##### Single-layer LSTM model training #####

#### 128 units Models ####

# the input to the network
input <- layer_input(shape = c(max_length,num_characters)) 

#the output to the network
output <- 
  input %>%
  layer_lstm(units = 128) %>% #128 units
  layer_dense(num_characters) %>%
  layer_activation("softmax")

## 256 batch size ##
# Compiling models
mod.1.256b.128u <- keras_model(inputs = input, outputs = output) %>%
  compile(
    loss = 'categorical_crossentropy',
    optimizer = "adam"
  )

#Callbacks
summary(mod.1.256b.128u)

# callbacks to save
callbacks_list_256 <- list(
  callback_early_stopping( #early stopping criterion, delta = 0.001 and patience = 5
    monitor = "loss",
    min_delta = 0.001,
    patience = 5),

  callback_model_checkpoint(
    filepath = "mod.1.256b.128u.h5",
    monitor = "loss",
    save_best_only = TRUE
  )
)


## Running the model ##

fit_mod.1.256b.128u <- mod.1.256b.128u %>% keras::fit(
  X,
  y,
  batch_size = 256, #256 batch size
  epochs = 200,
  callbacks = callbacks_list_256 #
)






##  128 batch size ##
# Compiling models
mod.1.128b.128u <- keras_model(inputs = input, outputs = output) %>% 
  compile(
    loss = 'categorical_crossentropy',
    optimizer = "adam"
  )

summary(mod.1.128b.128u)

# callbacks
callbacks_list_128 <- list(
  callback_early_stopping( #early stopping criterion, delta = 0.001 and patience = 5
    monitor = "loss",
    min_delta = 0.001,
    patience = 5),
  
  callback_model_checkpoint( #save file on best iteration
    filepath = "mod.1.128b.128u.h5", 
    monitor = "loss",
    save_best_only = TRUE
  )
)

#run the model
fit_mod.1.128b.128u <- mod.1.128b.128u %>% keras::fit(
  X, 
  y,
  batch_size = 128,
  epochs = 200,
  callbacks = callbacks_list_128
)







## 32 batch size ##
mod.1.32b.128u <- keras_model(inputs = input, outputs = output) %>% 
  compile(
    loss = 'categorical_crossentropy',
    optimizer = "adam"
  )

summary(mod.1.32b.128u)
# callbacks 
callbacks_list_32 <- list(
  callback_early_stopping( #early stopping criterion, delta = 0.001 and patience = 5
    monitor = "loss",
    patience = 5,
    min_delta = 0.001),

  callback_model_checkpoint(
    filepath = "mod.1.32b.128u.h5", # save best model
    monitor = "loss",
    save_best_only = TRUE
  )
)

# run the model
fit_mod.1.32b.128u <- mod.1.32b.128u %>% keras::fit(
  X,
  y,
  batch_size = 32,
  epochs = 200,
  callbacks = callbacks_list_32
)













#### 32 Unit models ####

# the input to the network
input <- layer_input(shape = c(max_length,num_characters)) 

#the output to the network
output <- 
  input %>%
  layer_lstm(units = 32) %>% #32 units
  layer_dense(num_characters) %>%
  layer_activation("softmax")

## 256 batch size ##
# Compiling models
mod.1.256b.32u <- keras_model(inputs = input, outputs = output) %>%
  compile(
    loss = 'categorical_crossentropy',
    optimizer = "adam"
  )

#Callbacks
summary(mod.1.256b.32u)

# callbacks to save
callbacks_list_256_32 <- list(
  callback_early_stopping( #early stopping criterion, delta = 0.001 and patience = 5
    monitor = "loss",
    min_delta = 0.001,
    patience = 5),
  
  callback_model_checkpoint(
    filepath = "mod.1.256b.32u.h5",
    monitor = "loss",
    save_best_only = TRUE
  )
)


## Running the model ##

fit_mod.1.256b.32u <- mod.1.256b.32u %>% keras::fit(
  X,
  y,
  batch_size = 256, #256 batch size
  epochs = 200,
  callbacks = callbacks_list_256_32 #activate callbacks
)







##  128 batch size ##
# Compiling models
mod.1.128b.32u <- keras_model(inputs = input, outputs = output) %>% 
  compile(
    loss = 'categorical_crossentropy',
    optimizer = "adam"
  )

summary(mod.1.128b.32u)

# callbacks
callbacks_list_128_32 <- list(
  callback_early_stopping( #early stopping criterion, delta = 0.001 and patience = 5
    monitor = "loss",
    min_delta = 0.001,
    patience = 5),
  
  callback_model_checkpoint( #save file on best iteration
    filepath = "mod.1.128b.32u.h5", 
    monitor = "loss",
    save_best_only = TRUE
  )
)

#run the model
fit_mod.1.128b.32u <- mod.1.128b.32u %>% keras::fit(
  X, 
  y,
  batch_size = 128,
  epochs = 200,
  callbacks = callbacks_list_128_32
)







## 32 batch size ##
mod.1.32b.32u <- keras_model(inputs = input, outputs = output) %>% 
  compile(
    loss = 'categorical_crossentropy',
    optimizer = "adam"
  )

summary(mod.1.32b.32u)
# callbacks 
callbacks_list_32_32 <- list(
  callback_early_stopping( #early stopping criterion, delta = 0.001 and patience = 5
    monitor = "loss",
    patience = 5,
    min_delta = 0.001),
  
  callback_model_checkpoint(
    filepath = "mod.1.32b.32u.h5", # save best model
    monitor = "loss",
    save_best_only = TRUE
  )
)

# run the model
fit_mod.1.32b.32u <- mod.1.32b.32u %>% keras::fit(
  X,
  y,
  batch_size = 32,
  epochs = 200,
  callbacks = callbacks_list_32_32
)
