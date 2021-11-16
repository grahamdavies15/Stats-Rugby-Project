# Final Project - Rugby Sequence Generation

This code used the 'keras' package to generate sequences of actions in rugby. All code was done using R. This study used LSTM models to generate these sequences. The data used for this project was provided by our supervisor, and consists of data collected from 5 rugby competitions, spanning 313 games. . This project was only concerned with the action variable from this data set. These actions were scraped from the data set and are supplied under the 'all_actions.Rda' file. The "gen_mod.2.128b.32u.Rdata" file contains 10000 generated seqeunces from a 2-layer stacked LSTM model using 128 batch size, 32 units and a temperature value of 1. This file can be used to conduct EDA on using the 'modelEDA.R' script. 

The R scripts provided are as follows:

  Rugby_dataClean.R - Cleans and prepares the data for training.
  
  LSTM1_train.R     - Trains 6 different single-layer LSTM models.
  
  LSTM2_train.R     - Trains 6 different 2-layer stacked LSTM models.
  
  winnersVSlosers.R - Game simulation script. Requires saved generated models from winning and losing teams.
  
  Rugby_output.R - Takes a trained model and generates 10000 sequences based on that model.
  
  modelEDA - Some explanatory data analysis done on the 10000 generated sequences from a specific model
  
  eda.R - Explanatory data analysis done on the sequences of actions from the original data set.
  
  winLosePrepTrain.R - Script that prepares and trains the winning and losing teams' model.
  
  
 

References:

https://github.com/jnolis/banned-license-plates

https://machinelearningmastery.com/text-generation-lstm-recurrent-neural-networks-python-keras/

https://keras.rstudio.com/articles/examples/lstm_text_generation.html

https://blogs.rstudio.com/ai/posts/2017-12-07-text-classification-with-keras/

https://www.r-bloggers.com/2018/10/tensorflow-jane-austen-and-text-generation/

https://www.r-bloggers.com/2018/11/lstm-with-keras-tensorflow/

https://keras.rstudio.com/
