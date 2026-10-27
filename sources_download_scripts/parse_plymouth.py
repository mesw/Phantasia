from bs4 import BeautifulSoup

with open('sources/plymouth_rhodes.html', 'r', encoding='utf-8', errors='ignore') as f:
    soup = BeautifulSoup(f.read(), 'html.parser')

for a in soup.find_all('a', href=True):
    href = a['href']
    if any(k in href.lower() for k in ['pdf', 'bitstream', 'download', 'handle', 'item']):
        print(a.text.strip(), '-->', href)
