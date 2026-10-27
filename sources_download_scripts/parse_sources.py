import re
import json

with open('wiki.txt', 'r', encoding='utf-8') as f:
    text = f.read()

# Let's see all lines and all references
# Find all ref tags: <ref name="...">...</ref> or <ref>...</ref> or <ref name="..." />
pattern = re.compile(r'<ref\b([^>/]*?)(?:>(.*?)</ref>|/>)', re.DOTALL)
matches = pattern.findall(text)

print(f"Total ref matches: {len(matches)}")

refs_by_name = {}
all_sources = []

for idx, (attr, body) in enumerate(matches, 1):
    attr = attr.strip()
    body = body.strip()
    name_m = re.search(r'name=["\']?([^"\'/]+)["\']?', attr)
    name = name_m.group(1).strip() if name_m else None
    
    if body:
        all_sources.append({
            "index": idx,
            "name": name,
            "body": body
        })
        if name:
            refs_by_name[name] = body
    else:
        # self-closing ref
        all_sources.append({
            "index": idx,
            "name": name,
            "body": f"[Referencing: {name}]"
        })

print(f"Total body references: {len([s for s in all_sources if not s['body'].startswith('[Referencing:')])}")
for s in all_sources:
    body_summary = s['body'][:80].replace('\n', ' ')
    print(f"[{s['index']}] name={s['name']} | {body_summary}")

# Also check for links outside of <ref> tags, like under == Literatur == or == Weblinks ==
literatur_match = re.search(r'==\s*Literatur\s*==\s*(.*?)\s*==', text, re.DOTALL)
if literatur_match:
    print("\n--- == Literatur == ---")
    print(literatur_match.group(1).strip())

weblinks_match = re.search(r'==\s*Weblinks\s*==\s*(.*?)\s*==', text, re.DOTALL)
if weblinks_match:
    print("\n--- == Weblinks == ---")
    print(weblinks_match.group(1).strip())
