library(tidyverse)
library(readxl)
library(dplyr)
library(stringr)

#set the directory when the script is executed directly
script_args <- commandArgs(trailingOnly = FALSE)
file_arg <- "--file="
script_path <- sub(file_arg, "", script_args[grepl(file_arg, script_args)])
if (length(script_path) > 0) {
  setwd(dirname(normalizePath(script_path[1])))
}

#read the data
tags <- read_csv("tags.csv")
chat <- read_excel("chat.xlsx")

# normalize names so the current chat.xlsx joins on the expected keys
names(tags) <- make.unique(tolower(names(tags)))
names(chat) <- make.unique(tolower(names(chat)))

#compare the numer of observarions in each dataset
nrow(tags)
names(tags)
nrow(chat)
names(chat)

#only the ones that can be merged
merged <- inner_join(tags, chat,
                     by = c("session", "period", "group"))

nrow(merged)

#see the first rows of the result
head(merged)

#before saving, drop the columns that are useless for the purpose of the research
# from tags: truth_a2 truth_a1 true_treatment_ordered surplus_babbling strategy2 strategy1 payoff_manager payoff_b2 payoff_b1 payoff_2 payoff_1 obn nummess_man nummess_agent messagecode man_suggest_safe man_suggest_efficient man_explanation man_discuss_rules man_discuss_howtoplay man_discuss_fairness man_discuss_efficient man_discuss_coordinate man_ask_game man_agree_proposal false_a2 false_a1 chat_decent chat_cent chat_advice
# from chat: obn, centralized, Session Start, Session No., TimeStage21ChatChatMessage,	TimeStage2InfoATreatment0And1ChatMessage,	TimeStage2StateOfTheWorldDecisionCTreatment0ChatMessage,	re

cols_to_drop <- c(
  # from tags
  "truth_a2", "truth_a1", "true_treatment_ordered", "surplus_babbling",
  "strategy2", "strategy1", "payoff_manager", "payoff_b2", "payoff_b1",
  "payoff_2", "payoff_1", "obn", "nummess_man", "nummess_agent",
  "messagecode", "man_suggest_safe", "man_suggest_efficient", 
  "man_explanation", "man_discuss_rules", "man_discuss_howtoplay",
  "man_discuss_fairness", "man_discuss_efficient", "man_discuss_coordinate",
  "man_ask_game", "man_agree_proposal", "false_a2", "false_a1",
  "chat_decent", "chat_cent", "chat_advice",
  
  # from chat
  "centralized", "session start", "session no.",
  "timestage21chatchatmessage", 
  "timestage2infoatreatment0and1chatmessage",
  "timestage2stateoftheworlddecisionctreatment0chatmessage",
  "re", "group.1"
)

merged <- merged %>% 
  select(-any_of(cols_to_drop))

names(merged)


#save the newly created dataset
write.csv(merged, "real_answers_desaggregated.csv", row.names = FALSE)


# Cargar datos
datos <- read.csv("real_answers_desaggregated.csv", stringsAsFactors = FALSE)


result <- datos %>%
  group_by(session, period, group, game) %>%  # agrupa por las columnas deseadas
  summarise(conteo = n(), .groups = "drop") %>%  # cuenta cuántas veces aparece cada combinación
  slice(match(paste(session, period, group, game), paste(session, period, group, game)))  # mantiene orden original

# Mostrar resultado
print(result, n = nrow(result))

# guardar en un txt separado por comas en el orden que sale solo la informacion de "conteo"
write.table(result %>% select(conteo), 
            file = "conteo_por_juego.txt", 
            sep = ",", 
            row.names = FALSE, 
            col.names = FALSE)

vars_keep <- c(
  "any_suggestion", "suggest_safe", "suggest_efficient", "agree_proposal",
  "discuss_coordinate", "discuss_fairness", "discuss_efficient", "discuss_rules",
  "explanation", "discuss_howtoplay", "ask_game", "receive_report",
  "truthful", "falsehood", "contradict", "neither_report"
)

names(datos)

vars_keep_existing <- intersect(vars_keep, names(datos))

# Agrupar y concatenar mensajes
result <- datos %>%
  mutate(across(all_of(vars_keep_existing),
                ~ ifelse(.x %in% c(0, 1), .x, 0.5))) %>% 
  group_by(session, period, group, game) %>%
  summarise(
    across(all_of(vars_keep_existing), ~ first(.x)),
    message = str_c(message, collapse = "/"),
    conteo = n(),
    .groups = "drop"
  )

# Mostrar resultado
print(result, n = nrow(result))

#revisar message en result 
head(result$message)

# guardar en un csv
write.table(result, 
            file = "real_answers.csv", 
            sep = ",", 
            row.names = FALSE, 
            col.names = TRUE)


