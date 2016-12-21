

source("possitiondifferntials.R")

mydata <- read.csv("FanDuel-NFL-2016-12-18-17288-players-list.csv",as.is=TRUE,header=TRUE)
mydata$value <- mydata$FPPG/mydata$Salary
mydata$value[is.infinite(mydata$value)] <- 0





#remove players with injuries by setting FPPG to 0

iflags<-c("O","IR","NA","Q")

mydata$FPPG[mydata$Injury.Indicator %in% iflags] <- 0

mydata$FPPG[is.na(mydata$Injury.Indicator)] <- 0


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







name <- paste0(mydata$First.Name," ",mydata$Last.Name)
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


f <- mydata$value

f <- pts

var.types <- rep("B", num.players)
 

A <- rbind(as.numeric(pos=="QB")
           , as.numeric(pos=="RB")
           , as.numeric(pos=="WR")
           , as.numeric(pos=="TE")
           , as.numeric(pos=="K")
           , as.numeric(pos== "D")
           ,teammatrix
           ,cost)

dir <- c("=="
         ,"=="
         ,"=="
         ,"=="
         ,"=="
         ,"=="
         ,"<="
         ,rep("<=",numteams))

b <- c(  1
       , 2
       , 3
       , 1
       , 1
       , 1
       ,rep(4,numteams)
       ,60000)

library(Rglpk)

sol <- Rglpk_solve_LP(obj = f
                      , mat = A
                      , dir = dir
                      , rhs = b
                      , types = var.types
                      , max=TRUE)
sol

paste0( name[sol$solution == 1], "  " ,pos[sol$solution == 1]," ",
        team[sol$solution == 1], " ", pts[sol$solution == 1])
