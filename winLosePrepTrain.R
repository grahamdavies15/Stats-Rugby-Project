# Winners vs. Losers Script


## Activate required Libraries
library(tensorflow)
library(keras)
library(readxl)
library(keras)
library(stringr)
library(DescTools)
library(purrr)
library(dplyr)
library(tidyr)


########. Winners #######
load("winnerDat.Rdata")
winAct <- as.numeric(winnerDat$act)


# get actions column
actions <- (winAct)
length(actions) #485502

#unique actions
unique_acts <- actions %>%  #24
  unique() %>%
  sort()

#create action indices
action_lookup <- data.frame(action = c(unique_acts), stringsAsFactors = FALSE)
action_lookup[["action_id"]] <- 1:nrow(action_lookup)

num_actions <- nrow(action_lookup) + 1  #24 + 1


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

seq <- seq[-length(seq)] #remove last sequence conatianing an NA value

seq<-tibble(seq) %>%
  mutate(id = row_number())

#12535 sequences

#create cumulitive sequences and shuffle
action_data <-
  seq %>% 
  mutate(accumulated_seq = seq %>%
           str_split(" ") %>%              # split into actions
           map( ~ purrr::accumulate(.x,c)) # make into cumulative sequences
  ) %>%
  select(accumulated_seq) %>%            # get only the column with the names
  unnest(accumulated_seq) %>%            # break into individual rows
  pull(accumulated_seq)                  # change to a list

#136097 action_data

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
  map(~ action_lookup$action_id[match(.x,action_lookup$action)]) %>% # change characters into the right numbers
  pad_sequences(maxlen = max_length+1) %>%                           # add padding so all of the sequences have the same length
  to_categorical(num_classes = num_actions)


# Make X and y
X <- act_matrix[,1:max_length,] # make the X data of the actions before
y <- act_matrix[,max_length+1,] # make the Y data of the next action



##### Winners 1 layer, 128 batch, 128 Units #####

# the input to the network
input <- layer_input(shape = c(max_length,num_characters)) 


#layers
output <- 
  input %>%
  layer_lstm(units = 128) %>%       #
  layer_dense(num_characters) %>%
  layer_activation("softmax")


# Compiling models
mod.win.128b <- keras_model(inputs = input, outputs = output) %>%    #
  compile(
    loss = 'categorical_crossentropy',
    optimizer = "adam"
  )

#Callbacks
summary(mod.win.128b)     #

callbacks_list_win_128 <- list(   #
  callback_early_stopping(
    monitor = "loss", 
    min_delta = 0.001,
    patience = 5),
  
  callback_model_checkpoint(
    filepath = "mod.win.128b.h5",        #
    monitor = "loss",
    save_best_only = TRUE
  )
)

## Running the model ##
fit_mod.win.128b <- mod.win.128b %>% keras::fit(     ##
  X, 
  y,
  batch_size = 128,       #
  epochs = 200,
  callbacks = callbacks_list_win_128          #
)


########## loser ##########
rm(list = ls()) 
load("loserDat.Rdata")
loserAct <- as.numeric(loserDat$act)


# get actions column
actions <- (loserAct)


#unique actions
unique_acts <- actions %>%  #24
  unique() %>%
  sort()

#create action indices
action_lookup <- data.frame(action = c(unique_acts), stringsAsFactors = FALSE)
action_lookup[["action_id"]] <- 1:nrow(action_lookup)

num_actions <- nrow(action_lookup) + 1  #24 + 1


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

seq <- seq[-length(seq)] #remove last sequence conatianing an NA value

seq<-tibble(seq) %>%
  mutate(id = row_number())

#12535 sequences

#create cumulitive sequences and shuffle
action_data <-
  seq %>% 
  mutate(accumulated_seq = seq %>%
           str_split(" ") %>%              # split into actions
           map( ~ purrr::accumulate(.x,c)) # make into cumulative sequences
  ) %>%
  select(accumulated_seq) %>%            # get only the column with the names
  unnest(accumulated_seq) %>%            # break into individual rows
  pull(accumulated_seq)                  # change to a list

#136097 action_data

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
  map(~ action_lookup$action_id[match(.x,action_lookup$action)]) %>% # change characters into the right numbers
  pad_sequences(maxlen = max_length+1) %>%                           # add padding so all of the sequences have the same length
  to_categorical(num_classes = num_actions)


# Make X and y
X <- act_matrix[,1:max_length,] # make the X data of the actions before
y <- act_matrix[,max_length+1,] # make the Y data of the next action



##### 1 layer, 128 batch, 128 Units #####


# the input to the network
input <- layer_input(shape = c(max_length,num_characters)) 


#layers
output <- 
  input %>%
  layer_lstm(units = 128) %>%       #
  layer_dense(num_characters) %>%
  layer_activation("softmax")


# Compiling models
mod.lose.128b <- keras_model(inputs = input, outputs = output) %>%    #
  compile(
    loss = 'categorical_crossentropy',
    optimizer = "adam"
  )

#Callbacks
summary(mod.lose.128b)     #

callbacks_list_lose_128 <- list(   #
  callback_early_stopping(
    monitor = "loss", 
    min_delta = 0.001,
    patience = 5),
  
  callback_model_checkpoint(
    filepath = "mod.lose.128b.h5",        #
    monitor = "loss",
    save_best_only = TRUE
  )
)

## Running the model ##
fit_mod.lose.128b <- mod.lose.128b %>% keras::fit(     ##
  X, 
  y,
  batch_size = 128,       #
  epochs = 200,
  callbacks = callbacks_list_lose_128          #
)
