### this R script conducts explanatory data analysis on 10000 generated seqeunces from a model
library(janitor)

#load 10000 generated sequences from the chosen model
load("gen_mod.2.32b.128u.Rdata")

mod <- gen_mod.2.32b.128u #assign model sequences to mod variable

mod <- strsplit(mod," ") #split the sequences into individual characters


#remove sequences with length of 0
if (sum(lengths(mod)==0)>0){
  mod <- mod[-which(lengths(mod)==0)]
}

#add a 15 to the end of each sequence
for (i in 1:length(mod)){
  mod[[i]] <- as.numeric(mod[[i]])
  mod[[i]][length(mod[[i]])+1]<-15
  
}

#get sequence lengths summary statistics
length_summary <- summary(lengths(mod))
length_summary

# Get duplicate sequences and see how many times they occured:
actions <- mod

# convert sequences into tibble format
for (i in 1:length(actions)){
  actions[[i]] <- paste(actions[[i]],collapse=' ')
}

seq<-unlist(actions)

seq<-tibble(seq) %>%
  mutate(id = row_number())

# get duplicate sequences
dupes1<-get_dupes(seq,seq)

# number of times these sequences were duplicated
num_dupes <- dupes1$dupe_count

#get the count of sequences that were duplicated the most
tail(sort(unique(num_dupes)))

# look at the top 5 most occuring sequences and get their proportion of occurance out of the 10000 generated seqeunces

unique(dupes1[which(dupes1$dupe_count==356),]) 
356/10000

unique(dupes1[which(dupes1$dupe_count==324),]) 
324/10000

unique(dupes1[which(dupes1$dupe_count==190),]) 
190/10000

unique(dupes1[which(dupes1$dupe_count==126),])
126/10000

unique(dupes1[which(dupes1$dupe_count==87),])
87/10000

#get duplicated long seqeunces (sequences with a length greater than 20):

#create empty list
dupes_x <- list()

#add duplicated sequences to list
for (i in 1:nrow(dupes1)){
  dupes_x[i] <- strsplit(dupes1$seq[i]," ")
}

#get top 5 longest duplicated sequences:

max(lengths(dupes_x)) #longest is 26

long_dupes <-dupes_x[which(lengths(dupes_x)>20)] # choose sequences longer than 20 actions

# make one long character
for (i in 1:length(long_dupes)){
  long_dupes[[i]] <- paste(long_dupes[[i]],collapse=' ')
}

#convert into tibble:
seq<-unlist(long_dupes)

seq<-tibble(seq) %>%
  mutate(id = row_number())

#get duplicated sequences
dupes1<-get_dupes(seq,seq)
u_dupes1<-unique(dupes1$seq)

# how many times they occured
num_dupes <- dupes1$dupe_count

# look at these sequences
unique(dupes1[dupes1$dupe_count==2,"seq"])



#get into one whole vector
mod_vec <- unlist(mod)

#get distribution of actions
prop_mod <- as.data.frame(table(mod_vec)/sum(table(mod_vec)))

# mod4_plot <- cbind(prop_mod, "Model 2.15")
# colnames(mod4_plot) <- c("act", "Freq", "Key")
# 
# orig_mod4 <- rbind(orig_plot,mod4_plot)
# orig_mod4 <- ggplot(orig_mod4, aes(x = act, y = Freq, fill = Key)) + geom_bar(stat = "identity", position=position_dodge()) +xlab("Actions")+ylab("Proportions")
# 
# all_models <- rbind(mod1_plot,mod2_plot,mod3_plot,mod4_plot)
# all_models <- ggplot(all_models, aes(x = act, y = Freq, fill = Key)) + geom_bar(stat = "identity", position=position_dodge()) +xlab("Actions")+ylab("Proportions")


#plot distribution of actions
mod1_dist <- ggplot(prop_mod,aes(x=mod_vec,y=Freq))+geom_bar(stat="identity")+xlab("Actions")+ylab("Proportions")+ylim(c(0,0.18))
mod1_dist

#get actions that follow each action
a1 <- mod_vec[which(mod_vec==1)+1]
a2 <- mod_vec[which(mod_vec==2)+1]
a3 <- mod_vec[which(mod_vec==3)+1]
a4 <- mod_vec[which(mod_vec==4)+1]
a5 <- mod_vec[which(mod_vec==5)+1]
a6 <- mod_vec[which(mod_vec==6)+1]
a7 <- mod_vec[which(mod_vec==7)+1]
a8 <- mod_vec[which(mod_vec==8)+1]
a9 <- mod_vec[which(mod_vec==9)+1]
a10 <- mod_vec[which(mod_vec==10)+1]
a11 <- mod_vec[which(mod_vec==11)+1]
a12 <- mod_vec[which(mod_vec==12)+1]
#a13 <- all_acts[which(all_acts==13)+1]
a14 <- mod_vec[which(mod_vec==14)+1]
a15 <- mod_vec[which(mod_vec==15)+1]
a17 <- mod_vec[which(mod_vec==17)+1]
a18 <- mod_vec[which(mod_vec==18)+1]
a20 <- mod_vec[which(mod_vec==20)+1]
a21 <- mod_vec[which(mod_vec==21)+1]
a23 <- mod_vec[which(mod_vec==23)+1]
a24 <- mod_vec[which(mod_vec==24)+1]
a26 <- mod_vec[which(mod_vec==26)+1]
a27 <- mod_vec[which(mod_vec==27)+1]
a28 <- mod_vec[which(mod_vec==28)+1]
a29 <- mod_vec[which(mod_vec==29)+1]

#after attacking sequences
after_attacking_qualities4 <- as.data.frame(table(a10)/sum(table(a10)))

ggplot(after_attacking_qualities4, aes(x = a10, y = Freq)) + geom_bar(stat = "identity",fill = "#228B22") + labs(x ="Actions", y = "Proportion") +ylim(c(0,0.5))



#after  kicks
after_kick1 <- as.data.frame(table(a11)/sum(table(a11)))

ggplot(after_kick1, aes(x = a11, y = Freq)) + geom_bar(stat = "identity") + labs(x ="Actions", y = "Proportion")


#after scrums
after_scrum1 <- as.data.frame(table(a5)/sum(table(a5)))

ggplot(after_scrum1, aes(x = a5, y = Freq)) + geom_bar(stat = "identity") + labs(x ="Actions", y = "Proportion")

#after penalty conceded
after_penalty4<- as.data.frame(table(a7)/sum(table(a7)))

after_penalty4<-ggplot(after_penalty4, aes(x = a7, y = Freq)) + geom_bar(stat = "identity",fill = "#228B22") + labs(x ="Actions", y = "Proportion")
after_penalty4

#after collection
after_collection1 <- as.data.frame(table(a18)/sum(table(a18)))

ggplot(after_collection1, aes(x = a18, y = Freq)) + geom_bar(stat = "identity") + labs(x ="Actions", y = "Proportion")


#after perod
after_period1 <- as.data.frame(table(a17)/sum(table(a17)))

ggplot(after_period1, aes(x = a17, y = Freq)) + geom_bar(stat = "identity") + labs(x ="Actions", y = "Proportion")

#after possession
after_possession4 <- as.data.frame(table(a15)/sum(table(a15)))

ggplot(after_possession4, aes(x = a15, y = Freq)) + geom_bar(stat = "identity",fill = "#228B22") + labs(x ="Actions", y = "Proportion") +ylim(c(0,0.6))

