use datapaper_anonymized.dta, replace


****************************
*** 2.1 DELAYED DECISION ***
****************************

tab communication delay						// "Treatment conditions, with number of subjects in parentheses."


**********************
*** 2.2 PROCEDURES ***
**********************

bysort session : gen counter = _n	
count if counter == 1						// "We conducted 40 experimental sessions..."	
count										// "...with a total of 707 student subjects"
drop counter


***********************
*** 3.1.1 ATTRITION ***
***********************

tab role firstquest							// "Only 0.8 percent of trustees (2.3 percent of trustors) did not complete Q1"
tab role secondquest						// "5.1 percent of trustees (7.4 percent of trustors) did not complete Q2"

tab delay firstquest if role == 1			// "For trustees in the EARLY delay condition, the Q1 attrition rate is 1.7 percent"
tab delay secondquest if role == 1			// "for trustees in the LATE delay, the Q2 attrition rate is 3.3 percent."
tab delay secondquest if role == 1, chi2	// "18 trustees did not complete Q2: 9 out of 115 in IMM, 5 out of 118 in EARLY, and 4 out of 121 in LATE, p = 0.25, χ2 test."

tab delay secondquest if role == 0, chi2	// "13 out of 115 in IMM, 9 out of 118 in EARLY, and 4 out of 120 in LATE, p=0.06, χ2 test."


*********************
*** 3.1.2 CHOICES ***
*********************

tab numrolls if role == 1	// "42 percent of trustees never chose ROLL, 33 percent always chose ROLL, and 25 percent chose ROLL for 1 to 9 out of the 10 decisions."
tab numins if role == 0		// "32 percent only chose OUT, 29 percent only chose IN, and 39 percent chose a combination"

kwallis numrolls if communication == 0 & role == 1, by(delay)	// "None of the tests are significant: ROLL NOCOMM p = 0.778,..."
kwallis numrolls if communication == 1 & role == 1, by(delay)	// "...ROLL COMM p = 0.885,..."
kwallis numins if communication == 0, by(delay)					// "...IN NOCOMM p = 0.507,..."
kwallis numins if communication == 1, by(delay)					// "...IN COMM p = 0.911, Kruskal-Wallis tests."
	
* Figure 2: (a) ROLL decisions of trustees

preserve

reg numrolls EarlyNoComm LateNoComm ImmComm EarlyComm LateComm if role == 1, cluster(session)

local b_IN = _b[_cons]
local b_EN = _b[EarlyNoComm]
local b_LN = _b[LateNoComm]
local b_IC = _b[ImmComm]
local b_EC = _b[EarlyComm]
local b_LC = _b[LateComm]

local se_IN = _se[_cons]
local se_EN = _se[EarlyNoComm]
local se_LN = _se[LateNoComm]
local se_IC = _se[ImmComm]
local se_EC = _se[EarlyComm]
local se_LC = _se[LateComm]

clear
set obs 6

gen treatment = _n
gen oldtreatment = mod(treatment-1,3)
replace treatment = treatment + 0.5 if treatment > 3

gen numrolls = `b_IN'
replace numrolls = numrolls + `b_EN' in 2
replace numrolls = numrolls + `b_LN' in 3
replace numrolls = numrolls + `b_IC' in 4
replace numrolls = numrolls + `b_EC' in 5
replace numrolls = numrolls + `b_LC' in 6

gen low = numrolls
replace low = low - `se_IN' in 1
replace low = low - `se_EN' in 2
replace low = low - `se_LN' in 3
replace low = low - `se_IC' in 4
replace low = low - `se_EC' in 5
replace low = low - `se_LC' in 6

gen high = numrolls
replace high = high +`se_IN' in 1
replace high = high + `se_EN' in 2
replace high = high + `se_LN' in 3
replace high = high + `se_IC' in 4
replace high = high + `se_EC' in 5
replace high = high + `se_LC' in 6

list

tw (bar numrolls treatment if oldtreatment == 0, barwidth(0.8) lcolor(gs0) color("0 40 165")) ///
	(bar numrolls treatment if oldtreatment == 1, barwidth(0.8) lcolor(gs0) color("115 137 205")) ///
	(bar numrolls treatment if oldtreatment == 2, barwidth(0.8) lcolor(gs0) color("231 235 246")) ///
	(rcap low high treatment, lcolor(black)), /// 
	ytitle("Average Number of ROLL choices") xtitle("") text(9 2 "NOCOMM") text(9 5.5 "COMM") ///
	xlabel(1 "IMM" 2 "EARLY" 3 "LATE" 4.5 "IMM" 5.5 "EARLY" 6.5 "LATE", noticks) ///
	graphregion(fcolor(white)) xsize(4) plotregion(margin(b=0)) legend(off) ///
	ylabel(0(2)10, glcolor(gs14) glwidth(thin))

restore

* Figure 2: (b) IN decisions of trustors
preserve

reg numins EarlyNoComm LateNoComm ImmComm EarlyComm LateComm if role == 0, cluster(session)

local b_IN = _b[_cons]
local b_EN = _b[EarlyNoComm]
local b_LN = _b[LateNoComm]
local b_IC = _b[ImmComm]
local b_EC = _b[EarlyComm]
local b_LC = _b[LateComm]

local se_IN = _se[_cons]
local se_EN = _se[EarlyNoComm]
local se_LN = _se[LateNoComm]
local se_IC = _se[ImmComm]
local se_EC = _se[EarlyComm]
local se_LC = _se[LateComm]

clear
set obs 6

gen treatment = _n
gen oldtreatment = mod(treatment-1,3)
replace treatment = treatment + 0.5 if treatment > 3

gen numins = `b_IN'
replace numins = numins + `b_EN' in 2
replace numins = numins + `b_LN' in 3
replace numins = numins + `b_IC' in 4
replace numins = numins + `b_EC' in 5
replace numins = numins + `b_LC' in 6

gen low = numins
replace low = low - `se_IN' in 1
replace low = low - `se_EN' in 2
replace low = low - `se_LN' in 3
replace low = low - `se_IC' in 4
replace low = low - `se_EC' in 5
replace low = low - `se_LC' in 6

gen high = numins
replace high = high +`se_IN' in 1
replace high = high + `se_EN' in 2
replace high = high + `se_LN' in 3
replace high = high + `se_IC' in 4
replace high = high + `se_EC' in 5
replace high = high + `se_LC' in 6

list

tw	(bar numins treatment if oldtreatment == 0, barwidth(0.8) lcolor(gs0) color("0 40 165")) ///
	(bar numins treatment if oldtreatment == 1, barwidth(0.8) lcolor(gs0) color("115 137 205")) ///
	(bar numins treatment if oldtreatment == 2, barwidth(0.8) lcolor(gs0) color("231 235 246")) ///
	(rcap low high treatment, lcolor(black)), /// 
	ytitle("Percent IN choices") xtitle("") text(9 2 "NOCOMM") text(9 5.5 "COMM") ///
	xlabel(1 "IMM" 2 "EARLY" 3 "LATE" 4.5 "IMM" 5.5 "EARLY" 6.5 "LATE", noticks) ///
	graphregion(fcolor(white)) plotregion(margin(b=0)) xsize(4) legend(off) ///
	ylabel(0(2)10, glcolor(gs14) glwidth(thin))

restore

tabstat numrolls if !communication & role, by(delay)	// "When there is no communication, trustees choose to roll on average between 35 percent to 38 percent of the time"
tabstat numrolls if communication & role, by(delay)		// "... this number increases to around 54 to 57 percent of the time when communication is possible."
tabstat numins if !role, by(communication) 				// "trustors increase their IN choices by roughly 20 percentage points" (= about two additional IN choices)

* "All twelve pairwise comparisons between delay conditions are statistically insignificant."
forvalues delay = 0/2 {
	forvalues comm = 0/1 {
		ranksum numrolls if delay != `delay' & communication == `comm' & role, by(delay)
	}
}
forvalues delay = 0/2 {
	forvalues comm = 0/1 {
		ranksum numins if delay != `delay' & communication == `comm' & !role, by(delay)
	}
}

* Table 2: Behavior of Trustees and Trustors

* ROLL
reg numrolls Early Late communication EarlyComm LateComm time risk age female if role == 1, cluster(session)
test communication + EarlyComm = 0			// "Communication raises the ROLL rate... by 1.91 in EARLY (p = 0.089)" 
test communication + LateComm = 0			// "... by 1.77 in LATE (p = 0.006)"
test Early + EarlyComm = 0 					// "There is no statistical difference between the IMM and EARLY conditions... COMM: p = 0.859"
test Late + LateComm = 0					// "IMM and LATE (... p = 0.565)"
test Early = Late							// "EARLY and LATE (p = 0.983, ..."
test Early + EarlyComm = Late + LateComm	// "p = 0.854)."

* IN
reg numins Early Late communication EarlyComm LateComm time risk age female if role == 0, cluster(session)
test communication + EarlyComm = 0			// "Communication significantly raises trust in all three delay conditions (..., EARLY: p = 0.005" 
test communication + LateComm = 0			// ", LATE: p = 0.019)"
test Early + EarlyComm = 0					// "[IMM vs. EARLY] COMM p = 0.932"
test Late + LateComm = 0					// "[IMM vs. LATE COMM]p = 0.659"
test Early = Late 							// "EARLY vs. LATE [NOCOMM]: p = 0.076"
test Early + EarlyComm = Late + LateComm	// "[EARLY vs. LATE COMM]p = 0.699"

**********************
*** 3.1.3 PROMISES ***
**********************

tabstat is_promise if role & communication, by(delay)		// "66 percent of trustees in COMM-IMM make a promise, 75 in COMM- EARLY, and 69 in COMM-LATE"
tab is_promise delay if role & communication, chi2			// "The rate of promises is not systematically different across the delay conditions (p = 0.538, χ2 test)."

// "using the most recent Linguistic Inquiry Word Count (LIWC2015) model , a widely used linguistic algorithm designed to detect deception in speech or writing, we do not detect any differences in the authenticity scores of messages across the delay conditions."
* export delimited Message using messages_IMM if role & communication & delay == 0, novarnames
* export delimited Message using messages_EARLY if role & communication & delay == 1, novarnames
* export delimited Message using messages_LATE if role & communication & delay == 2, novarnames
// Analyze the three resulting csv files with LIWC2015 (proprietary, see readme), compare authenticity score
// LIWC2015 home: https://liwc.wpengine.com; manual: https://s3-us-west-2.amazonaws.com/downloads.liwc.net/LIWC2015_OperatorManual.pdf

gen no_message = Message == ""
tab no_message delay if role & communication, chi2 				// "13 out of 172 COMM trustees chose to send an empty message (5 in COMM-IMM, and 4 each in COMM-EARLY and COMM-LATE, p=0.931, chi2 test)"

gen num_words = wordcount(Message)
tabstat num_words if role & communication, by(delay) s(n mean)	// "the average number of words written was significantly greater in EARLY (39 words) than in LATE (30 words) and IMM (27 words)."
kwallis num_words if role & communication, by(delay)  			// "This difference is significant ($p=0.026$, Kruskal-Wallis test)"

tabstat numrolls if role & communication, by(is_promise) // "Those who made promises have an even higher ROLL rate of 6.2 ROLL choices on average. In contrast, those who did not make a promise have a lower ROLL rate of 4.2"

reg numrolls communication is_promise if role, cluster(session) // "insignificant coefficient for communication condition without promise (p = 0.525) and a significant additional effect of actually making a promise (p = 0.043)"

gen pure = numrolls == 10 | numrolls == 0
tab pure if role										// "Only 25 percent of trustees choose a mixture of the two choices while 75 percent choose either ten times ROLL or ten times DON’T ROLL"

tabstat pure if role & communication, by(is_promise)	// "the exclusive use of either one of the two choices is higher if the trustee made a promise (77 percent) than if she did not make a promise (63 percent)"
tab pure is_promise if role & communication, chi2 		// "this difference is only marginally significant (p = 0.074, χ2 test)"


****************************
*** 3.1.4 MESSAGE RECALL ***
****************************

tab is_promise recalled_as_promise if communication & role & !recall_missing // "92.3 percent are classified in the same category as the original message. Recall accuracy was similar for those who originally made a promise (93.4 percent) and those who did not (89.8 percent)."

tab is_promise recalled_as_promise if communication & role & !recall_missing & delay == 2 // "messages from the LATE condition still have a category concordance of 90.2 percent with 88.5 percent of original messages containing a promise."

tabstat numrolls if communication & role & !recall_missing, by(recalled_as_promise)	// "Trustees who did not remember making a concrete promise had an average rate of 3.9 ROLL choices, while those who did remember doing so had a rate of 6.4 ROLL choices."


*******************
*** 3.2 BELIEFS ***
*******************

* Figure 3

* Panel (a) 1BM(ROLL)

preserve

reg Belief2 EarlyNoComm LateNoComm ImmComm EarlyComm LateComm if role == 0, cluster(session)
lincom _b[EarlyNoComm]
lincom _b[LateNoComm]
lincom _b[LateNoComm]-_b[EarlyNoComm]
lincom _b[EarlyComm]-_b[ImmComm]
lincom _b[LateComm]-_b[ImmComm]
lincom _b[LateComm]-_b[EarlyComm]

gen insample = e(sample)

local b_IN = _b[_cons]
local b_EN = _b[EarlyNoComm]
local b_LN = _b[LateNoComm]
local b_IC = _b[ImmComm]
local b_EC = _b[EarlyComm]
local b_LC = _b[LateComm]

local se_IN = _se[_cons]
local se_EN = _se[EarlyNoComm]
local se_LN = _se[LateNoComm]
local se_IC = _se[ImmComm]
local se_EC = _se[EarlyComm]
local se_LC = _se[LateComm]

clear
set obs 6

gen treatment = _n
gen oldtreatment = mod(treatment-1,3)
replace treatment = treatment + 0.5 if treatment > 3

gen Belief2 = `b_IN'
replace Belief2 = Belief2 + `b_EN' in 2
replace Belief2 = Belief2 + `b_LN' in 3
replace Belief2 = Belief2 + `b_IC' in 4
replace Belief2 = Belief2 + `b_EC' in 5
replace Belief2 = Belief2 + `b_LC' in 6

gen low = Belief2
replace low = low - `se_IN' in 1
replace low = low - `se_EN' in 2
replace low = low - `se_LN' in 3
replace low = low - `se_IC' in 4
replace low = low - `se_EC' in 5
replace low = low - `se_LC' in 6

gen high = Belief2
replace high = high +`se_IN' in 1
replace high = high + `se_EN' in 2
replace high = high + `se_LN' in 3
replace high = high + `se_IC' in 4
replace high = high + `se_EC' in 5
replace high = high + `se_LC' in 6

list

tw (bar Belief2 treatment if oldtreatment == 0, barwidth(0.8) lcolor(gs0) color("0 40 165")) ///
	(bar Belief2 treatment if oldtreatment == 1, barwidth(0.8) lcolor(gs0) color("115 137 205")) ///
	(bar Belief2 treatment if oldtreatment == 2, barwidth(0.8) lcolor(gs0) color("231 235 246")) ///
	(rcap low high treatment, lcolor(black)), /// 
	ytitle("Average number ROLL choices (1BM)") xtitle("") text(9 2 "NOCOMM") text(9 5.5 "COMM") ///
	xlabel(1 "IMM" 2 "EARLY" 3 "LATE" 4.5 "IMM" 5.5 "EARLY" 6.5 "LATE", noticks) ///
	graphregion(fcolor(white)) plotregion(margin(b=0)) xsize(4) legend(off) ///
	ylabel(0(2)10, glcolor(gs14) glwidth(thin))
	
restore

* Panel (d) 1BM(IN)

preserve

reg Belief2 EarlyNoComm LateNoComm ImmComm EarlyComm LateComm if role == 1, cluster(session)

local b_IN = _b[_cons]
local b_EN = _b[EarlyNoComm]
local b_LN = _b[LateNoComm]
local b_IC = _b[ImmComm]
local b_EC = _b[EarlyComm]
local b_LC = _b[LateComm]

local se_IN = _se[_cons]
local se_EN = _se[EarlyNoComm]
local se_LN = _se[LateNoComm]
local se_IC = _se[ImmComm]
local se_EC = _se[EarlyComm]
local se_LC = _se[LateComm]

clear
set obs 6

gen treatment = _n
gen oldtreatment = mod(treatment-1,3)
replace treatment = treatment + 0.5 if treatment > 3

gen Belief2 = `b_IN'
replace Belief2 = Belief2 + `b_EN' in 2
replace Belief2 = Belief2 + `b_LN' in 3
replace Belief2 = Belief2 + `b_IC' in 4
replace Belief2 = Belief2 + `b_EC' in 5
replace Belief2 = Belief2 + `b_LC' in 6

gen low = Belief2
replace low = low - `se_IN' in 1
replace low = low - `se_EN' in 2
replace low = low - `se_LN' in 3
replace low = low - `se_IC' in 4
replace low = low - `se_EC' in 5
replace low = low - `se_LC' in 6

gen high = Belief2
replace high = high +`se_IN' in 1
replace high = high + `se_EN' in 2
replace high = high + `se_LN' in 3
replace high = high + `se_IC' in 4
replace high = high + `se_EC' in 5
replace high = high + `se_LC' in 6

list

tw (bar Belief2 treatment if oldtreatment == 0, barwidth(0.8) lcolor(gs0) color("0 40 165")) ///
	(bar Belief2 treatment if oldtreatment == 1, barwidth(0.8) lcolor(gs0) color("115 137 205")) ///
	(bar Belief2 treatment if oldtreatment == 2, barwidth(0.8) lcolor(gs0) color("231 235 246")) ///
	(rcap low high treatment, lcolor(black)), /// 
	ytitle("Average number IN choices (1BM)") xtitle("") text(9 2 "NOCOMM") text(9 5.5 "COMM") ///
	xlabel(1 "IMM" 2 "EARLY" 3 "LATE" 4.5 "IMM" 5.5 "EARLY" 6.5 "LATE", noticks) ///
	graphregion(fcolor(white)) plotregion(margin(b=0)) xsize(4) legend(off) ///
	ylabel(0(2)10, glcolor(gs14) glwidth(thin))

restore

* Panel (b) 1BG(ROLL)

preserve

reg Belief EarlyNoComm LateNoComm ImmComm EarlyComm LateComm if role == 0, cluster(session)

local b_IN = _b[_cons]
local b_EN = _b[EarlyNoComm]
local b_LN = _b[LateNoComm]
local b_IC = _b[ImmComm]
local b_EC = _b[EarlyComm]
local b_LC = _b[LateComm]

local se_IN = _se[_cons]
local se_EN = _se[EarlyNoComm]
local se_LN = _se[LateNoComm]
local se_IC = _se[ImmComm]
local se_EC = _se[EarlyComm]
local se_LC = _se[LateComm]

clear
set obs 6

gen treatment = _n
gen oldtreatment = mod(treatment-1,3)
replace treatment = treatment + 0.5 if treatment > 3

gen Belief2 = `b_IN'
replace Belief2 = Belief2 + `b_EN' in 2
replace Belief2 = Belief2 + `b_LN' in 3
replace Belief2 = Belief2 + `b_IC' in 4
replace Belief2 = Belief2 + `b_EC' in 5
replace Belief2 = Belief2 + `b_LC' in 6

gen low = Belief2
replace low = low - `se_IN' in 1
replace low = low - `se_EN' in 2
replace low = low - `se_LN' in 3
replace low = low - `se_IC' in 4
replace low = low - `se_EC' in 5
replace low = low - `se_LC' in 6

gen high = Belief2
replace high = high + `se_IN' in 1
replace high = high + `se_EN' in 2
replace high = high + `se_LN' in 3
replace high = high + `se_IC' in 4
replace high = high + `se_EC' in 5
replace high = high + `se_LC' in 6

list

tw (bar Belief2 treatment if oldtreatment == 0, barwidth(0.8) lcolor(gs0) color("0 40 165")) ///
	(bar Belief2 treatment if oldtreatment == 1, barwidth(0.8) lcolor(gs0) color("115 137 205")) ///
	(bar Belief2 treatment if oldtreatment == 2, barwidth(0.8) lcolor(gs0) color("231 235 246")) ///
	(rcap low high treatment, lcolor(black)), /// 
	ytitle("Percent ROLL choices (1BG)") xtitle("") text(90 2 "NOCOMM") text(90 5.5 "COMM") ///
	xlabel(1 "IMM" 2 "EARLY" 3 "LATE" 4.5 "IMM" 5.5 "EARLY" 6.5 "LATE", noticks) ///
	graphregion(fcolor(white)) plotregion(margin(b=0)) xsize(4) legend(off) ///
	ylabel(0(20)100, glcolor(gs14) glwidth(thin))
	
restore

* Panel (e) 1BG(IN)

preserve

reg Belief EarlyNoComm LateNoComm ImmComm EarlyComm LateComm if role == 1, cluster(session)

local b_IN = _b[_cons]
local b_EN = _b[EarlyNoComm]
local b_LN = _b[LateNoComm]
local b_IC = _b[ImmComm]
local b_EC = _b[EarlyComm]
local b_LC = _b[LateComm]

local se_IN = _se[_cons]
local se_EN = _se[EarlyNoComm]
local se_LN = _se[LateNoComm]
local se_IC = _se[ImmComm]
local se_EC = _se[EarlyComm]
local se_LC = _se[LateComm]

clear
set obs 6

gen treatment = _n
gen oldtreatment = mod(treatment-1,3)
replace treatment = treatment + 0.5 if treatment > 3

gen Belief2 = `b_IN'
replace Belief2 = Belief2 + `b_EN' in 2
replace Belief2 = Belief2 + `b_LN' in 3
replace Belief2 = Belief2 + `b_IC' in 4
replace Belief2 = Belief2 + `b_EC' in 5
replace Belief2 = Belief2 + `b_LC' in 6

gen low = Belief2
replace low = low - `se_IN' in 1
replace low = low - `se_EN' in 2
replace low = low - `se_LN' in 3
replace low = low - `se_IC' in 4
replace low = low - `se_EC' in 5
replace low = low - `se_LC' in 6

gen high = Belief2
replace high = high + `se_IN' in 1
replace high = high + `se_EN' in 2
replace high = high + `se_LN' in 3
replace high = high + `se_IC' in 4
replace high = high + `se_EC' in 5
replace high = high + `se_LC' in 6

list

tw (bar Belief2 treatment if oldtreatment == 0, barwidth(0.8) lcolor(gs0) color("0 40 165")) ///
	(bar Belief2 treatment if oldtreatment == 1, barwidth(0.8) lcolor(gs0) color("115 137 205")) ///
	(bar Belief2 treatment if oldtreatment == 2, barwidth(0.8) lcolor(gs0) color("231 235 246")) ///
	(rcap low high treatment, lcolor(black)), /// 
	ytitle("Percent IN choices (1BG)") xtitle("") text(90 2 "NOCOMM") text(90 5.5 "COMM") ///
	xlabel(1 "IMM" 2 "EARLY" 3 "LATE" 4.5 "IMM" 5.5 "EARLY" 6.5 "LATE", noticks) ///
	graphregion(fcolor(white)) plotregion(margin(b=0)) xsize(4) legend(off) ///
	ylabel(0(20)100, glcolor(gs14) glwidth(thin))
	
restore

* Panel (f) 1BO(ROLL)

preserve

reg BeliefOtherGroup ImmNoComm EarlyNoComm ImmComm EarlyComm LateComm if role == 0, cluster(session)

local b_LN = _b[_cons]
local b_EN = _b[EarlyNoComm]
local b_IN = _b[ImmNoComm]
local b_IC = _b[ImmComm]
local b_EC = _b[EarlyComm]
local b_LC = _b[LateComm]

local se_LN = _se[_cons]
local se_EN = _se[EarlyNoComm]
local se_IN = _se[ImmNoComm]
local se_IC = _se[ImmComm]
local se_EC = _se[EarlyComm]
local se_LC = _se[LateComm]

clear
set obs 6

gen treatment = _n
gen oldtreatment = mod(treatment-1,3)
replace treatment = treatment + 0.5 if treatment > 3

gen Belief2 = `b_LN'
replace Belief2 = Belief2 + `b_IN' in 2
replace Belief2 = Belief2 + `b_EN' in 3
replace Belief2 = Belief2 + `b_LC' in 4
replace Belief2 = Belief2 + `b_IC' in 5
replace Belief2 = Belief2 + `b_EC' in 6

gen low = Belief2
replace low = low - `se_LN' in 1
replace low = low - `se_IN' in 2
replace low = low - `se_EN' in 3
replace low = low - `se_LC' in 4
replace low = low - `se_IC' in 5
replace low = low - `se_EC' in 6

gen high = Belief2
replace high = high + `se_LN' in 1
replace high = high + `se_IN' in 2
replace high = high + `se_EN' in 3
replace high = high + `se_LC' in 4
replace high = high + `se_IC' in 5
replace high = high + `se_EC' in 6

list

tw (bar Belief2 treatment if oldtreatment == 0, barwidth(0.8) lcolor(gs0) color("0 40 165")) ///
	(bar Belief2 treatment if oldtreatment == 1, barwidth(0.8) lcolor(gs0) color("115 137 205")) ///
	(bar Belief2 treatment if oldtreatment == 2, barwidth(0.8) lcolor(gs0) color("231 235 246")) ///
	(rcap low high treatment, lcolor(black)), /// 
	ytitle("Percent ROLL choices (1BO)") xtitle("") text(90 2 "NOCOMM") text(90 5.5 "COMM") ///
	xlabel(1 `" "EARLY" "bel. LATE" "' 2 `" "LATE" "bel. IMM" "' 3 `" "LATE" "bel. EARLY" "' 4.5 `" "EARLY" "bel. LATE" "' 5.5 `" "LATE" "bel. IMM" "' 6.5`" "LATE" "bel. EARLY" "', noticks labsize(vsmall)) ///
	graphregion(fcolor(white)) plotregion(margin(b=0)) xsize(4) legend(off) ///
	ylabel(0(20)100, glcolor(gs14) glwidth(thin))
	
restore

* Panel (g) 1BO(IN)

preserve

reg BeliefOtherGroup ImmNoComm EarlyNoComm ImmComm EarlyComm LateComm if role == 1, cluster(session)

local b_LN = _b[_cons]
local b_EN = _b[EarlyNoComm]
local b_IN = _b[ImmNoComm]
local b_IC = _b[ImmComm]
local b_EC = _b[EarlyComm]
local b_LC = _b[LateComm]

local se_LN = _se[_cons]
local se_EN = _se[EarlyNoComm]
local se_IN = _se[ImmNoComm]
local se_IC = _se[ImmComm]
local se_EC = _se[EarlyComm]
local se_LC = _se[LateComm]

clear
set obs 6

gen treatment = _n
gen oldtreatment = mod(treatment-1,3)
replace treatment = treatment + 0.5 if treatment > 3

gen Belief2 = `b_LN'
replace Belief2 = Belief2 + `b_IN' in 2
replace Belief2 = Belief2 + `b_EN' in 3
replace Belief2 = Belief2 + `b_LC' in 4
replace Belief2 = Belief2 + `b_IC' in 5
replace Belief2 = Belief2 + `b_EC' in 6

gen low = Belief2
replace low = low - `se_LN' in 1
replace low = low - `se_IN' in 2
replace low = low - `se_EN' in 3
replace low = low - `se_LC' in 4
replace low = low - `se_IC' in 5
replace low = low - `se_EC' in 6

gen high = Belief2
replace high = high + `se_LN' in 1
replace high = high + `se_IN' in 2
replace high = high + `se_EN' in 3
replace high = high + `se_LC' in 4
replace high = high + `se_IC' in 5
replace high = high + `se_EC' in 6

list

tw (bar Belief2 treatment if oldtreatment == 0, barwidth(0.8) lcolor(gs0) color("0 40 165")) ///
	(bar Belief2 treatment if oldtreatment == 1, barwidth(0.8) lcolor(gs0) color("115 137 205")) ///
	(bar Belief2 treatment if oldtreatment == 2, barwidth(0.8) lcolor(gs0) color("231 235 246")) ///
	(rcap low high treatment, lcolor(black)), /// 
	ytitle("Percent IN choices (1BO)") xtitle("") text(90 2 "NOCOMM") text(90 5.5 "COMM") ///
	xlabel(1 `" "EARLY" "bel. LATE" "' 2 `" "LATE" "bel. IMM" "' 3 `" "LATE" "bel. EARLY" "' 4.5 `" "EARLY" "bel. LATE" "' 5.5 `" "LATE" "bel. IMM" "' 6.5`" "LATE" "bel. EARLY" "', noticks labsize(vsmall)) ///
	graphregion(fcolor(white)) plotregion(margin(b=0)) xsize(4) legend(off) ///
	ylabel(0(20)100, glcolor(gs14) glwidth(thin))
	
restore

*Panel (c) 2BM(ROLL)

preserve

reg Belief2nd EarlyNoComm LateNoComm ImmComm EarlyComm LateComm if role == 1, cluster(session)

local b_IN = _b[_cons]
local b_EN = _b[EarlyNoComm]
local b_LN = _b[LateNoComm]
local b_IC = _b[ImmComm]
local b_EC = _b[EarlyComm]
local b_LC = _b[LateComm]

local se_IN = _se[_cons]
local se_EN = _se[EarlyNoComm]
local se_LN = _se[LateNoComm]
local se_IC = _se[ImmComm]
local se_EC = _se[EarlyComm]
local se_LC = _se[LateComm]

clear
set obs 6

gen treatment = _n
gen oldtreatment = mod(treatment-1,3)
replace treatment = treatment + 0.5 if treatment > 3

gen Belief2 = `b_IN'
replace Belief2 = Belief2 + `b_EN' in 2
replace Belief2 = Belief2 + `b_LN' in 3
replace Belief2 = Belief2 + `b_IC' in 4
replace Belief2 = Belief2 + `b_EC' in 5
replace Belief2 = Belief2 + `b_LC' in 6

gen low = Belief2
replace low = low - `se_IN' in 1
replace low = low - `se_EN' in 2
replace low = low - `se_LN' in 3
replace low = low - `se_IC' in 4
replace low = low - `se_EC' in 5
replace low = low - `se_LC' in 6

gen high = Belief2
replace high = `b_IN' +`se_IN' in 1
replace high = high + `se_EN' in 2
replace high = high + `se_LN' in 3
replace high = high + `se_IC' in 4
replace high = high + `se_EC' in 5
replace high = high + `se_LC' in 6

list

tw (bar Belief2 treatment if oldtreatment == 0, barwidth(0.8) lcolor(gs0) color("0 40 165")) ///
	(bar Belief2 treatment if oldtreatment == 1, barwidth(0.8) lcolor(gs0) color("115 137 205")) ///
	(bar Belief2 treatment if oldtreatment == 2, barwidth(0.8) lcolor(gs0) color("231 235 246")) ///
	(rcap low high treatment, lcolor(black)), /// 
	ytitle("Average number ROLL choices (2BM)") xtitle("") text(9 2 "NOCOMM") text(9 5.5 "COMM") ///
	xlabel(1 "IMM" 2 "EARLY" 3 "LATE" 4.5 "IMM" 5.5 "EARLY" 6.5 "LATE", noticks) ///
	graphregion(fcolor(white)) plotregion(margin(b=0)) xsize(4) legend(off) ///
	ylabel(0(2)10, glcolor(gs14) glwidth(thin))
	
restore

// "All of the 21 pairwise comparisons of belief measures [...] show a positive effect of communication and 16 of them are significant (two-tailed p < 0.05)"
ttest Belief if role & delay == 0, by(communication) unequal
local p_1 = r(p)
ttest Belief if role & delay == 1, by(communication) unequal
local p_2 = r(p)
ttest Belief if role & delay == 2, by(communication) unequal
local p_3 = r(p)
ttest Belief if !role & delay == 0, by(communication) unequal
local p_4 = r(p)
ttest Belief if !role & delay == 1, by(communication) unequal
local p_5 = r(p)
ttest Belief if !role & delay == 2, by(communication) unequal
local p_6 = r(p)
ttest Belief2 if role & delay == 0, by(communication) unequal
local p_7 = r(p)
ttest Belief2 if role & delay == 1, by(communication) unequal
local p_8 = r(p)
ttest Belief2 if role & delay == 2, by(communication) unequal
local p_9 = r(p)
ttest Belief2 if !role & delay == 0, by(communication) unequal
local p_10 = r(p)
ttest Belief2 if !role & delay == 1, by(communication) unequal
local p_11 = r(p)
ttest Belief2 if !role & delay == 2, by(communication) unequal
local p_12 = r(p)
ttest BeliefOtherGroup if role & delay == 0, by(communication) unequal
local p_13 = r(p)
ttest BeliefOtherGroup if role & delay == 1, by(communication) unequal
local p_14 = r(p)
ttest BeliefOtherGroup if role & delay == 2, by(communication) unequal
local p_15 = r(p)
ttest BeliefOtherGroup if !role & delay == 0, by(communication) unequal
local p_16 = r(p)
ttest BeliefOtherGroup if !role & delay == 1, by(communication) unequal
local p_17 = r(p)
ttest BeliefOtherGroup if !role & delay == 2, by(communication) unequal
local p_18 = r(p)
ttest Belief2nd if role & delay == 0, by(communication) unequal
local p_19 = r(p)
ttest Belief2nd if role & delay == 1, by(communication) unequal
local p_20 = r(p)
ttest Belief2nd if role & delay == 2, by(communication) unequal
local p_21 = r(p)


// "Furthermore, 11 of these pairwise comparisons remain significant after applying a Holm-Bonferroni correction"
preserve

clear
set obs 21
gen p = .
gen holm_bonferroni_stars = ""

forvalues i = 1/21 {
	replace p = `p_`i'' in `i'
}

sort p

* holm-bonferroni
foreach alpha in 0.1 0.05 0.01 {
	local obs = 21

	forvalues i = 1/21 {
		local threshold = `alpha'/`obs'
		local p = p in `i'
		if `p' < `threshold' {
			replace holm_bonferroni_stars = holm_bonferroni_stars + "*" in `i'
			local obs = `obs' - 1
		}
		else break
	}
}

list

restore

// "there are a total of 42 pairwise comparisons of delay effects (IMM vs EARLY, IMM vs LATE, EARLY vs LATE across 2 communication conditions for 7 belief measures)."
local counter = 1
ttest Belief2 if role & !comm & delay != 0, by(delay) unequal
local p_`counter' = r(p)
local t_`counter' = r(t)
local counter = `counter' + 1
ttest Belief2 if role & !comm & delay != 1, by(delay) unequal
local p_`counter' = r(p)
local t_`counter' = r(t)
local counter = `counter' + 1
ttest Belief2 if role & !comm & delay != 2, by(delay) unequal
local p_`counter' = r(p)
local t_`counter' = r(t)
local counter = `counter' + 1
ttest Belief2 if role & comm & delay != 0, by(delay) unequal
local p_`counter' = r(p)
local t_`counter' = r(t)
local counter = `counter' + 1
ttest Belief2 if role & comm & delay != 1, by(delay) unequal
local p_`counter' = r(p)
local t_`counter' = r(t)
local counter = `counter' + 1
ttest Belief2 if role & comm & delay != 2, by(delay) unequal
local p_`counter' = r(p)
local t_`counter' = r(t)
local counter = `counter' + 1
ttest Belief2 if !role & !comm & delay != 0, by(delay) unequal
local p_`counter' = r(p)
local t_`counter' = r(t)
local counter = `counter' + 1
ttest Belief2 if !role & !comm & delay != 1, by(delay) unequal
local p_`counter' = r(p)
local t_`counter' = r(t)
local counter = `counter' + 1
ttest Belief2 if !role & !comm & delay != 2, by(delay) unequal
local p_`counter' = r(p)
local t_`counter' = r(t)
local counter = `counter' + 1
ttest Belief2 if !role & comm & delay != 0, by(delay) unequal
local p_`counter' = r(p)
local t_`counter' = r(t)
local counter = `counter' + 1
ttest Belief2 if !role & comm & delay != 1, by(delay) unequal
local p_`counter' = r(p)
local t_`counter' = r(t)
local counter = `counter' + 1
ttest Belief2 if !role & comm & delay != 2, by(delay) unequal
local p_`counter' = r(p)
local t_`counter' = r(t)
local counter = `counter' + 1
ttest Belief if role & !comm & delay != 0, by(delay) unequal
local p_`counter' = r(p)
local t_`counter' = r(t)
local counter = `counter' + 1
ttest Belief if role & !comm & delay != 1, by(delay) unequal
local p_`counter' = r(p)
local t_`counter' = r(t)
local counter = `counter' + 1
ttest Belief if role & !comm & delay != 2, by(delay) unequal
local p_`counter' = r(p)
local t_`counter' = r(t)
local counter = `counter' + 1
ttest Belief if role & comm & delay != 0, by(delay) unequal
local p_`counter' = r(p)
local t_`counter' = r(t)
local counter = `counter' + 1
ttest Belief if role & comm & delay != 1, by(delay) unequal
local p_`counter' = r(p)
local t_`counter' = r(t)
local counter = `counter' + 1
ttest Belief if role & comm & delay != 2, by(delay) unequal
local p_`counter' = r(p)
local t_`counter' = r(t)
local counter = `counter' + 1
ttest Belief if !role & !comm & delay != 0, by(delay) unequal
local p_`counter' = r(p)
local t_`counter' = r(t)
local counter = `counter' + 1
ttest Belief if !role & !comm & delay != 1, by(delay) unequal
local p_`counter' = r(p)
local t_`counter' = r(t)
local counter = `counter' + 1
ttest Belief if !role & !comm & delay != 2, by(delay) unequal
local p_`counter' = r(p)
local t_`counter' = r(t)
local counter = `counter' + 1
ttest Belief if !role & comm & delay != 0, by(delay) unequal
local p_`counter' = r(p)
local t_`counter' = r(t)
local counter = `counter' + 1
ttest Belief if !role & comm & delay != 1, by(delay) unequal
local p_`counter' = r(p)
local t_`counter' = r(t)
local counter = `counter' + 1
ttest Belief if !role & comm & delay != 2, by(delay) unequal
local p_`counter' = r(p)
local t_`counter' = r(t)
local counter = `counter' + 1
ttest BeliefOtherGroup if role & !comm & delay != 0, by(delay) unequal
local p_`counter' = r(p)
local t_`counter' = r(t)
local counter = `counter' + 1
ttest BeliefOtherGroup if role & !comm & delay != 1, by(delay) unequal
local p_`counter' = r(p)
local t_`counter' = r(t)
local counter = `counter' + 1
ttest BeliefOtherGroup if role & !comm & delay != 2, by(delay) unequal
local p_`counter' = r(p)
local t_`counter' = r(t)
local counter = `counter' + 1
ttest BeliefOtherGroup if role & comm & delay != 0, by(delay) unequal
local p_`counter' = r(p)
local t_`counter' = r(t)
local counter = `counter' + 1
ttest BeliefOtherGroup if role & comm & delay != 1, by(delay) unequal
local p_`counter' = r(p)
local t_`counter' = r(t)
local counter = `counter' + 1
ttest BeliefOtherGroup if role & comm & delay != 2, by(delay) unequal
local p_`counter' = r(p)
local t_`counter' = r(t)
local counter = `counter' + 1
ttest BeliefOtherGroup if !role & !comm & delay != 0, by(delay) unequal
local p_`counter' = r(p)
local t_`counter' = r(t)
local counter = `counter' + 1
ttest BeliefOtherGroup if !role & !comm & delay != 1, by(delay) unequal
local p_`counter' = r(p)
local t_`counter' = r(t)
local counter = `counter' + 1
ttest BeliefOtherGroup if !role & !comm & delay != 2, by(delay) unequal
local p_`counter' = r(p)
local t_`counter' = r(t)
local counter = `counter' + 1
ttest BeliefOtherGroup if !role & comm & delay != 0, by(delay) unequal
local p_`counter' = r(p)
local t_`counter' = r(t)
local counter = `counter' + 1
ttest BeliefOtherGroup if !role & comm & delay != 1, by(delay) unequal
local p_`counter' = r(p)
local t_`counter' = r(t)
local counter = `counter' + 1
ttest BeliefOtherGroup if !role & comm & delay != 2, by(delay) unequal
local p_`counter' = r(p)
local t_`counter' = r(t)
local counter = `counter' + 1
ttest Belief2nd if role & !comm & delay != 0, by(delay) unequal
local p_`counter' = r(p)
local t_`counter' = r(t)
local counter = `counter' + 1
ttest Belief2nd if role & !comm & delay != 1, by(delay) unequal
local p_`counter' = r(p)
local t_`counter' = r(t)
local counter = `counter' + 1
ttest Belief2nd if role & !comm & delay != 2, by(delay) unequal
local p_`counter' = r(p)
local t_`counter' = r(t)
local counter = `counter' + 1
ttest Belief2nd if role & comm & delay != 0, by(delay) unequal
local p_`counter' = r(p)
local t_`counter' = r(t)
local counter = `counter' + 1
ttest Belief2nd if role & comm & delay != 1, by(delay) unequal
local p_`counter' = r(p)
local t_`counter' = r(t)
local counter = `counter' + 1
ttest Belief2nd if role & comm & delay != 2, by(delay) unequal
local p_`counter' = r(p)
local t_`counter' = r(t)

di `counter'

preserve

clear
set obs 42
gen p = .
gen t = .
gen holm_bonferroni_stars = ""

forvalues i = 1/42 {
	replace p = `p_`i'' in `i'
	replace t = `t_`i'' in `i'
}

count if t > 0				// "Of these, 18 are negative, indicating a decline of beliefs with increasing delay,..." [positive t-statistic means negative delay effect] 
count if t < 0				// "... and 24 are positive" [negative t-statistic means positive delay effect] 
count if t > 0 & p < 0.05	// "2 of the negative effects are significant and ..."
count if t < 0 & p < 0.05	// "3 of the positive effects are significant."

* holm-bonferroni
foreach alpha in 0.1 0.05 0.01 {
	local obs = 42

	forvalues i = 1/42 {
		local threshold = `alpha'/`obs'
		local p = p in `i'
		if `p' < `threshold' {
			replace holm_bonferroni_stars = holm_bonferroni_stars + "*" in `i'
			local obs = `obs' - 1
		}
		else break
	}
}

list 						// "Finally, no effect remains significant after applying a Holm-Bonferroni correction."
restore

* Table 3: Beliefs of Trustees and Trustors
	
preserve

reg Belief2 Early Late communication EarlyComm LateComm time risk age female if role == 0, cluster(session)
replace Belief = Belief/10
reg Belief Early Late communication EarlyComm LateComm time risk age female if role == 0, cluster(session)
reg Belief2nd Early Late communication EarlyComm LateComm time risk age female if role == 1, cluster(session)
reg Belief2 Early Late communication EarlyComm LateComm time risk age female if role == 1, cluster(session)
reg Belief Early Late communication EarlyComm LateComm time risk age female if role == 1, cluster(session)
reg BeliefOtherGroup Early Late communication EarlyComm LateComm time risk age female if role == 1, cluster(session)
reg BeliefOtherGroup Early Late communication EarlyComm LateComm time risk age female if role == 0, cluster(session)

restore


******************
*** APPENDIX C ***
******************

preserve
keep if role == 1
contract numrolls communication delay
sort communication delay numrolls
egen obs = total(_freq), by(communication delay)
by communication delay : gen cum = sum(_freq)
gen percent = 100*cum/obs

* Panel (a): Trustees NOCOMM
tw (sc percent numrolls if communication == 0 & delay == 0, connect(stairstep) msymbol(none) lcolor("115 137 205") lpattern(shortdash)) ///
	(sc percent numrolls if communication == 0 & delay == 1, connect(stairstep) msymbol(none) lcolor("0 40 165") lpattern(longdash)) ///
	(sc percent numrolls if communication == 0 & delay == 2, connect(stairstep) msymbol(none) lcolor(navy) lpattern(solid)), ///
	ytitle("Percent") xtitle("Number of ROLL choices") ///
	graphregion(fcolor(white)) xsize(4) plotregion(margin(b=0)) ///
	ylabel(0(20)100, glcolor(gs14) glwidth(thin)) legend(order(1 "IMM" 2 "EARLY" 3 "LATE") rows(1))


* Panel (b): Trustees COMM
tw (sc percent numrolls if communication == 1 & delay == 0, connect(stairstep) msymbol(none) lcolor("115 137 205") lpattern(shortdash)) ///
	(sc percent numrolls if communication == 1 & delay == 1, connect(stairstep) msymbol(none) lcolor("0 40 165") lpattern(longdash)) ///
	(sc percent numrolls if communication == 1 & delay == 2, connect(stairstep) msymbol(none) lcolor(navy) lpattern(solid)), ///
	ytitle("Percent") xtitle("Number of ROLL choices") ///
	graphregion(fcolor(white)) xsize(4) plotregion(margin(b=0)) ///
	ylabel(0(20)100, glcolor(gs14) glwidth(thin)) legend(order(1 "IMM" 2 "EARLY" 3 "LATE") rows(1))

restore

preserve
keep if role == 0
drop if numins == .
contract numins communication delay
sort communication delay numins
egen obs = total(_freq), by(communication delay)
by communication delay : gen cum = sum(_freq)
gen percent = 100*cum/obs

* Panel (c): Trustors NOCOMM
tw (sc percent numins if communication == 0 & delay == 0, connect(stairstep) msymbol(none) lcolor("115 137 205") lpattern(shortdash)) ///
	(sc percent numins if communication == 0 & delay == 1, connect(stairstep) msymbol(none) lcolor("0 40 165") lpattern(longdash)) ///
	(sc percent numins if communication == 0 & delay == 2, connect(stairstep) msymbol(none) lcolor(navy) lpattern(solid)), ///
	ytitle("Percent") xtitle("Number of IN choices") ///
	graphregion(fcolor(white)) xsize(4) plotregion(margin(b=0)) ///
	ylabel(0(20)100, glcolor(gs14) glwidth(thin)) legend(order(1 "IMM" 2 "EARLY" 3 "LATE") rows(1))
	
* Panel (d): Trustors COMM
tw (sc percent numins if communication == 1 & delay == 0, connect(stairstep) msymbol(none) lcolor("115 137 205") lpattern(shortdash)) ///
	(sc percent numins if communication == 1 & delay == 1, connect(stairstep) msymbol(none) lcolor("0 40 165") lpattern(longdash)) ///
	(sc percent numins if communication == 1 & delay == 2, connect(stairstep) msymbol(none) lcolor(navy) lpattern(solid)), ///
	ytitle("Percent") xtitle("Number of IN choices") ///
	graphregion(fcolor(white)) xsize(4) plotregion(margin(b=0)) ///
	ylabel(0(20)100, glcolor(gs14) glwidth(thin)) legend(order(1 "IMM" 2 "EARLY" 3 "LATE") rows(1))

restore


******************
*** APPENDIX D ***
******************

tab is_efficiency is_ethics if role & communication	// "Only 13 messages (8 percent) contain an appeal to fairness but 84 messages (49 percent) contain an appeal to efficiency." 
pwcorr is_efficiency is_promise 					// The latter is highly correlated with the presence of a promise (Pearson correlation 0.75).
