#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("A simple tool to support commissioners to determine if a risk prediction tool might work and save money before deployment"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            numericInput("cost", "Cost of adverse event to be avoided (£)", value = NA, min = 0,
                         max = Inf, step = 0.01),
            numericInput("ppv", "Positive predictive value of the risk prediction tool (%)", value = NA, min = 0,
                         max = 100, step = 0.01),
            numericInput("no_ppl_treat", "Number of people needed to treat with the upstream intervention, to avoid one adverse event", value = NA, min = 0,
                         max = 1000, step = 1)
        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("myplot"),
            verbatimTextOutput("max_cost")
        )
    )
))
