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
shinyUI(
    
    
    fluidPage(theme= "mystyle.css",

    # Application title
    titlePanel("A simple tool to support commissioners to determine if a risk prediction tool might work and save money before deployment"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        div(class="sidebar", sidebarPanel(
            strong("Cost of adverse event to be avoided (£)"),
            splitLayout(numericInput("cost_lower", "Lower Limit", value = 1800, min = 0,
                         max = Inf, step = 10),
            numericInput("cost_upper", "Upper Limit", value = 2200, min = 0,
                         max = Inf, step = 10)),
            strong("Positive predictive value of the risk prediction tool (%)"),
            splitLayout(numericInput("ppv_lower", "Lower Limit", value = 34, min = 0, max = 100, step = 1),
            numericInput("ppv_upper", "Upper Limit", value = 36, min = 0, max = 100, step = 1)),
            strong("Number of people needed to treat with the upstream intervention, to avoid one adverse event"),
            splitLayout(numericInput("nnt_lower", "Lower Limit", value = 16, min = 0,
                         max = 1000, step = 1),
                        numericInput("nnt_upper", "Upper Limit", value = 20, min = 0,
                                     max = 1000, step = 1))
        )),

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("myplot")
        )
    ),
    
    "This example uses Monte Carlo simulation over 1000 iterations. Values are drawn from uniform distribution. Figures in brackets represent Lower and Upper 10% Quantile Intervals."
))
