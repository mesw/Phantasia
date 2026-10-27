import urllib.request
import os

sources_dir = os.path.join(os.getcwd(), "sources")
os.makedirs(sources_dir, exist_ok=True)

test_urls = [
    ("Gallagher_BBC_2015.html", "https://www.bbc.com/news/health-34039054"),
    ("Costandi_Guardian_2016.html", "https://www.theguardian.com/education/2016/jun/04/aphantasia-no-visual-imagination-impact-learning"),
    ("Galton_1880_Statistics.html", "https://psychclassics.yorku.ca/Galton/imagery.htm")
]

headers = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
}

for fname, url in test_urls:
    dest = os.path.join(sources_dir, fname)
    req = urllib.request.Request(url, headers=headers)
    try:
        with urllib.request.urlopen(req, timeout=15) as resp:
            content = resp.read()
            with open(dest, 'wb') as f:
                f.write(content)
            print(f"Downloaded {fname} ({len(content)} bytes)")
    except Exception as e:
        print(f"Failed {fname}: {e}")
