#rm(list = ls())

#Finding draws:
# load("rc14.Rdata")
# load("sixn1415.Rdata")
# load("euro1415.Rdata")
# load("hc1314.Rdata")
# load("sr15.Rdata")


#dat = rbind(rc14, sixn1415, euro1415, hc1314, sr15)
#save(dat, file = "allData.Rdata")
#             
# games = unique(dat$fx_id)
# drawFix = c()
# fixDat = NA
# 
# for (i in 1:length(games))
# {
#   fixDat = dat[which(dat$fx_id == games[i]), ]
#   lastMinute = fixDat[which(fixDat$time == max(fixDat$time)),]
# 
#   if(lastMinute$score_adv[1] == 0)
#   {
#     drawFix = c(drawFix, lastMinute$fx_id)
#   }
# }
# 
# 
# 
# drawFix = unique(drawFix)

#save(drawFix, file = "drawFix.RData")
# ## Use the win lose spreadsheet
# 
# library(readxl)
# path <- "winlose.xlsx"
# sheetnames <- excel_sheets(path)
# winlose <- lapply(excel_sheets(path), read_excel, path = path)
# winlose <- data.frame(winlose)
# winlose
# 
# for (i in 1:length(drawFix))
# {
#   winlose <- winlose[-which(winlose$fixID == drawFix[i]),]
# }
# 
# save(winlose, file = "winlose.Rdata")


rm(list = ls())
load("winlose.Rdata")
load("allData.Rdata")
load("drawFix.Rdata")

winnerDat = NA
loserDat = NA


for( i in 1:nrow(winlose))
{
  temp_fx_id = winlose[i,]$fixID
  tempDat    = dat[dat$fx_id == temp_fx_id,]
  
  winner = winlose[i,]$winner
  loser  = winlose[i,]$loser
  
  winnerDat = rbind(winnerDat, tempDat[tempDat$tm_id == winner,])
  loserDat = rbind(loserDat, tempDat[tempDat$tm_id == loser,])

}

winnerDat = winnerDat[-1,] #240930
loserDat = loserDat[-1,] #235941



drawDat = NA
for(i in 1:length(drawFix))
{
  drawDat = rbind(drawDat, dat[dat$fx_id == drawFix[i],])
}

drawDat = drawDat[-1,] #8631

nrow(drawDat) + nrow(winnerDat) + nrow(loserDat) #485502 - correct.

save(winnerDat, file = "winnerDat.Rdata")
save(loserDat, file = "loserDat.Rdata")
save(drawDat, file = "drawDat.Rdata")

