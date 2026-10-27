import urllib.request
import os

sources_dir = os.path.join(os.getcwd(), "sources")
os.makedirs(sources_dir, exist_ok=True)

papers = [
    ("Monzel_2022_Proposal_consistent_definition.pdf", "https://eprints.gla.ac.uk/269371/1/269371.pdf"),
    ("Dance_2022_Prevalence_of_aphantasia.pdf", "http://sro.sussex.ac.uk/id/eprint/103365/1/SIMNER_Consciousness_and_Cognition_NOV_2021.pdf"),
    ("Zeman_2020_Phantasia_psychological_significance.pdf", "https://www.research.ed.ac.uk/files/148977760/Phantasia_Cortex_revision_transparency_amendments_6.4.20.pdf"),
    ("Monzel_2023_No_general_pathological_significance.pdf", "https://onlinelibrary.wiley.com/doi/pdfdirect/10.1111/sjop.12887"),
    ("Monzel_2021_Imagine_and_you_will_find.pdf", "https://link.springer.com/content/pdf/10.3758/s13414-021-02307-z.pdf"),
    ("Monzel_2023_Wheres_Wanda_visual_search.pdf", "https://link.springer.com/content/pdf/10.3758/s13414-022-02645-6.pdf"),
    ("Monzel_2023_Imaginal_extinction_without_imagery.pdf", "https://onlinelibrary.wiley.com/doi/pdfdirect/10.1111/psyp.14271"),
    ("Wicken_2021_Mental_imagery_human_emotion.pdf", "https://europepmc.org/articles/PMC7944105?pdf=render"),
    ("Zeman_2024_Aphantasia_and_hyperphantasia_extremes.pdf", "https://www.cell.com/action/showPdf?pii=S1364-6613%2824%2900034-2")
]

headers = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
    'Accept': 'application/pdf,text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
}

for fname, url in papers:
    dest = os.path.join(sources_dir, fname)
    req = urllib.request.Request(url, headers=headers)
    try:
        with urllib.request.urlopen(req, timeout=30) as resp:
            content = resp.read()
            # Verify if it's really a PDF or error HTML
            is_pdf = content.startswith(b'%PDF')
            with open(dest, 'wb') as f:
                f.write(content)
            print(f"OK ({'PDF' if is_pdf else 'HTML'}): {fname} ({len(content)} bytes)")
    except Exception as e:
        print(f"FAIL: {fname}: {e}")
