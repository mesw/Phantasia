import os
import json

sources_dir = os.path.join(os.getcwd(), 'sources')

# Remove duplicate / small error files
to_remove = [
    'Dance_2022_Prevalence_of_aphantasia.pdf',
    'Monzel_2023_Wheres_Wanda_visual_search.pdf',
    'NYT_Zimmer_2015.html',
    'Lynne_Kelly_2020.html',
    'Exeter_Blog_2015.html',
    'RND_2022_Afantasie.html',
    'Rhodes_2024_Imagery_training_athletes.pdf',
    'SSRN_4442330.html'
]

for f in to_remove:
    p = os.path.join(sources_dir, f)
    if os.path.exists(p):
        os.remove(p)
        print(f"Removed {f}")

# Rename Lynne_Kelly_live.html to Lynne_Kelly_2020_Aphantasia_and_Memory.html
lk_old = os.path.join(sources_dir, 'Lynne_Kelly_live.html')
lk_new = os.path.join(sources_dir, 'Lynne_Kelly_2020_Aphantasia_and_Memory.html')
if os.path.exists(lk_old):
    os.replace(lk_old, lk_new)

# Rename NewStatesman_Parfit_live.html to NewStatesman_Parfit_2018.html
ns_old = os.path.join(sources_dir, 'NewStatesman_Parfit_live.html')
ns_new = os.path.join(sources_dir, 'NewStatesman_Parfit_2018.html')
if os.path.exists(ns_old):
    os.replace(ns_old, ns_new)

print("Cleaned up directory.")
