library(shiny)

# Define UI
ui <- fluidPage(
  titlePanel("SquaresFind"),
  
  sidebarLayout(
    sidebarPanel(
      numericInput("number", "Enter a Number:", value = 1),
      actionButton("submit", "Calculate Square")
    ),
    
    mainPanel(
      textOutput("result")
    )
  )
)

# Define Server
server <- function(input, output) {
  observeEvent(input$submit, {
    output$result <- renderText({
      paste("The square of", input$number, "is", input$number^2)
    })
  })
}

# Run the application
shinyApp(ui = ui, server = server);
