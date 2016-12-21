

mydata <- read.csv("FanDuel-NFL-2016-11-06-16792-players-list.csv",as.is=TRUE,header=TRUE)
mydata$value <- mydata$FPPG/mydata$Salary
mydata$value[is.infinite(mydata$value)] <- 0



#remove players with injuries by setting FPPG to 0

iflags<-c("O","IR","NA","Q")

mydata$FPPG[mydata$Injury.Indicator %in% iflags] <- 0


#Scale offense players points by Orank

mydata<-merge(mydata,orank,by.x="Team",by.y="shortName")

mydata$FPPG[mydata$Position !="D"] <-mydata$FPPG[mydata$Position !="D"] * mydata$adj[mydata$Position !="D"]


#Scale defense  points by drank


mydata$FPPG[mydata$Position =="D"] <-mydata$FPPG[mydata$Position =="D"] * mydata$adj[mydata$Position =="D"]

name <- paste0(mydata$First.Name," ",mydata$Last.Name)
pos <- mydata$Position
pts <- mydata$FPPG
cost <- mydata$Salary
team <- mydata$Team

num.players <- length(name)

f <- mydata$value

f <- pts

var.types <- rep("B", num.players)

A <- rbind(as.numeric(pos=="QB")
           , as.numeric(pos=="RB")
           , as.numeric(pos=="WR")
           , as.numeric(pos=="TE")
           , as.numeric(pos=="K")
           , as.numeric(pos== "D")
           ,cost)

dir <- c("=="
         ,"=="
         ,"=="
         ,"=="
         ,"=="
         ,"=="
         ,"<=")

b <- c(  1
       , 2
       , 3
       , 1
       , 1
       , 1
       , 60000)

library(Rglpk)

sol <- Rglpk_solve_LP(obj = f
                      , mat = A
                      , dir = dir
                      , rhs = b
                      , types = var.types
                      , max=TRUE)
sol

paste0( name[sol$solution == 1], "  " ,pos[sol$solution == 1], " ",team[sol$solution == 1])
