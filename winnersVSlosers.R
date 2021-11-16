# working out average tries 
load("winnerDat.Rdata")
load("loserDat.Rdata")

winKick <- winnerDat[which(winnerDat$act == 11), c(8, 9)]
winKick <- winKick[-which(winKick$act_type == 296),]
table(winKick)

#Con 594/823 = 0.7217497
#Pen 685/861 = 0.7955865

#Success Con of goal kicks 0.4067696
loseKick <- loserDat[which(loserDat$act == 11), c(8, 9)]
loseKick <- loseKick[-which(loseKick$act_type == 296),]
table(loseKick)
#Con 258/357 = 0.7226891
#Pen 685/861 = 0.7213115

#Success Con of goal kicks 0.4708171
load("gen_mod.win.128b.Rdata")
load("gen_mod.lose.128b.Rdata")

win_v_lose = matrix(NA,ncol=6,nrow=10000)
winTry <- 0
loseTry <- 0

winPen <- 0
losePen <- 0

set.seed(1998)
for (i in 1:10000){
  
  # sample from distributions
  winner<- sample(gen_mod.win.128b, 43)
  loser <- sample(gen_mod.lose.128b, 43)

  #format for analysis
  split_win <- strsplit(winner," ")
  split_lose <- strsplit(loser," ")
  
  team_win <- as.numeric(unlist(split_win))
  team_lose <- as.numeric(unlist(split_lose))
  
  
  # reset score, tries and kicks to 0
  teamWin_score <- 0
  teamLose_score <- 0
  
  teamWin_Try <- 0
  teamLose_Try <- 0
  
  teamWin_Kick <- 0
  teamLose_Kick <- 0
  
  # winners point allocation
  for (j in 1:length(team_win)){
    
    if (team_win[j]==9) #try
    {
      teamWin_score  <- teamWin_score + 5 + 2*rbinom(n=1, size=1, prob=0.7217497) # conversion percentage
      teamWin_Try <- teamWin_Try + 1
    }
    else if (team_win[j]==11) # goal kick
    {
      teamWin_score <- teamWin_score + 3*rbinom(n=1, size=1, prob=0.4067696) #only goal kicks from sequences
      teamWin_Kick <- teamWin_Kick + 1
    }
    
  }
  
  # losers point allocation
  for (k in 1:length(team_lose)){
    
    if (team_lose[k]==9) #try
    {
      teamLose_score  <- teamLose_score + 5 + 2*rbinom(n=1, size=1, prob=0.7226891) # conversion percentage
      teamLose_Try <- teamLose_Try + 1
    }
    else if (team_lose[k]==11) #goal kick
    {
      teamLose_score <- teamLose_score + 3*rbinom(n=1, size=1, prob=0.4708171) #only goal kicks from sequences
      teamLose_Kick <- teamLose_Kick + 1
    }
    
  }
  
  # assign score, tries and kicks to column
  win_v_lose[i,1]<-teamWin_score
  win_v_lose[i,2]<-teamLose_score
  win_v_lose[i,3]<-teamWin_Try
  win_v_lose[i,4]<-teamLose_Try
  win_v_lose[i,5]<-teamWin_Kick
  win_v_lose[i,6]<-teamLose_Kick
  
}

# work out win/loss/draw from the winners persepctive
win_v_lose <- as.data.frame(win_v_lose)
for(i in 1:nrow(win_v_lose))
{
  if (win_v_lose$V1[i] > win_v_lose$V2[i])
  {
    win_v_lose$res[i] = "win"
  }
  else if (win_v_lose$V1[i] < win_v_lose$V2[i])
  {
    win_v_lose$res[i] = "lose"
  }
  else
  {
    win_v_lose$res[i] = "draw"
  }
}

#get medians
median(win_v_lose$V1)
median(win_v_lose$V2)

median(win_v_lose$V3)
median(win_v_lose$V4)

median(win_v_lose$V5)
median(win_v_lose$V6)

#get number of wins/losses/draws
sum(win_v_lose$res == "win")
sum(win_v_lose$res == "lose")
sum(win_v_lose$res == "draw")

# average score
mean(win_v_lose$V1)
mean(win_v_lose$V2)

#average tries
winTry/10000
loseTry/10000

#average goalkicks
winPen/10000
losePen/10000
