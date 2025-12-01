library(tidyverse)
library(readxl)
library(dplyr)

#set the directory
setwd("/Users/sophiaaristizabal/Documents/GitHub/LLMS_Project/LLMS_analysis/Data/managerial_leadership_Jordi_Cooper")

#read the data
tags <- read_csv("tags.csv")
chat <- read_excel("chat.xlsx")

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
  "centralized", "Session Start", "Session No.",
  "TimeStage21ChatChatMessage", 
  "TimeStage2InfoATreatment0And1ChatMessage",
  "TimeStage2StateOfTheWorldDecisionCTreatment0ChatMessage",
  "re","Group"
)

merged <- merged %>% 
  select(-any_of(cols_to_drop))

names(merged)


#save the newly created dataset
write.csv(merged, "merged_output.csv", row.names = TRUE)
