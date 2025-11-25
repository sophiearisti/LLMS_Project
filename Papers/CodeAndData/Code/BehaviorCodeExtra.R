# Setup and Packages ----



packages <- c("ggplot2","Hmisc","plyr","reshape2","e1071","foreign","dplyr",
              "data.table","grid","gridExtra","zTree","plm","psych",
              "clusrank","plotrix","devtools","purrr","perm","tidyverse",
              "forcats","viridis")
sapply(packages, require, character.only = TRUE)
rm(packages)

# WD
setwd(".../Data") # Set this to your folder where the Data folder is 

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

#ExtraTime sessions

Session32 <- as.data.frame(zTreeTables("180123_0850.xls"))
Session33 <- as.data.frame(zTreeTables("180123_1244.xls"))

Session32<-rename(Session32, globals.PosExt=subjects.PosExt ,
                  globals.StratComp=subjects.StratComp)

Session33<-rename(Session33, globals.PosExt=subjects.PosExt ,
                  globals.StratComp=subjects.StratComp)

Session32$globals.decisionTime <- NULL
Session32$globals.ShowUP <- NULL
Session33$globals.decisionTime <- NULL
Session33$globals.ShowUP <- NULL

Newww<-rbind(Session32,Session33)

# DatALL creation ----
DatALL <- rbind(Session1,Session2,Session3,Session4,Session5,Session6,Session7,Session8,Session9,
                Session10,Session11,Session12,Session13,Session14,Session15,Session16,Session17,
                Session18,Session19,Session20,Session21,Session22,Session23,Session24,
                Session25,Session26,Session27,Session28,Session29,Session30,Session31,Session32,Session33)
DatALLlim <- select(DatALL,Date=subjects.Date,Chat=globals.chatAllowed,
                    Comp=globals.StratComp,Period=subjects.Period,Subject=subjects.Subject,
                    Groupe=subjects.Group, ID=subjects.subjectID,Inv=subjects.Inv,
                    OtherInv=subjects.OtherInv,Payoff=subjects.Profit,
                    OtherPayoff=subjects.OtherProfit,Time=subjects.TimeValiderInvestmentStageOK)

rm(Session1,Session2,Session3,Session4,Session5,Session6,Session7,Session8,Session9,
Session10,Session11,Session12,Session13,Session14,Session15,Session16,Session17,
Session18,Session19,Session20,Session21,Session22,Session23,Session24,
Session25,Session26,Session27,Session28,Session29,Session30,Session31,Session32,Session33)

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
#ExtraTime Sessions
DatA[Date=="180123_0850", `:=`(Market=0, Chat=0, Comp=0, Session=32)]
DatA[Date=="180123_1244", `:=`(Market=0, Chat=0, Comp=0, Session=33)]


DatA$Treat <- with(DatA,(2*Chat-Comp+1))

# Variable Creation ----

DatA$Long <- with(DatA, ifelse(Session <32 ,0, 1))
DatA$LongT <- with(DatA,4*Comp+2*Chat+Long)

DatA$Crosssect <- with(DatA,(Session*100-Subject))
DatA$Pair <- with(DatA,(Session*100-Groupe))

DatA$PairAvePay <- with(DatA,(Payoff+OtherPayoff)/2)
DatA$PairAveCho <- with(DatA,(Inv+OtherInv)/2)
DatA$PairAbsDif <- with(DatA,abs(Inv-OtherInv))

DatA<-as.data.table(DatA)



# Draw extra graph ----
# Figure 15 in Appendix C2
SubAveCho <- aggregate.data.frame(DatA$Inv,
                                  list(Period=DatA$Period,
                                       Comp=DatA$Comp,
                                       Chat=DatA$Chat,
                                       Long=DatA$Long,
                                       Treat=DatA$Treat),mean)

names(SubAveCho)[6] <- "AveCho"
SubAveChoLong <- aggregate.data.frame(DatA$Inv,
                                      list(Period=DatA$Period,
                                           LongT=DatA$LongT),mean)

names(SubAveChoLong)[3] <- "AveCho"



# Draw w/w/out chat 
ggplot(filter(filter(SubAveChoLong,LongT!=6,LongT!=4)), 
       aes(x=Period, y=AveCho, colour = factor(LongT), 
           linetype=factor(LongT), shape=factor(LongT))) +
  geom_line() +
  geom_point() +
  scale_colour_manual("", labels=c("No Communication","Extra Time", "Communication"),
                      values=c("darkred","darkblue","darkgreen")) +
  scale_linetype_manual("", labels=c("No Communication","Extra Time", "Communication"),
                        values=c(1,2,3)) +
  scale_shape_manual("", labels=c("No Communication","Extra Time", "Communication"),
                     values=c(17,16,15))+
  theme_bw()+ylab("Choices")+
  theme(legend.position="bottom",
        legend.background = element_rect(fill=NULL, size=.2,colour = "black"),
        legend.key = element_rect(colour = 'white'))+
  ylim(8, 25)



# Numbers and tests ----
# Table 6 

round(mean(filter(DatA,LongT==1)$Inv),2)
round(sd(filter(DatA,LongT==1)$Inv),2)

length(table(filter(DatA,LongT==1)$Crosssect))

round(mean(filter(DatA,LongT==0)$Inv),2)
round(sd(filter(DatA,LongT==0)$Inv),2)
length(table(filter(DatA,LongT==0)$Crosssect))

round(mean(filter(DatA,LongT==2)$Inv),2)
round(sd(filter(DatA,LongT==2)$Inv),2)
length(table(filter(DatA,LongT==2)$Crosssect))


wilcox.test(filter(DatA,LongT==1)$Inv,filter(DatA,LongT==0)$Inv)
wilcox.test(filter(DatA,LongT==1)$Inv,filter(DatA,LongT==2)$Inv)
wilcox.test(filter(DatA,LongT==2)$Inv,filter(DatA,LongT==0)$Inv)
