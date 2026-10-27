import urllib.request
import json
import time

def check_doi(doi):
    url = f"https://api.openalex.org/works/https://doi.org/{doi}"
    req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'})
    try:
        with urllib.request.urlopen(req, timeout=10) as resp:
            data = json.loads(resp.read().decode('utf-8'))
            title = data.get('title')
            oa = data.get('open_access', {})
            pdf_url = oa.get('oa_url')
            best_loc = data.get('best_oa_location') or {}
            best_pdf = best_loc.get('pdf_url') or best_loc.get('landing_page_url')
            return {
                "found": True,
                "title": title,
                "is_oa": oa.get('is_oa'),
                "pdf_url": best_pdf or pdf_url,
                "landing_page": best_loc.get('landing_page_url')
            }
    except Exception as e:
        return {"found": False, "error": str(e)}

print("Testing OpenAlex on a DOI...")
res = check_doi("10.1016/j.cortex.2022.04.003")
print(res)
