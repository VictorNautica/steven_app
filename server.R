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
        

    this_shiny_ggplot_function(nntlower = input$nnt_lower, 
                               nntupper = input$nnt_upper, 
                               ppvlower = input$ppv_lower, 
                               ppvupper = input$ppv_upper)

    })
    
    # output$max_cost <- renderPrint({
    #     (input$cost*(input$ppv/100))/input$no_ppl_treat
    # })
    
    ## Simulations ####
    

    this_shiny_ggplot_function <- function(nntlower, nntupper, ppvlower, ppvupper) {
        
        nsims <- 1000
        
        
        s_ppv <-
            replicate(nsims, runif(1, input$ppv_lower / 100, input$ppv_upper / 100))
        s_nnt <-
            replicate(nsims, runif(1, input$nnt_lower, input$nnt_upper))
        s_a <-
            replicate(nsims, runif(1, input$cost_lower, input$cost_upper))
        s_i <- (s_a * s_ppv) / s_nnt
        
        
        df <- tibble(s_ppv = s_ppv, 
                     s_nnt = s_nnt, 
                     s_a = s_a, 
                     s_i = s_i)
        
        p10 <- round(round(quantile(df$s_i, 0.1), 2))
        p50 <- round(round(quantile(df$s_i, 0.5), 2))
        p90 <- round(round(quantile(df$s_i, 0.9), 2))
        
        ggplot() + 
        geom_point(aes(x = sum(nntlower+nntupper)/2, y = (sum(ppvlower+ppvupper)/2)/100),
                   size = 33,
                   colour = "white",
                   alpha = 0.5) +
        geom_text(aes(
            x = sum(nntlower+nntupper)/2,
            y = ((sum(ppvlower+ppvupper)/2)/100),
            label = paste0("£",p50)),
            size = 5) +
        geom_text(aes(
            x = sum(nntlower+nntupper)/2,
            y = ((sum(ppvlower+ppvupper)/2)/100)+0.05,
            label = paste0("(£",p10,")")),
            size = 3.5) +
        geom_text(aes(
            x = sum(nntlower+nntupper)/2,
            y = ((sum(ppvlower+ppvupper)/2)/100)-0.05,
            label = paste0("(£",p90,")")),
            size = 3.5) +
        scale_x_log10(limits = c(1, 1000),
                      breaks = c(0, 1, 10, 100, 1000)) +
        scale_y_continuous(limit = c(0,1),
                           labels = scales::percent_format(accuracy = 1)) +
        labs(x = "NNT", y = "PPV", title = "Maximum Cost of Intervention for Cost-Savings")
        
    }
    
    

})
