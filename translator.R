dictionary <- list('Padding',
                   'Carry',
                   'Tackle',
                   'Pass',
                   'Kick',
                   'Scrum',
                   'Lineout Throw',
                   'Penalty Conceded',
                   'Turnover',
                   'Try',
                   'Attacking Qualities',
                   'Goal Kick',
                   'Missed Tackle',
                   'Turnover Won',
                   'Restart',
                   'Possession',
                   'Other',
                   'Period',
                   'Collection',
                   'Team Play',
                   'Ref Review',
                   'Card',
                   'Clock',
                   'Ruck',
                   'Maul',
                   'Sequence',
                   'Lineout Take',
                   'Offensive Scrum',
                   'Defensive Scrum')

translate <- "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 26 6 27 18 18 3 3 1 3 2 1 10 2 2 3 10 1 2 23 3 10 2 12 1 10 2 23 3 3 1 20 23 3 3 3 2 1 10 3 3 3 1 2 23 3 3 1 2 3 18 1 8 2 2 18 2 2 1 10 1 8 23 7 8 18 1 2 2 23 3 3 1 2 2 23 3 3 3 10 4 18 4 18 23 8 18 1 2 2 23 3 1 2 2 2 23 3 1 2 2 23 3 1 2 2 23 3 4 18 8 18 18 1 3 1 3 1 8 2 23 2 12 2 2 10 1 23 3 7 3 4 18 18 1 4 18 8 18 1 2 23 3 1 4 3 1 10 2 2 1 2 23 1 14 18 7 6 27 18 7 3 3 3 3 18 1 2 2 23 3 1 10 3 2 2 10 1 10 8 2 2 8 3 10 10 2 12 10 1 3 3 3 2 12 2 10 1 23 3 8 2 1 0 0 0 0 0 0 0 0 26 17 17 5 28 28 29 29 24 1 4 18 18 1 2 12 2 23 7 1 2 23 3 1 2 2 23 1 4 18 18 23 3 3 3 3 8 18 18 1 14 2 1 2 2 23 3 1 2 23 2 2 1 10 3 2 8 2 1 3 3 2 18 1 3 1 3 2 1 3 2 12 3 10 2 12 3 3 2 1 23 3 3 4 4 18 18 18 18 1 3 3 10 2 12 3 10 1 10 8 2 23 3 3 3 3 3 3 3 3 1 2 2 23 3 1 2 2 23 3 3 1 2 23"
translate <- as.numeric(strsplit(translate, split = " ")[[1]])


for (i in 1:length(translate))
{
  print(dictionary[translate[i]])
}
