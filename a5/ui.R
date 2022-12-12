#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    navbarPage(
      'Global CO2 Emission Project',
      tabPanel('Introduction',
               mainPanel(
                 img(src='emission.png', height = 300, width = 400),
                 h3('Background Story'),
                 p('I live at a small town upon the northern China. The winter there is very cold and misty because every household has the heater driven by coal. When the winter comes, the CO2 emission will increase dramatically. I remember we have to wear mask when we are outside. Since the Ukraine war begin, the oil price had went up. I also want to analyze the CO2 emission comes from oil comsumption.'),
                 h3('Variable of Interest'),
                 p('The variable interested are `coal_co2`, `coal_co2_per_capita`, and `oil_co2`'),
                 h3('Data Analysis'),
                 p('Based on the recent data of every researched countries, here are some facts:'),
                 textOutput('averagecoal'),
                 textOutput('averagecoalpercapita'),
                 textOutput('themostcoalcountry'),
                 textOutput('themostoilcountries')
               )
      ),
      
      tabPanel('Interactive Chart',
               sidebarPanel(
                 uiOutput('selector'),
                 uiOutput('slider'),
                 p('You can input a country you want to explore and drag the bar to get a year range. The default year range is 1870~1914, when the world was undergoing second industrial revolution that lead to a dramatic growth of factory and manufactory.')
               ),
               mainPanel(
                 plotlyOutput('countryPlot'),
                 p('This interactive line chart compare four substance as sources of CO2 emission. The viewer can have a clear understanding of which substance take the lead in with documented year.')
               ))
    )
))
