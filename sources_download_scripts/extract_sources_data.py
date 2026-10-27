import re
import json

with open('wiki.txt', 'r', encoding='utf-8') as f:
    text = f.read()

# Pattern for refs
pattern = re.compile(r'<ref\b([^>/]*?)(?:>(.*?)</ref>|/>)', re.DOTALL)
matches = pattern.findall(text)

raw_sources = {}
named_refs = {}

for idx, (attr, body) in enumerate(matches, 1):
    attr = attr.strip()
    body = body.strip()
    name_m = re.search(r'name=["\']?([^"\'/]+)["\']?', attr)
    name = name_m.group(1).strip() if name_m else None
    
    if body:
        if name:
            named_refs[name] = body
            raw_sources[f"ref_{name}"] = body
        else:
            raw_sources[f"ref_anon_{idx}"] = body
    else:
        # Self-closing
        if name and f"ref_{name}" not in raw_sources:
            raw_sources[f"ref_{name}"] = named_refs.get(name, "")

# Add == Literatur ==
lit_match = re.search(r'==\s*Literatur\s*==\s*(.*?)\s*==', text, re.DOTALL)
if lit_match:
    for line in lit_match.group(1).strip().split('\n'):
        line = line.strip()
        if line.startswith('*'):
            raw_sources['lit_bartolomeo'] = line

# Add == Weblinks ==
weblinks_match = re.search(r'==\s*Weblinks\s*==\s*(.*?)\s*==', text, re.DOTALL)
if weblinks_match:
    for idx, line in enumerate(weblinks_match.group(1).strip().split('\n'), 1):
        line = line.strip()
        if line.startswith('*'):
            raw_sources[f'weblink_{idx}'] = line

print(f"Total extracted raw sources: {len(raw_sources)}")

with open('extracted_raw_sources.json', 'w', encoding='utf-8') as f:
    json.dump(raw_sources, f, indent=2, ensure_ascii=False)

print("Saved to extracted_raw_sources.json")
