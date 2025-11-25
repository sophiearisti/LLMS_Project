# Setup ----
library(dplyr)
setwd(".../Data") # Set this to your folder where the Data folder is 
dataAll <- read.csv("Data_for_RL_MLE.csv")

# Rename variables
names(dataAll)[names(dataAll) == 'Inv'] <- 'choice'
names(dataAll)[names(dataAll) == 'Payoff'] <- 'reward'
# Recode negative payoffs (just one instance)
dataAll$choice <-with(dataAll,ifelse(choice>=0,choice,0))
# Separate treatments
dataSUBS <- filter(dataAll,Comp==0)
dataCOMP <- filter(dataAll,Comp==1)
# Get subject IDs
SubS <- as.data.frame(unique(dataSUBS$Crosssect))[[1]]
SubC <- as.data.frame(unique(dataCOMP$Crosssect))[[1]]

# Main functions ----

# mu0: initial payoffs 
# omega: recency parameter

RLLE <- function(choice, reward, mu0,omega) {
  nt <- length(choice)
  actions <- seq(0, 28)
  no <- length(actions)
  m <- matrix(mu0,ncol=no,nrow=nt+1)
  for(t in 1:nt) {
    kt <- rep(0,no)
    for(op in 1:no){
      m[t+1,op] <- ifelse(choice[t]==actions[op],
                        omega*(m[t,op]) + (1-omega)*(reward[t]),m[t,op])  
    }
  }
  return(list(m=m))
}
# softmax
SoftM <- function(m,gamma) {
  prob <- exp(gamma*m)
  prob <- prob/rowSums(prob) # normalize
  return(prob)
}

# LogLikelihood
# change the initial 23.58 for SUBS, 8.63 for COMP
LogL <- function(lambda,ome,data,initial) {
  choice <- data$choice
  reward <- data$reward
  m <- RLLE(choice,reward,initial,ome)$m
  p <- SoftM(m,lambda)
  PROB <- numeric(30)
  for(i in 1:30)
      PROB[i] <- p[i,choice[i]+1]
  LL <- sum(log(PROB))
  return(LL)
}

# Estimations -----

# Estimate both variables for all subjects 
lambada <- seq(0.1,9.9,length=99)
omaga <- seq(0.01,0.99,length=99)
out <- matrix(NA,ncol=length(lambada),nrow=length(omaga))

foo <- function(subjecto,initial){
  for(i in 1:length(lambada)) 
    for(j in 1:length(omaga))
      out[i,j] <- LogL(lambada[i],omaga[j],filter(dataAll,Crosssect==subjecto),initial)
    return(out)
}

# SUBS ----
ouutS <- vector("list", length(SubS))

for(i in 1:length(SubS)){
  ouutS[[i]] <- foo(SubS[i],23.578)
}
 
ouutSind <- matrix(NA,ncol=2,nrow=length(SubS))

for(i in 1:length(SubS)){
  ouutSind[i,] <- c(omaga[which(ouutS[[i]] == max(ouutS[[i]]), arr.ind = TRUE)[2]],
                         lambada[which(ouutS[[i]] == max(ouutS[[i]]), arr.ind = TRUE)[1]])
}

# COMP ----
ouutC <- vector("list", length(SubC))
for(i in 1:length(SubC)){
  ouutC[[i]] <- foo(SubC[i],8.631)
}

ouutCind <- matrix(NA,ncol=2,nrow=length(SubC))

for(i in 1:length(SubC)){
  ouutCind[i,] <- c(omaga[which(ouutC[[i]] == max(ouutC[[i]]), arr.ind = TRUE)[2]],
                    lambada[which(ouutC[[i]] == max(ouutC[[i]]), arr.ind = TRUE)[1]])
}

# Sum LogL
FinalSumSUBS <- Reduce('+', ouutS)
FinalSumCOMP <- Reduce('+', ouutC)

FinalAll <- FinalSumCOMP + FinalSumSUBS

# Get maximizes
omaga[which(FinalAll == max(FinalAll), arr.ind = TRUE)[2]]
lambada[which(FinalAll == max(FinalAll), arr.ind = TRUE)[1]]


