library(keras)

# load the actions data
load("all_actions.Rda")
actions <- all_acts

#unique actions
unique_actions <- actions %>%
  unique() %>%
  sort()

#crete action indexes
action_lookup <- data.frame(action = c(unique_actions), stringsAsFactors = FALSE)
action_lookup[["action_id"]] <- 1:nrow(action_lookup)

num_actions <- nrow(action_lookup)+1  #24 + 1

#max length of input sequences
max_length <- 49

# load LSTM model
model <- load_model_hdf5("model.128.1layer.Rda")


# this function generates a sequence of actions
# model = the trained LSTM model
# action_lookup = table of actions and their IDs
# max_length = the length of input sequences
# temperature = the diversity of the generated sequences
generate_sequence <- function(model, action_lookup, max_length, temperature=1){
  
  # given the probabilities from the model, this function chooses the next action in the sequence:
  next_action <- function(predicted_probs,action_lookup,temperature=1){
    
    predicted_probs <- log(predicted_probs)/temperature
    predicted_probs <- exp(predicted_probs)/sum(exp(predicted_probs))
    next_index <- which.max(as.integer(rmultinom(1, 1, predicted_probs)))
    action_lookup$action[next_index-1]
  }
  
  # create vector to store next actions
  actions_progress <- character(0)
  next_act <- ""
  
  # while the sequence hasnt reached action 15, and the sequence has not reached max_length
  while(next_act != "15" && length(actions_progress) < max_length){
    
    
    #get sequence of actions generated so far
    previous_actions_data <- 
      lapply(list(actions_progress), function(.x){
        action_lookup$action_id[match(.x,action_lookup$action)]
      })
    
    #pad the sequence
    previous_actions_data <- pad_sequences(previous_actions_data, maxlen = max_length)
    #convert to categorical
    previous_actions_data <- to_categorical(previous_actions_data, num_classes = num_actions)
    
    # get the probabilities of each possible next action by running the model using the padded sequence
    next_action_probs <- 
      predict(model,previous_actions_data)
    
    # determine what the actual next action is
    next_act <- next_action(next_action_probs,action_lookup,temperature)
    
    # if the next action isn't 15 add the latest generated action to the sequence and continue
    if(next_act != "15") 
      actions_progress <- c(actions_progress,next_act)
  }
  
  #convert the list of actions into a single string
  seq <- paste0(actions_progress, collapse=" ")
  #generated sequence
  seq
}

# this function generates many sequences, specified by N
generate_many_sequences <- function(N=10000, ...){
  
  unlist(lapply(1:N,function(x) generate_sequence(...)))
  
}

# generate 1 sequence
generate_sequence(model, action_lookup, max_length)

#generate 10000 sequences
sequence_output <- generate_many_sequences(10000, model, action_lookup, max_length)  
sequence_output



