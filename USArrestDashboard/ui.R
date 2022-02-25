## Shiny UI component for the Dashboard

dashboardPage(
  
  dashboardHeader(title="Exploring the 1973 US Arrests data with R Shiny Dashboard", titleWidth = 650, 
                  tags$li(class="dropdown",tags$a(href="https://www.youtube.com/playlist?list=PL6wLL_RojB5xNOhe2OTSd-DPkMLVY9DfB", icon("youtube"), "My Channel", target="_blank")),
                  tags$li(class="dropdown",tags$a(href="https://www.linkedin.com/in/abhinav-agrawal-pmp%C2%AE-itil%C2%AE-5720309/" ,icon("linkedin"), "My Profile", target="_blank")),
                  tags$li(class="dropdown",tags$a(href="https://github.com/aagarw30/R-Shinyapp-Tutorial", icon("github"), "Source Code", target="_blank"))
                  ),
  
  
  dashboardSidebar(
    sidebarMenu(id = "sidebar",
      menuItem("Dataset", tabName = "data", icon = icon("database")),
      menuItem("Visualization", tabName = "hist", icon=icon("chart-line")),
      
      # Conditional Panel for conditional widget appearance
      # Filter should appear only for the visualization menu and selected tabs within it
      conditionalPanel("input.sidebar == 'hist' && input.t2 == 'distro'", selectInput(inputId = "var1" , label ="Select the Variable" , choices = v1)),
      conditionalPanel("input.sidebar == 'hist' && input.t2 == 'trends' ", selectInput(inputId = "var2" , label ="Select the Arrest type" , choices = v2)),
      conditionalPanel("input.sidebar == 'hist' && input.t2 == 'relation' ", selectInput(inputId = "var3" , label ="Select the Arrest type" , choices = v2)),
      
      menuItem("Choropleth Map", tabName = "map", icon=icon("map"))
      
    )
  ),
  
  
  dashboardBody(
    
    tabItems(
      ## First tab item
      tabItem(tabName = "data", 
              tabBox(id="t1", width = 12, 
                tabPanel("About", icon=icon("address-card"),
                         fluidRow(column(width = 8, tags$img(src="crime.jpg"),
                                         tags$br() , 
                                         tags$a("Photo by Campbell Jensen on Unsplash") ,
                                         align = "center"),
                                  column(width = 4, 
                                         tags$p("This data set comes along with base R and contains statistics, in arrests per 100,000 residents for assault, murder, and rape in each of the 50 US states in 1973."),
                                         tags$br(),
                                         tags$p("Also, given is the percent of the population living in urban areas."),
                                         align = "left"))), 
                tabPanel("Data", dataTableOutput("dataT"), icon = icon("table")), 
                tabPanel("Structure", verbatimTextOutput("structure"), icon=icon("uncharted")),
                tabPanel("Summary Stats", verbatimTextOutput("summary"), icon=icon("chart-pie"))
              )
),  
    
# Second Tab Item
    tabItem(tabName = "hist", 
            tabBox(id="t2",  width=12, 
            tabPanel("Distribution", value="distro",
                     # selectInput("var", "Select the variable", choices=c("Rape", "Assault")),
                     plotlyOutput("histplot", height = "350px")),
            tabPanel("Correlation", id="corr" ,plotlyOutput("cor")),
            tabPanel("Crime Trends by State", value="trends",
                     fluidRow(tags$div(align="center", box(tableOutput("top5"), title = textOutput("head1") , collapsible = TRUE, status = "primary",  collapsed = TRUE, solidHeader = TRUE)),
                              tags$div(align="center", box(tableOutput("low5"), title = textOutput("head2") , collapsible = TRUE, status = "primary",  collapsed = TRUE, solidHeader = TRUE))
                              
                              ),
                     plotlyOutput("bar")
                     ),
            tabPanel("Relationship between Crime Type and Population", plotlyOutput("scatter"), value="relation"),
            side = "left"
                   ),
            
            ),

   
    # Third Tab Item
      tabItem(
      tabName = "map",
      selectInput("crimetype","Select Arrest Type", choices = v2, selected="Rape"),
      withSpinner(plotOutput("map_plot"))


      
    )

)
    )
  )

  
  
