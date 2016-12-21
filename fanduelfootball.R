


players <- read.csv("FanDuel-NFL-2016-11-06-16789-players-list.csv",as.is=TRUE,header=TRUE)


players$value <- players$FPPG/players$Salary


players$QB <- as.integer(players$Position == "QB")

players$RB <- as.integer(players$Position == "RB")


players$WR <- as.integer(players$Position == "WR")


players$TE <- as.integer(players$Position == "TE")

players$K <- as.integer(players$Position == "K")

players$TD <- as.integer(players$Position == "D")