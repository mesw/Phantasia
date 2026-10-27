with open('sources/UCL_Discovery_Jacobs_2018.html', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

import re
matches = re.findall(r'href=["\']([^"\']+\.pdf)["\']', text, re.I)
print("PDF links found:", matches)
