library(shiny)
library(dplyr)
library(sf)
library(ggplot2)

map_data <- readRDS("county_polygons.RData")
us_cancer_incidence_county_long <- read.csv("shiny_app_cancer_data.csv")

# Merge the map geometry with the cancer incidence data
map_data <- merge(map_data,
                  us_cancer_incidence_county_long,
                  by = "FIPS",
                  all.x = TRUE)

race_ethnicity_vec <- na.omit(unique(map_data$RE))
sex_vec <- na.omit(unique(map_data$Sex))
cancer_site_vec <- na.omit(unique(map_data$cancer_site))

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Cancer Incidence Rates App"),
    fluidRow(
      column(4,
             wellPanel(
               fluidRow(uiOutput("race_ethnicity")),
               fluidRow(uiOutput("sex")),
               fluidRow(uiOutput("cancer_site"))
             )
             ),
      column(8,
             wellPanel(plotOutput("map"))
             )
    )
)

server <- function(input, output) {

    output$race_ethnicity <- renderUI({
      selectInput(
        inputId = "race_ethnicity",           
        label = "Select race/ethnicity",
        choices = race_ethnicity_vec,
        selected = "All",            
        multiple = FALSE           
      )
    })
    
    output$sex <- renderUI({
      selectInput(
        inputId = "sex",           
        label = "Select Sex",
        choices = sex_vec,
        selected = "All",            
        multiple = FALSE           
      )
    })
    
    output$cancer_site <- renderUI({
      selectInput(
        inputId = "cancer_site",           
        label = "Select Cancer Site",
        choices = cancer_site_vec,
        selected = "All Site",            
        multiple = FALSE           
      )
    })

    
    output$map <- renderPlot({
      
      shiny::req(input$race_ethnicity)
      shiny::req(input$sex)
      shiny::req(input$cancer_site)
      
      map_data_filt <- map_data |>
        dplyr::filter(RE == input$race_ethnicity,
                      Sex == input$sex,
                      cancer_site == input$cancer_site)
      
      
      
      validate(
        need(nrow(map_data) > 0, 
             "No data for current selection")
      )
      
      ggplot(data = map_data_filt) +
        geom_sf(aes(fill = age_adjusted_rate), size = 0.05) +
        scale_fill_viridis_c(option = "plasma", na.value = "grey90") +
        coord_sf() +
        theme_minimal() +
        ggtitle("Cancer Incidence Age Adjusted Rate")
      
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
