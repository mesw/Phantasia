import urllib.request
import urllib.parse
import os

base_url = "https://medicine-vet-medicine.ed.ac.uk"

files_to_download = [
    ("Zeman_2024_Trends_in_Cognitive_Sciences.pdf", "/sites/default/files/2025-09/Zeman%202024%20%28Trends%20in%20Cognitive%20Sciences%29.pdf"),
    ("Zeman_2020_Phantasia_Lifelong_Imagery_Extremes.pdf", "/sites/default/files/2025-09/Journal%20article%20-%20Zeman%20et%20al%202020%20Phantasia%3A%20The%20Psychological%20Significance%20of%20Lifelong%20Visual%20Imagery%20Extremes.pdf"),
    ("Dance_2022_Prevalence_of_Aphantasia_Consciousness_Cognition.pdf", "/sites/default/files/2025-09/Dance%20et%20al%202021%20%28Consciousness%20and%20Cognition%29.pdf"),
    ("Monzel_2022_Proposal_Consistent_Definition_Cortex.pdf", "/sites/default/files/2025-09/Monzel%20et%20al%202022%20%28Cortex%29.pdf")
]

sources_dir = os.path.join(os.getcwd(), "sources")

headers = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
}

for out_name, path in files_to_download:
    url = base_url + path
    dest = os.path.join(sources_dir, out_name)
    req = urllib.request.Request(url, headers=headers)
    try:
        with urllib.request.urlopen(req, timeout=30) as resp:
            content = resp.read()
            with open(dest, 'wb') as f:
                f.write(content)
            print(f"Downloaded {out_name}: {len(content)} bytes")
    except Exception as e:
        print(f"Failed {out_name}: {e}")
