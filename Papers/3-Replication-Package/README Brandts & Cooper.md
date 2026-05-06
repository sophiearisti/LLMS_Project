Data	Availability	and	Provenance	Statements

INSTRUCTIONS:	Every	README	should	contain	a	description	of	the	origin
(provenance),	location	and	accessibility	(data	availability)	of	the	data	used	in	the
article.	These	descriptions	are	generally	referred	to	as	“Data	Availability
Statements”	(DAS).	However,	in	some	cases,	there	is	no	external	data	used.

•  ☐	This	paper	does	not	involve	analysis	of	external	data	(i.e.,	no	data	are	used	or	the

only	data	are	generated	by	the	authors	via	simulation	in	their	code).

Sessions	 were	 run	 using	 z-tree	 (Fischbacher,	 2007).	 Each	 session	 began	 with
instructions	 Participants	 had	 printed	 copies	 of	 the	 payoff	 tables	 for	 all	 five	 games.
Sessions	were	run	at	the	LINEEX	lab	at	the	University	of	Valencia,	with	undergraduate
students	recruited	from	the	university	as	participants.	The	payoffs	were	denominated
in	 Experimental	 Currency	 Units,	 with	 1	 ECU	 =	 0.2€.	 Participants	 received	 their
cumulative	earnings	for	all	rounds.	Including	a	5€	show-up	fee,	average	pay	was	19.90€.
Sessions	lasted	approximately	an	hour.

Instructions	for	each	treatment	are	contained	in	the	folder	labelled	“Instructions.”	The
z-tree	software	used	for	each	treatment	is	in	the	folder	labelled	“Z-Tree	Programs.”	See
the	 ReadMe	 file	 in	 this	 folder	 for	 details	 about	 which	 program	 was	 used	 for	 each
treatment.

Statement	about	Rights
•  ⊠	I	certify	that	the	author(s)	of	the	manuscript	have	legitimate	access	to	and

permission	to	use	the	data	used	in	this	manuscript.

•  ⊠	I	certify	that	the	author(s)	of	the	manuscript	have	documented	permission	to

redistribute/publish	the	data	contained	within	this	replication	package.	Appropriate
permission	are	documented	in	the	LICENSE.txt	file.

All	data	was	gathered	at	the	LINEEX	lab	at	the	University	of	Valencia	and	is	owned	by
the	authors.	As	per	IRB	regulations,	the	data	being	shared	is	deidentified.

Summary	of	Availability
•  ⊠		All	data	are	publicly	available.

•  ☐	Some	data	cannot	be	made	publicly	available.

•  ☐	No	data	can	be	made	publicly	available.

•  ☐	Confidential	data	used	in	this	paper	and	not	provided	as	part	of	the	public

replication	package	will	be	preserved	for	___	years	after	publication,	in	accordance
with	journal	policies.

Details	on	each	Data	Source

All	data	used	in	this	paper	comes	from	experiments	conducted	at	the	LINEEX	lab	at	the
University	of	Valencia.	Individuals	using	this	data	should	cite	the	EJ	paper	in	which	the

experimental	results	were	presented:	Brandts,	Jordi	and	David	J.	Cooper	(2025),
“Managerial	Leadership,	Truth-Telling,	and	Efficient	Coordination”,	forthcoming	The
Economic	Journal.

Dataset	list
Data	file
BC	Master	Data,	Main
Experiment.dta
BC	Coding	Data,	Main
Experiment.dta
BC	Master	Data,	Follow	Up
Experiment.dta

Source	 Notes
LINEEX	 Raw	data	for	all	treatments	except	EC

Provided
Yes

-	MC
Coding	results	for	chat	treatment
(CH/S	–	D,	CH/A	–	D,	and	CH	–	MC)
Data	for	EC	–	MC	and	Section	5

Yes

Yes

Computational	requirements

Software	Requirements
•  ☐	The	replication	package	contains	one	or	more	programs	to	install	all	dependencies

and	set	up	the	necessary	directory	structure.

•

All	of	the	do	files	were	run	using	Stata	18.5.

Controlled	Randomness
•  ☐	Random	seed	is	set	at	line	_____	of	program	______

•  ⊠		No	Pseudo	random	generator	is	used	in	the	analysis	described	here.

Memory,	Runtime,	Storage	Requirements

INSTRUCTIONS:	Memory	and	compute-time	requirements	may	also	be	relevant
or	even	critical.	Some	example	text	follows.	It	may	be	useful	to	break	this	out	by
Table/Figure/section	of	processing.	For	instance,	some	estimation	routines	might
run	for	weeks,	but	data	prep	and	creating	figures	might	only	take	a	few	minutes.
You	should	also	describe	how	much	storage	is	required	in	addition	to	the	space
visible	in	the	typical	repository,	for	instance,	because	data	will	be	unzipped,	data
downloaded,	or	temporary	files	written.

Summary

Approximate	time	needed	to	reproduce	the	analyses	on	a	standard	2025	desktop	machine:

•  ⊠	<10	minutes

•  ☐	10-60	minutes

•  ☐	1-2	hours

•  ☐	2-8	hours

•  ☐	8-24	hours

•  ☐	1-3	days

•  ☐	3-14	days

•  ☐	>	14	days

Approximate	storage	space	needed:

•  ⊠	<	25	MBytes

•  ☐	25	MB	-	250	MB

•  ☐	250	MB	-	2	GB

•  ☐	2	GB	-	25	GB

•  ☐	25	GB	-	250	GB

•  ☐	>	250	GB

•  ☐	Not	feasible	to	run	on	a	desktop	machine,	as	described	below.

Details

•

The	do	file	was	run	on	a	MacBook	Pro	with	a	2.3	GHz	Quad-Core	Intel	Core	I7.	The
memory	was	32	GB	2733	MHz	LPDDR4X.	MacOS	was	Sonoma	14.7.1.

Description	of	programs/code

There	is	a	single	Stata	do	file,	“Brandts	and	Cooper,	EJ	2025,	replication	package,	full	do
file,”	which	creates	all	of	the	variables	(beyond	the	raw	data)	used	in	the	analysis	and
generates	all	of	the	numbers	reported	in	the	paper.	The	do	file	is	broken	into	three	sections.
The	first	section	loads	the	raw	choice	data	from	the	main	treatments	and	creates	the
relevant	variables.	It	then	produces	the	analysis	for	Sections	4.1	and	4.2.a	as	well	as	a	small
number	of	figures	used	elsewhere	in	the	paper.	The	next	section	loads	all	of	the	coding
data,	creates	relevant	variables,	and	produces	the	analysis	for	Section	4.2.b	as	well	as	a
small	amount	of	analysis	used	elsewhere	in	the	paper.	The	final	section	of	the	do	file	loads
the	raw	data	for	the	follow-up	treatment	(EC	–	MC)	and	produces	the	analysis	for	Section	5.

User	of	the	do	file	should	note	that	the	default	directory	is	set	at	the	beginning	of	the	do	file.
This	will	need	to	be	changed	to	reflect	the	location	of	the	date	files.

Also	note	that	outreg2	will	open	a	date	editor	and	stop	the	do	file	each	time	it	is	run.	We
have	commented	out	these	commands,	but	if	you	want	to	see	the	tables	produced	by
outreg2	you	will	need	to	remove	the	comments.	If	you	run	outreg2,	you	will	need	to	shut
the	data	editor	and	hit	enter	to	continue	the	do	file.

Instructions	to	Replicators

All	of	the	numbers	in	the	paper	are	generated	using	the	Stata	do	file	“Brandts	and	Cooper,
EJ	2025,	replication	package,	full	do	file”.	Before	running	the	program,	you	will	need	to	put
the	three	data	files	“BC	Master	Data,	Main	Experiment.dta”,	“BC	Coding	Data,	Main
Experiment.dta”,	and	“BC	Master	Data,	Follow	Up	Experiment.dta”	into	a	directory.	All	of
the	variables	in	the	data	files	have	been	labeled	with	descriptions	of	the	variable;	this
information	is	replicated	below.	Be	certain	that	you	set	the	default	directory	in	the	second
line	of	the	do	file.	Note	that	outreg2	will	open	a	date	editor	and	stop	the	do	file	each	time	it
is	run.	We	have	commented	out	these	commands,	but	if	you	want	to	see	the	tables
produced	by	outreg2	you	will	need	to	remove	the	comments.	If	you	run	outreg2,	you	will
need	to	shut	the	data	editor	and	hit	enter	to	continue	the	do	file.

Running	the	do	file	will	generate	all	of	the	numbers	used	in	the	paper,	including	the
appendices.	The	do	file	will	also	generate	all	of	the	necessary	variables	beyond	those
already	in	the	raw	data	files.	There	are	extensive	comments	in	the	do-file	letting	you	know
what	numbers	are	being	generated	by	any	particular	section	of	the	do	file.

Variable	List,	BC	Master	Data,	Main	Experiment

Variable	Name
true_treatment_ordered
session
part_decent
part_cent
str_decent
str_cent
hsl_decent
hsl_cent
hcomm
advice
chat_decent
chat_cent
chat_advice
game
period
group
original_subject
type
message
message1
message2
strategy1
strategy2

Description
treatments,	same	order	as	paper
session	id
ND	-	D
SC	-	MC
STR	-	D
STR	-	MC
HSL	-	D
HSL	-	MC
SC/S	-	D
SC/A	-	D
CH/S	-	D
CH/A	-	D
CH	-	MC
game	being	played
round
three	person	group	within	session
subject	within	session
0	=	Central	Manager,	1	=	Branch	1,	2	=	Branch
player's	own	message
message	sent	by	Branch	1,	centralized
message	sent	by	Branch	2,	centralized
action	for	Agent	1
action	for	Agent	2

payoff_b1
payoff_b2
payoff_manager
b1chat_row_r1
b1chat_row_r2
b1chat_row_r3
b1chat_col_r1
b1chat_col_r2
b1chat_col_r3
b2chat_row_r1
b2chat_row_r2
b2chat_row_r3
b2chat_col_r1
b2chat_col_r2
b2chat_col_r3
man_suggest_row_g1
man_suggest_row_g2
man_suggest_row_g3
man_suggest_row_g4
man_suggest_row_g5
man_suggest_col_g1
man_suggest_col_g2
man_suggest_col_g3
man_suggest_col_g4
man_suggest_col_g5

payoff	for	Agent	1
payoff	for	Agent	2
manager's	payoff,	also	total	surplus
comm	between	branches,	chat	round	1,	branch	1
comm	between	branches,	chat	round	2,	branch	1
comm	between	branches,	chat	round	3,	branch	1
comm	between	branches,	chat	round	1,	branch	1
comm	between	branches,	chat	round	2,	branch	1
comm	between	branches,	chat	round	3,	branch	1
comm	between	branches,	chat	round	1,	branch	2
comm	between	branches,	chat	round	2,	branch	2
comm	between	branches,	chat	round	3,	branch	2
comm	between	branches,	chat	round	1,	branch	2
comm	between	branches,	chat	round	2,	branch	2
comm	between	branches,	chat	round	3,	branch	2
advice,	suggested	row,	g1
advice,	suggested	row,	g2
advice,	suggested	row,	g3
advice,	suggested	row,	g4
advice,	suggested	row,	g5
advice,	suggested	col,	g1
advice,	suggested	col,	g2
advice,	suggested	col,	g3
advice,	suggested	col,	g4
advice,	suggested	col,	g5

Variable	List,	BC	Coding	Data,	Main	Experiment

Variable	Name
session
true_treatment_ordered
group
global_group
period
chat_decent
chat_advice
chat_cent
game
strategy1
strategy2
coordinate

Description
session	id
treatments,	same	order	as	paper
three	person	group	within	session
global	id	number	for	groups
round
CH/S	-	D
CH	-	MC
CH/A	-	D
game	being	played
action	for	Agent	1
action	for	Agent	2
agents	coordinate

coordinate_safe
coordinate_efficient
coordinate_other
payoff_b1
payoff_b2
payoff_manager
any_suggestion
suggest_safe
suggest_efficient
last_suggest_efficient
agree_proposal
discuss_coordinate
discuss_fairness
discuss_efficient
discuss_rules
discuss_howtoplay
explanation
ask_game
receive_report
truthful
falsehood
contradict
disagreement
neither_report
truth_a1
truth_a2
false_a1
false_a2
nummess_man
nummess_agent
man_suggest_safe
man_suggest_efficient
man_agree_proposal
man_discuss_coordinate
man_discuss_fairness
man_discuss_efficient

man_discuss_rules

man_discuss_howtoplay
man_explanation

coordinate	at	safe	equilibrium
coordinate	at	efficient	equilibrium
coordinate	at	other	equilibrium
payoff	for	Agent	1
payoff	for	Agent	2
manager's	payoff,	also	total	surplus
Any	Suggestion
Suggest	Safe	Outcome
Suggest	Efficient	Outcome
Final	suggestion	was	efficient
Agreement	to	Suggestion
Discuss	Need	to	Coordinate
Discuss	Fairness
Discuss	Efficiency
Questions	About	Rules	of	the	Experiment
Questions	About	How	to	Play
Explanation
Ask	What	Game	Is	Being	Played	(M)
report	about	game	being	played
truthfully	reveal	game
lie	about	game
Contradict	(One	tells	truth,	other	lies)
Explicit	disagreement	about	game
neither	agent	reported
Agent	1,	truthful
Agent	2,	truthful
Agent	1,	lied
Agent	2	,lied
#	messages,	manager
#	messages,	agents
Manager,	Suggest	Safe	Outcome
Manager,	Suggest	Efficient	Outcome
Manager,	Agreement	to	Suggestion
Manager,	Discuss	Need	to	Coordinate
Manager,	Discuss	Fairness
Manager,	Discuss	Efficiency
Manager,	Questions	About	Rules	of	the
Experiment
Manager,	Questions	About	How	to	Play
Manager,	Explanation

man_ask_game

Manager,	Ask	What	Game	Is	Being	Played	(M)

Variable	List,	BC	Master	Data,	Follow	Up	Experiment

Variable	Name

obn

time
session
period
late
message
subject
group
subjectid
type
messagecode
game
strategy1
strategy2
payoff_1
payoff_2
payoff_manager
surplus_babbling

Description
Observation	Number	(-999	if	no
message)
time	elapsed
Session
Period
Periods	10	-	18
message	text
Subject
Group
unique	subject	id
Type
numeric	code	for	message	types
Game
Agent	1	action
Agent	2	action
Agent	1	payoff
Agent	2	payoff
Manager	payoff
surplus	from	babbling	equilibrium

List	of	tables	and	programs

The	provided	code	reproduces:

•  ⊠	All	numbers	provided	in	text	in	the	paper

•  ⊠All	tables	and	figures	in	the	paper

Note:	To	be	precise,	it	generates	the	numbers	used	to	generate	the	tables	and	figures.	These
were	then	copied	into	MS	Word	or	MS	Excel	to	create	the	tables	and	figures.

•  ☐	Selected	tables	and	figures	in	the	paper,	as	explained	and	justified	below.

References

Acknowledgements

Some	content	on	this	page	was	copied	from	Hindawi.	Other	content	was	adapted	from	Fort
(2016),	Supplementary	data,	with	the	author’s	permission.

