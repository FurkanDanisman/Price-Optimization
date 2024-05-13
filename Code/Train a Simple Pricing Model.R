setwd("")
read.csv()

# Process training data

process_training_data <- function(raw_data) {
  
  # Convert date variable to date format
  
  raw_data$output_date <- as.Date(raw_data$output_date, format = "%d%b%Y")
  
  raw_data$output_date <- as.Date(raw_data$output_date, format = "%Y-%m-%d")
  
  library(lubridate)
  
  raw_data$year <- year(raw_data$output_date)
  
  raw_data$month <- month(raw_data$output_date)
  
  raw_data$day <- day(raw_data$output_date)
  
  library(dplyr)
  
  # Create new variable for price difference between own and competitors
  
  raw_data$price_diff <- raw_data$output_own_price - raw_data$output_comp_price

  # Select relevant variables for training
  
  training_data <- raw_data[, c("output_own_sales","output_own_price","month","day", "output_X", "price_diff", "output_own_cost", "output_own_share", "output_own_profits")]
  
  # Define the target variable (profit) and feature variables
  
  train_inputs <- training_data[, !names(training_data) %in% c("output_own_profits")]
  
  train_outputs <- training_data[,"output_own_profits"]
  
  # Convert the data to DMatrix format, which is required by xgboost
  
  library(xgboost)
  
  train_dmatrix <- xgb.DMatrix(data = as.matrix(train_inputs), label = train_outputs)
  
  return(train_dmatrix)
}

# Train model
train_model <- function(training_data) {
  
  
  # Define xgboost model (maximize the profit but in realistic standards which depends on the other features)
  
  model <- xgb.train(data = training_data,objective = "reg:squarederror", 
                     params = list(booster = "gbtree", eta = 0.9, max_depth = 30,
                                   subsample = 0.9, colsample_bytree = 0.9,maximize=T,eval_metric="error"),
                     nrounds = 100)
  return(model)
}

predict_price <- function(new_input, trained_model) {
  
  # Transform the new input for the prediction
  
  new_input$output_date <- as.Date(new_input$output_date, format = "%d%b%Y")
  
  new_input$output_date <- as.Date(new_input$output_date, format = "%Y-%m-%d")
  
  library(lubridate)
  
  new_input$year <- year(new_input$output_date)
  
  new_input$month <- month(new_input$output_date)
  
  new_input$day <- day(new_input$output_date)
  
  library(dplyr)
  
  # Create new variable for price difference between own and competitors
  
  new_input$price_diff <- new_input$output_own_price - new_input$output_comp_price
  
  # Select relevant variables for training
  
  training_data <- new_input[, c("output_own_sales","output_own_price","month","day", "output_X", "price_diff", "output_own_cost", "output_own_share", "output_own_profits")]
  
  # Define the target variable (profit) and feature variables
  
  train_inputs <- training_data[, !names(training_data) %in% c("output_own_profits")]
  
  train_outputs <- training_data[,"output_own_profits"]
  
  # Convert the data to DMatrix format, which is required by xgboost
  
  train_dmatrix <- xgb.DMatrix(data = as.matrix(train_inputs), label = train_outputs)
  
  # Use trained model to make predictions
  
  profit_predictions <- predict(trained_model, newdata = train_dmatrix)
  
  # Optimize price to maximize profit
  
  price_predictions <- (profit_predictions/ new_input$output_own_sales)+ new_input$output_own_cost
  
  # Adding the comp price to the predicted price since the price and profit has a strong relationship
  # It would optimize the overall points more benefically
  price_predictions <- abs(new_input$output_comp_price-price_predictions)+price_predictions                                                                                                    
  return(price_predictions)
}

process_training_data() # Takes the data that will go into model
train_model() # Takes the process_training_data
predict_price() # Take the new_data and model



