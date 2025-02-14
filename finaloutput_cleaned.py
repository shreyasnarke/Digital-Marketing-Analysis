import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
# Load dataset
df = pd.read_csv("E:\DAI\Digital Marketing Dataset\FinalOutput.csv")  # Replace with your file path

#Rename a Column
df.rename(columns={"Column1": "Date"}, inplace=True)
#Typecasting
df['Date']=pd.to_datetime(df['Date'])

#Hnadle Duplicates
print("Duplicate Rows: ", df.duplicated().sum())
df=df.drop_duplicates()

# Check Data Balance 
print(df['Platform'].value_counts())
#print(df['Conversions'].value.counts())

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
winsor_iqr=Winsorizer(capping_method='iqr',tail='both',fold=1.5,variables=['Final Sale Price(Revenue)'])
df_s = winsor_iqr.fit_transform(df[['Final Sale Price(Revenue)']])
# Inspect the minimum caps and maximum caps
# winsor.left_tail_caps_, winsor.right_tail_caps_

sns.boxplot(x=df_s["Final Sale Price(Revenue)"])
plt.show()

winsor_gaussian=Winsorizer(capping_method='gaussian',tail='both',fold=3,variables=['Final Cost Price'])
df_winsor=winsor_gaussian.fit_transform(df)
sns.boxplot(y=df_winsor['Final Cost Price'])
plt.show()

#Update "Ad Campaign" Names
campaign_mapping = {
    "Campaign 1": "Black Friday Sale",
    "Campaign 2": "Spring Collection Launch",
    "Campaign 3": "New App Promotion"
}
df["Ad Campaign"] = df["Ad Campaign"].replace(campaign_mapping)

#Update "Platform" Names
platform_mapping = {
    "Platform A": "Google Ads",
    "Platform B": "Facebook Ads",
    "Platform C": "YouTube Ads",
    "Platform D": "Instagram Ads"
}
df["Platform"] = df["Platform"].replace(platform_mapping)

#Discretization (Binning "Target_Achieved (%)")
def categorize_target(value):
    value = float(str(value).replace('%', ''))  # Remove '%' and convert to float
    if value < 10:
        return "Low"
    elif 11 <= value <= 22:
        return "Medium"
    else:
        return "High"

df["target_category"] = df["Target_Achieved (%)"].apply(categorize_target)

#Save cleaned data
df.to_csv("finaloutput_cleaned.csv", index=False)

#Display the first few rows
print(df.head())
