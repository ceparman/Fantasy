source("getFFPTHistory.R")


  
content <-  data.frame(player = "1",  Last.Name ="1", First.Name = "1", team = "1" , FPTS=1,as.is=TRUE)
content<-content[-1,]



for(w in 1:16)
{
   print(paste("week",w))

   for (p in c("QB",'RB',"WR","TE","K","D")) 
   {
     c<-getFFPThistory("2016",as.character(w),p,scoring="Fanduel")
     
     content <- rbind(content,  c )
     
     
    }
   
   
   
}

library(dplyr)

filtered<-filter(content,FPTS != 0)

risk<-filtered %>% group_by(player) %>% summarise_each(funs(mean,sd),FPTS)

names<-unique(content[,c("player","Last.Name","First.Name")])

mrisk<-merge(risk,names,by.x="player",by.y="player",all.y = FALSE, all.x = TRUE)

mrisk$player <- as.character(mrisk$player)

