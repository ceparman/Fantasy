
offense<-getOffenseRanks()
defense<-getDefenseRanks()
schedule<-getSchedule()
#create weight for offense


homeorank<-rep(1,nrow(schedule))
awayorank<-rep(1,nrow(schedule))


homedrank<-rep(1,nrow(schedule))
awaydrank<-rep(1,nrow(schedule))



for(i in 1:nrow(schedule))
{


homeorank[i] <-

1+((32 -offense[which(offense$team == schedule[i,]$home ),]$rank ) -
(32- defense[which(defense$team == schedule[i,]$away ),]$rank) )/128



homedrank[i] <-
  
  1+((32 -defense[which(defense$team == schedule[i,]$home ),]$rank ) -
     (32- offense[which(offense$team == schedule[i,]$away ),]$rank) )/128






awayorank[i] <-
  
1+((32 -offense[which(offense$team == schedule[i,]$away ),]$rank ) -
     (32- defense[which(defense$team == schedule[i,]$home ),]$rank) )/128



awaydrank[i] <-
  
  1+((32 -defense[which(defense$team == schedule[i,]$away),]$rank ) -
     (32- offense[which(offense$team == schedule[i,]$home ),]$rank) )/128




}

schedule$homeorank <-homeorank
schedule$awayorank <-awayorank



schedule$homedrank <-homedrank
schedule$awaydrank <-awaydrank


orank <- rbind(data.frame(team=schedule$home,adj=schedule$homeorank),
               data.frame(team=schedule$away,adj=schedule$awayorank)
               )


orank<-merge(orank,teams, by.x = "team", by.y = "longName" )

orank<-orank[order(orank$adj),]




drank <- rbind(data.frame(team=schedule$home,adj=schedule$homedrank),
               data.frame(team=schedule$away,adj=schedule$awaydrank)
)


drank<-merge(drank,teams, by.x = "team", by.y = "longName" )

drank<-drank[order(drank$adj),]



