server <- function(input, output, session) {
  
  output$mobile_plot <- renderPlot({
      data %>% 
      filter(country %in% input$country, vars %in% input$vars) %>%
        ggplot(aes(y = value, x = reorder(country, value), fill = highlight )) +
        geom_col(show.legend = F, width = .25, alpha = 45) +
      #  scale_y_continuous(labels = scales::percent, limits = c(0,1)) +
        scale_fill_manual(values = c("grey70", "darkred")) +
        labs(caption = "Source: World Bank", x = "", y = "") +
   #     theme(axis.text.y = element_text(size = 8)) +
        facet_wrap(~vars, scales = "free", ncol = 2) +
        coord_flip() +
        theme(panel.grid = element_blank())
  }, height = 700, width = 920)
  
  output$timecourse <- renderPlot({
    data_time %>% filter(country %in% input$country, vars %in% input$vars) %>%
      group_by(country, vars) %>%
      mutate(n = length(unique(year)),
             maxyear = max(year),
             maxvalue = max(value),
             country_lab = if_else(year == maxyear & value == maxvalue, country, "")) %>%
      filter(n > 1) %>%
      ggplot(aes(y = value, x = year, colour = country, label = country_lab )) +
      geom_line(show.legend = T) +
      geom_text(aes(x = year-1), show.legend = F) +
      #  scale_y_continuous(labels = scales::percent, limits = c(0,1)) +
    #  scale_fill_manual(values = c("grey70", "darkred")) +
      scale_colour_colorblind("") +
      scale_x_continuous(breaks = seq(2000, 2030, 1)) +
      labs(caption = "Source: World Bank", x = "", y = "") +
      #     theme(axis.text.y = element_text(size = 8)) +
      facet_wrap(~vars, scales = "free", ncol = 2, shrink = T)  +
      theme(legend.position = "bottom",
            legend.justification = "right")
  }, height = 600, width = 920)
  
  output$map <- renderPlot({
    coord <- rnaturalearth::ne_countries(returnclass = "sf") 
    plot_data <- data %>% select(-year, -highlight) %>%
    left_join(coord, ., c("name" = "country")) %>% rename(country = name) %>%
      filter(country %in% input$country, vars %in% input$vars) %>%
    #  filter(country %in% "Philippines") %>%
      drop_na(vars) %>%
      mutate(is_perc = str_detect(vars, pattern = "%"), 
             vars = word_wrap(vars, 30))
    
    plot_data %>% filter(is_perc == TRUE) %>%
      ggplot(aes(fill = value)) +
      geom_sf() +
      scale_fill_viridis_c(direction = -1) +
      facet_grid(~vars) +
      labs(caption = "Source: World Bank") +
      theme(axis.text = element_blank(),
            panel.grid = element_blank(),
            legend.position = "right",
            legend.justification = "top",
            legend.direction = "vertical") #-> plot_perc_yes
  #  ggplotly(plot_perc_yes) %>% layout(height = 700, width = 1100)
    
  }) #
  
  
  output$map2 <- renderPlot({
    coord <- rnaturalearth::ne_countries(returnclass = "sf") 
    plot_data <- data %>% select(-year, -highlight) %>%
      left_join(coord, ., c("name" = "country")) %>% rename(country = name) %>%
      filter(country %in% input$country, vars %in% input$vars) %>%
      #      filter(country %in% "Philippines") %>%
      drop_na(vars) %>%
      mutate(is_perc = str_detect(vars, pattern = "%"),
             vars = word_wrap(vars, 30))
    
    no_perc_vars <- plot_data %>% filter(is_perc == FALSE) %>% 
      pull(vars) %>% unique()
    
    for(i in no_perc_vars){
      assign(paste0("plot_perc_no_", substr(i,1,5)),
             plot_data %>% filter(vars %in% i) %>%
               ggplot(aes(fill = value)) +
               geom_sf() +
               scale_fill_viridis_c(direction = -1) +
               facet_grid(~vars) +
               labs(caption = "Source: World Bank") +
               theme(axis.text = element_blank(),
                     panel.grid = element_blank(),
                     legend.position = "right",
                     legend.justification = "top",
                     legend.direction = "vertical"))
      #  ggplotly(p) %>% layout(height = 700, width = 1100) %>%
      #    print()
    }    
    
    plots <- ls(pattern = "plot_perc")
    
    cowplot::plot_grid(plotlist=mget(plots))
    
  })
  
  output$map_language <- renderPlot({
    coord <- rnaturalearth::ne_countries(returnclass = "sf") 
    language_data %>% 
      count(country) %>%
      left_join(coord, ., c("name" = "country")) %>% rename(country = name) %>%
      drop_na("n") %>%
      filter(country %in% input$country) %>%
      ggplot(aes(fill = n)) +
      geom_sf() +
      scale_fill_viridis_c(direction = -1) +
      labs(caption = "Source: Glottolog 4.3", fill = "No. of languages") +
      theme(axis.text = element_blank(),
            panel.grid = element_blank(),
            legend.position = "right",
            legend.justification = "top",
            legend.direction = "vertical")
  })

  output$no_of_langs <- renderPlot({
    language_data %>% 
      count(country, highlight) %>%
      filter(country %in% input$country) %>%
      ggplot(aes(y=n, x=reorder(country,n), fill = highlight, label = n )) +
      geom_col(show.legend = F, width = .25, alpha = .45) +
      geom_label(fill = "white") +
      #  scale_y_continuous(labels = scales::percent, limits = c(0,1)) +
      scale_fill_manual(values = c("grey70", "darkred")) +
      labs(caption = "Source: Glottolog 4.3", x = "", y = "") +
      coord_flip() +
      theme(panel.grid = element_blank())
  }, height = 500, width = 950)
  
  
  data_summary <- reactive({
    data_summary <- data %>%
        filter(country %in% input$country, vars %in% input$vars) %>%
        mutate_if(is.double, round, 2) %>%
        arrange(desc(value)) %>%
        select(-highlight,-iso3c) %>%
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



