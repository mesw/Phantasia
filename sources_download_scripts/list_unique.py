import json

with open('unique_sources.json', 'r', encoding='utf-8') as f:
    sources = json.load(f)

for i, s in enumerate(sources, 1):
    print(f"[{i:02d}] {s['key']}")
    print(f"     Title:   {s['title']}")
    print(f"     Authors: {s['authors']}")
    print(f"     DOI:     {s['doi']}")
    print(f"     URL:     {s['url']}")
    print(f"     Arch:    {s['archive_url']}")
    print(f"     ISBN:    {s['isbn']}")
