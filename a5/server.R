#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(ggplot2)
library(dplyr)
library(plotly)

co2_data <- read.csv('owid-co2-data.csv')


recent_co2_data <- co2_data %>% 
  group_by(country) %>% 
  filter(year == max(year, na.rm = T))
average_co2_coal <- round(mean(recent_co2_data$coal_co2, na.rm = T), digits = 2)
average_co2_coal_per_capita <- round(mean(recent_co2_data$coal_co2_per_capita, na.rm =T), digits = 3)

the_most_country_coal <- co2_data %>%
  filter(year == max(year, na.rm = T)) %>% 
  filter(!(country == 'World' | country == 'Asia' | country == "Upper-middle-income countries")) %>% 
  filter(coal_co2 == max(coal_co2, na.rm = T)) %>% 
  select(country)

the_most_country_oil <- co2_data %>% 
  filter(year == max(year, na.rm = T)) %>% 
  filter(!(country == 'World' | country == 'Asia' | country == "Upper-middle-income countries")) %>% 
  filter(oil_co2 == max(oil_co2, na.rm = T)) %>% 
  select(country)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$averagecoal <- renderText({
      text <- paste('The average CO2 emisson came from coal is ', average_co2_coal, ' million tonnes.')
      return(text)
    })
    
    output$averagecoalpercapita <- renderText({
      text <- paste('The average CO2 emission per capita came from coal is ', average_co2_coal_per_capita, ' tonnes.')
      return(text)
    })
    
    output$themostcoalcountry <- renderText({
      text <- paste('The country with most CO2 emission from coal is', the_most_country_coal, '.')
      return(text)
    })
    
    output$themostoilcountries <- renderText({
      text <- paste(the_most_country_oil, 'have the highest CO2 emission comes from oil which is not surprising because high incomes countries can afford cars or other transportation.')
      return(text)
    })
    
    output$selector <- renderUI({
      selectInput('select', 'Choose a Country', choices = unique(co2_data$country))
    })
    
    output$slider <- renderUI({
      sliderInput('slider', 'Choose a year Range', min = 1850, max = 2021, value = c(1870, 1914))
    })
    
    interactiveplot <- reactive({
      plotData <- co2_data %>% 
        filter(country == input$select) %>% 
        filter(year >= input$slider[1]) %>%
        filter(year <= input$slider[2]) %>% 
        select(year, coal_co2, oil_co2, cement_co2, gas_co2)
      ggplot(plotData, aes(x = year))+
        geom_line(aes(y = coal_co2, colour = "coal"))+
        geom_line(aes(y = oil_co2, colour = "oil"))+
        geom_line(aes(y = cement_co2, colour = "cement"))+
        geom_line(aes(y = gas_co2, colour = 'gas'))+
        scale_color_manual(name = "Source",
                           labels = c('Coal', 'Oil', 'Cement', 'Gas'),
                           values = c('green', 'red', 'yellow', 'blue'))+
        labs(x = "Year",
             y = "The Co2 Emssion million tonnes",
             title = paste('The CO2 Emission of different source of', input$select, 'between', input$slider[1], 'and', input$slider[2]))
    })
    
    output$countryPlot <- renderPlotly({
      interactiveplot()
    })

})
