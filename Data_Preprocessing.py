import pandas as pd
#import numpy as np
from imblearn.over_sampling import SMOTE
#Load the dataset 
df=pd.read_excel('E:\DAI\Digital Marketing Dataset\Digital Marketing Dataset(AutoRecovered).xlsx',sheet_name="Data1")
print(df.info())

#Step2:Typecasting
df['Date']=pd.to_datetime(df['Date'])

#Removes '$' sign and convert currency-related columns to float
remove_dollar_cols=['Unit Cost Price','Unit Sale Price','Final Cost Price','Final Sale Price']
df[remove_dollar_cols]=df[remove_dollar_cols].replace('[\$]','',regex=True).astype(float)

#Convert Percentage columns to proper float values
df['Target_Achieved (%)']=df['Target_Achieved (%)'].replace('%','').astype(float)

#Step3:Hnadle Duplicates
print("Duplicate Rows: ", df.duplicated().sum())

df=df.drop_duplicates()

# Check Data Balance (Random Sampling or SMOTE)
#from imblearn.over_sampling import SMOTE

#check balance 
print(df['Platform'].value_counts())
#print(df['Conversions'].value.counts())

# Apply SMOTE only for classification tasks (e.g., conversions)
smote=SMOTE()
x,y=df.drop('Conversions',axis=1),df['Conversions']
x_resampled, y_resampled = smote.fit_resample(x, y)
df_resampled = pd.concat([pd.DataFrame(x_resampled), pd.DataFrame(y_resampled, columns=['Conversions'])], axis=1)

