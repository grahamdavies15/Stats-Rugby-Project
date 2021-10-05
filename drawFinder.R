#Finding draws:
load("rc14.Rdata")
dat = rc14

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
