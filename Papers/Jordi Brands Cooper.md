The Economic Journal , 135 ( August ), 1942–1979 https://doi.org/10.1093/ej/ueaf019 © The Author(s) 2025. Published by Oxford University Press on behalf of
Royal Economic Society. This is an Open Access article distributed under the terms of the Creative Commons Attribution License ( https://creativecommons.org/
licenses/ by/ 4.0/ ), which permits unrestricted reuse, distribution, and reproduction in any medium, provided the original work is properly cited.
Advance Access Publication Date: 4 March 2025

M ANAGERIAL  LEADERSHIP,  TRUTH-TELLING  A N D

∗
EFFICIENT  COORDINATION

Jordi Brandts and David J. Cooper

We study the manager-agent game, a no v el coordination game played between a manager and two agents.
Unlike commonly studied coordination games, the manager-agent game stresses asymmetric information
(agents know the state of the world, but managers do not) and asymmetric payoffs (for all states of the
world, agents have opposing preferences o v er outcomes). Efﬁcient coordination requires coordinating agents’
actions and utilising their pri v ate information. We v ary ho w agents’ actions are chosen (managerial control
v ersus dele gation), the mode of communication (none, structured communication or free-form chat) and the
channels of communication (i.e., who can communicate with each other). Achieving coordination per se is
not challenging, but, averaging across all states of the world, total surplus only surpasses the safe outcome
when managerial control is combined with three-way free-form chat. Unlike weak-link games, advice from
managers to agents does not increase total surplus. The combination of managerial control and free-form chat
works because, under these conditions, agents rarely lie about their pri v ate information. Our results suggest
that common ﬁndings from the experimental literature on lying are not robust to changes in the mode of
communication.

There exists a large experimental literature studying whether managers can use communication to
coordinate agents’ actions on an efﬁcient outcome. This literature focuses on cases like the weak-
link game where agents share common and known objectives with each other and the manager.
In settings with aligned interests, efﬁcient symmetric outcomes and symmetric information, it
is well established that (i) communication among agents and (ii) advice from the manager to
agents both increase the probability of efﬁcient coordination. Allowing managers to directly
control agents’ actions makes efﬁcient coordination trivial in such settings. The manager’s task
is far more difﬁcult when the underlying problem is asymmetric. Speciﬁcally, we are interested
in settings that have the following properties. (i) All parties would be better off if the agents
coordinate on a common course of action. (ii) Although all parties gain from coordination, they
have differing preferences over which a common course of action should be chosen. (iii) The state
of the world varies o v er time, changing which outcome is efﬁcient in the sense of maximising
total surplus. (iv) Agents know the state of the world, but the manager does not. The combination
of properties (ii) and (iv) implies that agents have an incentive to lie to their manager. Ideally, a

∗ Corresponding author: David J. Cooper, University of Iowa, USA . Email: david-j-cooper@uiowa.edu

This paper was received on 7 October 2022 and accepted on 27 February 2025. The Editor was Amanda Friedenberg.

The data and codes for this paper are available on the Journal repository. They were checked for their ability to
reproduce the results presented in the paper. The replication package for this paper is available at the following address:
https:// doi.org/ 10.5281/ zenodo.14933575 .

The authors thank the National Science Foundation (SES-0214310), the Spanish Ministry of Economy and Innovation
(Grant: ECO2020-114251GB-I00), the Severo Ochoa Program for Centers of Excellence in R&D (CEX2019-000915-S)
and the Generalitat de Catalunya (Grant: 2017 SGR 1136). We thank Zeina Aboushaar, Caleb Bray, Adri `a Bronchal, Joe
Ballard, Ellis Magee, Luke Ortolani and Lavinia Piemontese for valuable help as research assistants, and seminar
participants at Alaska – Anchorage, Case Western Reserve, Copenhagen Business School, Durham, East Anglia,
Edinburgh, Florida State, Indiana, Lausanne, Maryland, Paderborn, Paris School of Economics, Stavanger, UCSB,
Virginia, the Arne Ryde Workshop, the London Experimental Workshop and the NBER Organizational Economics
Working Group for useful feedback. Finally, we also thank the editor, Amanda Friedenberg, and the anonymous re vie w-
ers for their help.

[ 1942 ]

l

D
o
w
n
o
a
d
e
d

f
r
o
m
h

t
t

p
s
:
/
/

i

a
c
a
d
e
m
c
.
o
u
p
.
c
o
m
e

/

j
/

l

/

/

/

a
r
t
i
c
e
1
3
5
6
7
0
1
9
4
2
8
0
5
1
9
9
8
b
y
P
o
n

/

i

i

i

t
i
f
i
c
a
U
n
v
e
r
s
d
a
d
J
a
v
e
r
i
a
n
a
u
s
e
r
o
n
1
9
N
o
v
e
m
b
e
r
2
0
2
5

2025]

managerial leadership

1943

manager achie ves ef ﬁcient coordination, inducing her agents to coordinate on a common course
of action and doing so in a way that uses their pri v ate information to reach the efﬁcient outcome.
Achieving this is non-trivial, given the agents’ opposing objectives and the manager’s lack of
critical information.

Many problems like this arise within organisations. Managers and their agents must make
choices about what inputs to use, what people to hire, what products to produce and what
strategies to pursue. Gains from coordination are possible when these decisions are made. For
example, costs are lower if employees all use the same equipment or software, there are beneﬁcial
synergies if middle managers hire w ork ers with complementary skills and there are economies
of scale if a ﬁrm’s stores all sell the same products. But agents often have differing preferences
o v er the available options that are independent from what is good for the organisation as a whole.
Work ers lik e to use equipment and software they are already familiar with, middle managers prefer
to hire people for the group they manage (e.g., the people in charge of product design al w ays
want more people for the product design group even if the ﬁrm needs more help in marketing)
and store managers want product types that conform to tastes in their speciﬁc location. It is
natural that agents who are ‘in the ﬁeld’ will be better informed than their manager. Workers
who actually use a piece of software are better informed about its merits than their boss. Store
managers who interact with customers know more about the latest trends in consumer demand
than an upper-level manager sitting in a glass tower. The problem is that these agents may have
strong incentives to not truthfully report their information in an attempt to inﬂuence their manager
into enforcing the agent’s preferred option. 1

Can coordination on an efﬁcient outcome be achieved in the face of these difﬁculties? If the
manager imposes a decision on her agents (‘managerial control’), can she get her agents to
truthfully reveal their information against their interests? If so, does the manager’s ability to
elicit truthful information depend on what type of communication is possible? More broadly,
what is the mechanism behind getting agents to tell the truth? Is it better to delegate decision-
making to agents (‘delegation’), giving up control in exchange for eliminating the need to extract
information? Can the manager still play a useful leadership role while delegating authority by
suggesting a course of action to her agents (‘managerial advice’)? The purpose of this paper is
to address these questions.

We examine these issues using a no v el coordination game, the manager-agent game (‘MA
game’). This is a three-player game with one player in the role of manager and two acting as
her agents. The four properties listed abo v e are all present: coordinating on a common action
that beneﬁts all agents, agents have divergent preferences over possible outcomes, managers
lack  the  necessary  information  to  simply  impose  efﬁcient  coordination  on  their  agents  and
agents possess the rele v ant information, but have little reason to truthfully reveal it. The MA
game confronts subjects with a challenging coordination problem that accentuates the contrast
between managerial control and delegation.

1 A real-world example is the adoption of standards for new technologies such as HDTV and wireless communication
in the 1990s. Europe used a more centralised process than the United States. This was especially true for wireless
communication, where the United States largely delegated the problem of choosing a standard to ﬁrms. This made some
sense, as ﬁrms are better informed about the merits of various technologies than a central regulator, but also created a
thorny coordination problem. Both network externalities and IP issues gave ﬁrms reasons to prefer differing technologies.
Indeed, the US market suffered through an extended period where ﬁrms failed to coordinate on a single technology and
was widely seen as lagging behind Europe (for HDTV, see Farrell and Shapiro, 1992 ; for wireless communication, see
Gandal et al. , 2003 ). Other related examples from the ﬁeld include software adoption (Brynjolfsson and Kemerer, 1996 )
and product line selection (Thomas, 2011 ).

© The Author(s) 2025.

l

D
o
w
n
o
a
d
e
d

f
r
o
m
h

t
t

p
s
:
/
/

i

a
c
a
d
e
m
c
.
o
u
p
.
c
o
m
e

/

j
/

l

/

/

/

a
r
t
i
c
e
1
3
5
6
7
0
1
9
4
2
8
0
5
1
9
9
8
b
y
P
o
n

/

i

i

i

t
i
f
i
c
a
U
n
v
e
r
s
d
a
d
J
a
v
e
r
i
a
n
a
u
s
e
r
o
n
1
9
N
o
v
e
m
b
e
r
2
0
2
5

1944

the economic journal

[ august

The experimental design features repeated play of the MA game in ﬁxed groups. We vary
how actions are chosen (dele gation v ersus managerial control) and what type of communication
is available (none, structured communication with pre-speciﬁed messages or free-form chat).
The baseline treatment features delegation and no communication; this is expected to yield
poor performance since there is no mechanism to address the challenging coordination problem
faced by agents. Within each type of communication (structured communication or free-form
chat) we consider three possible mechanisms for choosing actions: delegation with pre-play
communication between agents, delegation with managerial advice and managerial control with
messages from agents to the manager.

Under managerial control, the MA game has a unique pure-strategy equilibrium in which the
manager receives no information from the agents. Lacking information, the manager requires
agents to coordinate on a ‘safe outcome’ (safe in the sense that agents’ actions correspond to the
secure equilibrium under delegation with agents al w ays using their maximin actions). Beyond
being safe, the safe outcome also has the attractive properties of being simple (the same actions
are used in all states of the world) and equalising agents’ payoffs on a round-by-round basis. The
safe outcome is not efﬁcient in terms of maximising total surplus because efﬁcient coordination
requires using the agents’ information. The safe outcome therefore serves as a benchmark for
what successful coordination can achieve without using a g ents’ information . With this in mind,
our analysis focuses on outperforming the safe outcome.

Turning to the data, total surplus is al w ays higher with managerial control than with delegation.
With no communication or structured communication, delegation invariably leads to coordina-
tion failure and lower total surplus than the safe outcome. Managerial control with structured
communication solves the coordination problem, improving matters o v er dele gation, but rarely
achieves efﬁcient coordination due to poor information transmission from agents to managers. As
a result, total surplus is indistinguishable from the safe outcome. With free-form chat, delegation
with no managerial role also solves the coordination problem. There is no issue of information
transmission, but agents opt for the safe outcome more often than efﬁcient coordination. The safe
outcome offers an easy way to coordinate and agents take advantage of this. Once again, total
surplus is no better than in the safe outcome. Managerial advice helps little, as an increase in
efﬁcient coordination is offset by an increase in coordination failure. Only with the combination
of managerial control and free-form chat is the total surplus signiﬁcantly greater than the safe
outcome, achieving roughly half of the possible efﬁciency gains. Managerial control, combined
with free-form chat, solves the coordination problem and makes good use of agents’ information.
Why does the combination of free-form chat and managerial control outperform the safe
outcome when the theory predicts that agents should transmit no information to managers?
Contrary to both the theory and the data with structured communication and managerial control,
lying by agents is almost non-existent when free-form chat and managerial control are combined.
This yields unambiguous transmission of information, making efﬁcient coordination possible.

The preceding observation raises an important question: why is there so little lying with
free-form chat? To address this question, we add a follow-up treatment that uses structured
communication, but includes a number of features that mimic important aspects of free-form
chat. Enriching structured communication has no effect on performance and less than half the
effect of free-form chat on the frequency of lying. These observations strongly suggest that
free-form communication is necessary per se for the sharp decrease in lying observed with the
combination of managerial control and free-form chat.

© The Author(s) 2025.

l

D
o
w
n
o
a
d
e
d

f
r
o
m
h

t
t

p
s
:
/
/

i

a
c
a
d
e
m
c
.
o
u
p
.
c
o
m
e

/

j
/

l

/

/

/

a
r
t
i
c
e
1
3
5
6
7
0
1
9
4
2
8
0
5
1
9
9
8
b
y
P
o
n

/

i

i

i

t
i
f
i
c
a
U
n
v
e
r
s
d
a
d
J
a
v
e
r
i
a
n
a
u
s
e
r
o
n
1
9
N
o
v
e
m
b
e
r
2
0
2
5

2025]

managerial leadership

1945

Our work contributes to existing research in multiple ways. There is a large experimental
literature about the effects of communication, advice and leadership on efﬁcient coordination.
(See Section 1 for a full summary of related research.) This research focuses on settings like the
weak-link game where the interests of all individuals are aligned and there is no dispute about
the most desirable outcome. Communication from a leader, such as advice from the manager to
agents, is ef fecti ve in these settings, but it is relatively easy for the manager to act as a coordination
device when everyone has the same information and aligned interests. Achieving efﬁciency via
managerial control is trivial in a weak-link game, presumably explaining why this has not been
studied. 2 Like a weak-link game (and unlike a battle-of-the-se x es g ame), the MA g ame has an
inefﬁcient symmetric equilibrium that makes it easy to coordinate. The challenge facing a leader
is not to achieve coordination per se , but rather to achieve efﬁcient coordination. Compared to
weak-link games, efﬁcient coordination is difﬁcult in the MA game. Managers need to do more
than just o v ercome strate gic risk. The y must either induce turn-taking through managerial advice
or impose turn-taking via managerial control. Achieving efﬁcient coordination via managerial
control is non-trivial in the MA game due to asymmetric information; the manager has to acquire
information that their agents have no incentive to provide. Managerial advice pro v es insufﬁcient
to outperform the safe outcome, unlike weak-link games, but the combination of managerial
control and free-form chat performs surprisingly well.

Our work also relates to research, both theoretical and experimental, comparing centralisation
and decentralisation. The recent literature sees this trade-off in terms of a comparison between the
beneﬁts of coordination (meant in a some what dif ferent sense than here) and the costs of distorted
information that accompany centralisation. These trade-offs play an important role in our work
as well, but there are major differences. Unlike the games studied in papers like Alonso et al.
( 2008a ) and Rantakari ( 2008 ), the MA game with delegation is a true coordination game where
the critical issue is selecting among multiple equilibria. We stress the role of active leaders using
free-form communication to achieve efﬁcient coordination. The effects of free-form communi-
cation are particularly rele v ant for the literature comparing centralisation and decentralisation.
Performance with managerial control and free-form chat surpasses the safe outcome because
agents reveal more information than is consistent with their ﬁnancial incentives. Even though the
games are signiﬁcantly different, the same insight presumably applies to comparisons of central-
isation and decentralisation—existing theories may systematically underestimate the beneﬁts of
centralisation due to o v erestimating the willingness of agents using free-form communication to
distort reports about their information for strategic purposes.

Our work contributes to the large and growing literature on whether and when individuals are
willing to lie. The typical ﬁnding is that individuals lie less than is payoff maximising, adjust
the frequency of lies in response to changing incentives (including both their own and other’s
payoffs) and frequently use partial lies (neither telling the truth nor lying to the full extent that
would maximise proﬁts). When agents are limited to sending a bare message about the state
of the world, our data exhibit all of these standard patterns. It is striking that none of these
patterns are present in the treatment with managerial control and free-form chat. Agents almost
never lie, the frequency of lying does not respond to incentives and partial lies are rare. The
follow-up treatment eliminates many possible reasons for the sharp reduction in lying, such as

2 There is little work on leadership in asymmetric games. The most rele v ant is the one-way communication treatment
in the study by Cooper et al. ( 1989 ) of communication in the battle of the se x es, but this is equi v alent to communication
between agents rather than managerial advice. See Section 1 for a detailed discussion. Managerial control is trivial in the
battle of the se x es due to the lack of asymmetric information.

© The Author(s) 2025.

l

D
o
w
n
o
a
d
e
d

f
r
o
m
h

t
t

p
s
:
/
/

i

a
c
a
d
e
m
c
.
o
u
p
.
c
o
m
e

/

j
/

l

/

/

/

a
r
t
i
c
e
1
3
5
6
7
0
1
9
4
2
8
0
5
1
9
9
8
b
y
P
o
n

/

i

i

i

t
i
f
i
c
a
U
n
v
e
r
s
d
a
d
J
a
v
e
r
i
a
n
a
u
s
e
r
o
n
1
9
N
o
v
e
m
b
e
r
2
0
2
5

1946

the economic journal

[ august

agents fact-checking each other (i.e., calling out when the other agent lies), managers requesting
truthful messages and asynchronous communication. The relatively high frequency of lies in
the follow-up treatment suggests that some effect of free-form communication per se causes the
reduction in lying. We speculate in the conclusion on what this effect might be, but it remains an
open question why free-form communication has such a strong effect on lying.

Finally, the unwillingness of agents to lie plays a critical role in generating efﬁcient coor-
dination with managerial control and free-form chat. Previous work has found that pre-play
communications in the form of free-form chat is more ef fecti ve than restricted communication at
fostering efﬁciency and cooperation (Brandts et al. , 2019 ), but our work identiﬁes a new channel
by which this occurs.

1.  Related Literature

There are a number of experiments showing that leaders can increase the likelihood of efﬁcient
coordination either by leading by example (e.g., Weber et al. , 2004 ; Cartwright et al. , 2013 ;
Sahin et al. , 2015 ) or by sending messages (Weber et al. , 2001 ; Cooper, 2006 ; Brandts and
Cooper, 2007 ; Brandts et al. , 2015 ; Sahin et al. , 2015 ; Cooper et al. , 2020 ). 3 Unlike our work,
these papers study symmetric games, mainly weak-link games. In a weak-link game, there is no
dispute o v er what equilibrium should be chosen. The primary role of a leader involv es o v ercoming
strategic uncertainty. Choosing the efﬁcient equilibrium is risky, and leaders help by establishing
common beliefs that everyone will choose the efﬁcient outcome. With the exception of Cooper
et al. ( 2020 ), asymmetric information does not play an important role in the existing literature.
Asymmetric payoffs and the resulting disputes are at the heart of the problem managers face in
our experiment, and asymmetric information exacerbates the difﬁculty. 4

Closely related, sev eral e xperiments study the effect of advice on efﬁcient coordination. This
includes papers that study advice from either the experimenter (e.g., Van Huyck et al. , 1992 ;
Brandts and MacLeod, 1995 ; Chaudhuri and Paichayontjivit, 2010 ) or from another subject who
has previously played the game (Chaudhuri et al. , 2009 ). Advice can be ef fecti ve, particularly
if it is common knowledge and the interests of advisors and advisees are aligned. Once again,
these papers about advice focus on symmetric games where players have aligned interests. We
confront managers with the more challenging problem of resolving the conﬂicting interests of
their agents.

Many papers show that pre-play communication among players (as opposed to an external
leader) leads to greater efﬁciency in social dilemmas (e.g., Dawes et al. , 1977 ; Isaac and Walker,
1988 ; Ostrom et al. , 1992 ; Charness and Dufwenberg, 2006 ; Cason and Mui, 2007 ; Cooper and
K ¨uhn, 2014 ) and symmetric coordination games with Pareto-ranked equilibria (e.g., Cooper et
al. , 1992 ; Blume and Ortmann, 2007 ; Kriss et al. , 2016 ; Blume et al. , 2017 ). Especially rele v ant
for our work, Cooper et al. ( 1989 ) studied the effect of pre-play communication on coordination
in a battle-of-the-se x es game, the best-known e xample of an asymmetric coordination game.
Communication is limited to pre-play announcements of intended play. Without communication,

3 It has also been shown that leaders can increase contributions in public goods games, either leading by example or
by transmitting their superior information about the state of the world. See Cooper and Hamman ( 2021 ) for a surv e y of
this literature.

4 In Cooper et al. ( 2020 ), the leader is better informed than the followers, and the primary problem created by
asymmetric information is that the leader has an incentive to make the state of the world appear better than it is, but
risks losing her credibility in the long run. In our paper, the problem is that the leader does not know which equilibrium
maximises total surplus and the well-informed followers have strong incentives to deceive her.

© The Author(s) 2025.

l

D
o
w
n
o
a
d
e
d

f
r
o
m
h

t
t

p
s
:
/
/

i

a
c
a
d
e
m
c
.
o
u
p
.
c
o
m
e

/

j
/

l

/

/

/

a
r
t
i
c
e
1
3
5
6
7
0
1
9
4
2
8
0
5
1
9
9
8
b
y
P
o
n

/

i

i

i

t
i
f
i
c
a
U
n
v
e
r
s
d
a
d
J
a
v
e
r
i
a
n
a
u
s
e
r
o
n
1
9
N
o
v
e
m
b
e
r
2
0
2
5

2025]

managerial leadership

1947

coordination is difﬁcult due to the lack of a focal equilibrium. With one-way communication,
coordination rates are high as the sender can call for her preferred equilibrium and the receiver
generally follows. This can be seen as an example of successful leadership in an asymmetric
game. There are many differences between our setup and the experiments of Cooper et al. ( 1989 ),
but perhaps the most important is our focus on efﬁcient coordination. Coordination is achieved
in a number of our treatments, and we have little doubt that one-way communication would
promote coordination as well. Efﬁcient coordination is an entirely different matter. For Cooper
et al. ( 1989 ), efﬁcient coordination is a non-issue as the two pure-strategy equilibria in the
battle-of-the-se x es game are not Pareto ranked.

Cooper et al. ( 1989 ) found that tw o-w ay communication is less ef fecti ve, although coordina-
tion rates impro v e somewhat with multiple rounds of tw o-w ay communication. Our treatment
combining structured communication between agents with delegation resembles the Cooper et al.
( 1989 ) treatment with multiple rounds of tw o-w ay communication, but, due to two important
differences, we anticipated that pre-play communication would be more ef fecti ve in the MA
game. Unlike the battle-of-the-se x es game, the safe outcome in the MA game provides a simple,
safe way of coordinating without asymmetric payoffs. Second, we use partner matching while
Cooper et al. ( 1989 ) used stranger matching. This provides more opportunities for agents to reach
an agreement, and also makes it possible to equalise (expected) payoffs while using asymmetric
choices. In spite of our optimism, we also observed little effect relative to no communication.

We ﬁnd large differences between our structured communication treatments and the paral-
lel chat treatments. These ﬁndings parallel existing evidence that the pro-efﬁciency effects of
communication are greater with free-form chat than structured communication (e.g., Ben-Ner
and Putterman, 2009 ; Lundquist et al. , 2009 ; Charness and Dufwenberg, 2010 ; Cooper and
K ¨uhn, 2014 ; Brandts et al. , 2016 ). The mechanism underlying our result, speciﬁcally the shift to
truth-telling by agents with free-form chat, differs from these previous studies.

An e xtremely activ e e xperimental literature on subjects’ willingness to lie has dev eloped o v er
the past ﬁfteen years (e.g., Gneezy, 2005 ; Erat and Gneezy, 2012 ; Fischbacher and F ¨ollmi-Heusi,
2013 ; Gneezy et al. , 2018 ; Abeler et al. , 2019 ). Several striking re gularities hav e emerged:
(1) subjects often tell the truth even when lying would pay more, 5 (2) the likelihood of lying is
sensiti ve to incenti ves and (3) partial lies (failing to either tell the truth or the payoff-maximising
lie) are common. In the treatment with structured communication and managerial control, where
agents can only send bare messages about the state of the world, all of these regularities are
present in agents’ messages. Ho we ver, lying is not sensitive to incentives and partial lies are rare
in the treatment with managerial control and chat. Messages are observable in both cases and the
message space in both cases is sufﬁcient to communicate the full state of the world, yet the nature
of truth-telling is quite different. Both theorists and experimenters have made a great deal of
progress in understanding why individuals tell partial lies, but we are unaware of any results that
explain the differing results with structured communication and chat. The conclusion discusses
some possibilities, but a full explanation is beyond the scope of this paper.

Beyond the general literature on lie aversion, our treatment with structured communication
and managerial control ( SC-MC ) is related to work by Lai et al. ( 2015 ) and Vespa and Wilson
( 2016 ). Both papers study information transmission in variations of the multidimensional cheap-
talk model with multiple senders proposed by Battaglini ( 2002 ). Lai et al. ( 2015 ) found that

5 Studies of cheap talk games ﬁnd a similar bias towards telling the truth (Cai and Wang, 2006 ; S ´anchez-Pag ´es and
Vorsatz, 2007 ), which could stem from either an aversion to lying or a failure to grasp the strategic beneﬁts of lying. See
Blume et al. ( 2023 ) for contrary evidence.

© The Author(s) 2025.

l

D
o
w
n
o
a
d
e
d

f
r
o
m
h

t
t

p
s
:
/
/

i

a
c
a
d
e
m
c
.
o
u
p
.
c
o
m
e

/

j
/

l

/

/

/

a
r
t
i
c
e
1
3
5
6
7
0
1
9
4
2
8
0
5
1
9
9
8
b
y
P
o
n

/

i

i

i

t
i
f
i
c
a
U
n
v
e
r
s
d
a
d
J
a
v
e
r
i
a
n
a
u
s
e
r
o
n
1
9
N
o
v
e
m
b
e
r
2
0
2
5

1948

the economic journal

[ august

information transmission is better with two senders than one and is particularly good when the
receiver’s interests are in all states aligned with one of the sender’s interests along one of the
two dimensions of the state space. Vespa and Wilson ( 2016 ) found that receivers perform poorly
at extracting information in games where it is relatively difﬁcult (but possible) to infer the state
of the world from senders’ messages. The MA game with structured messages and managerial
control is also a cheap talk game with multiple senders, but differs along a critical dimension from
the games studied by Lai et al. ( 2015 ) and Vespa and Wilson ( 2016 ). In keeping with Battaglini
( 2002 ), they studied games where the state space is multidimensional and messages fully reveal
the state of the world in equilibrium. This contrasts with the MA game where the state space is
unidimensional and messages are not fully revealing (or even informative) in equilibrium. 6 We
intentionally made the informational problems under managerial control as severe as possible.
That said, we also observ e receiv ers (managers) struggling to extract information from senders’
(agents’) messages. If anything, the problem is even more severe as managers make systematic
errors even when information extraction is trivial.

Our work has a clear relationship to the e xtensiv e literature comparing centralised and decen-
tralised ﬁrm management. See Mookherjee ( 2006 ) for a surv e y of the older theoretical literature.
Prominent recent examples in the theory literature include Alonso et al. ( 2008a , b ; 2015 ), Hart
and Moore ( 2008 ), Rantakari ( 2008 ), Dessein et al. ( 2010 ), Hart and Holmstrom ( 2010 ). Recent
empirical studies using observational data include Thomas ( 2011 ) and McElheran ( 2014 ), and
experiments by Evdokimov and Garfagnini ( 2019 ) compare centralisation and decentralisation.
Our work is not intended to test the predictions of an y e xisting theory comparing centralisation
and decentralisation, and our focus differs from the recent theoretical literature. Papers like Alonso
et al. ( 2008a ) and Rantikari ( 2008 ) concentrate on the relationship between the parameters of the
game and the quality of information ﬂowing between the various agents in equilibrium. The MA
g ame with deleg ation is a true coordination game with multiple equilibria. Rather than focusing
on how the equilibrium changes between organisational structures, we study the effect on the
likelihood of efﬁcient coordination with a stress on the roles of active leadership and free-form
communication. As noted abo v e, our results have some rele v ance for the theoretical literature
comparing centralisation and decentralisation, but interested readers should see Evdokimov and
Garfagnini ( 2019 ) for experiments directly testing some of the recent theoretical models. They
found support for theoretical predictions from the models of Alonso et al. ( 2008a ) and Rantakari
( 2008 ).

In our environment, the manager does not decide whether to delegate decision-making rights
or keep control. Nevertheless, our work bears some relation to the experimental work on control,
power and delegation. The seminal work here is Fehr et al. ( 2013 ) and Bartling et al. ( 2014 ). For
some more recent work, see Neri and Rommeswinkel ( 2017 ), Ferreira et al. ( 2020 ) and Pikulina
and Tergiman ( 2020 ).

2.  The Manager-Agent Game

The MA game confronts subjects with a challenging environment that accentuates the trade-offs
between having the manager make decisions for her agents and delegating decisions to the agents.
The MA game is played by two agents (A1 and A2) and a manager (M). The basic structure of

6 See Section 2 below on Battaglini ( 2002 ) for a discussion of the unidimensional case.

© The Author(s) 2025.

l

D
o
w
n
o
a
d
e
d

f
r
o
m
h

t
t

p
s
:
/
/

i

a
c
a
d
e
m
c
.
o
u
p
.
c
o
m
e

/

j
/

l

/

/

/

a
r
t
i
c
e
1
3
5
6
7
0
1
9
4
2
8
0
5
1
9
9
8
b
y
P
o
n

/

i

i

i

t
i
f
i
c
a
U
n
v
e
r
s
d
a
d
J
a
v
e
r
i
a
n
a
u
s
e
r
o
n
1
9
N
o
v
e
m
b
e
r
2
0
2
5

2025]

managerial leadership

1949

agent i ’s payoffs is given by

πA i = k 1 − k 2 ∗ coordination loss − k 3 ∗ adaptation loss − k 4 ∗ state loss .

They face three types of losses. (1) ‘Coordination losses’ are losses from not choosing the same
option as the other agent. In our simple example, it would be difﬁcult to co-author a document
if the two engineers used different software packages. Our model assumes that coordination is
paramount, so the worst outcome is to have the agents fail to agree on an option. (2) ‘Adaptation
losses’ are losses due to deviations from an agent’s most desired outcome (the agent has to
‘adapt’ to the wants and needs of others). Adaptation losses do not depend on the state of
the world. To maximise conﬂict, agents have diametrically opposed tastes in the MA game,
with A1’s most preferred option being A2’s least preferred option (and vice versa). (3) ‘State
losses’ are state dependent, capturing that some options are inherently more or less attractive,
depending on the state of the world. If coordination is the foremost concern and agents care
more about getting their most preferred option than the option that is best for the task at hand,
it follows that k 2 > k 3 > k 4 > 0. Imposing these inequalities makes the game induced by any
state of the world into a coordination game where the two agents have diametrically opposed
interests.

The manager’s payoff is the sum of the agents’ payoffs, implying that management seeks to
minimise total costs. This represents a setting where the manager is rewarded for how her unit does
as a whole, and should not be interpreted as benevolence on the part of the manager. Because the
agents have directly opposed interests, adaptation costs play no role in the manager’s decisions
under managerial control. Anything that makes one agent happier will necessarily make the
other agent less happy. The misaligned incentives that play a central role in most principal-agent
problems are also present in the MA game since agents care about whether or not coordination
occurs at their preferred option, but the manager does not.

2.1.  Sta g e Game Payoff Functions

This sub-section formally describes the MA game. There are three players in the game, a manager
(M) and two agents (A1 and A2). Let γ denote the state of the world: γ ∈  { 1, 2, 3, 4, 5 } . As
standard nomenclature, we refer to the states of the world by the games they induce (e.g., game
1 for γ = 1). The value of γ is randomly determined before players take any actions. Draws of γ
are independent and identically distributed with each game equally likely. To ease comparisons
across treatments, we used the same draw of games for all sessions (although different groups in
a session faced different draws). Both agents know the draw of game G, but the manager only
knows the ex ante distribution o v er games. Agents A1 and A2 choose (under delegation) or are
assigned (under managerial control) actions α1 and α2 : αi ∈  { 1, 2, 3, 4, 5 } . For simplicity, we
use the term ‘outcome’ to refer to the pair of actions ( α1 , α2 ) chosen by or assigned to agents A1
and A2. 7 The payoff functions for A1, A2 and M are respectively given by
πA1 = k 1 − k 2 | α1 − α2 | − k 3 | α1 − 5 | − k 4 | α1 − γ | ,

(1a)

πA2 = k 1 − k 2 | α1 − α2 | − k 3 | α2 − 1 | − k 4 | α2 − γ | ,
πM = πA1 + πA2 .

(1b)

7 From a technical point of view, the MA game is a game of imperfect information. The outcome of the game depends

on the strategies chosen by players and the state of the world. We abuse terminology to simplify the exposition.

© The Author(s) 2025.

l

D
o
w
n
o
a
d
e
d

f
r
o
m
h

t
t

p
s
:
/
/

i

a
c
a
d
e
m
c
.
o
u
p
.
c
o
m
e

/

j
/

l

/

/

/

a
r
t
i
c
e
1
3
5
6
7
0
1
9
4
2
8
0
5
1
9
9
8
b
y
P
o
n

/

i

i

i

t
i
f
i
c
a
U
n
v
e
r
s
d
a
d
J
a
v
e
r
i
a
n
a
u
s
e
r
o
n
1
9
N
o
v
e
m
b
e
r
2
0
2
5

1950

the economic journal

[ august

Table 1. Sta g e Game Payoffs ( k 1 = 54 , k 2 = 14 , k 3 = 7 and k 4 = 4 ).

C1

C2

C3

C4

C5

R1
R2
R3
R4
R5

R1
R2
R3
R4
R5

R1
R2
R3
R4
R5

26, 54, 80
15, 40, 55
4, 26, 30
−7, 12, 5
−18, −2, −20

18, 46, 64
15, 32, 47
12, 18, 30
1, 4, 5
−10, −10, −20

10, 38, 48
7, 24, 31
4, 10, 14
1, −4, −3
−2, −18, −20

12, 29, 41
29, 43, 72
18, 29, 47
7, 15, 22
−4, 1, −3

4, 29, 33
29, 43, 72
26, 29, 55
15, 15, 30
4,1, 5

−4, 21, 17
21, 35, 56
18, 21, 39
15, 7, 22
12, −7, 5

Game 1

−2, 4, 2
15, 18, 33
32,32, 64
21, 18, 39
10, 4, 14

−16, −21, −37
1, −7, −6
18, 7, 25
35, 21, 56
24, 7, 31

−30, −46, −76
−13, −32, −45
4, −18, −14
21, −4, 17
38, 10, 48

Game 3

−10,12, 2
15, 26, 41
40, 40, 80
29,26, 55
18,12, 30

−24, −13, −37
1, 1, 2
26, 15, 41
43,29, 72
32, 15, 47

−38, −38, −76
−13, −24, −37
12, −10,2
29, 4, 33
46, 18, 64

Game 5

−18, 4, −14
7, 18, 25
32, 32, 64
29, 18, 47
26,4, 30

−32, −13, −45
−7, 1, −6
18, 15, 33
43, 29, 72
40, 15, 55

−46, −30, −76
−21, −16, −37
4, −2, 2
29, 12, 41
54, 26, 80

Note : Each cell contains the payoffs for A1 ( π A1 ), A2 ( π A2 ) and M ( π M ).

For all treatments, k 1 = 54, k 2 = 14, k 3 = 7 and k 4 = 4. Table 1 displays the payoff tables for
γ = 1, 3 and 5. Copies of all ﬁve payoff tables can be found in Online Appendix A . The three
numbers in each cell of Table 1 correspond to the payoffs, denominated in experimental currency
units (ECUs), of A1 ( π A1 ), A2 ( π A2 ) and M ( π M ). The row and column are the actions chosen
by A1 and A2, respectively (or chosen for them by M). The row (R) and column (C) numbers
correspond to the actions chosen by the agents (e.g., R3 ≡ α1 = 3; C4 ≡ α2 = 4).

2.2.  Equilibrium Under Delegation

With delegation, each agent chooses an action and the manager is a passive bystander. Ignoring
the payoff for M, all ﬁve games are coordination games with ﬁve pure-strategy Nash equilibria
where the two agents choose the same action: ( α1 = α2 = 1), ( α1 = α2 = 2), ( α1 = α2 = 3),
( α1 = α2 = 4) and ( α1 = α2 = 5). We refer to these outcomes as outcome 1, outcome 2, etc.

In all ﬁve games, there is a tension similar to the battle-of-the-se x es game since A1 most
prefers outcome 5 as an equilibrium and least prefers outcome 1, the reverse is true for A2 and M
prefers the equilibrium that maximises total surplus. This implies that M al w ays w ants a different
equilibrium than at least one of her agents and wants a different equilibrium than either A1 or A2
in games 2, 3 and 4. Alternative principles for equilibrium selection, such as safety and efﬁciency,
suggest different ways of resolving the tension stemming from agents’ differing interests.

Unlike a battle-of-the-se x es game, but similar to a weak-link game, the MA game with del-
egation offers an equilibrium that is safe, simple and fair, but is not efﬁcient in the sense of
maximising total surplus. Al w ays coordinating on outcome 3 (the ‘safe’ outcome) is safe be-
cause αi = 3 is the maximin action for both agents in all ﬁve games. Coordinating on the safe
outcome in all ﬁve games is simple because agents use the same action in all states of the world.
It is fair because the safe outcome yields the same payoff to both agents in all ﬁve games. Except

© The Author(s) 2025.

l

D
o
w
n
o
a
d
e
d

f
r
o
m
h

t
t

p
s
:
/
/

i

a
c
a
d
e
m
c
.
o
u
p
.
c
o
m
e

/

j
/

l

/

/

/

a
r
t
i
c
e
1
3
5
6
7
0
1
9
4
2
8
0
5
1
9
9
8
b
y
P
o
n

/

i

i

i

t
i
f
i
c
a
U
n
v
e
r
s
d
a
d
J
a
v
e
r
i
a
n
a
u
s
e
r
o
n
1
9
N
o
v
e
m
b
e
r
2
0
2
5

2025]

managerial leadership

1951

in game 3, the safe outcome does not maximise total surplus. Despite this, the attractive features
of the safe outcome give it drawing power in our data.

All ﬁve games have an equilibrium that maximises total surplus. This is al w ays equi v alent to the
game number (i.e., outcome 1 in game 1, outcome 2 in game 2, etc.). Efﬁcient coordination, where
the agents play the surplus-maximising equilibrium in all states of the world, is procedurally fair
(i.e., equalises expected payoffs under the veil of ignorance about the state of the world; Bolton
et al. , 2005 ), but yields asymmetric payoffs for all games except game 3. Efﬁcient coordination
is also relatively complex because the agents must change their actions as the state of the world
changes.

l

D
o
w
n
o
a
d
e
d

f
r
o
m
h

t
t

2.3.  Equilibrium Under Mana g erial Control

The following discussion is based on structured communication, but extends in a straightforward
manner to free-form chat. With managerial control, agents do not choose rows and columns
directly. After being informed about the state of the world (i.e., game 1, game 2, etc.) each
agent independently sends a message to the manager indicating which state of the world has
been selected ( μi ∈ { 1, 2, 3, 4, 5 } ). After receipt of the two messages ( μ1 and μ2 ), the manager
chooses both a row and a column ( α1 and α2 ). She has no knowledge about which game has
been selected beyond the initial distribution over states of the world and whatever information
she gleans from the agents’ messages.

Conditional on enforcing coordination, Equations ( 1a ) and ( 1b ) imply that the manager does
not care about the adaptation losses, but the agents do. Given their opposing interests, the agents
have no incentive to be truthful with the manager. If both agents al w ays report the game where
the efﬁcient outcome is best for them (game 5 for A1, game 1 for A2), the best the manager
can do is to choose the safe outcome ( α1 = α2 = 3). 8 Any beneﬁts from the agents’ pri v ate
information are lost and the manager generally will not choose the efﬁcient outcome.

More formally, we can pro v e the following theorem that implies that the only pure-strategy
perfect Bayesian equalibria (PBEs) are babbling equilibria where the safe outcome ( α1 = α2 = 3)
is al w ays chosen. In Online Appendix B we show that the manager must pick the same row and
column ( α1 = α2 ) in any PBE. Given this, we henceforth refer to the manager as choosing a
single action in response to the agents’ messages.

THEOREM 1.  There does not exist a pure-strategy PBE for the MA game with mana g erial

control where the mana g er chooses different actions for two different states of the world.

PROOF.  See Online Appendix B .

(cid:2)

Finite repetition of the MA game with managerial control does not expand the set of possible
pure-strategy equilibria to include informative equilibria. There is a unique pure-strategy equilib-
rium payoff vector in the stage game. The set of equilibrium payoffs only expands if players can
take advantage of differing payoffs across stage game equilibria to prevent deviations. If there
were payof f dif ferences between the equilibria, a punishment scheme could be constructed to
support equilibria that are not babbling equilibria in the repeated game. But, given that payoffs
do not vary across equilibria, this is not possible.

8 Gi ven that payof fs are linear, this is not transparent. Deﬁne a manager’s error as the difference between the action
she chooses (assuming that α1 = α2 ) and her payoff-maximising choice, given the state of the world. Choosing the safe
equilibrium limits the size of manager errors. If she chooses the safe equilibrium, her average error is 1.2. If she chooses
action 2 or 4, the average error rises to 1.4. Choosing 1 or 5, the average error goes up to 2.0.

© The Author(s) 2025.

p
s
:
/
/

i

a
c
a
d
e
m
c
.
o
u
p
.
c
o
m
e

/

j
/

l

/

/

/

a
r
t
i
c
e
1
3
5
6
7
0
1
9
4
2
8
0
5
1
9
9
8
b
y
P
o
n

/

i

i

i

t
i
f
i
c
a
U
n
v
e
r
s
d
a
d
J
a
v
e
r
i
a
n
a
u
s
e
r
o
n
1
9
N
o
v
e
m
b
e
r
2
0
2
5

1952

the economic journal

[ august

The absence of an informative equilibrium does not reﬂect a generic property of cheap talk
games with multiple senders; such games generically have an informative equilibrium when
the state space is multidimensional (Battaglini, 2002 ). The MA game intentionally gives the
two agents diametrically opposed interests o v er a unidimensional state space. The resulting
lack of an informative equilibrium makes information transmission theoretically impossible with
managerial control. This is in keeping with our goal of confronting subjects with a challenging
environment that accentuates differences between the manager retaining control or delegating
choices to her agents. In the quest for efﬁcient coordination, managerial control exchanges
the problem of having multiple equilibria for the problem of needing to get agents to reveal
information against their interests.

The theory assumes that messages are cheap talk, with agents incurring no costs, pecuniary
or psychological, for sending false messages. If we add a psychological cost for sending false
messages, as in Kartik ( 2009 ), it is trivial to construct cases where truthful revelation is con-
sistent with an equilibrium. For example, let c L | μi  − γ | be agent i’ s psychological cost of
lying. If c L > k 3 − k 4 , there exists an equilibrium in which both agents truthfully reveal their
information. 9

There does not exist a pure-strategy equilibrium that is informative, but there do exist mixed
strategy equilibria that are partially informative. These equilibria are delicate; in Online Appendix
B  we  show  that  no  such  equilibria  exist  if  we  require  that  an  equilibrium  is  robust  to  the
introduction of trembles and manager strategies are monotonic. Empirically, we see no evidence
of such equilibria occurring. As such, we regard the partially informative equilibria as theoretical
oddities rather than predictive of subject behaviour.

2.4.  Discussion of the MA Game

A number of the MA game’s features were chosen to accentuate speciﬁc aspects of the coordi-
nation problems facing managers and agents. (1) Without asymmetric information, the problem
facing managers under managerial control is trivial as information transmission is a non-issue.
(2) Having a single common shock rather than two independent shocks accentuates the difference
between managerial control and delegation. Under delegation, asymmetric information plays no
role, but agents’ conﬂicting preferences make coordination difﬁcult. With managerial control,
coordination is trivial, but achieving efﬁciency requires the manager to overcome the asymmetric
information between her and her agents. 10 (3) The functional forms in ( 1a ) and ( 1b ) use abso-
lute values of differences, rather than squared differences as used by Alonso et al. ( 2008a ) and
Rantakari ( 2008 ). Because of this choice, there are multiple equilibria in the MA game with
delegation rather than a single equilibrium. 11 Multiplicity plays a central role in our paper, as the
main problem facing managers is trying to achie ve ef ﬁcient coordination rather than defaulting
to the safe outcome. (4) We use ﬁve possible actions and ﬁve states of the world rather than two

9 If both agents send the same message, the manager chooses the corresponding outcome. If μi = 1 and μj = 2, where
i , j ∈ { 1, 2 } and i (cid:5)= j , the manager chooses outcome 2. If μi = 4 and μj = 5, where i , j ∈ { 1, 2 } and i (cid:5)= j , the manager
chooses outcome 4. Otherwise, the manager chooses outcome 3.

10 Models like Alonso et al. ( 2008a ) and Rantikari ( 2008 ) use two independent shocks. Using the terminology of
our paper, this leads to a comparison of information ﬂows between agents under delegation versus information ﬂows
from agents to managers under managerial control. Our paper focuses on the coordination problem with delegation and
eliminates any issues due to asymmetric information between agents.

11 With absolute values, an agent maximises his payoff by picking exactly the same action as the other agent. With
squared differences, agents want to shade their choice away from their own preferred outcome and towards the other
agent’s action rather than matching the other agent’s action.

© The Author(s) 2025.

l

D
o
w
n
o
a
d
e
d

f
r
o
m
h

t
t

p
s
:
/
/

i

a
c
a
d
e
m
c
.
o
u
p
.
c
o
m
e

/

j
/

l

/

/

/

a
r
t
i
c
e
1
3
5
6
7
0
1
9
4
2
8
0
5
1
9
9
8
b
y
P
o
n

/

i

i

i

t
i
f
i
c
a
U
n
v
e
r
s
d
a
d
J
a
v
e
r
i
a
n
a
u
s
e
r
o
n
1
9
N
o
v
e
m
b
e
r
2
0
2
5

2025]

managerial leadership

1953

(as in a battle-of-the-se x es game) or three. Going from two to three possible actions adds the safe
outcome as an equilibrium that plays a critical role in subjects’ choices. Going from three to ﬁve
actions makes it easier to distinguish whether play is consistent with the efﬁcient or safe outcome,
since the two are equi v alent less frequently, and easier to detect partial lies. (5) To accentuate their
differing preferences, agents are paid based solely on their own payoffs rather than a weighted
av erage o v er the two agents’ payof fs. Implicitly, this eliminates incenti ve schemes that include
revenue or proﬁt-sharing components. (6) Finally, the interaction between the manager and agents
under managerial control is modeled as a cheap talk game rather than a problem of mechanism
design. Implicitly, we assume that the manager cannot commit to a mechanism for eliciting
information.

3.  Experimental Design and Hypotheses

3.1.  Experimental Design and Procedures

The initial design included seven treatments, broken into three broad categories by type of
communication (no communication, structured communication or chat). The six treatments with
communication cross two types of communication (structured or free-form chat) with three
different interaction structures between the manager and agents (delegation with communication
between agents, delegation with advice from managers and managerial control). Before getting
into the details of the experimental design, we pause to discuss the rationale for including both
of these dimensions.

Structured communication and chat can be seen as extreme types of communication that serve
different roles in our design. 12 Structured communication allows for clean tests of theoretical
predictions since the message space matches the theoretical model being tested. More generally,
the simplicity of structured communication makes it easier to pin down the mechanism by
which communication affects outcomes. Free-form chat is richer and offers a more realistic form
of communication. There exists ample evidence that free-form chat has dif fering ef fects from
structured communication (Brandts et al. , 2019 ), generally being more ef fecti ve at promoting
cooperation. There is no existing work that we know of comparing the effects of structured and
free-form communication on either coordination or truth-telling.

Turning to the other dimension of the design, the ﬁrst interaction structure, delegation with
communication between agents, gives the manager no role. The latter two treatments, delegation
with advice from managers and managerial control, explore different ways in which a manager
might try to achieve efﬁcient coordination, either persuading the agents to coordinate efﬁciently,
essentially  acting  as  a  focal  point,  or  imposing  actions  upon  the  agents.  In  the  absence  of
asymmetric information, it is trivial to achieve efﬁcient coordination by imposing actions. But,
it is no longer obvious which approach will be most ef fecti ve with the addition of asymmetric
information. Our treatments emphasise different approaches to the manager’s problem, letting us
see which will be more ef fecti ve. 13

12 Section 5 below presents a new treatment where the mode of communication is intermediate between these two

extremes.

13 The treatments with structured communication separately identify the effects of pre-play communication between
agents and managerial advice. Given that neither had much effect in isolation, it seems safe to assume that the combination,
paralleling treatment CH/A-D , would also have little effect.

© The Author(s) 2025.

l

D
o
w
n
o
a
d
e
d

f
r
o
m
h

t
t

p
s
:
/
/

i

a
c
a
d
e
m
c
.
o
u
p
.
c
o
m
e

/

j
/

l

/

/

/

a
r
t
i
c
e
1
3
5
6
7
0
1
9
4
2
8
0
5
1
9
9
8
b
y
P
o
n

/

i

i

i

t
i
f
i
c
a
U
n
v
e
r
s
d
a
d
J
a
v
e
r
i
a
n
a
u
s
e
r
o
n
1
9
N
o
v
e
m
b
e
r
2
0
2
5

1954

the economic journal

[ august

The seven initial treatments are as follows.

No communication with delegation ( NC-D ). This was the baseline treatment where subjects
played the MA game with delegation, as described in Section 2.2 , without any additional
communication.

Structured communication between a g ents with delegation ( SC/S-D ). This treatment was iden-
tical to the NC-D treatment, except pre-play communication between agents was added.
Prior to the agents’ choices of actions, each game began with three rounds of messages.
Within each round of messages, the agents simultaneously chose a pair of messages suggest-
ing actions for themselves and the other agent. The message space was limited in structured
communication treatments; in treatment SC/S-D , for example, the agents chose messages
by clicking on radio buttons labelled with the ﬁve available actions and could not send
any other messages. Agents observed each other’s messages at the end of each round of
messages. The purpose of having three rounds of messaging (rather than one) was to make
it easier for agents to agree upon a course of action.

Structured communication with advice and delegation ( SC/A-D ). This treatment was identical
to the NC-D treatment, except the manager sent a message to the agents prior to each round
of play. This message suggested actions for both agents in each of the ﬁve possible games.
In other words, the manager advised a course of action contingent on the realised state of
the world. The full message (a 5 × 2 matrix) was shown to both A1 and A2 prior to their
choice of actions. The agents knew that both received identical messages.

Structured communication and mana g erial control ( SC-MC ). In this treatment, subjects played
the game with managerial control as described in Section 2.3 . In each round, the two agents
viewed the state of the world (i.e., game 1, game 2, etc.) and sent simultaneous messages to
the manager reporting the state of the world ( μi ∈ { 1, 2, 3, 4, 5 } ). There was no requirement
that these messages be truthful, a point emphasised in the instructions. After receipt of the
two messages, M chose both a row and a column. There was no requirement that the row
and column match.

Chat between a g ents with delegation ( CH/S-D ). This treatment was identical to the NC-D
treatment, except pre-play chat between agents was added. The agents had two minutes
to engage in free-form discussions via chat before choosing actions. They could discuss
whatev er the y chose. In practice, discussions largely focused on the obvious topic, how to
play the game. The manager saw the discussion, but could not participate.

Chat with advice and delegation ( CH/A-D ). This treatment was identical to the CH/S-D
treatment, except the manager could participate in the chat prior to her agents choosing
actions. As in treatment SC/A-D , the manager had no control o v er the agents’ actions,
but could advise them. Free-form chat opened many possibilities beyond simply advising
a course of action, such as explaining the rationale for adopting efﬁcient coordination or
persuading agents of the mutual beneﬁts of trusting each other.

© The Author(s) 2025.

l

D
o
w
n
o
a
d
e
d

f
r
o
m
h

t
t

p
s
:
/
/

i

a
c
a
d
e
m
c
.
o
u
p
.
c
o
m
e

/

j
/

l

/

/

/

a
r
t
i
c
e
1
3
5
6
7
0
1
9
4
2
8
0
5
1
9
9
8
b
y
P
o
n

/

i

i

i

t
i
f
i
c
a
U
n
v
e
r
s
d
a
d
J
a
v
e
r
i
a
n
a
u
s
e
r
o
n
1
9
N
o
v
e
m
b
e
r
2
0
2
5

2025]

managerial leadership

1955

Chat and mana g erial control ( CH-MC ). This treatment w as identical to the SC-MC treatment,
except the structured messages about the state of the world were eliminated and replaced
by free-form chat between the agents and their manager. The agents were not speciﬁcally
instructed to share information about the state of the world, but this was a natural and
typical topic of conversation, making the structured messages redundant. Again, there was
a two-minute time limit. Unlike the CH/A-D treatment, the manager had control o v er the
outcome and the agents had reason to not truthfully reveal the state of the world.

Beyond the seven treatments reported in the main text, we ran an additional four treatments.
These were modiﬁcations of the NC-D and SC-MC treatments to examine secondary issues. The
main experimental design holds incentives ﬁxed to focus on the effects of changing decision-
making rights and the types of available communication. The HSL-D and HSL-MC treatments
examine the effect of changing incentives by increasing state losses ( k 4 = 6 versus k 4 = 4).
This reduces the tension between agents, making the efﬁcient outcome more attracti ve relati ve
to the safe outcome. Play shifts towards efﬁcient coordination, consistent with the change in
incentives, but our qualitative conclusions are unaffected. In particular, lowering state losses
does not signiﬁcantly increase efﬁciency gains relative to the SC-MC treatment and efﬁciency
gains remain signiﬁcantly lower than in the CH-MC treatment. In other words, a strong increase
in incentives to play the efﬁcient equilibrium has signiﬁcantly less impact than allowing free-
form communication. The STR-D and STR-MC treatments used stranger matching rather than
partner matching. This made efﬁcient coordination harder, as expected, but the effects are not
signiﬁcant and our qualitative conclusions are unaffected. Online Appendix D provides further
description of these four additional treatments and the results.

We used a between-subject design, so each subject participated in just one of the treatments.
There were three sessions per treatment and nine three-person groups per session, giving twenty-
seven subjects per session, twenty-seven independent groups per treatment and a total of 567
subjects in 189 independent groups.

Subjects played eighteen rounds in all treatments. They were assigned the role of M, S1 or S2 at
the beginning of the session and kept these roles throughout the session. Partner matching was used
(i.e., participants were matched with the same two subjects throughout the entire experiment).
In treatments with delegation, the participants in the M role were pure observers. We did this to
keep the possible inﬂuence of other-regarding preferences constant across treatments.

The state of the world (i.e., the game being played) was randomly and independently deter-
mined at the beginning of each round. Common seeds were used across treatments, limiting the
possibility that treatment effects could be driven by differing draws. At the end of each round,
subjects received feedback about the realised game and the chosen actions. In the treatments with
managerial control, this made it possible for managers to know if an agent had lied about the
game being played.

Sessions were run using z-tree (Fischbacher, 2007 ). Each session began with instructions (see
Online Appendix C ). Participants had printed copies of the payoff tables for all ﬁve games.
Sessions were run at the LINEEX lab at the University of Valencia, with undergraduate students
from the university as participants. The payoffs were denominated in e xperimental currenc y units,
with 1 ECU = 0.2 €. Participants received their cumulative earnings for all rounds. Including a
5 € show-up fee, average pay was 19.90 €. Sessions lasted approximately an hour.

© The Author(s) 2025.

l

D
o
w
n
o
a
d
e
d

f
r
o
m
h

t
t

p
s
:
/
/

i

a
c
a
d
e
m
c
.
o
u
p
.
c
o
m
e

/

j
/

l

/

/

/

a
r
t
i
c
e
1
3
5
6
7
0
1
9
4
2
8
0
5
1
9
9
8
b
y
P
o
n

/

i

i

i

t
i
f
i
c
a
U
n
v
e
r
s
d
a
d
J
a
v
e
r
i
a
n
a
u
s
e
r
o
n
1
9
N
o
v
e
m
b
e
r
2
0
2
5

1956

3.2.  Hypotheses

the economic journal

[ august

Hypothesis H1 below draws on the theory developed in Section 2 to compare the NC-D and
SC-MC treatments. Efﬁcient coordination, which is an equilibrium in the NC-D treatment, uses
agents’ information to achieve the maximum possible total surplus. In the SC-MC treatment, only
inefﬁcient pure-strategy babbling equilibria exist. Hypothesis H1 follows. This hypothesis was a
straw man. The MA game with delegation resembles a battle-of-the-se x es game, a setting where
coordination is known to be difﬁcult in the absence of communication (Cooper et al. , 1989 ).
Even though the presence of a safe equilibrium should make coordination easier, we still doubted
that agents could coordinate, let alone coordinate efﬁciently, in the absence of communication.

l

D
o
w
n
o
a
d
e
d

f
r
o
m
h

t
t

HYPOTHESIS H1. Total surplus will be greater in treatment NC-D than in treatment SC-MC .

The theory predicts play of a babbling equilibrium in the SC-MC treatment, implying that
agents’ messages will be uninformative. Hypothesis H2 below follows. Once again, there were
good reasons to be sceptical. Our design differed from most existing experiments, especially
since more than one subject sent messages, but the general ﬁnding that individuals are reluctant
to lie seemed likely to apply.

HYPOTHESIS  H2.  (a) In the SC-MC treatment, agents’ messages will contain no useful

information about the state of the world.

(b) Total surplus will not exceed the payoff from the safe outcome (the babbling equilibrium).

Turning  to  the  treatments  with  structured  communication  and  delegation,  SC/S-D  and
SC/A-D , neither type of pre-play communication changes the theoretical prediction. We nev-
ertheless expected total surplus to increase relative to the NC-D treatment in both cases. The
different types of communication (between agents versus managerial advice) emphasised differ-
ent mechanisms by which communication might yield efﬁcient coordination. Communication
between agents gave them an opportunity to directly coordinate their choices prior to picking
actions. The agents did not face any asymmetric information in the SC/S-D treatment, but lacked
an obvious mechanism for resolving conﬂicts due to their divergent interests. Cooper et al.
( 1989 ) observed modest improvements from adding three rounds of bilateral pre-play structure
communications to the battle-of-the-se x es game. Based on this evidence, we expected a modest
increase in total surplus between the NC-D and SC/S-D treatments. 14 With managerial advice, we
expected managers to act as a coordination device promoting efﬁcient coordination. Because the
power to choose actions resides with the agents, asymmetric information should not be an issue
in the SC/A-D treatment. It is al w ays in the manager’s interest to promote efﬁcient coordination,
and unlike the SC/S-D treatment, agents in the SC/A-D treatment have a single, common source
of guidance on how to play. We hoped that the beneﬁts of certain coordination would o v ercome
reluctance to accept a less preferred outcome. Thus, we anticipated that efﬁcient coordination
would be more likely with managerial advice than communication between agents. The preced-
ing conjectures are summarised in Hypothesis H3 below. This hypothesis is stated relative to the
NC-D treatment, as the structured communication treatments with delegation modify the NC-D
treatment, but combining Hypotheses H1 and H3 yields a prediction that both treatments will
also yield higher total surplus than the SC-MC treatment.

14 There are differences in the structure of our experiment and game, described in Section 1 , that increased our

optimism about the relative performance of the SC/S-D treatment.

© The Author(s) 2025.

p
s
:
/
/

i

a
c
a
d
e
m
c
.
o
u
p
.
c
o
m
e

/

j
/

l

/

/

/

a
r
t
i
c
e
1
3
5
6
7
0
1
9
4
2
8
0
5
1
9
9
8
b
y
P
o
n

/

i

i

i

t
i
f
i
c
a
U
n
v
e
r
s
d
a
d
J
a
v
e
r
i
a
n
a
u
s
e
r
o
n
1
9
N
o
v
e
m
b
e
r
2
0
2
5

2025]

managerial leadership

1957

HYPOTHESIS H3. Total surplus will be greater in treatment SC/A-D than in treatment SC/S-D ,

and greater in treatment SC/S-D than in treatment NC-D .

The  ﬁnal  hypothesis  co v ers  the  chat  treatments.  Many  papers  have  compared  the  effects
of  structured  communication  versus  chat.  The  general  ﬁnding  is  that  communication  has  a
greater impact on outcomes with chat rather than structured communication (Brandts et al. ,
2019 ). Particularly rele v ant to our current work, Cooper and K ¨uhn ( 2014 ) found that free-form
communication outperforms structured communication in a two-period Bertrand game, largely by
improving coordination on an efﬁcient equilibrium . While the games are different, we expected
that the ability to make unlimited asynchronous proposals along with the ability to explain
proposals would similarly increase efﬁcient coordination under delegation. We therefore expected
the chat treatments to yield higher total surplus than the parallel structured communication
treatments. We also expected the comparison of total surplus across chat treatments to match
the order across structured communication treatments. Consistent with the theory abo v e, we
anticipated that agents would not truthfully communicate the state of the world in the CH-
MC treatment, leading to play of the safe outcome. We expected that chat would solve the
coordination problem in the other two treatments ( CH/S-D and CH/A-D ) and would impro v e
efﬁcienc y be yond the safe equilibrium. Hypothesis H4 below summarises our conjectures.

HYPOTHESIS  H4.  (a)  Treatment  CH/S-D  will  yield  higher  total  surplus  than  treat-
ment  SC/S-D  and  treatment  CH/A-D  will  yield  higher  total  surplus  than  treatment
SC/A-D . No difference is predicted between treatments SC-MC and CH-MC .

(b) Comparing chat treatments, total surplus will be highest in treatment CH/A-D , followed

by treatments CH/S-D and CH-MC .

4.  Results

Section 4.1 gives an overview of the main treatment effects, and Section 4.2 examines the process
underlying these treatment effects.

4.1.  Treatment Effects

The discussion of treatment effects is based on the second half of the experiment (rounds 10–18)
when play has settled down. 15 Versions of Tables 2 and 3 based on the ﬁrst half of the experiment
can be found in Online Appendix A . Unless otherwise noted, statistical tests comparing treatments
are Wilcoxon rank-sum tests and comparisons with total surplus from play of the safe outcome are
Wilcoxon matched-pair signed-rank tests. The p -values come from exact tests. An observation is
the average value of the variable in question for a single group o v er rounds 10–18. Total surpluses
from the safe outcome are adjusted for the random draw of games.

Table 2 summarises outcomes by treatment from rounds 10–18. To maximise total surplus,
the choices of the two agents need to be coordinated ( α1 = α2 ) and these choices have to take
advantage of the agents’ information ( α1 = α2 = γ ). Along these lines, the ﬁrst column of Table 2
reports the percentage of games where the choices were coordinated, and the second shows the
frequency of efﬁcient coordination subject to the a g ents’ choices being coordinated . The ﬁnal

15 The average change in total surplus across rounds 1–9, comparing the ﬁrst and last three round blocks, is more than

ten times larger than the change across rounds 10–18 (6.40 versus 0.60).

© The Author(s) 2025.

l

D
o
w
n
o
a
d
e
d

f
r
o
m
h

t
t

p
s
:
/
/

i

a
c
a
d
e
m
c
.
o
u
p
.
c
o
m
e

/

j
/

l

/

/

/

a
r
t
i
c
e
1
3
5
6
7
0
1
9
4
2
8
0
5
1
9
9
8
b
y
P
o
n

/

i

i

i

t
i
f
i
c
a
U
n
v
e
r
s
d
a
d
J
a
v
e
r
i
a
n
a
u
s
e
r
o
n
1
9
N
o
v
e
m
b
e
r
2
0
2
5

1958

the economic journal

[ august

Table 2. Summary of Outcomes, Rounds 10–18.

Treatment

% Coordinate

NC-D
SC/S-D
SC/A-D
SC-MC
CH/S-D
CH/A-D
CH-MC

69 .5
77 .8
69 .5
99 .6
97 .5
90 .9
100 .0

% Efﬁcient
(subject to.
coordinate)

39 .1
57 .1
58 .7
45 .9
48 .1
60 .6
61 .7

Total surplus

61 .4
65 .7
64 .4
71 .7
72 .2
71 .6
75 .2

Efﬁciency gain
(%)
−108 .3
−57 .5
−77 .4
6 .5
14 .0
2 .8
44 .3

l

D
o
w
n
o
a
d
e
d

f
r
o
m
h

t
t

Table 3. Frequency of Types of Coordination if γ (cid:5)= 3, Rounds 10–18.

Treatment

% Safe

% Efﬁcient

% Other

NC-D
SC/S-D
SC/A-D
SC-MC
CH/S-D
CH/A-D
CH-MC

48 .1
36 .1
32 .8
31 .1
41 .0
29 .5
34 .4

12 .6
30 .6
30 .1
36 .1
36 .1
44 .8
50 .8

4 .9
8 .2
4 .4
32 .2
20 .8
15 .8
14 .8

two columns give measures of overall performance: the third column of Table 2 shows average
total surplus and the fourth column reports the average ‘efﬁciency gain’. Total surplus is deﬁned
as the sum of the payoffs for A1 and A2, equivalent to the manager’s payoff. Efﬁciency gain is
deﬁned as the difference between a group’s total surplus for the nine-round block and the total
surplus it would have achieved by playing the babbling equilibrium ( α1 = α2 = 3) throughout,
divided by the difference between the total surplus from efﬁcient coordination and the total
surplus from the babbling equilibrium. This transformation of the total surplus makes it easier
to see how well groups do relative to the babbling equilibrium. Playing the efﬁcient equilibrium
yields an efﬁciency gain of 100%, while the babbling equilibrium leads to an efﬁciency gain of
0%. Ne gativ e efﬁcienc y gains reﬂect failure to coordinate. F or treatments where coordination
is high, the efﬁciency game is a good measure of how well groups make use of the agents’
information

Hypothesis  H1 hypothesised  that total surplus would  be  greater in treatment  NC-D than
in  treatment  SC-MC .  This  was  a  straw  man,  relying  on  the  best-case  scenario  of  efﬁcient
coordination for treatment NC-D , and indeed Hypothesis H1 is strongly rejected as total surplus
is signiﬁcantly greater in treatment SC-MC than in treatment NC-D ( p < .001). It is not difﬁcult to
see the reason for this difference. Managers understand the importance of coordination, leading
to a coordination rate of almost 100% in treatment SC-MC . Lacking a coordination device,
coordination is signiﬁcantly lower in treatment NC-D ( p < .001).

RESULT 1. Total surplus is signiﬁcantly higher in treatment SC-MC than in treatment NC-D.
The data are not consistent with Hypothesis H1. Signiﬁcantly lower coordination rates largely
explain the lower total surplus in treatment NC-D .

While performance is far stronger in treatment SC-MC than in treatment NC-D , it does not
follow that much use is made of the agents’ information. The efﬁciency gain is only 6.5%
for treatment SC-MC , indicating that little of the possible gain o v er the babbling equilibrium is

© The Author(s) 2025.

p
s
:
/
/

i

a
c
a
d
e
m
c
.
o
u
p
.
c
o
m
e

/

j
/

l

/

/

/

a
r
t
i
c
e
1
3
5
6
7
0
1
9
4
2
8
0
5
1
9
9
8
b
y
P
o
n

/

i

i

i

t
i
f
i
c
a
U
n
v
e
r
s
d
a
d
J
a
v
e
r
i
a
n
a
u
s
e
r
o
n
1
9
N
o
v
e
m
b
e
r
2
0
2
5

2025]

managerial leadership

1959

achie ved. The dif ference between total surplus in treatment SC-MC and the babbling equilibrium
is not statistically signiﬁcant ( p = .444).

To help us better understand why performance varies across treatments, Table 3 summarises
the frequency of speciﬁc outcomes in games 1, 2, 4 and 5. As deﬁned previously, the safe outcome
refers to a mutual choice of 3 ( α1 = α2 = 3) and the efﬁcient outcome indicates coordinated
choices matching the state of the world ( α1 = α2 = γ ). ‘Other’ refers to any other outcome where
the agents’ actions are coordinated ( α1 = α2 ), but at neither the safe nor the efﬁcient outcome.
Table 3 does not use data from game 3 because the efﬁcient and safe outcomes coincide in this
case (hence, the coordination rates in Table 3 do not add up to the ﬁgures shown in the ﬁrst
column of Table 2 ).

Table 3 makes it clear that coordination failure is not the only problem in treatment NC-D .
When agents coordinate and the safe and efﬁcient outcomes do not coincide ( γ (cid:5)= 3), they usually
coordinate at the safe outcome (73% subject to coordinating) rather than the efﬁcient outcome
(19% subject to coordinating). The safe outcome provides a relatively easy route to coordination
in the challenging environment of treatment NC-D , and agents take advantage of this even though
it means not using their information.

Matters are a bit more complex in treatment SC-MC . In some ways performance is better than
the babbling equilibrium. For γ (cid:5)= 3, the efﬁcient outcome is slightly more common than the safe
outcome. Unfortunately, average total surplus for the 32% of outcomes in the ‘other’ category of
coordination is lower than could have been achieved via the babbling equilibrium (62.1 versus
67.7). These outcomes often do not involve shading the difference between safety and efﬁciency.
For games 1 and 5, 56% of ‘other’ outcomes use actions that are farther away from the efﬁcient
outcome than the safe outcome. Managers attempt to use their agents’ information, but often do
so poorly.

RESULT 2.  In treatment NC-D, a g ents g enerally coordinate by playing the safe outcome,
implying a failure to use their information. Total surplus in treatment SC-MC is almost identical to
the babbling equilibrium prediction, consistent with Hypothesis H2(b), but play is consistent with
neither the babbling equilibrium (repeated play of the safe outcome) nor efﬁcient coordination.
This implies a failure to use the a g ents’ information.

The results in Table 2 provide little support for Hypothesis H3. Total surplus in rounds 10–18 is
higher for treatments SC/S-D and SC/A-D than treatment NC-D , but the differences are small and
not statistically signiﬁcant ( p = .156 and p = .422, respectively). Total surplus is slightly lower in
treatment SC/A-D than in treatment SC/S-D , rather than higher as predicted. Neither treatment
SC/S-D nor SC/A-D does as well as treatment SC-MC , with both differences signiﬁcant across
rounds 10–18 ( p = .056 and p = .009, respectively).

Treatments SC/S-D and SC/A-D have little effect on total surplus in rounds 10–18 because
neither increases the coordination rate signiﬁcantly relative to treatment NC-D ( p = .325 and
p = .947, respectively). To the limited extent that these treatments do better than treatment NC-D ,
it is by making better use of agents’ information. Subject to coordinating in γ (cid:5)= 3, the frequency
of the efﬁcient outcome rises from 19% in treatment NC-D to 41% and 45% in treatments SC/S-D
and SC/A-D , respectively.

RESULT 3.  Treatments SC/S-D and SC/A-D do not yield signiﬁcantly higher total surplus
than treatment NC-D , and do signiﬁcantly worse than treatment SC-MC . The data do not support
Hypothesis H3.

© The Author(s) 2025.

l

D
o
w
n
o
a
d
e
d

f
r
o
m
h

t
t

p
s
:
/
/

i

a
c
a
d
e
m
c
.
o
u
p
.
c
o
m
e

/

j
/

l

/

/

/

a
r
t
i
c
e
1
3
5
6
7
0
1
9
4
2
8
0
5
1
9
9
8
b
y
P
o
n

/

i

i

i

t
i
f
i
c
a
U
n
v
e
r
s
d
a
d
J
a
v
e
r
i
a
n
a
u
s
e
r
o
n
1
9
N
o
v
e
m
b
e
r
2
0
2
5

1960

the economic journal

[ august

The three treatments with free-form chat all yield signiﬁcantly higher average total surplus
across rounds 10–18 than treatment NC-D ( p < .001 if all three cases). Hypothesis H4(a) fares
well with delegation, but not with managerial control; treatments CH/S-D and CH/A-D yield
signiﬁcantly higher total surplus than the parallel structured communication treatments ( p = .021
and p = .005, respectively), but total surplus is signiﬁcantly lower in treatment SC-MC than in
treatment CH-MC ( p = .003). Treatment CH-MC also yields signiﬁcantly higher total surplus
than treatment CH/S-D ( p = .014). Strong performance in the CH-MC treatment is not due to
chat or managerial control, but rather the conjunction of the two. 16

Oddly,  total  surplus  is  not  signiﬁcantly  higher  in  treatment  CH-MC  than  in  treatment
CH/A-D ( p = .162) even though total surplus across rounds 10–18 is lower on average in
treatment CH/A-D than in treatment CH/S-D . This reﬂects the high variance of outcomes in the
CH/A-D treatment. The SD of total surplus is more than double in treatment CH/A-D (10.5) than
the other two chat treatments (4.7 and 4.0 for treatments CH/S-D and CH-MC , respectively).
Looking at the nine groups in the chat treatments that achieve a perfect total average surplus of
80, treatment CH/A-D ties with treatment CH-MC for the most at four apiece. But, if we look
at the nine worst groups, treatment CH/A-D again leads with ﬁve while treatment CH-MC has
none. It would be a mistake to describe performance in treatment CH/A-D as either good or bad;
a more accurate adjective would be ‘erratic’.

Treatment CH-MC has by far the highest efﬁciency gain of any treatment (44.3%), and is the
only treatment that yields signiﬁcantly higher total surplus than repeated play of the safe outcome
( p < .001). 17 Efﬁcient coordination has two components: agents’ choices must be coordinated
and must reﬂect their information. Treatment CH-MC does well on both accounts. It is the only
treatment where groups achieve 100% coordination in rounds 10–18. Treatment CH/S-D does
almost as well at achieving coordination, but treatment CH/A-D has a lower coordination rate
that largely explains its relatively low total surplus. 18 Not only is coordination 100% perfect
in treatment CH-MC , but play of the efﬁcient equilibrium is signiﬁcantly increased relative to
either treatment SC-MC ( p = .027) or CH/S-D ( p = .064). Treatment CH-MC outperforms these
two treatments because of superior use of the agents’ information. This is not true for treatment
CH/A-D where the rate of efﬁcient coordination is only slightly lower than in treatment CH-MC
( p = .449 ) .

RESULT  4.  The data are only partially consistent with Hypothesis H4(a). All three chat
treatments produce signiﬁcantly higher total surplus than the parallel structured communication
treatments—Hypothesis H4(a) predicts identical surplus for treatments SC-MC and CH-MC .

RESULT 5.  Across all seven treatments, the combination of free-form chat with mana g erial
control yields the highest total surplus. This reﬂects both high levels of coordination and improved
usa g e of the a g ents’ information in treatment CH-MC . This is not consistent with Hypothesis
H4(b), which predicts that treatment CH-MC will have the lowest total surplus across the three
chat treatments.

To summarise, either managerial control or free-form communication impro v es performance,
but only the combination of both beats repeated play of the safe outcome. The only treatment

16 Neither the CH/S-D ( p = .664) nor CH/A-D ( p = .267) treatment impro v es performance signiﬁcantly o v er the

SC-MC treatment.

17 Equi v alent test statistics for treatments CH/S-D and CH/A-D are p = .111 and p = .105, respectively.
18 The average coordination rate in treatment CH/A-D hides a great deal of heterogeneity: nineteen of twenty-seven

groups achieve 100% coordination, but the other eight groups only have an average coordination rate of 69%.

© The Author(s) 2025.

l

D
o
w
n
o
a
d
e
d

f
r
o
m
h

t
t

p
s
:
/
/

i

a
c
a
d
e
m
c
.
o
u
p
.
c
o
m
e

/

j
/

l

/

/

/

a
r
t
i
c
e
1
3
5
6
7
0
1
9
4
2
8
0
5
1
9
9
8
b
y
P
o
n

/

i

i

i

t
i
f
i
c
a
U
n
v
e
r
s
d
a
d
J
a
v
e
r
i
a
n
a
u
s
e
r
o
n
1
9
N
o
v
e
m
b
e
r
2
0
2
5

2025]

managerial leadership

1961

that CH-MC fails to signiﬁcantly outperform is treatment CH/A-D , but this reﬂects the high
variance of outcomes in the latter treatment. Given that treatment CH-MC offers higher average
total surplus and signiﬁcantly lower risk than treatment CH/A-D , it is difﬁcult to argue that
treatment CH-MC is not doing better. The high performance of treatment CH-MC reﬂects both
high coordination rates and a relatively strong ability to use the agents’ information. The next
section digs into why this treatment does well on both dimensions relative to the other treatments,
focusing on how well information is transmitted from agents to managers.

4.2.  Process

This subsection examines the processes underlying the treatment effects described in Section
4.1 with a focus on information transmission in the treatments with managerial control ( SC-MC
and CH-MC ). In both cases managers achieve almost perfect coordination, but only in treatment
CH-MC do managers take advantage of their agents’ information to outperform the babbling
equilibrium. We show that this reﬂects what information is communicated to managers and how
they utilise it.

Unless otherwise noted, data from all rounds are used in this section. The eventual outcomes
in late rounds are strongly affected by the process in early rounds, plus we often compare how
managers behave between early (rounds 1–9) and late (rounds 10–18) rounds.

4.2.1.  Structured communication
Contrary to Hypothesis H3, neither treatment combining delegation with structured communica-
tion ( SC/S-D and SC/A-D ) has a signiﬁcant impact on total surplus relative to treatment NC-D .
The fundamental problem in both cases is a failure to signiﬁcantly impro v e the coordination rate.
In treatment SC/S-D , agents only reach an agreement in 63% of the observations, and the coor-
dination rate falls to 40% without an agreement. Turning to treatment SC/A-D , managers often
fail to give good advice and, even when they do, agents often fail to follow it. Coordination is not
recommended in 15% of managers’ messages, a ﬁgure that impro v es little with experience (12%
in late rounds). Managers often take a conserv ati ve approach when they do advise coordination,
calling for the safe outcome rather than efﬁcient coordination (37% for both if γ (cid:5)= 3). Agents
often fail to coordinate even when recommended to do so (65%), a ﬁgure which impro v es little
even if the safe outcome is suggested (71%).

Coordination is not the problem in treatment SC-MC ; rather, the issue is a lack of efﬁcient
coordination. Two things have to happen in treatment SC-MC for a group to take advantage of
the agents’ information. The agents have to send messages that are informative about the state of
the world, and the manager has to correctly interpret the information contained in their messages.
The theory presented in Section 2 focuses on the ﬁrst issue and concludes that information
transmission will fail since the agents have no incentive to send informative messages. Built into
the theory is an assumption that the messages would be interpreted correctly if informative. In
reality, the messages sent by A1 and A2 contain useful information, but managers make frequent
errors in using messages. Total surplus is about the same as predicted by the babbling equilibrium
(repeated play of the safe outcome) because the advantages from better-than-expected information
transmission are wiped out by errors in using this information.

Table 4 displays the messages sent in treatment SC-MC as a function of the game. The data
from A2 players have been remapped to be from an A1’s point of vie w, allo wing us to combine

© The Author(s) 2025.

l

D
o
w
n
o
a
d
e
d

f
r
o
m
h

t
t

p
s
:
/
/

i

a
c
a
d
e
m
c
.
o
u
p
.
c
o
m
e

/

j
/

l

/

/

/

a
r
t
i
c
e
1
3
5
6
7
0
1
9
4
2
8
0
5
1
9
9
8
b
y
P
o
n

/

i

i

i

t
i
f
i
c
a
U
n
v
e
r
s
d
a
d
J
a
v
e
r
i
a
n
a
u
s
e
r
o
n
1
9
N
o
v
e
m
b
e
r
2
0
2
5

1962

the economic journal

[ august

Table 4. Messa g es as a Function of the Game.

Message (mapped)

1

44
2
19
32
80

1
2
3
4
5

Game (mapped)

2

1
71
27
27
69

3

3
3
155
21
46

4

4
2
5
143
41

5

4
2
8
8
155

Table 5. Mana g er Choices as a Function of Messa g es.

Agent 1 ( μ1 )

1

1.38
1.57
2.42
2.72
2.90

2

–
2.25
2.58
3.00
3.08

Agent 2 ( μ2 )
3

–
–
2.98
3.67
3.52

4

–
–
–
3.71
4.50

5

–
–
–
4.00
4.79

1
2
3
4
5

data for the two roles. 19 If messages are uninformative, as the theory predicts, there should be
no correlation between messages and the game being played. Instead, there is strong positive
correlation ( ρ = 0.34). Play of a babbling equilibrium implies that agents only tell the truth in
20% of the observations, but the observed likelihood of truth-telling is 58%. Even when it is
least beneﬁcial to do so (game 1 for A1 or game 5 for A2), 25% of messages tell the truth. If
truth-telling is solely due to a failure to grasp the strategic value of lying, agents should lie more
as they learn that lying pays. This is not the case, with 58% truth-telling in both rounds 1–9
and rounds 10–18. Purely self-interested agents should al w ays send a message corresponding to
their most preferred outcome. This is the most common type of lie, but 35% of self-serving lies
are partial lies (i.e., the message lies strictly between the true game and the agent’s preferred
outcome). 20

RESULT 6.  The messa g es sent by a g ents are informative. The data are not consistent with

Hypothesis H2(a). Partial lies are common.

On aggregate, managers respond to the information in their agents’ messages. Table 5 shows
the managers’ average choices as a function of the messages sent by the two agents. Cells with
ﬁve or fewer observations are left blank due to the small amount of data, and we delete the
small number of observations (7/486) where the manager did not choose the same action for her
two agents. When the two messages coincide, the manager follows the messages closely (but
not perfectly). When the two messages differ, the manager’s choices generally increase in each
agent’s message (holding the other’s message ﬁxed). The response of managers to messages is
strong and statistically signiﬁcant. 21

19 Recall that outcome 5 is the most desired outcome for A1 and outcome 1 is the most desired outcome for A2. We

remap games for A2: G’ = 6 − G. Messages are remapped in an analogous fashion: μ2 ’ = 6 − μ2 .

20 Self-serving lies are shaded away from the actual game towards the agents’ preferred outcome. There are a small

number of messages (4.1%) that are shaded in the direction of the other agent’s preferred outcome.

21 To establish statistical signiﬁcance, we ran a regression where the dependent variable is the common action chosen
by the manager for her two agents, and the independent variables are the two messages. The parameter estimates are
0.361 and 0.392 with SEs, corrected for clustering at the group level, of 0.051 and 0.049.

© The Author(s) 2025.

l

D
o
w
n
o
a
d
e
d

f
r
o
m
h

t
t

p
s
:
/
/

i

a
c
a
d
e
m
c
.
o
u
p
.
c
o
m
e

/

j
/

l

/

/

/

a
r
t
i
c
e
1
3
5
6
7
0
1
9
4
2
8
0
5
1
9
9
8
b
y
P
o
n

/

i

i

i

t
i
f
i
c
a
U
n
v
e
r
s
d
a
d
J
a
v
e
r
i
a
n
a
u
s
e
r
o
n
1
9
N
o
v
e
m
b
e
r
2
0
2
5

2025]

managerial leadership

1963

Given that agents send useful information and managers respond to their agents’ messages,
why is total surplus no better than in the babbling equilibrium? The problem is that managers
often make choices that seem to be clear errors. For example, when the two agents’ messages
match ( μ1 = μ2 ), they are almost certainly telling the truth (98%). Not surprisingly, it is an
empirical best response to assign both agents the action that corresponds to their messages
( α1 = α2 = μ1 = μ2 ), but managers fail to do so in 18% of these observations. Managers making
this type of error earn an average payoff of 66.6 ECUs, compared with 79.6 ECUs for those
who play the best response. Another common error occurs when A1 and A2 send diametrically
opposed messages by choosing μ1 = 5 and μ2 = 1. Obviously, at least one of the agents is
lying. The safe outcome is the empirical best response to diametrically opposed messages, but
only 35% of managers follow this course of action. This type of error also reduces average total
surplus (66.9 versus 64.7 ECUs). Making matters worse, managers do not learn to a v oid these
errors. The frequency of the ﬁrst type of error falls a bit between the ﬁrst and second halves of
the experiment (19% versus 16%), and the frequency of the second error type increases slightly
from 59% to 70%.

One possible explanation for managerial errors is repeated game effects. Over time, agents
have the opportunity to establish a reputation for truthfulness. Agents potentially might beneﬁt
from building reputations for being truthful and then abandoning them at an opportune moment,
and choices that we identify as managerial mistakes might actually represent optimal strategic
decisions where managers take advantage of what they have learned about agents’ truthfulness
to  increase  their  payoffs.  In  line  with  this,  managers’  choices  are  sensitive  to  the  previous
truthfulness of the agents, responding more strongly to messages from agents who have a history
of being truthful. Ho we ver, there is little indication that agents strategically manipulate their
reputations, and the data strongly suggest that the managerial decisions we have identiﬁed as
errors do indeed reﬂect mistakes rather than strategic choices as part of a reputational equilibrium.
See Online Appendix D for a detailed exploration of these issues.

Managers’ errors explain why total surplus in treatment SC-MC is no better than repeated
play of the safe outcome. To see how well managers could do just by a v oiding obvious errors,
suppose that they adopt the following simple rule: if the agents’ messages agree, choose the
action that matches their messages; otherwise, play the safe outcome. This rule yields an average
total surplus of 73.1, compared to 71.0 for the babbling equilibrium and 70.8 for the average
total surplus actually achieved by managers. The efﬁciency gain from the simple rule is 24.0%,
compared to the −1.6% actually achieved, and it yields signiﬁcantly higher total surplus than
either repeated play of the safe outcome ( p < .001) or the realised total surplus ( p = .002).
Managers could easily outdo the babbling equilibrium, but fail to ef fecti vely use the information
transmitted by their agents.

RESULT 7.  Mana g er s in treatment SC-MC respond to a g ents’ messa g es, but mak e frequent
errors using the information contained in the messa g es, causing their failure to beat repeated
play of the safe outcome.

There  are  three  speciﬁc  things  to  take  away  from  the  various  structured  communication
treatments.  First,  in  all  three  treatments  there  is  room  for  impro v ement.  Ev en  in  treatment
SC-MC , the one case where coordination is not a problem, little advantage is taken of agents’
information. Second, managers are error prone. Whether giving poor advice, being e xcessiv ely
conserv ati ve or failing to grasp obvious information from their agents’ messages, managers

© The Author(s) 2025.

l

D
o
w
n
o
a
d
e
d

f
r
o
m
h

t
t

p
s
:
/
/

i

a
c
a
d
e
m
c
.
o
u
p
.
c
o
m
e

/

j
/

l

/

/

/

a
r
t
i
c
e
1
3
5
6
7
0
1
9
4
2
8
0
5
1
9
9
8
b
y
P
o
n

/

i

i

i

t
i
f
i
c
a
U
n
v
e
r
s
d
a
d
J
a
v
e
r
i
a
n
a
u
s
e
r
o
n
1
9
N
o
v
e
m
b
e
r
2
0
2
5

1964

the economic journal

[ august

Table 6. Frequency of Coding Categories.

Coding category

CH/S-D  CH/A-D  CH-MC

# Messages (manager)
# Messages (agent)
Any suggestion
Suggest safe outcome
Suggest efﬁcient outcome
Agreement to suggestion
Discuss need to coordinate ∗
Discuss fairness ∗
Discuss efﬁciency
Questions about rules of the experiment ∗
Questions about how to play ∗
Explanation ∗
Ask what game is being played (M)
Truthfully reveal game
Lie about game
Contradict (one tells truth, other lies)

N/A
4 .45
93 .1%
54 .1%
48 .4%
78 .9%
6 .4%
31 .8%
39 .4%
11 .7%
10 .9%
21 .7%
N/A
N/A
N/A
N/A

3 .33
3 .72
73 .3%
37 .6%
41 .0%
54 .0%
3 .5%
34 .6%
16 .0%
8 .8%
6 .0%
39 .3%
14 .9%
28 .8%
0 .0%
0 .0%

4 .56
5 .30
90 .7%
60 .6%
57 .7%
67 .9%
4 .0%
43 .9%
37 .7%
15 .0%
14 .2%
32 .3%
19 .4%
68 .4%
3 .4%
2 .5%

Note: Categories marked with an asterisk are cases where the two coders had a Cohen’s
kappa of less than 0.5. These categories were recoded by a third coder.

consistently mak e mistak es that hold down total surplus. Finally, and most importantly, even
though there is no incentive to reveal their information, agents frequently do so. The manner in
which they do so would not surprise anyone familiar with the literature on lie aversion; some
agents tell the truth, but lying is common, including the frequent use of partial lies.

4.2.2.  Free-form chat
To e v aluate the impact of speciﬁc message types in the three chat treatments, we developed a
systematic scheme for coding message content. The goal was to quantify communication that
might be rele v ant for the play of the game, a v oiding prejudgements about which sorts of messages
were important. We employed the methods developed by Cooper and Kagel ( 2005 ). After reading
a random sample of conversations, we developed a coding scheme. Two research assistants then
independently coded the content of all chat conversations. No effort was made to force agreement
among coders. For several categories (marked with asterisks in Table 6 ), the initial two coders
had a Cohen’s kappa of less than 0.5, indicating relatively low agreement. These categories were
recoded by a third coder who was given extensive training in an attempt to improve the quality
of the coding. The research assistants were not informed about any hypotheses the co-authors
had about the messages. They were told that their job was to simply capture what had been said
without concern to the possible effects of what had been said. Coding was binary—a message
line was coded as a 1 if it was deemed to contain the rele v ant category of content and 0 otherwise.
We had no requirement on the number of codings for a message line—a coder could check
as many or few categories as he or she deemed appropriate. A number of the categories also
had sub-categories. For example, the coding scheme has a category for suggesting what actions
should be chosen and sub-categories for speciﬁc suggestions (e.g., suggesting play of the efﬁcient
outcome). A coder was free to check whatever sub-categories they deemed appropriate when the
corresponding category was checked off. Our analysis of the coding uses averages across coders
unless otherwise noted.

Table 6 reports the frequency of the coding categories, broken down by treatment. Some of the
categories are not rele v ant in treatment CH/S-D since the manager cannot send messages, and

© The Author(s) 2025.

l

D
o
w
n
o
a
d
e
d

f
r
o
m
h

t
t

p
s
:
/
/

i

a
c
a
d
e
m
c
.
o
u
p
.
c
o
m
e

/

j
/

l

/

/

/

a
r
t
i
c
e
1
3
5
6
7
0
1
9
4
2
8
0
5
1
9
9
8
b
y
P
o
n

/

i

i

i

t
i
f
i
c
a
U
n
v
e
r
s
d
a
d
J
a
v
e
r
i
a
n
a
u
s
e
r
o
n
1
9
N
o
v
e
m
b
e
r
2
0
2
5

2025]

managerial leadership

1965

hence no ﬁgures are reported. ‘Contradict’ is not a category per se, but instead is a combination
of the preceding two categories that accounts for cases where one agent truthfully reported what
game was being played and the other lied. Table E1 in Online Appendix E provides a fuller
description of the categories. The unit of observation is the entire conversation prior to play in a
single round rather than a single message line within that conversation or messages from only one
individual in the conversation. So, for example, in 93.1% of the pre-play dialogues in treatment
CH/S-D , at least one agent suggested what actions should be chosen.

Before discussing the content of messages, the ﬁrst two lines of Table 6 report the average
number of messages sent per round, broken down by role. Managers send signiﬁcantly more mes-
sages in treatment CH-MC than in treatment CH/A-D ( p = .016), and agents send signiﬁcantly
more messages in treatment CH-MC than in either treatment CH/S-D ( p < .062) or CH/A-D
( p = .005). 22 Recall that total surplus has high variance in treatment CH/A-D . Underlying this,
managers’ behaviour also has high variance in treatment CH/A-D . The three most and the three
least talkative managers come from treatment CH/A-D , and, more generally, the variance in the
frequency of messages sent by managers is higher in treatment CH/A-D than in treatment CH-
MC (SD = 3.17 versus SD = 1.99). Our prediction of relatively high performance in treatment
CH/A-D depended on leadership by managers, but a surprisingly large fraction of managers fails
to provide any leadership.

Turning to message content, recall that treatment CH/S-D signiﬁcantly impro v es total surplus
relative to treatment SC/S-D , the parallel treatment with structured communication. Performance
in treatment SC/S-D is limited by failures to agree on what actions should be used as well as
a tendency to not agree on efﬁcient coordination. Agreements are more frequent in treatment
CH/S-D than in treatment SC/S-D (79% versus 63%). Given that agents almost al w ays coordinate
their actions if an agreement is reached (95%), the higher agreement rate translates into impro v ed
coordination and, by extension, higher total surplus. Treatment CH/S-D does not solve the second
problem that plagued treatment SC/S-D . In cases where the safe and efﬁcient outcomes do not
coincide ( γ (cid:5)= 3), only 34% of agreements in treatment CH/S-D call for play of the efﬁcient
outcome. This differs little from the 32% ﬁgure for treatment SC/S-D . When agents agree on
efﬁcient coordination, they usually follow through (96%), but treatment CH/S-D does no better
than the safe outcome because such agreements occur too rarely.

RESULT 8.  Total surplus is higher in treatment CH/S-D than in treatment SC/S-D because
agr eements ar e much mor e common in tr eatment CH/S-D . This promotes coor dination, but does
not improve the likelihood of efﬁcient coordination.

Total surplus is basically equal in treatments CH/A-D and CH/S-D , but the factors driving
performance differ. Subject to reaching an agreement when γ (cid:5)= 3, agreements on efﬁcient
coordination are more frequent in treatment CH/A-D than in treatment CH/S-D (45% versus
34%) and are usually followed (91%). The problem is that agreements of any kind are much
less frequent in treatment CH/A-D than in treatment CH/S-D (54% versus 79%), 23 and failing
to reach an agreement is associated with lower coordination rates (pooling treatments CH/A-D
and CH/S-D , 71% versus 95%). This does not go away with experience, as the agreement rate

22 For agents, an observation for the statistical test is the average number of messages sent by the pair of agents in a

group. The difference between treatments CH/S-D and CH/A-D is not statistically signiﬁcant ( p = .329).

23 Consistent with the high variance of total surplus, there is more variance in the groups’ ability to reach agreements
for treatment CH/A-D than treatment CH/S-D . Looking at the number of periods (out of eighteen) that a group reaches
an agreement, the SD is 4.53 for treatment CH/A-D versus 2.87 for treatment CH/S-D .

© The Author(s) 2025.

l

D
o
w
n
o
a
d
e
d

f
r
o
m
h

t
t

p
s
:
/
/

i

a
c
a
d
e
m
c
.
o
u
p
.
c
o
m
e

/

j
/

l

/

/

/

a
r
t
i
c
e
1
3
5
6
7
0
1
9
4
2
8
0
5
1
9
9
8
b
y
P
o
n

/

i

i

i

t
i
f
i
c
a
U
n
v
e
r
s
d
a
d
J
a
v
e
r
i
a
n
a
u
s
e
r
o
n
1
9
N
o
v
e
m
b
e
r
2
0
2
5

1966

the economic journal

[ august

l

D
o
w
n
o
a
d
e
d

f
r
o
m
h

t
t

p
s
:
/
/

i

a
c
a
d
e
m
c
.
o
u
p
.
c
o
m
e

/

j
/

l

/

/

/

a
r
t
i
c
e
1
3
5
6
7
0
1
9
4
2
8
0
5
1
9
9
8
b
y
P
o
n

/

i

i

i

t
i
f
i
c
a
U
n
v
e
r
s
d
a
d
J
a
v
e
r
i
a
n
a
u
s
e
r
o
n
1
9
N
o
v
e
m
b
e
r
2
0
2
5

Fig. 1. Distribution of Rounds in which the Game is Revealed.

falls slightly from 58% to 50% between the ﬁrst and second halves of the experiment. The result
is an odd combination of lower total surplus and more efﬁcient coordination.

In treatment CH-MC , coordination per se is trivial; the question is whether the manager can
achieve efﬁcient coordination, given that she cannot observe the state of the world. A central
ﬁnding of our work is that managers in treatment CH-MC get remarkably good information
about what game is being played, making efﬁcient coordination possible. In most cases (68%),
at least one agent truthfully reveals the game being played and only rarely (3%) does an agent
lie about the game. Rather than falling, these ﬁgures impro v e slightly with experience from 65%
and 5% in rounds 1–9 to 72% and 2% in rounds 10–18.

Information transmission is far cleaner in treatment CH-MC than in treatment SC-MC. This
can be seen in Figure 1 . Deﬁne the game as being ‘revealed’ to the manager in a round if at least
one agent tells the truth without contradiction from the other. An observation in Figure 1 is the
number of rounds o v er the entire session where the game was revealed for a group. Figure 1 shows
the distribution of how often agents in a group revealed the game. For example, in treatment
SC-MC , the game was revealed in 0–3 rounds for 22% of the groups. The distribution is shifted
to the right for treatment CH-MC relative to treatment SC-MC . For 89% of groups in treatment
SC-MC , the game is revealed for less than half of the rounds. In treatment CH-MC , the game is
revealed for more than half of the rounds in 78% of the groups.

Managers get some useful information in treatment SC-MC (see Section 4.2.1 ), but it often
involves conﬂicting reports (69%) that are difﬁcult to interpret. On top of this, managers in treat-

© The Author(s) 2025.

2025]

managerial leadership

1967

Table 7. Frequency of Truth-Telling and Lying.

SC-MC

CH-MC

Game (remapped)

1
2
3
4
5

Truth

24.9%
36.4%
68.0%
73.3%
87.6%

Lie

75.1%
63.6%
32.0%
26.7%
12.4%

Truth

46.6%
42.8%
43.0%
50.1%
47.1%

Lie

2.5%
3.1%
2.2%
1.9%
0.3%

ment SC-MC often mak e mistak es extracting information from agents’ messages. In treatment
CH-MC , managers receive some report about the game in 69% of observations. For 95% of these
cases, the y receiv e a truthful report without contradiction. Almost al w ays, managers in treatment
CH-MC either have no information, and therefore do not face an information extraction problem,
or have unambiguous information that makes information extraction trivial.

The high quality of information transmission in treatment CH-MC is enormously important
for efﬁciency. When the safe and efﬁcient outcomes do not coincide ( γ (cid:5)= 3), the frequency of
efﬁcient coordination rises from 19% when neither agent truthfully reveals the game to 52% if at
least one tells the truth. 24 The frequency of efﬁcient coordination changes little when one agent
tells the truth and the other lies (53%), albeit based on very fe w observ ations. The truth wins in
this environment.

RESULT 9.  Better transmission of the a g ents’ information occurs in treatment CH-MC than
in treatment SC-MC . This happens because a g ents frequently tell the truth, almost never lie
and rarely confront mana g er s with conﬂicting reports. Truth-telling is strongly associated with
efﬁcient coordination.

Accurate transmission also takes place in treatment CH/A-D . Agents are far less likely to
report what game is being played than in treatment CH-MC , but al w ays tell the truth when
they do so. The lack of lies is less surprising for treatment CH/A-D than treatment CH-MC :
there is little incentive to lie since the manager does not control what actions are chosen. Like
treatment CH-MC , accurate transmission promotes efﬁcient coordination in treatment CH/A-D .
The frequency of efﬁcient coordination is 51% when the game is truthfully reported (and γ (cid:5)=
3), compared with 33% otherwise.

The nature of truth-telling strongly differs between treatments CH-MC and SC-MC . Most
agents in treatment SC-MC mix between telling the truth and lying: 69% both tell the truth in at
least a third of the rounds and lie in at least a third of the rounds. There are only two agents that
never lie and none that never tell the truth. Partial lying is common and agents are strategic about
telling the truth, doing so more often when it is to their beneﬁt to be believed. This can be seen
in Table 7 . As in Table 4 , the games have been remapped for the A2 role so all observations are
from the point of view of A1 (i.e., outcome 1 is the worst outcome and outcome 5 is the best).
Agents are most likely to lie when the efﬁcient outcome would be worst for them ( γ = 1), and
most likely to be truthful when it would be best for them ( γ = 5).

24 It may seem surprising that the rate of efﬁcient coordination is not closer to zero when there is not a truthful report
and γ (cid:5)= 3. In 87% of cases with efﬁcient coordination and no truthful report, there is a suggestion that the efﬁcient
equilibrium should be played. These suggestions may serve as an indirect method of revealing the game, making a direct
report unnecessary.

© The Author(s) 2025.

l

D
o
w
n
o
a
d
e
d

f
r
o
m
h

t
t

p
s
:
/
/

i

a
c
a
d
e
m
c
.
o
u
p
.
c
o
m
e

/

j
/

l

/

/

/

a
r
t
i
c
e
1
3
5
6
7
0
1
9
4
2
8
0
5
1
9
9
8
b
y
P
o
n

/

i

i

i

t
i
f
i
c
a
U
n
v
e
r
s
d
a
d
J
a
v
e
r
i
a
n
a
u
s
e
r
o
n
1
9
N
o
v
e
m
b
e
r
2
0
2
5

1968

the economic journal

[ august

These patterns change in treatment CH-MC . Mixing between truth-telling and lying is largely
non-existent. There are forty-seven subjects in the agent role who send at least one message
reporting what game is being played, averaging 9.8 reports over the course of eighteen rounds.
Thirty-six of forty-seven reporting agents never lie and another ﬁve of forty-seven only lie once.
None lie in more than 35% of their reports. Unlike treatment SC-MC , there are no agents that
both tell the truth in at least a third of the rounds and lie in at least a third of the rounds. Subjects
mix, but it is almost entirely between telling the truth and not reporting. Subject to lying, partial
lies are common (43% of lies), but in absolute terms partial lies are necessarily rare, given the low
o v erall rate of lying. Returning to Table 7 , truth-telling is not sensitive to incentives. 25 Telling
the truth is about as likely when it is most advantageous for an agent to lie (46.6% in game 1) as
when it is most advantageous to tell the truth (47.1% in game 5).

RESULT 10. The frequency of truth-telling, lying and non-reports in treatment CH-MC is not
sensitive to what game is being played. Unlike treatment SC-MC , the patterns of truth-telling in
treatment CH-MC do not parallel what is typically reported in the literature on lying.

The different pattern of truth-telling in treatment CH-MC suggests that the psychological
mechanism underlying truth-telling is altered by the real-time, asynchronous communication
available in this treatment. One possible reason for infrequent lying in treatment CH-MC is that
agents feel guiltier about lying to their manager when they have been directly asked for a report.
Ho we ver, it is surprisingly rare for managers to request reports about what game is being played
(19%), and the fraction of lies increases from 2% to 9% when a report is requested. Another
possibility is that agents a v oid lying because they are concerned about being ‘f act-check ed’. In
both treatments SC-MC and CH-MC , the manager knows ex post when an agent has lied, but
in treatment CH-MC it is possible for the other agent to call out a liar in real time. Indeed, in
40% of the observations where an agent lies, the other agent corrects them. 26 It may be more
embarrassing to be actively called out as a liar than to merely be revealed as a liar. 27 We explore
both of these potential explanations in the follow-up treatment reported in Section 5 below.

Failing to report what game is being played could be considered a ‘soft’ lie. Ho we ver, agents
that do not report the game usually have little reason to do so. If one agent has truthfully revealed
the game, there is little need for the other to reiterate this information. In line with this, the other
agent has reported truthfully in 44% of the cases where an agent does not make a report. It is
also pointless to report what game is being played if the safe outcome will be chosen regardless.
Consider cases where the safe and efﬁcient outcomes could be distinguished in the previous
round ( γ (cid:5)= 3). If the safe outcome was played in the previous round, neither agent makes a
report for the current round in 41% of the observations; this makes sense if agents expect the
manager to choose the safe outcome regardless of any new information. By contrast, if agents
expect the efﬁcient outcome to be played then they have an incentive to guide the manager’s
decision by reporting the current game. Indeed, when the efﬁcient outcome was chosen in a
previous round with γ (cid:5)= 3, neither agent reports for only 16% of the observations. Overall, 78%

25 Table 7 reports the frequency that an individual agent reports truthfully at some point during the pre-play commu-
nication. This differs from the ﬁgure reported under ‘Truthfully reveal game’ in Table 6 , which shows the frequency that
at least one of the two agents reports truthfully at some point during the pre-play communication.

26 This is different from the ﬁgure reported as ‘Contradict’ in Table 6 , which measures cases where one agent reported
truthfully and the other lied. The 40% ﬁgure refers to ‘fact-checking’ where one agent explicitly corrects a false report
by the other (e.g., ‘It is game 3’; ‘No, it is really game 2’).

27 F act-checking helps e xplain why the frequenc y of efﬁcient coordination remains high when one agent tells the truth

and the other lies, since fact-checking gives the manager guidance about which agent to believe.

© The Author(s) 2025.

l

D
o
w
n
o
a
d
e
d

f
r
o
m
h

t
t

p
s
:
/
/

i

a
c
a
d
e
m
c
.
o
u
p
.
c
o
m
e

/

j
/

l

/

/

/

a
r
t
i
c
e
1
3
5
6
7
0
1
9
4
2
8
0
5
1
9
9
8
b
y
P
o
n

/

i

i

i

t
i
f
i
c
a
U
n
v
e
r
s
d
a
d
J
a
v
e
r
i
a
n
a
u
s
e
r
o
n
1
9
N
o
v
e
m
b
e
r
2
0
2
5

2025]

managerial leadership

1969

Table 8. Probit Regressions: Effects of Chat on Outcomes.

Treatment

CH/S-D

CH/A-D

Dependent variable

Agreement

Discuss need to coordinate

Discuss fairness

Discuss efﬁciency

Questions about rules

Questions about play

Explanation

Ask what game

Truthfully reveal game

Lie about game

Coordination
0 .108 ∗∗∗
(0 .021)
−0 .036
(0 .048)
0 .013
(0 .024)
0 .011
(0 .026)
−0 .055 ∗
(0 .030)
0 .033
(0 .032)
−0 .041
(0 .031)

Efﬁcient
coordination
0 .217 ∗∗∗
(0 .061)
0 .203
(0 .173)
−0 .265 ∗∗∗
(0 .080)
0 .253 ∗∗∗
(0 .066)
−0 .061
(0 .139)
−0 .109
(0 .149)
0 .056
(0 .119)

Coordination
0 .114 ∗∗∗
(0 .025)
0 .032
(0 .068)
−0 .004
(0 .024)
0 .050
(0 .038)
0 .218 ∗∗∗
(0 .057)
−0 .060
(0 .053)
−0 .077 ∗∗
(0 .031)
−0 .055 ∗∗
(0 .023)
0 .023
(0 .028)

Efﬁcient
coordination
0 .184 ∗∗
(0 .082)
0 .079
(0 .231)
−0 .087
(0 .088)
0 .262 ∗∗∗
(0 .098)
0 .112
(0 .114)
0 .161
(0 .167)
−0 .166 ∗
(0 .086)
−0 .121
(0 .083)
0 .205 ∗
(0 .118)

CH-MC

Efﬁcient
coordination

0 .045
(0 .079)
−0 .089
(0 .190)
−0 .101
(0 .092)
0 .111
(0 .088)
−0 .165
(0 .105)
−0 .117
(0 .152)
0 .035
(0 .099)
0 .121
(0 .084)
0 .295 ∗∗∗
(0 .086)
−0 .032
(0 .205)

Note : All models include 459 observations. Marginal effects are reported. SEs (in parentheses) are corrected for clustering
at the group level. All regressions include controls for the game being played, a dummy for late rounds and lagged
outcomes. Coefﬁcients for these variables are not reported to save space. ∗∗∗, ∗∗, ∗ Signiﬁcance at the 1%, 5% and 10%
levels using two-tailed tests.

of non-reports occur in cases where either the other agent has told the truth or the safe outcome
is used. Non-reports largely do not appear to be a form of deception.

4.2.3.  The effect of chat content
None of the preceding establishes a causal relationship between the content of pre-play com-
munication and outcomes. Establishing causality is tricky because outcomes and the content
of communication may both depend on lagged outcomes. Table 8 shows the results of probit
regressions that control for lagged outcomes. Separate regressions are shown for each of the three
treatments with chat. The dependent variable is either a dummy for coordination ( α1 = α2 ) or
efﬁcient coordination ( α1 = α2 = G). First-round data are dropped to allow the use of lagged
variables. There is no regression for coordination in treatment CH-MC because there was 100%
coordination following round 1.

As independent variables, all regressions include dummies for lagged outcomes (coordination
failure, safe coordination and efﬁcient coordination with other coordination as the omitted cat-
egory), game dummies and a dummy for late rounds (rounds 10–18). These are not reported to
save space in the table. All regressions include the average coding for the categories reported in
Table 6 with the following exceptions. The categories for ‘Lie about game’ and ‘Contradict’ are
highly collinear, so we only include the former (we felt that this was the more interesting of the
two). There were no cases of lies in treatment CD/A-D , so this variable is dropped. Including
suggestions about what actions (e.g., suggest efﬁcient outcome) to play makes the regressions
circular (subjects do what they say they should do), so these categories are omitted. We report
marginal effects. SEs are corrected for clustering at the group level.

© The Author(s) 2025.

l

D
o
w
n
o
a
d
e
d

f
r
o
m
h

t
t

p
s
:
/
/

i

a
c
a
d
e
m
c
.
o
u
p
.
c
o
m
e

/

j
/

l

/

/

/

a
r
t
i
c
e
1
3
5
6
7
0
1
9
4
2
8
0
5
1
9
9
8
b
y
P
o
n

/

i

i

i

t
i
f
i
c
a
U
n
v
e
r
s
d
a
d
J
a
v
e
r
i
a
n
a
u
s
e
r
o
n
1
9
N
o
v
e
m
b
e
r
2
0
2
5

1970

the economic journal

[ august

We  have  stressed  the  importance  of  agreements  for  achieving  coordination  in  treatments
CH/S-D and CH/A-D , and the re gressions pro vide additional evidence of this. In both treatments,
there is a strong positive relationship between reaching an agreement and either coordination or
efﬁcient coordination. Agreements play little role in treatment CH-MC . The manager is a dictator
in this treatment and does not need the agents to agree on a course of action. The regressions
also support our observation that efﬁcient coordination is likelier in both treatments CH/A-D and
CH-MC when at least one agent reports truthfully, with the effect being stronger in the latter case.
Lies, on the other hand, have little effect. 28 It is interesting to note that discussing efﬁciency has
a strong positi ve ef fect in treatments CH/S-D and CH/A-D , but not in treatment CH-MC . Once
again, this illustrates the importance of control. Managers can impose efﬁcient coordination
in treatment CH-MC without needing buy-in from their agents. Discussion of fairness plays
an important role in treatment CH/S-D , making the safe equilibrium more common, but plays
surprisingly little role in the other two treatments. Perhaps it is difﬁcult to argue persuasively that
the safe outcome is fair when it harms the manager (and the manager has a voice).

Modifying the regressions in Table 8 lets us make an important point about the ef fecti veness of
managers in treatment CH/A-D . Studies of leadership in experimental economics typically focus
on the avera g e effect of having a leader, concluding that leadership does not matter if the average
effect is zero. This ignores heterogeneity. The average effect of giving the manager an active role
in treatment CH/A-D is basically zero, but no group gets the average manager. Each group gets
a speciﬁc individual who may be a better or worse leader than average. Outcomes in treatment
CH/A-D are highly variable, suggesting that some managers are better than others. Indeed, the
data indicate that how the manager communicates in treatment CH/A-D affects outcomes, and
good managers are better communicators than their less successful peers.

To reach this conclusion, we ﬁrst run a probit regression analogous to those reported in Table 8 .
This regression analyses the effect of communication by mana g er s in treatment CH/A-D on the
likelihood of efﬁcient coordination. The independent variables of interest are the average coding of
messages sent by the manager. The regressions control for a number of factors: lagged outcomes,
the game being played and a dummy for late rounds. We ﬁnd that efﬁcient coordination is less
(more) likely if the manager suggests the safe (efﬁcient) equilibrium. These effects are large
(est. = −0.408 for suggesting the safe equilibrium, and est = 0.370 for suggesting the efﬁcient
equilibrium), and both effects are easily signiﬁcant at the 1% level ( p = .004 and p < .001,
respectively). This is not a case where the result is circular, as the manager does not directly
control the outcome in treatment CH/A-D ; the only thing a manager can do in this treatment is
give advice.

The preceding results establish that the manager’s messages affect outcomes even in the
absence of direct control. This suggests that successful managers send better messages than other
managers, which is indeed the case. To see this, divide managers into thirds by the average
payof fs they achie ve and label the top third as ‘good’ managers. To create an index of suggestion
quality, a manager gets a score of + 1 if they suggest the efﬁcient equilibrium only, −1 if they
suggest the safe equilibrium only and 0 if they suggest either both or neither. We then regress the
suggestion quality on whether the group had a good manager, with controls for the game being
played and a late period dummy. The effect of having a good manager is large (est. = 0.179),
and statistically signiﬁcant ( p = .049). To summarise, good managers are more likely to make
good suggestions, and groups that receive good suggestions from their manager are more likely to
28 This remains true if lies are restricted to cases where the false report was not contradicted in any way. The parameter

estimate for uncontradicted lies is −0.072 with an SE of 0.398.

© The Author(s) 2025.

l

D
o
w
n
o
a
d
e
d

f
r
o
m
h

t
t

p
s
:
/
/

i

a
c
a
d
e
m
c
.
o
u
p
.
c
o
m
e

/

j
/

l

/

/

/

a
r
t
i
c
e
1
3
5
6
7
0
1
9
4
2
8
0
5
1
9
9
8
b
y
P
o
n

/

i

i

i

t
i
f
i
c
a
U
n
v
e
r
s
d
a
d
J
a
v
e
r
i
a
n
a
u
s
e
r
o
n
1
9
N
o
v
e
m
b
e
r
2
0
2
5

2025]

managerial leadership

1971

achie ve ef ﬁcient coordination. Two points can be taken from this. (1) The varying group outcomes
in treatment CH/A-D are not a matter of pure chance, but instead reﬂect differing performance
by their managers. (2) The avera g e effect of letting a manager give advice in treatment CH/A-D
is small, but this is not because advice given by managers does not affect outcomes. Rather, on
aggregate, the positive effect of good managers is offset by the ne gativ e effect of bad managers.

5.  Extended Communication

Performance in treatment CH-MC is unambiguously better than in treatment SC-MC . Underly-
ing this, information transmission from agents to managers is unambiguously better in treatment
CH-MC , driven by a striking reduction in lying by agents. This raises an obvious question: what
feature(s) of treatment CH-MC leads to the low frequency of lies?

The free-form communication process in treatment CH-MC allows for a number of possi-
bilities that are not available in treatment SC-MC . (1) Agents can be f act-check ed in real time.
(2) Managers can request reports about the game as well as requesting that agents tell the truth.
(3) Agents can tell managers that they reported truthfully. (4) Because communication is asyn-
chronous, an agent can view the other agent’s report before making their own and alter their report
after seeing the other agent’s report. (5) Agents have the option of not making a report about what
game is being played. (6) The free-form nature of chat per se might affect behaviour. Subjects
must generate message content endogenously, can use any message rather than the limited set
available with structured communication and can frame messages in ways that subtly change
their meaning from what is expressed by the pre-speciﬁed messages.

There is ample evidence from other papers that the sixth item listed abo v e, free-form commu-
nication per se, changes behaviour, generally leading to more prosocial outcomes. 29 Ho we ver, a
priori, the ﬁrst ﬁve differences between treatments CH-MC and SC-MC could also lead to less
lying and can be implemented within structured communication. Treatment CH-MC does not
pro vide conclusiv e evidence that an y of these differences caused reduced lying. We therefore
de veloped a follo w-up treatment to e xplore whether an y of the ﬁv e differences other than free-
form communication reduce lying. Like treatment SC-MC , subjects only had a limited number
of messages available. Unlike treatment SC-MC , structured communication in the follow-up
treatment captures features (1) to (5) listed abo v e: fact-checking of lies was possible, managers
could ask for (truthful) reports about the game being played, agents could assert that they told the
truth, reports were asynchronous and reports were not mandatory. We included all ﬁve of these
differences, regardless of whether the CH-MC data suggested much impact, to give structured
communication the best possible chance to reduce lying. If there is little impact with all of
these differences present, it strongly suggests that free-form communication per se is a necessary
ingredient for reduced lying and impro v ed information transmission in treatment CH-MC .

Since the ability of subjects to communicate is extended relative to the SC-MC treatment,
we refer to the new treatment as the extended communication and mana g erial control ( EC-MC )
treatment. Communication w ork ed as follows. After the tw o agents observed which game was
being played, there was a 45 second period in which all three players could communicate. This
was done by pressing buttons containing prespeciﬁed messages. These messages could be sent as
many times as a player desired. Once a message was sent, it was displayed in a message window
on the screens of all three players along with the identity of the sender. The manager could send

29 See Brandts et al. ( 2019 ) for a summary of the evidence.

© The Author(s) 2025.

l

D
o
w
n
o
a
d
e
d

f
r
o
m
h

t
t

p
s
:
/
/

i

a
c
a
d
e
m
c
.
o
u
p
.
c
o
m
e

/

j
/

l

/

/

/

a
r
t
i
c
e
1
3
5
6
7
0
1
9
4
2
8
0
5
1
9
9
8
b
y
P
o
n

/

i

i

i

t
i
f
i
c
a
U
n
v
e
r
s
d
a
d
J
a
v
e
r
i
a
n
a
u
s
e
r
o
n
1
9
N
o
v
e
m
b
e
r
2
0
2
5

1972

the economic journal

[ august

Table 9. Comparison of MC Treatments, Rounds 10–18.

Total surplus
Efﬁciency gain
% Coordinate
% Efﬁcient subject to coordinate
Game revealed (group)
Truth-telling (individual)
Lie (individual)

SC-MC

EC-MC

CH-MC

71 .7
6 .5%
99 .6%
45 .9%
30 .9%
58 .4%
41 .6%

71 .3
−4 .9%
96 .7%
55 .7%
49 .8%
63 .6%
28 .6%

75 .2
44 .3%
100 .0%
61 .7%
77 .4%
48 .3%
1 .0%

two possible messages: ‘What game are we playing?’ and ‘Please tell me the truth.’ The agents
could send four possible messages: ‘It is game [agent entered a game number]’, ‘I am telling the
truth’, ‘The other agent is telling the truth’ and ‘The other agent is lying’.

The EC-MC treatment allows for the ﬁrst ﬁve aforementioned mechanisms. If one or more of
these mechanism(s) leads to reduced lying and, by extension, improved information transmission,
we should expect to see similar results in treatment EC-MC as in treatment CH-MC . Ho we ver,
if free-form communication itself is the critical ingredient, little difference should be observed
between treatments SC-MC and EC-MC .

Three sessions of treatment EC-MC were conducted at LINEEX with the same subject pool
and basic procedures as the main treatments. Each session contained nine groups, giving twenty-
seven independent observations, like the other treatments.

Table 9 reports the main results for the EC-MC treatment, and compares them with results from
the other two treatments with managerial control. Total surplus and efﬁciency gains are slightly
lower for treatment EC- MC than treatment SC-MC , rather than higher as expected, although the
difference in total surplus is not statistically signiﬁcant ( p = .833). Like treatment SC-MC , total
surplus in treatment EC-MC is not signiﬁcantly better than the babbling equilibrium ( p = .356)
and is signiﬁcantly lower than in treatment CH-MC ( p = .028). In terms of total surplus or
efﬁciency, there is no evidence that the extra communication options afforded by treatment
EC-MC affects outcomes relative to treatment SC-MC .

Messages are used frequently in treatment EC-MC . Subjects almost al w ays send at least one
message in a round (95.2% in rounds 10–18), and send an average of 5.9 messages per round
in rounds 10–18. 30 Looking at the third line from the bottom of Table 9 , treatment EC-MC
increases the probability that the game is revealed (at least one agent tells the truth without
contradiction from the other) relative to treatment SC-MC , albeit less than half as much as
treatment CH-MC (18.9% versus 46.5%). The increase o v er treatment SC-MC is signiﬁcant
( p = .023), although the probability of revealing the game is still signiﬁcantly lower than in
treatment CH-MC ( p = .002). These differences in information transmission reﬂect decreased
lying rather than increased truth-telling. The likelihood that an agent reveals the truth is roughly
the same for rounds 10–18 across the three treatments, but the likelihood of lying decreases
as richer communication becomes possible (41.6% for treatment SC-MC ; 28.6% for treatment
EC-MC ; 1.0% for treatment CH-MC ). When the true game is not revealed in treatments SC-MC
and EC-MC , it is usually because one agent tells the truth, but is contradicted by the other agent
telling a lie (79.8% for treatment SC-MC ; 83.6% for treatment EC-MC ). This rarely happens in

30 Agents sent more than twice as many messages per round as managers (7.4 versus 3.1) in rounds 10–18.

© The Author(s) 2025.

l

D
o
w
n
o
a
d
e
d

f
r
o
m
h

t
t

p
s
:
/
/

i

a
c
a
d
e
m
c
.
o
u
p
.
c
o
m
e

/

j
/

l

/

/

/

a
r
t
i
c
e
1
3
5
6
7
0
1
9
4
2
8
0
5
1
9
9
8
b
y
P
o
n

/

i

i

i

t
i
f
i
c
a
U
n
v
e
r
s
d
a
d
J
a
v
e
r
i
a
n
a
u
s
e
r
o
n
1
9
N
o
v
e
m
b
e
r
2
0
2
5

2025]

managerial leadership

1973

treatment CH-MC (9.1%), because agents who do not tell the truth typically do not report what
game is being played rather than lying. 31

Given that information transmission is better in treatment EC-MC than treatment SC-MC ,
why is the total surplus no higher? There is, as one would expect, a strong positive relationship
in rounds 10–18 between total surplus in treatment EC-MC and whether the game is revealed by
the agents or not (74.1 versus 68.5). Ho we ver, this relationship is stronger in treatment SC-MC
(78.4 versus 68.7). To understand why, deﬁne a mistake by the manager as either a failure to
coordinate or coordinating at an action that does not lie at or between efﬁcient coordination and
the safe equilibrium. 32 Subject to the game being revealed, managers make a mistake in 14.9%
of observations for treatment EC-MC versus 1.3% for treatment SC-MC . Thus, the beneﬁts of
better information are largely balanced out by more frequent managerial mistakes. 33

We previously outlined six differences between treatments CH-MC and SC-MC , with ﬁve
of these also being operational in treatment EC-MC . Are any of these differences responsible
for reduced lying in treatment EC-MC relative to treatment SC-MC ? The ﬁrst difference is the
possibility of fact-checking. Fact-checking refers to cases where an agent who lies about what
game is being played is accused of lying by the other agent. As in treatment CH-MC , this is
common in treatment EC-MC . In rounds 10–18, if an agent lies in their initial report, they are
f act-check ed 79.4% of the time. The problem is that being f act-check ed has no immediate effect
on truth-telling; no agent who is f act-check ed responds by changing their report to the truth.
Instead, it is very common for a f act-check ed agent to double down by making additional reports
that are also lies (90.7%). 34 Fact-checking does have a small delayed effect. If an individual lies
and gets f act-check ed, they are somewhat less lik ely to lie in the next game than if they are not
called on their lie (37.1% versus 45.2%). Ho we ver, based on a probit controlling for the game
being played and period, this effect is not statistically signiﬁcant ( p = .150). We previously
speculated that fear of fact-checking led to reduced lying in treatment CH-MC , but the EC-MC
data provide little evidence in fa v our of this mechanism.

The second difference is the possibility that managers can request truthful reports. This differ-
ence explains much of the impro v ed transmission of information in treatment EC-MC relative
to treatment SC-MC . Consider whether the manager either asks for a report or asks agents to tell
the truth prior to any a g ent reporting what game is being played . 35 Both types of messages are
common in rounds 10–18; managers ask for a report in 80.2% of rounds and ask for the truth
in 32.9% of rounds. Asking for a report has no impact on the likelihood that the game being
played is revealed (50.0% versus 49.7%), but asking for the truth does have a substantial effect
(44.2% versus 61.3%). The latter effect could be biased downwards if requests for truth-telling
are more likely when agents have lied in past periods. To control for this possibility, we run
a probit regression where the dependent variable is whether the game was revealed truthfully.
The independent variables are dummy variables for whether the manager had requested a report,

31 For 89.1% of cases where the game is not revealed in treatment CH-MC for rounds 10–18, neither agent reported

what game was being played.

32 F or e xample, in game 1, either not coordinating or coordinating at 4 or 5 are considered mistakes by the manager.
33 Treatment CH-MC lies somewhere between with a mistake rate of 9.0% when the game is revealed. If managers
never made mistakes when the game was revealed, instead playing the safe equilibrium, average total surplus across
rounds 10–18 would have been 71.7 in treatment SC-MC , 73.0 in treatment EC-MC and 76.0 for treatment CH-MC .
Without mistakes, treatment EC-MC would do a bit better than treatment SC-MC , but not as well as treatment CH-MC .
34 It was generally very rare for agents to change an initial report. For rounds 10–18, this only occurred for 0.9% of

observations where an initial report was made.

35 As documented below, agents rarely change their reports after an initial report. We therefore focus on what is said

before reports are made, as requests after reports are made can have little effect.

© The Author(s) 2025.

l

D
o
w
n
o
a
d
e
d

f
r
o
m
h

t
t

p
s
:
/
/

i

a
c
a
d
e
m
c
.
o
u
p
.
c
o
m
e

/

j
/

l

/

/

/

a
r
t
i
c
e
1
3
5
6
7
0
1
9
4
2
8
0
5
1
9
9
8
b
y
P
o
n

/

i

i

i

t
i
f
i
c
a
U
n
v
e
r
s
d
a
d
J
a
v
e
r
i
a
n
a
u
s
e
r
o
n
1
9
N
o
v
e
m
b
e
r
2
0
2
5

1974

the economic journal

[ august

requested the truth, and the lagged dependent variable. The regression also controls for the round
and game being played. SEs are clustered at the group level. The estimated marginal effect of
requesting the truth is large (est. = 0.188) and signiﬁcant ( p = .044).

Two things are worth noting at this point. First, the theory of guilt aversion (Charness and
Dufwenberg, 2006 ) suggests a mechanism by which requests for truthful reports will reduce
lying. Under guilt aversion, an agent’s willingness to lie is sensitive to their (second-order)
beliefs about whether the manager believ es the y will tell the truth. If requesting the truth implies
that agents believe the manager believes the truth will be told, agents will feel guiltier about
lying. If agents are guilt averse, requesting the truth will reduce lying, as is observed in treatment
EC-MC . Second, the preceding cannot be the mechanism behind reduced lying in treatment
CH-MC because there are virtually no requests for truthful reporting. Our coding scheme for
treatment CH-MC did not even include a category for requesting the truth because it is so rare.
To the extent that treatment EC-MC reduces lying, it appears to do so via a different mechanism
than treatment CH-MC .

A third difference between treatments EC-MC and SC-MC is that agents can tell managers
that the y hav e reported truthfully. This is a common message type: 61.8% of agents who send a
report in rounds 10–18 also send a claim that they are being truthful. The data give no evidence
that claiming to be truthful is associated with a reduced likelihood of lying. Instead, agents who
claim to have told the truth in rounds 10–18 are slightly more likely to lie (27.5% versus 33.2%),
subject to making a report about what game is being played.

The fourth difference between treatments EC-MC and SC-MC is that the asynchronous nature
of reporting makes it possible for an agent to view the other agent’s report before reporting, and
possibly alter their report. There appears to be an order effect in the data: limiting the data
to agents who make a report, agents who report ﬁrst are more likely to initially tell the truth
than laggards (75.7% versus 61.7%) in rounds 10–18. 36 Ho we ver, there is a strong relationship
between what game is being played and when agents report: an agent is almost twice as likely
to report ﬁrst when it is their most preferred game (66.7%) versus their least preferred game
(37.9%). In other words, they are more likely to report quickly in situations where they want to
tell the truth. Running a probit that controls for the game being played and period, the effect of
reporting ﬁrst on truth-telling is not statistically signiﬁcant ( p = .395). Another possibility is that
laggards respond to whether the ﬁrst report is true. This appears weakly true in the raw data, but
in an odd fashion: laggards are more likely to initially lie if the ﬁrst agent to report was truthful
rather than a lie (33.3% versus 27.8%), but also more likely to not make any report (19.8% versus
5.6%). This again is biased by the strong relationship between truth-telling and what game is
being played. The results look more sensible in a probit where the dependent variable is whether
a laggard lies and controls are included for the game being played and the period. A truthful
ﬁrst report signiﬁcantly reduces the probability the laggard initially lies—the estimated marginal
effect is −0.244 ( p = .047). Digging further, we ran a multinomial logit with lying as the base
category. A truthful ﬁrst report makes laggards signiﬁcantly more likely to not report ( p = .028)
and weakly (and not signiﬁcantly) more likely to initially tell the truth ( p = .120). In other words,
laggards lie less when the ﬁrst report was true, but this consists more of not reporting rather than
telling the truth.

36 There are thirteen cases where the two agents were recorded as ﬁrst reporting simultaneously (time is reported in
second increments). In these cases, we include both agents as reporting ﬁrst. If we limit the data to cases where one agent
is unambiguously ﬁrst, the percentage of truthful ﬁrst reports increases slightly to 77.3%.

© The Author(s) 2025.

l

D
o
w
n
o
a
d
e
d

f
r
o
m
h

t
t

p
s
:
/
/

i

a
c
a
d
e
m
c
.
o
u
p
.
c
o
m
e

/

j
/

l

/

/

/

a
r
t
i
c
e
1
3
5
6
7
0
1
9
4
2
8
0
5
1
9
9
8
b
y
P
o
n

/

i

i

i

t
i
f
i
c
a
U
n
v
e
r
s
d
a
d
J
a
v
e
r
i
a
n
a
u
s
e
r
o
n
1
9
N
o
v
e
m
b
e
r
2
0
2
5

2025]

managerial leadership

1975

A ﬁnal difference between treatments EC-MC and SC-MC is that agents are required to make
a report on what game was being played in treatment SC-MC , but not in treatment EC-MC .
Agents usually still report what game is being played (92% in rounds 10–18). It is not random
when non-reports occur. Almost al w ays when one agent reports and the other does not, the agent
that reports tells the truth (97%). In 63% of these cases, the agent who does not report sends a
message saying that the other agent has told the truth. In other words, many subjects who do not
explicitly report tell the truth implicitly. Non-reporting does not seem to matter much, except to
the extent that Table 9 slightly under-reports the extent of truth-telling by individuals. 37

To recapitulate, we identiﬁed six differences between treatments CH-MC and SC-MC , any
of which might explain why lying is less frequent and information transmission is better in
treatment CH-MC . Treatment EC-MC allows for ﬁve of these differences, but generates less
than half of the effect of treatment CH-MC , relative to treatment SC-MC , on the likelihood
that an agent lies or that the game is revealed. One factor that explains decreased lying in
treatment EC-MC , requests for truthful reporting, cannot explain decreased lying in treatment
CH-MC . Asynchronous communication explains some of the effect and could explain some of
the decreased lying in treatment CH-MC , but not enough to account for the near absence of
lies in treatment CH-MC (even when the ﬁrst report is truthful, the rate of lying by laggards is
well abo v e the near absence of lies observed in treatment CH-MC ). These observations strongly
suggest that the sixth difference plays a central role in the dramatic effect of treatment CH-MC
on truth-telling: free-form communication appears to be a necessary condition for the sharp
decrease in lies observed in treatment CH-MC . 38 In the conclusion we discuss why this might
be the case.

RESULT 11.  The game is signiﬁcantly more likely to be revealed in treatment EC-MC than
in treatment SC-MC , but signiﬁcantly less likely than in treatment CH-MC . The positive effect
of  treatment  EC-MC  stems  at  least  in  part  from  requests  by  mana g er s  for  truthful  reports
and asynchronous reporting. Given that less than half of the effects of treatment CH-MC on
information transmission and lying can be accounted for by the ﬁve factors incorporated into
treatment EC-MC , we conclude that free-form chat per se is a necessary ingredient for the
dramatic decrease of lying in treatment CH-MC relative to either treatment SC-MC or EC-MC .

6.  Concluding Remarks

This paper studies coordination in a demanding experimental environment, the MA game. It com-
bines four properties that characterise many organisational settings: coordinating on a common
course of action beneﬁts everyone, agents have divergent preferences over possible outcomes,
managers lack the necessary information to simply impose efﬁcient coordination on their agents
and agents have the necessary information, but also have little reason to truthfully reveal it.
Unlike the frequently studied weak-link game, the MA game stresses asymmetries: the manager
does not know what game is being played, and the agents’ interests are misaligned. Achiev-
ing coordination in the MA game is not difﬁcult, but achieving efﬁcient coordination that uses
agents’ information is a challenge. It is well established that either communication among play-
ers or external leadership (like managerial advice) increases efﬁcient coordination in symmetric

37 The same caveat applies in treatment CH-MC .
38 This evidence is related to results reported by Charness and Dufwenberg ( 2006 ; 2010 ). They found that promises

made within free-form communication affect behaviour differently from pre-formulated promises.

© The Author(s) 2025.

l

D
o
w
n
o
a
d
e
d

f
r
o
m
h

t
t

p
s
:
/
/

i

a
c
a
d
e
m
c
.
o
u
p
.
c
o
m
e

/

j
/

l

/

/

/

a
r
t
i
c
e
1
3
5
6
7
0
1
9
4
2
8
0
5
1
9
9
8
b
y
P
o
n

/

i

i

i

t
i
f
i
c
a
U
n
v
e
r
s
d
a
d
J
a
v
e
r
i
a
n
a
u
s
e
r
o
n
1
9
N
o
v
e
m
b
e
r
2
0
2
5

1976

the economic journal

[ august

coordination games. Managerial control has not been previously studied as its likely effect in
symmetric coordination games, unlike the MA game, is obvious. Our primary goal is to study the
roles of communication and managerial control in achieving efﬁcient coordination in the difﬁcult
environment of the MA game.

Achie ving ef ﬁcient coordination in the MA game requires two things: (1) the choices of the
agents have to be coordinated and (2) the agents’ information must be incorporated into the
choice of action. Either free-form communication (chat) or managerial control are sufﬁcient in
isolation to solve the coordination problem, but a combination of chat and managerial control is
necessary to use the agents’ information sufﬁciently well to outperform the babbling equilibrium,
gaining almost half of the possible gains o v er the babbling equilibrium. Free-form chat can seem
like a magic bullet in experimental economics, solving all problems with coordination and/or
cooperation. In the MA game, neither rich communication nor managerial advice is sufﬁcient.
Even though managers lack critical information, managerial control plays a valuable role in
enabling groups to make ef fecti ve use of agents’ information.

The key feature that allows the combination of chat and managerial control to function so well
is that information transmission is remarkably good. The MA game with managerial control gives
agents strong incentives to lie, and with structured communication, agents often do so. Managers
receive only limited information and struggle to use it ef fecti vely. When free-form communication
is used, agents generally reveal what game is being played and rarely lie. Managers take advantage
of their resulting good information to frequently impose efﬁcient coordination.

The patterns of communication about the state of the world (i.e., what game is being played)
in treatment CH-MC are quite different from either what is observed in treatment SC-MC or
what is typically observed in experiments on truth-telling. That raises the question of why lying
is so infrequent in treatment CH-MC . Our initial conjecture was that a fear of being f act-check ed
(being called out on a lie in real time by the other agent) drives the low rate of lying. Indeed,
fact-checking is common when lies are told in treatment CH-MC . Ho we ver, the results of the
follow-up EC-MC treatment argue against this explanation. Fact-checking is once again common
in treatment EC-MC , but there is little evidence that this leads to reduced lying. Apparently,
the possibility of being called out on a lie, either in real-time or with a delay, is not sufﬁciently
embarrassing to deter lying. Instead, the critical ingredient that leads to reduced lying appears to
be free-form communication per se. 39

Our experiments cannot tell us why free-form communication per se decreases lying. One
possibility is strictly mechanical: treatment EC-MC omits some speciﬁc type of message that
is necessary to prevent lying. If so, it is not obvious what such a message might be. The coding
e x ercise reported in Section 4.2.2 was intended to capture all content rele v ant to play of the game.
The obvious candidates that might increase truth-telling are available in treatment EC-MC . It
is possible that there is some other type of message in the CH-MC chat, possibly not coded,
that decreases lying. A second possibility is that free-form communication decreases lying via
a mechanism that only functions if it emerges endogenously. Once again, it is not obvious what
such a mechanism might be. Both fact-checking and asynchronous timing are endogenous in
treatment EC-MC , and managers must endogenously choose whether or not to ask for a report
or request the truth. That leaves us with two possibilities that we view as more likely. Language

39 The use of free-form communication need not al w ays lead to the almost complete elimination of lies we observe.
F or e xample, Lundquist et al . ( 2009 ) observed fe wer decepti ve lies with free-form messages, but a substantial fraction of
lies still occurs (40%). This may reﬂect the differing structure of communication, as messages in Lundquist et al . ( 2009 )
were restricted to a single one-way message as opposed to free-form bilateral (or trilateral) communication.

© The Author(s) 2025.

l

D
o
w
n
o
a
d
e
d

f
r
o
m
h

t
t

p
s
:
/
/

i

a
c
a
d
e
m
c
.
o
u
p
.
c
o
m
e

/

j
/

l

/

/

/

a
r
t
i
c
e
1
3
5
6
7
0
1
9
4
2
8
0
5
1
9
9
8
b
y
P
o
n

/

i

i

i

t
i
f
i
c
a
U
n
v
e
r
s
d
a
d
J
a
v
e
r
i
a
n
a
u
s
e
r
o
n
1
9
N
o
v
e
m
b
e
r
2
0
2
5

2025]

managerial leadership

1977

can be subtle and nuanced, with a gap between what is literally said and what is meant. For
example, in the American South, the phrase ‘bless your heart’ often implies the opposite of what
is being said. 40 Subtleties and nuances that induce greater truth-telling with free-form chat may
be missing even with the relatively ﬂexible structured communication of treatment EC-MC . 41
Another possibility is that free-form communication changes preferences by reducing social
distance between the managers and their agents. The older psychology literature on free-form
communication and cooperation ﬁnds that free-form communication increases cooperation by
promoting group identity (e.g., Orbell et al. , 1988 ). Similar effects could account for reduced
lying in treatment CH-MC , with greater group identity increasing concerns about maintaining
a positive social image by being truthful. 42 All of the preceding is obviously speculative. We
establish that free-form chat is necessary to reduce lying in treatment CH-MC , but exactly how
that works is an open question that will require additional research to answer.

Free-form communication impro v es efﬁcienc y, but it is still necessary that players come up
with the right thing to say. This point is made strongly by the CH/A-D treatment. Letting the
manager give advice to the agents has a minimal effect on avera g e , but this disguises a great deal
of heterogeneity. Managers can successfully induce more efﬁcient coordination, but this only
works when they actually think to suggest efﬁcient coordination to their agents.

We study an intentionally simple game designed to capture a set of features that are present
in many organisations. A natural goal for follow-up work is abandoning some of that simplicity
in exchange for greater verisimilitude. One possible approach is using subjects with real-world
managerial experience as subjects in the manager role. Existing evidence suggests that using
managers would not affect our results (for coordination games with leaders, see Cooper, 2006 ;
for games in general, see Fr ´echette, 2015 ), but it would still be interesting to see how real-world
managers approach the MA game. Another possibility is looking at decision-making by groups.
Many decisions within organisations are made by groups, and there is an e xtensiv e literature
suggesting that groups and individuals do not make identical decisions either for games generally
or coordination games speciﬁcally (Feri et al. , 2010 ).

Instituto de An ´alisis Econ ´omico (CSIC) & Barcelona School of Economics, Spain
University of Iowa, USA & University of East Anglia, UK

Additional Supporting Information may be found in the online version of this article:

Online Appendix
Replication Package

References
Abeler , J. , D. Nosenzo, and R. Raymond (2019). ‘Preferences for truth-telling’, Econometrica , vol. 87(4), pp. 1115–53.

40 If said in a certain way, ‘He means well, bless his heart’ is a gentle way of saying he is an idiot.
41 Along similar lines, Charness and Dufwenberg ( 2010 ) found that ‘bare’ promises do not have the same effect as
promises expressed in the context of a free-form message. In both cases it is possible to promise trust-worthy behaviour,
but something about the richer language available with free-form messages makes subjects more likely to follow through
on their promises.

42 Cohn et al. ( 2022 ) reported that truthfulness is signiﬁcantly higher when individuals interact with a human rather
than a machine. They posited that an increased sense of ‘closeness’ may be responsible for the result, increasing concerns
about being judged.

© The Author(s) 2025.

l

D
o
w
n
o
a
d
e
d

f
r
o
m
h

t
t

p
s
:
/
/

i

a
c
a
d
e
m
c
.
o
u
p
.
c
o
m
e

/

j
/

l

/

/

/

a
r
t
i
c
e
1
3
5
6
7
0
1
9
4
2
8
0
5
1
9
9
8
b
y
P
o
n

/

i

i

i

t
i
f
i
c
a
U
n
v
e
r
s
d
a
d
J
a
v
e
r
i
a
n
a
u
s
e
r
o
n
1
9
N
o
v
e
m
b
e
r
2
0
2
5

1978

the economic journal

[ august

Alonso , R. , W. Dessein, and N. Matouschek (2008a). ‘When does coordination require centralization?’, American

Economic Re vie w , vol. 98(1), pp. 145–79.

Alonso , R. , W. Dessein, and N. Matouschek (2008b). ‘Centralization versus decentralization: An application to price

setting by a multi-market ﬁrm’, Journal of the European Economic Association , vol. 6(2-3), pp. 457–67.

Alonso , R. , W. Dessein, and N. Matouschek (2015). ‘Organizing to adapt and compete’, American Economic Journal:

Microeconomics , vol. 7(2), pp. 158–87.

Bartling , B. , E. Fehr, and H. Herz (2014). ‘The intrinsic value of decision rights’, Econometrica , vol. 82(6), pp. 2005–39.
Battaglini , M. (2002). ‘Multiple referrals and multidimensional cheap talk’, Econometrica , vol. 70(4), pp. 1379–401.
Ben-Ner , A. and L. Putterman (2009). ‘Trust, communication and contracts: An experiment’, Journal of Economic

Behavior and Organization , vol. 70(1-2), pp. 106–21.

Blume , A. , P.H. Kriss, and R.A. Weber (2017). ‘Pre-play communication with forgone costly messages: Experimental

evidence on forward induction’, Experimental Economics , vol. 20(2), pp. 368–95.

Blume , A. , E.K. Lai, and W. Lim (2023). ‘Mediated talk: An experiment’, Journal of Economic Theory , vol. 208, 105593.
Blume , A. and A. Ortmann (2007). ‘The effects of costless pre-play communication: Experimental evidence from games

with Pareto-ranked equilibria’, Journal of Economic Theory , vol. 132(1), pp. 274–90.

Bolton , G. , J. Brandts, and A. Ockenfels (2005). ‘Fair procedures: Evidence from games involving lotteries’, ECONOMIC

JOURNAL , vol. 115(506), pp. 1054–76.

Brandts , J. , G. Charness, and M. Ellman (2016). ‘Let’s talk: How communication affects contract design’, Journal of the

European Economic Association, vol. 14(4), pp. 943–74.

Brandts , J. and D.J. Cooper (2007). ‘It’s what you say not what you pay: An experimental study of manager-employee
relationships in o v ercoming coordination failure’, Journal of the European Economic Association , vol. 5(6), pp.
1223–68.

Brandts , J. , D.J. Cooper, and R.A. Weber (2015). ‘Le gitimac y, communication, and leadership in the turnaround game’,

Mana g ement Science , vol. 61(11), pp. 2627–45.

Brandts , J. , D.J. Cooper, and C. Rott (2019). ‘Communication in laboratory experiments’, in (A. Schram and A. Ule, eds.),
Handbook of Research Methods and Applications in Experimental Economics , pp. 401–18, Cheltenham: Edward
Elgar Publishing.

Brandts , J. and B. MacLeod (1995). ‘Equilibrium selection in experimental games with recommended play’, Games and

Economic Behavior , vol. 11(1), pp. 36–63.

Brynjolfsson , E. and C.F. Kemerer (1996). ‘Network externalities in microcomputer software: An econometric analysis

of the spreadsheet market’, Management Science , vol. 42(12), pp. 1627–47.

Cai , Hongbin and Joseph Tao-Yi Wang (2006). ‘Overcommunication in strategic information transmission games’, Games

and Economic Behavior , vol. 56(1), pp. 7–36.

Cartwright , E. , J. Gillet, and M. van Vugt (2013). ‘Leadership by example in the weak-link game’, Economic Inquiry ,

vol. 51(4), pp. 2028–43.

Cason , T.N. and V.-L. Mui (2007). ‘Communication and coordination in the laboratory collective resistance game’,

Experimental Economics , vol. 10(3), pp. 251–67.

Charness , G. and M. Dufwenberg (2006). ‘Promises and partnerships’, Econometrica , vol. 74(6), pp. 1579–601.
Charness , G. and M. Dufwenberg (2010). ‘Bare promises: An experiment’, Economics Letters , vol. 107(2), pp. 281–3.
Chaudhuri , A. and T. Paichayontvijit (2010). ‘Recommended play and performance bonuses in the minimum effort

coordination game’, Experimental Economics , vol. 13, pp. 346–63.

Chaudhuri , A. , A. Schotter, and B. Sopher (2009). ‘Talking ourselves to efﬁciency: Coordination in inter-generational
minimum effort games with private, almost common, and common knowledge of advice’, ECONOMIC JOURNAL , vol.
119(534), pp. 91–122.

Cohn , A. , T. Gesche, and M. Mar ´echal (2022). ‘Honesty in the digital age’, Mana g ement Science, vol. 68(2), pp. 827–45.
Cooper , D.J. (2006). ‘Are experienced managers experts at overcoming coordination failure?’, The B.E. Journal of

Economic Analysis & Policy , vol. 6(2), doi: 10.2202/1538-0637.1479.

Cooper , D.J. and J.R. Hamman (2021). ‘Leadership and delegation of authority’, in (M.-C. Ville v al and K. Zimmermann,

eds.), The Handbook of Labor, Human Resources and Population Economics , pp. 1–25, Cham: Springer.

Cooper , D.J. , J.R. Hamman, and R. Weber (2020). ‘Fool me once: An experiment on credibility and leadership’, ECONOMIC

JOURNAL , vol. 130(631), pp. 2105–33.

Cooper , D.J. and J.H. Kagel (2005). ‘Are two heads better than one? Team versus individual play in signaling games’,

American Economic Re vie w, 95(3), pp. 477–509.

Cooper , D.J. and K.-U. K ¨uhn (2014). ‘Communication, renegotiation, and the scope for collusion’, American Economic

Journal: Microeconomics , vol. 6(2), pp. 247–78.

Cooper , R. , D. DeJong, B. Forsythe, and T. Ross (1989). ‘Communication in the battle of the se x es game: Some

experimental results’, RAND Journal of Economics, vol. 20(4), pp. 568–87.

Cooper , R. , D. DeJong, B. Forsythe, and T. Ross (1992). ‘Communication in coordination games’, The Quarterly Journal

of Economics, vol. 107(2), pp. 739–71.

Dawes , R.M. , J. McTavish, and H. Shaklee (1977). ‘Behavior, communication, and assumptions about other people’s
behavior in a commons dilemma situation’, Journal of Personality and Social Psychology , vol. 35(1), 1–11.
Dessein , W. , L. Garicano, and R. Gertner (2010). ‘Organizing for synergies’, American Economic Journal: Microeco-

nomics , vol. 2(4), pp. 77–114.

© The Author(s) 2025.

l

D
o
w
n
o
a
d
e
d

f
r
o
m
h

t
t

p
s
:
/
/

i

a
c
a
d
e
m
c
.
o
u
p
.
c
o
m
e

/

j
/

l

/

/

/

a
r
t
i
c
e
1
3
5
6
7
0
1
9
4
2
8
0
5
1
9
9
8
b
y
P
o
n

/

i

i

i

t
i
f
i
c
a
U
n
v
e
r
s
d
a
d
J
a
v
e
r
i
a
n
a
u
s
e
r
o
n
1
9
N
o
v
e
m
b
e
r
2
0
2
5

2025]

managerial leadership

1979

Erat , S. and U. Gneezy (2012). ‘White Lies’, Mana g ement Science , vol. 58(4), pp. 723–33.
Evdokimov , P. and U. Garfagnini (2019). ‘Communication and behavior in organizations: An experiment’, Quantitative

Economics , vol. 10(2), pp. 775–801.

Farrell , J. and C. Shapiro (1992). ‘Standard setting in high deﬁnition television’, Brookings Papers on Economic Activity:

Microeconomics , vol. 1992, 1–93.

Fehr , E. , H. Herz, and T. Wilkening (2013). ‘The lure of authority: Moti v ation and incenti ve ef fects of power’, American

Economic Re vie w , vol. 103(4), pp. 1325–59.

Feri , F. , B. Irlenbusch, and M. Sutter (2010). ‘Efﬁciency gains from team-based coordination – Large-scale experimental

evidence’, American Economic Re vie w , vol. 100(4), pp. 1892–912.

Ferreira , J.V. , N. Hanaki, and B. Tarroux (2020). ‘On the roots of the intrinsic value of decision rights: Experimental

evidence’, Games and Economic Behavior , vol. 119(C), pp. 110–22.

Fischbacher , U. (2007). ‘z-Tree: Zurich toolbox for ready-made economic experiments’, Experimental Economics , vol.

10(2), pp. 171–8.

Fischbacher , U. and F. F ¨ollmi-Heusi (2013). ‘Lies in disguise – An experimental study on cheating’, Journal of the

European Economic Association , vol. 11(3), pp. 525–47.

Fr ´echette , G.R. (2015). ‘Laboratory experiments: Professionals versus students’, in (G. Fr ´echette and A. Schotter, eds.),

Handbook of Experimental Economic Methodology , pp. 360–90, Oxford: Oxford University Press.

Gandal , N. , D. Salant, and L. Waverman (2003). ‘Standards in wireless telephone networks’, Telecommunications Policy ,

vol. 27(5), pp. 325–32.

Gneezy , U. (2005). ‘Deception: The role of consequences’, American Economic Re vie w , vol. 95(1), pp. 384–94.
Gneezy , U. , A. Kajackaite, and J. Sobel (2018). ‘Lying aversion and the size of the lie’, American Economic Re vie w , vol.

108(2), pp. 419–53.

Hart , O. and B. Holmstrom (2010). ‘A theory of ﬁrm scope’, Quarterly Journal of Economics , 125(2), pp. 483–513.
Hart , O. and J. Moore (2008). ‘Contracts as reference points’, Quarterly Journal of Economics , vol. 123(1), pp. 1–48.
Isaac , R.M. and J.M. Walker (1988). ‘Communication and free-riding behavior: The voluntary contribution mechanism’,

Economic Inquiry , vol. 26(4), pp. 585–608.

Kartik , N. (2009). ‘Strategic communication with lying costs’, Review of Economic Studies, vol. 76(4), pp. 1359–95.
Kriss , P.H. , A. Blume, and R.A. Weber (2016). ‘Coordination with decentralized costly communication’, Journal of

Economic Behavior and Organization , vol. 130, pp. 225–41.

Lai , E.K. , W. Lim, and J.T.-Y. Wang (2015). ‘An experimental analysis of multidimensional cheap talk’, Games and

Economic Behavior , vol. 91(C), pp. 114–44.

Lundquist , T. , T. Ellingsen, E. Gribbe, and M. Johannesson (2009). ‘The aversion to lying’, Journal of Economic Behavior

and Organization , vol. 70(1-2), pp. 81–92.

McElheran , K. (2014). ‘Delegation in multi-establishment ﬁrms: The organizational structure of I.T. purchasing authority’,

Journal of Economics and Mana g ement Strategy , vol. 23(2), pp. 225–57.

Mookherjee , D. (2006). ‘Decentralization, hierarchies and incentives: A mechanism design perspective’, Journal of

Economic Literature , vol. 44(2), pp. 367–90.

Neri , C. and H. Rommeswinkel (2017). ‘Decision rights: Freedom, power, and interference’. Preprint, http://dx.doi.org

/10.2139/ssrn.2485107 .

Orbell , J. , A.J.C. van de Kragt, and R.M. Dawes (1988). ‘Explaining discussion-induced cooperation’, Journal of

Personality and Social Psychology , vol. 54(5), pp. 811–19.

Ostrom , E. , J. Walker, and R. Gardner (1992). ‘Co v enants with and without a sword: Self-go v ernance is possible’,

American Political Science Re vie w , vol. 86(2), pp. 404–17.

Pikulina , E.S. and C. Tergiman (2020). ‘Preferences for power’, Journal of Public Economics , vol. 185, 104173.
Rantakari , H. (2008). ‘Go v erning adaptation’, The Re vie w of Economic Studies , vol. 75(4), pp. 1257–85.
Sahin , S.G. , C. Eckel, and M. Komai (2015). ‘An experimental study of leadership institutions in collective action games’,

Journal of the Economic Science Association , vol. 1, pp. 100–13.

S ´anchez-Pag ´es , S. and M. Vorsatz (2007). ‘An experimental study of truth-telling in a sender–receiver game’, Games

and Economic Behavior , vol. 61(1), pp. 86–112.

Thomas , C. (2011). ‘Too many products: Decentralized decision making in multinational ﬁrms’, American Economic

Journal: Microeconomics , vol. 3(1), pp. 280–306.

Van Huyck , J. , A. Gillette, and R. Battalio (1992). ‘Credible assignments in coordination games’, Games and Economic

Behavior , vol. 4(4), pp. 606–26.

Vespa , E. and A.J. Wilson (2016). ‘Communication with multiple senders: An experiment’, Quantitative Economics , vol.

7(1), pp. 1–36.

Weber , R.A. , C. Camerer, and M Knez. (2004). ‘Timing and virtual observability in ultimatum bargaining and "weak-link"

coordination games’, Experimental Economics , vol. 7(1), pp. 25–48.

Weber , R.A. , Y. Rottenstreich, C. Camerer, and M. Knez (2001). ‘The illusion of leadership: Misattribution of cause in

coordination games’, Organization Science , vol. 12(5), pp. 582–98.

© The Author(s) 2025.
The Economic Journal , 135 ( August ), 1942–1979 https://doi.org/10.1093/ej/ueaf019 © The Author(s) 2025. Published by Oxford University Press on behalf of Royal Economic Society. This is
an Open Access article distributed under the terms of the Creative Commons Attribution License ( https://cr eativecommons.or g/licenses/by/4.0/), which permits unrestricted reuse, distribution,
and reproduction in any medium, provided the original work is properly cited.
Advance Access Publication Date: 4 March 2025

l

D
o
w
n
o
a
d
e
d

f
r
o
m
h

t
t

p
s
:
/
/

i

a
c
a
d
e
m
c
.
o
u
p
.
c
o
m
e

/

j
/

l

/

/

/

a
r
t
i
c
e
1
3
5
6
7
0
1
9
4
2
8
0
5
1
9
9
8
b
y
P
o
n

/

i

i

i

t
i
f
i
c
a
U
n
v
e
r
s
d
a
d
J
a
v
e
r
i
a
n
a
u
s
e
r
o
n
1
9
N
o
v
e
m
b
e
r
2
0
2
5

