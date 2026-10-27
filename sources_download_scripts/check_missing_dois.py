import urllib.request
import json
import re

def search_epmc(query):
    try:
        url = f"https://www.ebi.ac.uk/europepmc/webservices/rest/search?query={urllib.parse.quote(query)}&format=json&resultType=core"
        req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
        with urllib.request.urlopen(req, timeout=10) as resp:
            data = json.loads(resp.read().decode('utf-8'))
            results = data.get('resultList', {}).get('result', [])
            if results:
                r = results[0]
                full_text_urls = r.get('fullTextUrlList', {}).get('fullTextUrl', [])
                pdf_urls = [u.get('url') for u in full_text_urls if u.get('documentStyle') == 'pdf']
                pmcid = r.get('pmcid')
                return {
                    "title": r.get('title'),
                    "pmcid": pmcid,
                    "pdf_urls": pdf_urls,
                    "doi": r.get('doi'),
                    "isOpenAccess": r.get('isOpenAccess')
                }
    except Exception as e:
        return {"error": str(e)}
    return None

def search_semanticscholar(doi):
    try:
        url = f"https://api.semanticscholar.org/graph/v1/paper/DOI:{doi}?fields=title,openAccessPdf"
        req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
        with urllib.request.urlopen(req, timeout=10) as resp:
            data = json.loads(resp.read().decode('utf-8'))
            return data.get('openAccessPdf')
    except Exception as e:
        return None

missing_dois = [
    ("Zeman_2015_Lives_without_imagery", "10.1016/j.cortex.2015.05.019"),
    ("Zeman_2010_Blind_imagination", "10.1016/j.neuropsychologia.2009.08.024"),
    ("Keogh_2018_Blind_mind", "10.1016/j.cortex.2017.10.012"),
    ("Monzel_2022_Memory", "10.1111/jnp.12265"),
    ("Monzel_2023_Prosopagnosia", "10.1177/03010066231180712"),
    ("Monzel_2023_SSRN_Overshadowing", "10.2139/ssrn.4442330"),
    ("Monzel_2023_Empathy", "10.1016/j.jrp.2023.104354"),
    ("Wicken_2021_Emotion", "10.1098/rspb.2021.0267"),
    ("Zeman_2024_Extremes", "10.1016/j.tics.2024.02.007"),
    ("Keogh_2024_Revisiting", "10.1016/j.neures.2024.01.008"),
    ("Koenig_2025_Psychedelic", "10.1016/j.cortex.2025.08.002"),
    ("Dawes_2024_Multisensory", "10.1016/j.neures.2023.11.009"),
    ("Bartolomeo_2026_Review", "10.1146/annurev-vision-110425-105103")
]

import urllib.parse
for name, doi in missing_dois:
    epmc = search_epmc(f"DOI:{doi}")
    s2 = search_semanticscholar(doi)
    print(f"[{name}]")
    print(f"   EPMC: {epmc}")
    print(f"   S2:   {s2}")
