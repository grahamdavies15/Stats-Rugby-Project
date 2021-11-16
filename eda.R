#analysis of original data dataset after removing sequences of length 1 and outliers

library(tensorflow)
library(readxl)
library(keras)
library(stringr)
library(DescTools)
library(purrr)
library(dplyr)
library(tidyr)
library(ggplot2)

#load data
load("all_actions.Rda") #called all_acts
actions <- all_acts

#split into sequences
actions <- SplitAt(actions,which(actions=="15")+1) 

#check for sequence of length 1, and if true remove them
sum(lengths(actions)==1) #there are sequences of length 1
actions<-actions[-which(lengths(actions)==1)] #remove sequences of length 1

#remove outliers
actions<-actions[-which(lengths(actions) %in% boxplot(lengths(actions))$out)]


#summary statistics of sequence lengths

length_summary_original <- summary(lengths(actions))
length_summary_original


#covert list back into numerical vector
all_acts <- unlist(actions)

#get action after each action
a1 <- all_acts[which(all_acts==1)+1]
a2 <- all_acts[which(all_acts==2)+1]
a3 <- all_acts[which(all_acts==3)+1]
a4 <- all_acts[which(all_acts==4)+1]
a5 <- all_acts[which(all_acts==5)+1]
a6 <- all_acts[which(all_acts==6)+1]
a7 <- all_acts[which(all_acts==7)+1]
a8 <- all_acts[which(all_acts==8)+1]
a9 <- all_acts[which(all_acts==9)+1]
a10 <- all_acts[which(all_acts==10)+1]
a11 <- all_acts[which(all_acts==11)+1]
a12 <- all_acts[which(all_acts==12)+1]
#a13 <- all_acts[which(all_acts==13)+1]
a14 <- all_acts[which(all_acts==14)+1]
a15 <- all_acts[which(all_acts==15)+1]
a17 <- all_acts[which(all_acts==17)+1]
a18 <- all_acts[which(all_acts==18)+1]
a20 <- all_acts[which(all_acts==20)+1]
a21 <- all_acts[which(all_acts==21)+1]
a23 <- all_acts[which(all_acts==23)+1]
a24 <- all_acts[which(all_acts==24)+1]
a26 <- all_acts[which(all_acts==26)+1]
a27 <- all_acts[which(all_acts==27)+1]
a28 <- all_acts[which(all_acts==28)+1]
a29 <- all_acts[which(all_acts==29)+1]



#get distribution of all actions in original data set
prop <- as.data.frame(all_acts)
prop <- as.data.frame(table(all_acts)/sum(table(all_acts)))
table(all_acts)

# orig_plot <- cbind(prop, "Original Data Set")
# colnames(orig_plot) <- c("act", "Freq","Key")

#plot distribution
orig_dist <- ggplot(prop,aes(x=all_acts,y=Freq))+geom_bar(stat="identity",fill = "#228B22")+xlab("Actions")+ylab("Proportions")+ylim(c(0,0.18))
orig_dist


### Actions after actions

#Action 1: Carry

after_carry <- as.data.frame(table(a1)/sum(table(a1)))

ggplot(after_carry, aes(x = a1, y = Freq)) + geom_bar(stat = "identity") + labs(x ="Actions", y = "Proportion")

#Action 2: Tackle

after_tackle <- as.data.frame(table(a2)/sum(table(a2)))

ggplot(after_tackle, aes(x = a2, y = Freq)) + geom_bar(stat = "identity") + labs(x ="Actions", y = "Proportion")

#Action 3: Pass

after_pass<- as.data.frame(table(a3)/sum(table(a3)))

ggplot(after_pass, aes(x = a3, y = Freq)) + geom_bar(stat = "identity") + labs(x ="Actions", y = "Proportion")


#Action 4: Kick

after_kick <- as.data.frame(table(a4)/sum(table(a4)))

ggplot(after_kick, aes(x = a4, y = Freq)) + geom_bar(stat = "identity") + labs(x ="Actions", y = "Proportion")


#Action 5: Scrum

after_scrum <- as.data.frame(table(a5)/sum(table(a5)))

ggplot(after_scrum, aes(x = a5, y = Freq)) + geom_bar(stat = "identity") + labs(x ="Actions", y = "Proportion")

#Action 6: Lineout throw

after_lineout_throw<- as.data.frame(table(a6)/sum(table(a6)))

ggplot(after_lineout_throw, aes(x = a6, y = Freq)) + geom_bar(stat = "identity") + labs(x ="Actions", y = "Proportion")

#Action 7: Penalty

after_penalty<- as.data.frame(table(a7)/sum(table(a7)))

after_penalty<-ggplot(after_penalty, aes(x = a7, y = Freq)) + geom_bar(stat = "identity",fill = "#228B22") + labs(x ="Actions", y = "Proportion")
after_penalty
#Action 8: Turnover

after_turnover <- as.data.frame(table(a8)/sum(table(a8)))

ggplot(after_turnover, aes(x = a8, y = Freq)) + geom_bar(stat = "identity") + labs(x ="Actions", y = "Proportion")

#Action 9: Try

after_try <- as.data.frame(table(a9)/sum(table(a9)))

ggplot(after_try, aes(x = a9, y = Freq)) + geom_bar(stat = "identity") + labs(x ="Actions", y = "Proportion")

#Action 10: Attacking qualities

after_attacking_qualities <- as.data.frame(table(a10)/sum(table(a10)))

ggplot(after_attacking_qualities, aes(x = a10, y = Freq)) + geom_bar(stat = "identity",fill = "#228B22") + labs(x ="Actions", y = "Proportion")+ylim(c(0,0.5))

#Action 11: Goal kick

after_goal_kick <- as.data.frame(table(a11)/sum(table(a11)))

ggplot(after_goal_kick, aes(x = a11, y = Freq)) + geom_bar(stat = "identity") + labs(x ="Actions", y = "Proportion")

#Action 12: Missed tackle

after_missed_tackle <- as.data.frame(table(a12)/sum(table(a12)))

ggplot(after_missed_tackle, aes(x = a12, y = Freq)) + geom_bar(stat = "identity") + labs(x ="Actions", y = "Proportion")

#Action 14: Restart

after_restart <- as.data.frame(table(a14)/sum(table(a14)))

ggplot(after_restart, aes(x = a14, y = Freq)) + geom_bar(stat = "identity") + labs(x ="Actions", y = "Proportion")

#Action 15: Possession

after_possession <- as.data.frame(table(a15)/sum(table(a15)))

ggplot(after_possession, aes(x = a15, y = Freq)) + geom_bar(stat = "identity",fill = "#228B22") + labs(x ="Actions", y = "Proportion")

#Action 17: Period

after_period <- as.data.frame(table(a17)/sum(table(a17)))

ggplot(after_period, aes(x = a17, y = Freq)) + geom_bar(stat = "identity") + labs(x ="Actions", y = "Proportion")

#Action 18: Collection

after_collection <- as.data.frame(table(a18)/sum(table(a18)))

ggplot(after_collection, aes(x = a18, y = Freq)) + geom_bar(stat = "identity") + labs(x ="Actions", y = "Proportion")

#Action 20: Ref Review

after_ref_review <- as.data.frame(table(a20)/sum(table(a20)))

ggplot(after_ref_review, aes(x = a20, y = Freq)) + geom_bar(stat = "identity") + labs(x ="Actions", y = "Proportion")

#Action 21: Card

after_card <- as.data.frame(table(a21)/sum(table(a21)))

ggplot(after_card, aes(x = a21, y = Freq)) + geom_bar(stat = "identity") + labs(x ="Actions", y = "Proportion")

#Action 23: Ruck

after_ruck <- as.data.frame(table(a23)/sum(table(a23)))

ggplot(after_ruck, aes(x = a23, y = Freq)) + geom_bar(stat = "identity") + labs(x ="Actions", y = "Proportion")

#Action 24: Maul

after_maul <- as.data.frame(table(a24)/sum(table(a24)))

ggplot(after_maul, aes(x = a24, y = Freq)) + geom_bar(stat = "identity") + labs(x ="Actions", y = "Proportion")

#Action 26: Sequence

after_sequence <- as.data.frame(table(a26)/sum(table(a26)))

ggplot(after_sequence, aes(x = a26, y = Freq)) + geom_bar(stat = "identity") + labs(x ="Actions", y = "Proportion")

#Action 27: Lineout take

after_lineout_take <- as.data.frame(table(a27)/sum(table(a27)))

ggplot(after_lineout_take, aes(x = a27, y = Freq)) + geom_bar(stat = "identity") + labs(x ="Actions", y = "Proportion")

#Action 28: offensive scrum

after_offensive_scrum <- as.data.frame(table(a28)/sum(table(a28)))

ggplot(after_offensive_scrum, aes(x = a28, y = Freq)) + geom_bar(stat = "identity") + labs(x ="Actions", y = "Proportion")

#Action 29: defensive scrum

after_defensive_scrum <- as.data.frame(table(a29)/sum(table(a29)))

ggplot(after_defensive_scrum, aes(x = a29, y = Freq)) + geom_bar(stat = "identity") + labs(x ="Actions", y = "Proportion")




