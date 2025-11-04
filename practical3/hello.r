# Load libraries
library(shiny)
library(dplyr)
library(vroom)

# Read data
sales <- vroom::vroom("saledata.csv", na = "")

# UI definition
ui <- fluidPage(
  titlePanel("Dashboard for Sales Data"),
  sidebarLayout(
    sidebarPanel(
      selectInput("territories", "Territories", choices = unique(sales$territories)),
      selectInput("Customers", "Customer", choices = sales$Customers)
    ),
    mainPanel(
      uiOutput("customer"),
      tableOutput("data")
    )
  )
)

# Server logic
server <- function(input, output, session) {

  territories <- reactive({
    req(input$territories)
    filter(sales, territories == input$territories)
  })

  customer <- reactive({
    req(input$Customers)
    filter(territories(), Customers == input$Customers)
  })

  output$customer <- renderUI({
    row <- customer()[1, ]
    tags$div(
      class = "well",
      tags$p(tags$strong("Name: "), row$fname, " ", row$lname),
      tags$p(tags$strong("Phone: "), row$contact),
      tags$p(tags$strong("Order: "), row$order)
    )
  })

  order <- reactive({
    req(input$order)
    customer() %>%
      filter(order == input$order) %>%
      arrange(OLNUMBER) %>%
      select(pline, qty, price, sales, status)
  })

  output$data <- renderTable(order())

  observeEvent(territories(), {
    updateSelectInput(
      session, "Customers",
      choices = unique(territories()$Customers),
      selected = character()
    )
  })

  observeEvent(customer(), {
    updateSelectInput(
      session, "order",
      choices = unique(customer()$order)
    )
  })
}

# Run the Shiny app
shinyApp(ui, server)
