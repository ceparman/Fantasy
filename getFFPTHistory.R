
getFFPThistory<-function(year,week,position,scoring="Fanduel")
{
  
source("teams.R")  

#there are small difference between FD scoring and thsi site  
#need to modify position to convert from Fanduel to thhuddle format  
  
if( position == "K") position <- "PK"
    
if( position == "D") position <- "DF"
  
if (scoring == "Fanduel") ccs<-96672 else stop("I don't know that scoring system")

theurl <- paste0("http://thehuddle.com/stats/",year,"/","plays_weekly.php?pos=",position,"&week=",week,"&ccs=",ccs)


print(theurl)

FPTScol <- 4 

if( position == "DF")  FPTScol <- 3


#theurl <-"http://thehuddle.com/stats/2016/plays_weekly.php?pos=DF&week=10&ccs=96672"

# Download page using RCurl
# You may need to set proxy details, etc.,  in the call to getURL

webpage <- getURL(theurl)
# Process escape characters
webpage <- readLines(tc <- textConnection(webpage)); close(tc)

# Parse the html tree, ignoring errors on the page
pagetree <- htmlTreeParse(webpage, error=function(...){})

# Navigate your way through the tree. It may be possible to do this more efficiently using getNodeSet
body <- pagetree$children$html$children$body 

thetable  <-body$children[[10]]$children$div[[2]]$children$div[[5]]$children$div[[1]]

content <-  data.frame(player = "1",  Last.Name ="1", First.Name = "1", team = "1" , FPTS=1,as.is=TRUE)
content<-content[-1,]


#loop through sections
 

  #loop through each table row section 
  

 for(i in 1:length(thetable$children[[2]]$children))
  {
   
   #print(i)
    
   tablerow <- thetable$children[[2]]$children[i]
   
    
  #  xmlValue(thetable$children[2]$tbody$children[1]$tr$children[2]$td)
  
   if( position != "DF")
   {
     player <- as.character(xmlValue(tablerow$tr$children[1]$td))
    
     First.Name <- strsplit(player, " ")[[1]][[1]]
     Last.Name <-  strsplit(player, " ")[[1]][[2]]
    }
   
   else {
      
      First.Name <- as.character(xmlValue(tablerow$tr$children[1]$td))
     
      sn <-xmlValue(tablerow$tr$children[2]$td)
    
      if(sn == "ARI") sn <- 'AZ'
      
      Last.Name <- as.character( teams$team[which(teams$shortName == sn)])
      
      player <- paste0(First.Name," ",Last.Name)
      
    }
      
    #print(sn)
    team  <- as.character(xmlValue(tablerow$tr$children[2]$td))
    
    FPTS <-as.numeric(xmlValue(tablerow$tr$children[FPTScol]$td))
    # print(player)
    # print(Last.Name)
    # print(First.Name)
    content <- rbind(content, 
                     data.frame(player = player, Last.Name = Last.Name, First.Name = First.Name, team = team, FPTS=FPTS ) )
    
    
    
    
  }
  
  

content
}

getFFPThistory("2016","1","D")
