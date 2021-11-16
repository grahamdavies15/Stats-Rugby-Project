# Final Project - Rugby Sequence Generation

This code used the 'keras' package to generate sequences of actions in rugby. All code was done using R. This study used LSTM models to generate these sequences. The data used for this project was provided by our supervisor, and consists of data collected from 5 rugby competitions, spanning 313 games. The data is supplied and titled 'data'. This project was only concerned with the action variable from this data set. These actions were scraped from the data set and are supplied under the 'all_actions.Rda' file. 

The R scripts provided are as follows:
  Rugby_dataClean.R - Cleans and prepares the data for training.
  LSTM1_train.R     - Trains 6 different single-layer LSTM models.
  LSTM2_train.R     - Trains 6 different 2-layer stacked LSTM models.
  
  
  winnersVSlosers.R - Game simulation script. Requires saved generated models from winning and losing teams.
