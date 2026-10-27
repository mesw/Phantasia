from bs4 import BeautifulSoup
import re

with open('sources/edinburgh_eyes_mind.html', 'r', encoding='utf-8', errors='ignore') as f:
    soup = BeautifulSoup(f.read(), 'html.parser')

for a in soup.find_all('a', href=True):
    href = a['href']
    if any(k in href.lower() for k in ['pdf', 'publication', 'paper', 'article', 'update', 'ross', 'zeman', 'cortex']):
        print(a.text.strip(), '-->', href)
