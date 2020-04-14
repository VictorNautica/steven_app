library(shiny)

shinyUI(
    
    
    fluidPage(theme= "mystyle.css",

    # Application title
    titlePanel("A simple tool to support commissioners to determine if a risk prediction tool might work and save money before deployment"),

    # Sidebar
    sidebarLayout(
        div(class="sidebar", sidebarPanel(
            strong("Average cost (A) of adverse event to be avoided (£)"),
            splitLayout(numericInput("cost_lower", "Lower Limit", value = 1800, min = 0,
                         max = Inf, step = 10),
            numericInput("cost_upper", "Upper Limit", value = 2200, min = 0,
                         max = Inf, step = 10)),
            strong("Positive predictive value (PPV) of the risk prediction tool (%)"),
            splitLayout(numericInput("ppv_lower", "Lower Limit", value = 34, min = 0, max = 100, step = 1),
            numericInput("ppv_upper", "Upper Limit", value = 38, min = 0, max = 100, step = 1)),
            strong("Number of people needed to treat (NNT) with the upstream intervention, to avoid one adverse event"),
            splitLayout(numericInput("nnt_lower", "Lower Limit", value = 16, min = 0,
                         max = 1000, step = 1),
                        numericInput("nnt_upper", "Upper Limit", value = 20, min = 0,
                                     max = 1000, step = 1)),
            tags$br(),
            "This app allows you to model different worked examples based on the design-stage evaluation framework in the paper.",
            tags$br(),tags$br(),
            "Based on the illustrated example in the paper, with a PPV of 36%, out of a patient sub-population of 100 patients, 36 would be identified to experience an unplanned admission or incident of interest. To avoid one adverse event, we would need to treat 18 patients (NNT). So, out of 36 patients identified, the intervention would prevent two adverse events from happening.",
            tags$br(),tags$br(),
            "Thus, based on an average cost for an intervention, in order for cost-savings to be possible, the maximum cost of the upstream intervention is: A * PPV/NNT.",
            tags$br(),tags$br(),
            "To incorporate uncertainity, we allow you to select minimum and maximum parameters for a uniform distribution for the three variables. Each number between these two parameters has an equal chance of being selected. This example uses Monte Carlo simulation over 1000 iterations.",
            tags$br(),tags$br(),
            "Figures in brackets represent lower and upper 10% quantile intervals (80% interval around the median) over the 1000 iterations.",
            tags$br(),tags$br(),
            "For any technical queries please contact victor.yu@nhs.net" 
        ),
        ),

        # Show a plot
        mainPanel(
            plotOutput("myplot", height = "800")
        )
    )
))
