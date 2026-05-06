|     | Strategic |     |     | Environment |     | Effect | and |
| --- | --------- | --- | --- | ----------- | --- | ------ | --- |
Communication∗
|     |     |     | Ali OZKES† |      | Nobuyuki | HANAKI‡ |     |
| --- | --- | --- | ---------- | ---- | -------- | ------- | --- |
|     |     |     |            | June | 23, 2020 |         |     |
Abstract
We study the interaction of the effects of the strategic environment and communication on
theobservedlevelsofcooperationintwo-personfinitelyrepeatedgameswithaPareto-inefficient
Nashequilibrium. Wereplicatepreviousfindingsthatpointtohigherlevelsoftacitcooperation
under strategic complementarity compared to strategic substitution. We find that this is not
due to differences in levels of reciprocity as previously suggested. Instead, we find that slow
learning coupled with noisy choices might drive this effect. When subjects are allowed to com-
municateinfree-formonlinechatbeforemakingchoices,cooperationlevelsincreasesignificantly
to the extent that the difference between strategic complements and substitutes disappears. A
machine-assisted natural language processing approach shows how the content of communica-
tion is dependent on the strategic environment and cooperative behavior. In particular, we find
that subjects in complementarity games reach full cooperation by agreeing on gradual moves
| towards | it. |     |     |     |     |     |     |
| ------- | --- | --- | --- | --- | --- | --- | --- |
Keywords:
Communication, Cooperation, Reinforcement learning, Strategic environment,
| Structural |        | topic modeling |      |             |     |     |     |
| ---------- | ------ | -------------- | ---- | ----------- | --- | --- | --- |
| JEL        | Codes: | C7 · C8        | · C9 | · D83 · L13 |     |     |     |
∗Part of this work is carried out when Ozkes was affiliated with Aix-Marseille School of Economics, and Hanaki
was affiliated with Universit´e Coˆte d’Azur, CNRS, GREDEG. We thank these institutions for their supportive en-
vironments. This work was supported by ANR grant Investissements d’Avenir under PSL∗ MIFID (IDEX ANR-
UCAJEDI
10-IDEX-0001-02) and (ANR-15-IDEX-01), an ORA-Plus project“BEAM”(ANR-15-ORAR-0004), and
| financial | aid from | Aix-Marseille | School | of Economics. |     |     |     |
| --------- | -------- | ------------- | ------ | ------------- | --- | --- | --- |
†Wirtschaftsuniversit¨atWien, InstituteforMarketsandStrategy, Vienna, Austria. E-mail: ali.ozkes@wu.ac.at
‡Institute
of Social and Economic Research, Osaka University, Osaka, Japan. E-mail:
nobuyuki.hanaki@iser.osaka-u.ac.jp
1

1 Introduction
In many economic decisions, there is a tension between what is individually rational and what is
collectively optimal. As shown in the extant experimental literature, whether or not this dilemma
can be resolved in favor of cooperation on the collectively optimal outcomes may depend on a
multitude of aspects in the specific context. This paper sheds light on the functioning of two well-
known determinants of cooperative behavior in games with Pareto-inefficient Nash equilibrium.
Particularly, we study the effect of communication in interaction with the strategic environment,
i.e., whether strategic interactions exhibit complementarity or substitution.
Theoretically, aslongasinteractionsaretoberepeatedcertaincommonlyknowntimes, cooper-
ation unravels in equilibrium due to backward induction.1 However, ample experimental evidence
demonstrates that participants reach and sustain cooperation to a significant extent.2 In market
games, forinstance, thisextentmightdependonthetypeofthegoods, asinHolt(1993), whonotes
that sellers of substitute goods might find it easier to collude tacitly than sellers of complement
goods do.3 Similar findings in the contexts of price and quantity competition underpinned the
argument that this is due to reaction functions being upward sloping in Bertrand games, while they
are downward sloping in Cournot games.4 The former is a case of strategic complementarity and
the latter is a case of strategic substitution, hence represent different strategic environments. This
paper contributes to the literature in two ways: we build on previous findings first by exploring the
behavioral underpinnings of the effect of strategic environment on tacit cooperation and second, by
studying if and how communication interacts with this effect.
In our benchmark setting without communication, we follow Potters and Suetens (2009) (PS),
who focus on the effect of the strategic environment by controlling for a set of previously discovered
potential confounds. Our findings regarding this benchmark confirm previous results that suggest
a higher tendency towards cooperation under strategic complementarity as opposed to substitu-
tion. We find that under complementarity, choices are higher than equilibrium levels, i.e., more
cooperative, which are, in turn, higher than choices under substitution. On the other hand, we
find that reciprocity, as suggested by PS, does not explain this effect: changes in partner’s choices
are followed to the same extent under both strategic environments. We show, however, through
maximum likelihood estimations and simulations based on a simple reinforcement learning model
that this can be driven by slow learning coupled with noisy choices.
We implemented an extension to the baseline setup, by allowing subjects to chat before making
decisionsineachperiod,todeterminewhetherthedifferenceinthedegreesofcooperationcontinues
to hold under communication and also to better understand how the strategic environment affects
1Our focus is on finitely repeated games. See Mermer et al. (2016) for an analysis on indefinitely repeated
games. Furthermore, we want to note that the strategic environment definitions are based on the stage games and
as demonstrated by Echenique (2004), Sabarwal and VuXuan (2018), and Vives (2009), these definitions may not
extend to repeated interactions.
2See, inter alia, Embrey et al. (2017) and Mengel (2017) for meta-studies on how cooperation is reached and
sustainedinrepeatedsocialdilemmagames. Crawford(2019)providesarecentreviewondeterminantsofcooperation,
including the role of communication.
3TheintuitionisthatincaseofsubstitutestheBertrandpricecompetitionmodelgeneratesupwardslopingreaction
functionsinpricesandhencetheorypredictsthatifonesellermovesawayfromNashequilibriumtowardthecollusive
outcome, the other seller has a unilateral incentive to respond by raising price toward the collusive outcome.
4SeeSuetensandPotters(2007)foradiscussionandreviewofresultsonthisissueandPottersandSuetens(2013)
for a survey on oligopoly experiments.
2

subjects’ reasoning about the game. Although communication is generally found to enhance coop-
eration in previous literature, its effect on the levels of cooperation is not definite and known to
depend on the type, duration, or contents of communication, as well as the specifics of the game.5
Inourexperiments, subjectsweregiventheopportunitytocommunicateinfreeformbeforemaking
decisions without any cost or binding agreement.
Fonseca and Normann (2014) investigate the impact of communication in Bertrand markets
with different sizes, and find that, free-from communication helps to obtain higher profits and firms
continue collusion successfully after communication is disabled. They note, however, referring to
Farrell and Rabin (1996) and Whinston (2008), that the effect of communication on dilemma
games is subject to debate. Waichman et al. (2014) note that there is only very little attention
devoted to the study of the impact of communication on Cournot markets and find that free-form
communication boosts collusion levels (measured by both aggregate output and collusion counts),
while standardized communication does not have a significant effect.6
We find that when subjects can communicate, average choices and payoffs shift substantially
andabout75percentofpairsreachandsustainefficientcooperationinbothstrategicenvironments.
Thus, communication has an“ironing effect”: the impact of the strategic environment on aggregate
cooperation disappears. Considering the hardship of eliminating communication in order to avoid
collusion in oligopolies, for instance, our finding points to that the strategic environment may
not be of major significance as previously thought. Nonetheless, there are some differences to
note. Firstly, communication is more effective in helping participants to cooperate, even if not at
the efficient level, in substitution than in complementarity. Secondly, under complementarity, the
efficient cooperation is more likely to be reached by gradual moves.
We then aim at understanding more about how communication works towards cooperation and
if strategic environment is relevant in that regard. To that end, we employ a set of text analysis
methods, including the analyses of number of messages sent, the frequencies of most used words,
and finally, a machine-assisted natural language processing (NLP) approach. Machine learning
methods for text analysis are increasingly employed in economic research (see Gentzkow et al.,
2019).7 However, these methods were not considered in analyses of communication records in
experimental games until very recently.8
We refer to an unsupervised learning method, for the first time in the literature, for content
5Andersson and Wengstr¨om (2012) find, for instance, that the possibility of repeated communication does not
necessarily lead to more cooperation in two-stage games.
6Gomez-Martinez et al. (2016) study the effect of the revelation of firm-specific data in a Cournot game with
multiple firms, and find that communication helps to reach collusive agreements in both individual and aggregate
informationtreatments. AwayaandKrishna(2016)investigate,intheirtheoreticalstudythatisbuiltonamodelof
repeated oligopoly with secret price cuts, how unverifiable communication about past sales can facilitate collusion.
Bigoni et al. (2018) run a series of experiments with an indefinitely repeated noisy Cournot game to investigate the
effect of flexibility (ability to respond quickly) on cooperation, and observe rapid convergence to very low levels of
cooperation, independent of flexibility.
7Recent works include, among others, Hansen and McMahon (2016), who assess the impact of content in central
bank communication on real economic variables, Gentzkow and Shapiro (2010), who investigate the demand for
like-minded news as a reason behind bias in newspapers, Mueller and Rauh (2018), who suggest implementing topic
models in the analysis of newspaper articles to predict timing of political violence, and Grajzl and Murrell (2019),
who employ a structural topic model to study features of Francis Bacon’s writings in relation to their importance
regarding the history of economic thought.
8See Brandts et al. (2019) for a survey. Penczynski (2018) and Georgalos and Hey (2019) are the only published
works we are aware of that propose a machine learning approach. More on this in Section 4.
3

analysis of the chat records. In particular, we estimate a structural topic model (Roberts et al.,
2016) that presumes that subjects’ chats are formed as a weighted mixture of topics that are in
turn distributions over words. We find that the topical content of subjects’ chat records depend on
the strategic environment and whether or not they achieve efficient cooperation in the game. For
instance, we observe in the choice data that it is equally likely for subjects to realize and swiftly
move to efficient cooperation in the two strategic environments. However, we find evidence in
chat content that, subjects in complementarity reach efficient cooperation by agreeing on gradual
moves towards it, in case they do not start cooperating from the very beginning. In substitution
treatment, on the other hand, subjects either do not reach efficient cooperation or they may jump
| to it later on. |     |     |     |     |     |     |     |     |     |     |
| --------------- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
The remainder of the paper is organized as follows. Section 2 is devoted to the experimental
design and procedure. Section 3 delivers our major findings on the strategic environment effect and
its interaction with the effect of communication. Section 4 contains chat analysis, while Section 5
concludes.
|     |     |     |     | 2 The |     | Experiment |     |     |     |     |
| --- | --- | --- | --- | ----- | --- | ---------- | --- | --- | --- | --- |
Our central experimental questions are the following. First, we ask if tacit cooperation levels
are higher under strategic complementarity compared to substitution and what the behavioral
underpinnings are. Second, we investigate if there is a difference between strategic environments
in terms of the degree of cooperation when subjects can communicate via a free form online chat.
Finally, we explore on how the chat content relates to the strategic environment. Our experimental
design that we describe in the following section is built on these questions.
2.1 Design
We designed treatments with strategies as substitutes and complements, both with and without
communication, based on PS. Thus, we had a 2 × 2 between-subjects design, in which subjects
played the stage game repeatedly for 30 times in fixed pairs (partner matching). The dominance-
solvable stage game has a unique (symmetric) Nash equilibrium that is Pareto dominated. Also
there is a unique (symmetric) socially efficient outcome, that is called the joint profit maximization
(JPM) outcome. In both strategic environments, there is positive externality, i.e., one’s own payoff
actions.9
| is increasing | in partner’s |     |     |     |     |     |     |     |     |     |
| ------------- | ------------ | --- | --- | --- | --- | --- | --- | --- | --- | --- |
Let x ,x ≥ 0 denote the actions for players 1 and 2 in a pair, respectively. We write the
1 2
| quadratic payoff | functions |         | for each | treatment             |     | as                                              |      |      |       |     |
| ---------------- | --------- | ------- | -------- | --------------------- | --- | ----------------------------------------------- | ---- | ---- | ----- | --- |
|                  |           | πComp(x | ,x       | ) = c +c              | x   | +c x −c                                         | x2+c | x2+c | x x , |     |
|                  |           | i       | i        | j 1                   | 2 i | 3 j                                             | 4 i  | 5 j  | 6 i j |     |
|                  |           | πSubs(x |          | c(cid:48) +c(cid:48)x |     | +c(cid:48)x −c(cid:48)x2+c(cid:48)x2−c(cid:48)x |      |      |       |     |
|                  |           |         | ,x       | ) =                   |     |                                                 |      |      | x ,   |     |
|                  |           | i       | i        | j 1                   | 2 i | 3 j                                             | 4 i  | 5 j  | 6 i j |     |
for i,j ∈ {1,2} and i (cid:54)= j. The coefficients satisfy (i) c(cid:48) = c , (ii) c(cid:48) = c2(2c4−c6) , (iii) c(cid:48) =
1
|     |     |             |     |     |     |     | 1   |             | 2 2c4+c6 | 3   |
| --- | --- | ----------- | --- | --- | --- | --- | --- | ----------- | -------- | --- |
|     |     | c4(2c4−c6)2 |     |     |     | 2c3 |     | c6(2c4−c6)2 |          |     |
c + 2c2c6 ,(iv)c(cid:48) = ,(v)c(cid:48) = c + 6 ,and(vi)c(cid:48) = . Thesesixconditions
| 3 2c4+c6 | 4   | (2c4+c6)2 |     | 5   | 5 (2c4+c6)2 |     |     | 6 (2c4+c6)2 |     |     |
| -------- | --- | --------- | --- | --- | ----------- | --- | --- | ----------- | --- | --- |
guarantee that the NE choices and payoffs, the JPM choices and payoffs, the optimal defection
9PS find that the sign of externality does not play a significant role on the degree of cooperation.
4

|     |     |     |     | x   |     | BRc |     |     |     |     |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
|     |     |     |     | 2   |     |     | 1   |     |     |     |
JPM
BRc
2
NE
BRs
2
|     |                 |              |           |          |               | BR         | s x        |               |     |     |
| --- | --------------- | ------------ | --------- | -------- | ------------- | ---------- | ---------- | ------------- | --- | --- |
|     |                 |              |           |          |               |            | 1 1        |               |     |     |
|     |                 | Figure       | 1. Best   | response | functions     |            | and NE and | JPM choices.  |     |     |
|     |                 |              |           | Without  | Communication |            | With       | Communication |     |     |
|     | Complementarity |              |           |          | 56 (4)        |            |            | 100           | (8) |     |
|     |                 | Substitution |           |          | 64 (6)        |            |            | 74            | (5) |     |
|     |                 | Table        | 1. Number | of       | participants  | (sessions) | in four    | treatments.   |     |     |
payoff, and the absolute value of the slope of the reaction curve are the same across strategic
environments. The latter makes the best-reply dynamics generate the same speed of convergence.
Figure 1 summarizes the similarities and the differences between strategic environments.
We follow PS and set c 1 = −28,c 2 = 5.474,c 3 = 0.01,c 4 = 0.278,c 5 = 0.0055, c 6 = 0.165, and
x ∈ [0,28], thus our treatments without communication are exact replicates of positive externality
treatments in PS. Given these values, we have x = 14, x = 25.5, π = 27.71, π =
|     |     |     |     |     |     | NE  | JPM |     | NE  | JPM |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
41.94, and the optimal defection payoff π = 60.14. The slope of the reaction curve under
defect
| complementarity |     | is 0.3, | while it is | −0.3 | under substitution. |     |     |     |     |     |
| --------------- | --- | ------- | ----------- | ---- | ------------------- | --- | --- | --- | --- | --- |
2.2 Procedure
All our computerized sessions were conducted at the Laboratory of Experimental Economics of
Nice.10 Intotal,308studentsubjectsparticipatedintheexperiment. Numbersofsubjects(sessions)
| per treatment | are | provided | in Table | 1.11 |     |     |     |     |     |     |
| ------------- | --- | -------- | -------- | ---- | --- | --- | --- | --- | --- | --- |
Instructions with screenshots were distributed and read aloud at the beginning of each session
(see Appendix A). The instructions were exactly the same for complementarity and substitution
and subjects were told that their earnings were going to be based on their own decisions and the
decision of another participant, with whom they were matched for the session. No reference to
any market or economic term was made; the experiment was introduced as a neutral decision-
making problem with two persons involved. Each participant received a payoff table showing own
payoff corresponding to choices in even numbers between 0 and 28 (see Appendix B). In addition
to the payoff table, subjects were provided on their screen a payoff calculator for hypothetical
10Weusedtheexperimentalsoftwaretoolkitz-Tree (Fischbacher,2007)toprogramtheexperiment. Subjectswere
| recruited | using ORSEE | (Greiner, | 2015). |     |     |     |     |     |     |     |
| --------- | ----------- | --------- | ------ | --- | --- | --- | --- | --- | --- | --- |
11The number of participants and sessions varied across treatments due to variation in show-up rate across our
pre-schedulessessionsthattookplaceindifferentperiodsoftheschoolsemester. Webaseouranalysison294subjects
excluding7pairs,inwhichatleastonesubjectmakechoiceslessthanorequalto2(whichleadstoverylowpayoffs)
| for half of | the experiment | or  | longer. |     |     |     |     |     |     |     |
| ----------- | -------------- | --- | ------- | --- | --- | --- | --- | --- | --- | --- |
5

numbers that they could type in. The number of decimal points for both the calculator and
decisions was restricted to be one. In sessions with communication, subjects could communicate
voluntarily through a chat box during one minute before moving to the decision stage. Offensive
language and identifying messages were banned but there was no further restriction on the content
of communication. Subjects’ communication language occurred to be exclusively French, although
it was not restricted.
Thestagegamewasrepeatedfor30periods, startingafteratrialperiodwithforceddecisions.12
History of past decisions and payoffs was provided at each period. Payoffs were denoted in points
and exchanged for cash at a rate of 100 points = 1 Euro. The final earnings paid at the end
of the experiment consisted of a participation fee of 5 Euros and total payoffs throughout the
session. Subjects earned on average 15.5 Euros in treatments with communication and 11.3 Euros
in treatments without communication, including 5 Euros show-up fee. The average duration of
a session without communication was 90 minutes, whereas it was 105 minutes for sessions with
communication.
3 Experimental Results
3.1 Aggregate Results
The subsequent analysis is based on the degree of cooperation, which is defined, for a pair k in
period t with average choice within pair denoted by x¯ , as
kt
x¯ −x
kt NE
ρ = . (1)
kt
x −x
JPM NE
The average degrees of cooperation in four treatments are reported in Figure 2 and Table 2.
As is clearly seen in Figure 2, when communication is not allowed, complementarity induces more
cooperationcomparedtosubstitution. Thisisinlinewithpreviousfindings, particularlywithPS.13
Next, for both strategic environments, communication boosts the levels of cooperation. However,
this shift leads to the disappearance of the strategic environment effect, i.e., when communication
is allowed, the degree of cooperation is the same across strategic environments.14
Table 2 delivers details and test results for all periods combined (1-30), first half of the exper-
iment (1-15), second half of the experiment (16-30), first period, and last period. The p−values
12In the trial period, the payoff calculators were used twice to calculate hypothetical payoffs. In chat treatments,
the chat box is tried out by typing“hello”(bonjour) after this and finally, a forced decision has been commanded.
Payoffs in the trial period did not count in final earnings.
13Although overall comparison in between treatments is the same with PS, several observations should be noted.
First, in PS, the average cooperation rates are higher (0.27 in substitution and 0.41 in complementarity). In both
of their treatments, there seems to be a clear increasing trend of choices over the periods after first few. In case of
complementarity, average choices increase as high as to the level of the JPM. Second, choices in PS are both higher
than Nash equilibrium, whereas, in our data, substitution treatment has lower average choices than the NE. And
finally,theendgameeffectinPSisstrongercomparedtoourdataforbothtreatments. Theseobservationscouldbe
explainedbydifferencesinsubjectpoolsacrossstudies. Forinstance, asnotedbyAl-Ubaydlietal.(2016),cognitive
skills predict well the average cooperation rates in repeated prisoners’ dilemma games, and Noussair et al. (2016)
andBreabanetal.(2020)findthattheaverageCognitiveReflectionTestscoreinTilburgsubjectpoolisaround1.8,
whereas it is around 0.4 for the subject pool in Nice, as reported by Babutsidze et al. (2020).
14Figure 13 in Appendix C shows the comparison of payoffs. The average payoffs over all periods with (without)
communication are: 35.1 (24.1) for complementarity and 36.9 (21.8) for substitution.
6

1.0
noitarepooC fo eergeD
0.5
0.0
−0.5
|     | 0   |     | 10  | 20  |     | 30  |
| --- | --- | --- | --- | --- | --- | --- |
Period
|     |     | Subs. without comm. | Subs. with comm.  | Comp. without comm. | Comp. with comm. |     |
| --- | --- | ------------------- | ----------------- | ------------------- | ---------------- | --- |
|     |     | Figure              | 2. Average degree | of cooperation.     |                  |     |
|     |     | No Communication    |                   |                     | Communication    |     |
Periods Substitution Complementarity p−value Substitution Complementarity p−value
1-30 -0.07 (0.28) 0.16 (0.29) 0.034 0.72 (0.34) 0.74 (0.33) 0.538
1-15 -0.09 (0.24) 0.19 (0.31) 0.000 0.63 (0.43) 0.67 (0.37) 0.538
16-30 -0.06 (0.38) 0.13 (0.33) 0.018 0.82 (0.32) 0.81 (0.37) 0.240
1 0.03 (0.85) -0.05 (0.72) 0.695 0.43 (0.90) 0.37 (0.70) 0.950
30 -0.22 (0.57) 0.00 (0.36) 0.046 0.57 (0.51) 0.70 (0.43) 0.104
Table 2. Average degrees of cooperation (standard deviations in parentheses). Standard
deviations measure between-pair variability, except for first period, in which individual choices
areused. Reportedp−valuesareforalternativehypothesesintheWMWtestsforhigherdegrees
| of cooperation | under | complementarity. |     |     |     |     |
| -------------- | ----- | ---------------- | --- | --- | --- | --- |
correspond to Wilcoxon-Mann-Whitney (WMW) tests of the null hypotheses that the degree of
cooperation is the same in substitution and complementarity. When communication is not allowed,
allthenullhypotheses(exceptforthefirstperiod)arerejectedinfavorofthealternativehypotheses
that the degree of cooperation is higher in complementarity than in substitution. However, when
communication is allowed, we reject none of the null hypotheses. It is immediate to observe that
the average degrees of cooperation are substantially higher when communication is allowed within
| a strategic | environment.15 |     |     |     |     |     |
| ----------- | -------------- | --- | --- | --- | --- | --- |
Theend-gameeffectthatisgenerallyobservedinfinitelyrepeatedsocialdilemmagames(Selten
and Stoecker, 1986) seems to take place in all our treatments, as seen in Figure 2. Let us define this
| |ρ30 | −ρ16−30| | ρ16−30 |     |     |     |     |
| ---- | -------- | ------ | --- | --- | --- | --- |
effect as where is the average degree of cooperation in the second half of the
15All WMW tests yield p−values of 0.000. We tested if this is due to the extra time given for chat, rather than
theeffectofcommunicationitselfbyrunningtwoextrasessionswiththesameextratime(1minute)butwithoutthe
abilitytocommunicate. TheresultscanbefoundinAppendixC.2,whichshowthattheextratimeincommunication
| treatments have | only a very | small effect. |     |     |     |     |
| --------------- | ----------- | ------------- | --- | --- | --- | --- |
7

experiment and ρ30 is the average degree of cooperation in the final period. We observe that the
end-game effect is slightly stronger (0.16) under substitution compared to complementarity (0.13).
Thismightpartiallybeexplainedbythefactthatoptimaldefectionchoiceundersubstitution(10.6)
is much lower than in complementarity (17.4), as noted by PS.
3.1.1 Full-cooperation behavior
We say the choice of a subject at any period is at JPM level if it lies in the interval [25,26], and
we say the choices of a pair are at JPM level if both subjects play at JPM level simultaneously.
When communication is not allowed, the number of pairs who have played JPM level as a pair at
least once is 4 in both environments, which amounts to 12.5% of the pairs in substitution and 14%
in complementarity.16 However, out of these four pairs, none of them sustained JPM level choices
for more than 5 periods in substitution, whereas in complementarity, three of them managed to
cooperatefullyfromthefirstperiodtheyplayatJPMlevelasapairuntilthepenultimateperiod.17
We call a pair a JPM pair if their choices as a pair are at the JPM level for at least three periods
untilthelastperiod,thelastbutoneperiod,thelastbuttwoperiods,orthelastbutthreeperiods.18
The rest of the pairs are called non-JPM.
We observe that more subjects make JPM level choices in substitution (47% compared to 34%
in complementarity). One might conclude that subjects tend to unilaterally try out JPM strategies
more in substitution, whereas only under complementarity we have pairs that succeed in sustaining
cooperationforseveralperiods.19 Itshouldbenoted,however,thatthisdifferenceisnotstatistically
significant (Fisher’s test yields a p−value of 0.193).
3.1.2 Reciprocity
With a regression model estimation, PS identify a higher level of reciprocity among subjects in the
complementarity treatment. Table 3 shows the estimation results of the same model for our data
(without communication):
∆x = β +β ∆x +β COMP ∆x +u ,
it 0 1 jt−1 2 i jt−1 it
16Figures 15 and 16 in the Appendix D show the evolution of choices within pairs.
17Thefirstperiodsofmutualfull-cooperationforthesethreepairsare: 4,6,and18. Oneotherpairincomplemen-
tarityplaysatJPMlevelonlyonce,atthe28thperiod. Insubstitution,twopairsplayatJPMlevelonlyonce(24th
and 30th periods), one pair at 22nd and 24th periods, and another pair between 15th and 19th periods.
18The following results do not depend on the choice of the length of mutual cooperation. Details can be provided
upon request.
19Mengel(2017),inhersurveycomprising96studieswith3500subjectsintotal,findsthatrisk(lossfromunilateral
cooperation) and temptation (gain from unilateral defection) play a significant role on the levels of cooperation in
prisoners’dilemmagames. IfwelookattherestrictedgamewithonlyNEandJPMstrategiesforrespectivelydefection
and cooperation, the value of the risk parameter is calculated to be approximately 2.6 for our complementarity
treatment and 0.8 for our substitution treatment. Similarly, the value of the temptation parameter is calculated to
be approximately 1.06 for our complementarity treatment and 1.22 for our substitution treatment. Mengel (2017)
concludes that in repeated games with partner matching, temptation explains better the variation in cooperative
behavior. As temptation is higher, sustaining cooperation is more difficult in substitution. On the other hand, as
risk is higher in complementarity, fewer subjects tend to try out (jump to) JPM strategies. The latter follows from
the argument that risk is crucial in determining short-run incentives (see Blonski et al., 2011).
8

|     |     |     |          | β       |          |     | β       |     |
| --- | --- | --- | -------- | ------- | -------- | --- | ------- | --- |
|     |     |     |          | 1       |          |     | 2       |     |
|     |     |     | Estimate | p−value | Estimate |     | p−value |     |
|     |     |     | 0.16     | 0.012   | −0.04    |     | 0.554   |     |
Table 3. Regression results (with individual random effects) on changes in choices without
communication. Standard errors are robust to within-pair dependency. Two-tailed p−values
arereported. 3360observationsfrom120subjects(64insubstitutionand56complementarity).
where COMP is a dummy variable that takes the value 1 for choices in complementarity treatment
and the value 0 for substitution, ∆x is the change in the choice of subject i from period t−1 to
it
t, and ∆x is the change in the choice of the partner from period t−2 to t−1. We observe
jt−1
significant reciprocity among our subjects, represented by the β estimate in Table 3. However,
1
(βˆ
there is no difference between strategic environments 2 is not significantly different from zero).
This is in contrast to what PS find. Specifically, PS observe that subjects in complementarity have
(βˆ
| significantly | higher | reciprocity |     | 2 = 0.17 with | p = | 0.003). |     |     |
| ------------- | ------ | ----------- | --- | ------------- | --- | ------- | --- | --- |
Asdifferencesinthedegreeofreciprocitybetweentwostrategicenvironmentsdonotexplainthe
higher degree of cooperation under complementarity in our data, in the next section we investigate
| whether | a learning | model | can generate | the | result of | our | experiment. |     |
| ------- | ---------- | ----- | ------------ | --- | --------- | --- | ----------- | --- |
3.2 Learning
We consider a simple reinforcement learning model (without communication) where learning is
based on realized payoffs (see Erev and Roth, 1998). Let xt denote the action agent i chooses in
i
period t, s the step size used to discretize the action space, and S the discretized action space.
Furthermore, Ai(t) denotes the attraction associated with action x for agent i at period t. Given
q
the attractions, the probability that i chooses x in period t is defined by
eλAi (t)
|     |     |     |     | pi(t) |          | x    |     |     |
| --- | --- | --- | --- | ----- | -------- | ---- | --- | --- |
|     |     |     |     |       | =        |      | ,   |     |
|     |     |     |     | x     | (cid:80) | eλAi | (t) |     |
k
k∈S
where λ ≥ 0 is the parameter that governs the“sensitivity”of choice to the attraction. λ = 0 means
uniformly random choice (thus, attractions play no role) and λ → ∞ means that the quantity with
the highest attraction for agent i in period t will be chosen with probability approaching 1.
Weassumethateachactionhasthesamelevelofinitialattraction, whichisequaltotheaverage
payoff i can obtain if both i and j uniformly randomize their actions, i.e.,
|     |     |     |     | Ai(0) | (cid:88) | (a,b)/|S|2, |     |     |
| --- | --- | --- | --- | ----- | -------- | ----------- | --- | --- |
|     |     |     |     | =     |          | π           |     |     |
|     |     |     |     | x     |          | i           |     |     |
(a,b)∈S×S
for all x ∈ S. Furthermore, as in McAllister (1991) and Hanaki et al. (2005, 2018), we assume that
| the attraction | for any | x ∈ | S evolves | as a weighted | average |     | with |     |
| -------------- | ------- | --- | --------- | ------------- | ------- | --- | ---- | --- |
(cid:40)
|     |     |         |     | ωAi(t)+(1−ω)π |     | (xt,xt) |     | if xt = x, |
| --- | --- | ------- | --- | ------------- | --- | ------- | --- | ---------- |
|     |     | Ai(t+1) | =   | x             |     | i       | i j | i          |
|     |     | x       |     | Ai(t)         |     |         |     | otherwise, |
x
for all t ≥ 0, where ω is the“recency”parameter that indicates the speed at which past payoffs are
9

noitarepooC fo eergeD 0.1
0.0
−0.1
|     | 0   |     | 10  |     | 20  |     | 30  |
| --- | --- | --- | --- | --- | --- | --- | --- |
Period
|     |        |              |        | Substitution   | Complementarity |               |     |
| --- | ------ | ------------ | ------ | -------------- | --------------- | ------------- | --- |
|     | Figure | 3. Simulated | degree | of cooperation | for λ∗ =0.2     | and ω∗ =0.88. |     |
forgotten: ω = 0 when only the last period payoff is remembered and ω = 1 implies that only the
initial attractions are remembered. Thus, ω is higher when learning is slower.
Based on a maximum likelihood estimation, we obtained parameter values for our exper-
imental data. In particular, we identified by a grid search over λ ∈ {0.1,0.2,...,9.99} and
| ω ∈ {0.01,0.02,...,0.99} |     | the maximizers |     | of  |     |     |     |
| ------------------------ | --- | -------------- | --- | --- | --- | --- | --- |
(cid:88) (cid:88)
|     |     |     |     | log(pi | (t)). |     | (2) |
| --- | --- | --- | --- | ------ | ----- | --- | --- |
x=xt
i
i∈Nt∈{1,...,30}
Figure 3 shows the simulations based on 1000 pairs with the obtained parameter estimates, i.e.,
λ∗ = 0.2 and ω∗ = 0.88, which point to slow learning and noisy choices.
To show that the pattern we observe is dependent on the estimated parameters, we have com-
puted simulations for λ ∈ [0.1,1.5] with increments of 0.2, and ω ∈ [0.05,0.95] with increments of
0.05. For each set of parameter values, we have created 100 simulated pairs. We then computed,
for each simulated pair, the average degree of cooperation within 30 periods. Namely, for pair k,
| the average | degree of | cooperation | is defined | as  |     |     |     |
| ----------- | --------- | ----------- | ---------- | --- | --- | --- | --- |
1 30
(cid:88)
|     |     |     |     | ρ =  | ρ . |     |     |
| --- | --- | --- | --- | ---- | --- | --- | --- |
|     |     |     |     | k 30 | kt  |     |     |
t=1
We then took the average of ρ across all simulated pairs and obtained ρC for complementarity and
k
ρS for substitution. Finally, we computed ∆ρ = ρC −ρS which summarizes the difference between
complementarity and substitution, namely, the size of the strategic environment effect.
Figure 4 shows the relationship between ∆ρ and ω for four values of λ. The average degree
of cooperation in complementarity is higher than in substitution when learning is slow enough
(ω ≥ 0.8). When choices are less sensitive to attractions (λ is smaller), we observe the strategic
| environment | effect for | faster learning | (smaller | ω) as well. |     |     |     |
| ----------- | ---------- | --------------- | -------- | ----------- | --- | --- | --- |
10

0.2
0.0
−0.2
0.25 0.50 0.75
Recency (ω)
Sρ−Cρ=ρ∆
Sensitivity (λ)
0.1
0.5
0.9
1.5
Figure 4. Simulated ∆ρ for various values of ω and four values of λ.
4 Communication
Many experimental studies include communication, and it is often implemented in free form, in
which subjects are not restricted in the content of their messages, except for abusive words and
identification purposes, as was the case in our experiments. It has been documented that free-
form communication, as opposed to structured or restricted communication, has a larger impact
on strategic interactions.20 On the other hand, there is a big challenge facing the analyses of the
impact of free-form communication on strategic behavior that pertains to the question of how it
works.
Free-form communication is more and more prevalent in economic experiments that are imple-
mented online and in laboratory, and has a distinctive power to reveal reasoning and deliberative
processes in strategic decision-making. Naturally, however, assessment of this kind of data can
be complex and are, most of the time, based on subjective judgment of researchers or research
assistants. Current practices with regard to making sense of chat data coming from free-form
communication in lab experiments include (i) self-classification of messages in order to relate the
choice of words or messages to actual plays and outcomes (see Charness and Dufwenberg, 2006;
Schotter and Sopher, 2007; Kimbrough et al., 2008), (ii) content analysis in which a few research
assistants are recruited to be trained to code messages into categories formed by the researchers
(see Cooper and Kagel, 2005; Sutter and Strassmair, 2009; Hennig-Schmidt et al., 2008), and (iii)
classification coordination game `a la Houser and Xiao (2011), in which coders are incentivized to
20Charness and Dufwenberg (2006, 2011) emphasize the effectivity of free-form communication in enhancing effi-
ciency when equilibria can be Pareto ranked. Cooper and Ku¨hn (2014) conclude that allowing a rich message space
leadstopersistentcollusioninatwo-persontwo-periodmatrixgameresemblingBertrandpricecompetition. Brandts
etal.(2015)arguethatrestrictedandunilateralcommunicationislesseffectivecomparedtofree-formcommunication
incontractgames. AnderssonandWengstr¨om(2012)arguethatfree-formcommunicationincreasestheimportanceof
socialpreferencesasopposedtostructuredcommunication. Buildingonthisargument,CasonandMui(2015)deliver
evidence for that rich communication is more effective in facilitating coordinated resistance modeled a` la Weingast
(1995). Casonetal.(2012),ontheotherhand,pointtocontestenvironmentswherefree-formcommunicationmight
damageefficiency. Finally,WangandHouser(2019)findthatincoordinationgames,free-formcommunicationboosts
coordination much more than restricted communication.
11

|     | Periods | Substitution | Complementarity | p−value |
| --- | ------- | ------------ | --------------- | ------- |
|     | 1-30    | 1.97 (2.00)  | 1.57 (1.81)     | 0.000   |
|     | 1-15    | 2.05 (1.87)  | 1.85 (1.77)     | 0.000   |
|     | 16-30   | 1.88 (2.12)  | 1.30 (1.82)     | 0.000   |
Table 4. Average number of messages per period (s.d. in parentheses). The p−values are due
| to two-tailed | WMW tests. |     |     |     |
| ------------- | ---------- | --- | --- | --- |
pay more attention through rewarding the codes that match the most popular evaluation among
other coders’ evaluations (see Corazzini et al., 2014; Ellingsen and Johannesson, 2008; Andersson
et al., 2010).
In this paper, we propose the use of computerized techniques in analyzing experimental chat
data in place of human labor. Advantages are that (i) they are less costly in terms of time and
moneyasresearchersdevotelesstimetotheanalysisanddonothavetohirecodersorassistants,(ii)
they may make language restriction redundant as many techniques in natural language processing
are language-free, and (iii) they may rely on subjective assessments to a lesser extent. The latter
two points are particularly relevant for unsupervised learning methods.
BeforeproceedingwiththeresultsofourNLPapproach,i.e.,estimatingastructuraltopicmodel
(STM), we look at the general features of chat content, in relation to the strategic environment and
| full-cooperation | behavior.   |      |     |     |
| ---------------- | ----------- | ---- | --- | --- |
| 4.1 Number       | of messages | sent |     |     |
In this section we look at the number of messages sent by subjects.21 All 174 subjects sent at least
one message throughout the experiment. They sent, on average, 1.74 messages per period. In the
first half of the experiment, the average is 1.93, which is significantly higher than the second half
(1.55, with p = 0.000 in a WMW two-tailed test). As can be seen in Table 4, in complementarity
averagenumberofmessagesperperiodis1.57, whereasitis1.97insubstitution. Thus, weconclude
thatsubjectssentmoremessagesinsubstitutiontreatments,thedifferencebeingaboutonemessage
| in every two | periods. |     |     |     |
| ------------ | -------- | --- | --- | --- |
Figure 5a depicts the evolution of the number of messages over time by strategic environment,
which confirms that, especially in the second half of the experiment, subjects in the substitution
treatment sent more messages. The percentage of subjects who do not send any message is in-
creasing in complementarity treatment, whereas there is no visible trend in substitution, as seen in
Figure 5b. This might be explained in part with the fact that there are more pairs who manage to
reach and sustain full-cooperation and may not need further communication in complementarity
(seeTable5). Inwhatfollows,welookmorecloselyatthemessagingpatternsinJPMandnon-JPM
pairs.
| 4.1.1 Full-cooperation | and communication |     |     |     |
| ---------------------- | ----------------- | --- | --- | --- |
Table 5 shows the number (percentage) of subjects and pairs who make JPM level choices at least
once in both strategic environment with communication, together with JPM pairs. We do not
21This
| is based | on the number of | times subjects clicked | the“send”button. |     |
| -------- | ---------------- | ---------------------- | ---------------- | --- |
12

3
sredneS−noN fo egatnecreP 0.6
segasseM fo rebmuN
2
0.4
1
0.2
|     | 0   |     |              |                 |     |     |     | 0.0 |                              |     |     |
| --- | --- | --- | ------------ | --------------- | --- | --- | --- | --- | ---------------------------- | --- | --- |
|     | 0   |     | 10           |                 | 20  | 30  |     | 0   | 10                           | 20  | 30  |
|     |     |     |              | Period          |     |     |     |     | Period                       |     |     |
|     |     |     | Substitution | Complementarity |     |     |     |     | Substitution Complementarity |     |     |
a. Average number of messages per period. b. Percentage of subjects who do not send any
|     |     |     |     |     |     |     | message | per | period. |     |     |
| --- | --- | --- | --- | --- | --- | --- | ------- | --- | ------- | --- | --- |
Figure 5. Average number of messages and percentage of subjects who do not send any
|     | message |     | per period. | The      | period     | 0 stands for the | forced       | trial period. |                 |     |     |
| --- | ------- | --- | ----------- | -------- | ---------- | ---------------- | ------------ | ------------- | --------------- | --- | --- |
|     |         |     |             |          |            |                  | Substitution |               | Complementarity |     |     |
|     |         |     | JPM         | at least | once       | individually     | 67           | (90%)         | 94 (94%)        |     |     |
|     |         |     |             | JPM at   | least once | as pair          | 33           | (90%)         | 44 (88%)        |     |     |
|     |         |     |             |          | JPM pairs  |                  | 27           | (73%)         | 40 (80%)        |     |     |
Table 5. Number (percentage) of pairs and subjects that play at JPM level at least once and
|     | JPM | pairs. |     |     |     |     |     |     |     |     |     |
| --- | --- | ------ | --- | --- | --- | --- | --- | --- | --- | --- | --- |
observe any significant difference between strategic environments (Fisher’s tests yield p−values
0.4).22
greater than
Figure 6 shows the evolution of the degree of cooperation for both JPM and non-JPM pairs in
both strategic environments. The JPM pairs start at already high degrees of cooperation and grad-
ually reach full cooperation in average. The average choice of non-JPM pairs in complementarity
treatment is stable throughout the experiment, whereas there is a visible trend in substitution. In
fact, the average degree of cooperation over all periods under substitution is much higher for non-
JPM pairs when communication is allowed (0.28) compared to when communication is not allowed
(-0.07). This difference is not as large for complementarity (0.25 for non-JPM with communication
and 0.16 for without communication). We conclude that communication fosters cooperation in
substitution to a greater extent, even if it does not lead to full cooperation.23
Considering two strategic environments together, subjects both in JPM and non-JPM pairs
send on average 1.74 messages (s.d. = 1.90 and 1.91 respectively) per period. In the first half of the
experiment, average number of messages is 1.96 (s.d. = 1.80) and 1.86 (s.d. = 1.85), respectively.
Thenumberofmessagessentbynon-JPMsubjectsissignificantlyhighercomparedtoJPMsubjects
onlyinthesecondhalfoftheexperiment(1.62(s.d. = 1.96)and1.53(s.d. = 1.98),respectively,with
p = 0.014 from WMW two-tailed test). Table 6 shows these values for each strategic environment
| separately, |     | together | with | p−values |     | for corresponding | tests. |     |     |     |     |
| ----------- | --- | -------- | ---- | -------- | --- | ----------------- | ------ | --- | --- | --- | --- |
Subjects sent more messages in substitution treatments regardless of if they manage to reach
22Figures
|     |     | 17  | and 18 in | the Appendix | E   | show the evolution | of  | choices within | pairs. |     |     |
| --- | --- | --- | --------- | ------------ | --- | ------------------ | --- | -------------- | ------ | --- | --- |
23Also,thereisnovisibleend-gameeffectineitherofstrategicenvironments,whichmightindicatethatsubjectsin
non-JPMpairsarenotinvolvedinthegamestrategicallytotheextentthoseinJPMpairsare,whoshowasubstantial
| end-game |     | effect. |     |     |     |     |     |     |     |     |     |
| -------- | --- | ------- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
13

1.0
noitarepooC fo eergeD
0.5
0.0
−0.5
|     | 0   |     |     | 10  |     | 20  |     | 30  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
Period
|     |        |     | Non−JPM in Subs. | JPM in Subs.          | Non−JPM in Comp. |                 | JPM in Comp. |     |
| --- | ------ | --- | ---------------- | --------------------- | ---------------- | --------------- | ------------ | --- |
|     | Figure |     | 6. Average       | degree of cooperation | by               | JPM and non-JPM | pairs.       |     |
|     |        |     | Substitution     |                       |                  | Complementarity |              |     |
Periods non-JPM pairs JPM pairs p−value non-JPM pairs JPM pairs p−value
1-30 2.12 (2.02) 1.91 (1.99) 0.000 1.36 (1.71) 1.63 (1.83) 0.000
1-15 2.07 (1.90) 2.05 (1.86) 0.897 1.66 (1.78) 1.89 (1.76) 0.009
16-30 2.18 (2.14) 1.76 (2.11) 0.000 1.05 (1.58) 1.36 (1.87) 0.010
Table 6. Average number of messages per period (standard deviations in parentheses). Re-
| ported | p−values | are | for two-tailed | WMW tests. |     |     |     |     |
| ------ | -------- | --- | -------------- | ---------- | --- | --- | --- | --- |
and sustain full cooperation or not. In complementarity, JPM subjects send more messages both in
the first and second half of the experiment. In substitution, on the other hand, non-JPM subjects
send more messages in the second half of the experiment and there is no difference in the first half.
The fact that non-JPM subjects send fewer messages in complementarity compared to JPM
might indicate that the failure of cooperation in complementarity is due to failure in communi-
cation. On the other hand, non-JPM subjects send more messages in the substitution treatment,
which might indicate that even when subjects communicate (e.g., to find a common ground), com-
| munication | may not | lead | to cooperation, | which is harder. |     |     |     |     |
| ---------- | ------- | ---- | --------------- | ---------------- | --- | --- | --- | --- |
Inwhatfollows,weexplorechatcontentforabetterunderstandingofhowstrategicenvironment
| affects cooperative |     | behavior. |     |     |     |     |     |     |
| ------------------- | --- | --------- | --- | --- | --- | --- | --- | --- |
14

exempl
|     |     |     |                            | tromper                      | faudrait seulementpres | q u pardon            |                          |                                |
| --- | --- | --- | -------------------------- | ---------------------------- | ---------------------- | --------------------- | ------------------------ | ------------------------------ |
|     |     |     |                            | maximis                      | essai doi trouvé       | fera 25.4 h e in jeu  | attend                   |                                |
|     |     |     |                            | tiarved demand               | deja 32 personn        | comprend              | gagna                    |                                |
|     |     |     |                            | tiate éitiom jouer           | vie evarg ariv euro    | parc minut comment    | ensembl normal           | enfait                         |
|     |     |     |                            | confianc entr                | drager rtua choisi     | dernier tjrs          | ruelliem t’inquièt       |                                |
|     |     |     | jusqua                     | seul donn march              | 03 choix               | 7 invers soit         | luclac choisir           | maximum                        |
|     |     |     | retser commenc             | solut veut                   | pareilpens             | voir 27               | nifne cool exact         | mec                            |
|     |     |     |                            | tubed isav sorg erid 14 vite | mettr sert max         | 25                    | irpmoc xuep prendr       | j’aurai                        |
|     |     |     | experi                     | d’accord accord              | nob 22                 | comm                  | ias tniop parler         | fallait 25.6 quell             |
|     |     |     | compt face l’heur          | merci                        | 0 28                   |                       | rtua’l                   | iuped tiafer nu’uq             |
|     |     |     | total riartnoc sen dialogu | moin                         | 51 rdm                 | xued                  | dit                      | iamaj                          |
|     |     |     | norivne ssap tiafrap       | test truc 18                 |                        |                       | fini bien                | début dnerper                  |
|     |     |     |                            | titep rbmon port ruot        | 26 12                  |                       | 60 01 temp ell           | trouv dnom                     |
|     |     |     | tent cneirépxe             | 24                           | 4                      | 9                     | 2                        | chang                          |
|     |     |     | déjà long                  | même                         | 3                      | 6 5 gagn              | 25.5                     | niahcorp final gagnant c’etait |
|     |     |     | repus but                  | éngag nucahc                 | 8                      | ci                    |                          | dnerp somm 100                 |
|     |     |     | yeh iouqruop               | netniam iorc 16              | 20 fin                 | 1                     |                          | rentabl iasid                  |
|     |     |     | l’un risqu                 | metplus                      |                        |                       | encor                    | sac plutot                     |
|     |     |     | pck                        | tiod                         |                        |                       | chaqu                    | iarv 7.52 l’argent             |
|     |     |     | savai revient              | just sid                     |                        |                       |                          | pensai oh fonction             |
|     |     |     | possibl                    | revuort 13                   | mieuxfoi               | tuaf aussi            | uaelbat yasse voila      | d’autr gen reimerp             |
|     |     |     | faisant quelqu             | 19.14 tnos veux              | 86                     | rien                  | pui car                  | etap tîalp rehcrehc            |
|     |     |     | 26.5                       | mal period                   | gain ahah              | rest bonn ares        | joue                     |                                |
|     |     |     | part igétarts              | gard avant noir              | vu                     | toujour               | genr rapport avai        | tuot                           |
|     |     |     |                            | 82 jusqu’a connai combien    | voi 71 peu             | continu               | trompé                   |                                |
|     |     |     |                            | décision termin              | combinaison 11         | chiffr perdr parti    | 41 raison voulai         | fass                           |
|     |     |     |                            | changer cherch               | propos                 | clair tnemiarv perd   | périod haut centim souci |                                |
|     |     |     |                            | vont moyen beaucoup          | grand tape             | 40 ttem drem altern   | pier tiasiaf pey         |                                |
|     |     |     |                            | bout autant                  | 41.94 tuav 26−26       | celui                 | 41.27                    |                                |
|     |     |     |                            | qu’est                       | 9.52 vous risialp      | miaf désolé courhello |                          |                                |
j’avou hhaha
Figure 7. 298 stemmed terms that are used by subjects at least 10 times in total. Centrality,
| size,       | and colors | reflect frequencies. |     |     |     |     |     |     |
| ----------- | ---------- | -------------------- | --- | --- | --- | --- | --- | --- |
| 4.2 Message | Content    |                      |     |     |     |     |     |     |
We first look at the frequencies of the terms subjects used in their communication. The word cloud
in Figure 7 shows the terms that appeared in chats at least ten times.24 We build our analysis on
| chat records | for each | of 86 pairs.25 |     |     |     |     |     |     |
| ------------ | -------- | -------------- | --- | --- | --- | --- | --- | --- |
We first compare the most frequently used terms across treatments. To do so, we refer to the
relative rank differences (r.r.d., `a la Huerta, 2008) of 50 most frequent terms. For each term t, we
| compute | r.r.d. for | substitution | as  |        |     |         |       |     |
| ------- | ---------- | ------------ | --- | ------ | --- | ------- | ----- | --- |
|         |            |              |     |        | r   | C (t)−r | S (t) |     |
|         |            |              |     | ∆rC(t) | =   |         |       | ,   |
S
r S (t)
where r (t) stands for the rank of the word t in the decreasing order of the times it is used by the
C
subjects in the complementarity treatment, and r (t) stands for the substitution treatment. The
S
relative rank difference for complementarity, ∆rS(t), is symmetrically defined. We pay a particular
C
attentiontothosewordsthathaveeither∆rC(t) > 1or∆rS(t) > 1,followingFischerandNormann
|     |     |     |     |     | S   |     | C   |     |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
(2019).
Figure 8 shows the ranks of the top 50 words in both treatments.26 The shaded (green) area
24The
proceeding analysis is executed with the R packages quanteda (Benoit et al., 2018) and tm (Feinerer, 2018).
The stopwords we removed that may not be predefined in these packages are listed in the Appendix G.1. Details
of our preparation for the content analysis, which includes a mild orthographical clean-up necessitated by common
| mistakes, | will be provided | in the | online appendix. |     |     |     |     |     |
| --------- | ---------------- | ------ | ---------------- | --- | --- | --- | --- | --- |
25We exclude a pair in substitution treatment who did not communicate beyond first period. Some stopwords are
removed after the word cloud in Figure 7. This removal emptied one other subject’s chat content, thus we have 171
| subjects, | whose chat records | are | utilized. |     |     |     |     |     |
| --------- | ------------------ | --- | --------- | --- | --- | --- | --- | --- |
26Three terms are not included as they did not appear more than 10 times in substitution although they were in
the top 50 for complementarity. These are“period”(period),“tableau”(table), and“chiffr”(number), which are at
| 41st, 44th, | and 45th ranks | in complementarity, |     | respectively. |     |     |     |     |
| ----------- | -------------- | ------------------- | --- | ------------- | --- | --- | --- | --- |
15

150
ytiratnemelpmoC ni knaR
grave
100
dis
parc
dernier
|     |     |          |          |          | sai             | croi l'autr | 12         |           |          |     |     |
| --- | --- | -------- | -------- | -------- | --------------- | ----------- | ---------- | --------- | -------- | --- | --- |
|     | 50  |          |          | p o in t |                 |             | c          | o m pri   |          |     |     |
|     |     |          | mainten  |          | 2 5 .5          | t rop       |            | toujou r  |          |     |     |
|     |     |          |          | haha     | r ie n          |             | p e u in v | e rs      |          |     |     |
|     |     |          |          |          |                 | enco r      |            | fin t emp | meilleur |     |     |
|     |     |          |          | to u r   | au s s i re s t | conti       | n u        |           |          |     |     |
|     |     | deux     | foi      | pens     |                 | veux        | chaqu      |           |          |     | 25  |
|     |     |          |          | bien     |                 | gain        | moin       |           | 22       |     |     |
|     |     | mdr      | bon comm |          | mettr           | 20          |            |           |          |     |     |
|     |     |          |          | 2 24     | d'accord        |             |            |           |          |     |     |
|     |     | met plus |          | mieux    | pareil          |             |            |           |          |     |     |
|     |     |          | 10 (18)  |          | faut            |             |            |           |          |     |     |
|     |     | 0 26 28  | gagn     | même     |                 |             |            |           |          |     |     |
|     |     | 0        |          |          | 25              |             |            | 50        |          | 75  |     |
Rank in Substitution
Figure 8. The frequency rankings of 50 most used words in both treatments. Within the
shaded region we have −1/2 ≤ ∆rC(t) ≤ 1 and only outside this region we have either of
S
the difference greater than 1. The term“10”in substitution is matched with the term“18”in
complementarity as they are the corresponding optimal defection choices. Translations can be
|     | found | in Table | 9   | in Appendix | F.  |     |     |     |     |     |     |
| --- | ----- | -------- | --- | ----------- | --- | --- | --- | --- | --- | --- | --- |
indicates r.r.d. values smaller than or equal to 1.27 The rankings of words are remarkably similar
acrosstreatments. Thispointstothatcommunicationisutilizedinsimilarwaysinthetwostrategic
environments. Nevertheless, there are some observations we can make. For instance, there are two
terms (“mainten”and“grave”) that appear to be significantly more frequently used by subjects in
| substitution |     | treatment. |     |     |     |     |     |     |     |     |     |
| ------------ | --- | ---------- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
The term“mainten”stands only for the word“maintenant”, i.e.,“now”in English. A closer look
intochatcontentandchoicesinthegamerevealsthatthisdifferenceisduetotheexcessiveusageof
thewordbysubjectsinasmallsetofpairswhotrytosustainasophisticatedalternatingstrategy.28
This alternating strategy involves playing the action pair (28,10) in one round, and (10,28) in the
following. Thus, subjects remind each other quite frequently that“now”it is their turn to play, for
instance, the action“10”. And it is immediate to observe that this strategy is embraced by some
pairs as the action pair (28,10) maximizes the payoff for the first player (although the two-period
average payoff, 36.54, is lower than JPM, 41.94). The corresponding pair in complementarity is
(28,18), which pays the same to first player. However, this strategy is observed only in substitution
treatments as the reverse pays negative and much lower in complementarity (-7.56 vs. 4.87 in
substitution). Thechoicesofpairs(withIDs298,1894,2091,and2097)thatemploythisalternating
| strategy |     | can be | seen | in the Figure | 18  | in Appendix |     | E.  |     |     |     |
| -------- | --- | ------ | ---- | ------------- | --- | ----------- | --- | --- | --- | --- | --- |
The difference in popularity of the term (word)“grave”indicates that under substitution, more
subjects need to reassure and forgive the other one for maintaining full cooperation, as defections,
|     | 27Note | that ∆rC(t)=−∆rS(t)/(∆rS(t)+1). |     |     |     |     |     |     |     |     |     |
| --- | ------ | ------------------------------- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
|     |        | S                               |     | C   | C   |     |     |     |     |     |     |
28Figure 19 in the Appendix F shows that this term is not outside the shaded region for JPM pairs. Figure 20
| shows | the | same data | for | non-JPM | pairs. |     |     |     |     |     |     |
| ----- | --- | --------- | --- | ------- | ------ | --- | --- | --- | --- | --- | --- |
16

or mistakes, happen more.29
The terms that appear at higher ranks in complementarity, i.e.,“22”and“25”(together with
“20”and“24”, which also have relatively high r.r.d values, i.e., higher than 0.8), point to that in
complementarity the move towards full cooperation is more gradual, as discussions about interim
cooperative choices are more prevalent. That“25.5”, the exact value of JPM choice that is not in
the payoff tables, is slightly more popular among subjects in substitution might indicate that the
move is not as gradual but happens due to jumps to full cooperation.30
4.3 Structural topic modeling
The use of machine-assisted natural language processing techniques has not been considered until
very recently in analyses of communication data coming from (lab) experiments (see the beginning
of Section 4 for a review of common practices). Penczynski (2018) suggests, in the first ever
published paper with such an approach, that computer classification can be employed to validate
the consistency of previously used methods of content analyses and finds that a supervised learning
approach can replicate to a considerable extent the human classification of written accounts of
reasoning in terms of models of cognitive processes in experimental games of beauty contest, hide
and seek, social learning, and coordination.31 Georgalos and Hey (2019), on the other hand,
employ a Bayesian classifier algorithm to classify messages exchanged in a production game. Here,
we propose topic modeling for the analysis of chat data coming from lab experiments.
Topic models form an unsupervised method to recover generative underlying topics in a col-
lection of documents (corpora) to exploit the co-occurrence of words towards a classification of
documents. Structural topic models, which are logistic-normal mixed membership topic models,
built on the early works in topic modeling such as the Latent Dirichlet Analysis (Blei et al., 2003)
and the Correlated Topic Model (Blei and Lafferty, 2007), among others, allow researchers to in-
tegrate metadata (document-level covariates other than text) into the latent semantic analysis of
documents (see Roberts et al., 2014).
Particularly, in an STM, a set of covariates are chosen to explain topical variation across docu-
ments, and even variation in the usage of different words within topics. Let there be D documents.
A document d ∈ {1,...,D} is seen as beginning with a collection of N empty positions, each to
d
be filled with a word. Assume there are K topics that exist in the whole corpora. Then, to fill
a position, a topic k ∈ {1,...,K} will be chosen according to a distribution over topics firstly.
The chosen topic is also a probability distribution, this time over words in the vocabulary (of the
corpora), and it is according to this the choice of the particular word for each empty position is
made. The metadata used in an STM estimation comes into play in recovering the probability
distributions both over topics (topic prevalence) and words (topical content). Topical prevalence
refers to how much of a document is associated with a topic. Topical content, on the other hand,
29The term appears as in“ce n’est pas grave”, which translates as“it does not matter”in English, in the chat
content of 7 (3) subjects in 5 (3) pairs in substitution (complementarity). They use this term as in this sentence to
show forgiveness for a cheating attempt or a (self-declared) mistake by the opponent. Details can be provided upon
request.
30Figure 19 in Appendix F supports this argument, as the differences between 25.5 and other interim values (such
as 20, 22, 24) in terms of prevalence in different strategic environments seem to be more pronounced for JPM pairs.
31Arad and Penczynski (2018) employ the (random forest) method proposed in Penczynski (2018) for the analysis
of reasoning in Blotto games.
17

tas p d lu ac s cord m co e m t m mieu fo b x i on 26 de ja u i x r f e a s u t t 2818 2 22 4 mdr gagn m ga e i t n trpens 552 bien 20 invers netniam nif peuencor aussi 25 10 moin veux pareil ruojuot haha tour chaqu continu prend rien isiohc reg t a ro rd uv pointpropos co c m o p m ri blainuatrison meisllaeiur jus d q it ua vu chpoei p xr a io rf d ait d c 1 r e o 41 r i mn 6 iea c rx ehsifsfraydis 2626 te 1 m 2ch p acun tableau rbmon combien merci paprcériovdraiment euro doit cotrmoumveént mettr2628 cherch met m q c e u ah n i ra l fci n nhg truc 68 gt d rroair pvee 10deux co p mpeop rdurerqnudoi rapapuotrrt pcehuoxisir perdr
a. Topic 1.
ngag foibon 12 point mainten plusjai doirep tas 20 droccad mieux25veenucxor combien entr chiffr march rien dialogu 16 faut compritermin neib dernier parc 6262 iouqruop trucdischoisietap regard tourhaha prochain 22 18 maltoeinrn 51 chac2u4ntableauferaperdr choix ssaili 14 preesut comnommbr beapulcaoîtupgain iorc voi 23 mett grave fin dit essai just perd chaqu titep trvoopila icrem contracironfianc ensembl vcitoentinu essay propos granddonn revnel comprend aussi gagné tem pe p ux mdr mêmes quil max plus fonction
b. Topic 2.
ngag p c e h nr a e c ss u b t n e b taou o cuo n urp 28jai co t m ro m p bien c f r o2 o i0 i meti v lole e uu u jor x u ta r s d a e u u s 2 s x 6 i m co i n e ti u nu xmdaectc g o e rd nr iarv rentabl gain point uep lautr somm tape hhahaparc ahah confianc voi just voir 24 dire éloséd trouvetait tinquièt moin faut tehnein vfiun merci combien calcreuglard lam exact10 doit cthaanqtuplaisir srevni autr oh cs t ea rg n u va s t c a p i g e mi e n rrt a d n r t perd driieanlogu cas iaruaj refait gagna limpress joue 30 16 jouer long rapport jen 04 deja javai final serieux nimret raison vite déjà
c. Topic 3.
Figure 9. Word clouds for each topic.
refers to the words used in topics.32
We estimated a model with three topics, while topic prevalence is assumed to be dependent on
the strategic environment and full cooperation behavior, without a topical content covariate. The
basis of analysis is the chat content for each pair throughout the experiment. A detailed account
of our procedures regarding model selection can be found in the Appendix G.
4.3.1 Topical content and prevalence
Figure 9 shows the word clouds for each topic separately. In the first topic, most used term is“26”,
the JPM choice on the payoff table. In the second topic, it is the verb ”met”(“put”in English),
and in the third topic, it is“mdr”(acronym for“mort de rire”, corresponding to“lol”or“laughing
out loud”in English, although literally“dead from laughing”).
Figure 10 shows the results from a regression estimation where chat content in pairs are the
units, the outcome is the proportion of each document devoted to a topic in an STM model, and
the explanatory dummy variables indicate strategic environment and whether the pair is a JPM
pair or not.33 This estimation shows that in complementarity, Topic 1 is used relatively more and
Topic 2 and 3 are used more in substitution. On the other hand, while non-JPM subjects use Topic
2 more, JPM subjects use Topic 3 more. In what follows we look at these patterns more closely.
We divide JPM pairs into early and eventual JPM pairs. We say that a JPM pair is an
early JPM pair if both players in the pair choose 24 or higher for 7 or more times in the first
10 periods.34 A JPM pair that is not an early JPM pair is called an eventual JPM pair. The
percentage of early JPM subjects are the same in both treatments (Pr[early JPM|SUBS] = 0.44
32We refer the reader to Roberts et al. (2016) for the formal aspects of the estimation procedure. In short, model
estimationusesafastsemi-collapsed,variationalexpectationmaximizationalgorithmwhereLaplaceapproximations
are used for the non-conjugate portions of the model.
33This procedure incorporates measurement uncertainty from the STM model using the method of composition
(see Roberts et al., 2019, for details). Appendix G.3 contains the estimated topic proportions for each pair in both
treatments and Appendix G.4 delivers a set of examples of chat contents together with estimated topic proportions.
34Symmetricstrategypairsthatarehigherthan24payverysimilartowhatJPMpays. ForinstanceπS(28,28)=
πS(28,28) = 41.272 and πC(24,24) = πS(24,24) = 41.696, whereas πC(25.5,25.5) = πS(25.5,25.5) = 41.94. Thus,
subjects may not be able to coordinate on the most efficient cooperation although they intend to in the first few
periods. Oursubsequentobservationsarerobusttosmallchangesinthechoiceofthisinterval. Webelievethechoice
of 7periods (insteadof 5 or 6) wouldnotbe of significantimportance for the purpose of thisdiscussion. Detailscan
be provided upon request.
18

|     |     |      |      | 1   |     |     |     |     |      | 1    |         |     |
| --- | --- | ---- | ---- | --- | --- | --- | --- | --- | ---- | ---- | ------- | --- |
|     |     |      | 2    |     |     |     |     |     | 2    |      |         |     |
|     |     |      | 3    |     |     |     |     |     |      |      | 3       |     |
|     |     | −0.4 | −0.2 | 0.0 | 0.2 | 0.4 |     |     | −0.4 | −0.2 | 0.0 0.2 | 0.4 |
a. Effectofstrategicenvironment. Positivevalues b. EffectofJPMbehavior. Positivevaluesindicate
indicate higher prevalence in the chat content of higherprevalenceinthechatcontentofsubjectsin
|     | subjects | in complementarity |     |     | treatment. |     |     | JPM | pairs. |     |     |     |
| --- | -------- | ------------------ | --- | --- | ---------- | --- | --- | --- | ------ | --- | --- | --- |
Figure 10. MeandifferencesintopicproportionsforstrategicenvironmentandJPMbehavior
|     | together | with    | 95%  | confidence | intervals. |      |       |         |     |       |          |         |
| --- | -------- | ------- | ---- | ---------- | ---------- | ---- | ----- | ------- | --- | ----- | -------- | ------- |
|     | Topics   |         |      | All        | Non-JPM    |      | JPM   | p−value |     | Early | Eventual | p−value |
|     | 1        |         | Comp | 0.46       |            | 0.32 | 0.49  | 0.199   |     | 0.39  | 0.60     | 0.012   |
|     |          |         | Subs | 0.25       |            | 0.33 | 0.22  | 0.424   |     | 0.19  | 0.28     | 0.283   |
|     |          | p−value |      | 0.001      | 0.948      |      | 0.000 |         |     | 0.009 | 0.001    |         |
|     | 2        |         | Comp | 0.23       |            | 0.48 | 0.17  | 0.034   |     | 0.14  | 0.20     | 0.278   |
|     |          |         | Subs | 0.33       |            | 0.51 | 0.27  | 0.081   |     | 0.24  | 0.31     | 0.412   |
|     |          | p−value |      | 0.078      | 0.855      |      | 0.049 |         |     | 0.134 | 0.173    |         |
|     | 3        |         | Comp | 0.31       |            | 0.20 | 0.34  | 0.241   |     | 0.47  | 0.20     | 0.001   |
|     |          |         | Subs | 0.42       |            | 0.16 | 0.51  | 0.002   |     | 0.57  | 0.41     | 0.154   |
|     |          | p−value |      | 0.106      | 0.739      |      | 0.020 |         |     | 0.271 | 0.032    |         |
|     | #        |         | Comp | 49         |            | 9    | 40    |         |     | 21    | 19       |         |
|     |          |         | Subs | 36         |            | 9    | 27    |         |     | 16    | 11       |         |
Table 7. Mean topic proportions. p−values are due to two-sided t−tests with null hypotheses
|     | that | topic | proportions | do  | not differ. |     |     |     |     |     |     |     |
| --- | ---- | ----- | ----------- | --- | ----------- | --- | --- | --- | --- | --- | --- | --- |
and Pr[early JPM|COMP] = 0.43). This indicates that jumping to JPM is equally likely in both
strategic environments. However, it appears that among the pairs who do not reach and sustain
full cooperation early on, eventual cooperation is less likely under substitution (Pr[JPM|not early,
| SUBS] | =   | 0.55 | and Pr[JPM|not |     | early, | COMP] |     | = 0.68). |     |     |     |     |
| ----- | --- | ---- | -------------- | --- | ------ | ----- | --- | -------- | --- | --- | --- | --- |
Table 7 shows the mean topic proportions. Note that Topic 1 is more popular among eventual
JPM pairs in complementarity. As interim choices (such as 20, 22, and 24) appear with relatively
higher frequencies in this topic, we conclude that these pairs reach full cooperation by agreeing on
gradual moves towards cooperation. On the other hand, we do not see any significant difference
between early and eventual JPM pairs in the substitution. Finally, Topic 3 is used more by JPM
pairsinbothtreatments. Whilethedifferenceissignificantinsubstitution,incomplementarity,itis
not. However,thistopicissignificantlymorefrequentlyusedbyearlyJPMpairsthaneventualJPM
pairs in complementarity. These differences point to a possibility that those pairs who managed to
reach and sustain full cooperation switch to a more collegial conversation, not necessarily related
to the game anymore, reflected by the large weight of the term“mdr”.
19

5 Conclusion
Social dilemmas are prevalent in economic decision-making processes and strategic environment is
argued to have a significant impact on how they are resolved.35 Our results confirm previous find-
ings,whichareclearlyidentifiedbyPS,thatintheabsenceofcommunication,aggregatebehavioris
more cooperative under complementarity as opposed to substitution. Our results beyond this point
differ from that of PS, however, in that the higher degree of cooperation under complementarity is
not due to the higher degree of reciprocity in our data. Rather, it can be explained by noisy choices
and slow learning. Differences in subject pools, as discussed in Footnote 13, can account for these
differences.
Our major findings relate to the impact of communication in interaction with the strategic
environment. Firstly, communication boosts cooperation levels in both strategic environments.
Secondly, communication has an ironing effect regarding the impact of strategic environment, in
thatthedegreeofcooperationintwostrategicenvironmentsbecomesthesamewithcommunication.
Consideringmanyinstancesinwhicheliminatingcommunicationcompletelymaynotbeviable, our
findings point to that the strategic environment would not matter in terms of cooperation levels (or
collusionlevelsasinoligopolymarkets).36 However,thereremainsomedifferences. Communication
ismoreeffectiveinhelpingparticipantstocooperate,evenifnotattheefficientlevel,insubstitution
than in complementarity. Also, reaching efficient cooperation happens in a more gradual fashion
under complementarity. Our results from the structural topic model estimation show that the use
of machine learning techniques can be promising for the content analysis of experimental chat data.
Through our estimations, we are able to automatically categorize the topics subjects talk about in
their chats according to their cooperative behavior and the strategic environment they are in.
Acknowledgments
We are grateful to Colin Camerer, Jernej Cˇopiˇc, Charles Holt, Kenan Huremovi´c, Yukio Koriyama,
Nikhil Kotecha, Antonin Mac´e, Aidas Masiliu¯nas, Paul Pezanis-Christou, Charles Plott, Kirill
Pogorelskiy, Jan Potters, Owen Powell, Erik Wengstr¨om, Sevgi Yuksel, and participants in Murat
Sertel Workshop in Paris, Economic Science Association World Meeting in San Diego, Southwest
Experimental and Behavioral Economics Workshop in Santa Barbara, Istanbul Bilgi University
Experimental Economics Seminars, Economic Design Workshop at CNAM in Paris, GATE-LSE
seminars in Lyon, LAMETA seminars in Montpellier, Behavioral and Experimental Analyses in
Macro-finance Workshop in Nice, Theory, Organization, and Markets seminar at Paris School of
Economics, CREST Workshop in Experimental Economics, and T&C Chen Center lab meetings at
Caltech. We are grateful to Erina Hanaki for translations from French to English.
35See Eaton (2004) for an overview of the prevalence of strategic environment effects in social dilemma situations
in economic studies. These include patent races, international trade policies, arms races, team productions, public
goods, and so on.
36Similarconclusionscanbedrawnforteamproductioninstances,inwhichskillsofthemembersofteammightbe
complementsorsubstitutes,R&Dcompetitioninwhichhighspilloverswouldinducecomplementaritywhereaslower
spillovers would induce substitution, and public good production processes, in which the nature of returns to scale
would imply complementarity or substitution, among others.
20

References
| Airoldi, | E.  | M. and | J. M. | Bischof |         |            |     |            |              |           |
| -------- | --- | ------ | ----- | ------- | ------- | ---------- | --- | ---------- | ------------ | --------- |
|          |     |        |       |         | (2016): | “Improving | and | Evaluating | Topic Models | and Other |
Models of Text,”Journal of the American Statistical Association, 111, 1381–1403.
Al-Ubaydli, O., G. Jones, and J. Weel (2016): “Average player traits as predictors of coop-
eration in a repeated prisoner’s dilemma,”Journal of Behavioral and Experimental Economics,
64, 50–60.
Andersson, O., M. M. Galizzi, T. Hoppe, S. Kranz, K. Van Der Wiel, and
Wengstro¨m
E. (2010): “Persuasion in experimental ultimatum games,” Economics Letters,
108, 16–18.
| Andersson, |     | O. and | E. Wengstro¨m |     |     |                   |               |     |                  |        |
| ---------- | --- | ------ | ------------- | --- | --- | ----------------- | ------------- | --- | ---------------- | ------ |
|            |     |        |               |     |     | (2012): “Credible | communication |     | and cooperation: | exper- |
imental evidence from multi-stage games,” Journal of Economic Behavior & Organization, 81,
207–219.
Arad, A. and S. Penczynski (2018): “Multi-Dimensional Reasoning in Competitive Resource
Allocation Games: Evidence from Intra-Team Communication,”Working paper.
Arora, S., R. Ge, Y. Halpern, D. Mimno, A. Moitra, D. Sontag, Y. Wu, and M. Zhu
(2013): “A practical algorithm for topic modeling with provable guarantees,” in International
| Conference |     | on Machine | Learning, |     | 280–288. |     |     |     |     |     |
| ---------- | --- | ---------- | --------- | --- | -------- | --- | --- | --- | --- | --- |
Awaya, Y. and V. Krishna (2016): “On communication and collusion,”The American Economic
| Review,     | 106, | 285–315. |         |     |                 |     |         |            |             |              |
| ----------- | ---- | -------- | ------- | --- | --------------- | --- | ------- | ---------- | ----------- | ------------ |
| Babutsidze, |      | Z., N.   | Hanaki, | and | A. Zylbersztejn |     |         |            |             |              |
|             |      |          |         |     |                 |     | (2020): | “Nonverbal | content and | swift trust: |
An experiment on digital communication,”Available at SSRN 3540258.
Benoit, K., K. Watanabe, H. Wang, P. Nulty, A. Obeng, S. Mu¨ller, and A. Matsuo
(2018): “quanteda: An R package for the quantitative analysis of textual data,”Journal of Open
| Source | Software, |     | 3, 774. |     |     |     |     |     |     |     |
| ------ | --------- | --- | ------- | --- | --- | --- | --- | --- | --- | --- |
Bigoni, M., J. Potters, and G. Spagnolo (2018): “Frequency of interaction, communication
| and | collusion: | an  | experiment,”Economic |     |     | Theory, | 1–18. |     |     |     |
| --- | ---------- | --- | -------------------- | --- | --- | ------- | ----- | --- | --- | --- |
Blei, D. M. and J. D. Lafferty (2007): “A correlated topic model of science,”The Annals of
| Applied | Statistics, |     | 17–35.    |              |     |         |         |           |              |            |
| ------- | ----------- | --- | --------- | ------------ | --- | ------- | ------- | --------- | ------------ | ---------- |
| Blei,   | D. M.,      | A.  | Y. Ng,    | and M.       | I.  | Jordan  |         |           |              |            |
|         |             |     |           |              |     | (2003): | “Latent | dirichlet | allocation,” | Journal of |
| machine | Learning    |     | research, | 3, 993–1022. |     |         |         |           |              |            |
Blonski, M., P. Ockenfels, and G. Spagnolo (2011): “Equilibrium selection in the repeated
prisoner’s dilemma: Axiomatic approach and experimental evidence,”American Economic Jour-
| nal: | Microeconomics, |     | 3, 164–192. |     |     |     |     |     |     |     |
| ---- | --------------- | --- | ----------- | --- | --- | --- | --- | --- | --- | --- |
Brandts, J., D. J. Cooper, and C. Rott (2019): “21. Communication in laboratory experi-
ments,”Handbook of Research Methods and Applications in Experimental Economics, 401.
21

Brandts, J., M. Ellman, and G. Charness (2015): “Let’s talk: How communication affects
contract design,”Journal of the European Economic Association, 14, 943–974.
Breaban, A., C. N. Noussair, and A. V. Popescu (2020): “Contests with money and time:
Experimental evidence on overbidding in all-pay auctions,” Journal of Economic Behavior &
| Organization, |       | 171, | 391–405. |     |         |       |                |     |        |              |                 |     |
| ------------- | ----- | ---- | -------- | --- | ------- | ----- | -------------- | --- | ------ | ------------ | --------------- | --- |
| Cason,        | T. N. | and  | V.-L.    | Mui |         |       |                |     |        |              |                 |     |
|               |       |      |          |     | (2015): | “Rich | communication, |     | social | motivations, | and coordinated |     |
resistance against divide-and-conquer: A laboratory investigation,”European Journal of Political
| Economy, | 37,    | 146–159. |               |     |     |     |       |         |                |     |                |     |
| -------- | ------ | -------- | ------------- | --- | --- | --- | ----- | ------- | -------------- | --- | -------------- | --- |
| Cason,   | T. N., | R.       | M. Sheremeta, |     | and | J.  | Zhang |         |                |     |                |     |
|          |        |          |               |     |     |     |       | (2012): | “Communication |     | and efficiency | in  |
competitive coordination games,”Games and Economic Behavior, 76, 26–43.
Charness, G. and M. Dufwenberg (2006): “Promises and partnership,” Econometrica, 74,
1579–1601.
——— (2011): “Participation,”The American Economic Review, 101, 1211–1237.
| Cooper, | D.  | J. and | J. H. | Kagel(2005): |     |                            |     |     |     |                      |     |     |
| ------- | --- | ------ | ----- | ------------ | --- | -------------------------- | --- | --- | --- | -------------------- | --- | --- |
|         |     |        |       |              |     | “Aretwoheadsbetterthanone? |     |     |     | Teamversusindividual |     |     |
play in signaling games,”The American economic review, 95, 477–509.
| Cooper, | D.  | J. and | K.-U. | Ku¨hn |         |     |                 |     |                |     |               |     |
| ------- | --- | ------ | ----- | ----- | ------- | --- | --------------- | --- | -------------- | --- | ------------- | --- |
|         |     |        |       |       | (2014): |     | “Communication, |     | renegotiation, |     | and the scope | for |
collusion,”American Economic Journal: Microeconomics, 6, 247–278.
Corazzini, L., S. Kube, M. A. Mare´chal, and A. Nicolo (2014): “Elections and deceptions:
an experimental study on the behavioral effects of democracy,” American Journal of Political
| Science, | 58, | 579–592. |     |     |     |     |     |     |     |     |     |     |
| -------- | --- | -------- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
Crawford, V. P. (2019): “Experiments on Cognition, Communication, Coordination, and Coop-
eration in Relationships,”Annual Review of Economics, 11, 167–191.
| Eaton, | B. C. |     |     |     |     |     |     |     |     |     |     |     |
| ------ | ----- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
(2004): “The elementary economics of social dilemmas,”Canadian Journal of Eco-
| nomics/Revue |     | canadienne |     | d’´economique, |     | 37, | 805–829. |     |     |     |     |     |
| ------------ | --- | ---------- | --- | -------------- | --- | --- | -------- | --- | --- | --- | --- | --- |
| Echenique,   |     | F.         |     |                |     |     |          |     |     |     |     |     |
(2004): “Extensive-form games and strategic complementarities,”Games and Eco-
| nomic | Behavior, |     | 46, 348–364. |     |     |     |     |     |     |     |     |     |
| ----- | --------- | --- | ------------ | --- | --- | --- | --- | --- | --- | --- | --- | --- |
Ellingsen, T. and M. Johannesson (2008): “Anticipated verbal feedback induces altruistic
| behavior,”Evolution |     |     | and | Human | Behavior, |     | 29, 100–105. |     |     |     |     |     |
| ------------------- | --- | --- | --- | ----- | --------- | --- | ------------ | --- | --- | --- | --- | --- |
Embrey, M., G. R. Fre´chette, and S. Yuksel (2017): “Cooperation in the finitely repeated
prisoner’s dilemma,”The Quarterly Journal of Economics, 133, 509–551.
| Erev, | I. and | A. E. | Roth |     |     |     |     |     |     |     |     |     |
| ----- | ------ | ----- | ---- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
(1998): “Predicting how people play games: Reinforcement learning in
experimentalgameswithunique,mixedstrategyequilibria,”American economic review,848–881.
| Farrell, | J.  | and | M. Rabin |         |        |     |        |     |         |             |               |     |
| -------- | --- | --- | -------- | ------- | ------ | --- | ------ | --- | ------- | ----------- | ------------- | --- |
|          |     |     |          | (1996): | “Cheap |     | talk,” | The | Journal | of Economic | Perspectives, | 10, |
103–118.
22

Feinerer, I. (2018): “Introduction to the tm Package Text Mining in R,” Retrieved March, 1,
2019.
Fischbacher, U. (2007): “z-Tree: Zurich toolbox for ready-made economic experiments,”Experi-
| mental   | economics, | 10,   | 171–178. |     |         |            |     |            |               |     |         |     |
| -------- | ---------- | ----- | -------- | --- | ------- | ---------- | --- | ---------- | ------------- | --- | ------- | --- |
| Fischer, | C. and     | H.-T. | Normann  |     |         |            |     |            |               |     |         |     |
|          |            |       |          |     | (2019): | “Collusion | and | bargaining | in asymmetric |     | Cournot |     |
duopoly – An experiment,”European Economic Review, 111, 360–379.
| Fonseca,            | M. A. | and | H.-T.    | Normann       |         |             |     |        |            |              |     |     |
| ------------------- | ----- | --- | -------- | ------------- | ------- | ----------- | --- | ------ | ---------- | ------------ | --- | --- |
|                     |       |     |          |               | (2014): | “Endogenous |     | cartel | formation: | Experimental |     |     |
| evidence,”Economics |       |     | Letters, | 125, 223–225. |         |             |     |        |            |              |     |     |
Gentzkow, M., B. Kelly, and M. Taddy (2019): “Text as data,”Journal of Economic Liter-
| ature, | 57, 535–74. |     |     |     |     |     |     |     |     |     |     |     |
| ------ | ----------- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
Gentzkow, M. and J. M. Shapiro (2010): “What drives media slant? Evidence from US daily
| newspapers,”Econometrica, |            |       | 78,           | 35–71.  |          |              |           |         |                |                |             |     |
| ------------------------- | ---------- | ----- | ------------- | ------- | -------- | ------------ | --------- | ------- | -------------- | -------------- | ----------- | --- |
| Georgalos,                | K.         | and   | J. Hey        |         |          |              |           |         |                |                |             |     |
|                           |            |       |               | (2019): | “Testing | for the      | emergence | of      | spontaneous    | order,”Experi- |             |     |
| mental                    | Economics, | 1–21. |               |         |          |              |           |         |                |                |             |     |
| Gomez-Martinez,           |            | F.,   | S. Onderstal, |         | and      | J. Sonnemans |           |         |                |                |             |     |
|                           |            |       |               |         |          |              |           | (2016): | “Firm-specific |                | information |     |
and explicit collusion in experimental oligopolies,”European Economic Review, 82, 132–141.
Grajzl, P. and P. Murrell (2019): “Toward understanding 17th century English culture: A
structuraltopicmodelofFrancisBacon’sideas,”Journal of Comparative Economics,47,111–135.
Greiner, B.(2015): “Subjectpoolrecruitmentprocedures: organizingexperimentswithORSEE,”
| Journal | of the | Economic | Science | Association,        |     | 1, 114–125. |         |                |     |                   |     |     |
| ------- | ------ | -------- | ------- | ------------------- | --- | ----------- | ------- | -------------- | --- | ----------------- | --- | --- |
| Hanaki, | N., A. | Kirman,  | and     | P. Pezanis-Christou |     |             |         |                |     |                   |     |     |
|         |        |          |         |                     |     |             | (2018): | “Observational |     | and reinforcement |     |     |
pattern-learning: An exploratory study,”European Economic Review, 104, 1–28.
| Hanaki,  | N., R.   | Sethi, | I. Erev,      | and | A. Peterhansl |     |         |           |                     |     |     |     |
| -------- | -------- | ------ | ------------- | --- | ------------- | --- | ------- | --------- | ------------------- | --- | --- | --- |
|          |          |        |               |     |               |     | (2005): | “Learning | strategies,”Journal |     |     | of  |
| Economic | Behavior | &      | Organization, |     | 56, 523–542.  |     |         |           |                     |     |     |     |
Hansen, S. and M. McMahon (2016): “Shocking language: Understanding the macroeconomic
effects of central bank communication,”Journal of International Economics, 99, S114–S133.
Hennig-Schmidt, H., Z.-Y. Li, and C. Yang (2008): “Why people reject advantageous offers:
Non-monotonic strategies in ultimatum bargaining: Evaluating a video experiment run in PR
China,”Journal of Economic Behavior & Organization, 65, 373–384.
| Holt, | C. A. |     |     |     |     |     |     |     |     |     |     |     |
| ----- | ----- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
(1993): “Industrial organization: A survey of laboratory research,”The handbook of
| experimental | economics, |     | 349, | 402–03. |     |     |     |     |     |     |     |     |
| ------------ | ---------- | --- | ---- | ------- | --- | --- | --- | --- | --- | --- | --- | --- |
Houser, D.andE.Xiao(2011):“Classificationofnaturallanguagemessagesusingacoordination
| game,”Experimental |     |     | Economics, | 14, | 1–14. |     |     |     |     |     |     |     |
| ------------------ | --- | --- | ---------- | --- | ----- | --- | --- | --- | --- | --- | --- | --- |
23

Huerta, J. M. (2008): “Relative rank statistics for dialog analysis,” in Proceedings of the Con-
ference on Empirical Methods in Natural Language Processing, Association for Computational
| Linguistics, | 965–972. |     |     |     |     |     |     |     |     |     |     |
| ------------ | -------- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
Kimbrough, E., V. L. Smith, and B. J. Wilson (2008): “Historical property rights, sociality,
and the emergence of impersonal exchange in long-distance trade,” The American Economic
| Review,     | 98, 1009–1039. |     |     |     |     |     |     |     |     |     |     |
| ----------- | -------------- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| McAllister, | P.             | H.  |     |     |     |     |     |     |     |     |     |
(1991): “Adaptive approaches to stochastic programming,”Annals of Opera-
| tions | Research, | 30, 45–62. |     |     |     |     |     |     |     |     |     |
| ----- | --------- | ---------- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
Mengel, F. (2017): “Risk and Temptation: A Meta-Study on Prisoner’s Dilemma Games,”The
| Economic | Journal. |             |     |            |     |         |              |     |                 |     |          |
| -------- | -------- | ----------- | --- | ---------- | --- | ------- | ------------ | --- | --------------- | --- | -------- |
| Mermer,  | A. G.,   | W. Mu¨ller, | and | S. Suetens |     |         |              |     |                 |     |          |
|          |          |             |     |            |     | (2016): | “Cooperation |     | in Indefinitely |     | Repeated |
Games of Strategic Complements and Substitutes,” University of Vienna, Department of Eco-
| nomics, | Working | paper. |     |     |     |     |     |     |     |     |     |
| ------- | ------- | ------ | --- | --- | --- | --- | --- | --- | --- | --- | --- |
Mimno, D., H. M. Wallach, E. Talley, M. Leenders, and A. McCallum(2011):“Optimiz-
ing semantic coherence in topic models,”in Proceedings of the conference on empirical methods
in natural language processing, Association for Computational Linguistics, 262–272.
Mueller, H. and C. Rauh (2018): “Reading between the lines: Prediction of political violence
using newspaper text,”American Political Science Review, 112, 358–375.
| Noussair, | C.  | N., S. Tucker, |     | and Y. Xu |         |     |          |          |           |     |              |
| --------- | --- | -------------- | --- | --------- | ------- | --- | -------- | -------- | --------- | --- | ------------ |
|           |     |                |     |           | (2016): |     | “Futures | markets, | cognitive |     | ability, and |
mispricing in experimental asset markets,”Journal of Economic Behavior & Organization, 130,
166–179.
Penczynski, S. P. (2018): “Using machine learning for communication classification,”Experimen-
| tal Economics, |        | 1–28.      |         |              |     |     |              |     |          |           |         |
| -------------- | ------ | ---------- | ------- | ------------ | --- | --- | ------------ | --- | -------- | --------- | ------- |
| Potters,       | J. and | S. Suetens |         |              |     |     |              |     |          |           |         |
|                |        |            | (2009): | “Cooperation |     | in  | experimental |     | games of | strategic | comple- |
ments and substitutes,”The Review of Economic Studies, 76, 1125–1147.
——— (2013): “Oligopoly experiments in the current millennium,”Journal of Economic Surveys,
27, 439–460.
Roberts, M., B. Stewart, and D. Tingley (2019): “stm: An R Package for Structural Topic
| Models,”Journal |        | of Statistical | Software, | Articles, |            | 91, | 1–40.   |     |               |     |            |
| --------------- | ------ | -------------- | --------- | --------- | ---------- | --- | ------- | --- | ------------- | --- | ---------- |
| Roberts,        | M. E., | B. M. Stewart, |           | and E.    | M. Airoldi |     |         |     |               |     |            |
|                 |        |                |           |           |            |     | (2016): | “A  | model of text | for | experimen- |
tation in the social sciences,”Journal of the American Statistical Association, 111, 988–1003.
Roberts, M. E., B. M. Stewart, D. Tingley, C. Lucas, J. Leder-Luis, S. K. Gadarian,
B. Albertson, and D. G. Rand (2014): “Structural Topic Models for Open-Ended Survey
| Responses,”American |                          | Journal       | of  | Political    | Science, | 58, | 1064–1082. |      |           |             |     |
| ------------------- | ------------------------ | ------------- | --- | ------------ | -------- | --- | ---------- | ---- | --------- | ----------- | --- |
| Sabarwal,           | T.                       | and H. VuXuan |     |              |          |     |            |      |           |             |     |
|                     |                          |               |     | (2018): “Two | Stage    | 2x2 | Games      | with | Strategic | Substitutes | and |
| Strategic           | Heterogeneity,”Available |               |     | at SSRN      | 3322176. |     |            |      |           |             |     |
24

Schotter, A. and B. Sopher (2007): “Advice and behavior in intergenerational ultimatum
games: An experimental approach,”Games and Economic Behavior, 58, 365–393.
Selten, R. and R. Stoecker (1986): “End behavior in sequences of finite Prisoner’s Dilemma
supergames A learning theory approach,”Journal of Economic Behavior & Organization, 7, 47–
70.
| Suetens,   | S. and | J. Potters    |     |         |                 |          |             |               |              |         |
| ---------- | ------ | ------------- | --- | ------- | --------------- | -------- | ----------- | ------------- | ------------ | ------- |
|            |        |               |     | (2007): | “Bertrand       | colludes | more than   | Cournot,”     | Experimental |         |
| Economics, | 10,    | 71–77.        |     |         |                 |          |             |               |              |         |
| Sutter,    | M. and | C. Strassmair |     |         |                 |          |             |               |              |         |
|            |        |               |     | (2009): | “Communication, |          | cooperation | and collusion |              | in team |
tournaments: an experimental study,”Games and Economic Behavior, 66, 506–525.
Taddy, M. (2012): “On estimation and selection for topic models,”in International Conference on
| Artificial | Intelligence | and | Statistics, |     | 1184–1193. |     |     |     |     |     |
| ---------- | ------------ | --- | ----------- | --- | ---------- | --- | --- | --- | --- | --- |
Vives, X. (2009): “Strategic complementarity in multi-stage games,”Economic Theory, 40, 151–
171.
| Waichman,  | I.,            | T. Requate, | et          | al. |             |                |            |              |     |        |
| ---------- | -------------- | ----------- | ----------- | --- | ----------- | -------------- | ---------- | ------------ | --- | ------ |
|            |                |             |             |     | (2014):     | “Communication | in Cournot | competition: |     | An ex- |
| perimental | study,”Journal |             | of Economic |     | Psychology, | 42, 1–16.      |            |              |     |        |
Wallach, H.M., I.Murray, R.Salakhutdinov, andD.Mimno(2009):“Evaluationmethods
fortopicmodels,”inProceedings of the 26th annual international conference on machine learning,
| ACM, | 1105–1112. |     |     |     |     |     |     |     |     |     |
| ---- | ---------- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
Wang, S. and D. Houser (2019): “Demanding or deferring? an experimental analysis of the
economic value of communication with attitude,”Games and Economic Behavior, 115, 381–395.
Weingast, B. R. (1995): “The economic role of political institutions: Market-preserving federal-
ism and economic development,”Journal of Law, Economics, & Organization, 1–31.
| Whinston, | M.  | D.      |           |     |           |                |       |        |     |     |
| --------- | --- | ------- | --------- | --- | --------- | -------------- | ----- | ------ | --- | --- |
|           |     | (2008): | “Lectures | on  | antitrust | economics,”MIT | Press | Books. |     |     |
25

|     | A   | Instructions | for treatments |     | with chat |
| --- | --- | ------------ | -------------- | --- | --------- |
Authors’ note: The following were read aloud and distributed in the beginning of the sessions within
chat treatments, for both complementarity and substitution. Aside from these instructions, subjects
| also received | payoff tables. |     |     |     |     |
| ------------- | -------------- | --- | --- | --- | --- |
You are participating in an experiment on economic decision-making and will be asked to make
a number of decisions. If you follow the instructions carefully, you can earn a considerable amount
of money. At the end of the experiment, you will be paid your earnings in private and in cash.
During the experiment you are not allowed to talk to other participants. You can ask your
| questions | after the instructions | and before | we start | the experiment. |     |
| --------- | ---------------------- | ---------- | -------- | --------------- | --- |
Your earnings depend on your own decisions and on the decisions of one other participant. The
identity of the other participant will not be revealed. The other participant remains the same
during the entire experiment and will be referred to as“the other”in what follows.
The experiment consists of 30 periods. In each period you have to choose a number between
0.0 and 28.0 (in increments of 0.1 points). The other also chooses a number between 0.0 and 28.0.
Your earnings in points depend on your choice and the other’s choice. The table you have received
gives information about your earnings for some combinations of your choice and the other’s choice.
| The other | gets the same | table. |     |     |     |
| --------- | ------------- | ------ | --- | --- | --- |
At each period there will be two stages. In the first stage you are allowed to communicate with
the other. In the second stage you will make a decision. In the first stage, your screen will look
| like the | picture below. |     |     |     |     |
| -------- | -------------- | --- | --- | --- | --- |
In this first stage, you can calculate your and the other’s earnings in more detail (for choices
that are not multiples of 2 for instance) by using the EARNINGS CALCULATOR on the left of
your screen. On the right, you can communicate with the other through a chat box, during 1
minute. You can type your message in the bar at the bottom right and hit“Return”. Only you and
26

the other will be able to see the messages you send and you are allowed to post as many messages
as you like. The same is true for the other. The messages you send should not identify yourself
(e.g., name, age, gender, location, etc.) in any case and you may not use offensive language. If you
want to finish chat before 1 minute, you can click “Finish Chat” button at the top right. If the
other also clicks this button, communication will end and you will move to next stage.
| In the | second | stage, your | screen will | look | like the picture below. |
| ------ | ------ | ----------- | ----------- | ---- | ----------------------- |
Inthisstageyouwillnotcommunicatebutyouwillmakeyourdecision. Youwillseethemessage
history at the top left of the screen. At the bottom left, you can use the Earnings Calculator, same
as before. At the top right you are asked to type in your choice and click“Enter”. In each period
you have about 1 minute to enter your decision. A history of your and the other’s past choices and
| earnings | is available | at the | bottom right | of your | screen. |
| -------- | ------------ | ------ | ------------ | ------- | ------- |
At the end of each period you are informed about the other’s choice and your and the other’s
| earnings | in that | period as | in the picture | below. |     |
| -------- | ------- | --------- | -------------- | ------ | --- |
27

Your total earnings in points are the sum of your earnings in points over the 30 periods. Your
earnings in points will be converted into EUR according to the rate: 100 points = 1 EUR.
Now we move to the trial period. The result of the trial period will not be counted into your
| earnings. Please | follow | our instructions | in the trial | period. |
| ---------------- | ------ | ---------------- | ------------ | ------- |
28

B Payoff Tables
(cid:13)(cid:19)(cid:22)(cid:20)(cid:26)(cid:1)(cid:17)(cid:18)(cid:1)(cid:21)(cid:27)(cid:15)(cid:25)(cid:24)(cid:23)(cid:18)(cid:1)è
(cid:3)(cid:2)(cid:3) (cid:5)(cid:2)(cid:3) (cid:7)(cid:2)(cid:3) (cid:9)(cid:2)(cid:3) (cid:11)(cid:2)(cid:3) (cid:4)(cid:3)(cid:2)(cid:3) (cid:4)(cid:5)(cid:2)(cid:3) (cid:4)(cid:7)(cid:2)(cid:3) (cid:4)(cid:9)(cid:2)(cid:3) (cid:4)(cid:11)(cid:2)(cid:3) (cid:5)(cid:3)(cid:2)(cid:3) (cid:5)(cid:5)(cid:2)(cid:3) (cid:5)(cid:7)(cid:2)(cid:3) (cid:5)(cid:9)(cid:2)(cid:3) (cid:5)(cid:11)(cid:2)(cid:3)
(cid:3)(cid:2)(cid:3)(cid:28)(cid:5)(cid:11)(cid:2)(cid:3)(cid:3)(cid:28)(cid:5)(cid:10)(cid:2)(cid:12)(cid:9)(cid:28)(cid:5)(cid:10)(cid:2)(cid:11)(cid:10)(cid:28)(cid:5)(cid:10)(cid:2)(cid:10)(cid:7)(cid:28)(cid:5)(cid:10)(cid:2)(cid:8)(cid:10)(cid:28)(cid:5)(cid:10)(cid:2)(cid:6)(cid:8)(cid:28)(cid:5)(cid:10)(cid:2)(cid:3)(cid:12)(cid:28)(cid:5)(cid:9)(cid:2)(cid:10)(cid:11)(cid:28)(cid:5)(cid:9)(cid:2)(cid:7)(cid:6)(cid:28)(cid:5)(cid:9)(cid:2)(cid:3)(cid:7)(cid:28)(cid:5)(cid:8)(cid:2)(cid:9)(cid:3)(cid:28)(cid:5)(cid:8)(cid:2)(cid:4)(cid:5)(cid:28)(cid:5)(cid:7)(cid:2)(cid:8)(cid:12)(cid:28)(cid:5)(cid:7)(cid:2)(cid:3)(cid:5)(cid:28)(cid:5)(cid:6)(cid:2)(cid:7)(cid:4)
(cid:5)(cid:2)(cid:3)(cid:28)(cid:4)(cid:11)(cid:2)(cid:4)(cid:9)(cid:28)(cid:4)(cid:10)(cid:2)(cid:7)(cid:9)(cid:28)(cid:4)(cid:9)(cid:2)(cid:10)(cid:5)(cid:28)(cid:4)(cid:8)(cid:2)(cid:12)(cid:6)(cid:28)(cid:4)(cid:8)(cid:2)(cid:3)(cid:12)(cid:28)(cid:4)(cid:7)(cid:2)(cid:5)(cid:4)(cid:28)(cid:4)(cid:6)(cid:2)(cid:5)(cid:12)(cid:28)(cid:4)(cid:5)(cid:2)(cid:6)(cid:6)(cid:28)(cid:4)(cid:4)(cid:2)(cid:6)(cid:5)(cid:28)(cid:4)(cid:3)(cid:2)(cid:5)(cid:9) (cid:28)(cid:12)(cid:2)(cid:4)(cid:9) (cid:28)(cid:11)(cid:2)(cid:3)(cid:5) (cid:28)(cid:9)(cid:2)(cid:11)(cid:7) (cid:28)(cid:8)(cid:2)(cid:9)(cid:4) (cid:28)(cid:7)(cid:2)(cid:6)(cid:6)
(cid:7)(cid:2)(cid:3)(cid:28)(cid:4)(cid:3)(cid:2)(cid:8)(cid:8) (cid:28)(cid:12)(cid:2)(cid:4)(cid:12) (cid:28)(cid:10)(cid:2)(cid:10)(cid:11) (cid:28)(cid:9)(cid:2)(cid:6)(cid:6) (cid:28)(cid:7)(cid:2)(cid:11)(cid:7) (cid:28)(cid:6)(cid:2)(cid:6)(cid:3) (cid:28)(cid:4)(cid:2)(cid:10)(cid:5) (cid:28)(cid:3)(cid:2)(cid:3)(cid:12) (cid:4)(cid:2)(cid:8)(cid:11) (cid:6)(cid:2)(cid:5)(cid:12) (cid:8)(cid:2)(cid:3)(cid:8) (cid:9)(cid:2)(cid:11)(cid:8) (cid:11)(cid:2)(cid:10)(cid:3) (cid:4)(cid:3)(cid:2)(cid:8)(cid:12) (cid:4)(cid:5)(cid:2)(cid:8)(cid:5)
(cid:9)(cid:2)(cid:3) (cid:28)(cid:8)(cid:2)(cid:4)(cid:9) (cid:28)(cid:6)(cid:2)(cid:4)(cid:7) (cid:28)(cid:4)(cid:2)(cid:3)(cid:11) (cid:4)(cid:2)(cid:3)(cid:6) (cid:6)(cid:2)(cid:4)(cid:12) (cid:8)(cid:2)(cid:6)(cid:12) (cid:10)(cid:2)(cid:9)(cid:6) (cid:12)(cid:2)(cid:12)(cid:4) (cid:4)(cid:5)(cid:2)(cid:5)(cid:7) (cid:4)(cid:7)(cid:2)(cid:9)(cid:5) (cid:4)(cid:10)(cid:2)(cid:3)(cid:7) (cid:4)(cid:12)(cid:2)(cid:8)(cid:3) (cid:5)(cid:5)(cid:2)(cid:3)(cid:3) (cid:5)(cid:7)(cid:2)(cid:8)(cid:8) (cid:5)(cid:10)(cid:2)(cid:4)(cid:8)
(cid:11)(cid:2)(cid:3) (cid:28)(cid:5)(cid:2)(cid:3)(cid:3) (cid:3)(cid:2)(cid:9)(cid:11) (cid:6)(cid:2)(cid:7)(cid:4) (cid:9)(cid:2)(cid:4)(cid:11) (cid:11)(cid:2)(cid:12)(cid:12) (cid:4)(cid:4)(cid:2)(cid:11)(cid:8) (cid:4)(cid:7)(cid:2)(cid:10)(cid:8) (cid:4)(cid:10)(cid:2)(cid:10)(cid:3) (cid:5)(cid:3)(cid:2)(cid:9)(cid:12) (cid:5)(cid:6)(cid:2)(cid:10)(cid:5) (cid:5)(cid:9)(cid:2)(cid:11)(cid:3) (cid:5)(cid:12)(cid:2)(cid:12)(cid:5) (cid:6)(cid:6)(cid:2)(cid:3)(cid:12) (cid:6)(cid:9)(cid:2)(cid:6)(cid:3) (cid:6)(cid:12)(cid:2)(cid:8)(cid:8)
(cid:4)(cid:3)(cid:2)(cid:3) (cid:28)(cid:4)(cid:2)(cid:3)(cid:9) (cid:5)(cid:2)(cid:5)(cid:11) (cid:8)(cid:2)(cid:9)(cid:10) (cid:12)(cid:2)(cid:4)(cid:3) (cid:4)(cid:5)(cid:2)(cid:8)(cid:10) (cid:4)(cid:9)(cid:2)(cid:3)(cid:12) (cid:4)(cid:12)(cid:2)(cid:9)(cid:8) (cid:5)(cid:6)(cid:2)(cid:5)(cid:9) (cid:5)(cid:9)(cid:2)(cid:12)(cid:4) (cid:6)(cid:3)(cid:2)(cid:9)(cid:3) (cid:6)(cid:7)(cid:2)(cid:6)(cid:7) (cid:6)(cid:11)(cid:2)(cid:4)(cid:5) (cid:7)(cid:4)(cid:2)(cid:12)(cid:8) (cid:7)(cid:8)(cid:2)(cid:11)(cid:5) (cid:7)(cid:12)(cid:2)(cid:10)(cid:6)
(cid:14)(cid:22)(cid:24)(cid:23)(cid:18) (cid:4)(cid:5)(cid:2)(cid:3) (cid:28)(cid:5)(cid:2)(cid:6)(cid:7) (cid:4)(cid:2)(cid:9)(cid:9) (cid:8)(cid:2)(cid:10)(cid:3) (cid:12)(cid:2)(cid:10)(cid:12) (cid:4)(cid:6)(cid:2)(cid:12)(cid:6) (cid:4)(cid:11)(cid:2)(cid:4)(cid:4) (cid:5)(cid:5)(cid:2)(cid:6)(cid:6) (cid:5)(cid:9)(cid:2)(cid:8)(cid:12) (cid:6)(cid:3)(cid:2)(cid:12)(cid:3) (cid:6)(cid:8)(cid:2)(cid:5)(cid:9) (cid:6)(cid:12)(cid:2)(cid:9)(cid:9) (cid:7)(cid:7)(cid:2)(cid:4)(cid:3) (cid:7)(cid:11)(cid:2)(cid:8)(cid:11) (cid:8)(cid:6)(cid:2)(cid:4)(cid:4) (cid:8)(cid:10)(cid:2)(cid:9)(cid:12)
(cid:16)(cid:19)(cid:22)(cid:20)(cid:26) (cid:4)(cid:7)(cid:2)(cid:3) (cid:28)(cid:8)(cid:2)(cid:11)(cid:8) (cid:28)(cid:4)(cid:2)(cid:4)(cid:12) (cid:6)(cid:2)(cid:8)(cid:5) (cid:11)(cid:2)(cid:5)(cid:10) (cid:4)(cid:6)(cid:2)(cid:3)(cid:9) (cid:4)(cid:10)(cid:2)(cid:12)(cid:3) (cid:5)(cid:5)(cid:2)(cid:10)(cid:11) (cid:5)(cid:10)(cid:2)(cid:10)(cid:4) (cid:6)(cid:5)(cid:2)(cid:9)(cid:11) (cid:6)(cid:10)(cid:2)(cid:9)(cid:12) (cid:7)(cid:5)(cid:2)(cid:10)(cid:8) (cid:7)(cid:10)(cid:2)(cid:11)(cid:8) (cid:8)(cid:6)(cid:2)(cid:3)(cid:3) (cid:8)(cid:11)(cid:2)(cid:4)(cid:12) (cid:9)(cid:6)(cid:2)(cid:7)(cid:5)
ê (cid:4)(cid:9)(cid:2)(cid:3)(cid:28)(cid:4)(cid:4)(cid:2)(cid:8)(cid:11) (cid:28)(cid:9)(cid:2)(cid:5)(cid:9) (cid:28)(cid:3)(cid:2)(cid:12)(cid:3) (cid:7)(cid:2)(cid:8)(cid:4) (cid:12)(cid:2)(cid:12)(cid:10) (cid:4)(cid:8)(cid:2)(cid:7)(cid:10) (cid:5)(cid:4)(cid:2)(cid:3)(cid:4) (cid:5)(cid:9)(cid:2)(cid:8)(cid:12) (cid:6)(cid:5)(cid:2)(cid:5)(cid:5) (cid:6)(cid:10)(cid:2)(cid:12)(cid:3) (cid:7)(cid:6)(cid:2)(cid:9)(cid:5) (cid:7)(cid:12)(cid:2)(cid:6)(cid:11) (cid:8)(cid:8)(cid:2)(cid:4)(cid:11) (cid:9)(cid:4)(cid:2)(cid:3)(cid:6) (cid:9)(cid:9)(cid:2)(cid:12)(cid:6)
(cid:4)(cid:11)(cid:2)(cid:3)(cid:28)(cid:4)(cid:12)(cid:2)(cid:8)(cid:7)(cid:28)(cid:4)(cid:6)(cid:2)(cid:8)(cid:9) (cid:28)(cid:10)(cid:2)(cid:8)(cid:6) (cid:28)(cid:4)(cid:2)(cid:7)(cid:9) (cid:7)(cid:2)(cid:9)(cid:8) (cid:4)(cid:3)(cid:2)(cid:11)(cid:4) (cid:4)(cid:10)(cid:2)(cid:3)(cid:4) (cid:5)(cid:6)(cid:2)(cid:5)(cid:9) (cid:5)(cid:12)(cid:2)(cid:8)(cid:8) (cid:6)(cid:8)(cid:2)(cid:11)(cid:11) (cid:7)(cid:5)(cid:2)(cid:5)(cid:9) (cid:7)(cid:11)(cid:2)(cid:9)(cid:11) (cid:8)(cid:8)(cid:2)(cid:4)(cid:8) (cid:9)(cid:4)(cid:2)(cid:9)(cid:9) (cid:9)(cid:11)(cid:2)(cid:5)(cid:4)
(cid:5)(cid:3)(cid:2)(cid:3)(cid:28)(cid:5)(cid:12)(cid:2)(cid:10)(cid:5)(cid:28)(cid:5)(cid:6)(cid:2)(cid:3)(cid:11)(cid:28)(cid:4)(cid:9)(cid:2)(cid:6)(cid:12) (cid:28)(cid:12)(cid:2)(cid:9)(cid:9) (cid:28)(cid:5)(cid:2)(cid:11)(cid:12) (cid:6)(cid:2)(cid:12)(cid:6) (cid:4)(cid:3)(cid:2)(cid:10)(cid:12) (cid:4)(cid:10)(cid:2)(cid:10)(cid:3) (cid:5)(cid:7)(cid:2)(cid:9)(cid:8) (cid:6)(cid:4)(cid:2)(cid:9)(cid:7) (cid:6)(cid:11)(cid:2)(cid:9)(cid:11) (cid:7)(cid:8)(cid:2)(cid:10)(cid:9) (cid:8)(cid:5)(cid:2)(cid:11)(cid:12) (cid:9)(cid:3)(cid:2)(cid:3)(cid:9) (cid:9)(cid:10)(cid:2)(cid:5)(cid:10)
(cid:5)(cid:5)(cid:2)(cid:3)(cid:28)(cid:7)(cid:5)(cid:2)(cid:4)(cid:5)(cid:28)(cid:6)(cid:7)(cid:2)(cid:11)(cid:5)(cid:28)(cid:5)(cid:10)(cid:2)(cid:7)(cid:11)(cid:28)(cid:5)(cid:3)(cid:2)(cid:3)(cid:12)(cid:28)(cid:4)(cid:5)(cid:2)(cid:9)(cid:8) (cid:28)(cid:8)(cid:2)(cid:4)(cid:10) (cid:5)(cid:2)(cid:6)(cid:8) (cid:12)(cid:2)(cid:12)(cid:4) (cid:4)(cid:10)(cid:2)(cid:8)(cid:5) (cid:5)(cid:8)(cid:2)(cid:4)(cid:11) (cid:6)(cid:5)(cid:2)(cid:11)(cid:11) (cid:7)(cid:3)(cid:2)(cid:9)(cid:5) (cid:7)(cid:11)(cid:2)(cid:7)(cid:3) (cid:8)(cid:9)(cid:2)(cid:5)(cid:6) (cid:9)(cid:7)(cid:2)(cid:4)(cid:4)
(cid:5)(cid:7)(cid:2)(cid:3)(cid:28)(cid:8)(cid:9)(cid:2)(cid:10)(cid:8)(cid:28)(cid:7)(cid:11)(cid:2)(cid:10)(cid:12)(cid:28)(cid:7)(cid:3)(cid:2)(cid:10)(cid:11)(cid:28)(cid:6)(cid:5)(cid:2)(cid:10)(cid:6)(cid:28)(cid:5)(cid:7)(cid:2)(cid:9)(cid:7)(cid:28)(cid:4)(cid:9)(cid:2)(cid:8)(cid:3) (cid:28)(cid:11)(cid:2)(cid:6)(cid:5) (cid:28)(cid:3)(cid:2)(cid:3)(cid:12) (cid:11)(cid:2)(cid:4)(cid:11) (cid:4)(cid:9)(cid:2)(cid:7)(cid:12) (cid:5)(cid:7)(cid:2)(cid:11)(cid:8) (cid:6)(cid:6)(cid:2)(cid:5)(cid:8) (cid:7)(cid:4)(cid:2)(cid:10)(cid:3) (cid:8)(cid:3)(cid:2)(cid:4)(cid:12) (cid:8)(cid:11)(cid:2)(cid:10)(cid:5)
(cid:5)(cid:9)(cid:2)(cid:3)(cid:28)(cid:10)(cid:6)(cid:2)(cid:9)(cid:3)(cid:28)(cid:9)(cid:7)(cid:2)(cid:12)(cid:11)(cid:28)(cid:8)(cid:9)(cid:2)(cid:6)(cid:5)(cid:28)(cid:7)(cid:10)(cid:2)(cid:9)(cid:4)(cid:28)(cid:6)(cid:11)(cid:2)(cid:11)(cid:8)(cid:28)(cid:6)(cid:3)(cid:2)(cid:3)(cid:8)(cid:28)(cid:5)(cid:4)(cid:2)(cid:5)(cid:4)(cid:28)(cid:4)(cid:5)(cid:2)(cid:6)(cid:6) (cid:28)(cid:6)(cid:2)(cid:7)(cid:3) (cid:8)(cid:2)(cid:8)(cid:11) (cid:4)(cid:7)(cid:2)(cid:9)(cid:3) (cid:5)(cid:6)(cid:2)(cid:9)(cid:9) (cid:6)(cid:5)(cid:2)(cid:10)(cid:9) (cid:7)(cid:4)(cid:2)(cid:12)(cid:4) (cid:8)(cid:4)(cid:2)(cid:4)(cid:4)
(cid:5)(cid:11)(cid:2)(cid:3)(cid:28)(cid:12)(cid:5)(cid:2)(cid:9)(cid:11)(cid:28)(cid:11)(cid:6)(cid:2)(cid:7)(cid:3)(cid:28)(cid:10)(cid:7)(cid:2)(cid:3)(cid:10)(cid:28)(cid:9)(cid:7)(cid:2)(cid:10)(cid:3)(cid:28)(cid:8)(cid:8)(cid:2)(cid:5)(cid:12)(cid:28)(cid:7)(cid:8)(cid:2)(cid:11)(cid:6)(cid:28)(cid:6)(cid:9)(cid:2)(cid:6)(cid:6)(cid:28)(cid:5)(cid:9)(cid:2)(cid:10)(cid:11)(cid:28)(cid:4)(cid:10)(cid:2)(cid:4)(cid:12) (cid:28)(cid:10)(cid:2)(cid:8)(cid:9) (cid:5)(cid:2)(cid:4)(cid:5) (cid:4)(cid:4)(cid:2)(cid:11)(cid:7) (cid:5)(cid:4)(cid:2)(cid:9)(cid:4) (cid:6)(cid:4)(cid:2)(cid:7)(cid:5) (cid:7)(cid:4)(cid:2)(cid:5)(cid:10)
Figure 11. Payoff table for the complementarity treatments. Horizontal axis shows the part-
ner’s choices.
(cid:13)(cid:19)(cid:22)(cid:20)(cid:26)(cid:1)(cid:17)(cid:18)(cid:1)(cid:21)(cid:27)(cid:15)(cid:25)(cid:24)(cid:23)(cid:18)(cid:1)è
(cid:3)(cid:2)(cid:3) (cid:5)(cid:2)(cid:3) (cid:7)(cid:2)(cid:3) (cid:9)(cid:2)(cid:3) (cid:11)(cid:2)(cid:3) (cid:4)(cid:3)(cid:2)(cid:3) (cid:4)(cid:5)(cid:2)(cid:3) (cid:4)(cid:7)(cid:2)(cid:3) (cid:4)(cid:9)(cid:2)(cid:3) (cid:4)(cid:11)(cid:2)(cid:3) (cid:5)(cid:3)(cid:2)(cid:3) (cid:5)(cid:5)(cid:2)(cid:3) (cid:5)(cid:7)(cid:2)(cid:3) (cid:5)(cid:9)(cid:2)(cid:3) (cid:5)(cid:11)(cid:2)(cid:3)
(cid:3)(cid:2)(cid:3)(cid:28)(cid:5)(cid:11)(cid:2)(cid:3)(cid:3)(cid:28)(cid:5)(cid:5)(cid:2)(cid:11)(cid:11)(cid:28)(cid:4)(cid:10)(cid:2)(cid:8)(cid:10)(cid:28)(cid:4)(cid:5)(cid:2)(cid:3)(cid:12)(cid:28)(cid:9)(cid:2)(cid:7)(cid:5)(cid:28)(cid:3)(cid:2)(cid:8)(cid:10) (cid:8)(cid:2)(cid:7)(cid:10) (cid:4)(cid:4)(cid:2)(cid:9)(cid:11) (cid:4)(cid:11)(cid:2)(cid:3)(cid:11) (cid:5)(cid:7)(cid:2)(cid:9)(cid:9) (cid:6)(cid:4)(cid:2)(cid:7)(cid:5) (cid:6)(cid:11)(cid:2)(cid:6)(cid:10) (cid:7)(cid:8)(cid:2)(cid:7)(cid:12) (cid:8)(cid:5)(cid:2)(cid:11)(cid:3) (cid:9)(cid:3)(cid:2)(cid:5)(cid:12)
(cid:5)(cid:2)(cid:3)(cid:28)(cid:5)(cid:5)(cid:2)(cid:6)(cid:12)(cid:28)(cid:4)(cid:10)(cid:2)(cid:7)(cid:9)(cid:28)(cid:4)(cid:5)(cid:2)(cid:6)(cid:8) (cid:28)(cid:10)(cid:2)(cid:3)(cid:9)(cid:28)(cid:4)(cid:2)(cid:8)(cid:11) (cid:7)(cid:2)(cid:3)(cid:10) (cid:12)(cid:2)(cid:12)(cid:4) (cid:4)(cid:8)(cid:2)(cid:12)(cid:6) (cid:5)(cid:5)(cid:2)(cid:4)(cid:7) (cid:5)(cid:11)(cid:2)(cid:8)(cid:5) (cid:6)(cid:8)(cid:2)(cid:3)(cid:12) (cid:7)(cid:4)(cid:2)(cid:11)(cid:7) (cid:7)(cid:11)(cid:2)(cid:10)(cid:10) (cid:8)(cid:8)(cid:2)(cid:11)(cid:12) (cid:9)(cid:6)(cid:2)(cid:4)(cid:12)
(cid:7)(cid:2)(cid:3)(cid:28)(cid:4)(cid:10)(cid:2)(cid:7)(cid:6)(cid:28)(cid:4)(cid:5)(cid:2)(cid:10)(cid:3) (cid:28)(cid:10)(cid:2)(cid:10)(cid:11) (cid:28)(cid:5)(cid:2)(cid:9)(cid:12) (cid:5)(cid:2)(cid:8)(cid:12) (cid:11)(cid:2)(cid:3)(cid:9) (cid:4)(cid:6)(cid:2)(cid:10)(cid:3) (cid:4)(cid:12)(cid:2)(cid:8)(cid:6) (cid:5)(cid:8)(cid:2)(cid:8)(cid:7) (cid:6)(cid:4)(cid:2)(cid:10)(cid:6) (cid:6)(cid:11)(cid:2)(cid:4)(cid:4) (cid:7)(cid:7)(cid:2)(cid:9)(cid:9) (cid:8)(cid:4)(cid:2)(cid:7)(cid:3) (cid:8)(cid:11)(cid:2)(cid:6)(cid:5) (cid:9)(cid:8)(cid:2)(cid:7)(cid:6)
(cid:9)(cid:2)(cid:3)(cid:28)(cid:4)(cid:6)(cid:2)(cid:4)(cid:6) (cid:28)(cid:11)(cid:2)(cid:8)(cid:12) (cid:28)(cid:6)(cid:2)(cid:11)(cid:10) (cid:4)(cid:2)(cid:3)(cid:6) (cid:9)(cid:2)(cid:4)(cid:5) (cid:4)(cid:4)(cid:2)(cid:6)(cid:12) (cid:4)(cid:9)(cid:2)(cid:11)(cid:7) (cid:5)(cid:5)(cid:2)(cid:7)(cid:10) (cid:5)(cid:11)(cid:2)(cid:5)(cid:12) (cid:6)(cid:7)(cid:2)(cid:5)(cid:12) (cid:7)(cid:3)(cid:2)(cid:7)(cid:10) (cid:7)(cid:9)(cid:2)(cid:11)(cid:6) (cid:8)(cid:6)(cid:2)(cid:6)(cid:10) (cid:9)(cid:3)(cid:2)(cid:4)(cid:3) (cid:9)(cid:10)(cid:2)(cid:3)(cid:4)
(cid:11)(cid:2)(cid:3) (cid:28)(cid:12)(cid:2)(cid:7)(cid:11) (cid:28)(cid:8)(cid:2)(cid:4)(cid:7) (cid:28)(cid:3)(cid:2)(cid:9)(cid:4) (cid:7)(cid:2)(cid:4)(cid:3) (cid:11)(cid:2)(cid:12)(cid:12) (cid:4)(cid:7)(cid:2)(cid:3)(cid:10) (cid:4)(cid:12)(cid:2)(cid:6)(cid:5) (cid:5)(cid:7)(cid:2)(cid:10)(cid:9) (cid:6)(cid:3)(cid:2)(cid:6)(cid:11) (cid:6)(cid:9)(cid:2)(cid:4)(cid:12) (cid:7)(cid:5)(cid:2)(cid:4)(cid:10) (cid:7)(cid:11)(cid:2)(cid:6)(cid:7) (cid:8)(cid:7)(cid:2)(cid:9)(cid:12) (cid:9)(cid:4)(cid:2)(cid:5)(cid:6) (cid:9)(cid:10)(cid:2)(cid:12)(cid:7)
(cid:4)(cid:3)(cid:2)(cid:3) (cid:28)(cid:9)(cid:2)(cid:7)(cid:12) (cid:28)(cid:5)(cid:2)(cid:6)(cid:7) (cid:5)(cid:2)(cid:3)(cid:3) (cid:9)(cid:2)(cid:8)(cid:4) (cid:4)(cid:4)(cid:2)(cid:5)(cid:4) (cid:4)(cid:9)(cid:2)(cid:3)(cid:12) (cid:5)(cid:4)(cid:2)(cid:4)(cid:8) (cid:5)(cid:9)(cid:2)(cid:7)(cid:3) (cid:6)(cid:4)(cid:2)(cid:11)(cid:6) (cid:6)(cid:10)(cid:2)(cid:7)(cid:6) (cid:7)(cid:6)(cid:2)(cid:5)(cid:6) (cid:7)(cid:12)(cid:2)(cid:5)(cid:3) (cid:8)(cid:8)(cid:2)(cid:6)(cid:9) (cid:9)(cid:4)(cid:2)(cid:10)(cid:3) (cid:9)(cid:11)(cid:2)(cid:5)(cid:5)
(cid:14)(cid:22)(cid:24)(cid:23)(cid:18) (cid:4)(cid:5)(cid:2)(cid:3) (cid:28)(cid:7)(cid:2)(cid:4)(cid:8) (cid:28)(cid:3)(cid:2)(cid:4)(cid:12) (cid:6)(cid:2)(cid:12)(cid:8) (cid:11)(cid:2)(cid:5)(cid:10) (cid:4)(cid:5)(cid:2)(cid:10)(cid:10) (cid:4)(cid:10)(cid:2)(cid:7)(cid:9) (cid:5)(cid:5)(cid:2)(cid:6)(cid:6) (cid:5)(cid:10)(cid:2)(cid:6)(cid:11) (cid:6)(cid:5)(cid:2)(cid:9)(cid:4) (cid:6)(cid:11)(cid:2)(cid:3)(cid:6) (cid:7)(cid:6)(cid:2)(cid:9)(cid:6) (cid:7)(cid:12)(cid:2)(cid:7)(cid:4) (cid:8)(cid:8)(cid:2)(cid:6)(cid:10) (cid:9)(cid:4)(cid:2)(cid:8)(cid:4) (cid:9)(cid:10)(cid:2)(cid:11)(cid:7)
(cid:16)(cid:19)(cid:22)(cid:20)(cid:26) (cid:4)(cid:7)(cid:2)(cid:3) (cid:28)(cid:5)(cid:2)(cid:7)(cid:9) (cid:4)(cid:2)(cid:6)(cid:3) (cid:8)(cid:2)(cid:5)(cid:7) (cid:12)(cid:2)(cid:6)(cid:10) (cid:4)(cid:6)(cid:2)(cid:9)(cid:11) (cid:4)(cid:11)(cid:2)(cid:4)(cid:10) (cid:5)(cid:5)(cid:2)(cid:11)(cid:8) (cid:5)(cid:10)(cid:2)(cid:10)(cid:4) (cid:6)(cid:5)(cid:2)(cid:10)(cid:8) (cid:6)(cid:10)(cid:2)(cid:12)(cid:10) (cid:7)(cid:6)(cid:2)(cid:6)(cid:10) (cid:7)(cid:11)(cid:2)(cid:12)(cid:9) (cid:8)(cid:7)(cid:2)(cid:10)(cid:5) (cid:9)(cid:3)(cid:2)(cid:9)(cid:10) (cid:9)(cid:9)(cid:2)(cid:11)(cid:4)
ê (cid:4)(cid:9)(cid:2)(cid:3) (cid:28)(cid:4)(cid:2)(cid:7)(cid:6) (cid:5)(cid:2)(cid:4)(cid:7) (cid:8)(cid:2)(cid:11)(cid:12) (cid:12)(cid:2)(cid:11)(cid:5) (cid:4)(cid:6)(cid:2)(cid:12)(cid:7) (cid:4)(cid:11)(cid:2)(cid:5)(cid:7) (cid:5)(cid:5)(cid:2)(cid:10)(cid:5) (cid:5)(cid:10)(cid:2)(cid:6)(cid:11) (cid:6)(cid:5)(cid:2)(cid:5)(cid:5) (cid:6)(cid:10)(cid:2)(cid:5)(cid:8) (cid:7)(cid:5)(cid:2)(cid:7)(cid:9) (cid:7)(cid:10)(cid:2)(cid:11)(cid:8) (cid:8)(cid:6)(cid:2)(cid:7)(cid:6) (cid:8)(cid:12)(cid:2)(cid:4)(cid:11) (cid:9)(cid:8)(cid:2)(cid:4)(cid:5)
(cid:4)(cid:11)(cid:2)(cid:3) (cid:28)(cid:4)(cid:2)(cid:3)(cid:9) (cid:5)(cid:2)(cid:6)(cid:5) (cid:8)(cid:2)(cid:11)(cid:11) (cid:12)(cid:2)(cid:9)(cid:5) (cid:4)(cid:6)(cid:2)(cid:8)(cid:7) (cid:4)(cid:10)(cid:2)(cid:9)(cid:7) (cid:5)(cid:4)(cid:2)(cid:12)(cid:6) (cid:5)(cid:9)(cid:2)(cid:7)(cid:3) (cid:6)(cid:4)(cid:2)(cid:3)(cid:8) (cid:6)(cid:8)(cid:2)(cid:11)(cid:11) (cid:7)(cid:3)(cid:2)(cid:12)(cid:3) (cid:7)(cid:9)(cid:2)(cid:4)(cid:3) (cid:8)(cid:4)(cid:2)(cid:7)(cid:11) (cid:8)(cid:10)(cid:2)(cid:3)(cid:7) (cid:9)(cid:5)(cid:2)(cid:10)(cid:11)
(cid:5)(cid:3)(cid:2)(cid:3) (cid:28)(cid:4)(cid:2)(cid:6)(cid:6) (cid:4)(cid:2)(cid:11)(cid:8) (cid:8)(cid:2)(cid:5)(cid:4) (cid:11)(cid:2)(cid:10)(cid:9) (cid:4)(cid:5)(cid:2)(cid:7)(cid:12) (cid:4)(cid:9)(cid:2)(cid:7)(cid:3) (cid:5)(cid:3)(cid:2)(cid:7)(cid:12) (cid:5)(cid:7)(cid:2)(cid:10)(cid:9) (cid:5)(cid:12)(cid:2)(cid:5)(cid:5) (cid:6)(cid:6)(cid:2)(cid:11)(cid:9) (cid:6)(cid:11)(cid:2)(cid:9)(cid:11) (cid:7)(cid:6)(cid:2)(cid:9)(cid:11) (cid:7)(cid:11)(cid:2)(cid:11)(cid:10) (cid:8)(cid:7)(cid:2)(cid:5)(cid:7) (cid:8)(cid:12)(cid:2)(cid:10)(cid:12)
(cid:5)(cid:5)(cid:2)(cid:3) (cid:28)(cid:5)(cid:2)(cid:5)(cid:9) (cid:3)(cid:2)(cid:10)(cid:5) (cid:6)(cid:2)(cid:11)(cid:12) (cid:10)(cid:2)(cid:5)(cid:8) (cid:4)(cid:3)(cid:2)(cid:10)(cid:11) (cid:4)(cid:7)(cid:2)(cid:7)(cid:12) (cid:4)(cid:11)(cid:2)(cid:6)(cid:12) (cid:5)(cid:5)(cid:2)(cid:7)(cid:10) (cid:5)(cid:9)(cid:2)(cid:10)(cid:7) (cid:6)(cid:4)(cid:2)(cid:4)(cid:11) (cid:6)(cid:8)(cid:2)(cid:11)(cid:4) (cid:7)(cid:3)(cid:2)(cid:9)(cid:5) (cid:7)(cid:8)(cid:2)(cid:9)(cid:4) (cid:8)(cid:3)(cid:2)(cid:10)(cid:11) (cid:8)(cid:9)(cid:2)(cid:4)(cid:7)
(cid:5)(cid:7)(cid:2)(cid:3) (cid:28)(cid:6)(cid:2)(cid:11)(cid:8) (cid:28)(cid:4)(cid:2)(cid:3)(cid:8) (cid:4)(cid:2)(cid:12)(cid:5) (cid:8)(cid:2)(cid:3)(cid:11) (cid:11)(cid:2)(cid:7)(cid:5) (cid:4)(cid:4)(cid:2)(cid:12)(cid:7) (cid:4)(cid:8)(cid:2)(cid:9)(cid:7) (cid:4)(cid:12)(cid:2)(cid:8)(cid:6) (cid:5)(cid:6)(cid:2)(cid:9)(cid:3) (cid:5)(cid:10)(cid:2)(cid:11)(cid:8) (cid:6)(cid:5)(cid:2)(cid:5)(cid:11) (cid:6)(cid:9)(cid:2)(cid:12)(cid:3) (cid:7)(cid:4)(cid:2)(cid:10)(cid:3) (cid:7)(cid:9)(cid:2)(cid:9)(cid:11) (cid:8)(cid:4)(cid:2)(cid:11)(cid:7)
(cid:5)(cid:9)(cid:2)(cid:3) (cid:28)(cid:9)(cid:2)(cid:3)(cid:12) (cid:28)(cid:6)(cid:2)(cid:7)(cid:12) (cid:28)(cid:3)(cid:2)(cid:10)(cid:4) (cid:5)(cid:2)(cid:5)(cid:9) (cid:8)(cid:2)(cid:7)(cid:3) (cid:11)(cid:2)(cid:10)(cid:6) (cid:4)(cid:5)(cid:2)(cid:5)(cid:7) (cid:4)(cid:8)(cid:2)(cid:12)(cid:6) (cid:4)(cid:12)(cid:2)(cid:11)(cid:4) (cid:5)(cid:6)(cid:2)(cid:11)(cid:9) (cid:5)(cid:11)(cid:2)(cid:4)(cid:3) (cid:6)(cid:5)(cid:2)(cid:8)(cid:5) (cid:6)(cid:10)(cid:2)(cid:4)(cid:6) (cid:7)(cid:4)(cid:2)(cid:12)(cid:4) (cid:7)(cid:9)(cid:2)(cid:11)(cid:11)
(cid:5)(cid:11)(cid:2)(cid:3) (cid:28)(cid:11)(cid:2)(cid:12)(cid:11) (cid:28)(cid:9)(cid:2)(cid:8)(cid:10) (cid:28)(cid:6)(cid:2)(cid:12)(cid:12) (cid:28)(cid:4)(cid:2)(cid:5)(cid:5) (cid:4)(cid:2)(cid:10)(cid:6) (cid:7)(cid:2)(cid:11)(cid:10) (cid:11)(cid:2)(cid:4)(cid:11) (cid:4)(cid:4)(cid:2)(cid:9)(cid:11) (cid:4)(cid:8)(cid:2)(cid:6)(cid:9) (cid:4)(cid:12)(cid:2)(cid:5)(cid:5) (cid:5)(cid:6)(cid:2)(cid:5)(cid:10) (cid:5)(cid:10)(cid:2)(cid:8)(cid:3) (cid:6)(cid:4)(cid:2)(cid:12)(cid:4) (cid:6)(cid:9)(cid:2)(cid:8)(cid:3) (cid:7)(cid:4)(cid:2)(cid:5)(cid:10)
Figure 12. Payoff table for the substitution treatments. Horizontal axis shows the partner’s
choices.
29

|            | C Payoff  | evolution |     | and extra | sessions |     |
| ---------- | --------- | --------- | --- | --------- | -------- | --- |
| C.1 Payoff | evolution |           |     |           |          |     |
40
30
ffoyaP
20
10
|     | 0   |     | 10  | 20  |     | 30  |
| --- | --- | --- | --- | --- | --- | --- |
Period
|     |     | Subs. without comm. | Subs. with comm. | Comp. without comm. | Comp. with comm. |     |
| --- | --- | ------------------- | ---------------- | ------------------- | ---------------- | --- |
Figure 13. Average payoffs per period for complementarity and substitution treatments with
| and without       | chat. |          |       |     |     |     |
| ----------------- | ----- | -------- | ----- | --- | --- | --- |
| C.2 Communication |       | or extra | time? |     |     |     |
25
20
seciohC
15
10
|     | 0   |     | 10  | 20  |     | 30  |
| --- | --- | --- | --- | --- | --- | --- |
Period
|     |     |     | No Communication | Extra Time Communication |     |     |
| --- | --- | --- | ---------------- | ------------------------ | --- | --- |
Figure 14. Average choices within each substitution treatment, including extra sessions with
| extra time | without | communication. |     |     |     |     |
| ---------- | ------- | -------------- | --- | --- | --- | --- |
Here, we provide comparisons with the extra sessions we have run to check if the observed
effect of communication is due to the extra time in the communication treatments. Figure 14
shows the average choices for each of the substitution treatments, including extra sessions where
30

|          | No Communication | Extra Time   | Communication |
| -------- | ---------------- | ------------ | ------------- |
| Choices  | 13.13 (7.31)     | 14.13 (7.47) | 22.34 (7.28)  |
| Subjects | 64               | 48           | 74            |
Table 8. Averagechoiceswithineachsubstitutiontreatment,includingextrasessionswithex-
tratimewithoutcommunication. TheWMWtestforanypairyieldap−valueofapproximately
zero. Tests are run over all periods, thus, cover number of subjects × 30 observations.
subjects were given the same amount of time as in the communication treatments but were not
able to communicate. As can be seen in the figure, choices are very close to the case without extra
time and much lower than the treatment with communication. Table 8 shows the average choices
| (standard deviations) for each | treatment. |     |     |
| ------------------------------ | ---------- | --- | --- |
31

D Choices in treatments without communication
JPM=0, Early=0, ID=1194 JPM=0, Early=0, ID=1196 JPM=0, Early=0, ID=1197 JPM=0, Early=0, ID=1198 JPM=0, Early=0, ID=1199
28.0
25.5
18.0
14.0
0.0
JPM=0, Early=0, ID=1793 JPM=0, Early=0, ID=1794 JPM=0, Early=0, ID=1795 JPM=0, Early=0, ID=1796 JPM=0, Early=0, ID=1797
28.0
25.5
18.0
14.0
0.0
JPM=0, Early=0, ID=1798 JPM=0, Early=0, ID=1799 JPM=0, Early=0, ID=191 JPM=0, Early=0, ID=192 JPM=0, Early=0, ID=193
28.0
25.5
18.0
14.0
0.0
JPM=0, Early=0, ID=194 JPM=0, Early=0, ID=195 JPM=0, Early=0, ID=196 JPM=0, Early=0, ID=197 JPM=0, Early=0, ID=198
28.0
25.5
18.0
14.0
0.0
JPM=0, Early=0, ID=199 JPM=0, Early=0, ID=694 JPM=0, Early=0, ID=695 JPM=0, Early=0, ID=697 JPM=0, Early=0, ID=699
28.0
25.5
18.0
14.0
0.0
1 5 10 15 20 25 30 1 5 10 15 20 25 30
JPM=1, Early=0, ID=693 JPM=1, Early=1, ID=1195 JPM=1, Early=1, ID=696
28.0
25.5
18.0
14.0
0.0
1 5 10 15 20 25 30 1 5 10 15 20 25 30 1 5 10 15 20 25 30
Period
seciohC
Figure 15. The evolution of choices in pairs under complementarity without communication.
PairIDsareprintedontopofeachplotnexttoifthepairisaJPMpair(1, ifnot0), andifthe
pairisanearlyJPMpair(1,ifnot0). ThedefinitionsofearlyandeventualJPMpairsaregiven
in Section 4.3.1. The plots are confined to the strategy space, i.e., the interval [0,28]. Nash
equilibrium is 14 and JPM is 25.5 for both strategic environments and the optimal defection
choice is 18 for complementarity.
32

JPM=0, Early=0, ID=1093 JPM=0, Early=0, ID=1094 JPM=0, Early=0, ID=1095 JPM=0, Early=0, ID=1097 JPM=0, Early=0, ID=1098
28.0
25.5
14.0
10.0
0.0
JPM=0, Early=0, ID=1099 JPM=0, Early=0, ID=1595 JPM=0, Early=0, ID=1596 JPM=0, Early=0, ID=1597 JPM=0, Early=0, ID=1598
28.0
25.5
14.0
10.0
0.0
JPM=0, Early=0, ID=1599 JPM=0, Early=0, ID=2195 JPM=0, Early=0, ID=2196 JPM=0, Early=0, ID=2197 JPM=0, Early=0, ID=2198
28.0
25.5
14.0
10.0
0.0
JPM=0, Early=0, ID=2199 JPM=0, Early=0, ID=2296 JPM=0, Early=0, ID=2298 JPM=0, Early=0, ID=2299 JPM=0, Early=0, ID=492
28.0
25.5
14.0
10.0
0.0
JPM=0, Early=0, ID=494 JPM=0, Early=0, ID=495 JPM=0, Early=0, ID=497 JPM=0, Early=0, ID=498 JPM=0, Early=0, ID=499
28.0
25.5
14.0
10.0
0.0
JPM=0, Early=0, ID=793 JPM=0, Early=0, ID=794 JPM=0, Early=0, ID=795 JPM=0, Early=0, ID=796 JPM=0, Early=0, ID=797
28.0
25.5
14.0
10.0
0.0
1 5 10 15 20 25 30 1 5 10 15 20 25 30 1 5 10 15 20 25 30
JPM=0, Early=0, ID=798 JPM=0, Early=0, ID=799
28.0
25.5
14.0
10.0
0.0
1 5 10 15 20 25 30 1 5 10 15 20 25 30
Period
seciohC
Figure 16. The evolution of choices in pairs under substitution without communication. Pair
IDsareprintedontopofeachplotnexttoifthepairisaJPMpair(1, ifnot0), andifthepair
is an early JPM pair (1, if not 0). The definitions of early and eventual JPM pairs are given
in Section 4.3.1. The plots are confined to the strategy space, i.e., the interval [0,28]. Nash
equilibrium is 14 and JPM is 25.5 for both strategic environments and the optimal defection
choice is 10 for substitution.
33

E Choices in treatments with communication
JPM=0, Early=0, ID=1393 JPM=0, Early=0, ID=1397 JPM=0, Early=0, ID=1498 JPM=0, Early=0, ID=396 JPM=0, Early=0, ID=94
2258..50
18.0
14.0
0.0
JPM=0, Early=0, ID=95 JPM=0, Early=0, ID=96 JPM=0, Early=0, ID=97 JPM=0, Early=0, ID=996 JPM=0, Early=0, ID=997
2258..50
18.0
14.0
0.0
JPM=1, Early=0, ID=1296 JPM=1, Early=0, ID=1394 JPM=1, Early=0, ID=1396 JPM=1, Early=0, ID=1398 JPM=1, Early=0, ID=1399
2258..50
18.0
14.0
0.0
JPM=1, Early=0, ID=1492 JPM=1, Early=0, ID=1495 JPM=1, Early=0, ID=1496 JPM=1, Early=0, ID=1694 JPM=1, Early=0, ID=1696
2258..50
18.0
14.0
0.0
JPM=1, Early=0, ID=1698 JPM=1, Early=0, ID=1699 JPM=1, Early=0, ID=1997 JPM=1, Early=0, ID=1998 JPM=1, Early=0, ID=1999
2258..50
18.0
14.0
0.0
JPM=1, Early=0, ID=397 JPM=1, Early=0, ID=399 JPM=1, Early=0, ID=99 JPM=1, Early=0, ID=995 JPM=1, Early=1, ID=1297
2258..50
18.0
14.0
0.0
JPM=1, Early=1, ID=1298 JPM=1, Early=1, ID=1299 JPM=1, Early=1, ID=1392 JPM=1, Early=1, ID=1395 JPM=1, Early=1, ID=1493
2258..50
18.0
14.0
0.0
JPM=1, Early=1, ID=1494 JPM=1, Early=1, ID=1497 JPM=1, Early=1, ID=1499 JPM=1, Early=1, ID=1691 JPM=1, Early=1, ID=1692
2258..50
18.0
14.0
0.0
JPM=1, Early=1, ID=1693 JPM=1, Early=1, ID=1695 JPM=1, Early=1, ID=1697 JPM=1, Early=1, ID=1994 JPM=1, Early=1, ID=1995
2258..50
18.0
14.0
0.0
JPM=1, Early=1, ID=1996 JPM=1, Early=1, ID=398 JPM=1, Early=1, ID=98 JPM=1, Early=1, ID=998 JPM=1, Early=1, ID=999
2258..50
18.0
14.0
0.0
1 5 10 15 20 25 30 1 5 10 15 20 25 30 1 5 10 15 20 25 30 1 5 10 15 20 25 30 1 5 10 15 20 25 30
Period
seciohC
Figure 17. Theevolutionofchoicesinpairsundercomplementaritywithcommunication. Pair
IDsareprintedontopofeachplotnexttoifthepairisaJPMpair(1, ifnot0), andifthepair
is an early JPM pair (1, if not 0). The definitions of early and eventual JPM pairs are given
in Section 4.3.1. The plots are confined to the strategy space, i.e., the interval [0,28]. Nash
equilibrium is 14 and JPM is 25.5 for both strategic environments and the optimal defection
choice is 18 for complementarity.
34

JPM=0, Early=0, ID=1894 JPM=0, Early=0, ID=2091 JPM=0, Early=0, ID=2092 JPM=0, Early=0, ID=2097 JPM=0, Early=0, ID=2098
28.0
25.5
14.0
10.0
0.0
JPM=0, Early=0, ID=292 JPM=0, Early=0, ID=293 JPM=0, Early=0, ID=591 JPM=0, Early=0, ID=597 JPM=0, Early=0, ID=896
28.0
25.5
14.0
10.0
0.0
JPM=1, Early=0, ID=1895 JPM=1, Early=0, ID=1899 JPM=1, Early=0, ID=2089 JPM=1, Early=0, ID=2090 JPM=1, Early=0, ID=2094
28.0
25.5
14.0
10.0
0.0
JPM=1, Early=0, ID=2096 JPM=1, Early=0, ID=296 JPM=1, Early=0, ID=297 JPM=1, Early=0, ID=298 JPM=1, Early=0, ID=594
28.0
25.5
14.0
10.0
0.0
JPM=1, Early=0, ID=596 JPM=1, Early=1, ID=1896 JPM=1, Early=1, ID=1897 JPM=1, Early=1, ID=2093 JPM=1, Early=1, ID=2095
28.0
25.5
14.0
10.0
0.0
JPM=1, Early=1, ID=2099 JPM=1, Early=1, ID=291 JPM=1, Early=1, ID=294 JPM=1, Early=1, ID=295 JPM=1, Early=1, ID=299
28.0
25.5
14.0
10.0
0.0
JPM=1, Early=1, ID=592 JPM=1, Early=1, ID=593 JPM=1, Early=1, ID=595 JPM=1, Early=1, ID=598 JPM=1, Early=1, ID=599
28.0
25.5
14.0
10.0
0.0
1 5 10 15 20 25 30 1 5 10 15 20 25 30 1 5 10 15 20 25 30
JPM=1, Early=1, ID=898 JPM=1, Early=1, ID=899
28.0
25.5
14.0
10.0
0.0
1 5 10 15 20 25 30 1 5 10 15 20 25 30
Period
seciohC
Figure 18. Theevolutionofchoicesinpairsundercomplementaritywithcommunication. Pair
IDsareprintedontopofeachplotnexttoifthepairisaJPMpair(1, ifnot0), andifthepair
is an early JPM pair (1, if not 0). The definitions of early and eventual JPM pairs are given
in Section 4.3.1. The plots are confined to the strategy space, i.e., the interval [0,28]. Nash
equilibrium is 14 and JPM is 25.5 for both strategic environments and the optimal defection
choice is 10 for substitution.
35

|          | F Further   | content   | analysis | data        |           |
| -------- | ----------- | --------- | -------- | ----------- | --------- |
|          |             | Rank Rank |          |             | Rank Rank |
| Term     | Translation | Subs Comp | Term     | Translation | Subs Comp |
| met      | put         | 1 3       | sai      | know        | 28 53     |
| 26       | 26          | 2 1       | rien     | nothing     | 29 40     |
| 28       | 28          | 3 2       | 25.5     | 25.5        | 30 47     |
| plus     | more        | 4 4       | croi     | believe     | 31 52     |
| mdr      | lol         | 5 8       | 20       | 20          | 32 21     |
| gagn     | win         | 6 5       | veux     | want        | 33 32     |
| bon      | good        | 7 14      | gain     | earn        | 34 26     |
| deux     | two         | 8 9       | encor    | again       | 35 36     |
| 10 (18)  | 10 (18)     | 9 6       | trop     | too much    | 36 50     |
| foi      | time        | 10 13     | moin     | less        | 37 30     |
| comm     | like        | 11 12     | continu  | continue    | 38 38     |
| mieux    | better      | 12 10     | parc     | because     | 39 73     |
| mˆeme    | same        | 13 7      | l’autr   | the other   | 40 51     |
| 2        | 2           | 14 15     | grave    | serious     | 41 118    |
| pens     | think       | 15 25     | 12       | 12          | 42 48     |
| mainten  | now         | 16 43     | compri   | understood  | 43 49     |
| bien     | good        | 17 19     | dernier  | last        | 44 55     |
| tour     | turn        | 18 28     | invers   | inverse     | 45 37     |
| point    | point       | 19 31     | peu      | little      | 46 35     |
| 24       | 24          | 20 11     | chaqu    | each        | 47 33     |
| faut     | must        | 21 16     | fin      | end         | 48 34     |
| haha     | haha        | 22 22     | toujour  | always      | 49 46     |
| d’accord | agreed      | 23 20     | dis      | said        | 50 70     |
| aussi    | too         | 24 27     | 22       | 22          | 60 17     |
| pareil   | same        | 25 18     | 25       | 25          | 91 23     |
| mettr    | to put      | 26 24     | temp     | time        | 52 39     |
| rest     | rest        | 27 29     | meilleur | best        | 70 42     |
Table 9. Most frequent (stemmed) terms depicted in Figure 8 with English translations and
| ranks in both | treatments. |     |     |     |     |
| ------------- | ----------- | --- | --- | --- | --- |
36

300
ytiratnemelpmoC ni knaR
200
grave
100
veux
|     | plus | tour 25.5 | croi parc |     |     |     |     |     |     |     |     |
| --- | ---- | --------- | --------- | --- | --- | --- | --- | --- | --- | --- | --- |
trop toujour
|     | deux | 2 aussi   | sai l'autr |         |           |                 |     |     |     |     |     |
| --- | ---- | --------- | ---------- | ------- | --------- | --------------- | --- | --- | --- | --- | --- |
|     |      |           |            | mainten | encor fin |                 |     |     |     |     |     |
|     | mdr  | foi point | gain       |         | chaqu     | invers meilleur |     |     |     |     |     |
bon
|     |          | pens |                    | mettr       | rest peu   |     |     |     |     |     |     |
| --- | -------- | ---- | ------------------ | ----------- | ---------- | --- | --- | --- | --- | --- | --- |
|     | met      | comm | moin               |             |            |     | 25  |     |     |     | 22  |
|     |          |      | bi e n             | c o n t inu | 2 0        |     |     |     |     |     |     |
|     | 2 6      |      | fa u t             |             | d'accord   |     |     |     |     |     |     |
| 0   | 2 8 gagn | même | m i e ux 1 0  (18) | h a h a     | pareil 2 4 |     |     |     |     |     |     |
|     | 0        |      |                    |             | 50         |     |     | 100 |     | 150 |     |
Rank in Substitution
Figure 19. The ranks of 40 most frequently used words by JPM pairs in both treatments.
200
150
ytiratnemelpmoC ni knaR
encor
100
mainten
rest
choisi
dis haha
| 50  |          |      | comm          | combien | dernier  |      |       |      |        |      |     |
| --- | -------- | ---- | ------------- | ------- | -------- | ---- | ----- | ---- | ------ | ---- | --- |
|     |          |      | ri e n        |         | mieux    |      |       |      |        |      |     |
|     |          | bon  |               | propos  |          | bien |       | temp |        |      |     |
|     | d'accord |      | foi p a r eil |         | 6        |      |       |      |        |      | 14  |
|     |          |      |               |         | 18       | 16   | point |      |        |      |     |
|     |          | plus | 20            | faut    |          |      |       |      | chiffr |      |     |
|     |          |      | 2 2           |         | comp r i |      |       | veux |        |      |     |
|     | 10 (18)  |      |               |         |          | même |       |      | 25     | gain |     |
|     |          |      | 2 4 mettr     |         | 1 2      |      | mdr   |      |        |      |     |
| 0   | 28       | deux |               |         |          |      |       |      |        |      |     |
|     | met      | 26   | gagn          |         |          |      |       |      |        |      |     |
|     | 0        |      |               | 25      |          | 50   |       |      | 75     |      | 100 |
Rank in Substitution
Figure 20. Theranksof30mostfrequentlyusedwordsbynon-JPMpairsinbothtreatments.
37

G STM Specifications
G.1 Removed stopwords
“a, `a, ah, ai, aie, aient, aies, ait, aller, allez, alors, apres, apr`es, as, au, aura, aurai, auraient, aurais,
aurait, auras, aurez, auriez, aurions, aurons, auront, aux, avaient, avais, avait, avec, avez, aviez,
avions, avoir, avons, ayant, ayez, ayons, bah, bjr, bonjour, c, c’est, c’´etait, ca, ¸ca, cb, ce, ceci,
cela, cel`a, ces, cest, cet, cette, chose, coup, d, dans, de, des, donc, dsl, du, e, elle, en, es, est, et,
´etaient,´etais,´etait,´etant,´et´e,ˆetes,´etiez,´etions, etre,ˆetre, eu, eue, eues, euˆmes, eurent, eus, eusse,
eussen, eusses, eussiez, eussions, eut, euˆt, euˆtes, eux, fai, fair, faire, fais, fait, fuˆmes, furent, fus,
fusse, fussent, fusses, fussiez, fussions, fut, fuˆt, fuˆtes, ici, il, ils, j, j’avais, j’en, je, l, la, l`a, le, les,
leur, leurs, lui, m, m’a, m’as, ma, mais, me, mˆeme, mes, mis, mm, moi, mon, n, nan, ne, nn, non,
nos, notre, nous, o, ok, on, ont, ou, ouai, ouais, oui, ouii, p, par, pas, pas, peut, pour, pr, q, qu,
qu’il, qu’ils, qu’on, quand, que, quel, quelle, quelles, quels, qui, quoi, quon, re, s, s’il, sa, salut, sans,
se, sera, serai, seraient, serais, serait, seras, serez, seriez, serions, serons, seront, ses, si, sinon, soi,
soient, sois, soit, sommes, son, sont, sous, soyez, soyons, suis, sur, t, t’en, t’es, ta, te, tes, toi, ton,
tous, tout, tres, tr`es, tt, tu, un, une, va, vais, vas, vera, viens, vos, votre, vous, x, xd, y, ya”
G.2 Model Selection
As is necessary for any mixed-membership topic model, STM entails multi-modal estimation that
may depend on starting values of parameters such as the distribution over words for a particular
topic. Inthispaperweutilizeaninitializationmethodthatisknownasspectralinitialization,which
based on the method of moments that is deterministic and globally consistent under reasonable
assumptions (see Arora et al., 2013). Under spectral initialization, the only remaining choice
pertains to the number of topics to estimate, which involves, in general, evaluating outcomes of
estimations for different numbers according to some criteria. In our exercise, we followed the
methodology suggested by Roberts et al. (2019). We paid particular attention to four criteria. The
first one is semantic coherence developed by Mimno et al. (2011), which is maximized when the
most probable words in a given topic frequently co-occur together. As shown by Mimno et al.
(2011), the criterion correlates well with human judgment of topic quality. Formally, let D(v,v(cid:48)) be
the number of times that words v and v(cid:48) appear together in a document. Then given the number of
topics K in the model, for the list of MK most probable words in topic k, the semantic coherence
k
for topic k, CK, is computed as
k
CK = M (cid:88)k K (cid:88) i−1 log (cid:18) D(v i ,v j )+1 (cid:19) .
k D(v )
j
i=2 j=1
Second, it is desirable to have topics that can be distinguishable, i.e., they are exclusive to
topics. For this purpose, another criterion called FREX is proposed by Roberts et al. (2019)
(following Airoldi and Bischof, 2016), which assesses the degree to which high probability words
across topics coincide. FREX, what we denote by φ, is a weighted harmonic mean of the word’s
38

|     |     |     | Held−Out Likelihood |     |     |     |     | Residuals |     |     |
| --- | --- | --- | ------------------- | --- | --- | --- | --- | --------- | --- | --- |
00.5−
doohilekiL tuO−dleH
|     |     |     |     |     |     | slaudiseR | 53.1 |     |     |     |
| --- | --- | --- | --- | --- | --- | --------- | ---- | --- | --- | --- |
40.5−
52.1
80.5−
|     |     | 3 4 | 5                  | 6 7 | 8 9 | 10  | 3 4 | 5 6              | 7 8 | 9 10 |
| --- | --- | --- | ------------------ | --- | --- | --- | --- | ---------------- | --- | ---- |
|     |     |     | Number of Topics   |     |     |     |     | Number of Topics |     |      |
|     |     |     | Semantic Coherence |     |     |     |     | Exclusivity      |     |      |
ecnerehoC citnameS
|     | 42− |     |     |     |     | ytivisulcxE |     |     |     |     |
| --- | --- | --- | --- | --- | --- | ----------- | --- | --- | --- | --- |
4.8
82−
0.8
23−
|      |          | 3 4 | 5                | 6 7      | 8 9        | 10               | 3 4 | 5 6              | 7 8        | 9 10 |
| ---- | -------- | --- | ---------------- | -------- | ---------- | ---------------- | --- | ---------------- | ---------- | ---- |
|      |          |     | Number of Topics |          |            |                  |     | Number of Topics |            |      |
|      |          |     |                  |          | Figure     | 21. Diagnostics. |     |                  |            |      |
| rank | in terms | of  | exclusivity      | and      | frequency. | Formally,        |     |                  |            |      |
|      |          |     |                  | (cid:18) |            |                  |     |                  | (cid:19)−1 |      |
|      |          |     |                  |          |            | ω                | 1−ω |                  |            |      |
φK
|     |     |     |     | =   |        |           | +       |     | ,   |     |
| --- | --- | --- | --- | --- | ------ | --------- | ------- | --- | --- | --- |
|     |     |     |     | k,v |        | (cid:80)K | ECDF(β  | )   |     |     |
|     |     |     |     |     | ECDF(β | k,v /     | β j,v ) | k,v |     |     |
j=1
where β k,v is the probability of the word v in topic k, ECDF is the empirical CDF, and ω is the
|     |     |     | exclusivity.37 |     |     |     |     |     | φK, |     |
| --- | --- | --- | -------------- | --- | --- | --- | --- | --- | --- | --- |
weight given to For a topic k, the exclusivity of the topic, is calculated as the
k
MK
| average | of  | the top |     | words. |     |     |     |     |     |     |
| ------- | --- | ------- | --- | ------ | --- | --- | --- | --- | --- | --- |
k
Atopicthatisbothcohesiveinitswordsandexclusiveismorelikelytobesemanticallyrelevant.
Furthermore, we check residual dispersion (Taddy, 2012) and held-out likelihood (Wallach et al.,
2009)values. Computingthesemeasuresarestraightforwardwithinthestmpackage. Taddy(2012)
proposes the following residual analysis. First, the sample dispersion of the residuals is obtained
by dividing the mean of the squared adjusted residuals by the degrees of freedom parameter, which
itself is obtained by approximating the parameter Nˆ by the number of expected counts exceeding
a tolerance level (set to 100). When the model is correctly specified, the multinomial likelihood
implies that dispersion of residuals is 1. Hence, if the computed sample dispersion is greater than
this, thenumberoftopicsmightbetoolow, becausethelatenttopicsarenotabletoaccountforthe
variation. We also computed the document-completion held-out likelihood that is the estimation
of the probability of words being used by a subject when those words have been removed in the
estimation.38 Figure 21 shows relationship between these measures and the number of topics.
We have chosen three topics as this gives the highest semantic coherence without a significant
37We
|     | take | ω=0.7, | following | Roberts | et al. | (2019). |     |     |     |     |
| --- | ---- | ------ | --------- | ------- | ------ | ------- | --- | --- | --- | --- |
3850%
|     | of the | content | of 10% | of documents | are | held out. |     |     |     |     |
| --- | ------ | ------- | ------ | ------------ | --- | --------- | --- | --- | --- | --- |
39

loss in terms of held-out likelihood. Both the residual analysis and exclusivity naturally point to
higher number of topics. As the residuals constraint can never be satisfied within our topic number
interval, and exclusivity may not be a major concern in a specific context such as our experiment,
we are not worried about the low performance of the three-topic model on these measures. We
believe including more topics in the estimation would not add to our analysis.
G.3 Estimated topic proportions within pairs
JPM=0, Early=0, ID=1894 JPM=0, Early=0, ID=2091 JPM=0, Early=0, ID=2092 JPM=0, Early=0, ID=2097 JPM=0, Early=0, ID=292
1.00
0.75
0.50
0.25
0.00
JPM=0, Early=0, ID=293 JPM=0, Early=0, ID=591 JPM=0, Early=0, ID=597 JPM=0, Early=0, ID=896 JPM=1, Early=0, ID=1895
1.00
0.75
0.50
0.25
0.00
JPM=1, Early=0, ID=1899 JPM=1, Early=0, ID=2089 JPM=1, Early=0, ID=2090 JPM=1, Early=0, ID=2094 JPM=1, Early=0, ID=2096
1.00
0.75
0.50
0.25
0.00
JPM=1, Early=0, ID=296 JPM=1, Early=0, ID=297 JPM=1, Early=0, ID=298 JPM=1, Early=0, ID=594 JPM=1, Early=0, ID=596
1.00
0.75
0.50
0.25
0.00
JPM=1, Early=1, ID=1896 JPM=1, Early=1, ID=1897 JPM=1, Early=1, ID=2093 JPM=1, Early=1, ID=2095 JPM=1, Early=1, ID=2099
1.00
0.75
0.50
0.25
0.00
JPM=1, Early=1, ID=291 JPM=1, Early=1, ID=294 JPM=1, Early=1, ID=295 JPM=1, Early=1, ID=299 JPM=1, Early=1, ID=592
1.00
0.75
0.50
0.25
0.00
JPM=1, Early=1, ID=593 JPM=1, Early=1, ID=595 JPM=1, Early=1, ID=598 JPM=1, Early=1, ID=599 JPM=1, Early=1, ID=898
1.00
0.75
0.50
0.25
0.00
1 2 3 1 2 3 1 2 3 1 2 3
JPM=1, Early=1, ID=899
1.00
0.75
0.50
0.25
0.00
1 2 3
Topic
noitroporP
Figure 22. Estimated topic proportions within pairs in substitution treatment.
40

JPM=0, Early=0, ID=1393 JPM=0, Early=0, ID=1397 JPM=0, Early=0, ID=1498 JPM=0, Early=0, ID=396 JPM=0, Early=0, ID=94
1.00
0.75
0.50
0.25
0.00
JPM=0, Early=0, ID=96 JPM=0, Early=0, ID=97 JPM=0, Early=0, ID=996 JPM=0, Early=0, ID=997 JPM=1, Early=0, ID=1296
1.00
0.75
0.50
0.25
0.00
JPM=1, Early=0, ID=1394 JPM=1, Early=0, ID=1396 JPM=1, Early=0, ID=1398 JPM=1, Early=0, ID=1399 JPM=1, Early=0, ID=1492
1.00
0.75
0.50
0.25
0.00
JPM=1, Early=0, ID=1495 JPM=1, Early=0, ID=1496 JPM=1, Early=0, ID=1694 JPM=1, Early=0, ID=1696 JPM=1, Early=0, ID=1698
1.00
0.75
0.50
0.25
0.00
JPM=1, Early=0, ID=1699 JPM=1, Early=0, ID=1997 JPM=1, Early=0, ID=1998 JPM=1, Early=0, ID=1999 JPM=1, Early=0, ID=397
1.00
0.75
0.50
0.25
0.00
JPM=1, Early=0, ID=399 JPM=1, Early=0, ID=99 JPM=1, Early=0, ID=995 JPM=1, Early=1, ID=1297 JPM=1, Early=1, ID=1298
1.00
0.75
0.50
0.25
0.00
JPM=1, Early=1, ID=1299 JPM=1, Early=1, ID=1392 JPM=1, Early=1, ID=1395 JPM=1, Early=1, ID=1493 JPM=1, Early=1, ID=1494
1.00
0.75
0.50
0.25
0.00
JPM=1, Early=1, ID=1497 JPM=1, Early=1, ID=1499 JPM=1, Early=1, ID=1691 JPM=1, Early=1, ID=1692 JPM=1, Early=1, ID=1693
1.00
0.75
0.50
0.25
0.00
JPM=1, Early=1, ID=1695 JPM=1, Early=1, ID=1697 JPM=1, Early=1, ID=1994 JPM=1, Early=1, ID=1995 JPM=1, Early=1, ID=1996
1.00
0.75
0.50
0.25
0.00
1 2 3
JPM=1, Early=1, ID=398 JPM=1, Early=1, ID=98 JPM=1, Early=1, ID=998 JPM=1, Early=1, ID=999
1.00
0.75
0.50
0.25
0.00
1 2 3 1 2 3 1 2 3 1 2 3
Topic
noitroporP
Figure 23. Estimated topic proportions within pairs in complementarity treatment.
41

| G.4 Chat      | record                 | examples |               |       |             |                      |              |
| ------------- | ---------------------- | -------- | ------------- | ----- | ----------- | -------------------- | ------------ |
|               |                        |          |               | 1     | 2           | 3                    |              |
|               |                        |          |               | 0.92  | 0.03 0.04   |                      |              |
|               |                        | Table    | 10. Estimated | topic | proportions |                      | in Pair 397. |
| Period Player | Message                |          |               |       |             | English              | translation  |
| 0 1           | bonjour                |          |               |       |             | hello                |              |
| 1 1           | jeproposedechoisir18.0 |          |               |       |             | Iproposetochoose18.0 |              |
| 1 2           | camarche               |          |               |       |             | alright              |              |
| 2 1           | choisir18.0            |          |               |       |             | choose18.0           |              |
2 2 noussommescens´eschoisirlemmnombre? Arewesupposetochoosethesamenumber?
| 2 2 | ??    |     |     |     |     | ??   |     |
| --- | ----- | --- | --- | --- | --- | ---- | --- |
| 3 1 | 18.0  |     |     |     |     | 18.0 |     |
| 3 2 | moi16 |     |     |     |     | me16 |     |
| 4 1 | ?     |     |     |     |     | ?    |     |
4 2 jechercheunpeusurletableauprvoirlameilleure I’mlookingalittlebitonthetabletoseethebest
|     | combinaisonprnous2 |     |     |     |     | combinationforustwo |     |
| --- | ------------------ | --- | --- | --- | --- | ------------------- | --- |
| 4 2 | 20prns2            |     |     |     |     | 20forustwo          |     |
| 5 2 | 22prnous2          |     |     |     |     | 22forustwo          |     |
6 2 tupensesquonestsurlabonnevoie? Doyouthinkthatwe’reonrighttrack?
| 6 1 | OUI                  |     |     |     |     | YES                 |     |
| --- | -------------------- | --- | --- | --- | --- | ------------------- | --- |
| 6 2 | 24prns2              |     |     |     |     | 24forustwo          |     |
| 6 1 | OK                   |     |     |     |     | OK                  |     |
| 7 2 | propose              |     |     |     |     | propose             |     |
| 7 1 | 28.0POURNS           |     |     |     |     | 28forus             |     |
| 7 2 | ok                   |     |     |     |     | ok                  |     |
| 8 2 | 26?                  |     |     |     |     | 26?                 |     |
| 8 1 | OK                   |     |     |     |     | OK                  |     |
| 9 1 | ONCONTINUECOMMEC¸A   |     |     |     |     | Wekeepdoinglikethis |     |
| 9 2 | situvxonrestesurle26 |     |     |     |     | Wekeep26ifyouwant   |     |
| 9 1 | OUI                  |     |     |     |     | YES                 |     |
| 9 1 | CMIEUX               |     |     |     |     | It’sbetter          |     |
| 9 2 | okcamarche           |     |     |     |     | Okalright           |     |
10-14
15 2 tupensesqueccequilfautfaire:d? Doyouthinkthatit’swhatwehavetodo?
| 15 1 | OUI     |     |     |     |     | YES    |     |
| ---- | ------- | --- | --- | --- | --- | ------ | --- |
| 15 1 | JECROIS |     |     |     |     | ITHINK |     |
| 15 2 | okk     |     |     |     |     | Ok     |     |
16-19
| 20 2 | cennuyeux |     |     |     |     | It’sboring |     |
| ---- | --------- | --- | --- | --- | --- | ---------- | --- |
| 20 1 | CVRAI     |     |     |     |     | it’strue   |     |
21-30
|     | Table | 11. Chat | record | of Pair | 397 in | time order | within periods. |
| --- | ----- | -------- | ------ | ------- | ------ | ---------- | --------------- |
42

|               |         |       |               | 1     | 2           | 3       |               |
| ------------- | ------- | ----- | ------------- | ----- | ----------- | ------- | ------------- |
|               |         |       |               | 0.05  | 0.66 0.30   |         |               |
|               |         | Table | 12. Estimated | topic | proportions |         | in Pair 1393. |
| Period Player | Message |       |               |       |             | English | translation   |
| 0 2           | Bonjour |       |               |       |             | Hello   |               |
| 0 1           | bonjour |       |               |       |             | Hello   |               |
1 1 faut qu’il y en ai un qui mettre des chiffres entre There has to be one who puts a number between
18et20etl’autreentre26et28? 18and20andtheotherbetween26and28?
1 2 J’aipastropcomprislebusdelaboitededialogue, Ididn’tquiteunderstandthebus(purpose)ofthe
|     | jerentrelechois6.0 |     |     |     |     | boxofthedialogue,Iputinthechoice6.0 |     |
| --- | ------------------ | --- | --- | --- | --- | ----------------------------------- | --- |
| 1 2 | Jenesaispas        |     |     |     |     | Idon’tknow                          |     |
| 2 1 | onmetquoi,         |     |     |     |     | Whatdoweputin?                      |     |
2 2 Il faut ˆetre en fonction du tableau pour avoir le Ithastobethataccordedtothetable,tohavethe
|     | plusdegainspossiblesc’estca? |     |     |     |     | biggestgainhasn’tit?         |     |
| --- | ---------------------------- | --- | --- | --- | --- | ---------------------------- | --- |
| 2 2 | jemets26?                    |     |     |     |     | DoIputin26?                  |     |
| 2 1 | JEPENSE                      |     |     |     |     | ITHINK                       |     |
| 2 1 | MOI24                        |     |     |     |     | ME24                         |     |
| 2 1 | oklm                         |     |     |     |     | Cosy                         |     |
| 2 2 | onbrasse                     |     |     |     |     | Let’sdoit                    |     |
| 3 2 | jemets28                     |     |     |     |     | Iputin28                     |     |
| 3 2 | cquoilebutdelaperiode?       |     |     |     |     | What’sthepurposeoftheperiod? |     |
| 3 1 | mois10                       |     |     |     |     | month(me)10                  |     |
| 3 1 | riencomprisjesuisamopinsla   |     |     |     |     | Idon’tunderstandanything     |     |
| 3 1 | moins                        |     |     |     |     | minus                        |     |
| 3 2 | moinonmaisjecomprendspaspq   |     |     |     |     | NotmebutIdon’tunderstandwhy  |     |
| 3 1 | t’asmis3auderniertruc?       |     |     |     |     | Didyouput3inthelastthing?    |     |
| 3 2 | oui                          |     |     |     |     | yes                          |     |
| 3 2 | ettoi                        |     |     |     |     | andyou                       |     |
| 3 1 | 24                           |     |     |     |     | 24                           |     |
| 4 2 | moi13cca?                    |     |     |     |     | me13isit?                    |     |
| 4 1 | moi12                        |     |     |     |     | me12                         |     |
| 4 1 | situveux                     |     |     |     |     | Ifyouwant                    |     |
| 4 2 | camarche                     |     |     |     |     | alright                      |     |
4 2 fautetreenfonctiondescolonnesdonctoiteshor- Wehavetobebythecolumnssoareyouhorizontal
|     | izontaleouverticale?       |     |     |     |     | orvertical?                |     |
| --- | -------------------------- | --- | --- | --- | --- | -------------------------- | --- |
| 4 1 | jesaispaschacunsacolonne   |     |     |     |     | Idon’tknoweachonehiscolumn |     |
| 5 2 | onemettouslesdeux28?       |     |     |     |     | Webothput28?               |     |
| 5 2 | met                        |     |     |     |     | put                        |     |
| 5 1 | ouionessayevoirc’quecafait |     |     |     |     | Yeswetrytoseewhatitdoes    |     |
5 2 tuveuxverticaleouhorizontalepourlasuite? Doyouwanthorizontalorverticalfortherest?
5 1 28touslesdeuxcadevraitfaire41.27 28forustwoshouldmake41.27
| 5 2 | c’estbonca |     |     |     |     | Thisisgood |     |
| --- | ---------- | --- | --- | --- | --- | ---------- | --- |
5 1 c’est pareil mdr j’essaye de comprendre leur truc It’s the same lol I’m trying to understand their
|     | la                   |          |        |         |         | thingnow             |                 |
| --- | -------------------- | -------- | ------ | ------- | ------- | -------------------- | --------------- |
| 5 2 | moijecomprensdpas    |          |        |         |         | Idon’tunderstandit   |                 |
| 5 1 | j’croisj’comprendkla |          |        |         |         | IthinkIunderstandnow |                 |
|     | Table                | 13. Chat | record | of Pair | 1393 in | time order           | within periods. |
43

| Period Player | Message                      |     |     | English                   | translation |
| ------------- | ---------------------------- | --- | --- | ------------------------- | ----------- |
| 6 2           | jemets12toi28?               |     |     | Iput12andyouput28?        |             |
| 6 1           | j’aipris-45                  |     |     | Itook-45                  |             |
| 6 1           | mdrrr                        |     |     | lol                       |             |
| 6 2           | jesaismdr                    |     |     | Iknowlol                  |             |
| 6 2           | 1248?                        |     |     | 1248?                     |             |
| 6 1           | lesescrocettoit’asgagne      |     |     | Thescammersandyouwon      |             |
| 6 2           | cestcalestyle                |     |     | That’scool                |             |
| 6 1           | atytj’essayunchiffegardele28 |     |     | WaitItryanumber,keepthe28 |             |
| 6 2           | jemtes28?                    |     |     | DoIput28?                 |             |
| 6 1           | oui                          |     |     | Yes                       |             |
7 2 dismoitonchiffrej’auidumettreauhasard TellmeyournumberthatIprobablyputrandomly
| 7 1 | maisserieux             |     |     | Seriously                    |     |
| --- | ----------------------- | --- | --- | ---------------------------- | --- |
| 7 2 | mdrrrrrr                |     |     | lol                          |     |
| 7 2 | onmetquoi               |     |     | Whatdoweput                  |     |
| 7 2 | s                       |     |     | s                            |     |
| 7 2 | jetesuit                |     |     | Ifollowyou                   |     |
| 7 1 | j’met28metauhasardtoi   |     |     | I’mputting28,youputrandomly  |     |
| 7 2 | moijemets12             |     |     | Iput12                       |     |
| 7 1 | ok                      |     |     | 12                           |     |
| 7 1 | j’vaisfinira-1000       |     |     | Iamgoingtoendat-1000         |     |
| 7 2 | pasbeaucoupdesoustoutca |     |     | That’snotalotofmoney         |     |
| 7 2 | mdrctoiquivadevoirpayer |     |     | lolit’syouwhowillhavetopayit |     |
| 8 2 | MAISJECOMPRENDSPAS      |     |     | BUTIDON’TUNDERSTAND          |     |
| 8 2 | jemets22toi44?          |     |     | Iput22andyouput44?           |     |
8 1 j’suistellementennegatifqu’ilsvontmedemander I am so much in the minus that they will ask me
|     | del’argentalafin |     |     | moneyattheend |     |
| --- | ---------------- | --- | --- | ------------- | --- |
| 8 2 | cesthyperbizarre |     |     | It’ssostrange |     |
| 8 2 | mdrrrrouic’estc  |     |     | lolyesexactly |     |
| 8 2 | a                |     |     | a             |     |
| 8 1 | moijemet3        |     |     | Iput3         |     |
8 2 maispqlesimpairscpasdansletableau? Butwhyaren’ttheoddnumbersinthetable?
8 1 aupointouj’ensuisjetentedetoucherlejackpot AtthesituationIamI’mtryingtotouchthejack-
pot
| 9 2 | tableauuuuuuu          |     |     | Tableeeeeee          |     |
| --- | ---------------------- | --- | --- | -------------------- | --- |
| 9 1 | fautqu’onretentele1213 |     |     | Wehavetotry1213again |     |
9 2 laperiodeonestd’accordctotalementauhasard Weagreethattheperiodiscompletelyrandom?
?
| 9 1 | jemet12ettoi13     |     |     | Iput12andyouput13 |     |
| --- | ------------------ | --- | --- | ----------------- | --- |
| 9 1 | oui                |     |     | yes               |     |
| 9 2 | pa12et13           |     |     | Not12and13        |     |
| 9 2 | j’aimepas13        |     |     | Idontlike13       |     |
| 9 2 | jepeuxpasmettre14? |     |     | Can’tIput14?      |     |
| 9 1 | situveux           |     |     | Ifyouwant         |     |
| 9 2 | periodeauhasard?   |     |     | randomperiod?     |     |
9 1 quandtucalculsdansleurtructugagnesachauqe Ifyoucalculateintheirthingyouwineverytime
|     | foisetlerien |     |     | andthenothing |     |
| --- | ------------ | --- | --- | ------------- | --- |
10 2 Onessaiememechiffrememeperiode? Dowetrysamenumbersameperiod?
| 10 1 | j’aidespointqs!!!!!!! |        |     | Ihavepoints!!!!! |        |
| ---- | --------------------- | ------ | --- | ---------------- | ------ |
| 10 2 |                       |        |     |                  |        |
| 10 2 | BRAVO                 |        |     | CONGRATULATION   |        |
| 10 1 | ouisituveux           |        |     | Yesifyouwant     |        |
| 10 2 | onmetquoi             |        |     | Whatdoweput      |        |
| 10 1 | quelchiffre?          |        |     | Whichdigit?      |        |
| 10 1 | mdrrmemequestion      |        |     | lolsamequestion  |        |
| 10 2 | 26                    |        |     | 26               |        |
| 10 1 | ok                    |        |     | ok               |        |
| 10 2 | etperiode......       | decide |     | andperiod......  | decide |
10 1 tuvasgagnerdespointstoiet(moinegatif Youaregoingtowinpointsand(menegative
10 2 siongagnepaspareilccheloui Ifwedon’twininthesamewayit’sweird
| 10 2 | pourquoi |                 |              | Why           |                 |
| ---- | -------- | --------------- | ------------ | ------------- | --------------- |
|      | Table    | 14. Chat record | of Pair 1393 | in time order | within periods. |
44

| Period Player | Message                 |     |     | English                | translation |
| ------------- | ----------------------- | --- | --- | ---------------------- | ----------- |
| 11 2          | okmauvauisetechnique    |     |     | Okaybadtechnique       |             |
| 11 2          | mdr                     |     |     | lol                    |             |
| 11 2          | jet’´ecoutemtnt         |     |     | I’mlisteningtoyounow   |             |
| 11 1          | STOPPPP                 |     |     | STOPPPP                |             |
| 11 2          | donnemoitesinstructions |     |     | Givemeyourinstructions |             |
11 1 maispktugagnestoujoursetpasmoi Butwhydoyoualwayswinandnotme
| 11 2 | pacqjesuistropfraiche |     |     | BecauseI’mtoofresh |     |
| ---- | --------------------- | --- | --- | ------------------ | --- |
11 1 memequandonmetlesmemesresultatsmoij’perd EvenwhenweputthesameanswersIlose-50and
|      | -50ettoi+            |     |     | you+                     |     |
| ---- | -------------------- | --- | --- | ------------------------ | --- |
| 11 2 | troptropbizarre      |     |     | sosoweird                |     |
| 11 1 | yauntrucla           |     |     | There’ssomethinghere     |     |
| 11 2 | jemetsquoitumetsquoi |     |     | WhydoIputandwhatdoyouput |     |
| 11 2 | dismoi               |     |     | tellme                   |     |
| 11 2 | 10sec                |     |     | 10seconds                |     |
| 11 1 | viensonmethasqard    |     |     | Let’sputrandomly         |     |
12 2 moijepenseclaperiodequifaittout Ithinkthatit’stheperiodwhichdoeseverything
| 12 1 | etallezencore          |     |     | andagain                |     |
| ---- | ---------------------- | --- | --- | ----------------------- | --- |
| 12 2 | lerestecdubaratin      |     |     | theothersarespiels      |     |
| 12 1 | cachangeqsuoilaperiode |     |     | Whatdoestheperiodchange |     |
12 2 Jsais pas regarde on met les mm chiffres et une Idon’tknowlookweputthesamenumbersanda
|      | periodediff´erente              |     |     | differentperiod             |               |
| ---- | ------------------------------- | --- | --- | --------------------------- | ------------- |
| 12 2 | r´esultat: t’esenmoins          |     |     | result:                     | youareinminus |
| 12 2 | moienplus                       |     |     | meinplus                    |               |
| 12 2 | doncbon...                      |     |     | Soyes                       |               |
| 12 1 | vasyonmet10et12                 |     |     | Let’sput10and12             |               |
| 12 2 | periode: 9                      |     |     | period:                     | 9             |
| 12 2 | moi10                           |     |     | me10                        |               |
| 12 1 | 9alors                          |     |     | 9then                       |               |
| 13 2 | okdonconfaitenfonctiondutableau |     |     | Oksowedobasedonthetable     |               |
| 13 1 | t’asmis9?                       |     |     | Didyouput9?                 |               |
| 13 2 | acveclesmemeperiodes            |     |     | Withthesameperiods          |               |
| 13 2 | ouienperiodejaimis9             |     |     | yesIput9asaperiod           |               |
| 13 1 | onmet10?                        |     |     | doweput10?                  |               |
| 13 2 | enperiode?                      |     |     | asaperiod?                  |               |
| 13 2 | etenchiffreonmet2222            |     |     | andasnumbersweput2222       |               |
| 13 2 | ?                               |     |     | ?                           |               |
| 13 1 | onvoitoulaperiode?              |     |     | wheredoweseetheperiod?      |               |
| 13 2 | cladeuxiemeetape                |     |     | itisthesecondstep           |               |
| 13 1 | situveux                        |     |     | ifyouwant                   |               |
| 13 2 | ok22periode10                   |     |     | ok22period10                |               |
| 13 2 | deterr                          |     |     | decided                     |               |
| 14 2 | t’aqsmislamemeperiode?????      |     |     | Didyouputthesameperiod????? |               |
| 14 1 | c’estquoilaperiode????          |     |     | What’stheperiod????         |               |
| 14 2 | la2eetapela                     |     |     | thesecondstepnow            |               |
| 14 1 | c’estouquet’ecrislaperiode??    |     |     | Wheredoyouwritetheperiod??  |               |
| 14 2 | jappellecaperiode               |     |     | Icallitperiod               |               |
| 14 2 | enhautadroiteapresca            |     |     | Onthetopattherightafterthis |               |
14 1 j’aiqu’uneetapemoic’estecrireunchiffre Ionlyhaveonestepanditistowriteanumber
| 14 2 | ouicca                   |     |     | yesitisthat          |     |
| ---- | ------------------------ | --- | --- | -------------------- | --- |
| 14 1 | moij’aiecris22c’zesttout |     |     | Iwrote22andthat’sall |     |
| 15 1 | t’asmiscb?               |     |     | Howmanydidyouput?    |     |
| 15 1 | moi14                    |     |     | me14                 |     |
15 2 EN FAIT C MIEUX QUAND Y A PAS DE ACTUALLY IT’S BETTER WHEN THERE IS
|      | STRATEGIEETQU’onmetauhasard |                 |              | NOSTRATEGYANDTHATweputrandomly    |                 |
| ---- | --------------------------- | --------------- | ------------ | --------------------------------- | --------------- |
| 15 2 | moi10                       |                 |              | me10                              |                 |
| 15 1 | ouivoila                    |                 |              | yesthat’sright                    |                 |
| 15 2 | lajemets26faistalife        |                 |              | hereIput26andyoudowhateveryouwant |                 |
| 15 1 | ok                          |                 |              | ok                                |                 |
|      | Table                       | 15. Chat record | of Pair 1393 | in time order                     | within periods. |
45

| Period Player | Message             |     |     | English                    | translation |
| ------------- | ------------------- | --- | --- | -------------------------- | ----------- |
| 16 2          | jaipascompris       |     |     | Ididn’tunderstand          |             |
| 16 1          | hello               |     |     | hello                      |             |
| 16 2          | salut               |     |     | hi                         |             |
| 16 1          | onfaitnotrelifemtn  |     |     | wedowhateverwewantnow      |             |
| 16 2          | camarche            |     |     | alright                    |             |
| 16 1          | c’estcheat´e        |     |     | itischeating               |             |
| 16 2          | jecapteriencamegave |     |     | Idon’tgetanythingI’menough |             |
| 16 2          | encore1h.....       |     |     | still1hour.....            |             |
| 16 1          | pareil              |     |     | same                       |             |
| 17 1          | riencompris         |     |     | Iunderstandnothing         |             |
| 17 2          | bahmoinonplus       |     |     | wellmeneither              |             |
17 2 maisyarienacomprendreamonavis butIthinkthatthere’snothingtounderstand
17 2 ilstestentnotrefacondereflechir theyaretestingourwayofthinking
17 2 etlailscaptentqu’onestpastresintelligents and now they understand that we are not very
smart
17 1 mais quand tu fais dans le calculateur de gain ca but when you do in the calculator of the gain it
|      | donnejamaisalmemechose |     |     | nevergivesthesamething |     |
| ---- | ---------------------- | --- | --- | ---------------------- | --- |
| 17 2 | bahnanccaquiestbizarre |     |     | wellthat’swhat’sweird  |     |
| 17 1 | c’estquoiledelirelaaa  |     |     | What’stheproblemhereee |     |
| 18 2 | onfaitquoi             |     |     | whatdowedo             |     |
| 18 2 | concretementla         |     |     | concretelynow          |     |
| 18 2 | cam’agace              |     |     | itannoysme             |     |
18 1 ils ont peur qu’on gagne trop le l’experience est they are afraid that we win too much the experi-
|      | truqu´eemdr             |     |     | mentistrickedlol      |     |
| ---- | ----------------------- | --- | --- | --------------------- | --- |
| 18 2 | mdrrrrrcsurementca      |     |     | lolit’scertainlythat  |     |
| 18 2 | jemetsttletpspareilmtnt |     |     | Ialwaysputthesamenow  |     |
| 19 1 | gavaoooo                |     |     | I’menooouugh          |     |
| 19 2 | etencore1h              |     |     | andstill1hour         |     |
| 19 2 | onvasefaire1euro        |     |     | wearegoingtomake1euro |     |
| 19 1 | jamais                  |     |     | never                 |     |
| 19 2 | ccool:)                 |     |     | it’scool              |     |
| 19 2 | garrooooo               |     |     |                       |     |
19 1 t’faconilsvontmedemanderdel’argentavecmon they are going to ask me money anyway with my
|      | scorenegatifj’mebarreencourant |     |     | minusscoreIwillruntoescape |     |
| ---- | ------------------------------ | --- | --- | -------------------------- | --- |
| 19 2 | mdrrrrlafuite                  |     |     | loltheescape               |     |
20 2 danslesprevisionsilsdisaientquej’avais20points In the previsions they were saying that I had 20
|      | ettoi18    |     |     | pointsandyou18 |     |
| ---- | ---------- | --- | --- | -------------- | --- |
| 20 2 | bahquedal  |     |     | wellnothing    |     |
| 20 2 | doncnashav |     |     | soalie         |     |
| 20 1 | fakeeee    |     |     | fake           |     |
| 20 1 | 18         |     |     | 18             |     |
| 20 1 | et18       |     |     | and18          |     |
| 20 2 | oki        |     |     | ok             |     |
| 21 2 | 2828       |     |     | 2828           |     |
21 1 pkcaamarchela???????????????? whydoesitworknow???????????
| 21 1 | non20et20              |     |     | no20and20             |     |
| ---- | ---------------------- | --- | --- | --------------------- | --- |
| 21 2 | 2626mˆeme              |     |     | 2626same              |     |
| 21 2 | ok                     |     |     | ok                    |     |
| 21 2 | 2828cafaitplusdepoints |     |     | 2828itmakesmorepoints |     |
21 1 mdrrrrrrr28cazportemalheurdepuisledebut lol28isbadluckfromthebeginning
| 21 2 | mdrrrrj’avoue |     |     | lolit’strue |     |
| ---- | ------------- | --- | --- | ----------- | --- |
| 21 1 | 20            |     |     |             |     |
| 21 2 | donc20        |     |     | so20        |     |
| 21 1 | yessssss      |     |     | yes         |     |
21 2 maisjeviensdecoprendreenfait waitIjustunderstoodnowactually
| 22 2 | test2828 |                 |              | try2828       |                 |
| ---- | -------- | --------------- | ------------ | ------------- | --------------- |
|      | Table    | 16. Chat record | of Pair 1393 | in time order | within periods. |
46

| Period Player | Message  |     |     | English   | translation |
| ------------- | -------- | --- | --- | --------- | ----------- |
| 23 2          | 28lesang |     |     | 28thelife |             |
23 1 onprendlesmemesetonrecommence wetakethesameandwedoitagain
| 23 2 | que28          |     |     | only28          |     |
| ---- | -------------- | --- | --- | --------------- | --- |
| 23 2 | clemeilleur    |     |     | it’sthebest     |     |
| 23 2 | cafait41points |     |     | itmakes41points |     |
23 2 onauraitdufairecadepuisled´ebut weshould’vedonethissincethebeginning
| 23 1 | oui                     |     |     | yes            |     |
| ---- | ----------------------- | --- | --- | -------------- | --- |
| 24 1 | same                    |     |     | same           |     |
| 24 2 | clebest                 |     |     | it’sthebest    |     |
| 24 2 | tuvoiscaportepasmalheur |     |     | seeit’sbadluck |     |
| 24 2 | plusque6etapes          |     |     | only6stepsleft |     |
| 24 2 | allelujah               |     |     | hallelujah     |     |
| 24 1 | gogoggogogogo           |     |     | go             |     |
| 25 1 | 26?                     |     |     | 26?            |     |
25 2 bah nan c pas equitable quand on met pas les well no because it’s not even if we don’t put the
|      | mˆemesnombres |     |     | samenumbers |     |
| ---- | ------------- | --- | --- | ----------- | --- |
| 25 1 | 26et26        |     |     | 26and26     |     |
25 2 genresijemets20toi26jai60pointeettoi14 ifIput20andyou26Iget60pointsandyou14
| 25 2 | onvagagnermoinsque28avec26 |     |     | wewillwinlessthan28with26 |     |
| ---- | -------------------------- | --- | --- | ------------------------- | --- |
| 25 2 | doncrestonssur28           |     |     | solet’sstayon28           |     |
| 25 1 | o                          |     |     | o                         |     |
| 26 2 | acoupde-60pourtoiaud´ebut  |     |     | so-60foryouatthebeginning |     |
| 26 2 | onestd´ebiles              |     |     | wearestupid               |     |
| 26 2 | onauraitdugarder28         |     |     | weshould’vekept28         |     |
| 26 1 | ouiiiiiii                  |     |     | yeeees                    |     |
26 2 dans tous les cas ca va nous payer le paquet de it’llpayusthepacketofGarranyway
garr
| 27 1 | xd       |     |     | lol  |     |
| ---- | -------- | --- | --- | ---- | --- |
| 27 2 | XHDmˆeme |     |     | same |     |
27 1 cavamemepasmepayerlepaquetdegarrstp itwon’tevenpaymethepacketofgar
| 27 2 | maissi                    |     |     | yesitwill                    |     |
| ---- | ------------------------- | --- | --- | ---------------------------- | --- |
| 27 2 | t’ascash5euros            |     |     | doyouhave5eurosincash        |     |
| 27 2 | ett’zurasbiengagn´e2euros |     |     | andyouwouldhavewellwon2euros |     |
27 1 nonj’aipristropdemalusaudebut noItooksomanybadthingsatthebeginning
| 27 2 | ahouimerde                   |     |     | ohyessh*t                 |     |
| ---- | ---------------------------- | --- | --- | ------------------------- | --- |
| 27 2 |                              |     |     |                           |     |
| 27 2 |                              |     |     |                           |     |
| 27 2 | moij’enaipresquepaseuenscred |     |     | Igotalmostnothinginsecret |     |
| 27 2 | maisjesaispaspq              |     |     | butIdon’tknowwhy          |     |
27 1 non ils vont me raquetter a la fin avec tous les notheywillaskmeformoneywithalltheminus
|     | moinsquej’aieu |     |     | Igot |     |
| --- | -------------- | --- | --- | ---- | --- |
28 1 en vrai j’espere prochaine experience c’est indi- actually I hope that the next experiment will be
|      | viduel                       |     |     | individual            |     |
| ---- | ---------------------------- | --- | --- | --------------------- | --- |
| 28 2 | mdrpourquoi                  |     |     | lolwhy                |     |
| 28 1 | etpasavecdeschiffrestoutmort |     |     | andwithoutdeadnumbers |     |
| 28 2 | ahoui                        |     |     | ahyes                 |     |
| 28 2 | tropbizarreeeee              |     |     | soweird               |     |
28 2 camelaisseperplexeleurslogicielsla theirsoftwareleavesmeconfused
28 1 parcequetoutseulaumoinsjt’eferaispasperdre becausealoneIwon’tmakeyoulose
delov´es
| 28 2 | :$    |                 |              | :$            |                 |
| ---- | ----- | --------------- | ------------ | ------------- | --------------- |
|      | Table | 17. Chat record | of Pair 1393 | in time order | within periods. |
47

| Period Player | Message                      |     |     | English                 | translation |
| ------------- | ---------------------------- | --- | --- | ----------------------- | ----------- |
| 29 2          | 2s´eancesetbasta             |     |     | twosessionsandthat’sall |             |
| 29 2          | gavaoamax                    |     |     | let’sdoit               |             |
| 29 1          | onfinissurleschapeauxderoues |     |     | weendonagoodway         |             |
| 29 2          | 28282828282828828            |     |     | 28282828282828828       |             |
| 29 2          | nsm                          |     |     |                         |             |
29 1 prochainerseancejefaispeterlabanquemdrr inthenextsessionIwillmakethebankexplode
| 29 2 | mdrrrrrvoila     |     |     | yesthat’sit    |     |
| ---- | ---------------- | --- | --- | -------------- | --- |
| 29 2 | q15eurosminimumq |     |     | 15eurosminimum |     |
| 29 2 | LOL              |     |     | LOL            |     |
29 1 minimumlemimiprochaineseance thenextlittlesessionatleast
| 30 2 | THELASTONE |     |     | THELASTONE |     |
| ---- | ---------- | --- | --- | ---------- | --- |
| 30 2 | YEAH       |     |     | YEAH       |     |
30 1 prochaineseanceminimum2paquetdegarro thenextsessionminimum2packetsofgarro
| 30 1 | enfinnnnnnfini           |     |     | finallyfinished            |     |
| ---- | ------------------------ | --- | --- | -------------------------- | --- |
| 30 2 | mdrc’estl’objectif       |     |     | lolit’ttheobjective        |     |
| 30 1 | yespaquetsouplebiensur   |     |     | yesaflexiblepacketofcourse |     |
| 30 2 | tupensesyadesstrategies? |     |     | doyouthinkthere’sstrategy? |     |
| 30 2 | mdrpouravoirlaclasse     |     |     | loltobecool                |     |
| 30 1 | pourfairel’bg            |     |     | toactthecoolguy            |     |
30 1 nonyarienj’pensedfautetrzebeteetrdiscipline no there’s nothing I think we have to be stupid
andhavediscipline
| 30 1 | ettravauillerenequipe |                 |              | andworkwiththeteam |                 |
| ---- | --------------------- | --------------- | ------------ | ------------------ | --------------- |
|      | Table                 | 18. Chat record | of Pair 1393 | in time order      | within periods. |
48

|               |                                   |       |               | 1     | 2           | 3                          |              |
| ------------- | --------------------------------- | ----- | ------------- | ----- | ----------- | -------------------------- | ------------ |
|               |                                   |       |               | 0.04  | 0.05 0.91   |                            |              |
|               |                                   | Table | 19. Estimated | topic | proportions |                            | in Pair 595. |
| Period Player | Message                           |       |               |       |             | English                    | translation  |
| 0 1           | bonjour                           |       |               |       |             | hello                      |              |
| 0 2           | bonjour                           |       |               |       |             | hello                      |              |
| 1 1           | tuveuxprendrequelchifffre         |       |               |       |             | whichnumberdoyouwanttotake |              |
| 1 2           | ilfautfairequoil`a?               |       |               |       |             | whatdowehavetodohere?      |              |
| 1 1           | tape28                            |       |               |       |             | patin28                    |              |
| 1 1           | faitmoiconfiance                  |       |               |       |             | trustme                    |              |
| 2 1           | tavuonagagnetoutlesdeux40centimes |       |               |       |             | youseewewinboth40cents     |              |
2 2 oncontinucomme¸catoutlelong? wekeepdoinglikethisallalong?
| 2 1 | continuedetape28 |     |     |     |     | keepputting28in |     |
| --- | ---------------- | --- | --- | --- | --- | --------------- | --- |
| 2 2 | d’acc            |     |     |     |     | okay            |     |
2 1 ouialafinentoutonaurachacun14euros yesattheendwewillhaveboth14euros
| 2 2 | ok  |     |     |     |     | ok  |     |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 2 1 | ok  |     |     |     |     | ok  |     |
3
| 4 1 | cettefoiscitape26.0    |     |     |     |     | thistimeput26in        |     |
| --- | ---------------------- | --- | --- | --- | --- | ---------------------- | --- |
| 4 1 | onaurachacunencoreplus |     |     |     |     | wewillbothhaveevenmore |     |
4 2 sionmettoutlesdeux26ongagneplus ifweputboth26wewillwinmore
| 4 1 | onvapassede41.27a`41.97      |     |     |     |     | wearegoingtogofrom41.27to41.97 |     |
| --- | ---------------------------- | --- | --- | --- | --- | ------------------------------ | --- |
| 4 2 | ahbinvoila`onavulamˆemechose |     |     |     |     | ahyeswesawthesamething         |     |
| 4 1 | ouiok                        |     |     |     |     | yesok                          |     |
5-8
| 9 1 | ctroooooooooooplongla...    |     |     |     |     | it’stoolong...          |     |
| --- | --------------------------- | --- | --- | --- | --- | ----------------------- | --- |
| 9 2 | ouais¸cam’asoul´e!!         |     |     |     |     | yesitannoysme           |     |
| 9 2 | mdr                         |     |     |     |     | lol                     |     |
| 9 1 | ennuie.......               |     |     |     |     | bored                   |     |
| 9 1 | lol                         |     |     |     |     | lol                     |     |
| 9 2 | onestseulementautiersenplus |     |     |     |     | andweareonlyatone-third |     |
10 1 jaipaseuletempsdelirecequetuaecrittouta Ididn’thavetimetoreadwhatyouwroteearlier
l’heur?
10 2 qenplusonafaitseulementuntiersq andevenmorethatwehaveonlydoneone-third
| 11 1 | ouiseulement1/3... |     |     |     |     | yesonly1/3 |     |
| ---- | ------------------ | --- | --- | --- | --- | ---------- | --- |
11 1 pourladernierepartietrahispastonamievirtuel for the last game where you have been betrayed
|      | dujourmdr        |     |     |     |     | byyourvirtualfriendlol |     |
| ---- | ---------------- | --- | --- | --- | --- | ---------------------- | --- |
| 11 2 | mdr              |     |     |     |     | lol                    |     |
| 11 2 | pareilpourtoi... |     |     |     |     | sameforyou...          |     |
12 1 nonpour20centimesenplussasefaitpasjepref- nofor20centsthat’sjustwrongIpreferthat
ereque
| 12 1 | l’ongagnetoutlesdeux40centimes |     |     |     |     | webothwin40cents |     |
| ---- | ------------------------------ | --- | --- | --- | --- | ---------------- | --- |
| 13 2 | ouais¸casert`arien             |     |     |     |     | yesit’snouse     |     |
| 13 1 | oelol                          |     |     |     |     | yeslol           |     |
13 2 etenplus¸cafaitperdredessous`al’autre andevenyoucan’tmaketheotherloosemoney
| 13 1 | ouieneffet |     |     |     |     | yesexactly |     |
| ---- | ---------- | --- | --- | --- | --- | ---------- | --- |
14
| 15 2 | −−    |          |        |         |        |            |                 |
| ---- | ----- | -------- | ------ | ------- | ------ | ---------- | --------------- |
|      | Table | 20. Chat | record | of Pair | 595 in | time order | within periods. |
49

| Period Player | Message |     |     | English | translation |
| ------------- | ------- | --- | --- | ------- | ----------- |
16-20
21 2 J’ai l’impression que ¸ca fait 3 heures qu’on est Ifeellikeithasbeen3hourssincewestartedthis
dessus
22-24
| 25 1 | plusque6parties!         |     |     | only6sessionsleft! |     |
| ---- | ------------------------ | --- | --- | ------------------ | --- |
| 25 2 | enfin!                   |     |     | finally!           |     |
| 25 2 | jem’endors               |     |     | I’mfallingasleep   |     |
| 25 1 | continueadormirealorsmdr |     |     | keepsleepingthen   |     |
| 25 2 | mdr                      |     |     | lol                |     |
26 1 c’est domage que l’experience est aussi longue it’s unfortunate that this experiment is that long
|      | sinonelleesttresinterressante |     |     | butapartfromthatit’sinteresting |     |
| ---- | ----------------------------- | --- | --- | ------------------------------- | --- |
| 26 2 | ouaisc’estvrai                |     |     | yestrue                         |     |
| 26 2 | c’esttapremi`ere?             |     |     | Isityourfirstone?               |     |
| 26 1 | nondutout                     |     |     | notatall                        |     |
27 2 ¸catefaitcombiendefoisalors? Howmanytimeshaveyoudoneitthen?
| 28 1 | 6/7foisjecroisettoi? |     |     | 6/7timesIthinkandyou? |     |
| ---- | -------------------- | --- | --- | --------------------- | --- |
| 28 2 | ahouaisquandmˆeme    |     |     | ohwow                 |     |
| 28 2 | moic’estmapremi`ere  |     |     | meit’smyfirsttime     |     |
28 1 tut’ensortbienpourunnouveaulol youdoitwellforanewarrival
28 2 eta`chaquefoistufaiscettestrat´egie? andyoudothisstrategyeverytime?
| 29 2 | Jetefaisconfiancehein... |     |     | Itrustyouok... |     |
| ---- | ------------------------ | --- | --- | -------------- | --- |
29 1 ouij’adoptetoujourslastrategiedeqjefais50/50 YesIalwaysusethestrategywhenIdo50/50with
avec
| 29 1 | l’autreqjetrouvequeclameilleur |     |     | theotherIthinkisthebest |     |
| ---- | ------------------------------ | --- | --- | ----------------------- | --- |
29 1 aprestpastoujoursavecdgensdesfoiscavecl’ordi you are not always with other people sometimes
youarewithcomputers
| 29 2 | ouaisc’estsuˆr |     |     | yesit’strue   |     |
| ---- | -------------- | --- | --- | ------------- | --- |
| 29 1 | ouitkt         |     |     | yesdon’tworry |     |
| 29 2 | ahbon?         |     |     | isthatso?     |     |
30 1 saaetaitunplaisirdejoueravectoimdrr itwasapleasuretoplaywithyoulol
| 30 2 | mdr                   |                 |         | lol                    |                 |
| ---- | --------------------- | --------------- | ------- | ---------------------- | --------------- |
| 30 2 | Unplaisirpourmoiaussi |                 |         | itwasapleasureformetoo |                 |
| 30 1 | bonnecontinuation     |                 |         | goodluck               |                 |
| 30 2 | toiaussi;-)           |                 |         | youtoo                 |                 |
| 30 1 | enrevoirlol           |                 |         | goodbyelol             |                 |
|      | Table                 | 21. Chat record | of Pair | 595 in time order      | within periods. |
50