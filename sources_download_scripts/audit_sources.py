import json
import os

with open('clean_unique_sources.json', 'r', encoding='utf-8') as f:
    unique_sources = json.load(f)

sources_dir = os.path.join(os.getcwd(), 'sources')
downloaded_files = os.listdir(sources_dir)

# Clean up broken / placeholder files:
# 1. Monzel_2021_Imagine_and_you_will_find.pdf was 3038 bytes, but test_springer.pdf was 799121 bytes!
if os.path.exists(os.path.join(sources_dir, 'test_springer.pdf')):
    os.replace(os.path.join(sources_dir, 'test_springer.pdf'), os.path.join(sources_dir, 'Monzel_2021_Imagine_and_you_will_find.pdf'))
    print("Replaced Monzel_2021 with full PDF")

# 2. Monzel_2023_Wheres_Wanda_visual_search.pdf was 3038 bytes, but test_wanda.pdf was 729106 bytes!
if os.path.exists(os.path.join(sources_dir, 'test_wanda.pdf')):
    os.replace(os.path.join(sources_dir, 'test_wanda.pdf'), os.path.join(sources_dir, 'Monzel_2023_Wheres_Wanda.pdf'))
    print("Replaced Monzel_2023 Wanda with full PDF")

# Remove temp test files
for temp_file in ['test_wicken.pdf', 'test_wicken_pmc.pdf', 'test_wicken_rs.pdf', 'test_cognition.pdf', 'test_handle_exeter.html', 'sussex_dance.html']:
    p = os.path.join(sources_dir, temp_file)
    if os.path.exists(p):
        os.remove(p)

downloaded_files = os.listdir(sources_dir)
print(f"Total files in sources/: {len(downloaded_files)}")
for f in sorted(downloaded_files):
    size = os.path.getsize(os.path.join(sources_dir, f))
    print(f"  {f} ({size:,} bytes)")
