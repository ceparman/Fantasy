

longName <- c(
   "Minnesota",     "Seattle",       "New England",   "Philadelphia",
  "Denver",        "Arizona",       "Dallas",        "Kansas City",  
  "Baltimore",     "NY Giants",     "Houston",       "Pittsburgh",   
  "Buffalo",       "Los Angeles",   "Green Bay",     "Chicago",      
  "Miami",         "Tennessee",     "Washington",    "Cincinnati",   
  "Detroit",       "Oakland",       "NY Jets",       "San Diego",    
  "Jacksonville",  "Carolina",      "Indianapolis",  "Atlanta",      
  "Tampa Bay",     "Cleveland",     "New Orleans",   "San Francisco"
)
shortName <- c(
  "MIN",     "SEA",       "NE",   "PHI",
  "DEN",        "AZ",       "DAL",        "KC",  
  "BAL",     "NYG",     "HOU",       "PIT",   
  "BUF",       "LA",   "GB",     "CHI",      
  "MIA",         "TEN",     "WAS",    "CIN",   
  "DET",       "OAK",       "NYJ",       "SD",    
  "JAC",  "CAR",      "IND",  "ATL",      
  "TB",     "CLE",     "NO",   "SF"
  
)

team <- c(
          "Vikings", " Seahawks", "Partiots", "Eagles",
          "Broncos", "Cardinals", "Cowboys" , "Chiefs",
          "Ravens", "Giants", "Texans", "Steelers",
          "Bills", "Rams", "Packers", "Bears",
          "Dolphins", "Titians", "Redskins", "Bengals",
          "Lions", "Raiders", "Jets", "Chargers",
          "Jaguars", "Panthers", "Colts", "Falcons",
           "Buccaneers", "Browns", "Saints", "49ers" 
  
)
  

teams<-data.frame(shortName = shortName, longName = longName,team = team , as.is=TRUE)
