library(shiny)
library(tidyverse)
library(patchwork)

options(scipen = 999)

shinyServer(function(input, output) {

    output$myplot <- renderPlot({
        

    this_shiny_ggplot_function()

    })
    
    # output$max_cost <- renderPrint({
    #     (input$cost*(input$ppv/100))/input$no_ppl_treat
    # })
    
    ## Simulations ####
    

    this_shiny_ggplot_function <- function() {
        
        nsims <- 1000
        
        ppvlower <- reactive({
            req(input$ppv_lower)
            input$ppv_lower
        })
        
        ppvupper <- reactive({
            req(input$ppv_upper)
            input$ppv_upper
        })
        
        nntlower <- reactive({
            req(input$nnt_lower)
            input$nnt_lower
        })
        
        nntupper <- reactive({
            req(input$nnt_upper)
            input$nnt_upper
        })
        
        costlower <- reactive({
            req(input$cost_lower)
            input$cost_lower
        })
        
        costupper <- reactive({
            req(input$cost_upper)
            input$cost_upper
        })
        
        s_ppv <-
            replicate(nsims, runif(1, ppvlower() / 100, ppvupper() / 100))
        s_nnt <-
            replicate(nsims, runif(1, nntlower(), nntupper()))
        s_a <-
            replicate(nsims, runif(1, costlower(), costupper()))
        s_i <- (s_a * s_ppv) / s_nnt
        
        
        df <- tibble(s_ppv = s_ppv, 
                     s_nnt = s_nnt, 
                     s_a = s_a, 
                     s_i = s_i)
        
        p10 <- round(quantile(df$s_i, 0.1), 2)
        p50 <- round(quantile(df$s_i, 0.5), 2)
        p90 <- round(quantile(df$s_i, 0.9), 2)
        
        pointplot <- ggplot() + 
        geom_point(aes(x = sum(nntlower()+nntupper())/2, y = (sum(ppvlower()+ppvupper())/2)/100),
                   size = 33,
                   colour = "white",
                   alpha = 0.5) +
        geom_text(aes(
            x = sum(nntlower()+nntupper())/2,
            y = ((sum(ppvlower()+ppvupper())/2)/100),
            label = paste0("£",p50)),
            size = 5) +
        geom_text(aes(
            x = sum(nntlower()+nntupper())/2,
            y = ((sum(ppvlower()+ppvupper())/2)/100)+0.05,
            label = paste0("(£",p10,")")),
            size = 3.5) +
        geom_text(aes(
            x = sum(nntlower()+nntupper())/2,
            y = ((sum(ppvlower()+ppvupper())/2)/100)-0.05,
            label = paste0("(£",p90,")")),
            size = 3.5) +
        scale_x_log10(limits = c(1, 1000),
                      breaks = c(0, 1, 10, 100, 1000)) +
        scale_y_continuous(limit = c(0,1),
                           labels = scales::percent_format(accuracy = 1)) +
        labs(x = "NNT", y = "PPV", title = "Maximum Cost of Intervention for Cost-Savings")
        
        cumhist <- 
            ggplot(NULL,aes(s_i)) + 
            geom_histogram(aes(y=cumsum(..count..)), colour = "black", alpha = 0) +
            # stat_bin(aes(y=cumsum(..count..)),geom="line", color="red", size = 2) +
            labs(x = "Cost of Intervention (£)",
                 y = "Cumulative Draws Frequency",
                 title = "Cumulative Histogram")
        
        basichist <- 
            ggplot(df, aes(x=s_i)) +
            geom_histogram(colour = "black", alpha = 0) +
            labs(y = "Draws Frequency",
                 x = "Cost of Intervention (£)",
                 title = "Histogram")
        
        pointplot / (basichist | cumhist )
        
    }
    
    

})
