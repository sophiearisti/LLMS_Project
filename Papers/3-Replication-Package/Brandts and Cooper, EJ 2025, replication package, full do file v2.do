* load main data

* set the default directory to the location of the data files

clear

cd "/Users/djcoopr/Dropbox/Decentralization/EJ, Revision 4/"

use "BC Master Data, Main Experiment.dta"

* generate variables

gen app_d_treatments = part_decent + 2 * str_decent + 3 * hsl_decent + 4 * part_cent + 5 * str_cent + 6 * hsl_cent

label define adlab 0 "unused" 1 "ND - D" 2 "STR - D" 3 "HSL - D" 4 "SC - MC" 5 "STR - MC" 6 "HSL - MC"

label values app_d_treatments adlab

label variable app_d_treatments "treatments for Appendix D"

* generate and label variables

gen late = (period >= 10)

label variable late "Rounds 10 - 18"
* set the default directory to the location of the data files
gen block3 = 1 + (period > 3.5)+ (period > 6.5)+ (period > 9.5)+ (period > 12.5)+ (period > 15.5)

label variable block3 "Rounds in three round blocks"

gen pick_treatments = true_treatment_ordered <= 7

label variable pick_treatments "treatments in main text"

gen global_group = 100*session + group

label variable global_group "global id number for groups"

gen global_subject = 10*global_group + type

label variable global_subject "global_id for subjects"

gen new_cluster = global_group
replace new_cluster = 100*session if ((true_treatment_ordered == 8) + (true_treatment_ordered == 9))

label variable new_cluster "for strangers treatments, cluster at session level, otherwise group"

gen new_cluster_late = 10*new_cluster + late

label variable new_cluster_late "clusters bye early vs late rounds"

gen coordinate = (strategy1 == strategy2)

label variable coordinate "agents coordinate"

gen coordinate_safe = coordinate*(strategy1 == 3)

label variable coordinate_safe "coordinate at safe equilibrium"

gen coordinate_efficient = coordinate*(strategy1 == game)

label variable coordinate_efficient "coordinate at efficient equilibrium"

gen coordinate_other = coordinate - coordinate_safe - coordinate_efficient

label variable coordinate_other "coordinate at other equilibrium"

gen agreement = (b1chat_row_r3 == b2chat_row_r3)*(b1chat_col_r3 == b2chat_col_r3)*hcomm

label variable agreement "agents agree on outcome in SC/S-D"

gen suggest_coordinate = advice*((man_suggest_row_g1 == man_suggest_col_g1)*(game == 1) + (man_suggest_row_g2 == man_suggest_col_g2)*(game == 2) + (man_suggest_row_g3 == man_suggest_col_g3)*(game == 3) + (man_suggest_row_g4 == man_suggest_col_g4)*(game == 4) + (man_suggest_row_g5 == man_suggest_col_g5)*(game == 5))

label variable suggest_coordinate "manager suggests coordination, SC/A-D"

gen suggest_safe = suggest_coordinate*((man_suggest_row_g1 == 3)*(game == 1) + (man_suggest_row_g2 == 3)*(game == 2) + (man_suggest_row_g3 == 3)*(game == 3) + (man_suggest_row_g4 == 3)*(game == 4) + (man_suggest_row_g5 == 3)*(game == 5))

label variable suggest_safe "manager suggests safe outcome, SC/A-D"

gen suggest_efficient = suggest_coordinate*((man_suggest_row_g1 == game)*(game == 1) + (man_suggest_row_g2 == game)*(game == 2) + (man_suggest_row_g3 == game)*(game == 3) + (man_suggest_row_g4 == game)*(game == 4) + (man_suggest_row_g5 == game)*(game == 5))

label variable suggest_efficient "manager suggests efficient outcome, SC/A-D"

gen suggest_other = suggest_coordinate - max(suggest_efficient, suggest_safe)

label variable suggest_other "manager suggests other coordination outcome (not safe, efficient), SC/A-D"

gen suggest_cat = suggest_safe + 2*suggest_efficient + 3*suggest_other

label variable suggest_cat "manager suggestion, SC/A-D"

label define sugcat 0 "not equilibrium" 1 "safe" 2 "efficient" 3 "other equilibrium"
label values suggest_cat sugcat

gen mapgame = (type == 1)*game + (type == 2)*(6 - game)

label variable mapgame "games, same pov for both agents"

gen mapgame_pc = mapgame * part_cent

label variable mapgame_pc "interaction, mapgame & part_cent"

gen  mapmessage = (type == 1)*message + (type == 2)*(6 - message)

label variable mapmessage "messages, same pov for both agents"

gen tell_truth = (message == game)

label variable tell_truth "truthful message, SC - MC"

gen partial_lie = (mapmessage > mapgame) & (mapmessage != 5)

label variable partial_lie "advantageous partial lie"

gen altruistic_lie = (mapmessage < mapgame) 

label variable altruistic_lie "disadvantageous lie"

gen div_agree = (message1 == message2)

label variable div_agree "message1 = message2"

gen true1 = message1 == game

label variable true1 "Agent 1 told truth"

gen true2 = message2 == game

label variable true2 "Agent 2 told truth"

gen both_true = (message1 == game)*(message2 == game)

label variable both_true "both agents tell truth"

egen total_game_revealed = sum(both_true), by(global_subject)

label variable total_game_revealed "total number of times game revealed, all 18 rounds"

gen tgr_block = (total_game_revealed > 3.5) + (total_game_revealed > 6.5) + (total_game_revealed > 9.5) + (total_game_revealed > 12.5) + (total_game_revealed > 15.5) 

label variable tgr_block "create categories for total_game_revealed"

gen follow_divisions = (message1 == strategy1)*(message2 == strategy2)

label variable follow_divisions "strategy1 = message1, strategy2 = message2"

gen div_agree_mistake = div_agree*(1-follow_divisions)

label variable div_agree_mistake "manager does not follow agent's messages when agents agree"

gen div_disagree = (message1 == 5)*(message2 == 1)

label variable div_disagree "message1 = 5, message2 = 1"

gen babble_surp = 64*((game == 1)+(game == 5)) + 72*((game == 2)+(game == 4)) + 80*(game == 3)
replace babble_surp = 56*((game == 1)+(game == 5)) + 68*((game == 2)+(game == 4)) + 80*(game == 3) if true_treatment_ordered > 9

label variable babble_surp "surplus from babbling equilibrium"

egen surplus_block = mean(payoff_manager), by (new_cluster_late)
egen new_babble_surplus_block = mean(babble_surp),by (new_cluster_late)
egen coordinate_block = mean(coordinate), by (new_cluster_late)
egen efficient_block = mean(coordinate_efficient), by (new_cluster_late)
gen efficiency_gain_block =  (surplus_block - new_babble_surplus_block )/(80 - new_babble_surplus_block )

label variable surplus_block "total surplus, 9 round block"
label variable new_babble_surplus_block "total babble surplus, 9 round block"
label variable coordinate_block "coordination rate, 9 round block"
label variable efficient_block "efficient coordination rate, 9 round block"
label variable efficiency_gain_block "efficiency gain, 9 round block"

gen simple_strategy = (div_agree * message1) + ((1 - div_agree) * 3)

label variable simple_strategy "follow messages if agents agree, otherwise play safe"

gen simple_payoff = 80 - 8*abs(game - simple_strategy)

label variable simple_payoff "payoff from simple strategy"

egen count_true = sum(tell_truth), by(global_subject)

label variable count_true "rounds telling truth, SC-MC"

egen revealed_block = mean(both_true), by(new_cluster_late)

label variable revealed_block "% game revealed, 9 round block"

gen manager_mistake = (1 - coordinate) + coordinate*(strategy1 > max(game,3)) + coordinate*(strategy1 < min(game,3))

label variable manager_mistake "error by manager as defined in Section 5"

gen alt_surplus = (1 - manager_mistake*both_true)*payoff_manager + manager_mistake * both_true* babble_surp

label variable alt_surplus "replace surplus with babbling if manager made mistake and game revealed"

sort session original_subject period
gen lag_true1 = true1[_n-1]
gen lag_true2 = true2[_n-1]
gen lag_truth_comb = lag_true1 - lag_true2

label variable lag_true1 "Agent 1 told truth in the previous period"
label variable lag_true2 "Agent 2 told truth in the previous period"
label variable lag_truth_comb "truth index (see Appendix D)"

*** Section 4.1 ***

* for fn 15

tab block3 true_treatment_ordered if pick_treatments & type == 0, summarize(payoff_manager) mean

* create Table 2 (note: rows and columns flipped)

dtable coordinate payoff_manager efficiency_gain_block if pick_treatments & type == 0 & late , by(true_treatment_ordered, nototals) nosample cont(coordinate payoff_manager efficiency_gain_block,stat(mean))

tab true_treatment_ordered if pick_treatments & type == 0 & late & coordinate, summarize(coordinate_efficient) mean

* Top panel in Table A2
* Bottom panel is same as Table 2

dtable coordinate payoff_manager efficiency_gain_block if pick_treatments & type == 0 & 1 - late , by(true_treatment_ordered, nototals) nosample cont(coordinate payoff_manager efficiency_gain_block,stat(mean))

tab true_treatment_ordered if pick_treatments & type == 0 & 1 - late & coordinate, summarize(coordinate_efficient) mean

* Table D1

dtable coordinate payoff_manager efficiency_gain_block if app_d_treatments > 0 & type == 0 & late , by(app_d_treatments, nototals) nosample cont(coordinate payoff_manager efficiency_gain_block,stat(mean))

tab app_d_treatments if app_d_treatments > 0 & type == 0 & late & coordinate, summarize(coordinate_efficient) mean

* tests underlying Result 1

ranksum surplus_block if type == 0 & period == 10 & (true_treatment_ordered == 1) + (true_treatment_ordered == 4), by(true_treatment)

ranksum coordinate_block if type == 0 & period == 10 & (true_treatment_ordered == 1) + (true_treatment_ordered == 4), by(true_treatment)

signrank surplus_block = new_babble_surplus_block if type == 0 & period == 10 & true_treatment_ordered == 4

* create Table 3

dtable coordinate_safe coordinate_efficient coordinate_other if pick_treatments & type == 0 & late & game != 3, by(true_treatment_ordered, nototals) nosample cont(coordinate_safe coordinate_efficient coordinate_other,stat(mean))

* Top panel in Table A3
* Bottom panel is same as Table 3

dtable coordinate_safe coordinate_efficient coordinate_other if pick_treatments & type == 0 & 1 - late & game != 3, by(true_treatment_ordered, nototals) nosample cont(coordinate_safe coordinate_efficient coordinate_other,stat(mean))

* support for Result 2

tab true_treatment_ordered if pick_treatments & type == 0 & late & game != 3 & coordinate, summarize(coordinate_safe)
tab true_treatment_ordered if pick_treatments & type == 0 & late & game != 3 & coordinate, summarize(coordinate_efficient)


tab true_treatment_ordered if pick_treatments & type == 0 & late & game != 3 & coordinate_other, summarize(payoff_manager)
tab true_treatment_ordered if pick_treatments & type == 0 & late & game != 3 & coordinate_other, summarize(babble_surp)

tab strategy1 if part_cent & late & coordinate_other & type == 0 & game == 1
tab strategy1 if part_cent & late & coordinate_other & type == 0 & game == 5

* 56% figure calculated using output from previous two commands
* numerator sum of action farther away from efficient than the safe outcome
* denominator is total # obs

display 18/32

* support for Result 3

ranksum surplus_block if type == 0 & period == 10 & (true_treatment_ordered == 1) + (true_treatment_ordered == 2), by(true_treatment)
ranksum surplus_block if type == 0 & period == 10 & (true_treatment_ordered == 1) + (true_treatment_ordered == 3), by(true_treatment)

ranksum surplus_block if type == 0 & period == 10 & (true_treatment_ordered == 4) + (true_treatment_ordered == 2), by(true_treatment)
ranksum surplus_block if type == 0 & period == 10 & (true_treatment_ordered == 4) + (true_treatment_ordered == 3), by(true_treatment)

ranksum coordinate_block if type == 0 & period == 10 & (true_treatment_ordered == 1) + (true_treatment_ordered == 2), by(true_treatment)
ranksum coordinate_block if type == 0 & period == 10 & (true_treatment_ordered == 1) + (true_treatment_ordered == 3), by(true_treatment)

tab true_treatment_ordered if pick_treatments & type == 0 & late & game != 3 & coordinate, summarize(coordinate_efficient)

* Support for Result 4

ranksum surplus_block if type == 0 & period == 10 & (true_treatment_ordered == 1) + (true_treatment_ordered == 5), by(true_treatment)
ranksum surplus_block if type == 0 & period == 10 & (true_treatment_ordered == 1) + (true_treatment_ordered == 6), by(true_treatment)
ranksum surplus_block if type == 0 & period == 10 & (true_treatment_ordered == 1) + (true_treatment_ordered == 7), by(true_treatment)

ranksum surplus_block if type == 0 & period == 10 & (true_treatment_ordered == 2) + (true_treatment_ordered == 5), by(true_treatment)
ranksum surplus_block if type == 0 & period == 10 & (true_treatment_ordered == 3) + (true_treatment_ordered == 6), by(true_treatment)
ranksum surplus_block if type == 0 & period == 10 & (true_treatment_ordered == 4) + (true_treatment_ordered == 7), by(true_treatment)

ranksum surplus_block if type == 0 & period == 10 & (true_treatment_ordered == 5) + (true_treatment_ordered == 7), by(true_treatment)


* fn 16

ranksum surplus_block if type == 0 & period == 10 & (true_treatment_ordered == 4) + (true_treatment_ordered == 5), by(true_treatment)
ranksum surplus_block if type == 0 & period == 10 & (true_treatment_ordered == 4) + (true_treatment_ordered == 6), by(true_treatment)

* Support for Result 4 (cont)

ranksum surplus_block if type == 0 & period == 10 & (true_treatment_ordered == 6) + (true_treatment_ordered == 7), by(true_treatment)
tab true_treatment_ordered if pick_treatments & type == 0 & period == 10 , summarize(surplus_block)
tab2 surplus_block true_treatment  if chat_decent + chat_cent+ chat_advice & type == 0 & period == 10

* includes fn 17

signrank surplus_block = new_babble_surplus_block if type == 0 & period == 10 & true_treatment_ordered == 5
signrank surplus_block = new_babble_surplus_block if type == 0 & period == 10 & true_treatment_ordered == 6
signrank surplus_block = new_babble_surplus_block if type == 0 & period == 10 & true_treatment_ordered == 7

ranksum efficient_block if type == 0 & period == 10 & (true_treatment_ordered == 4) + (true_treatment_ordered == 7), by(true_treatment_ordered)
ranksum efficient_block if type == 0 & period == 10 & (true_treatment_ordered == 5) + (true_treatment_ordered == 7), by(true_treatment_ordered)
ranksum efficient_block if type == 0 & period == 10 & (true_treatment_ordered == 6) + (true_treatment_ordered == 7), by(true_treatment_ordered)

* fn 18

tab coordinate_block if true_treatment_ordered == 6 & type == 0 & period == 10

* calculate weighted average using output of preceding command

display (4*(8/9) + 7/9 + 2/3 + 5/9)/8

* for Figure 1 (SC - MC)
* Output from the following command was copied and pasted into Excel
* Divide by 27 to get percentages

tab tgr_block if period == 1 & part_cent & type == 0

*** Section 4.2. ***

* Structured Communication

* SC/S-D and SC/A-D

summarize agreement if hcomm & type == 0
tab agreement if hcomm & type == 0, summarize(coordinate)
tab late if advice & type == 0, summarize(suggest_coordinate)
tab suggest_cat  if type == 0 & advice & game != 3
tab2 suggest_coordinate suggest_safe  if type == 0 & advice , summarize(coordinate) mean

* SC - MC

* Table 4

tab2 mapmessage mapgame if true_treatment_ordered == 4  & type >=1 

* support for result 6

correlate mapmessage mapgame if part_cent & type >=1 

summarize tell_truth if part_cent  & type >=1 
summarize tell_truth if part_cent  & type >=1 & mapgame == 1
bysort late: summarize tell_truth if part_cent  & type >=1 
summarize partial_lie if part_cent  & type >=1  & mapmessage > mapgame
summarize altruistic_lie if part_cent  & type >=1 

* Table 5

tab message1 message2 if part_cent & type == 0 & coordinate, summarize(strategy1) nostandard

summarize div_agree_mistake if part_cent & type == 0 & div_agree
tab div_agree div_agree_mistake if part_cent & type == 0, summarize(payoff_manager) mean
summarize coordinate_safe if div_disagree & type == 0 & part_cent
summarize payoff_manager babble_surp if div_disagree & type == 0 & part_cent & 1 - coordinate_safe
bysort late: summarize div_agree_mistake if part_cent & type == 0 & div_agree
bysort late: summarize coordinate_safe if div_disagree & type == 0 & part_cent

* benefit of following simple strategy

summarize payoff_manager babble_surp simple_payoff if part_cent & type == 0

* use output of preceding commands to calculate efficiency gain from simple rule vs. actual efficiency gain

display (70.81893   - 70.96296 )/(80 - 70.96296 )
display (73.1358   - 70.96296 )/(80 - 70.96296 )

* for section 4.2.b (before result 9)

tab div_agree if part_cent & type == 0

* for paragraph before Table 7

tab count_true if part_cent & type != 0 & period == 1

* use output from previous calculate % agents both tell the truth in at least a third of the rounds and lie in at least a third of the rounds
* for numerator subtract strictly less than 6 or strictly greater than 12

display (54 - 3 - 14)/54

* for Table 7

tab mapgame if type != 0 & part_cent, summarize(tell_truth) mean

* for Table 9

summarize both_true if part_cent & type == 0 & late
summarize tell_truth if type != 0 & part_cent & late

* for Section 5

tab true1 true2 if both_true == 0 & late & part_cent & type == 0

* 2nd paragraph after Table 9
* use output of preceding, calculate % one true and one lied

display 134/168

tab both_true if part_cent & late & type == 0, summarize(payoff_manager)
tab manager_mistake if part_cent & late & type == 0 & both_true

* fn 33

summarize payoff_manager alt_surplus if late & type == 0 & part_cent

* Appendix B, fn 7

tab message1 game if part_cent & type == 0
tab message2 game if part_cent & type == 0

* Appendix B, use of extreme outcomes

tab strategy1 strategy2 if (message1 != message2) & (message1 >= 2) & (message1 <= 4)& (message2 >= 2) & (message2 <= 4) & type == 0 & part_cent

* use output from previous command to calculate % safe and % extreme outcomes

display 28/61
display 2/61

* for Appendix D, after Table D1

ranksum surplus_block if type == 0 & period == 10 & (app_d_treatments == 1) + (app_d_treatments == 2)*(group == 1), by(app_d_treatments)
ranksum surplus_block if type == 0 & period == 10 & (app_d_treatments == 4) + (app_d_treatments == 5)*(group == 1), by(app_d_treatments)

ranksum efficiency_gain_block if type == 0 & period == 10 & (app_d_treatments == 1) + (app_d_treatments == 3), by(app_d_treatments)
ranksum efficiency_gain_block if type == 0 & period == 10 & (app_d_treatments == 4) + (app_d_treatments == 6), by(app_d_treatments)
ranksum efficiency_gain_block if type == 0 & period == 10 & (chat_cent) + (app_d_treatments == 6), by(app_d_treatments)

* regression table about responding to truth telling (Table D2)

regress strategy1 message1 message2  lag_truth_comb i.period if part_cent & coordinate & period > 1 & type == 0, cluster(new_cluster)
est store truth1

regress strategy1 message1 message2  lag_truth_comb i.period if str_cent & coordinate & period > 1 & type == 0, cluster(new_cluster)
est store truth2

* outreg2 [truth1 truth2] using truthreg1, replace see word excel keep(message1 message2  lag_truth_comb) aster stats(coef se) dec(3) 

* Table D3

tab2 mapmessage mapgame if part_cent  & type >=1 , col
tab2 mapmessage mapgame if str_cent  & type >=1 , col

* regression table about telling truth (Table D4)

xi: dprobit tell_truth part_cent i.mapgame i.period if part_cent + str_cent  & type != 0, cluster(new_cluster)
est store truth3

xi: dprobit tell_truth part_cent mapgame_pc i.mapgame i.period if part_cent + str_cent  & type != 0, cluster(new_cluster)
est store truth4

* outreg2 [truth3 truth4] using truthreg2, replace see word excel keep(part_cent mapgame_pc) aster stats(coef se) dec(3) 

* stats about mistakes (App D)

summarize follow_divisions if div_agree & type == 0 & part_cent
summarize follow_divisions if div_agree & type == 0 & str_cent

summarize coordinate_safe if div_disagree & type == 0 & part_cent
summarize coordinate_safe if div_disagree & type == 0 & str_cent

* for non-parametrics in Section 5

keep  if type == 0 & period == 10 
keep if part_cent + chat_cent
keep global_group part_cent chat_cent surplus_block new_babble_surplus_block revealed_block
gen ec_cent = 0
order part_cent ec_cent chat_cent surplus_block new_babble_surplus_block revealed_block
save "for Section 5 non-parametrics.dta", replace




*****************************************************************************************************************************************************************************************
*****************************************************************************************************************************************************************************************
*****************************************************************************************************************************************************************************************
*****************************************************************************************************************************************************************************************

* load chat data

clear

use "BC Coding Data, Main Experiment.dta"

* generate and label variables

gen late = period > 9.5

label variable late "Rounds 10 - 18"

egen total_agreements = sum(agree_proposal), by(global_group)

label variable total_agreements "total number of agreements reached by group over all 18 rounds"

gen game_revealed = (truthful > 0) * (contradict == 0)

label variable game_revealed "one branch told truth, no contradiction"

egen total_game_revealed = sum(game_revealed), by(global_group)

label variable total_game_revealed "total number of times game revealed, all 18 rounds"

gen tgr_block = (total_game_revealed > 3.5) + (total_game_revealed > 6.5) + (total_game_revealed > 9.5) + (total_game_revealed > 12.5) + (total_game_revealed > 15.5) 

label variable tgr_block "create categories for total_game_revealed"

gen report_a1 = truth_a1 + false_a1

label variable report_a1 "reports by A1"

egen tot_reports_a1 = sum(report_a1), by(global_group)

label variable tot_reports_a1 "total reports by A1, all rounds"

gen report_a2 = truth_a2 + false_a2

label variable report_a2 "reports by A2"

egen tot_reports_a2 = sum(report_a2), by(global_group)

label variable tot_reports_a2 "total reports by A2, all rounds"

gen any_report_a1 = max(truth_a1, false_a1)

label variable any_report_a1 "any report by A1, truth or lie"

egen tot_any_reports_a1 = sum(any_report_a1), by(global_group)

label variable tot_any_reports_a1 "rounds with any report, A1"

gen any_report_a2 = max(truth_a2, false_a2)

label variable any_report_a2 "any report by A2, truth or lie"

egen tot_any_reports_a2 = sum(any_report_a2), by(global_group)

label variable tot_any_reports_a2 "rounds with any report, A2"

egen tot_false_a1 = sum(false_a1), by(global_group)

label variable tot_false_a1 "rounds with lies, A1"

egen tot_false_a2 = sum(false_a2), by(global_group)

label variable tot_false_a2 "rounds with lies, A2"

gen coordinate_failure = 1 - coordinate

label variable coordinate_failure "coordination failure"

sort session global_group period

gen lag_coordinate_efficient = coordinate_efficient[_n-1]
gen lag_coordinate_safe = coordinate_safe[_n-1]
gen lag_coordinate_failure = coordinate_failure[_n-1]
gen lag_game = game[_n-1]

label variable lag_coordinate_efficient "lagged value, coordinate_efficient"
label variable lag_coordinate_safe "lagged value, coordinate_safe"
label variable lag_coordinate_failure "lagged value, coordinate_failure"
label variable lag_game "lagged value, game"

gen hard_lie = falsehood * (contradict == 0)*(disagreement == 0)

label variable hard_lie "uncontradicted lie"

egen tot_payoff_manager = sum(payoff_manager), by(global_group)
tab tot_payoff_manager if period == 1 & chat_advice
gen high_manager = tot_payoff_manager > 1305

label variable high_manager "highest earning third of managers in CH/A – D"

gen suggest_type =  man_suggest_efficient - man_suggest_safe 

label variable suggest_type "good manager suggestions in CH/A – D "

drop tot_payoff_manager

gen global_group_late = 10*global_group + late

egen game_revealed_block = mean(game_revealed), by(global_group_late)

label variable game_revealed_block "% game revealed, 9 round block"

drop global_group_late

gen manager_mistake = (1 - coordinate) + coordinate*(strategy1 > max(game,3)) + coordinate*(strategy1 < min(game,3))

label variable manager_mistake "error by manager as defined in Section 5"

gen babble_surplus = 80*(game == 3) + 72*((game ==2)+(game==4))+ 64*((game ==1)+(game==5))

label variable babble_surplus "total surplus, babbling equilibrium"

gen alt_surplus = (1 - manager_mistake*game_revealed)*payoff_manager + manager_mistake * game_revealed * babble_surplus

label variable alt_surplus "Surplus, replace with babbling surplus for manager mistakes"


* Table 6

* Note: There are observations where the message is blank because no messages were sent. These are not counted as messages. 
* There are also observations where the message is blank because a message was sent but contained no content. These are counted as messages.

tab true_treatment, summarize(nummess_man) nostandard
tab true_treatment, summarize(nummess_agent) nostandard

* divide output from preceding command by 2 to get number of messages per agent

display 10.6049/2
display 7.44856 /2
display 8.9033/2

* Note: There are no observations for ask_game truthful falsehood contradict in CH/S-D

bysort true_treatment_ordered: summarize any_suggestion suggest_safe suggest_efficient agree_proposal discuss_coordinate discuss_fairness discuss_efficient discuss_rules discuss_howtoplay explanation ask_game truthful falsehood contradict 

* tests, frequency of messages

preserve

collapse (mean) true_treatment chat_decent chat_advice chat_cent nummess_man nummess_agent, by(global_group) 

ranksum nummess_man if chat_advice + chat_cent, by(chat_cent)

ranksum nummess_agent if chat_decent + chat_cent, by(chat_cent)
ranksum nummess_agent if chat_advice + chat_cent, by(chat_cent)

* fn 22

ranksum nummess_agent if chat_decent + chat_advice, by(chat_advice)

tab true_treatment_ordered, summarize(nummess_man)

restore

* frequency of coordination if agreement, CH/S-D

tab agree_proposal if chat_decent, summarize(coordinate) nostandard

* use output from preceding command to calculate weighted average, correct for cases where coders disagreed (50% weight on these cases)

display (.950*362 + .953*21.5)/(362 + 21.5)

* agree to efficient subject to agreeing, game != 3, CH/S-D

tab agree_proposal if chat_decent & game != 3, summarize( last_suggest_efficient )

* use output from preceding command to calculate weighted average, correct for cases where coders disagreed (50% weight on these cases)

display (.3485*274 + .2429*17.5)/(274 + 17.5)

* play efficient subject to agreeing to efficient

tab agree_proposal last_suggest_efficient if chat_decent & game ! = 3, summarize( coordinate_efficient ) nostandard

* use output from preceding command to calculate weighted average, correct for cases where coders disagreed (50% weight on cases with 1 disagreement, 25% if two coder disagreements)

display (90 * .9666667 + .875 * 4 + 5.5 + .25 )/( 90+4+5.5+.25)

* agree to efficient subject to agreeing, game != 3, CH/A-D

tab agree_proposal if chat_advice & game != 3, summarize( last_suggest_efficient )

* use output from preceding command to calculate weighted average, correct for cases where coders disagreed (50% weight on these cases)

display (.4735*170 + .3182*33)/(170 + 33)

* efficient coordination subject to agreeing to efficient coordination, game != 3, CH/A-D

tab agree_proposal last_suggest_efficient if chat_advice & game ! = 3, summarize( coordinate_efficient ) nostandard

* use output from preceding command to calculate weighted average, correct for cases where coders disagreed (50% weight on cases with 1 disagreement, 25% if two coder disagreements)

display (80 * .925 + 9.5*.9474 + .75*.25  )/( 80+9.5+1+.5)

* coordination rate without vs. with agreement

tab2 true_treatment_ordered agree_proposal if chat_decent + chat_advice, summarize(coordinate) nostandard

* use output from preceding command to calculate weighted average, correct for cases where coders disagreed (50% weight on these cases)
* use final line (total)

display (.6603 * 262 + .90625 *64)/(262 + 64)
display (.9502*582 + .90625 *64)/(582 + 64)

* change in agreement rate, CH/A-D
tab late if chat_advice, summarize(agree_proposal)

* fn 23

tab true_treatment_ordered if period == 1, summarize(total_agreements)

* change in truth telling and lying, CH-MC

bysort late: summarize truthful falsehood if chat_cent

* for Figure 1 (CH - MC)
* Output from the following command was copied and pasted into Excel
* Divide by 27 to get percentages

tab tgr_block if period == 1 & chat_cent

* paragraphs before Result 9

tab receive_report if chat_cent, summarize(game_revealed)

* use output from preceding command to calculate weighted average, correct for cases where coders disagreed (50% weight on these cases)

display (309 + 27.5)/486
display (309*.95146 + 27.5*.90909)/(309 + 27.5)

tab truthful if chat_cent & game != 3, summarize(coordinate_efficient)

* use output from preceding command to calculate weighted average, correct for cases where coders disagreed (50% weight on these cases)

display (.1134 * 97 + .56757 * 18.5)/(97 + 18.5)
display (.52101 * 238 + .56757 * 18.5)/(238 + 18.5)

tab contradict if chat_cent & game != 3, summarize(coordinate_efficient)

* use output from preceding command to calculate weighted average, correct for cases where coders disagreed (50% weight on these cases)

display (.42935 * 7 + 1.5)/8.5

* fn 24

tab truthful if chat_cent & game != 3 & coordinate_efficient, summarize(suggest_efficient)

* use output from preceding command to calculate weighted average, correct for cases where coders disagreed (50% weight on these cases)

display (.90909*11 + .83333333*10.5)/(11 + 10.5)

* paragraph following Result 9

tab truthful if chat_advice & game != 3, summarize(coordinate_efficient)

* use output from preceding command to calculate weighted average, correct for cases where coders disagreed (50% weight on these cases)

display (.32946 * 258 + .38889 * 9)/(258 + 9)
display (.52083 * 96 + .38889 * 9)/(96 + 9)

* for Table 7 (games have to be flipped for Agent 2)

table game if chat_cent, stat( mean truth_a1 truth_a2)
table game if chat_cent, stat( mean false_a1 false_a2)

* for Table 9

summarize truth_a1 truth_a2 false_a1 false_a2 if chat_cent & late

* use output from preceding command, average over the two agents

display (.4485597 +  .5164609)/2
display (.0164609 +  .0041152)/2

summarize game_revealed if late & chat_cent

* paragraph following Table 7

gen some_report1 = tot_any_reports_a1 > 0
gen some_report2 = tot_any_reports_a2 > 0

tab some_report1 if chat_cent & period == 1
tab some_report2 if chat_cent & period == 1

drop some_report1 some_report2

gen never_lie1 = tot_false_a1 == 0
gen never_lie2 = tot_false_a2 == 0

tab never_lie1 if chat_cent & period == 1 & tot_any_reports_a1 > 0
tab never_lie2 if chat_cent & period == 1 & tot_any_reports_a2 > 0

drop never_lie1 never_lie2


* generate 9.8 figure

summarize tot_any_reports_a1 if tot_any_reports_a1 > 0 & chat_cent & period == 1
summarize tot_any_reports_a2 if tot_any_reports_a2 > 0 & chat_cent & period == 1

* use output from preceding command, average over the two agents

display ((9.6875 * 24) + (9.913 * 23))/47

* generate 36 figure

tab tot_false_a1 if chat_cent & period == 1 & tot_any_reports_a1 > 0
tab tot_false_a2 if chat_cent & period == 1 & tot_any_reports_a2 > 0

* partial lie figure based on hand count, not Stata command

* generate max percent lies

gen rat_false_a1 = tot_false_a1/tot_reports_a1
gen rat_false_a2 = tot_false_a2/tot_reports_a2

summarize rat_false_a1 if chat_cent & period == 1 & tot_any_reports_a1 > 0
summarize rat_false_a2 if chat_cent & period == 1 & tot_any_reports_a2 > 0

drop rat_false_a1 rat_false_a2

* generate no 1/3 true 1/3 lies

summarize tot_false_a1 if chat_cent & period == 1 
summarize tot_false_a2 if chat_cent & period == 1 

* paragraph after result 10

tab ask_game if chat_cent, summarize(falsehood)

* use output from preceding command to calculate weighted average, correct for cases where coders disagreed (50% weight on these cases)

display ((.01463 * 376)+(15.5*.1452))/(376 + 15.5)
display ((.1452*15.5) + (.0823*79))/(15.5 + 79)

* use output from preceding command to calculate weighted average, correct for cases where coders disagreed (50% weight on these cases), average across 2 agents

tab false_a1 if chat_cent, summarize(disagreement)
tab false_a2 if chat_cent , summarize(disagreement)
display (.407 * 9 + .6 * 5 + .238 *3.5 + .111 * 1.5)/(9+3.5+5+1.5)

* last paragraph of 4.2.1

tab any_report_a1 truth_a2 if chat_cent
tab any_report_a2 truth_a1 if chat_cent

* use output from preceding two commands to calculate weighted average, correct for cases where coders disagreed (50% weight on cases with 1 disagreement, 25% if two coder disagreements)

display (93 + 7 + 4 + (29/4))/(229 + (49/2))
display (97 + 4.5 + 4.5 + (29/4))/(231 + 27)

* average over two agents

display (.4389 + .4390)/2

tab neither_report if chat_cent & period > 1 & lag_game != 3 & lag_coordinate_safe == 1

* use output from preceding command to calculate weighted average, correct for cases where coders disagreed (50% weight on these cases)

display 37.59 + 7.52/2

tab neither_report if chat_cent & period > 1 & lag_game != 3 & lag_coordinate_efficient == 1

* use output from preceding command to calculate weighted average, correct for cases where coders disagreed (50% weight on these cases)

display 7.38 + 17.45/2

tab any_report_a1 if chat_cent

* use preceding to calculate non-reports by Agent 1, correct for cases where coders disagreed (50% weight on these cases)

display 229 + 49/2

tab any_report_a1 if chat_cent & max(coordinate_safe,truth_a2) == 1

* use preceding to calculate non-reports by Agent 1 if either coordinate on safe or Agent 2 told truth, correct for cases where coders disagreed (50% weight on these cases)

display 178 + 14

tab any_report_a1 if chat_cent & max(coordinate_safe,truth_a2) == .5

* use preceding to calculate non-reports by Agent 1 if either coordinate on safe or Agent 2 told truth (coder disagreement)
* correct for cases where coders disagreed (50% weight on these cases)

display (6 + 7.5)/2

tab any_report_a2 if chat_cent

* use preceding to calculate non-reports by Agent 2, correct for cases where coders disagreed (50% weight on these cases)

display 231 + 27

tab any_report_a2 if chat_cent & max(coordinate_safe,truth_a1) == 1

* use preceding to calculate non-reports by Agent 2 if either coordinate on safe or Agent 1 told truth, correct for cases where coders disagreed (50% weight on these cases)

display 180 + 16

tab any_report_a2 if chat_cent & max(coordinate_safe,truth_a1) == .5

* use preceding to calculate non-reports by Agent 2 if either coordinate on safe or Agent 1 told truth (coder disagreement)
* correct for cases where coders disagreed (50% weight on these cases)

display (4 + 8)/2

* aggregate preceding results to generate weighted average

display (192 + 196 + 12.75)/(253.5 + 258)

* Table 8

xi: dprobit coordinate agree_proposal discuss_coordinate discuss_fairness discuss_efficient discuss_rules discuss_howtoplay explanation lag_coordinate_safe lag_coordinate_efficient lag_coordinate_failure late i.game if chat_decent & period > 1 , cluster(global_group)

est store dprob_dcent1

xi: dprobit coordinate_efficient agree_proposal discuss_coordinate discuss_fairness discuss_efficient discuss_rules discuss_howtoplay explanation lag_coordinate_safe lag_coordinate_efficient lag_coordinate_failure late i.game if chat_decent & period > 1 , cluster(global_group)

est store dprob_dcent2

xi: dprobit coordinate agree_proposal discuss_coordinate discuss_fairness discuss_efficient discuss_rules discuss_howtoplay explanation lag_coordinate_safe lag_coordinate_efficient lag_coordinate_failure ask_game truthful falsehood late i.game if chat_advice & period > 1 , cluster(global_group)

est store dprob_adv1

xi: dprobit coordinate_efficient agree_proposal discuss_coordinate discuss_fairness discuss_efficient discuss_rules discuss_howtoplay explanation lag_coordinate_safe lag_coordinate_efficient lag_coordinate_failure ask_game truthful falsehood late i.game if chat_advice & period > 1 , cluster(global_group)

est store dprob_adv2

xi: dprobit coordinate_efficient agree_proposal discuss_coordinate discuss_fairness discuss_efficient discuss_rules discuss_howtoplay explanation lag_coordinate_safe lag_coordinate_efficient lag_coordinate_failure ask_game truthful falsehood late i.game if chat_cent & period > 1 , cluster(global_group)

est store dprob_cent1

* outreg2 [dprob_dcent1 dprob_dcent2 dprob_adv1 dprob_adv2 dprob_cent1] using dfile9, replace see word excel keep(  agree_proposal discuss_coordinate discuss_fairness discuss_efficient discuss_rules discuss_howtoplay explanation ask_game truthful falsehood ) aster stats(coef se) dec(3)

* fn 28

xi: dprobit coordinate_efficient agree_proposal discuss_coordinate discuss_fairness discuss_efficient discuss_rules discuss_howtoplay explanation lag_coordinate_safe lag_coordinate_efficient lag_coordinate_failure ask_game truthful hard_lie late i.game if chat_cent & period > 1 , cluster(global_group)

* discussion of good vs. bad managers with advice

xi: dprobit coordinate_efficient man_suggest_safe man_suggest_efficient man_agree_proposal man_discuss_coordinate man_discuss_fairness man_discuss_efficient man_discuss_rules man_discuss_howtoplay man_explanation man_ask_game lag_coordinate_safe lag_coordinate_efficient lag_coordinate_fail late i.game if period > 1 & chat_advice, cluster(global_group) 

regress suggest_type high_manager i.game late if chat_advice , cluster(global_group)

* for Section 5

summarize contradict if late & chat_cent & 1 - game_revealed

* fn 33

tab manager_mistake if chat_cent & late & game_revealed

* fn 31

summarize neither_report if late & chat_cent & 1 - game_revealed

* fn 33

summarize payoff_manager alt_surplus if late & chat_cent

* for non-parametrics in Section 5

keep if chat_cent & period == 10

keep global_group game_revealed_block

sort global_group

save "revealed in ch - mc.dta", replace

use "for Section 5 non-parametrics.dta", replace

merge 1:1 global_group using "revealed in ch - mc.dta"

replace revealed_block = game_revealed_block if chat_cent

drop _merge

save "for Section 5 non-parametrics.dta", replace

*****************************************************************************************************************************************************************************************
*****************************************************************************************************************************************************************************************
*****************************************************************************************************************************************************************************************
*****************************************************************************************************************************************************************************************

* load data

clear
use "BC Master Data, Follow Up Experiment.dta"

* generate and label variables

gen global_group = 100*(session + 37) + group
gen global_subject = 100*(session + 37) + subject


label variable global_group "Global ID, group"
label variable global_subject "Global ID, subject"

gen modgame = game*(type <= 1) + (6 - game)*(type == 2)

label variable modgame "6 - game for column player"

gen coordinate = (strategy1 == strategy2)

label variable coordinate "agents coordinate"

gen coordinate_safe = coordinate*(strategy1 == 3)

label variable coordinate_safe "coordinate at safe equilibrium"

gen coordinate_efficient = coordinate*(strategy1 == game)

label variable coordinate_efficient "coordinate at efficient equilibrium"

gen coordinate_other = coordinate - coordinate_safe - coordinate_efficient

label variable coordinate_other "coordinate at other equilibrium"

gen report_game = (messagecode > 10.5) * (messagecode < 15.5)

label variable report_game "report on what game is being played"

gen game_reported = (messagecode == 11) + 2*(messagecode == 12) + 3*(messagecode == 13) + 4*(messagecode == 14) + 5*(messagecode == 15)

label variable game_reported "If game reported, what game was reported"

gen group_period = 100*global_group + period

label variable group_period "period index, by group"

sort group_period obn

gen lead_group_period = group_period[_n+1]

gen last_message_group = lead_group_period != group_period

label variable last_message_group "dummy for last message sent by a group in a period"

drop lead_group_period

gen subject_period = 100*global_subject + period

label variable subject_period "period index, by subject"

sort subject_period obn

gen lead_subject_period = subject_period[_n+1]

gen last_message_ind = lead_subject_period != subject_period

label variable last_message_ind "dummy for last message sent by a subject in a period"

drop lead_subject_period

gen truth = (game == game_reported)

label variable truth "truthful report"

gen lie = report_game * (1 - truth)

label variable lie "false report"

gen claim_truth = messagecode == 16

label variable claim_truth "claim to be telling truth"

egen ever_claim_truth = max(claim_truth), by(subject_period)

label variable ever_claim_truth "ever claimed to be telling truth, period"

gen bubba = report_game * obn

sort subject_period bubba

gen lead_subject_period = subject_period[_n+1]

gen last_report_ind = lead_subject_period != subject_period

label variable last_report_ind "dummy for last message sent by a subject in a period"

drop lead_subject_period bubba

gen bubba = report_game * obn + (1 - report_game)*10000

sort subject_period bubba

gen lag_subject_period = subject_period[_n-1]

gen first_report_ind = lag_subject_period != subject_period

label variable first_report_ind "dummy for first report sent by a subject in a period"

drop lag_subject_period bubba

gen bubba = report_game * obn + (1 - report_game)*10000

sort group_period bubba

gen lag_group_period = group_period[_n-1]

gen first_report_group = lag_group_period != group_period

label variable first_report_group "dummy for first report sent in a group in a period"

drop lag_group_period bubba

gen babble_surplus = 64*((game == 1)+(game == 5)) + 72*((game == 2)+(game == 4)) + 80*(game == 3)

label variable babble_surplus "surplus from babbling equilibrium"

gen global_group_late = 10*global_group + late

label variable global_group_late "global_group, early vs. late divided"

gen bubba = payoff_manager * last_message_group

egen surplus_block = sum(bubba), by (global_group_late)
replace surplus_block = surplus_block/9

label variable surplus_block "average total surplus, 9 period block"

replace bubba = babble_surplus * last_message_group

egen babble_surplus_block = sum(bubba),by (global_group_late)
replace babble_surplus_block = babble_surplus_block/9

label variable babble_surplus_block "aveage surplus babbling equilibrium, 9 period block"

replace bubba = coordinate * last_message_group

egen coordinate_block = sum(bubba), by (global_group_late)
replace coordinate_block = coordinate_block/9

label variable coordinate_block "coordination rate, 9 period block"

replace bubba = coordinate_efficient * last_message_group

egen efficient_block = sum(bubba), by (global_group_late)
replace efficient_block = efficient_block/9

label variable efficient_block "% coordinate efficient, 9 period block"

drop bubba

gen efficiency_gain_block =  (surplus_block - babble_surplus_block )/(80 - babble_surplus_block )

label variable efficiency_gain_block "efficiency gain, 9 period block"

gen bubba = first_report_group * truth
egen first_report_true_group = max(bubba), by(group_period)
replace bubba = first_report_group * lie
egen first_report_lie_group = max(bubba), by(group_period)
replace bubba = first_report_group * game_reported
egen first_game_reported_group = max(bubba), by(group_period)

drop bubba

label variable first_report_true_group "group's first report was true"
label variable first_report_lie_group "group's first report was a lie"
label variable first_game_reported_group "group's first report"

gen bubba = first_report_ind * truth
egen first_report_true = max(bubba), by(subject_period)
replace bubba = first_report_ind * lie
egen first_report_lie = max(bubba), by(subject_period)
replace bubba = first_report_ind * game_reported
egen first_game_reported = max(bubba), by(subject_period)

drop bubba

label variable first_report_true "subject's first report was true"
label variable first_report_lie "subject's first report was a lie"
label variable first_game_reported "first report"

gen bubba = last_report_ind * truth
egen last_report_true = max(bubba), by(subject_period)
replace bubba = last_report_ind * lie
egen last_report_lie = max(bubba), by(subject_period)
replace bubba = last_report_ind * game_reported
egen last_game_reported = max(bubba), by(subject_period)
drop bubba

gen subject_true_type = last_report_lie + 2*last_report_true
gen first_sub_true_type = first_report_lie + 2*first_report_true
label define subtypes 0 "never_report" 1 "lie" 2 "truth"
label values subject_true_type subtypes
label values first_sub_true_type subtypes
gen changed_report = (first_game_reported != last_game_reported)

label variable last_report_true "subject's last report was true"
label variable last_report_lie "subject's last report was a lie"
label variable last_game_reported "last report"
label variable subject_true_type "Final Report Type, by subject"
label values subject_true_type subtypes
label variable changed_report "changed report during period"

gen bubba1 = first_sub_true_type * (type == 1)
gen bubba2 = first_sub_true_type * (type == 2)
egen first_sub_true_type_1 = max(bubba1), by(group_period)
egen first_sub_true_type_2 = max(bubba2), by(group_period)
label values first_sub_true_type_1 subtypes
label values first_sub_true_type_2 subtypes
gen other_first_true = (first_sub_true_type_1 == 2)*(type == 2)+(first_sub_true_type_2 == 2)*(type == 1)
drop bubba1 bubba2

label variable first_sub_true_type_1 "subject first true type, Agent 1"
label variable first_sub_true_type_2 "subject first true type, Agent 2"
label variable other_first_true "other subject intially told truth"

gen bubba1 = subject_true_type * (type == 1)
gen bubba2 = subject_true_type * (type == 2)
egen subject_true_type_1 = max(bubba1), by(group_period)
egen subject_true_type_2 = max(bubba2), by(group_period)
label values subject_true_type_1 subtypes
label values subject_true_type_2 subtypes
drop bubba1 bubba2

label variable subject_true_type_1 "subject true type, Agent 1"
label variable subject_true_type_2 "subject true type, Agent 2"

gen revealed = (subject_true_type_1 == 0)*(subject_true_type_2 == 2) + (subject_true_type_1 == 2)*(subject_true_type_2 == 0) + (subject_true_type_1 == 2)*(subject_true_type_2 == 2) 

label variable revealed "true game revealed, no contradiction"

gen bubba = revealed * last_message_group
egen revealed_block = sum(bubba), by(global_group_late)
replace revealed_block = revealed_block/9
drop bubba

label variable revealed_block "% game revealed, 9 period block"

gen no_message = (messagecode == -999)

label variable no_message "individual did not send message in period"

gen bubba = messagecode != -999
egen number_messages = sum(bubba), by(subject_period)
drop bubba

label variable number_messages "number of messages in period"

egen number_reports = sum(report_game), by(subject_period)

label variable number_reports "number of reports in period"

gen never_report = (number_reports == 0)

label variable never_report "never reported game"

gen manager_mistake = (1 - coordinate) + coordinate*(strategy1 > max(game,3)) + coordinate*(strategy1 < min(game,3))

label variable manager_mistake "error by manager as defined in Section 5"

gen bubba = messagecode == 23
gen bubba2 = messagecode == 21
egen column_true = max(bubba), by(group_period)
egen row_true = max(bubba2), by(group_period)
drop bubba bubba2

gen bubba = (type == 1)* (messagecode == 24)
gen bubba2 = (type == 2)* (messagecode == 22)
egen accuse_col = max(bubba), by(group_period)
egen accuse_row = max(bubba2), by(group_period)
drop bubba bubba2

gen accused = accuse_row * (type ==1) + accuse_col * (type == 2)
gen fact_checked = first_report_lie * accused * (type != 0)

label variable column_true "report column told the truth"
label variable row_true "report row told the truth"
label variable accuse_col "row accuses column of lying"
label variable accuse_row "column accuses row of lying"
label variable accused "accused of lying"
label variable fact_checked "lied, accused of lying"

sort last_message_group global_group period
gen bubba = revealed[_n-1]
replace bubba = 0 if last_message_group == 0
replace bubba = -999 if period == 1
egen lag_revealed = max(bubba),by(group_period)
drop bubba

sort last_message_ind global_subject period
gen bubba = fact_checked[_n-1]
replace bubba = 0 if last_message_ind == 0
replace bubba = -999 if period == 1
egen lag_fact_checked = max(bubba),by(subject_period)
drop bubba

label variable lag_fact_checked "lagged value, fact_checked"

gen bubba = subject_true_type[_n-1]
replace bubba = 0 if last_message_ind == 0
replace bubba = -999 if period == 1
egen lag_subject_true_type = max(bubba),by(subject_period)
drop bubba

label variable lag_subject_true_type "lagged value, fact_checked"

gen alt_surplus = (1 - manager_mistake*revealed)*payoff_manager + manager_mistake * revealed * babble_surplus

label variable alt_surplus "replace surplus with babbling for manager mistakes"

gen bubba = report_game * time + (1 - report_game)*10000
egen first_report_time = min(bubba) , by(group_period)
replace bubba = report_game * time * (type == 1) + (1 - report_game*(type==1))*10000
egen first_report_time_1 = min(bubba) , by(group_period)
replace bubba = report_game * time * (type == 2) + (1 - report_game*(type==2))*10000
egen first_report_time_2 = min(bubba) , by(group_period)

label variable first_report_time "time of first report, group"
label variable first_report_time_1 "time of first report, agent 1"
label variable first_report_time_2 "time of first report, agent 2"

gen bubba2 = (messagecode == 1)*(time <= first_report_time)
gen bubba3 = (messagecode == 2)*(time <= first_report_time)
egen early_askgame = max(bubba2), by(group_period)
egen early_askfortruth = max(bubba3), by(group_period)
drop bubba bubba2 bubba3

label variable early_askgame "ask what game is before first report"
label variable early_askfortruth "ask for truth before first report"

gen first_reporter = (type == 1)*(first_report_time_1 <= first_report_time_2) + (type == 2)*(first_report_time_2 <= first_report_time_1)
replace first_reporter = first_reporter * (number_reports > .5)

gen alt_first_reporter = (type == 1)*(first_report_time_1 < first_report_time_2) + (type == 2)*(first_report_time_2 < first_report_time_1)
replace alt_first_reporter = alt_first_reporter * (number_reports > .5)

label variable first_reporter "reported first"
label variable alt_first_reporter "strictly reported first"


* for Table 9
* use Table 2 for first four rows

summarize payoff_manager if late & last_message_group

summarize efficiency_gain_block if period == 10 & last_message_group

summarize coordinate if late & last_message_group

summarize coordinate_efficient if late & last_message_group & coordinate

summarize revealed if late & last_message_group 

tab subject_true_type if last_message_ind & late & type != 0

* paragraphs following Table 9 (also see lower for tests between treatments)
* Note: non-parametric tests below

tab no_message if last_message_ind & late

summarize number_messages if last_message_ind & late

* fn 30

tab type if last_message_ind & late, summarize(number_messages)

* use output from preceding command to generate weighted average over agents

display (7.535 + 7.218)/2

* return to main text

tab subject_true_type_1 subject_true_type_2 if last_message_group & late & 1 - revealed

* use output from preceding command to calculate frequency of 1 true & 1 lies if not truth not revealed

display 102/122

* why total surplus not higher

tab revealed if last_message_group & late, summarize(payoff_manager)

summarize manager_mistake if revealed & last_message_group & late

* fn 33

summarize payoff_manager alt_surplus if late & last_message_group

* fact checking frequency & changes

summarize accused if first_report_lie & last_message_ind & late & type != 0
summarize last_report_lie if first_report_lie & last_message_ind & late & accused & type != 0

tab2  subject_true_type lag_fact_checked if late & type > .5 & last_message_ind & lag_subject_true_type == 1, col
xi: dprobit last_report_lie lag_fact_checked  i.modgame i.period if late & last_message_ind & type > .5 & lag_subject_true_type == 1, cluster(global_group)


* fn 34

summarize changed_report if number_report >= 1 & late & last_message_ind & type != 0

* effects of asking game, asking for truth

summarize early_askgame early_askfortruth if late & last_message_group
tab early_askgame if late & last_message_group, summarize(revealed)
tab early_askfortruth if late & last_message_group, summarize(revealed)
xi: dprobit revealed early_askgame early_askfortruth lag_reveal i.period i.game if last_message_group & late, cluster(global_group)

* claiming to be truthful

summarize ever_claim_truth if last_message_ind & number_reports > 0 & late
tab ever_claim_truth if last_message_ind & number_reports > 0 & late, summarize(last_report_lie)

* asynchronous reporting

tab first_reporter if number_reports > 0 & late & last_message_ind & type > .5, summarize(first_report_true)
tab modgame  if late & last_message_ind & type > .5, summarize(first_reporter)
xi: dprobit last_report_true first_reporter i.modgame i.period if number_reports > 0  & late & last_message_ind & type > .5  , cluster(global_group)
tab first_report_true_group if  late & last_message_ind & type > .5 & 1 - first_reporter, summarize(first_report_lie)
tab first_report_true_group if  late & last_message_ind & type > .5 & 1 - first_reporter, summarize(never_report)
xi: dprobit first_report_lie first_report_true_group i.period i.modgame if  late & last_message_ind & type > .5 & 1 - first_reporter, cluster(global_group)
xi: mlogit first_sub_true_type other_first_true i.modgame i.period if  late & last_message_ind & type > .5 & 1 - first_reporter , cluster(global_group) base(1)

* fn 36

tab alt_first_reporter if number_report > .5 & late & last_message_ind & type > .5, summarize(first_report_true)

* forced vs. voluntary reporting

tab never_report if type > .5 & late & last_message_ind

tab subject_true_type_2 if type == 1 & late & last_message_ind & never_report
tab subject_true_type_1 if type == 2 & late & last_message_ind & never_report

* combine results from preceding two commands to calculate frequency other agent reports truth if agent doesn't report and other agent does

display 35/36

tab subject_true_type_2 if type == 1 & late & last_message_ind & never_report, summarize(column_true)
tab subject_true_type_1 if type == 2 & late & last_message_ind & never_report, summarize(row_true)

* calculate average using output from preceding two commands
* multiple percent saying other told the truth by frequency to get number who don't report but say the other told the truth

display 22/35

* for generating non-parametric after Table 9

gen part_cent = 0
gen ec_cent = 1
gen chat_cent = 0

keep  if period == 10 & last_message_group
rename babble_surplus_block new_babble_surplus_block

keep part_cent ec_cent chat_cent surplus_block new_babble_surplus_block revealed_block global_group

order part_cent ec_cent chat_cent surplus_block new_babble_surplus_block revealed_block global_group

save "for Section 5 non-parametrics, n2.dta", replace

use "for Section 5 non-parametrics.dta", replace

append using "for Section 5 non-parametrics, n2.dta"

save "for Section 5 non-parametrics, merged.dta", replace

*****************************************************************************************************************************************************************************************
*****************************************************************************************************************************************************************************************
*****************************************************************************************************************************************************************************************
*****************************************************************************************************************************************************************************************

* Section 5, non-parametric tests

ranksum surplus_block if part_cent + ec_cent, by(ec_cent)

signrank surplus_block = new_babble_surplus_block if ec_cent

ranksum surplus_block if chat_cent + ec_cent, by(ec_cent)

ranksum revealed_block if part_cent + ec_cent, by(ec_cent)

ranksum revealed_block if chat_cent + ec_cent, by(ec_cent)

