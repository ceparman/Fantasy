#load all playerdata



playerfiles<- list.files("pastplayers",pattern="*.csv",full.names = TRUE)

#read all files

database<-read.csv(file=playerfiles[1],as.is=TRUE,blank.lines.skip = TRUE)


print(nrow(database))
for( i in 2:length(playerfiles))
{
  print(playerfiles[i])
  d<-read.csv(file=playerfiles[i],as.is=TRUE,blank.lines.skip = TRUE)
 
  
  d<-as.data.frame(sapply(d, function(x) gsub("[^0-9A-Za-z[:punct:]///' ]", "", x)),stringsAsFactors = FALSE)
  
  
  
  
  
  d<-d[!duplicated(d),]
  database<-rbind(database,d)
  print(nrow(database))
  
  
}
source("teams.R")
database$away<-unlist(lapply(strsplit(database$Game,"@"),function(x) x[1]))
database$home<-unlist(lapply(strsplit(database$Game,"@"),function(x) x[2]))

source("get2016Schedule.R")

longdb<-merge(database,teams, by.x = "home", by.y = "shortName" )
longdb$home<-longdb$longName
longdb$longName<- NULL
longdb<-merge(longdb,teams, by.x = "away", by.y = "shortName" )
longdb$away<-longdb$longName


merged<-merge(longdb,schedule,by.x=c("home","away"),by.y=c("home","away"))

merged$Id <-NULL



merged<-merged[!duplicated(merged),]

