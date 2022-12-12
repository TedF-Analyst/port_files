#!/usr/bin/env python
# coding: utf-8

# In[2]:


# Import Libraries

import pandas as pd
import seaborn as sns
import numpy as np

import matplotlib
import matplotlib.pyplot as plt
plt.style.use('ggplot')
from matplotlib.pyplot import figure

get_ipython().run_line_magic('matplotlib', 'inline')
matplotlib.rcParams['figure.figsize'] = (12,8) # Adjusts the configuration of the plots we will create


# Read in the data

df = pd.read_csv(r'C:\Users\milwt\OneDrive\Portfolio Files\Python Project 1\movies.csv')


# In[2]:


# Lets look at the data
df.head()


# In[4]:


# Looking for missing data

for col in df.columns:
    pct_missing = np.mean(df[col].isnull())
    print('{} - {}%'.format(col, pct_missing))


# In[5]:


# Look at data types for the columns

df.dtypes


# In[7]:


# Fix year column, has incorrect values

df['yearcorrect'] = df['released'].str.extract(pat = '([0-9]{4})').astype(int)

df


# In[8]:


df.sort_values(by=['gross'], inplace=False, ascending=False)


# In[3]:


pd.set_option('display.max_rows', None)


# In[ ]:


# Drop any duplicates

df['company']


# In[ ]:


# Budget high correlation
# company high correlation


# In[4]:


# Scatter plot with budget vs gross revenue

plt.scatter(x=df['budget'], y=df['gross'])

plt.title('Budget vs Gross Revenue')

plt.xlabel('Gross Earnings')
plt.ylabel('Budget of Film')
plt.show()


# In[6]:


# Plot budget vs gross using seaborn

sns.regplot(x='budget', y='gross', data=df, scatter_kws={"color": "red"}, line_kws={"color" : "blue"})


# In[7]:


# Looking at correlation
df.corr()


# In[12]:


correlation_matrix = df.corr(method='pearson')

sns.heatmap(correlation_matrix, annot=True)

plt.title('Correlation Matrix for Numeric Features')

plt.xlabel('Movie Features')

plt.ylabel('Moviw Features')

plt.show()


# In[17]:


df_numericalized = df

for col_name in df_numericalized.columns:
    if(df_numericalized[col_name].dtype == 'object'):
        df_numericalized[col_name] = df_numericalized[col_name].astype('category')
        df_numericalized[col_name] = df_numericalized[col_name].cat.codes
        
df_numericalized


# In[18]:


correlation_matrix = df_numericalized.corr(method='pearson')

sns.heatmap(correlation_matrix, annot=True)

plt.title('Correlation Matrix for Numeric Features')

plt.xlabel('Movie Features')

plt.ylabel('Moviw Features')

plt.show()


# In[19]:


correlation_mat = df_numericalized.corr()

corr_pairs = correlation_mat.unstack()

corr_pairs


# In[21]:


sorted_pairs = corr_pairs.sort_values()

sorted_pairs


# In[23]:


high_corr = sorted_pairs[(sorted_pairs) > 0.5]

high_corr


# In[ ]:




