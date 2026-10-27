import urllib.request
import json
import time

dois = [
    ("Monzel_2022_Proposal", "10.1016/j.cortex.2022.04.003"),
    ("Dance_2022_Prevalence", "10.1016/j.concog.2021.103243"),
    ("Zeman_2020_Phantasia", "10.1016/j.cortex.2020.04.003"),
    ("Zeman_2015_Lives_without_imagery", "10.1016/j.cortex.2015.05.019"),
    ("Monzel_2023_No_general_pathological", "10.1111/sjop.12887"),
    ("Galton_1880_Statistics", "10.1093/mind/os-V.19.301"),
    ("Zeman_2010_Blind_imagination", "10.1016/j.neuropsychologia.2009.08.024"),
    ("Keogh_2018_Blind_mind", "10.1016/j.cortex.2017.10.012"),
    ("Monzel_2021_Imagine_find", "10.3758/s13414-021-02307-z"),
    ("Monzel_2023_Wanda", "10.3758/s13414-022-02645-6"),
    ("Monzel_2022_Memory", "10.1111/jnp.12265"),
    ("Monzel_2023_Prosopagnosia", "10.1177/03010066231180712"),
    ("Monzel_2023_SSRN_Overshadowing", "10.2139/ssrn.4442330"),
    ("Monzel_2023_Empathy", "10.1016/j.jrp.2023.104354"),
    ("Wicken_2021_Emotion", "10.1098/rspb.2021.0267"),
    ("Zeman_2024_Extremes", "10.1016/j.tics.2024.02.007"),
    ("Rhodes_2024_Athletes", "10.1080/10413200.2024.2337019"),
    ("Keogh_2024_Revisiting", "10.1016/j.neures.2024.01.008"),
    ("Koenig_2025_Psychedelic", "10.1016/j.cortex.2025.08.002"),
    ("Dawes_2024_Multisensory", "10.1016/j.neures.2023.11.009"),
    ("Monzel_2023_Imaginal", "10.1111/psyp.14271"),
    ("Bartolomeo_2026_Review", "10.1146/annurev-vision-110425-105103")
]

results = {}

for name, doi in dois:
    time.sleep(0.2)
    # Check OpenAlex
    oa_url = f"https://api.openalex.org/works/https://doi.org/{doi}"
    req = urllib.request.Request(oa_url, headers={'User-Agent': 'Mozilla/5.0'})
    res_entry = {"doi": doi, "pdf_url": None, "landing_page": None, "is_oa": False, "title": None}
    try:
        with urllib.request.urlopen(req, timeout=10) as resp:
            data = json.loads(resp.read().decode('utf-8'))
            res_entry['title'] = data.get('title')
            oa = data.get('open_access', {})
            res_entry['is_oa'] = oa.get('is_oa', False)
            best = data.get('best_oa_location') or {}
            res_entry['pdf_url'] = best.get('pdf_url')
            res_entry['landing_page'] = best.get('landing_page_url')
            # Check other locations if pdf_url is None
            if not res_entry['pdf_url']:
                for loc in data.get('locations', []):
                    if loc.get('pdf_url'):
                        res_entry['pdf_url'] = loc.get('pdf_url')
                        break
    except Exception as e:
        res_entry['error'] = str(e)
    
    # Also check Unpaywall if not found
    if not res_entry['pdf_url']:
        try:
            upw_url = f"https://api.unpaywall.org/v2/{doi}?email=user@example.com"
            req2 = urllib.request.Request(upw_url, headers={'User-Agent': 'Mozilla/5.0'})
            with urllib.request.urlopen(req2, timeout=5) as resp:
                upw_data = json.loads(resp.read().decode('utf-8'))
                best_oa = upw_data.get('best_oa_location') or {}
                if best_oa.get('url_for_pdf'):
                    res_entry['pdf_url'] = best_oa.get('url_for_pdf')
                if not res_entry['landing_page']:
                    res_entry['landing_page'] = best_oa.get('url_for_landing_page')
        except Exception:
            pass

    print(f"[{name}] is_oa={res_entry['is_oa']} PDF={res_entry['pdf_url']}")
    results[name] = res_entry

with open('doi_resolution_results.json', 'w', encoding='utf-8') as f:
    json.dump(results, f, indent=2)
