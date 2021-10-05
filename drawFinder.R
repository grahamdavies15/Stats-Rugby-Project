#Finding draws:
load("rc14.Rdata")
load("sixn1415.Rdata")
load("euro1415.Rdata")
load("hc1314.Rdata")
load("sr15.Rdata")


dat = rbind(rc14, sixn1415, euro1415, hc1314, sr15)
            
games = unique(dat$fx_id)
drawFix = c()
fixDat = NA

for (i in 1:length(games))
{
  fixDat = dat[which(dat$fx_id == games[i]), ]
  lastMinute = fixDat[which(fixDat$time == max(fixDat$time)),]
  
  if(lastMinute$score_adv[1] == 0)
  {
    drawFix = c(drawFix, lastMinute$fx_id)
  }
}

drawFix = unique(drawFix)

## Use the win lose spreadsheet

library(readxl)
path <- "winlose.xlsx"
sheetnames <- excel_sheets(path)
winlose <- lapply(excel_sheets(path), read_excel, path = path)
winlose <- data.frame(winlose)
for (i in 1:length(drawFix))
{
  winlose <- winlose[-which(winlose$fixID == drawFix[i]),]
}




