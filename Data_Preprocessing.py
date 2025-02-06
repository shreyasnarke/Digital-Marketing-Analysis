import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
#from imblearn.over_sampling import SMOTE
#from sklearn.feature_selection import VarianceThreshold
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
#smote=SMOTE()
#x,y=df.drop('Conversions',axis=1),df['Conversions']
#x_resampled, y_resampled = smote.fit_resample(x, y)
#df_resampled = pd.concat([pd.DataFrame(x_resampled), pd.DataFrame(y_resampled, columns=['Conversions'])], axis=1)

#Handle Missing Values (Imputation)
print(df.isnull().sum())
# Fill missing numerical values with median
df.fillna(df.mode().iloc[0],inplace=True)
 
#>>outlier detection
Q1=df['Profit'].quantile(0.25)
Q3=df['Profit'].quantile(0.75)
IQR=Q3-Q1

lower_bound=Q1-1.5*IQR
upper_bound=Q3+1.5*IQR
print(f'IQR ={IQR} ,\nlower_bound={lower_bound},\nupper_bound={upper_bound}')
#Remove Outliers
df_cleaned = df[~((df['Profit'] < lower_bound) | (df['Profit'] > upper_bound))]

#Winsorization to detect and handle outliers using the IQR (Interquartile Range) method.
from feature_engine.outliers import Winsorizer
#Define the model with IQR method
winsor_iqr=Winsorizer(capping_method='iqr',tail='both',fold=1.5,variables=['Revenue'])
df_s = winsor_iqr.fit_transform(df[['Revenue']])
# Inspect the minimum caps and maximum caps
# winsor.left_tail_caps_, winsor.right_tail_caps_

sns.boxplot(df_s.Revenue)
plt.show()

winsor_gaussian=Winsorizer(capping_method='gaussian',tail='both',fold=3,variables=['Final Cost Price'])
df_winsor=winsor_gaussian.fit_transform(df)
sns.boxplot(y=df_winsor['Final Cost Price'])
plt.show()