###
# author: Myriam Munezero
# date: 28.03.208
###

## Load the necessary libraries
library(ggplot2) # needed for the plots
library(caret) # needed for building ML models

## Load data
mydata<-read.csv("economic-data-africa.csv", header = TRUE, sep = ";", stringsAsFactors = FALSE, dec = ",", na.strings = "N/A") 
# can also specify above, if you already how the missing values look like with - "na.strings = "NA"


#-----------Explore the data ----------#

## Before building model - good practice to analyze and understand how the data looks like
class(mydata) # class of mydata (e.g., numeric, matrix, data frame, etc)
dim(mydata) # dimensions of mydata = 51 * 3
str(mydata) # see the structure of mydata
summary(mydata) # gives more information
head(mydata) # or can use tail(mydata, 10)


## Identify if any missing values exist in our data set and the quantity
sum(is.na(mydata))  # 1.returns TRUE of mydata is missing 2. count the amount of missing values


#-----------Explore with visuals as well----------#

X<-mydata$GovExpenditurePerc
Y<-mydata$UnemploymentPerc


## 1. Lets plot a scatter plot
plot(x=X, y=Y, main = "Unemployment Rate (%) ~Goverment Expenditure (%)") 

# Looking at these plots, would it be possible for us to plot a line through these points

# 2. Instead of imgining, we can use the scatter.smooth function draws the line
scatter.smooth(x=X, y=Y, main = "Unemployment Rate (%) ~ Goverment Expenditure (%)")

# So how does this line look like? "The scatter plot along with the smoothing 
# line above suggests that there is a linearly increasing relationship between the 
# government expenditure and unemployment rate variables. This is a good thing, because, one of the underlying 
# assumptions in linear regression is that the relationship 
# between the response and predictor variables is linear and additive.

# With this function, if there looks to be a line, then we know that linear regression 
# might be the appropriate prediction approach for this dataset.

# 3. Another way of checking if there is a relationship between our variables is to plot a 
# correlation map. We can do that as follows:
cor(X, Y)


# 4. Let's also do a boxplot - A box plot is good for seeing if there are any outliers.
# It is good to check for outliers as these might affect your model.
par(mfrow = c(1,2)) # divide graph area in 2 columns
boxplot(X, main="Government expenditure") 
boxplot(Y, main="Unemployment rates")  

# We do find outliers. Let's remove the biggest outlier as this will affect our model.
mydata<-mydata[mydata$GovExpenditurePerc<80, ]

#-----------Let's build the linear model----------#

# Now that we have seen the linear relationship pictorially using the scatter plot let 
# us now see the syntax for building the linear model.

# split the dataset into training and test set
set.seed(7) # To ensure that our data is randomly split in the same for all our runs
inTrain<-createDataPartition(mydata$GovExpenditurePerc, p =0.8, list = FALSE)

trainset<-mydata[inTrain,]
testset<-mydata[-inTrain,]
dim(trainset) # 42   4
dim(testset) # 8   4


# The lm() function is what is used to build a linear regression model in R.
# It takes in two main arguments, namely: 1. Formula 2. Data."

linearMod<-lm(UnemploymentPerc ~ GovExpenditurePerc, data = trainset) 
# building the linear model establishes a mathematical relationship between the predictor and factors.

# What does this model look like?
print(linearMod)
# From the output, we are mostly interested in the  Coefficients of our model. This has part having two components: 
# Intercept: -3.5539, Slope: 0.4942 These are also called the beta coefficients. 
# In other words, => Unemployment = -3.5539 + 0.4942 * Government Expenditure

# With these coefficients, if given a new amount of government expenditure in Africa, 
# we can use it to predict what the unemployment rate is.


#-----------Let's evaluate how good our linear model is----------#

# With our model, we can make predictions on new data, but will they be good? 
# That is what we also have to find out! Before using the regression model, we have to ensure 
# that it is statistically significant. 
# We can check this by printing the summary statistics for linearMod.
sm<-summary(linearMod)
sm
# In these results, there are a few things to look at: 
# 1. p-value of the model p-Value (bottom last line) and the p-Value of individual predictor 
# variables (extreme right column under Coefficients). The p-Values are very important because, 
# We can consider a linear model to be statistically significant only when both these p-Values 
# are less that the pre-determined statistical significance level, which is ideally 0.05. 
# This is visually interpreted by the significance stars at the end of the row. 
# The more the stars beside the variables p-Value, the more significant the variable.
# if p-value is less than 0.05, we can conclude that our model is indeed statistically significant.

## 2. Both standard errors (closer to zero the better) and 3. F-statistic (higher the better) are measures of goodness of fit.

# Mean squared error
mse <- mean(sm$residuals^2)
mse



#------------Diagnostic plots------------#
# Let's plot and see our model
par(mfrow = c(1,1))
plot(x=trainset$GovExpenditurePerc, y=trainset$UnemploymentPerc, main = "Unemployment (%) ~ Goverment expenditure (%)") 
abline(linearMod, col = "red") # show the line abline(lm(y ~x)) - best line that fits the points
#residuals(linearMod)



#-----------Let's do some prediction with our linear model is----------#


unemplPred<-predict(linearMod, newdata = testset)


# get and plot the predicted values of the test data to see how our model is


ggplot(testset, aes(x=testset$GovExpenditurePerc, y =testset$UnemploymentPerc)) +
  geom_segment(aes(xend = testset$GovExpenditurePerc, yend = unemplPred), alpha = .2) +
  geom_point() + 
  geom_point(aes(y = unemplPred), shape = 1, col = "red") +
  theme_bw()

# Mean Squared Error on the test data
mse_test<-mean((testset$UnemploymentPerc - unemplPred) ** 2)
mse_test

##---------Assessment-----------##

# 1. What do you think of the model? 
# 2. What could we do to improve it? Are the variable sufficient?


#-----------Multi-variate linear regression----------#
# If we had more variables to consider, e.g., country's GDP, then the formula for training our 
# linear model would be something like this, where X1 and X2 are other variable names.
multiMod<-lm(UnemploymentPerc ~ GovExpenditurePerc + X1 + X2, data = trainset)

##----------That's it for now!--------------##
