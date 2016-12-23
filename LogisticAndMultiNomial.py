import numpy as np
import pandas as pd
from sklearn.naive_bayes import MultinomialNB
from sklearn.linear_model import LogisticRegression
from sklearn.cross_validation import cross_val_score

#load and randomise data
dataset = pd.read_csv('HeroAndGoldMatrix.csv', index_col = 0)
dataset = dataset.take(np.random.permutation(len(dataset)))

#split dependent/independent variables
x = dataset.drop('radiant_win', axis=1)
y = dataset['radiant_win']

#print results
print 'Logistic Regression accuracy:', np.mean(cross_val_score(LogisticRegression(), x, y, scoring='accuracy', cv = 5))
print 'MultinominalNB accuracy:', np.mean(cross_val_score(MultinomialNB(), x, y, scoring='accuracy', cv = 5))
