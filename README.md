# RescueRoute

This repository contains the exam project in the course 'Spatial Analytics' for the elective 'Cultural Data Science' at Aarhus University. Specifically, it contains a preliminary risk assessment analysis and the [RescueRoute application](https://sofiemosegaard.shinyapps.io/RescueRoute/).

## 1. The RescueRoute Application

[RescueRoute](https://sofiemosegaard.shinyapps.io/RescueRoute/) is an interactive map that effectively identifies the nearest hospital to a user-specified address and suggest the emergency optimal route for an ambulance. The application aims to highlight accessibility of medical care in Denmark.

<div align = "center">

![Alt Text](https://github.com/SMosegaard/RescueRoute/blob/main/app/RescueRoute-recording.gif)

</div>

The app has a monthly restriction of 25 hours of use and a maximum of one user at a time. If you experience any challenges with the app, don't hesitate to contact Sofie Mosegaard on 202106512@post.au.dk. 

## 2. Repository Structure

This repository contains the following key components:

|Folder name|Description|Content|
|---|---|---|
|analysis|data preparation, preprocessing, and risk assesment analysis |`spatial_analysis.Rmd`, `Visualizaitions` folder|
|app|RescueRoute application and related files|`app.R`, `RescueRoute-recording.gif`, `data` folder|
|data|Datasets and isochrones|`all_bases.csv`, `all_hospitals.csv`, `all_hospitals_before.csv`, `municipalitied.rsd`, `isochrones` folder|

## 3. Reproducibility 

To execute the code in this repository, specifically the spatial analysis and the application, on your local machine, follow the steps below. The code has been tested on a Lenovo laptop with Windows 11.

### 3.1 Prerequisites

Ensure you have R (version 4.2.0 or higher) and RStudio installed.

### 3.2. Getting Started

Clone the repository using the following command in your terminal:
```python
$ git clone "https://github.com/SMosegaard/RescueRoute.git"
```
Then, navigate into the 'RescueRoute' folder:
```python
$ cd RescueRoute.git
```

### 3.3. Runing Scripts Locally

1. Open the ```spatial_analysis.Rmd``` file in the 'analysis' folder using RStudio. This file contains data preparation, preprocessing, and risk assessment analysis.
2. To execute the RescueRoute application, navigate to the 'app' folder and open ```app.R``` in RStudio. Running this script will automatically launch the app in a separate R window.

## License

The project is licensed under the MIT License.

## Contact

For further questions, please contact Sofie Mosegaard at 202106512@post.au.dk.