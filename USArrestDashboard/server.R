## Shiny Server component for dashboard

function(input, output, session){
  
  # Data table Output
  output$dataT <- renderDataTable(my_data)

  
  # Rendering the box header  
  output$head1 <- renderText(
    paste("5 states with high", input$var2, "Arrests")
  )
  
  # Rendering the box header 
  output$head2 <- renderText(
    paste("5 states with low", input$var2, "Arrests")
  )
  
  
  # Rendering table with 5 states with high arrests for specific crime type
  output$top5 <- renderTable({
    
    my_data %>% 
      gather(Crime, Value, -state, -UrbanPop) %>% 
      filter(Crime==input$var2) %>% 
      group_by(state) %>% 
      summarise(Count=sum(Value)) %>% 
      arrange(desc(Count)) %>% 
      head(5)
    
  })
  
  # Rendering table with 5 states with low arrests for specific crime type
  output$low5 <- renderTable({
    
    my_data %>% 
      gather(Crime, Value, -state, -UrbanPop) %>% 
      filter(Crime==input$var2) %>% 
      group_by(state) %>% 
      summarise(Count=sum(Value)) %>% 
      arrange(Count) %>% 
      head(5)
    
  })
  
  
  # For Structure output
  output$structure <- renderPrint({
    my_data %>% 
      str()
  })
  
  
  # For Summary Output
  output$summary <- renderPrint({
    my_data %>% 
      summary()
  })
  
  # For histogram - distribution charts
  output$histplot <- renderPlotly({
    p1 = my_data %>% 
      plot_ly() %>% 
      add_histogram(x=~get(input$var1)) %>% 
      layout(xaxis = list(title = paste(input$var1)))
    
    
    p2 = my_data %>%
      plot_ly() %>%
      add_boxplot(x=~get(input$var1)) %>% 
      layout(yaxis = list(showticklabels = F))
    
    # stacking the plots on top of each other
    subplot(p2, p1, nrows = 2, shareX = TRUE) %>%
      hide_legend() %>% 
      layout(title = "Distribution chart - Histogram and Boxplot",
             yaxis = list(title="Frequency"))
  })
  
  
  ### Bar Charts - State wise trend
  output$bar <- renderPlotly({
    my_data %>% 
      plot_ly() %>% 
      add_bars(x=~state, y=~get(input$var2)) %>% 
      layout(title = paste("Statewise Arrests for", input$var2),
             xaxis = list(title = "State"),
             yaxis = list(title = paste("No. of Arrests per 100,000 residents for", input$var2) ))
  })
  
  
  ### Scatter Charts 
  output$scatter <- renderPlotly({
    p = my_data %>% 
      ggplot(aes(x=UrbanPop, y=get(input$var3))) +
      geom_point() +
      geom_smooth(method=lm) +
      labs(title = paste("Relation b/w", input$var3 , "Arrests and Urban Population"),
           x = "Urban Population",
           y = input$var3) +
      theme(  plot.title = element_textbox_simple(size=10,
                                                  halign=0.5))
      
    
    # applied ggplot to make it interactive
    ggplotly(p)
    
  })
  
  
  ## Correlation plot
  output$cor <- renderPlotly({
    my_df <- my_data %>% 
      select(-state)
    # Compute a correlation matrix
    corr <- round(cor(my_df), 1)
    
    # Compute a matrix of correlation p-values
    p.mat <- cor_pmat(my_df)
    
    corr.plot <- ggcorrplot(
      corr, hc.order = TRUE, outline.col = "white",
      p.mat = p.mat
    )
    
    ggplotly(corr.plot)
  })
  
  
    # Choropleth map
  output$map_plot <- renderPlot({
    
    
    new_join %>% 
      ggplot(aes(x=long, y=lat,fill=get(input$crimetype) , group = group)) +
      geom_polygon(color="black", size=0.4) +
      scale_fill_gradient(low="#73A5C6", high="#001B3A", name = paste(input$crimetype, "Arrests")) +
      theme_void() +
      labs(title = paste("Choropleth map of", input$crimetype , " Arrests by state in 1973")) +
      theme(
        plot.title = element_textbox_simple(face="bold", 
                                            size=20,
                                            halign=0.5),
        
        legend.position = c(0.2, 0.1),
        legend.direction = "horizontal"
        
      ) +
      geom_text(aes(x=x, y=y, label=abb), size = 4, color="white")
    
    
 
  })
  
  
  
}

