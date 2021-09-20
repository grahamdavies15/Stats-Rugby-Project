library(readxl)
library(keras)
library(stringr)
setwd("Desktop/Thesis/Data")
path <- "data.xlsx"

#read in excel sheets
sheetnames <- excel_sheets(path)
mylist <- lapply(excel_sheets(path), read_excel, path = path)

# name the sheets
names(mylist) <- sheetnames

# rugby championship
rc14 <- read_excel(path = path, sheet = "RC14")

head(rc14)

# get actions column
actions <- rc14$act[1:500]

#split into sequences ending in play 15
library(DescTools)
seq <- SplitAt(actions,which(actions==15)+1)

#longest sequence
max(lengths(seq))

#pre-pad sequences
pad <- seq

for (i in 1:length(pad)){
  pad[[i]] <- pad_sequences(pad[i],41)
  
}

class(pad)

#get into right format
actions_vec <- unlist(pad)
#actions_vec <- paste(actions_vec,collapse = " ")
#actions_vec<-as.character(actions_vec)



#length of sequence and step
maxlen <- 41
step <- 3

# act_indexes <- seq(1, length(actions_vec) - maxlen, by = step)
# sequences <- str_sub(actions_vec, act_indexes, act_indexes + maxlen - 1)  #Holds the targets (the follow-up characters)
# next_act <- str_sub(actions_vec, act_indexes + maxlen, act_indexes + maxlen)  #Holds the extracted sequences

# Cut the text in semi-redundant sequences of maxlen characters
library(purrr)

dataset <- map(
  seq(1, length(actions_vec) - maxlen - 1, by = 3), 
  ~list(sentece = actions_vec[.x:(.x + maxlen - 1)], next_char = actions_vec[.x + maxlen])
)


#transpose
dataset <- transpose(dataset)

#unique actions
chars <- actions_vec %>%
  unique() %>%
  sort()

# Vectorization
x <- array(0, dim = c(length(dataset$sentece), maxlen, length(chars)))
y <- array(0, dim = c(length(dataset$sentece), length(chars)))

for(i in 1:length(dataset$sentece)){
  
  x[i,,] <- sapply(chars, function(x){
    as.integer(x == dataset$sentece[[i]])
  })
  
  y[i,] <- as.integer(chars == dataset$next_char[[i]])
  
}

# Model Definition --------------------------------------------------------

model <- keras_model_sequential()

model %>%
  layer_lstm(128, input_shape = c(maxlen, length(chars))) %>%
  layer_dense(length(chars)) %>%
  layer_activation("softmax")

optimizer <- optimizer_rmsprop(lr = 0.01)

model %>% compile(
  loss = "categorical_crossentropy", 
  optimizer = optimizer
)

# Training & Results ----------------------------------------------------

sample_mod <- function(preds, temperature = 1){
  preds <- log(preds)/temperature
  exp_preds <- exp(preds)
  preds <- exp_preds/sum(exp(preds))
  
  rmultinom(1, 1, preds) %>% 
    as.integer() %>%
    which.max()
}

on_epoch_end <- function(epoch, logs) {
  
  cat(sprintf("epoch: %02d ---------------\n\n", epoch))
  
  for(diversity in c(1)){   #c(0.2, 0.5, 1, 1.2)){
    
    cat(sprintf("diversity: %f ---------------\n\n", diversity))
    
    start_index <- sample(1:(length(actions_vec) - maxlen), size = 1)
    sentence <- actions_vec[start_index:(start_index + maxlen - 1)]
    generated <- ""
    
    
    for(i in 1:10){
      
      x <- sapply(chars, function(x){
        as.integer(x == sentence)
      })
      x <- array_reshape(x, c(1, dim(x)))
      
      preds <- predict(model, x)
      next_index <- sample_mod(preds, diversity)
      next_char <- chars[next_index]
      
      generated <- str_c(generated," ", next_char, collapse = "")
      sentence <- c(sentence[-1], next_char)
      
    }
    
    cat(generated)
    cat("\n\n")
    
  }
}

print_callback <- callback_lambda(on_epoch_end = on_epoch_end)

model %>% fit(
  x, y,
  batch_size = 128,
  epochs = 10,
  callbacks = print_callback
)
