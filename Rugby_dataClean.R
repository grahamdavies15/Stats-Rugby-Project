#### Data cleaning and preparation ####

## Activate libraries
library(tensorflow)
library(keras)
library(readxl)
library(stringr)
library(DescTools)
library(purrr)
library(dplyr)
library(tidyr)
library(ggplot2)


#load data set
#load("Dropbox/Data/all_actions.Rda")
load("all_actions.Rda")


# get actions column
actions <- (all_acts)
length(actions) #485502

#unique actions
chars <- actions %>%  #24
  unique() %>%
  sort()

#create action indices
action_lookup <- data.frame(character = c(chars), stringsAsFactors = FALSE)
action_lookup[["character_id"]] <- 1:nrow(action_lookup)

num_characters <- nrow(action_lookup) + 1  #24 + 1


#split into sequences ending in play 15
seq <- SplitAt(actions, which(actions=="15") + 1)


# Boxplot of sequences

# png("boxplotSeqBefore.png", width = 685, height = 450)
ggplot(as.data.frame(lengths(seq)), aes( y=lengths(seq))) + 
  geom_boxplot(fill="#8DB600", alpha=0.4) + coord_flip() + ylab("Length of sequence") + theme(axis.title = element_text(size = 15))
# dev.off()

#Stats prior to removal
summary(lengths(seq))

#remove seuqences of 1
seq <- seq[-which(lengths(seq) == 1)]
seq <- seq[-which(lengths(seq) %in% boxplot.stats(lengths(seq))$out)]

#stats after romval
summary(lengths(seq))

# png("boxplotSeqAfter.png", width = 685, height = 450)
# ggplot(as.data.frame(lengths(seq)), aes( y=lengths(seq))) +
#   geom_boxplot(fill="#8DB600", alpha=0.4) + coord_flip() + ylab(label = "Length of sequence") + theme(axis.title = element_text(size = 15))
# dev.off()

max_length <- max(lengths(seq)) #49

# get into tibble format
for (i in 1:length(seq))
{
  seq[[i]] <- paste(seq[[i]],collapse=' ')
}

seq<-unlist(seq)

seq<-tibble(seq) %>%
  mutate(id = row_number())

#25005 sequences

#create cumulitive sequences and shuffle
action_data <-
  seq %>% 
  mutate(accumulated_plate = seq %>%
           str_split(" ") %>%              # split into actions
           map( ~ purrr::accumulate(.x,c)) # make into cumulative sequences
  ) %>%
  select(accumulated_plate) %>%            # get only the column with the names
  unnest(accumulated_plate) %>%            # break into individual rows
  pull(accumulated_plate)                  # change to a list

#389591 action_data

#change to numeric
for (i in 1:length(action_data))
{
  action_data[[i]] <- as.numeric(action_data[[i]])
}

#check sequence format
action_data 

#1 hot encode - pad and get into matrix form
act_matrix <-
  action_data %>%
  map(~ character_lookup$character_id[match(.x,action_lookup$character)]) %>% # change characters into the right numbers
  pad_sequences(maxlen = max_length+1) %>%                                    # add padding so all of the sequences have the same length
  to_categorical(num_classes = num_characters)


# Make X and y
X <- act_matrix[,1:max_length,] # make the X data of the actions before
y <- act_matrix[,max_length+1,] # make the Y data of the next action
