import pandas as pd
import numpy as np
import os

import projekt_ml.data as datadef

# initializing boject of Data class and loading the whole data set

df = datadef.Data()

# creating dev_df for analysis/exploration purposes

dev_df, rest_df, full_df = df.dev_data('pledged_in_usd', random_state=41)

# exporting to files
# dev_df for analysis, rest_df to compare the similarity between
# the sample and the rest of data set, encoders for later
# to be able to translate tables into human language
# and the whole data set to be used by the model at the end

dev_df.to_csv(r'dev_df.csv', index = False)
rest_df.to_csv(r'rest_df.csv', index = False)
df.save_encoders()
full_df.to_csv(r'full_df.csv')