
library(RCurl)
source("parseteamrankings.R")
source("teams.R")
library(XML)

##############  Schedule  ######################3
library(gdata)
source("parseSchedule.R")
schedule<-getSchedule()





############### Rush ####################

teamrushrank<-getTeamRanks("https://www.teamrankings.com/nfl/stat/opponent-rushing-yards-per-game")

teampassrank<-getTeamRanks("https://www.teamrankings.com/nfl/stat/opponent-passing-yards-per-game")


homerushrank<-rep(1,nrow(schedule))
homepassrank<-rep(1,nrow(schedule))
awayrushrank<-rep(1,nrow(schedule))
awaypassrank<-rep(1,nrow(schedule))


for(i in 1:nrow(schedule))
{
  
  
  homerushrank[i] <-
    
    1+(teamrushrank[which(teamrushrank$team == schedule[i,]$home ),]$rank-16)/128
  
  homepassrank[i] <-
    
    1+(teampassrank[which(teampassrank$team == schedule[i,]$home ),]$rank-16)/128
  
  
  awayrushrank[i] <-
    
    1+(teamrushrank[which(teamrushrank$team == schedule[i,]$away ),]$rank-16)/128
  
  awaypassrank[i] <-
    
    1+(teampassrank[which(teampassrank$team == schedule[i,]$away ),]$rank-16)/128
  
  
  
  
  
}




schedule$awayrushrank <-homerushrank
schedule$homerushrank <-awayrushrank


schedule$awaypassrank <-homepassrank
schedule$homepassrank <-awaypassrank







rushrank <- rbind(data.frame(team=schedule$home,radj=schedule$homerushrank),
               data.frame(team=schedule$away,radj=schedule$awayrushrank)
)


rushrank<-merge(rushrank,teams, by.x = "team", by.y = "longName" )

rushrank<-rushrank[order(rushrank$radj),]




passrank <- rbind(data.frame(team=schedule$home,padj=schedule$homepassrank),
               data.frame(team=schedule$away,padj=schedule$awaypassrank)
)


passrank<-merge(passrank,teams, by.x = "team", by.y = "longName" )

passrank<-passrank[order(passrank$padj),]







############## Defense ########################################

teamdefrank<-getTeamRanks("https://www.teamrankings.com/nfl/stat/opponent-points-per-game")

teamdefrank$defrank <- (teamdefrank$rank)

teamdefrank[,c(1,3,4,5)] <- NULL


teamdepoints <- getTeamRanks("https://www.teamrankings.com/nfl/stat/defensive-points-per-game")

teamdepoints$depoints <-teamdepoints$rank

teamdepoints[,c(1,3,4,5)] <- NULL


teamDEsacks<- getTeamRanks("https://www.teamrankings.com/nfl/stat/sacks-per-game")

teamDEsacks$DEsacks <-teamDEsacks$rank

teamDEsacks[,c(1,3,4,5)] <- NULL


teamDEint<- getTeamRanks("https://www.teamrankings.com/nfl/stat/interceptions-per-game")

teamDEint$DEint<-teamDEint$rank

teamDEint[,c(1,3,4,5)] <- NULL


teamDEfumr<- getTeamRanks("https://www.teamrankings.com/nfl/stat/opponent-fumbles-lost-per-game")

teamDEfumr$DEfumr<-teamDEfumr$rank

teamDEfumr[,c(1,3,4,5)] <- NULL




mergeddef <-cbind(teamdefrank,teamDEfumr$DEfumr,teamDEint$DEint,teamdepoints$depoints,
                  teamDEsacks$DEsacks)


mergeddef$rank <- (3*mergeddef$defrank + 2*teamDEfumr$DEfumr +2*teamDEint$DEint 
                   + teamdepoints$depoints +  teamDEsacks$DEsack)/9

awaydefrank <-rep(1,nrow(schedule))
homedefrank <-rep(1,nrow(schedule))


for(i in 1:nrow(schedule))
{
  awaydefrank[i] <- 
    1+(16-mergeddef[which(mergeddef$team == schedule[i,]$away ),]$rank)/128
  
  
  
  homedefrank[i] <- 
    1+(16-mergeddef[which(mergeddef$team == schedule[i,]$home ),]$rank)/128
  
  
  
}



schedule$awaydefrank <-awaydefrank
schedule$homedefrank <-homedefrank



defrank <- rbind(data.frame(team=schedule$home,dadj=schedule$homedefrank),
                  data.frame(team=schedule$away,dadj=schedule$awaydefrank)
                 )


defrank<-merge(defrank,teams, by.x = "team", by.y = "longName" )

defrank<-defrank[order(defrank$dadj),]












