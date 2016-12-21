
getSchedule<-function()
{
  

theurl <-"https://www.teamrankings.com/nfl/schedules/season/"

# Download page using RCurl
# You may need to set proxy details, etc.,  in the call to getURL

webpage <- getURL(theurl)
# Process escape characters
webpage <- readLines(tc <- textConnection(webpage)); close(tc)

# Parse the html tree, ignoring errors on the page
pagetree <- htmlTreeParse(webpage, error=function(...){})

# Navigate your way through the tree. It may be possible to do this more efficiently using getNodeSet
body <- pagetree$children$html$children$body 

thetable  <- body$children[[6]]$children$div[[5]]$children$main$children[[3]]

content <-  data.frame(home = "1",   away = "1" , day="1",time ="1")
content<-content[-1,]


#loop through sections


for(i in 1:length(thetable$children))
{
  #loop through each section
   for(j in 1:length(thetable$children[[i]]$children))
  {
   
    #determine if we have a heater or game
    tablerow <- thetable$children[[i]]$children[[j]] 
   
    
    if (length(grep("@",xmlValue(tablerow$children[[1]]))) >0) {
     
      
    away <- trim(strsplit(xmlValue(tablerow$children[[1]]),"@")[[1]][1])
    
    home  <- trim(strsplit(xmlValue(tablerow$children[[1]]),"@")[[1]][2])
    
    time <-strsplit(xmlValue(tablerow$children[[2]])," ")[[1]][1]
    
    content <- rbind(content, 
                     data.frame(home = home, away = away,day=day , time = time) )
    
    } else
    {
      day <- strsplit(xmlValue(tablerow$children[[1]])," ")[[1]][1]
    }
    
    
    
  }
  
  

  
 
}

content$home <- as.character(content$home)
content$away <- as.character(content$away)
content$time <- as.character(content$time)
content$day <- as.character(content$day)

content
}