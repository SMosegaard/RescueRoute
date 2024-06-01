# RescueRoute
# Sofie Mosegaard


####### Load packages #######

pacman::p_load(tidyverse, shiny, leaflet, mapboxapi, sf, fontawesome, waiter)


####### Insert Mapbox token #######

token <- "MY_TOKEN"


####### Load data #######

all_bases <- read_csv("../data/all_bases.csv")
all_hospitals <- read_csv("../data/all_hospitals.csv")


####### Convert data to sf objects #######

all_bases_sf <- st_as_sf(all_bases, coords = c("oc_lng", "oc_lat"),
                         crs = 4326)
all_hospitals_sf <- st_as_sf(all_hospitals, coords = c("oc_lng", "oc_lat"),
                             crs = 4326)


####### Predefine variables ####### 

icons <- awesomeIconList(
  "Ambulance" = makeAwesomeIcon(
    icon = "ambulance",
    markerColor = "blue",
    iconColor = "white",
    library = "fa"
  ),
  "Hospital" = makeAwesomeIcon( 
    icon = "h-square",
    markerColor = "red",
    iconColor = "white",
    library = "fa"
  )
)

#fa-h-square
#fa-ambulance

# Define text and spinner for waiting screen
text_for_waiting_screen <- data.frame(text = "RescueRoute") 

waiting_screen <- tagList(h3(text_for_waiting_screen,
                             style = "color:#FFFFFF;font-weight: 50;font-family: 'Helvetica Neue', Helvetica;font-size: 30px;"))


####### Define UI #######

ui <- fluidPage(
  
  # Initialize waiter
  useWaiter(),
  
  # App title
  titlePanel(
    div("RescueRoute",
      style = "font-size: 22px; font-weight: bold; text-align: center;"
    )
  ),
  
  # Main layout with sidebar and map
  fluidRow(
    column(
      width = 3,
      # Sidebar content
      sidebarPanel(
        
        # Welcome text
        helpText(h4("Welcome to RescueRoute!"),
                 "This app will identify your nearest hospital and suggest the optimal route for an ambulance."),
        
        # Box for user input (User-specified address)
        textInput("address_text",
                  label = "Please specify your address:",
                  placeholder = " ",
                  width = "100%"),
        actionButton("action", "Estimate rescue routes",
                     style = "font-size: 13px; width: 100%; display: flex; justify-content: center; align-items: center;"),
        
        htmlOutput("instructions"),
        width = 15 # Full width of the column
      ) 
    ), 
    column(
      width = 9,
      # Main panel - map output
      leafletOutput(outputId = 'map', width = "100%", height = "750px")
    )
  )
)




####### Define server #######


server <- function(input, output) {
  
  # Waiting screen
  waiter_show(html = waiting_screen)
  Sys.sleep(4) # displays the waiting screen for4  seconds
  waiter_hide()
  
  
  ambulance_instructions <- reactiveVal(NULL)
  hospital_instructions <- reactiveVal(NULL)

  
  output$map <- renderLeaflet({
    leaflet() %>%
      addMapboxTiles(style_id = "satellite-streets-v11", username = "mapbox", access_token = token) %>%
      addAwesomeMarkers(data = all_bases_sf, icon = ~icons["Ambulance"], popup = ~paste("Ambulance Base:", placename)) %>%
      addAwesomeMarkers(data = all_hospitals_sf, icon = ~icons["Hospital"], popup = ~paste("Hospital:", placename))
  })
  

  
  observeEvent(input$action, {
    req(input$address_text)
    
    input_sf <- tryCatch({
      mb_geocode(input$address_text, output = "sf", access_token = token)
    }, error = function(e) {
      showNotification("Geocoding failed. Please check the address and try again.", type = "error")
      return(NULL)
    })
    
    if (is.null(input_sf)) return()
    
    st_crs(input_sf) <- 4326
    
    distances_bases <- st_distance(input_sf, all_bases_sf)
    nearest_base_index <- which.min(distances_bases)
    nearest_base <- all_bases_sf[nearest_base_index, ]
    
    distances_hospitals <- st_distance(input_sf, all_hospitals_sf)
    nearest_hospital_index <- which.min(distances_hospitals)
    nearest_hospital <- all_hospitals_sf[nearest_hospital_index, ]
    
    route_to_user <- tryCatch({
      mb_directions(
        origin = st_coordinates(nearest_base),
        destination = st_coordinates(input_sf),
        profile = "driving",
        output = "sf",
        steps = TRUE,
        access_token = token
      )
    }, error = function(e) {
      showNotification("Failed to get directions to the user.", type = "error")
      return(NULL)
    })
    
    route_to_hospital <- tryCatch({
      mb_directions(
        origin = st_coordinates(input_sf),
        destination = st_coordinates(nearest_hospital),
        profile = "driving",
        output = "sf",
        steps = TRUE,
        access_token = token
      )
    }, error = function(e) {
      showNotification("Failed to get directions to the hospital.", type = "error")
      return(NULL)
    })
    
    
    if (!is.null(route_to_user) && !is.null(route_to_hospital)) {
      # Calculate estimated drive time based on distance and constant speed of 50 km/h
      # drive-time in minutes
      est_drive_time_user <- round(distances_bases[nearest_base_index] / 1000 / 50 * 60)
      est_drive_time_hospital <- round(distances_hospitals[nearest_hospital_index] / 1000 / 50 * 60)
      
      ambulance_instructions(paste("Your nearest ambulance base is", all_bases$oc_formatted[nearest_base_index], ".<br/>",
                                   "<br/>Estimated drive time:", round(est_drive_time_user, 2), "minutes.<br/>",
                                   "<br/>Instructions:", paste(route_to_user$instruction, collapse = "<br/>")))
      
      hospital_instructions(paste("Your nearest hospital is", all_hospitals$oc_formatted[nearest_hospital_index], ".<br/>",
                                  "<br/>Estimated drive time:", round(est_drive_time_hospital, 2), "minutes.<br/>",
                                  "<br/>Instructions:", paste(route_to_hospital$instruction, collapse = "<br/>")))
      
      leafletProxy("map") %>%
        clearShapes() %>%
        addPolylines(data = route_to_user, color = "blue", opacity = 1, weight = 4, group = "Route to User") %>%
        addPolylines(data = route_to_hospital, color = "red", opacity = 1, weight = 4, group = "Route to Hospital") %>%
        addCircleMarkers(data = all_bases_sf, color = "blue", radius = 5, popup = ~paste("Ambulance Base:", placename)) %>%
        flyTo(lng = st_coordinates(nearest_base)[1], lat = st_coordinates(nearest_base)[2], zoom = 12)
    }
  })
  
  output$instructions <- renderUI({
    if (!is.null(ambulance_instructions()) && !is.null(hospital_instructions())) {
      HTML(paste("<b>Route to Ambulance Base:</b><br/>", ambulance_instructions(), "<br/><br/>",
                 "<b>Route to Hospital:</b><br/>", hospital_instructions()))
    }
  })
}

####### Run #######

shinyApp(ui = ui, server = server)


