import pandas as pd
from sklearn import preprocessing
from sklearn.model_selection import train_test_split
import pickle

class Data():
    def __init__(self):
        self.data, self.encoders  = self.load_csv()

    def convert(self,x):
        le = preprocessing.LabelEncoder()
        le.fit(x)
        x_convert = le.transform(x)
        return x_convert, le

    def load_csv(self):
        data = pd.read_csv('kickstarter_filtered.tsv', sep='\t')
        data['main_cat_cat'] = data['main_category'].str.cat(data['category'], sep=">")
        data['state'] = data['state'].replace('canceled', 'failed')
        data = data[['main_cat_cat', 'country', 'duration',
                     'currency', 'goal_in_usd', 'pledged_in_usd',
                     'percentage_of_money_collected', 'backers', 'state']]

        encoders={}
        for element in ['main_cat_cat', 'country', 'currency', 'state']:
            tmp, tmp_encoder = self.convert(data[element])
            data[element]=tmp
            encoders[element]=tmp_encoder

        return data, encoders

    def dev_data(self, y_name, test_percent=0.1, random_state=42):
        y = self.data[y_name]
        tmp=self.data
        tmp.pop(y_name)
        x = tmp
        x_train, x_test, y_train, y_test = train_test_split(x, y, test_size=test_percent, random_state=random_state)
        dev_df_created = pd.concat([x_test, y_test], axis=1)
        rest_df_created = pd.concat([x_train, y_train], axis=1)
        full_df_created = pd.concat([dev_df_created, rest_df_created], axis=0)
        return dev_df_created, rest_df_created, full_df_created

    def save_encoders(self):
        with open('encoders.pickle', 'wb') as handle:
            pickle.dump(self.encoders, handle, protocol=pickle.HIGHEST_PROTOCOL)

    def show_encoders(self):
        with open('encoders.pickle', 'rb') as handle:
            cos = pickle.load(handle)
        return cos