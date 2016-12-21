
library(XML)
library(RCurl)

theurl <-"https://www.teamrankings.com/nfl/stat/opponent-points-per-game"

# Download page using RCurl
# You may need to set proxy details, etc.,  in the call to getURL

webpage <- getURL(theurl)
# Process escape characters
webpage <- readLines(tc <- textConnection(webpage)); close(tc)

# Parse the html tree, ignoring errors on the page
pagetree <- htmlTreeParse(webpage, error=function(...){})

# Navigate your way through the tree. It may be possible to do this more efficiently using getNodeSet
body <- pagetree$children$html$children$body 

body$children[[6]]$children$div[[5]]

names(body$children[[6]]$children$div[[5]]$children[[2]]=="table")

divbodyContent <- body$children[[6]]$children$div[[5]]$children[[2]]
tables <- body$children[[6]]$children$div[[5]]$children$main$children[[5]]

#In this case, the required table is the only one with class "wikitable sortable"  
tableclasses <- sapply(tables, function(x) x$attributes["class"])
thetable  <- body$children[[6]]$children$div[[5]]$children$main$children[[5]]

#Get columns headers
headers <- thetable$children[[1]]$children$tr
columnnames <- unname(sapply(headers, function(x) x$children$text$value))

# Get rows from table
content <-  data.frame(rank = 1,  team = "a", points = 1, home = 1, away = 1 )
content<-content[-1,]
for(i in 1:length(thetable$children[[2]]$children))
{
  
  tablerow <- thetable$children[[2]]$children[[i]]
  
  rank <- as.integer(xmlValue(tablerow$children[[1]]$children$text))
  
  team <-as.character(xmlValue(tablerow$children[[2]]$children$a))
  
  points <- as.numeric(xmlValue(tablerow$children[[3]]$children$text))
  
  home <-  as.numeric(xmlValue(tablerow$children[[6]]$children$text))
  
  away <- as.numeric(xmlValue(tablerow$children[[7]]$children$text))
  
  ###############
 
  content <- rbind(content, 
                   data.frame(rank = rank, team =team , points = points,
                        home = home, away = away) )
}

# Convert to data frame
colnames(content) <- columnnames
as.data.frame(content)