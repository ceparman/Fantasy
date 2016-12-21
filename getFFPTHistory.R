
getSchedule<-function()
{
  

theurl <-"http://thehuddle.com/stats/2016/plays_weekly.php?pos=DF&week=10&ccs=96672"

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

content <-  data.frame(player = "1",   team = "1" , FPTS=1)
content<-content[-1,]


#loop through sections


  #loop through each section
   for(i in 1:length(thetable$children[[2]]$children))
  {
   
    
    tablerow <- thetable$children[[2]]$children[[i]] 
   
    
  
     
    
   player <- as.character(xmlValue(tablerow$children[[1]]))
    
    team  <- as.character(xmlValue(tablerow$children[[2]]))
    
    FPTS <-as.numeric(xmlValue(tablerow$children[[3]]))
    
    content <- rbind(content, 
                     data.frame(player = player, team = team, FPTS=FPTS ) )
    
    
    
    
  }
  
  

  
 


content$home <- as.character(content$home)
content$away <- as.character(content$away)
content$time <- as.character(content$time)
content$day <- as.character(content$day)

content
}