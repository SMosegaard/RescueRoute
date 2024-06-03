# RescueRoute

## 1. The RescueRoute Application

This repository contains the exam project in the course 'Spatial Analytics' for the elective 'Cultural Data Science' at Aarhus University. Specifically, it contains the [RescueRoute application](https://sofiemosegaard.shinyapps.io/RescueRoute/).

RescueRoute is an interactive map that effectively identifies the nearest hospital to a user-specified address and suggest the optimal route for an ambulance. The application aims to highlight accessibility of medical care in Denmark.

<div align = "center">

![Alt Text](https://github.com/SMosegaard/RescueRoute/blob/main/app/RescueRoute-recording.gif)

</div>

The app has a monthly restriction of 25 hours of use and a maximum of one user at a time. If you experience any challenges with the app, don't hesitate to contact Sofie Mosegaard on 202106512@post.au.dk. 

## 2. Repository Structure

The repository consists of the following elements:

|Folder name|Description|Content|
|---|---|---|
|analysis|data preparation, preprocessing, and risk assesment analysis |```spatial_analysis.Rmd```, ```Visualizaitions```|
|app|the RescueRoute application|```app.R```, ```RescueRoute-recording.gif```|
|data|datasets in .csv and .rsd format, as well as saved isochrones|```all_bases.csv```, ```all_hospitals.csv```, ```all_hospitals_before.csv```, ```municipalitied.rsd```|

## 3. Reproducibility 

To run the code in this repository, both the spatial analysis and the application, on your local machine, please follow the steps. Note, that the code was produced and tested on a Lenovo with Windows operating system. 

### 3.1 Prerequisites

Ensure that R (>= 4.2.0) and RStudio are installed before executing the code locally.

### 3.2. Getting Started

Clone the repository by pasting the following command into your terminal:
```python
$ git clone "https://github.com/SMosegaard/RescueRoute.git"
```
Navigate into the 'RescueRoute' folder:
```python
$ cd RescueRoute.git
```

...

## License

The project is licensed under the MIT License.

## Contact

For further questions, please contact Sofie Mosegaard at 202106512@post.au.dk.