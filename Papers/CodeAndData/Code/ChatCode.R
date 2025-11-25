# Library, WD and setup ----

# Run first the behavior code
# Then remove everything except DatA: 

rm(list= ls()[!(ls() %in% c('DatA'))])

setwd(".../Data") # Set this to your folder where the Data folder is 

packages <- c("plyr", "zTree", "stm", "igraph", "quanteda","wordcloud",
              "tm","DT","stmCorrViz","stmgui","clue","quanteda.textplots")

sapply(packages, require, character.only = TRUE)
rm(packages)

# create a function for Diagnostics 
plotSearch <- function(x, ....){
  oldpar <- par(no.readonly = TRUE)
  g <- x$results
  par(mfrow = c(2, 2), mar = c(4, 4, 4, 4), oma = c(2, 2, 2, 
                                                    2))
  plot(g$K, g$heldout, type = "p", main = "Held-Out Likelihood", 
       xlab = "", ylab = "")
  lines(g$K, g$heldout, lty = 1, col = 1)
  plot(g$K, g$residual, type = "p", main = "Residuals", 
       xlab = "", ylab = "")
  lines(g$K, g$residual, lty = 1, col = 1)
  if (!is.null(g$semcoh)) {
    plot(g$K, g$semcoh, type = "p", main = "Semantic Coherence", 
         xlab = "Number of Topics", ylab = "")
    lines(g$K, g$semcoh, lty = 1, col = 1)
  }
  plot(g$K, g$exclus, type = "p", main = "Exclusivity", 
       xlab = "Number of Topics", ylab = "")
  lines(g$K, g$exclus, lty = 1, col = 1)
#  title("Diagnostic Values by Number of Topics", outer = TRUE)
  par(oldpar)
}

# Session Naming and variable ----
Session1Chat <- as.data.frame(zTreeTables("160503_0820.xls","chat",ignore.errors = T))
Session1Chat$Session <- with(Session1Chat,1)
Session1Chat$Crosssect <- with(Session1Chat,(Session*100-chat.Owner))
Session1Chat$Comp <- with(Session1Chat,1)

Session3Chat <- as.data.frame(zTreeTables("160510_0920.xls","chat",ignore.errors = T))
Session3Chat$Session <- with(Session3Chat,3)
Session3Chat$Crosssect <- with(Session3Chat,(Session*100-chat.Owner))
Session3Chat$Comp <- with(Session3Chat,0)

Session4Chat <- as.data.frame(zTreeTables("160511_0853.xls","chat",ignore.errors = T))
Session4Chat$Session <- with(Session4Chat,4)
Session4Chat$Crosssect <- with(Session4Chat,(Session*100-chat.Owner))
Session4Chat$Comp <- with(Session4Chat,1)

Session6Chat <- as.data.frame(zTreeTables("160511_1426.xls","chat",ignore.errors = T))
Session6Chat$Session <- with(Session6Chat,6)
Session6Chat$Crosssect <- with(Session6Chat,(Session*100-chat.Owner))
Session6Chat$Comp <- with(Session6Chat,0)

Session9Chat <- as.data.frame(zTreeTables("160512_1420.xls","chat",ignore.errors = T))
Session9Chat$Session <- with(Session9Chat,9)
Session9Chat$Crosssect <- with(Session9Chat,(Session*100-chat.Owner))
Session9Chat$Comp <- with(Session9Chat,0)

Session10Chat <- as.data.frame(zTreeTables("160513_0850.xls","chat",ignore.errors = T))
Session10Chat$Session <- with(Session10Chat,10)
Session10Chat$Crosssect <- with(Session10Chat,(Session*100-chat.Owner))
Session10Chat$Comp <- with(Session10Chat,1)

Session13Chat <- as.data.frame(zTreeTables("160519_0934.xls","chat",ignore.errors = T))
Session13Chat$Session <- with(Session13Chat,13)
Session13Chat$Crosssect <- with(Session13Chat,(Session*100-chat.Owner))
Session13Chat$Comp <- with(Session13Chat,1)

Session14Chat <- as.data.frame(zTreeTables("161018_0903.xls","chat",ignore.errors = T))
Session14Chat$Session <- with(Session14Chat,14)
Session14Chat$Crosssect <- with(Session14Chat,(Session*100-chat.Owner))
Session14Chat$Comp <- with(Session14Chat,1)

Session15Chat <- as.data.frame(zTreeTables("161018_1209.xls","chat",ignore.errors = T))
Session15Chat$Session <- with(Session15Chat,15)
Session15Chat$Crosssect <- with(Session15Chat,(Session*100-chat.Owner))
Session15Chat$Comp <- with(Session15Chat,1)

Session17Chat <- as.data.frame(zTreeTables("161019_0824.xls","chat",ignore.errors = T))
Session17Chat$Session <- with(Session17Chat,17)
Session17Chat$Crosssect <- with(Session17Chat,(Session*100-chat.Owner))
Session17Chat$Comp <- with(Session17Chat,1)

Session19Chat <- as.data.frame(zTreeTables("161019_1411.xls","chat",ignore.errors = T))
Session19Chat$Session <- with(Session19Chat,19)
Session19Chat$Crosssect <- with(Session19Chat,(Session*100-chat.Owner))
Session19Chat$Comp <- with(Session19Chat,0)

Session20Chat <- as.data.frame(zTreeTables("170510_0938.xls","chat",ignore.errors = T))
Session20Chat$Session <- with(Session20Chat,20)
Session20Chat$Crosssect <- with(Session20Chat,(Session*100-chat.Owner))
Session20Chat$Comp <- with(Session20Chat,1)

Session21Chat <- as.data.frame(zTreeTables("170510_1319.xls","chat",ignore.errors = T))
Session21Chat$Session <- with(Session21Chat,21)
Session21Chat$Crosssect <- with(Session21Chat,(Session*100-chat.Owner))
Session21Chat$Comp <- with(Session21Chat,0)

# Extra sessions
Session30Chat <- as.data.frame(zTreeTables("211118_1312.xls","chat",ignore.errors = T))
Session30Chat$Session <- with(Session30Chat,30)
Session30Chat$Crosssect <- with(Session30Chat,(Session*100-chat.Owner))
Session30Chat$Comp <- with(Session30Chat,0)

Session31Chat <- as.data.frame(zTreeTables("211118_1537.xls","chat",ignore.errors = T))
Session31Chat$Session <- with(Session31Chat,31)
Session31Chat$Crosssect <- with(Session31Chat,(Session*100-chat.Owner))
Session31Chat$Comp <- with(Session31Chat,0)

# Create Chat content data

ChatALL <- rbind(Session1Chat,Session3Chat,Session4Chat,Session6Chat,Session9Chat,Session10Chat,Session13Chat,
                 Session14Chat,Session15Chat,Session17Chat,Session19Chat,Session20Chat,Session21Chat,
                 Session30Chat,Session31Chat)

rm(Session1Chat,Session3Chat,Session4Chat,Session6Chat,Session9Chat,Session10Chat,Session13Chat,
      Session14Chat,Session15Chat,Session17Chat,Session19Chat,Session20Chat,Session21Chat,
      Session30Chat,Session31Chat)

# Join behavior data to the old sessions for chat analysis ----
### Attention, here we choose the classification 
### (either Event, NotAtAll, or Early ==1) for separate analysis if need be
DatA1<-filter(DatA,Chat==1,Period==30)
DatA1<-select(DatA1,Crosssect,Pair,ID,Comp,JPMabel,NotAtAll,Early,Event)
DatA2<-select(DatA,Crosssect,Pair,Period,Inv,OtherInv,Payoff,OtherPayoff)
# Chat count ----
# Chat count
### Attention: this is a correction for content analysis for subjects 1384 and 1385, who spoiled with random hits 
ChatALL <- as.data.table(ChatALL)
ChatALL[Crosssect==1384&chat.Period==20, chat.WORDS := NA]
ChatALL[Crosssect==1385&chat.Period==20, chat.WORDS := NA]
ChatALL[Crosssect==1385&chat.Period==30, chat.WORDS := NA]
ChatALL <- as.data.frame(ChatALL)

ChatALL1 <- ChatALL # Save this for word count stuff without removal
ChatALL1 <- filter(ChatALL1, !is.na(chat.WORDS))
ChatALL1 <- merge(ChatALL1,select(DatA1,Crosssect,Pair), by = c("Crosssect"))

# Remove pairs where at least one subject does not talk
ChatALL <- filter(ChatALL,
                  Crosssect!=894,Crosssect!=895,
                  Crosssect!=1896,Crosssect!=1897
                  )

ChatALL <- filter(ChatALL, !is.na(chat.WORDS))

ChatALL <- merge(ChatALL,select(DatA1,Crosssect,Pair), by = c("Crosssect"))

# Continue with chat counting ---
ChatA1 <- merge(ChatALL1,DatA1, by = c("Crosssect"))
ChatA1$Comp <- ChatA1$Comp.x
ChatA1 <- select(ChatA1, Crosssect,Pair=Pair.x,chat.Period,chat.Owner,chat.groupe,chat.ID,
                chat.WORDS,JPMabel,Comp)

ChatA <- merge(ChatALL,DatA1, by = c("Crosssect"))
ChatA$Comp <- ChatA$Comp.x
ChatA <- select(ChatA, Crosssect,Pair=Pair.x,chat.Period,chat.Owner,chat.groupe,chat.ID,
                chat.WORDS,JPMabel,Comp)

# Period 0 included
ChatCountInd0 <- aggregate.data.frame(ChatA1$chat.WORDS,
                                  list(Crosssect=ChatA1$Crosssect,
                                       Period=ChatA1$chat.Period),length)
# Period 0 excluded
ChatCountInd <- aggregate.data.frame(filter(ChatA1,chat.Period>0)$chat.WORDS,
                                     list(Crosssect=filter(ChatA1,chat.Period>0)$Crosssect,
                                          Period=filter(ChatA1,chat.Period>0)$chat.Period),length)


# this is to ensure that those who do not send any message
# given a period also appear in the data with 0 message count
y <- expand.grid(Crosssect=DatA1$Crosssect, Period = 0:30)
ChatCountInd <- merge(ChatCountInd, y, all = T) %>% replace_na(list(x= 0))
ChatCountInd<-merge(ChatCountInd,DatA1, by = c("Crosssect"))

ChatCountInd0 <- merge(ChatCountInd0, y, all = T) %>% replace_na(list(x= 0))
ChatCountInd0 <- merge(ChatCountInd0,DatA1, by = c("Crosssect"))

## this is to look at certain periods and numbers of messages to detect exploiters
filter(aggregate.data.frame(filter(ChatCountInd,Period>1,Period<31)$x,
                            list(Crosssect=filter(ChatCountInd,Period>1,
                                                  Period<31)$Crosssect),sum),x>149)

---- # ANALYSIS # ----
#### ---- Word Counts ----
## Plotting Chatcounts ----
## averages over subjects for each period

ChatCountIndAve<- aggregate.data.frame(ChatCountInd$x,
                                       list(Period=ChatCountInd$Period,
                                            Comp=ChatCountInd$Comp),
                                       mean)

ChatCountIndSum<- aggregate.data.frame(ChatCountInd$x,
                                       list(Crosssect=ChatCountInd$Crosssect,
                                            Comp=ChatCountInd$Comp),
                                       sum)

ChatCountInd0Sum<- aggregate.data.frame(ChatCountInd0$x,
                                       list(Crosssect=ChatCountInd0$Crosssect,
                                            Comp=ChatCountInd0$Comp),
                                       sum)


ChatCountIndAve0<- aggregate.data.frame(ChatCountInd0$x,
                                       list(Period=ChatCountInd$Period,
                                            Comp=ChatCountInd$Comp),
                                       mean)


## plotting average messages sent - Figure 6a
ggplot(filter(ChatCountIndAve0), 
       aes(x=Period, y=x, colour = factor(Comp), 
           linetype=factor(Comp), shape=factor(Comp))) +
  geom_line() +
  geom_point() +
  scale_colour_manual("",values=c("red","blue"),labels=c("Substitution","Complementarity")) +
  scale_linetype_manual("", values=c(4,1),labels=c("Substitution","Complementarity")) +
  scale_shape_manual("", values=c(1,1),labels=c("Substitution","Complementarity"))+
  theme_bw()+ylab("Number of Messages")+
  theme(legend.position="bottom",
      #  legend.background = element_rect(fill=NULL, size=.2,colour = "black"),
        legend.key = element_rect(colour = 'white'))+
  scale_y_continuous(limits = c(0,3))


# plotting the number of people with zero message per treatment - Figure 6b
NonMess <- aggregate.data.frame(filter(ChatCountInd0,x==0)$x,
                                list(Period=filter(ChatCountInd0,x==0)$Period,
                                     Comp=filter(ChatCountInd0,x==0)$Comp),length)
NonMess$Normed <- with(NonMess,x/(104-Comp*4))

wilcox.test(filter(NonMess,Comp==0)$Normed,
            filter(NonMess,Comp==1)$Normed) 

ggplot(NonMess, 
       aes(x=Period, y=Normed, colour = factor(Comp), 
           linetype=factor(Comp), shape=factor(Comp))) +
  geom_line() +
  geom_point() +
  scale_colour_manual("",values=c("red","blue"),labels=c("Substitution","Complementarity")) +
  scale_linetype_manual("", values=c(4,1),labels=c("Substitution","Complementarity")) +
  scale_shape_manual("", values=c(1,1),labels=c("Substitution","Complementarity"))+
  theme_bw()+ylab("Percentage of Non-Senders")+
  theme(legend.position="bottom",
    #    legend.background = element_rect(fill=NULL, size=.2,colour = "black"),
        legend.key = element_rect(colour = 'white'))+
  scale_y_continuous(limits = c(0,0.75))

## Chatcount means with restrictions ----
round(mean(filter(ChatCountInd,Period>0)$x),2)
round(sd(filter(ChatCountInd,Period>0)$x),2)

# Table 4
round(mean(filter(ChatCountInd,Period>0,Period<16)$x),2)
round(mean(filter(ChatCountInd,Period>15)$x),2)

wilcox.test(filter(ChatCountInd,Period>0,Period<16)$x,
            filter(ChatCountInd,Period>15)$x)

round(mean(filter(ChatCountInd,Period>0,Comp==1)$x),2)
round(sd(filter(ChatCountInd,Period>0,Comp==1)$x),2)
round(mean(filter(ChatCountInd,Period>0,Comp==0)$x),2)
round(sd(filter(ChatCountInd,Period>0,Comp==0)$x),2)

wilcox.test(filter(ChatCountInd,Period>0,Comp==1)$x,
            filter(ChatCountInd,Period>0,Comp==0)$x)


round(mean(filter(ChatCountInd,Comp==0,Period>0,Period<16)$x),2)
round(sd(filter(ChatCountInd,Comp==0,Period>0,Period<16)$x),2)
round(mean(filter(ChatCountInd,Comp==1,Period>0,Period<16)$x),2)
round(sd(filter(ChatCountInd,Comp==1,Period>0,Period<16)$x),2)

wilcox.test(filter(ChatCountInd,Comp==0,Period>0,Period<16)$x,
            filter(ChatCountInd,Comp==1,Period>0,Period<16)$x)


round(mean(filter(ChatCountInd,Comp==0,Period>15)$x),2)
round(sd(filter(ChatCountInd,Comp==0,Period>15)$x),2)
round(mean(filter(ChatCountInd,Comp==1,Period>15)$x),2)
round(sd(filter(ChatCountInd,Comp==1,Period>15)$x),2)

wilcox.test(filter(ChatCountInd,Comp==0,Period>15)$x,
            filter(ChatCountInd,Comp==1,Period>15)$x)


## JPM chatcounts ----
# Table 5
round(sd(filter(ChatCountInd,JPMabel==1,Period>0)$x),2)
round(sd(filter(ChatCountInd,JPMabel==0,Period>0)$x),2)
wilcox.test(filter(ChatCountInd,JPMabel==1,Period>0)$x,
            filter(ChatCountInd,JPMabel==0,Period>0)$x)

round(sd(filter(ChatCountInd,JPMabel==1,Period>0,Period<16)$x),2)
round(sd(filter(ChatCountInd,JPMabel==0,Period>0,Period<16)$x),2)
wilcox.test(filter(ChatCountInd,JPMabel==1,Period>0,Period<16)$x,
            filter(ChatCountInd,JPMabel==0,Period>0,Period<16)$x)

round(sd(filter(ChatCountInd,JPMabel==1,Period>15)$x),2)
round(sd(filter(ChatCountInd,JPMabel==0,Period>15)$x),2)
wilcox.test(filter(ChatCountInd,JPMabel==1,Period>15)$x,
            filter(ChatCountInd,JPMabel==0,Period>15)$x)

## JPM messaging per treatment
#SUBS
mean(filter(ChatCountInd,JPMabel==0,Comp==0,Period>0)$x)
mean(filter(ChatCountInd,JPMabel==1,Comp==0,Period>0)$x)
wilcox.test(filter(ChatCountInd,JPMabel==0,Comp==0,Period>0)$x,
            filter(ChatCountInd,JPMabel==1,Comp==0,Period>0)$x)

sd(filter(ChatCountInd,JPMabel==0,Comp==0,Period>0,Period<16)$x)
sd(filter(ChatCountInd,JPMabel==1,Comp==0,Period>0,Period<16)$x)
wilcox.test(filter(ChatCountInd,JPMabel==0,Comp==0,Period>0,Period<16)$x,
            filter(ChatCountInd,JPMabel==1,Comp==0,Period>0,Period<16)$x)

sd(filter(ChatCountInd,JPMabel==0,Comp==0,Period>15)$x)
sd(filter(ChatCountInd,JPMabel==1,Comp==0,Period>15)$x)
wilcox.test(filter(ChatCountInd,JPMabel==0,Comp==0,Period>15)$x,
            filter(ChatCountInd,JPMabel==1,Comp==0,Period>15)$x)

#COMP
sd(filter(ChatCountInd,JPMabel==0,Comp==1,Period>0)$x)
sd(filter(ChatCountInd,JPMabel==1,Comp==1,Period>0)$x)
wilcox.test(filter(ChatCountInd,JPMabel==0,Comp==1,Period>0)$x,
            filter(ChatCountInd,JPMabel==1,Comp==1,Period>0)$x)

sd(filter(ChatCountInd,JPMabel==0,Comp==1,Period>0,Period<16)$x)
sd(filter(ChatCountInd,JPMabel==1,Comp==1,Period>0,Period<16)$x)
wilcox.test(filter(ChatCountInd,JPMabel==0,Comp==1,Period>0,Period<16)$x,
            filter(ChatCountInd,JPMabel==1,Comp==1,Period>0,Period<16)$x)

sd(filter(ChatCountInd,JPMabel==0,Comp==1,Period>15)$x)
sd(filter(ChatCountInd,JPMabel==1,Comp==1,Period>15)$x)
wilcox.test(filter(ChatCountInd,JPMabel==0,Comp==1,Period>15)$x,
            filter(ChatCountInd,JPMabel==1,Comp==1,Period>15)$x)

rm(ChatCountInd,ChatCountInd0,ChatCountInd0Sum,
   ChatCountIndAve,ChatCountIndAve0,ChatCountIndSum,y)
#### ----- Content Analysis ----
# Data preparation ----

ChatALL2 <- dplyr::filter(ChatALL,chat.Period>0,chat.Period<31)


# Create Chat content file
ChatALLcoll<-aggregate(filter(ChatALL2)$chat.WORDS, 
                       list(filter(ChatALL2)$Pair), paste, collapse=" ")

names(ChatALLcoll) <- c("Pair","text")

# Create Chat content file for before first JPM

DatChat <- select(filter(DatA1,ID==1),
                  Pair,Comp,JPMabel,NotAtAll,Early,Event)

Chatter <- merge(ChatALLcoll, DatChat, by = c("Pair"),  all = T)
Chatter <- filter(Chatter, !is.na(text))
Chatter <- filter(Chatter, !is.na(Comp))


# Dropping a pair who do not communicate beyond Bonjour and Salut 
Chatter <- filter(Chatter, Pair!=2098,Pair!=95)

## Converting X.0 to X and typos to words ----
Chatter$text<- gsub('28.0', '28', Chatter$text);
Chatter$text<- gsub('26.0', '26', Chatter$text);
Chatter$text<- gsub('25.0', '25', Chatter$text);
Chatter$text<- gsub('24.0', '24', Chatter$text);
Chatter$text<- gsub('22.0', '22', Chatter$text);
Chatter$text<- gsub('20.0', '22', Chatter$text);
Chatter$text<- gsub('18.0', '18', Chatter$text);
Chatter$text<- gsub('16.0', '16', Chatter$text);
Chatter$text<- gsub('14.0', '14', Chatter$text);
Chatter$text<- gsub('12.0', '12', Chatter$text);
Chatter$text<- gsub('10.0', '10', Chatter$text);
Chatter$text<- gsub('6.0', '6', Chatter$text);
Chatter$text<- gsub('4.0', '4', Chatter$text);
Chatter$text<- gsub('3.0', '3', Chatter$text);
Chatter$text<- gsub('2.0', '2', Chatter$text);
Chatter$text<- gsub('0.0', '0', Chatter$text);

Chatter$text<- gsub('meme', 'même', Chatter$text);
Chatter$text<- gsub('apres', 'après', Chatter$text);
Chatter$text<- gsub('jai', "j'ai", Chatter$text,ignore.case=T);
Chatter$text<- gsub('tas', "t'as", Chatter$text,ignore.case=T);
Chatter$text<- gsub('tu as', "t'as", Chatter$text,ignore.case=T);
Chatter$text<- gsub('mdrr', 'mdr', Chatter$text,ignore.case=T);
Chatter$text<- gsub('mdrrr', 'mdr', Chatter$text,ignore.case=T);
Chatter$text<- gsub('mdrrrr', 'mdr', Chatter$text,ignore.case=T);
Chatter$text<- gsub('mdrrrrr', 'mdr', Chatter$text,ignore.case=T);
Chatter$text<- gsub('mdrrrrrr', 'mdr', Chatter$text,ignore.case=T);
Chatter$text<- gsub('mdrrrrrrr', 'mdr', Chatter$text,ignore.case=T);
Chatter$text<- gsub('mdrrrrrrrr', 'mdr', Chatter$text,ignore.case=T);
Chatter$text<- gsub('mdrrrrrrrrr', 'mdr', Chatter$text,ignore.case=T);
Chatter$text<- gsub('mdrrrrrrrrrr', 'mdr', Chatter$text,ignore.case=T);
Chatter$text<- gsub('mdrrrrrrrrrrr', 'mdr', Chatter$text,ignore.case=T);
Chatter$text<- gsub('mdrrrrrrrrrrrr', 'mdr', Chatter$text,ignore.case=T);
Chatter$text<- gsub('mdrrrrrrrrrrrrr', 'mdr', Chatter$text,ignore.case=T);
Chatter$text<- gsub('mdrrrrrrrrrrrrrr', 'mdr', Chatter$text,ignore.case=T);
Chatter$text<- gsub('mdrrrrrrrrrrrrrrr', 'mdr', Chatter$text,ignore.case=T);
Chatter$text<- gsub('mdrrrrrrrrrrrrrrrr', 'mdr', Chatter$text,ignore.case=T);
Chatter$text<- gsub('mdrrrrrrrrrrrrrrrrr', 'mdr', Chatter$text,ignore.case=T);
Chatter$text<- gsub('rrrr', 'rrr', Chatter$text,ignore.case=T);
Chatter$text<- gsub('rrr', 'rr', Chatter$text,ignore.case=T);
Chatter$text<- gsub('rr', 'r', Chatter$text,ignore.case=T);
Chatter$text<- gsub('lol', 'mdr', Chatter$text,ignore.case=T);
Chatter$text<- gsub('daccord', "d'accord", Chatter$text,ignore.case=T);
Chatter$text<- gsub('dacc', "d'accord", Chatter$text,ignore.case=T);
Chatter$text<- gsub('dac', "d'accord", Chatter$text,ignore.case=T);
Chatter$text<- gsub("d'acc", "d'accord", Chatter$text,ignore.case=T);
Chatter$text<- gsub("d'accordord", "d'accord", Chatter$text,ignore.case=T);
Chatter$text<- gsub('yes', "oui", Chatter$text,ignore.case=T);
Chatter$text<- gsub('ahah', "haha", Chatter$text,ignore.case=T);
Chatter$text<- gsub('hhahaa', "haha", Chatter$text,ignore.case=T);
Chatter$text<- gsub('hahaah', "haha", Chatter$text,ignore.case=T);
Chatter$text<- gsub("l'inverse", "inverse", Chatter$text,ignore.case=T);
Chatter$text<- gsub("pk", "parce", Chatter$text,ignore.case=T);
Chatter$text<- gsub("psk", "parce", Chatter$text,ignore.case=T);
Chatter$text<- gsub("stp", "s'il tu plaît", Chatter$text,ignore.case=T);
Chatter$text<- gsub("mtn", "maintenant", Chatter$text,ignore.case=T);
Chatter$text<- gsub("mnt", "maintenant", Chatter$text,ignore.case=T);
Chatter$text<- gsub("euros", "euro", Chatter$text,ignore.case=T);
Chatter$text<- gsub("bcp", "beaucoup", Chatter$text,ignore.case=T);
Chatter$text<- gsub("tkt", "t'inquiète", Chatter$text,ignore.case=T);
Chatter$text<- gsub("okay", "ok", Chatter$text,ignore.case=T);
Chatter$text<- gsub("mieu", "mieux", Chatter$text,ignore.case=T);
Chatter$text<- gsub("mieuxx", "mieux", Chatter$text,ignore.case=T);
Chatter$text<- gsub("lautre", "l'autre", Chatter$text,ignore.case=T);
Chatter$text<- gsub("gagner", "gagn", Chatter$text,ignore.case=T);
Chatter$text<- gsub("gagnes", "gagn", Chatter$text,ignore.case=T);
Chatter$text<- gsub("gagne", "gagn", Chatter$text,ignore.case=T);
Chatter$text<- gsub("chaqune", "chaqu", Chatter$text,ignore.case=T);
Chatter$text<- gsub("chaqun", "chaqu", Chatter$text,ignore.case=T);
## Plotting the relative rank differential and word cloud ----
CTC <-corpus(Chatter) # add filters here for Comp, JPMabel, and Early
CTCj <-corpus(filter(Chatter,JPMabel==1))
CTCnj <-corpus(filter(Chatter,JPMabel==0))
mydfm2 <- dfm(CTC,
              remove = c("a","ca","c'est","ou","ça","oui","si","non","quoi","sans","q",
                         "-","ouai","cest","ouais","ah","nan","ok","et","tt","j'avais",
                         "de","le","la","pas","que","en","les","un","une","mais","est","t'es",
                         "à",'c',"va","une","il","au","ce","des","qu'on","qui","nos",
                         "pour","sur","du","y","se","dans","suis","sa","pas","aller",
                         "on","je","tu","moi","toi","nous","me","te","ne","vas","notre",
                         "avec","etre","par","être","mon","ton","son","leur","ya","m",
                         "ma","sa","ta","ils","j","p","d","donc","alors","cette",
                         "bah","ai","t","l","qu'il","quand","bonjour","mis","dsl",
                         "fait","n","m'a","t'en","qu'ils","cb","mm","très","s",
                         "faire","quon","tes","vera","pr","tres","bjr",
                         "peut","fais","coup","mes","vais","avoir","j'ai","t'as",
                         "apres","chose","là","j'avais","quel","viens","salut",
                         "après","eu","aura","xd","qu","es","x","o","e","as",
                         "j'en","ouii","ont","allez","re","nn","c'était","sous",
                         "tout","tous","sinon","m'as","s'il","fai","fair","^"),
              remove_punct = T,stem = T)

# checking top features
topfeatures(mydfm2, 30)
topfeatures(mydfm2, 328)
# checking the context of words
kwic(CTC, "12", 4) # "x" x in its context with 2 words around

TextPair <- as.data.frame(cbind(mydfm2@docvars$docname_,
                                mydfm2@docvars$Pair))
names(TextPair) <- c("Text","Pair")

Graaave <- kwic(CTC, "grave", 1)
Graaave <- filter(Graaave, pre %in% c("pas","Pas"))
TabGrav<- as.data.frame(table(Graaave$docname)) # subjects using "grave"
Gravers <- as.vector(TabGrav$Var1)
Gravers <- filter(TextPair,Text %in% Gravers)
table(filter(DatA, Pair %in% Gravers$Pair, Period==1,ID==1)$Comp)

# Collect pairs IDs where "25.5" appears
j255 <- kwic(CTC, "25.5", 1)
Tabj255<- as.data.frame(table(j255$docname)) # subjects using "grave"
j255ers <- as.vector(Tabj255$Var1)
names(Tabj255) <- c("Text", "Freq")
j255ers <- filter(TextPair,Text %in% j255ers)
j255ers <- as.data.frame(merge(Tabj255,j255ers,by="Text"))

# How many times "25.5" appear in JPM pairs in Comp and Subs?
sum(filter(j255ers, Pair %in% filter(DatA,Period==1,
                                       Chat==1,ID==1, Comp==1)$Pair
             )$Freq)

sum(filter(j255ers, Pair %in% filter(DatA,Period==1,
                                 Chat==1,ID==1, Comp==0)$Pair
)$Freq)



# saving ranks and counts of words
write.csv(topfeatures(mydfm2, 200),"Top200_All_RRD.csv") 
# This file needs to be created for both Str. Env. 
# Then it needs to be polished and transformed for the RRD plot
# A polished one is included in the package as a sample.

# global wordcloud - Figure 7
set.seed(10000)
textplot_wordcloud(mydfm2, min.freq = 10, random.order = F,
                   rot.per = .25, comparison = F,
                   colors = RColorBrewer::brewer.pal(8,"Dark2"))

# RRD ----
#plotting relative rank differences - Figure 8
require(readxl)
RRD<- read_xls("Top200_Alln.xls")
RRD<- filter(RRD,rankS<100) # if necessary, restrict for lower ranks 
require("ggrepel")

# RRD is the basis of Table 7 in Appendix F

ggplot(RRD, aes(x = rankS, y = rankC)) + 
  geom_point(color = ifelse((RRD$rrdC>1|RRD$rrdS>1)&RRD$rankS>5, 
                            "red", "black")) +
  theme_bw() +
  # geom_segment(aes(x=50,xend=86,y=50,yend=50),
  #              linetype = "dotted",
  #              size=0.005)+
  # geom_segment(aes(x=50,xend=50,y=50,yend=100),
  #              linetype = "dotted",
  #              size=0.005)+
   geom_text_repel(aes(label=word),
                  segment.size = 0.3,
                  segment.alpha = 0.75,
                  size=3)+
  ylab("Rank in Complementarity")+
  xlab("Rank in Substitution")+
  geom_line(aes(x = rankS,y = rankS))+
  geom_ribbon(aes(ymin = min, ymax = max, fill = 'prediction'),
              alpha = 0.2,show.legend = F) +
  scale_fill_manual('Interval', values = c('green')) 


## STM analysis Setup ----
# Getting the text data with the help of tm package
OwnStopwords <- c("a","ca","c'est","ou","ça","oui","si","non","quoi","sans","q",
                  "-","ouai","cest","ouais","ah","nan","ok","et","tt","j'avais",
                  "de","le","la","pas","que","en","les","un","mais","est","t'es",
                  "à",'c',"va","une","il","au","ce","des","qu'on","qui","nos",
                  "pour","sur","du","y","se","dans","suis","sa","pas","aller",
                  "on","je","tu","moi","toi","nous","me","te","ne","vas","notre",
                  "avec","etre","par","être","mon","ton","son","leur","ya","m",
                  "ma","sa","ta","ils","j","p","d","donc","alors","cette",
                  "bah","ai","t","l","qu'il","quand","bonjour","mis","dsl",
                  "fait","n","m'a","t'en","qu'ils","cb","mm","très","s",
                  "faire","quon","tes","vera","pr","tres","bjr",
                  "peut","fais","coup","mes","vais","avoir",
                  "apres","chose","là","j'avais","quel","viens","salut",
                  "après","eu","aura","xd","qu","es","x","o","e","as",
                  "j'en","ouii","ont","allez","re","nn","c'était","sous",
                  "tout","tous","sinon","m'as","s'il","fai","fair")


temp <- textProcessor(documents = Chatter$text, 
                      metadata = Chatter, lowercase = TRUE,
              removestopwords = TRUE, removepunctuation = TRUE,
              stem = T, wordLengths = c(2,15),
              language = "french",removenumbers = F ,
              customstopwords=OwnStopwords)

# print stopwords to report - Appendix G1

write.csv(sort(append(stopwords("fr"),OwnStopwords)),"stopwords_fr.csv")

# creating the stm input out
out <- prepDocuments(temp$documents,temp$vocab,temp$meta, lower.thresh = 5) 
# creating the essential elements for stm
docs <- out$documents
vocab <- out$vocab
meta <- out$meta
# which(unlist(lapply(docs, length))>250) Those whose chat exceeds 250 words after this 

#### ----- STM ----
# Initial check over models with internal functions
set.seed(2019) # This is the seed used for the writing of the accepted paper

SK_comp <- searchK(docs, vocab, 
                   K=3:15, 
                   prevalence=~Comp+JPMabel,
                   proportion = 0.5, # Proportion of docs to be held out
                   init.type = "Spectral", # spectral is deterministic
                   data=meta,
                   heldout.seed =2019, # seed 
                   )


plotSearch(SK_comp) # Figure 20 in Appendix G2
# we produce these values for the exact models we estimate
# once the seed is the same it should produce the same values, even for held-out L
# !semantic coherence and exclusivity here does not match the average within topic definition

##--- Model Selection ----

# Estimating models with different K in 3:10. Spectral init. is deterministic, so no seed. 
stm3 <- stm(docs,vocab, data=meta, K= 3, prevalence=~Comp+JPMabel,
            init.type = "Spectral", verbose = T,seed = 2019) 

# Residuals -
checkResiduals(stm3,docs)


# Heldout likelihood --
heldmade<- make.heldout(docs,vocab,seed = 2019) # seed
helddocs <- heldmade$documents
heldvocab <- heldmade$vocab

heldoutstm3 <- stm(helddocs,heldvocab, data=meta, K= 3, prevalence=~Comp+JPMabel,
                   init.type = "Spectral", verbose = F,seed=2019)


eval.heldout(heldoutstm3, heldmade$missing)$expected.heldout




### --- Topic analysis ----
labelTopics(stm3) # topic top words
labelTopics(stm3,n=10)$prob # top words in a matrix
findThoughts(stm3, texts=meta$text,n=5,topics=1)$index # id of exemplary docs
findThoughts(stm3, texts=meta$text,n=2,topics=2)$docs # docs themselves

View(t(stm3$beta$logbeta[[1]])) #log of word probabilities

#View loadings on each document 
View(stm3$theta) # for instance you can look up at a particular document that comes up in findThoughts
meta$Pair # get the pair number matched to the text number

# word clouds for each topic - Figure 9
par(mfrow=c(1,1))
stm::cloud(stm3,topic=1,type = "documents",documents = docs,thresh = 0.25,
           colors = RColorBrewer::brewer.pal(8,"Dark2"), random.order = F) 
stm::cloud(stm3,topic=2,type = "model",documents = docs,thresh = 0.25,
           colors = RColorBrewer::brewer.pal(8,"Dark2"), random.order = F) 
stm::cloud(stm3,topic=3,type = "model",documents = docs,thresh = 0.25,
           colors = RColorBrewer::brewer.pal(8,"Dark2"), random.order = F) 


# Effect Estimations ----
EffectEst3 <- estimateEffect(1:3 ~ JPMabel+Comp, 
                             stm3,
                             meta = out$meta,
                             uncertainty = "Global")



summary(EffectEst3,topics = 3) # getting the regression output


## Covariate effects of topics - Figure 10
plot(EffectEst3, 
     covariate = "Comp",
     model = stm3, 
     method = "difference",
     cov.value1 = "1",
     cov.value2 = "0",
     xlab = c("         Substitution ------- Complementarity"),
     main = NULL,
     xlim = c(-0.5, 0.5),
     labeltype = "custom",
     custom.labels = c('1', '2','3')
     )

plot(EffectEst3, 
     covariate = "JPMabel",
     model = stm3, 
     method = "difference",
     cov.value1 = "1", cov.value2 = "0",
     xlab = c("Non-JPM ------- JPM       "),
     main = NULL,
     xlim = c(-0.5, 0.5),
     labeltype = "custom",
     custom.labels = c('1', '2','3')
     )




# Topic distributions and metadata including pairs ----
deneee <- cbind(select(Chatter,Pair,Comp,JPMabel,Early,text),stm3$theta)
NoTextDene <- select(deneee,-text)

# Plot the topic distributions within pairs in grid
# Figures 21 and 22 in Appendix G3

TopicDist <- data.table(NoTextDene, key=c("Pair","Comp","JPMabel","Early"))
TopicDist <- melt(TopicDist,id= c("Pair","Comp","JPMabel","Early"),value.name="TopicProb")
names(TopicDist) <- c("Pair","Comp","JPMabel","Early","Topic","TopicProb")

# write.csv(TopicDist,"TopicDist.csv")


require(grid);require(gridExtra);

TopicDist$PairType <- with(TopicDist,paste("JPM","=",JPMabel,","," ",
                                               "Early","=",Early,","," ",
                                               "ID","=",Pair,
                                               sep = ""))
TopicDist$PairType2 <-with(TopicDist,
                           ifelse(JPMabel==0,
                                  paste("Non-JPM"," ",Pair,sep = ""),
                                  ifelse(Early==0,
                                         paste("Eventual JPM"," ",Pair,sep = ""), 
                                         paste("Early JPM"," ",Pair,sep = "")
                                  )
                           )
)



PlotGrids <- ggplot(filter(TopicDist,Comp==1),
                    aes(x=as.numeric(Topic),
                                                 y=TopicProb)) + 
  geom_line(group=1) + 
  # scale_y_continuous(limits=c(0, 1), 
  #                    expand = c(0.001, 0),
  #                    breaks=c(0,0.5,1))+
  scale_x_discrete(limits = c("1","2","3"))+
  labs(
  #      title = "Topic Distributions in Pairs: Substitution", 
    y = "Proportion", x = "Topic") 


PlotGrids +   facet_wrap( ~ PairType2, ncol=5) +
  theme(strip.background = element_blank(),
        #        strip.text.x = element_blank()),
        legend.position="none",panel.grid.major = element_blank(),
        panel.border = element_rect(fill=NA),
        panel.background = element_blank())

# Early - Eventual comparison over Str Env ----
# Figure 11
TopicsAndJPM <- aggregate.data.frame(TopicDist$TopicProb,
                                      list(TopicDist$Comp,
                                           TopicDist$JPMabel,
                                           TopicDist$Early,
                                           TopicDist$Topic),mean)
names(TopicsAndJPM) <- c("Comp","JPM","Early","Topic","TopicProb")
TopicsAndJPM$Type <- with(TopicsAndJPM,ifelse(
  JPM == 1 & Early == 1, "Early", ifelse(
    JPM==1 & Early == 0, "Eventual", "Non-JPM"
  )
))
TopicsAndJPM <- TopicsAndJPM[,-c(2,3)]
TopicsAndJPM$Topic<-as.numeric(TopicsAndJPM$Topic)

ggplot(filter(TopicsAndJPM,Comp==0), # Change Comp value for Str.Env.
       aes(x=Topic, y=TopicProb, colour = factor(Type), 
           linetype=factor(Type), shape=factor(Type))) +
  geom_line() +
  geom_point() +
  scale_colour_manual("",values=c("red","blue","darkgreen"),labels=c("Early","Eventual","Non-JPM")) +
  scale_linetype_manual("", values=c(4,1,3),labels=c("Early","Eventual","Non-JPM")) +
  scale_shape_manual("", values=c(1,2,3),labels=c("Early","Eventual","Non-JPM"))+
  theme_bw()+ylab("Topic Probabilities")+
  theme(legend.position="bottom",
        legend.key = element_rect(colour = 'white'))+
  scale_y_continuous(limits = c(0.12,0.8))+
  scale_x_discrete(limits = factor(c(1,2,3)))

# Comparison of the probabilities of interim strategies across Topic 1 and 2
sum(exp(t(stm3$beta$logbeta[[1]])[8:21,1]))/sum(exp(t(stm3$beta$logbeta[[1]])[8:21,2]))


InterimNumb <- c(15,19,51,53,57,58,61,62,65,68:74,86:89,93:96,98:100,103:126)

CountInterimNumb <- numeric(98)
for(i in 1:98){
  CountInterimNumb[i] <- sum(filter(as.data.frame(t(temp$documents[[i]])),V1 %in% InterimNumb)$V2)
}

CountInterimNumb<-as.data.frame(CountInterimNumb)
CountInterimNumb <- as.data.frame(cbind(temp$meta$Pair,CountInterimNumb))

names(CountInterimNumb) <- c("Pair","CountInterimNumb")

CountInterimNumb <- merge(filter(TopicDist,Topic==1),CountInterimNumb,by=c("Pair"))
CountInterimNumb <- CountInterimNumb[,-c(5,6)]

CountInterimNumb$Type <- with(CountInterimNumb,ifelse(
  JPMabel == 1 & Early == 1, "Early", ifelse(
    JPMabel==1 & Early == 0, "Eventual", "Non-JPM"
  )
))

CountInterimNumb <- CountInterimNumb[,-c(3,4)]

mean(filter(CountInterimNumb,Comp==1)$CountInterimNumb)
mean(filter(CountInterimNumb,Comp==0)$CountInterimNumb)

wilcox.test(filter(CountInterimNumb,Comp==1)$CountInterimNumb,
            filter(CountInterimNumb,Comp==0)$CountInterimNumb)

wilcox.test(filter(CountInterimNumb,Comp==1,Type!="Non-JPM")$CountInterimNumb,
            filter(CountInterimNumb,Comp==0,Type!="Non-JPM")$CountInterimNumb)


## printing chat records of particular pairs without long messaging ----

# Pair 397, Comp=1, JPM =1, Early=0, who both use Topic 1 extensively

Pair397 <-select(filter(ChatALL,Crosssect==394|Crosssect==395),
                 chat.Period,chat.TimeStageChatMessage,chat.ID,chat.WORDS)

filter(NoTextDene,Pair==397) # Table 8

write.csv(Pair397,"ChatRecord_Pair397.csv") # Table 9

# Pair1393, Comp=1, JPM=0, who both use Topic 4 eextensively 
Pair1393 <-select(filter(ChatALL,Crosssect==1386|Crosssect==1387),
                 chat.Period,chat.TimeStageChatMessage,chat.ID,chat.WORDS)
filter(NoTextDene,Pair==1393) # Table 10

write.csv(Pair1393,"ChatRecord_Pair1393.csv") # Tables 11-16

# Pair595, Comp=0, JPM=1, Early==1, who both use Topic 6 eextensively 

Pair595 <-select(filter(ChatALL,Crosssect==590|Crosssect==591),
                  chat.Period,chat.TimeStageChatMessage,chat.ID,chat.WORDS)
filter(NoTextDene,Pair==595) # Table 17

write.csv(Pair595,"ChatRecord_Pair595.csv") # Tables 18-19

