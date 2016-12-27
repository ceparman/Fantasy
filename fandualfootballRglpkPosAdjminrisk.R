

source("possitiondifferntials.R")
source("buildplayerrisk.R")


mydata <- read.csv("FanDuel-NFL-2016-12-24-17371-players-list.csv",as.is=TRUE,header=TRUE)
mydata$player <- paste0(mydata$First.Name," ",mydata$Last.Name)

mydata$value <- mydata$FPPG/mydata$Salary
mydata$value[is.infinite(mydata$value)] <- 0

mydata<-inner_join(mrisk,mydata,by="player")



#remove players with injuries by setting FPPG to 0

iflags<-c("O","IR","NA","Q")

mydata$FPPG[mydata$Injury.Indicator %in% iflags] <- 0

mydata$FPPG[is.na(mydata$Injury.Indicator)] <- 0


#set sd of na to 20% of points


mydata$sd[which(is.na(mydata$sd))]<-  mydata$FPPG[which(is.na(mydata$sd))]*.2


#scale rb by rushranks

mydata<-merge(mydata,rushrank,by.x="Team",by.y="shortName")

mydata$FPPG[mydata$Position =="RB"] <-mydata$FPPG[mydata$Position =="RB"] * mydata$radj[mydata$Position =="RB"] 



#scale rb by rushranks

mydata<-merge(mydata,passrank,by.x="Team",by.y="shortName")

mydata$FPPG[mydata$Position %in% c("WR","TE","QB")] <-
            mydata$FPPG[mydata$Position  %in% c("WR","TE","QB")] * mydata$radj[mydata$Position  %in% c("WR","TE","QB")] 



#Scale defense  points by drank

mydata<-merge(mydata,defrank,by.x="Team",by.y="shortName")

mydata$FPPG[mydata$Position =="D"] <-mydata$FPPG[mydata$Position =="D"] * mydata$dadj[mydata$Position =="D"]



#set sd to min of FFPG

mydata$sd[which((mydata$FPPG - mydata$sd) < 0)] <- mydata$FPPG[which((mydata$FPPG - mydata$sd) < 0)]





name <- paste0(mydata$First.Name.x," ",mydata$Last.Name.x)
pos <- mydata$Position
pts <- mydata$FPPG
cost <- mydata$Salary
team <- mydata$Team
numteams <- length(unique(team))
teamList <- unique(team)
num.players <- length(name)



teammatrix<-as.numeric(team == teamList[1])

for(i in 2:numteams)
{
  
  teammatrix <- rbind(teammatrix,
                      as.numeric(team == teamList[i]))
}



f <- pts

r<- mydata$sd 

#r <- (1+runif(length(name)))*f*.2

var.types <- rep("B", num.players)
 

A <- rbind(as.numeric(pos=="QB")
           , as.numeric(pos=="RB")
           , as.numeric(pos=="WR")
           , as.numeric(pos=="TE")
           , as.numeric(pos=="K")
           , as.numeric(pos== "D")
           ,teammatrix
           ,cost
           ,pts)

dir <- c("=="
         ,"=="
         ,"=="
         ,"=="
         ,"=="
         ,"=="
         ,rep("<=",numteams)
         ,"<="
         ,">=")

b <- c(  1
       , 2
       , 3
       , 1
       , 1
       , 1
       ,rep(4,numteams)
       ,60000
       ,120)

library(Rglpk)

sol <- Rglpk_solve_LP(obj = r
                      , mat = A
                      , dir = dir
                      , rhs = b
                      , types = var.types
                      , max=FALSE)
sol

paste0( name[sol$solution == 1], "  " ,pos[sol$solution == 1]," ",
        team[sol$solution == 1], " ", pts[sol$solution == 1])
