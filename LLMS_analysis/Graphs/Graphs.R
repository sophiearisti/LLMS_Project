  library(readr)
  library(dplyr)
  
  papers <- data.frame(
    paper_number = c(1, 2, 4),
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
            
          }
        }
      }
    }
  }
  
