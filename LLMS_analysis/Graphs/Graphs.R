  library(readr)
  library(dplyr)
  library(ggplot2)
  library(patchwork)
  
  papers <- data.frame(
    paper_number = c(1, 3, 4),
    paper_name = c(
      "managerial_leadership_Jordi_Cooper",
      "trust_promises_Ederer_Schneider",
      "under_reporting_Ling_Kale_Imas"
    )
  )
  
  
  # list of zeroshot and fewshot
  shot_types <- c(
    "0shot",
    "fewshot"
  )
  
  # lista de variables de medición
  metrics <- c(
    "accuracy",
    "cohen_kappa",
    "precision_0",
    "recall_0",
    "precision_1",
    "recall_1"
  )
  
  # lista temperaturas
  temperatures <- c(
    0,
    0.1,
    0.5,
    1,
    1.2
  )
  
  # lista llm
  llms <- c(
    "gpt",
    "gemini"
  )
  
  
  #cambiar directorio a "~/Documents/GitHub/LLMS_Project/LLMS_analysis/Results"
  setwd("~/Documents/GitHub/LLMS_Project/LLMS_analysis/Results")
  
  # la idea es iterar con llms/nombrepaper/shottype
  # acceder al csv, todos tienen la misma estructura: results_paper_1_temp0_modeuser_type0shot.csv 
  # la idea es itetar por temperatura para leer todas los csvs del shot en cuestion y de ahi ya te digo el proceso apra crear las graficas
  # iterar por metricas
  # en tag en el csv aparece la lista de tags que toca ir evaluando
  
  all_data <- list()
  
  
  for (llm in llms) {
    
    for (i in 1:nrow(papers)) {
      
      for (shot in shot_types) {
        
        paper_num <- papers$paper_number[i]
        paper_name <- papers$paper_name[i]
        
        folder_path <- file.path(llm, paper_name, shot)
        
        for (temp in temperatures) {
          
          
          file_name <- paste0(
            "results_paper_", paper_num,
            "_temp", temp,
            "_modeuser_type", shot,
            ".csv"
          )
          
          
          full_path <- file.path(folder_path, file_name)
          
          if (file.exists(full_path)) {
                
                df <- read_csv(full_path, na = c("", "NA"))
                
                #print full_path
                cat(full_path, "\n")
                
                
                df <- df %>%
                  mutate(
                    llm = llm,
                    paper = paper_num,
                    shot = shot,
                    temperature = temp
                  )
                
                all_data[[length(all_data)+1]] <- df
          }
        }
      }
    }
  }
  

head(all_data)

results_df <- bind_rows(all_data)

setwd("~/Documents/GitHub/LLMS_Project/LLMS_analysis/Graphs")

for(llm_name in llms){
  
  for (i in 1:nrow(papers)) {
    
    for(metric in metrics){
      
      paper_num <- papers$paper_number[i]
      
      df_llm <- results_df %>% 
        filter(llm == llm_name, shot == "0shot", paper_id == paper_num)
      
      p1 <- ggplot(df_llm,
                   aes(x = tag,
                       y = .data[[metric]],
                       fill = factor(temperature))) +
        geom_bar(stat="identity", position="dodge") +
        labs(
          title = paste("0-shot"),
          y = metric,
          fill = "Temperature"
        ) +
        theme_classic() +
        scale_fill_brewer(palette = "Set2") +
        theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))
      
      
      df_llm <- results_df %>% 
        filter(llm == llm_name, shot == "fewshot", paper_id == paper_num)
      
      p2 <- ggplot(df_llm,
                   aes(x = tag,
                       y = .data[[metric]],
                       fill = factor(temperature))) +
        geom_bar(stat="identity", position="dodge") +
        labs(
          title = paste("Few-shot"),
          y = metric,
          fill = "Temperature"
        ) +
        theme_classic() +
        scale_fill_brewer(palette = "Set2") +
        theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))
      
      
      # juntar las dos gráficas
      combined_plot <- p1 + p2 +
        plot_annotation(
          title = paste(metric, "- LLM:", llm_name, "paper", papers$paper_name[i])
        )
      
      print(combined_plot)
      
      ggsave(
        filename = paste0(metric, "_", llm_name, "_", papers$paper_name[i], ".png"),
        plot = combined_plot,
        width = 14,
        height = 6,
        dpi = 300
      )
    }
  }
}
