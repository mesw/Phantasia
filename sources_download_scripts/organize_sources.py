import json
import re

with open('extracted_raw_sources.json', 'r', encoding='utf-8') as f:
    raw_sources = json.load(f)

sources = []

for key, raw in raw_sources.items():
    # Detect DOI - broader regex
    doi = None
    doi_m = re.search(r'(?:doi(?:\s*=\s*|\s*:\s*|\.org/|\]\s*:\s*|\]\s*=\s*)|(?:10\.\d{4,9}/))([^\s|}<>\"]+)', raw, re.IGNORECASE)
    if doi_m:
        raw_doi = doi_m.group(1) if not doi_m.group(0).startswith('10.') else doi_m.group(0)
        # cleanup
        doi_clean = re.search(r'10\.\d{4,9}/[-._;()/:A-Za-z0-9]+', raw_doi)
        if doi_clean:
            doi = doi_clean.group(0).rstrip('.,;)]\'"')
    
    # Detect PMID
    pmid = None
    pmid_m = re.search(r'(?:pmid(?:\s*=\s*|\s*:\s*|\]\s*:\s*|\]\s*)|PMID\s+)(\d+)', raw, re.IGNORECASE)
    if pmid_m:
        pmid = pmid_m.group(1)

    # Detect ISBN
    isbn = None
    isbn_m = re.search(r'isbn(?:\s*=\s*|\s*:\s*)([0-9X-]{10,17})', raw, re.IGNORECASE)
    if isbn_m:
        isbn = isbn_m.group(1).replace('-', '')

    # Detect Archive URL
    archive_url = None
    arch_m = re.search(r'archiv(?:e)?-url\s*=\s*([^\s|}]+)', raw, re.IGNORECASE)
    if arch_m:
        archive_url = arch_m.group(1)

    # Detect primary URL
    url = None
    url_m = re.search(r'(?:url|Online)\s*=\s*\[?([^\s\]|}]+)', raw)
    if not url_m:
        url_m = re.search(r'https?://[^\s\]<|"\']+', raw)
    if url_m:
        try:
            url = url_m.group(1)
        except (IndexError, AttributeError):
            url = url_m.group(0)
        url = url.rstrip('.,;)]\'"')

    # Detect Title
    title = None
    title_m = re.search(r'(?:titel|title)\s*=\s*([^|}]+)', raw, re.IGNORECASE)
    if title_m:
        title = title_m.group(1).strip()
    else:
        qtitle_m = re.search(r'\"([^\"]+)\"', raw)
        if qtitle_m:
            title = qtitle_m.group(1).strip()
        else:
            ltitle_m = re.search(r'\[https?://[^\s]+ ([^\]]+)\]', raw)
            if ltitle_m:
                title = ltitle_m.group(1).strip()
            else:
                it_title_m = re.search(r"''([^'']+)''", raw)
                if it_title_m:
                    title = it_title_m.group(1).strip()

    # Detect Authors
    authors = None
    author_m = re.search(r'(?:autor|author)\s*=\s*([^|}]+)', raw, re.IGNORECASE)
    if author_m:
        authors = author_m.group(1).strip()
    else:
        firsts = re.findall(r'first\d*\s*=\s*([^|}]+)', raw)
        lasts = re.findall(r'last\d*\s*=\s*([^|}]+)', raw)
        if lasts:
            names = [f"{f.strip()} {l.strip()}" for f, l in zip(firsts, lasts)]
            authors = ", ".join(names)
        else:
            lead_m = re.match(r'^\*?\s*([A-Za-z.,\s-]+?)\s*(?:\(\d{4}\)|:|\.|\")', raw)
            if lead_m:
                authors = lead_m.group(1).strip()

    sources.append({
        "key": key,
        "title": title,
        "authors": authors,
        "doi": doi,
        "pmid": pmid,
        "isbn": isbn,
        "url": url,
        "archive_url": archive_url,
        "raw": raw
    })

# Deduplicate
unique_sources = []
seen_dois = set()
seen_urls = set()
seen_titles = set()

for s in sources:
    if s['doi']:
        d_lower = s['doi'].lower()
        if d_lower in seen_dois:
            continue
        seen_dois.add(d_lower)
    elif s['url']:
        u_lower = s['url'].lower()
        if u_lower in seen_urls:
            continue
        seen_urls.add(u_lower)
    elif s['title']:
        t_lower = s['title'].lower()
        if t_lower in seen_titles:
            continue
        seen_titles.add(t_lower)

    unique_sources.append(s)

print(f"Total unique sources: {len(unique_sources)}")

with open('clean_unique_sources.json', 'w', encoding='utf-8') as f:
    json.dump(unique_sources, f, indent=2, ensure_ascii=False)
