#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(tidymodels)
library(tidyverse)

# setwd(here::here("car_price_prediction"))

model <- read_rds("final_lasso_model.rds")

# df_test <- read_rds("data/test_df.rds")

# test_ob <- df_test %>% 
#   slice_sample(n = 1)

# predict(model, test_ob %>% select(-price))

# test_ob

# make_model_ops <- df_small %>%
#   count(make_model, sort = T) %>% 
#   head(50) %>% 
#   pull(make_model)

# setwd(here::here("car_price_prediction"))

# Define UI for application that draws a histogram
ui <- fluidPage(

  # Application title
  titlePanel("Car price prediction"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      valueBoxOutput("car_price_prediction")
    ),

    # Show a plot of the generated distribution
    mainPanel(
      fluidRow(
        column(
          width = 6,
          selectizeInput("make_model_in",
            "Make and model",
            choices = make_model_ops,
            selected = "Volkswagen Polo"
          ),
          selectizeInput("seller_type_in",
            "Seller type",
            choices = c(
              "Private or unregistered dealer",
              "Professional Seller"
            ),
            selected = "Private or unregistered dealer"
          ),
          selectizeInput("province_in",
            "Province",
            choices = c("Eastern Cape", "Free State", "Gauteng", "Kwazulu-Natal", "Limpopo", "Mpumalanga", "North West", "Northern Cape", "Western Cape"),
            selected = "Western Cape"
          ),
          selectizeInput("colour_in",
            "Colour",
            choices = c("Black", "Blue", "Brown", "Burgundy", "Gold", "Green", "Grey", "Orange", "Other", "Pink", "Purple", "Red", "Silver", "Tan", "Teal", "White", "Yellow"),
            selected = "White"
          ),
          selectizeInput("body_type_in",
            "Body type",
            choices = c("Hatchback", "SUV", "Sedan", "Double Cab", "Single Cab", "MPV/Bus")
          ),
          selectizeInput("transmission_in",
            "Transmission",
            choices = c("Automatic", "Manual"),
            selected = "Manual"
          ),
          selectizeInput("fuel_type_in",
            "Fuel type",
            choices = c("Petrol", "Diesel", "Electric", "Hybrid"),
            selected = "Petrol"
          )
        ),
        column(
          width = 6,
          sliderInput("year_in",
            "Year of production",
            min = 1980,
            max = 2022,
            value = 2010,
            sep = ""),
          sliderInput("km_in",
                      "Kilometers",
                      min = 0,
                      max = 300000,
                      value = 30000,
                      step = 50),
          sliderInput("n_photos_in",
                      "Number of photos",
                      min = 1,
                      max = 12,
                      value = 12)
        )
      )
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$car_price_prediction <- renderValueBox({
      prediction <- predict(model, 
      tibble('title' = "Title",
             'make_model' = input$make_model_in,
             'seller_type' = input$seller_type_in, 
             'province' = input$province_in, 
             'kilometers' = input$km_in,
             'colour' = input$colour_in,
             'year' = input$year_in,
             'n_photos' = input$n_photos_in,
             'body_type' = input$body_type_in,
             'fuel_type' = input$fuel_type_in,
             'transmission' = input$transmission_in))
      
      prediction <- prediction %>% 
        mutate(.pred = exp(.pred),
               .pred = round(.pred, -3),
               .pred = scales::number(.pred, prefix = "R")) %>% 
        pull(.pred)
      
      valueBox(
        value = prediction,
        subtitle = "Predicted price",
        color = "aqua")
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
