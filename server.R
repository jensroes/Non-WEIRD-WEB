server <- function(input, output, session) {
  
  source("environment.R")
  
  output$mobile_plot <- renderPlot({
      data %>% filter(country %in% input$country, vars %in% input$vars) %>%
        ggplot(aes(y = value, x = reorder(country, value), fill = highlight )) +
        geom_col(show.legend = F, width = .25) +
      #  scale_y_continuous(labels = scales::percent, limits = c(0,1)) +
        scale_fill_manual(values = c("grey70", "darkred")) +
        labs(caption = "Source: World Bank", x = "", y = "") +
   #     theme(axis.text.y = element_text(size = 8)) +
        facet_wrap(~vars, scales = "free") +
        coord_flip() 
  })
  
  output$timecourse <- renderPlot({
    data_time %>% filter(country %in% input$country, vars %in% input$vars) %>%
      group_by(country, vars) %>%
      mutate(n = length(unique(year)),
             country_lab = if_else(year == max(year) & value == max(value), country, "")) %>%
      filter(n > 1) %>%
      ggplot(aes(y = value, x = year, colour = country, label = country_lab )) +
      geom_line(show.legend = F) +
      geom_text(show.legend = F) +
      #  scale_y_continuous(labels = scales::percent, limits = c(0,1)) +
      scale_fill_manual(values = c("grey70", "darkred")) +
      scale_colour_colorblind() +
      scale_x_continuous(breaks = seq(2000, 2030, 1)) +
      labs(caption = "Source: World Bank", x = "", y = "") +
      #     theme(axis.text.y = element_text(size = 8)) +
      facet_wrap(~vars, scales = "free", ncol = 2, shrink = T) 
  })
  
  output$map <- renderPlot({
    coord <- ne_countries(returnclass = "sf") 
    left_join(
      coord,
      data,
      c("iso_a2" = "iso2c")) %>%
      filter(country %in% input$country, vars %in% input$vars) %>%
      drop_na(vars) %>%
      ggplot(aes(fill = value)) +
      geom_sf() +
      scale_fill_viridis_c() +
      facet_wrap(~vars, ncol = 3) +
      theme(legend.position="bottom",
            axis.text = element_blank()) 
    
    
  })
  
  data_summary <- reactive({
    data_summary <- data %>%
        filter(country %in% input$country, vars %in% input$vars) %>%
        mutate_if(is.double, round, 2) %>%
        arrange(desc(value)) %>%
        select(-highlight,-iso2c) %>%
        pivot_wider(names_from = country, values_from = value) %>%
        select(Indicator = vars, Status = year, everything()) 
    
    data_summary
  })
  
  
  output$summary <- renderDataTable({
    datatable(data_summary(), 
              rownames = F,
              options = list(dom = "t", autoWidth = F,
                             initComplete = JS(
                               "function(settings, json) {",
                               "$(this.api().table().header()).css({'background-color': '#000', 'color': '#fff'});",
                               "}") )) })
  
       
  # Downloadable csv of dataset 
  output$downloadDesc <- downloadHandler(
    filename = function() {
      "nonweird_summary.csv"
    },
    content = function(file) {
      write_csv(data_summary(), file)
    }
  )
   
}



