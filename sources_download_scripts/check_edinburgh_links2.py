from bs4 import BeautifulSoup

with open('sources/edinburgh_our_research.html', 'r', encoding='utf-8', errors='ignore') as f:
    soup = BeautifulSoup(f.read(), 'html.parser')

with open('edinburgh_links.txt', 'w', encoding='utf-8') as out:
    for a in soup.find_all('a', href=True):
        href = a['href']
        out.write(f"{a.text.strip()} --> {href}\n")

print("Saved all edinburgh links to edinburgh_links.txt")
