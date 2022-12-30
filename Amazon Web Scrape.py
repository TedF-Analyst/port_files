#!/usr/bin/env python
# coding: utf-8

# In[4]:


# Import Libraries

from bs4 import BeautifulSoup
import requests
import smtplib
import time
import datetime


# In[61]:


# Connect to Website
# Since Amazon does not like to be scraped, you have to run this a few times for it to work.

URL = 'https://www.amazon.com/Funny-Data-Systems-Business-Analyst/dp/B07FNW9FGJ/ref=sr_1_12?keywords=data+analyst+tshirt&qid=1669249483&sprefix=data+analyst+t%2Caps%2C99&sr=8-12'
    
headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:107.0) Gecko/20100101 Firefox/107.0"}

page = requests.get(URL, headers=headers)

soup1 = BeautifulSoup(page.content, "html.parser")

soup2 = BeautifulSoup(soup1.prettify(), 'html.parser')

title = soup2.find(id="productTitle").get_text()

price = soup2.find('span', {'class':'a-offscreen'}).get_text()

print(title)
print(price)


# In[86]:


# Removes $ from price so its cleaner to go into a CSV

price = price.strip()[1:]
title = title.strip()

print(title)
print(price)


# In[89]:


# Create CSV file

import csv

header = ['title', 'price']
data = [title,price]

with open('AmazonScrape.csv', 'w', newline='', encoding='UTF8') as f:
    writer = csv.writer(f)
    writer.writerow(header)
    writer.writerow(data)


# In[91]:


import pandas as pd

df = pd.read_csv(r'C:\Users\milwt\AmazonScrape.csv')

print(df)


# In[ ]:


# Append to CSV

with open('AmazonScrape.csv', 'a+', newline='', encoding='UTF8') as f:
    writer = csv.writer(f)
    writer.writerow(data)


# In[93]:


# Check the Amazon page once an hour, and append to the CSV file

def check_price():

    URL = 'https://www.amazon.com/Funny-Data-Systems-Business-Analyst/dp/B07FNW9FGJ/ref=sr_1_12?keywords=data+analyst+tshirt&qid=1669249483&sprefix=data+analyst+t%2Caps%2C99&sr=8-12'
    
    headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:107.0) Gecko/20100101 Firefox/107.0"}

    page = requests.get(URL, headers=headers)

    soup1 = BeautifulSoup(page.content, "html.parser")

    soup2 = BeautifulSoup(soup1.prettify(), 'html.parser')

    title = soup2.find(id="productTitle").get_text()

    price = soup2.find('span', {'class':'a-offscreen'}).get_text()

    price = price.strip()[1:]
    title = title.strip()
    
    import datetime

    today = datetime.date.today()
    
    import csv
    
    header = ['Title', 'Price', 'Date']
    data = [title, price, date]

    with open('AmazonScrape.csv', 'a+', newline='', encoding='UTF8') as f:
        writer = csv.writer(f)
        writer.writerow(data)


# In[ ]:


while(True):
    check_price()
    time.sleep(3600)

