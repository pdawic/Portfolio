import pandas as pd
import numpy as np
from sklearn.tree import DecisionTreeClassifier, DecisionTreeRegressor
from sklearn.ensemble import RandomForestClassifier, RandomForestRegressor
from sklearn.neighbors import KNeighborsClassifier, RadiusNeighborsClassifier, KNeighborsRegressor, RadiusNeighborsRegressor
from sklearn.model_selection import train_test_split, cross_val_score
from sklearn.metrics import accuracy_score
from sklearn.preprocessing import MinMaxScaler
from sklearn.model_selection import GridSearchCV
from sklearn import svm
from sklearn.naive_bayes import GaussianNB
from sklearn.datasets import load_iris


data = pd.read_csv('kickstarter_filtered.tsv', sep='\t', nrows=100)
data = data[['main_category', 'category', 'country', 'duration',
                     'currency', 'goal_in_usd', 'pledged_in_usd',
                     'percentage_of_money_collected', 'backers', 'state']]

data['main_category']=data['main_category'].factorize()[0]
data['category']=data['category'].factorize()[0]
data['country']=data['country'].factorize()[0]
data['currency']=data['currency'].factorize()[0]
data['state']=data['state'].factorize()[0]

def best_params(model, params, cv, x_train, y_train):
    grid = GridSearchCV(model, params, cv=cv)
    grid.fit(x_train, y_train)
    best_options = grid.best_params_
    return best_options


def prediction(model, x_train, y_train, x_test, y_test, cv):
    model.fit(x_train, y_train)
    score_val = np.mean(cross_val_score(model, x_train, y_train, cv=cv))
    y_pred = model.predict(x_test)
    score_acc = accuracy_score(y_test, y_pred)
    score = model.score(x_train, y_train)
    return score_val, score_acc, score

def prediction_reg(model, x_train, y_train, x_test, y_test, cv):
    model.fit(x_train, y_train)
    score_val = np.mean(cross_val_score(model, x_train, y_train, cv=cv))
    y_pred = model.predict(x_test)
    score_acc = None
    score = model.score(x_train, y_train)
    return score_val, score_acc, score


def normalize_data(x_train, x_test):
    scaler = MinMaxScaler()
    scaler.fit(x_train)
    x_train_norm = scaler.transform(x_train)
    x_test_norm = scaler.transform(x_test)
    return x_train_norm, x_test_norm


# iris = load_iris()
# x = iris['data']
# y = iris['target']

x = data.drop(columns=['state'], axis=1)
y = data['state']

# podział próbek
x_train, x_test, y_train, y_test = train_test_split(x, y, test_size=0.2)
x_train_norm, x_test_norm = normalize_data(x_train, x_test)



# DecisionTreeClassifier
dtc = DecisionTreeClassifier()
dtc_params = {"criterion": ["gini", "entropy"],
              "splitter": ["best", "random"]}
dtc_best_params = best_params(dtc, dtc_params, 3, x_train, y_train)
dtc_best = DecisionTreeClassifier(**dtc_best_params)
dtc_result = prediction(dtc_best, x_train, y_train, x_test, y_test, cv=3)

# DecisionTreeRegressor
dtr = DecisionTreeRegressor()
dtr_params = {"criterion": ["mse", "friedman_mse", "mae"],
              "splitter": ["best", "random"]}
dtr_best_params = best_params(dtr, dtr_params, 3, x_train, y_train)
dtr_best = DecisionTreeRegressor(**dtr_best_params)
dtr_result = prediction_reg(dtr_best, x_train, y_train, x_test, y_test, cv=3)




# KNeighborsClassifier
knc = KNeighborsClassifier()
knc_params = {'weights': ["uniform", "distance"],
              'p': [1, 2],
              'n_neighbors': np.arange(1, 40)}
knc_best_params = best_params(knc, knc_params, 3, x_train_norm, y_train)
knc_best = KNeighborsClassifier(**knc_best_params)
knc_result = prediction(knc_best, x_train_norm, y_train, x_test_norm, y_test, cv=3)

# # RadiusNeighborsClassifier
# rnc = RadiusNeighborsClassifier()
# rnc_params = {}
# rnc_best_params = best_params(rnc, rnc_params, 3, x_train_norm, y_train)
# rnc_best = RadiusNeighborsClassifier(**rnc_best_params)
# rnc_result = prediction(rnc_best, x_train_norm, y_train, x_test_norm, y_test, cv=3)

# KNeighborsRegressor
knr = KNeighborsRegressor()
knr_params = {'weights': ["uniform", "distance"],
              'p': [1, 2],
              'n_neighbors': np.arange(1, 40)}
knc_best_params = best_params(knr, knr_params, 3, x_train_norm, y_train)
knr_best = KNeighborsClassifier(**knc_best_params)
knr_result = prediction(knr_best, x_train_norm, y_train, x_test_norm, y_test, cv=3)

# RadiusNeighborsRegressor
rnr = RadiusNeighborsRegressor()
rnr_params = {}
rnr_best_params = best_params(rnr, rnr_params, 3, x_train_norm, y_train)
rnr_best = RadiusNeighborsRegressor(**rnr_best_params)
rnr_result = prediction_reg(rnr_best, x_train_norm, y_train, x_test_norm, y_test, cv=3)



# RandomForestClassifier
rfc = RandomForestClassifier()
rfc_params = {"n_estimators": np.arange(10, 15, 1),
              "min_samples_split": np.arange(2, 5, 1),
              "min_samples_leaf": np.arange(1, 5, 1),
              "criterion": ["gini", "entropy"]}
rfc_best_params = best_params(rfc, rfc_params, 3, x_train, y_train)
rfc_best = RandomForestClassifier(**rfc_best_params)
rfc_result = prediction(rfc_best, x_train, y_train, x_test, y_test, cv=3)

# RandomForestRegressor
rfr = RandomForestRegressor()
rfr_params = {"n_estimators": np.arange(10, 15, 1),
              "min_samples_split": np.arange(2, 5, 1),
              "min_samples_leaf": np.arange(1, 5, 1),
              "criterion": ["mse", "mae"]}
rfr_best_params = best_params(rfr, rfr_params, 3, x_train, y_train)
rfr_best = RandomForestRegressor(**rfr_best_params)
rfr_result = prediction_reg(rfr_best, x_train, y_train, x_test, y_test, cv=3)



# SVM
svm_model = svm.SVC()
svm_params = {'kernel': ['linear'],
              'gamma': ['scale','auto']}
svm_best_params = best_params(svm_model, svm_params, 2, x_train, y_train)
svm_best = svm.SVC(**svm_best_params)
svm_result = prediction(svm_best, x_train, y_train, x_test, y_test, cv=3)



# Bayes
bayes_model = GaussianNB()
bayes_params = {'priors': None
                #'var_smoothing': [1e-9]
                }
bayes_best_params = best_params(bayes_model, bayes_params, 2, x_train, y_train)
bayes_best = svm.SVC(**bayes_best_params)
bayes_result = prediction(bayes_best, x_train, y_train, x_test, y_test, cv=3)




all_results = [['DecisionTreeClassifier', *dtc_result],
               ['DecisionTreeRegressor', *dtr_result],
               ['KNeighborsClassifier', *knc_result],
               #['RadiusNeighborsClassifier', *rnc_result],
               ['KNeighborsRegressor',*knr_result],
               ['RadiusNeighborsRegressor',*rnr_result],
               ['RandomForestClassifier', *rfc_result],
               ['RandomForestRegressor', *rfr_result],
               ['SVM', *svm_result],
               ['Byess', *bayes_result]
               ]


result_df = pd.DataFrame(all_results, columns=["model", "mean_val_score", "accuracy_score", "score"])
print(result_df)
