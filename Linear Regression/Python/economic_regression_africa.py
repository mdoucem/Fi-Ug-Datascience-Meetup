"""
Created on Friday March  2, 2018
@author: Joshua Olayemi
"""

# Import the needed libraries
import matplotlib.pyplot as plt # for the creating plots
import pandas as pd # for working with dataframes
import numpy as np

# Load our dataset
dataset = pd.read_csv('economic-data-africa.csv', sep=';', encoding='ISO-8859-1')
# Let's look at how our data looks like
dataset.shape
dataset.head(5)

# select specific rows
dataset = dataset.loc[dataset['GovExpenditurePerc'] < 80]
dataset.shape

# Subset the data
X = dataset['GovExpenditurePerc']
y = dataset['UnemploymentPerc']

# First we split the data into a training and test set, 80:20
# Random state ensures that we have the same random split in all our runs
from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=.20, random_state=00)

# Next we need to reshape the array since sklearn library requires a 2D array
X1_train = X_train.values.reshape(-1, 1)

# Fitting a simple Linear Regression to the Training set
from sklearn.linear_model import LinearRegression
# First create a LinearRegression object
regressor = LinearRegression()
regressor.fit(X1_train, y_train)


# Return coefficient of determination - check these
print(regressor.coef_) # the slope
print(regressor.intercept_) # the intercept

mseTrain = np.mean((y_train - regressor.predict(X1_train)) ** 2)

# Visualise the linear regression line (in blue) on the training set.
# We also add the coefficients for illustration
plt.scatter(X1_train, y_train, color = 'red')
plt.plot(X1_train, regressor.predict(X1_train), color ='blue')
plt.title('Unemployment vs Government Expenditure (Training set): ' + "\n" +
          'Mean Squared Error = ' + str(round(mseTrain, 2)))
plt.xlabel('Government Expenditure (%)')
plt.ylabel('Unemployment (%)')
plt.show()

# Let's use the linear model to predict unemployment on the test set
# First reshape the test set into a 2D array as well
X1_test = X_test.values.reshape(-1,1)

# performing the prediction
y_pred = regressor.predict(X1_test)

# Based on, how well did our model do?
# Let's look at the mean-squared errors and plot it
mseTest = np.mean((y_test - y_pred) ** 2)


# Let's visualise our predicted values in comparison to the original values
plt.scatter(X1_test, y_test, color='green')
plt.scatter(X1_test, y_pred, color='red')
plt.title('Unemployment vs Government Expenditure (Test set): ' + "\n" +
          'Mean Squared Error = ' + str(round(mseTest, 2)))
plt.xlabel('Government expenditure (%)')
plt.ylabel('Unemployment (%)')
plt.show()

# Our MSE is 43. What we want is a balance between overfit
# (very low MSE for training data)
# and underfit (very high MSE for test/validation/unseen data).
#
# In our data, we found a linear relationship which showed that Linear regression
# was a good approach. But we also need to compare with other methods to see if
# this really perfoms the best.

# An advantage of R over Python perhaps is also the visualization with ggplot2,
# shiny etc.

