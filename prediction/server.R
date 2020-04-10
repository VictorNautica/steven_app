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

options(scipen = 999)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$myplot <- renderPlot({


        # draw plot
        ggplot() + 
            geom_point(aes(x = input$no_ppl_treat, y = input$ppv / 100),
                       size = 33,
                       colour = "white") +
            geom_text(aes(
                x = input$no_ppl_treat,
                y = input$ppv / 100,
                label = paste0("£",round((input$cost*(input$ppv/100))/input$no_ppl_treat, 2))
            ),
            size = 10) +
            scale_x_log10(limits = c(1, 1000),
                          breaks = c(0, 1, 10, 100, 1000)) +
            scale_y_continuous(limits = c(0, 1)) +
            labs(x = "NNT", y = "PPV", title = "Maximum Cost of Intervention")

    })
    
    output$max_cost <- renderPrint({
        (input$cost*(input$ppv/100))/input$no_ppl_treat
    })

})
