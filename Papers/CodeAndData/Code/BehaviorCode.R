# Setup and Packages ----

install.packages(c(
  "Hmisc","plyr","reshape2","data.table","gridExtra",
  "zTree","plm","clusrank","plotrix","perm","tidyverse",
  "viridis","devtools"
))


packages <- c("ggplot2","Hmisc","plyr","reshape2","e1071","foreign","dplyr",
              "data.table","grid","gridExtra","zTree","plm","psych",
              "clusrank","plotrix","devtools","purrr","perm","tidyverse",
              "forcats","viridis")

sapply(packages, require, character.only = TRUE)

rm(packages)


# WD
setwd("~/Documents/GitHub/LLMS_Project/Papers/CodeAndData/Data") # Set this to your folder where the Data folder is

# Session_Naming ----
Session1 <- as.data.frame(zTreeTables("160503_0820_.xls",zTree.encoding = "utf-8",ignore.errors = T))
Session2 <- as.data.frame(zTreeTables("160503_1138.xls"))
Session3 <- as.data.frame(zTreeTables("160510_0920.xls"))
Session4 <- as.data.frame(zTreeTables("160511_0853.xls"))
Session5 <- as.data.frame(zTreeTables("160511_1253.xls"))
Session6 <- as.data.frame(zTreeTables("160511_1426_.xls",zTree.encoding = "utf-8",ignore.errors = T))

Session7 <- as.data.frame(zTreeTables("160512_0953.xls"))
Session8 <- as.data.frame(zTreeTables("160512_1252.xls"))
Session9 <- as.data.frame(zTreeTables("160512_1420_.xls",zTree.encoding = "utf-8",ignore.errors = T))

Session10 <- as.data.frame(zTreeTables("160513_0850_.xls",zTree.encoding = "utf-8",ignore.errors = T))

Session11 <- as.data.frame(zTreeTables("160513_1136.xls"))
Session12 <- as.data.frame(zTreeTables("160513_1422.xls"))
Session13 <- as.data.frame(zTreeTables("160519_0934.xls"))
Session14 <- as.data.frame(zTreeTables("161018_0903.xls"))
Session15 <- as.data.frame(zTreeTables("161018_1209.xls"))
Session16 <- as.data.frame(zTreeTables("161018_1447.xls"))
Session17 <- as.data.frame(zTreeTables("161019_0824_.xls",zTree.encoding = "utf-8",ignore.errors = T))

Session18 <- as.data.frame(zTreeTables("161019_1145.xls"))
Session19 <- as.data.frame(zTreeTables("161019_1411.xls"))
Session20 <- as.data.frame(zTreeTables("170510_0938.xls"))
Session21 <- as.data.frame(zTreeTables("170510_1319.xls"))
Session22 <- as.data.frame(zTreeTables("170516_0848.xls"))
Session23 <- as.data.frame(zTreeTables("170516_1322.xls"))
# Extra sessions
Session24 <- as.data.frame(zTreeTables("211027_0840.xls"))
Session25 <- as.data.frame(zTreeTables("211027_1245.xls"))
Session26 <- as.data.frame(zTreeTables("211027_1527.xls"))
Session27 <- as.data.frame(zTreeTables("211028_0828.xls"))
Session28 <- as.data.frame(zTreeTables("211028_1225.xls"))
Session29 <- as.data.frame(zTreeTables("211118_0854.xls"))
Session30 <- as.data.frame(zTreeTables("211118_1312.xls"))
Session31 <- as.data.frame(zTreeTables("211118_1537.xls"))

# DatALL creation ----
DatALL <- rbind(Session1,Session2,Session3,Session4,Session5,Session6,Session7,Session8,Session9,
                Session10,Session11,Session12,Session13,Session14,Session15,Session16,Session17,
                Session18,Session19,Session20,Session21,Session22,Session23,Session24,
                Session25,Session26,Session27,Session28,Session29,Session30,Session31)
DatALLlim <- select(DatALL,Date=subjects.Date,Chat=globals.chatAllowed,
                    Comp=globals.StratComp,Period=subjects.Period,Subject=subjects.Subject,
                    Groupe=subjects.Group, ID=subjects.subjectID,Inv=subjects.Inv,
                    OtherInv=subjects.OtherInv,Payoff=subjects.Profit,
                    OtherPayoff=subjects.OtherProfit,Time=subjects.TimeValiderInvestmentStageOK)

rm(Session1,Session2,Session3,Session4,Session5,Session6,Session7,Session8,Session9,
Session10,Session11,Session12,Session13,Session14,Session15,Session16,Session17,
Session18,Session19,Session20,Session21,Session22,Session23,Session24,
Session25,Session26,Session27,Session28,Session29,Session30,Session31)

# DatA_debug --------------------------------------------------------------
DatA <- as.data.table(DatALLlim)
DatA <- filter(DatA,ID>0 & Period>0 & Period<31)
DatA <- as.data.table(DatA)
DatA[Date=="160503_0820", `:=`(Market=0, Chat=1, Comp=1, Session=1)]
DatA[Date=="160503_1138", `:=`(Market=0, Chat=0, Comp=1, Session=2)]
DatA[Date=="160510_0920", `:=`(Market=0, Chat=1, Comp=0, Session=3)]
DatA[Date=="160511_0853", `:=`(Market=0, Chat=1, Comp=1, Session=4)]
DatA[Date=="160511_1253", `:=`(Market=0, Chat=0, Comp=0, Session=5)]
DatA[Date=="160511_1426", `:=`(Market=0, Chat=1, Comp=0, Session=6)]
DatA[Date=="160512_0953", `:=`(Market=0, Chat=0, Comp=1, Session=7)]
DatA[Date=="160512_1252", `:=`(Market=0, Chat=0, Comp=0, Session=8)]
DatA[Date=="160512_1420", `:=`(Market=0, Chat=1, Comp=0, Session=9)]
DatA[Date=="160513_0850", `:=`(Market=0, Chat=1, Comp=1, Session=10)]
DatA[Date=="160513_1136", `:=`(Market=0, Chat=0, Comp=0, Session=11)]
DatA[Date=="160513_1422", `:=`(Market=0, Chat=0, Comp=1, Session=12)]
DatA[Date=="160519_0934", `:=`(Market=0, Chat=1, Comp=1, Session=13)]
DatA[Date=="161018_0903", `:=`(Market=0, Chat=1, Comp=1, Session=14)]
DatA[Date=="161018_1209", `:=`(Market=0, Chat=1, Comp=1, Session=15)]
DatA[Date=="161018_1447", `:=`(Market=0, Chat=0, Comp=0, Session=16)]
DatA[Date=="161019_0824", `:=`(Market=0, Chat=1, Comp=1, Session=17)]
DatA[Date=="161019_1145", `:=`(Market=0, Chat=0, Comp=1, Session=18)]
DatA[Date=="161019_1411", `:=`(Market=0, Chat=1, Comp=0, Session=19)]
DatA[Date=="170510_0938", `:=`(Market=0, Chat=1, Comp=1, Session=20)]
DatA[Date=="170510_1319", `:=`(Market=0, Chat=1, Comp=0, Session=21)]
DatA[Date=="170516_0848", `:=`(Market=0, Chat=0, Comp=0, Session=22)]
DatA[Date=="170516_1322", `:=`(Market=0, Chat=0, Comp=0, Session=23)]
# Extra sessions
DatA[Date=="211027_0840", `:=`(Market=0, Chat=0, Comp=1, Session=24)]
DatA[Date=="211027_1245", `:=`(Market=0, Chat=0, Comp=1, Session=25)]
DatA[Date=="211027_1527", `:=`(Market=0, Chat=0, Comp=0, Session=26)]
DatA[Date=="211028_0828", `:=`(Market=0, Chat=0, Comp=1, Session=27)]
DatA[Date=="211028_1225", `:=`(Market=0, Chat=0, Comp=0, Session=28)]
DatA[Date=="211118_0854", `:=`(Market=0, Chat=0, Comp=0, Session=29)]
DatA[Date=="211118_1312", `:=`(Market=0, Chat=1, Comp=0, Session=30)]
DatA[Date=="211118_1537", `:=`(Market=0, Chat=1, Comp=0, Session=31)]

DatA$Treat <- with(DatA,(2*Chat-Comp+1)) # Treatment variable 
# NoChat-Subs: 1, NoChat-Comp: 0, Chat-Subs: 3, ChatComp: 2

# Table 1
table(filter(DatA,Period==1)$Treat) # This gives the subject numbers at each sessions
table(filter(DatA,Period==1,Treat==0)$Session) # This and below give subject numberss at each session for each treatment
table(filter(DatA,Period==1,Treat==1)$Session)
table(filter(DatA,Period==1,Treat==2)$Session)
table(filter(DatA,Period==1,Treat==3)$Session)

# Variable Creation ----

DatA$Crosssect <- with(DatA,(Session*100-Subject))
DatA$Pair <- with(DatA,(Session*100-Groupe))

DatA$PairAvePay <- with(DatA,(Payoff+OtherPayoff)/2)
DatA$PairAveCho <- with(DatA,(Inv+OtherInv)/2)
DatA$PairAbsDif <- with(DatA,abs(Inv-OtherInv))

DatA<-as.data.table(DatA)

DatA[, Linv:=c(NA, Inv[-.N]),by=list(Crosssect)]
DatA[, Lotherinv:=c(NA, OtherInv[-.N]),by=list(Crosssect)]
DatA[, LLotherinv:=c(NA, Lotherinv[-.N]),by=list(Crosssect)]

DatA<-as.data.frame(DatA)

DatA$DegCoopPair <- with(DatA, (PairAveCho-14)/11.5)
DatA$DegCoopInd <- with(DatA, (Inv-14)/11.5)

# Choices smaller than 1. 
DatA$ZeroCho <- with(DatA, ifelse(Inv >1 ,0, 1))

# Average choices and payoffs 
AveChoice <- as.data.frame(stats::aggregate(DatA$Inv, 
                                       by=list(DatA$Crosssect,DatA$Comp,DatA$Chat),
                                       FUN=mean))
names(AveChoice) <- c("Crosssect","Comp","Chat","AveCho")
DatA<-merge(DatA, AveChoice, by = c("Crosssect","Comp","Chat"))

AvePayoff <- as.data.frame(aggregate(DatA$Payoff, 
                                     by=list(DatA$Crosssect,DatA$Comp,DatA$Chat),
                                     FUN=mean))
names(AvePayoff) <- c("Crosssect","Comp","Chat","AvePay")
DatA<-merge(DatA, AvePayoff, by = c("Crosssect","Comp","Chat"))


## JPM pairs with [25,26]
#JPM pairs three or more times in last 7 periods

DatA$JPM <- with(DatA, ifelse(Inv >= 25 & Inv <=26,1, 0))
DatA$JPMother <- with(DatA, ifelse(OtherInv >= 25 & OtherInv <=26,1, 0))
DatA$JPMpair <- with(DatA, ifelse(JPM==1&JPMother==1,1, 0))

Last7pair <- as.data.frame(aggregate(filter(DatA,Period>23)$JPMpair, 
                                     by=list(filter(DatA,Period>23)$Crosssect),
                                     FUN=sum))
names(Last7pair) <- c("Crosssect","NumbLast7pair")
Last7pair$JPMabel <- with(Last7pair,ifelse(NumbLast7pair>2,1, 0))
DatA<-merge(DatA, Last7pair, by = c("Crosssect"))

DatA$Great24 <- with(DatA, ifelse(Inv >= 24,1,0))
DatA$Great24other <- with(DatA, ifelse(OtherInv >= 24,1, 0))
DatA$Great24pair <- with(DatA, ifelse(Great24==1&Great24other==1,1, 0))

##JPM pairs who try at least once in all experiment

AllJPMOncepair <- as.data.frame(aggregate(filter(DatA,Period>0)$JPMpair, 
                                  by=list(filter(DatA,Period>0)$Crosssect),
                                  FUN=sum))
names(AllJPMOncepair) <- c("Crosssect","NumbAllJPMpair")
AllJPMOncepair$JPMOnceabel <- with(AllJPMOncepair,ifelse(NumbAllJPMpair>0,1, 0))
DatA<-merge(DatA, AllJPMOncepair, by = c("Crosssect"))


### JPM subjects
## Who try once in all periods
NumJPMsubAll <- as.data.frame(aggregate(DatA$JPM, 
                                     by=list(DatA$Crosssect),
                                     FUN=sum))
names(NumJPMsubAll) <- c("Crosssect","NumbJPMsubAll")
NumJPMsubAll$JPMSubAllabel <- with(NumJPMsubAll,ifelse(NumbJPMsubAll>0,1, 0))
DatA<-merge(DatA, NumJPMsubAll, by = c("Crosssect"))

#Subjects that try JPM once

#1st period
NumJPMsub1 <- as.data.frame(aggregate(filter(DatA,Period==1)$JPM, 
                                        by=list(filter(DatA,Period==1)$Crosssect),
                                        FUN=sum))
names(NumJPMsub1) <- c("Crosssect","NumbJPMsub1")
NumJPMsub1$JPMSub1abel <- with(NumJPMsub1,ifelse(NumbJPMsub1>0,1, 0))
DatA<-merge(DatA, NumJPMsub1, by = c("Crosssect"))

#1-5 periods
NumJPMsub15 <- as.data.frame(aggregate(filter(DatA,Period>0,Period<6)$JPM, 
                                      by=list(filter(DatA,Period>0,Period<6)$Crosssect),
                                      FUN=sum))
names(NumJPMsub15) <- c("Crosssect","NumbJPMsub15")
NumJPMsub15$JPMSub15abel <- with(NumJPMsub15,ifelse(NumbJPMsub15>0,1, 0))
DatA<-merge(DatA, NumJPMsub15, by = c("Crosssect"))

#1-15 periods
NumJPMsub115 <- as.data.frame(aggregate(filter(DatA,Period>0,Period<16)$JPM, 
                                       by=list(filter(DatA,Period>0,Period<16)$Crosssect),
                                       FUN=sum))
names(NumJPMsub115) <- c("Crosssect","NumbJPMsub115")
NumJPMsub115$JPMSub115abel <- with(NumJPMsub115,ifelse(NumbJPMsub115>0,1, 0))
DatA<-merge(DatA, NumJPMsub115, by = c("Crosssect"))

#1-10 periods
NumJPMsub110 <- as.data.frame(aggregate(filter(DatA,Period>0,Period<11)$JPM, 
                                        by=list(filter(DatA,Period>0,Period<11)$Crosssect),
                                        FUN=sum))
names(NumJPMsub110) <- c("Crosssect","NumbJPMsub110")
NumJPMsub110$JPMSub110abel <- with(NumJPMsub110,ifelse(NumbJPMsub110>0,1, 0))
DatA<-merge(DatA, NumJPMsub110, by = c("Crosssect"))

#16-30 periods
NumJPMsub1630 <- as.data.frame(aggregate(filter(DatA,Period>15,Period<31)$JPM, 
                                        by=list(filter(DatA,Period>15,Period<31)$Crosssect),
                                        FUN=sum))
names(NumJPMsub1630) <- c("Crosssect","NumbJPMsub1630")
NumJPMsub1630$JPMSub1630abel <- with(NumJPMsub1630,ifelse(NumbJPMsub1630>0,1, 0))
DatA<-merge(DatA, NumJPMsub1630, by = c("Crosssect"))

## JPM early on, JPM eventually, and non-JPM

First10periods <- as.data.frame(aggregate(filter(DatA,Period>0,Period<11)$Great24pair, 
                                     by=list(filter(DatA,Period>0,Period<11)$Crosssect),
                                     FUN=sum))
names(First10periods) <- c("Crosssect","NumFirst10")

First10periods$Event <- with(First10periods,ifelse(NumFirst10<6,1, 0))
DatA<-merge(DatA, First10periods, by = c("Crosssect"))
DatA$Event <- with(DatA, ifelse(Event==1 & JPMabel==1,1,0))

DatA <- as.data.table(DatA)

DatA$Early <- with(DatA, ifelse(Event==0 & JPMabel==1,1,0))
DatA$NotAtAll <- with(DatA, ifelse(Event==0 & JPMabel==0,1,0))

DatA <- as.data.frame(DatA)

# Reduce pairs to individuals
ddddd<-as.data.table(filter(DatA,ID==1)) 

--------------- ## Analysis ## ---------------------

# #Degrees of cooperation ----
## Table 2 for Chat

ChatAveDeg130 <- as.data.frame(aggregate(filter(DatA,Chat==1,ID==1)$DegCoopPair, 
                                         by=list(filter(DatA,Chat==1,ID==1)$Crosssect,
                                                 filter(DatA,Chat==1,ID==1)$Comp),
                                         FUN=ave))

names(ChatAveDeg130) <- c("Crosssect","Comp","AveDegCoop")
ChatAveDeg130$AveDegCoop<-ChatAveDeg130$AveDegCoop[,1]

round(mean(filter(ChatAveDeg130,Comp==0)$AveDegCoop),2)
round(sd(filter(ChatAveDeg130,Comp==0)$AveDegCoop),2)

round(mean(filter(ChatAveDeg130,Comp==1)$AveDegCoop),2)
round(sd(filter(ChatAveDeg130,Comp==1)$AveDegCoop),2)

wilcox.test(AveDegCoop~Comp,data=ChatAveDeg130,alternative="l")



ChatAveDeg115 <- as.data.frame(aggregate(filter(DatA,Chat==1,ID==1,Period>0,Period<16)$DegCoopPair, 
                                         by=list(filter(DatA,Chat==1,ID==1,Period>0,Period<16)$Crosssect,
                                                 filter(DatA,Chat==1,ID==1,Period>0,Period<16)$Comp),
                                         FUN=ave))

names(ChatAveDeg115) <- c("Crosssect","Comp","AveDegCoop")
ChatAveDeg115$AveDegCoop<-ChatAveDeg115$AveDegCoop[,1]

round(mean(filter(ChatAveDeg115,Comp==0)$AveDegCoop),2)
round(sd(filter(ChatAveDeg115,Comp==0)$AveDegCoop),2)

round(mean(filter(ChatAveDeg115,Comp==1)$AveDegCoop),2)
round(sd(filter(ChatAveDeg115,Comp==1)$AveDegCoop),2)

wilcox.test(AveDegCoop~Comp,data=ChatAveDeg115,alternative="l")


ChatAveDeg1630 <- as.data.frame(aggregate(filter(DatA,Chat==1,ID==1,Period>15,Period<31)$DegCoopPair, 
                                          by=list(filter(DatA,Chat==1,ID==1,Period>15,Period<31)$Crosssect,
                                                  filter(DatA,Chat==1,ID==1,Period>15,Period<31)$Comp),
                                          FUN=ave))

names(ChatAveDeg1630) <- c("Crosssect","Comp","AveDegCoop")
ChatAveDeg1630$AveDegCoop<-ChatAveDeg1630$AveDegCoop[,1]

round(mean(filter(ChatAveDeg1630,Comp==0)$AveDegCoop),2)
round(sd(filter(ChatAveDeg1630,Comp==0)$AveDegCoop),2)

round(mean(filter(ChatAveDeg1630,Comp==1)$AveDegCoop),2)
round(sd(filter(ChatAveDeg1630,Comp==1)$AveDegCoop),2)

wilcox.test(AveDegCoop~Comp,data=ChatAveDeg1630,alternative="l")


round(mean(filter(DatA,Chat==1,Period==1,Comp==1)$DegCoopInd),2)
round(sd(filter(DatA,Chat==1,Period==1,Comp==1)$DegCoopInd),2)

round(mean(filter(DatA,Chat==1,Period==1,Comp==0)$DegCoopInd),2)
round(sd(filter(DatA,Chat==1,Period==1,Comp==0)$DegCoopInd),2)

wilcox.test(filter(DatA,Chat==1,Period==1,Comp==1)$DegCoopInd,
            filter(DatA,Chat==1,Period==1,Comp==0)$DegCoopInd,alternative="g")

round(mean(filter(DatA,Chat==1,Period==30,Comp==1,ID==1)$DegCoopPair),2)
round(sd(filter(DatA,Chat==1,Period==30,Comp==1,ID==1)$DegCoopPair),2)

round(mean(filter(DatA,Chat==1,Period==30,Comp==0,ID==1)$DegCoopPair),2)
round(sd(filter(DatA,Chat==1,Period==30,Comp==0,ID==1)$DegCoopPair),2)

wilcox.test(filter(DatA,Chat==1,Period==30,Comp==1,ID==1)$DegCoopPair,
            filter(DatA,Chat==1,Period==30,Comp==0,ID==1)$DegCoopPair,alternative="g")


## Table 2 for No Chat
NoChatAveDeg130 <- as.data.frame(aggregate(filter(DatA,Chat==0,ID==1)$DegCoopPair, 
                                           by=list(filter(DatA,Chat==0,ID==1)$Crosssect,
                                                   filter(DatA,Chat==0,ID==1)$Comp),
                                           FUN=mean))

names(NoChatAveDeg130) <- c("Crosssect","Comp","AveDegCoop")

round(mean(filter(NoChatAveDeg130,Comp==0)$AveDegCoop),2)
round(sd(filter(NoChatAveDeg130,Comp==0)$AveDegCoop),2)

round(mean(filter(NoChatAveDeg130,Comp==1)$AveDegCoop),2)
round(sd(filter(NoChatAveDeg130,Comp==1)$AveDegCoop),2)

wilcox.test(AveDegCoop~Comp,data=NoChatAveDeg130,alternative="l")



NoChatAveDeg115 <- as.data.frame(aggregate(filter(DatA,Chat==0,ID==1,Period>0,Period<16)$DegCoopPair, 
                                           by=list(filter(DatA,Chat==0,ID==1,Period>0,Period<16)$Crosssect,
                                                   filter(DatA,Chat==0,ID==1,Period>0,Period<16)$Comp),
                                           FUN=mean))

names(NoChatAveDeg115) <- c("Crosssect","Comp","AveDegCoop")

round(mean(filter(NoChatAveDeg115,Comp==0)$AveDegCoop),2)
round(sd(filter(NoChatAveDeg115,Comp==0)$AveDegCoop),2)

round(mean(filter(NoChatAveDeg115,Comp==1)$AveDegCoop),2)
round(sd(filter(NoChatAveDeg115,Comp==1)$AveDegCoop),2)

wilcox.test(AveDegCoop~Comp,data=NoChatAveDeg115,alternative="l")


NoChatAveDeg1630 <- as.data.frame(aggregate(filter(DatA,Chat==0,ID==1,Period>15,Period<31)$DegCoopPair, 
                                            by=list(filter(DatA,Chat==0,ID==1,Period>15,Period<31)$Crosssect,
                                                    filter(DatA,Chat==0,ID==1,Period>15,Period<31)$Comp),
                                            FUN=mean))

names(NoChatAveDeg1630) <- c("Crosssect","Comp","AveDegCoop")

round(mean(filter(NoChatAveDeg1630,Comp==0)$AveDegCoop),2)
round(sd(filter(NoChatAveDeg1630,Comp==0)$AveDegCoop),2)

round(mean(filter(NoChatAveDeg1630,Comp==1)$AveDegCoop),2)
round(sd(filter(NoChatAveDeg1630,Comp==1)$AveDegCoop),2)

wilcox.test(AveDegCoop~Comp,data=NoChatAveDeg1630,alternative="l")


round(mean(filter(DatA,Chat==0,Period==1,Comp==1)$DegCoopInd),2)
round(sd(filter(DatA,Chat==0,Period==1,Comp==1)$DegCoopInd),2)

round(mean(filter(DatA,Chat==0,Period==1,Comp==0)$DegCoopInd),2)
round(sd(filter(DatA,Chat==0,Period==1,Comp==0)$DegCoopInd),2)

wilcox.test(filter(DatA,Chat==0,Period==1,Comp==1)$DegCoopInd,
            filter(DatA,Chat==0,Period==1,Comp==0)$DegCoopInd,alternative="g")

round(mean(filter(DatA,Chat==0,Period==30,Comp==1,ID==1)$DegCoopPair),2)
round(sd(filter(DatA,Chat==0,Period==30,Comp==1,ID==1)$DegCoopPair),2)

round(mean(filter(DatA,Chat==0,Period==30,Comp==0,ID==1)$DegCoopPair),2)
round(sd(filter(DatA,Chat==0,Period==30,Comp==0,ID==1)$DegCoopPair),2)

wilcox.test(filter(DatA,Chat==0,Period==30,Comp==1,ID==1)$DegCoopPair,
            filter(DatA,Chat==0,Period==30,Comp==0,ID==1)$DegCoopPair,alternative="g")


## Ave degree of cooperation plot -  Figure 2

SubAveDeg <- aggregate.data.frame(ddddd$DegCoopPair,
                                  list(Period=ddddd$Period,
                                       Comp=ddddd$Comp,
                                       Chat=ddddd$Chat),mean)

names(SubAveDeg)[4] <- "AveDeg"

## Plot of JPM vs NonJPM deg of cooperation with communication

AveDegCoopInd <- aggregate.data.frame(DatA$DegCoopInd,
                                      list(Period=DatA$Period,
                                           Comp=DatA$Comp,
                                           Chat=DatA$Chat,
                                           JPM=DatA$JPMabel),mean)

names(AveDegCoopInd)[5] <- "AveDeg"

## Plot of payoffs with and without communication

AvePayoffPeriod <- aggregate.data.frame(DatA$Payoff,
                                      list(Period=DatA$Period,
                                           Comp=DatA$Comp,
                                           Chat=DatA$Chat),mean)

names(AvePayoffPeriod)[4] <- "AvePay"

# Plot degrees of cooperation and payoffs ----
#Plot all treatments - Figure 2

SubAveDeg.merged<-SubAveDeg
SubAveDeg.merged$int <- paste(SubAveDeg$Comp, SubAveDeg$Chat, sep=".")

ggplot(SubAveDeg.merged, aes(x=Period, y=AveDeg, colour = int, linetype=int, shape=int)) +
  geom_line() +
  geom_point() +
  theme_bw() + ylim(c(-0.5,1.0)) + theme(legend.position = "bottom")+ 
  ylab("Degree of Cooperation")+
  scale_colour_manual("",values=c("red","red","blue","blue"),
                      labels=c("Subs. without comm.", "Subs. with comm.",
                               "Comp. without comm.","Comp. with comm.")) +
  scale_linetype_manual("", values=c(4,4,1,1),labels=c("Subs. without comm.", "Subs. with comm.",
                                                       "Comp. without comm.","Comp. with comm.")) +
  scale_shape_manual("", values=c(1,3,1,3),labels=c("Subs. without comm.", "Subs. with comm.",
                                                    "Comp. without comm.","Comp. with comm."))

# JPM plots with communication - Figure 3
AveDegCoopInd.merged<-AveDegCoopInd
AveDegCoopInd.merged$int <- paste(AveDegCoopInd$Comp, AveDegCoopInd$JPM, sep=".")

ggplot(filter(AveDegCoopInd.merged,Chat==1), aes(x=Period, y=AveDeg, colour = int, 
                                          linetype=int, shape=int)) +
  geom_line() +
  geom_point() +
  theme_bw() + ylim(c(-0.5,1.1)) + theme(legend.position = "bottom")+ 
  ylab("Degree of Cooperation")+
  scale_colour_manual("",values=c("red","red","blue","blue"),labels=c("Non-JPM in Subs.","JPM in Subs.",
                                                                      "Non-JPM in Comp.","JPM in Comp.")) +
  scale_linetype_manual("", values=c(4,4,1,1),labels=c("Non-JPM in Subs.","JPM in Subs.",
                                                       "Non-JPM in Comp.","JPM in Comp.")) +
  scale_shape_manual("", values=c(1,3,1,3),labels=c("Non-JPM in Subs.","JPM in Subs.",
                                                    "Non-JPM in Comp.","JPM in Comp."))


# Payoff plots with and without communication - Figure 14 in Appendix C1
AvePayoffPeriod.merged<-AvePayoffPeriod
AvePayoffPeriod.merged$int <- paste(AvePayoffPeriod$Comp, AvePayoffPeriod$Chat, sep=".")

ggplot(AvePayoffPeriod.merged, aes(x=Period, y=AvePay, colour = int, 
                                                 linetype=int, shape=int)) +
  geom_line() +
  geom_point() +
  theme_bw() + ylim(c(5,41))+ theme(legend.position = "bottom")+ 
  ylab("Payoff")+
  scale_colour_manual("",values=c("red","red","blue","blue"),
                      labels=c("Subs. without comm.", "Subs. with comm.",
                               "Comp. without comm.","Comp. with comm.")) +
  scale_linetype_manual("", values=c(4,4,1,1),labels=c("Subs. without comm.", "Subs. with comm.",
                                                       "Comp. without comm.","Comp. with comm.")) +
  scale_shape_manual("", values=c(1,3,1,3),labels=c("Subs. without comm.", "Subs. with comm.",
                                                           "Comp. without comm.","Comp. with comm."))

# Payoff comparisons 

round(mean(filter(DatA,Chat==0,Comp==0)$Payoff),2)
round(mean(filter(DatA,Chat==0,Comp==1)$Payoff),2)
round(mean(filter(DatA,Chat==1,Comp==0)$Payoff),2)
round(mean(filter(DatA,Chat==1,Comp==1)$Payoff),2)

wilcox.test(filter(DatA,Chat==0,Comp==1)$Payoff,
            filter(DatA,Chat==0,Comp==0)$Payoff,alternative = "g")

wilcox.test(filter(DatA,Chat==1,Comp==1)$Payoff,
            filter(DatA,Chat==1,Comp==0)$Payoff,alternative = "g")


# JPM Analysis ----
## JPM Individual
length(table(filter(ddddd,Chat==1,Comp==1,JPMabel==1)$Crosssect))
length(table(filter(ddddd,Chat==1,Comp==0,JPMabel==1)$Crosssect))
length(table(filter(ddddd,Chat==0,Comp==0,JPMabel==1)$Crosssect))
length(table(filter(ddddd,Chat==0,Comp==1,JPMabel==1)$Crosssect))

## JPM Pair



## Reproduce Table 2 in Potters and Suetens for Chat and JPM
ChatAveDeg130J <- as.data.frame(aggregate(filter(DatA,Chat==1,JPMabel==1, ID==1)$DegCoopPair, 
                                         by=list(filter(DatA,Chat==1,JPMabel==1,ID==1)$Crosssect,
                                                 filter(DatA,Chat==1,JPMabel==1,ID==1)$Comp),
                                         FUN=ave))

names(ChatAveDeg130J) <- c("Crosssect","Comp","AveDegCoop")
ChatAveDeg130J$AveDegCoop<-ChatAveDeg130J$AveDegCoop[,1]

ChatAveDeg115J <- as.data.frame(aggregate(filter(DatA,Chat==1,ID==1,JPMabel==1,Period>0,Period<16)$DegCoopPair, 
                                         by=list(filter(DatA,Chat==1,ID==1,JPMabel==1,Period>0,Period<16)$Crosssect,
                                                 filter(DatA,Chat==1,ID==1,JPMabel==1,Period>0,Period<16)$Comp),
                                         FUN=ave))

names(ChatAveDeg115J) <- c("Crosssect","Comp","AveDegCoop")
ChatAveDeg115J$AveDegCoop<-ChatAveDeg115J$AveDegCoop[,1]


ChatAveDeg1630J <- as.data.frame(aggregate(filter(DatA,Chat==1,ID==1,JPMabel==1,Period>15,Period<31)$DegCoopPair, 
                                          by=list(filter(DatA,Chat==1,ID==1,JPMabel==1,Period>15,Period<31)$Crosssect,
                                                  filter(DatA,Chat==1,ID==1,JPMabel==1,Period>15,Period<31)$Comp),
                                          FUN=ave))

names(ChatAveDeg1630J) <- c("Crosssect","Comp","AveDegCoop")
ChatAveDeg1630J$AveDegCoop<-ChatAveDeg1630J$AveDegCoop[,1]

# wilcox test for intervals of periods
wilcox.test(filter(ChatAveDeg1630,Comp==1)$AveDegCoop,
            filter(ChatAveDeg1630,Comp==0)$AveDegCoop,alternative="greater")
# wilcox test for singular 1 and 30 periods
#30th:
wilcox.test(filter(DatA,Chat==1,ID==1,Comp==1,Period==30)$DegCoopPair,
            filter(DatA,Chat==1,ID==1,Comp==0,Period==30)$DegCoopPair,alternative = "greater")
#1st:
wilcox.test(filter(DatA,Chat==1,Comp==1,Period==1)$DegCoopInd,
            filter(DatA,Chat==1,Comp==0,Period==1)$DegCoopInd,alternative = "greater")

#Fisher test for number/percentage of subjects who play JPM at least once
fisher.test(cbind(c(length(table(filter(DatA,Chat==0,Comp==1,JPMSubAllabel==1)$Crosssect)),
                    length(table(filter(DatA,Chat==0,Comp==1,JPMSubAllabel==0)$Crosssect))),
                  c(length(table(filter(DatA,Chat==0,Comp==0,JPMSubAllabel==1)$Crosssect)),
                    length(table(filter(DatA,Chat==0,Comp==0,JPMSubAllabel==0)$Crosssect)))))

fisher.test(cbind(c(length(table(filter(ddddd,Chat==1,Comp==1,JPMOnceabel==1)$Crosssect)),
                    length(table(filter(ddddd,Chat==1,Comp==1,JPMOnceabel==0)$Crosssect))),
                  c(length(table(filter(ddddd,Chat==1,Comp==0,JPMOnceabel==1)$Crosssect)),
                    length(table(filter(ddddd,Chat==1,Comp==0,JPMOnceabel==0)$Crosssect)))))

fisher.test(cbind(c(length(table(filter(ddddd,Chat==1,Comp==1,JPMabel==1)$Crosssect)),
                    length(table(filter(ddddd,Chat==1,Comp==1,JPMabel==0)$Crosssect))),
                  c(length(table(filter(ddddd,Chat==1,Comp==0,JPMabel==1)$Crosssect)),
                    length(table(filter(ddddd,Chat==1,Comp==0,JPMabel==0)$Crosssect)))))


## Reproduce Table 2 in Potters and Suetens for Chat and non-JPM
ChatAveDeg130nJ <- as.data.frame(aggregate(filter(DatA,Chat==1,JPMabel==0, ID==1)$DegCoopPair, 
                                          by=list(filter(DatA,Chat==1,JPMabel==0,ID==1)$Crosssect,
                                                  filter(DatA,Chat==1,JPMabel==0,ID==1)$Comp),
                                          FUN=ave))

names(ChatAveDeg130nJ) <- c("Crosssect","Comp","AveDegCoop")
ChatAveDeg130nJ$AveDegCoop<-ChatAveDeg130nJ$AveDegCoop[,1]

ChatAveDeg115nJ <- as.data.frame(aggregate(filter(DatA,Chat==1,ID==1,JPMabel==0,Period>0,Period<16)$DegCoopPair, 
                                          by=list(filter(DatA,Chat==1,ID==1,JPMabel==0,Period>0,Period<16)$Crosssect,
                                                  filter(DatA,Chat==1,ID==1,JPMabel==0,Period>0,Period<16)$Comp),
                                          FUN=ave))

names(ChatAveDeg115nJ) <- c("Crosssect","Comp","AveDegCoop")
ChatAveDeg115nJ$AveDegCoop<-ChatAveDeg115nJ$AveDegCoop[,1]


ChatAveDeg1630nJ <- as.data.frame(aggregate(filter(DatA,Chat==1,ID==1,JPMabel==0,Period>15,Period<31)$DegCoopPair, 
                                           by=list(filter(DatA,Chat==1,ID==1,JPMabel==0,Period>15,Period<31)$Crosssect,
                                                   filter(DatA,Chat==1,ID==1,JPMabel==0,Period>15,Period<31)$Comp),
                                           FUN=ave))

names(ChatAveDeg1630nJ) <- c("Crosssect","Comp","AveDegCoop")
ChatAveDeg1630nJ$AveDegCoop<-ChatAveDeg1630nJ$AveDegCoop[,1]

# wilcox test for intervals of periods
wilcox.test(filter(ChatAveDeg130nJ,Comp==1)$AveDegCoop,
            filter(ChatAveDeg130nJ,Comp==0)$AveDegCoop,alternative="greater")
# wilcox test for singular 1 and 30 periods
#30th:
wilcox.test(filter(DatA,Chat==1,ID==1,JPMabel==0,Comp==1,Period==30)$DegCoopPair,
            filter(DatA,Chat==1,ID==1,JPMabel==0,Comp==0,Period==30)$DegCoopPair,alternative = "greater")
#1st:
wilcox.test(filter(DatA,Chat==1,JPMabel==0,Comp==1,Period==1)$DegCoopInd,
            filter(DatA,Chat==1,JPMabel==0,Comp==0,Period==1)$DegCoopInd,alternative = "greater")

## Number of subjects who try JPM at least once: 
#for all periods
length(filter(DatA,Period==1,Chat==0,Comp==0)$JPMSubAllabel) #vs 
sum(filter(DatA,Period==1,Chat==0,Comp==0)$JPMSubAllabel)

#for period 1
length(filter(DatA,Period==1,Chat==0,Comp==0)$JPMSub1abel) #vs 
sum(filter(DatA,Period==1,Chat==0,Comp==0)$JPMSub1abel) #vs 

## Wilcox test for payoffs 

NoChatAvePay130 <- as.data.frame(aggregate(filter(DatA,Chat==0)$Payoff, 
                                           by=list(filter(DatA,Chat==0)$Crosssect,
                                                   filter(DatA,Chat==0)$Comp),
                                           FUN=ave))

names(NoChatAvePay130) <- c("Crosssect","Comp","AvePay")
NoChatAvePay130$AvePay<-NoChatAvePay130$AvePay[,1]


wilcox.test(filter(DatA,Chat==1,Comp==1,Period>0)$Payoff,
            filter(DatA,Chat==1,Comp==0,Period>0)$Payoff,alternative = "less")


# Number of pairs who try JPM once 
table(filter(ddddd,Chat==0,Comp==0,JPMOnceabel==1)$Pair)
table(filter(ddddd,Chat==0,Comp==1,JPMOnceabel==1)$Pair)

# Comparing early and event across SE 
length(filter(DatA,Period==1,Chat==1,Comp==0,Event==1)$Pair)/length(filter(DatA,Period==1,Chat==1,Comp==0,Early==0)$Pair)
length(filter(DatA,Period==1,Chat==1,Comp==1,Event==1)$Pair)/length(filter(DatA,Period==1,Chat==1,Comp==1,Early==0)$Pair)

# Pair graphs grid ----

# Create labels for the pair grid graph - Figures 16 to 19 in Appendices D and E (change Chat and Comp values in ggplot function)
ddddd$PairType <- with(ddddd,
                       ifelse(NotAtAll==1,
                              paste("Non-JPM"," ",Pair,sep = ""),
                              ifelse(Event==1,
                                     paste("Eventual JPM"," ",Pair,sep = ""), 
                                     paste("Early JPM"," ",Pair,sep = "")
                              )
                       )
)

PlotGrids <- ggplot(filter(ddddd,Chat==1,Comp==0), aes(Period)) + 
  geom_line(aes(y = Inv, linetype  = "OtherInv")) + 
  geom_line(aes(y = OtherInv, colour = "Inv")) +
  scale_y_continuous(limits=c(-0.25, 28.25), 
                     expand = c(0.001, 0),
                     breaks=c(0, 10, 14,28))+
  scale_x_continuous(breaks=c(1,5,10,15,20,25,30))+
  labs(
#    title = "Comp - Chat", 
    y = "Choices", x = "Period")
  

PlotGrids +
  geom_hline(yintercept = 25.5,
             linetype="dotted",
             color = "darkgreen", 
             size=0.5) +   facet_wrap( ~ PairType, ncol=5) +
  theme(strip.background = element_blank(),
  #      strip.text.x = element_blank(),
        legend.position="none",
        panel.grid.major = element_blank(),
        panel.border = element_rect(fill=NA),
        panel.background = element_blank())



--------------- ## STATA and Mathematica export ## ---------------------
# For Stata ----

DatA$DLotherinv <- with(DatA,Lotherinv-LLotherinv)
DatA$DInv <- with(DatA,Inv-Linv)
DatA$CompDLotherinv <- with(DatA,Comp*DLotherinv)
DatA$Linv[is.na(DatA$Linv)] <- 999
DatA$Lotherinv[is.na(DatA$Lotherinv)] <- 999
DatA$LLotherinv[is.na(DatA$LLotherinv)] <- 999
DatA$DLotherinv[is.na(DatA$DLotherinv)] <- 999
DatA$DInv[is.na(DatA$DInv)] <- 999
DatA$CompDLotherinv[is.na(DatA$CompDLotherinv)] <- 999

write.csv(DatA, "Data_for_Stata.csv")

## change this to xls in Excel afterwards 

# For Mathematica MLE execise for RL ----
MathDatA <- select(filter(DatA,Chat==0),Session,Crosssect,Comp,Pair,Period,Subject,
                   Groupe,ID,Inv,OtherInv,Payoff,OtherPayoff)

write.csv(MathDatA, "Data_for_RL_MLE.csv")

MathDatASubs <- select(filter(DatA,Chat==0,Comp==0),Subject=Crosssect,
                       Comp,Period,Inv,OtherInv,Payoff,OtherPayoff)
MathDatAComp <- select(filter(DatA,Chat==0,Comp==1),Subject=Crosssect,
                       Comp,Period,Inv,OtherInv,Payoff,OtherPayoff)

write.csv(MathDatASubs, "MathDatASubs.csv")
write.csv(MathDatAComp, "MathDatAComp.csv")

