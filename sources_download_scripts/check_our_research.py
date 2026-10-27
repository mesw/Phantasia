from bs4 import BeautifulSoup

with open('sources/edinburgh_our_research.html', 'r', encoding='utf-8', errors='ignore') as f:
    soup = BeautifulSoup(f.read(), 'html.parser')

for a in soup.find_all('a', href=True):
    href = a['href']
    if any(k in href.lower() for k in ['pdf', 'doi.org', 'cortex', 'sciencedirect', 'cell', 'zeman']):
        print(a.text.strip(), '-->', href)
