**************************************************
* Do file for trying to merge the two datasets*
**************************************************

cd "/Users/sophiaaristizabal/Documents/GitHub/LLMS_Project/LLMS_analysis/Data/managerial_leadership_Jordi_Cooper"

use "BC Coding Data, Main Experiment.dta", clear

//first only leave the unit in session

gen session_unit = mod(session, 10)

drop session

rename session_unit session

//with this done, merge this dataset witht he other one. 
//from this dataset to the other one it is 1 .. n

merge 1:m session period group game using "BC Master Data, Follow Up Experiment.dta"

keep if _merge == 3

drop _merge

drop truth_a2 truth_a1 true_treatment_ordered surplus_babbling strategy2 strategy1 payoff_manager payoff_b2 payoff_b1 payoff_2 payoff_1 obn nummess_man nummess_agent messagecode man_suggest_safe man_suggest_efficient man_explanation man_discuss_rules man_discuss_howtoplay man_discuss_fairness man_discuss_efficient man_discuss_coordinate man_ask_game man_agree_proposal false_a2 false_a1 chat_decent chat_cent chat_advice

export delimited "merged_experiment.csv", replace

