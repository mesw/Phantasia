import json
import re

with open('extracted_raw_sources.json', 'r', encoding='utf-8') as f:
    sources = json.load(f)

parsed_sources = []

for key, raw in sources.items():
    item = {
        "id": key,
        "raw": raw,
        "title": None,
        "authors": None,
        "year": None,
        "doi": None,
        "url": None,
        "archive_url": None,
        "isbn": None,
        "pmid": None,
        "type": "other"
    }
    
    # DOI
    doi_m = re.search(r'doi(?:\s*=\s*|\s*:\s*|\.org/|\]:\s*)(10\.\d{4,9}/[-._;()/:A-Za-z0-9]+)', raw, re.IGNORECASE)
    if doi_m:
        doi = doi_m.group(1).rstrip('.,;)]\'"')
        item['doi'] = doi

    # PMID
    pmid_m = re.search(r'pmid(?:\s*=\s*|\s*:\s*|\]\s*)(\d+)', raw, re.IGNORECASE)
    if pmid_m:
        item['pmid'] = pmid_m.group(1)

    # ISBN
    isbn_m = re.search(r'isbn(?:\s*=\s*|\s*:\s*)([0-9X-]{10,17})', raw, re.IGNORECASE)
    if isbn_m:
        item['isbn'] = isbn_m.group(1)

    # Archive URL
    arch_m = re.search(r'archiv-url\s*=\s*([^\s|}]+)', raw, re.IGNORECASE)
    if not arch_m:
        arch_m = re.search(r'archive-url\s*=\s*([^\s|}]+)', raw, re.IGNORECASE)
    if arch_m:
        item['archive_url'] = arch_m.group(1)

    # URL
    url_m = re.search(r'(?:url|Online)\s*=\s*\[?([^\s\]|}]+)', raw)
    if not url_m:
        url_m = re.search(r'https?://[^\s\]<|"\']+', raw)
    if url_m:
        try:
            u = url_m.group(1)
        except (IndexError, AttributeError):
            u = url_m.group(0)
        item['url'] = u.rstrip('.,;)]\'"')

    # Title
    title_m = re.search(r'(?:titel|title)\s*=\s*([^|}]+)', raw, re.IGNORECASE)
    if title_m:
        item['title'] = title_m.group(1).strip()
    else:
        # Check quoted title or markdown link title
        qtitle_m = re.search(r'\"([^\"]+)\"', raw)
        if qtitle_m:
            item['title'] = qtitle_m.group(1).strip()
        else:
            ltitle_m = re.search(r'\[https?://[^\s]+ ([^\]]+)\]', raw)
            if ltitle_m:
                item['title'] = ltitle_m.group(1).strip()

    # Author
    author_m = re.search(r'(?:autor|author|first=.*?last=.*?)\s*=\s*([^|}]+)', raw, re.IGNORECASE)
    if author_m:
        item['authors'] = author_m.group(1).strip()
    
    parsed_sources.append(item)

print(f"Parsed {len(parsed_sources)} items")
with open('parsed_sources.json', 'w', encoding='utf-8') as f:
    json.dump(parsed_sources, f, indent=2, ensure_ascii=False)

for p in parsed_sources:
    print(f"[{p['id']}]")
    print(f"  Title: {p['title']}")
    print(f"  DOI:   {p['doi']}")
    print(f"  URL:   {p['url']}")
    print(f"  Arch:  {p['archive_url']}")
    print(f"  ISBN:  {p['isbn']}")
