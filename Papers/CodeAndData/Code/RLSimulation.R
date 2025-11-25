# Packages ----
library(ggplot2);library(tidyverse);library(latex2exp)

# WD and Source ----
setwd(".../Data") # Set this to your folder where the Data folder is 


# Plot ----


Uniform0108 <- as.data.frame(read.csv("Uniform0108.csv",header=F))
names(Uniform0108) <- c("Period","Comp","Subs")
Uniform0108$Period <- as.numeric(Uniform0108$Period)
Uniform0108$Comp <- as.numeric(Uniform0108$Comp)
Uniform0108$Subs <- as.numeric(Uniform0108$Subs)

Uniform0108 <- gather(Uniform0108, Comp, DegCoop, Comp:Subs, factor_key=F)

Uniform0108$DegCoop<-as.numeric(Uniform0108$DegCoop)

# Figure 4 

ggplot(Uniform0108, aes(x=Period, y=DegCoop,color=Comp, 
                      shape = Comp,show.legend = T
))+ 
    ylab("Degree of Cooperation")+
  theme_bw() + theme(legend.position = "bottom")+ 
  scale_colour_manual("",values=c("blue","red"),
                      labels=c("Complementarity","Substitution")) +
  scale_linetype_manual("", values=c(1,4),
                        labels=c("Complementarity","Substitution")) +
  scale_shape_manual("", values=c(1,1),
                     labels=c("Complementarity","Substitution")) +
  geom_line(aes(linetype = factor(Comp)),show.legend = T) +
  geom_point(show.legend = T) + ylim(c(-0.1,0.1)) 


# Figure 5
UniformData <- as.data.frame(read.csv("UniformAll.csv"))
UniformData$Lambda <- as.factor(UniformData$Lambda)
names(UniformData) <- c("Omega","Dp","Lambda")


# plot
ggplot(UniformData, aes(x=as.numeric(Omega), y=Dp,color=Lambda, 
                        shape = Lambda
))+ 
  ylab(TeX("$\\Delta \\rho = \\rho^{C}-\\rho^{S}$"))+
  xlab(TeX("Recency $(\\omega)$"))+
  scale_colour_manual(name=TeX("Sensitivity $(\\lambda)$"),    # Legend label, use darker colors
                      #                     breaks=c("0","1"),
                      labels=c("0.1", "0.5","0.9","1.5"),
                      values=c("red","blue","darkgreen","brown")) +
  
  scale_shape_manual(name=TeX("Sensitivity $(\\lambda)$"),
                     labels=c("0.1", "0.5","0.9","1.5"),
                     values=c(0:3))+
  scale_linetype_manual(name=TeX("Sensitivity $(\\lambda)$"),
                        labels=c("0.1", "0.5","0.9","1.5"),
                        values=c(1:4))+
  geom_line(aes(linetype = Lambda, color = Lambda),show.legend = T) +
  theme_bw() +
  geom_point(aes(color = Lambda)) +
  ylim(c(-0.3,0.3)) 



  