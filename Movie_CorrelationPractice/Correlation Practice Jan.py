#!/usr/bin/env python
# coding: utf-8

# In[2]:


#Import Libraries
import pandas as pd
import numpy as np
import seaborn as sns

import matplotlib.pyplot as plt
import matplotlib.mlab as mlab
import matplotlib
plt.style.use('ggplot')
from matplotlib.pyplot import figure

get_ipython().run_line_magic('matplotlib', 'inline')
matplotlib.rcParams['figure.figsize'] = (12,8)

pd.options.mode.chained_assignment = None

#Reard in the data

df = pd.read_csv(r'C:\Users\casil\OneDrive\Documents\Portafolio Project\movies.csv')


# In[3]:


#Look the data
df.head()


# In[4]:


# Missing Data for loop
df = df.dropna()
for col in df.columns:
    pct_missing=np.mean(df[col].isnull())
    print('{}-{}%'.format(col,pct_missing))


# In[5]:


#Data types for our columns
df.dtypes


# In[14]:


#Change data type
df['budget'].round().astype('Int64')
df['budget']=df['budget'].astype('Int64')
df['gross'].round().astype('Int64')
df['gross']=df['gross'].astype('Int64')


# In[15]:


#Create Correct Year column
#df['yearcorrect']=df['released'].astype(str).str[9:13]
#print(df['released'].astype(str))
str1= df['released'].str.split(',',expand=True)[1]
#print(str1)
str2 = str1.str.split(' ',expand=True)[1]
df['yearcorrect'] = str2
df


# In[16]:


#sort values
df=df.sort_values(by=['gross'],inplace=False,ascending=False)


# In[17]:


#to display all the information
pd.set_option('display.max_rows',None)


# In[18]:


#Search for duplicates and drop
df['company'].drop_duplicates().sort_values(ascending=False)


# In[19]:


#Correlation Analysis
#Scatter plot with budget vs gross
plt.scatter(x=df['budget'],y=df['gross'])
plt.title('Budget vs Gross Earnings')
plt.xlabel('Budget for Film')
plt.ylabel('Gross Earnings')
plt.show


# In[20]:


df.head()


# In[31]:


#Plot budget Vs Gross Using seaborn
#Data types for our columns
#df.dtypes
df['budget']=df['budget'].astype('float')
df['gross']=df['gross'].astype('float')
#Change data type
sns.regplot(x='budget', y='gross',data=df, scatter_kws={"color":"red"},line_kws={"color":"blue"})


# In[37]:


#Correlation analyis
correlation_matrix=df.corr(numeric_only=True) 


# In[41]:


#High correlation between budget and gross
#Correlation matrix
#correlation_matrix=df.corr(numeric_only=True) 
sns.heatmap(correlation_matrix,annot=True)
plt.title('Correlation Matrix for Numeric Features')
plt.xlabel('Movie Features')
plt.ylabel('Movie Features')
plt.show()


# In[44]:


#Creating numeric representation for non numeric values
df_numerized=df
for col_name in df_numerized.columns:
    if(df_numerized[col_name].dtype=='object'):
        df_numerized[col_name]=df_numerized[col_name].astype('category')
        df_numerized[col_name]=df_numerized[col_name].cat.codes
        
df_numerized


# In[45]:


correlation_matrix2=df_numerized.corr(numeric_only=True) 
sns.heatmap(correlation_matrix2,annot=True)
plt.title('Correlation Matrix for Numeric Features')
plt.xlabel('Movie Features')
plt.ylabel('Movie Features')
plt.show()


# In[51]:


#To review the highest correlation
corr_pairs=correlation_matrix2.unstack()
corr_pairs


# In[52]:


#sorting corr values
sorted_pairs=corr_pairs.sort_values()
sorted_pairs


# In[54]:


#To find values >0.5
high_corr= sorted_pairs[(sorted_pairs)>0.5]
high_corr


# In[ ]:




