import os
import json

sources_dir = os.path.join(os.getcwd(), 'sources')

# Let's map downloaded files
files_info = {}
for f in os.listdir(sources_dir):
    p = os.path.join(sources_dir, f)
    if os.path.isfile(p):
        files_info[f] = {
            "size_bytes": os.path.getsize(p),
            "size_str": f"{os.path.getsize(p) / 1024:.1f} KB" if os.path.getsize(p) < 1024*1024 else f"{os.path.getsize(p) / (1024*1024):.2f} MB"
        }

catalog = [
    # Books
    {
        "category": "Books & Monographies",
        "title": "L'évolution des idées générales (1897)",
        "authors": "Théodule Ribot",
        "year": "1897 / 2006",
        "file": "Ribot_1897_Evolution_des_idees_generales.pdf",
        "type": "Full Book (PDF, Scan)",
        "doi_url": "ISBN: 978-2-296-02334-5 / Internet Archive (Public Domain)",
        "notes": "Original historic work describing 'typographical visual imagination' cited in wiki.txt."
    },
    {
        "category": "Books & Monographies",
        "title": "The Mathematician's Mind: The Psychology of Invention in the Mathematical Field",
        "authors": "Jacques Hadamard",
        "year": "1945 / 2020",
        "file": "Hadamard_1945_Psychology_of_Invention_Mathematicians_Mind.pdf",
        "type": "Full Book (PDF)",
        "doi_url": "ISBN: 978-0-691-21290-6 / Princeton Science Library",
        "notes": "Classic study analyzing thinking without visual images and quoting Ribot."
    },
    {
        "category": "Books & Monographies",
        "title": "The Doors of Perception and Heaven and Hell",
        "authors": "Aldous Huxley",
        "year": "1954 / 2004",
        "file": "Huxley_2004_Doors_of_Perception.pdf",
        "type": "Full Book (PDF)",
        "doi_url": "ISBN: 978-0-06-059518-0 / Perennial Classics",
        "notes": "Autobiographical account of lacking voluntary mental imagery and exploring perception."
    },
    {
        "category": "Books & Monographies",
        "title": "A Dictionary of Neurological Signs",
        "authors": "Andrew J. Larner",
        "year": "2016",
        "file": "Larner_Dictionary_of_Neurological_Signs.pdf",
        "type": "Full Book (PDF)",
        "doi_url": "ISBN: 978-3-319-29821-4 / Springer",
        "notes": "Neurological reference dictionary defining aphantasia and related conditions."
    },
    {
        "category": "Books & Monographies",
        "title": "Aphantasie: Fakt oder Fiktion? (Cumulative Doctoral Dissertation)",
        "authors": "Dr. Merlin Monzel",
        "year": "2025",
        "file": "Monzel_2025_Dissertation_BonnDoc.pdf",
        "type": "Full Doctoral Thesis (PDF)",
        "doi_url": "BonnDoc: handle/20.500.11811/12856 / University of Bonn",
        "notes": "Complete doctoral dissertation encompassing 12 published studies on aphantasia from the Bonn Aphantasia Research Project (covering attention, visual search, memory, prosopagnosia, verbal overshadowing, empathy, pathology, and imaginal extinction)."
    },

    # Scientific Journal Papers
    {
        "category": "Scientific Journal Articles",
        "title": "Lives without imagery – Congenital aphantasia",
        "authors": "Adam Zeman, Michaela Dewar, Sergio Della Sala",
        "year": "2015",
        "file": "Zeman_2015_Lives_without_imagery_Cortex_Published.pdf",
        "file2": "Zeman_2015_Lives_without_imagery.pdf",
        "type": "Journal Article (PDF, Published & Figshare)",
        "doi_url": "DOI: 10.1016/j.cortex.2015.05.019 (Cortex 73: 378–380)",
        "notes": "The foundational paper coining the term 'Aphantasia'."
    },
    {
        "category": "Scientific Journal Articles",
        "title": "Loss of imagery phenomenology with intact visuo-spatial task performance: A case of 'blind imagination'",
        "authors": "Adam Z.J. Zeman, Sergio Della Sala, Lorna A. Torrens, et al.",
        "year": "2010",
        "file": "Zeman_2010_Blind_imagination.pdf",
        "type": "Journal Article (PDF, Zenodo)",
        "doi_url": "DOI: 10.1016/j.neuropsychologia.2009.08.024 (Neuropsychologia 48: 145–155)",
        "notes": "The seminal case study of patient MX who lost mental visualization after surgery."
    },
    {
        "category": "Scientific Journal Articles",
        "title": "Phantasia–The psychological significance of lifelong visual imagery vividness extremes",
        "authors": "Adam Zeman, Fraser Milton, Sergio Della Sala, et al.",
        "year": "2020",
        "file": "Zeman_2020_Phantasia_Lifelong_Imagery_Extremes.pdf",
        "type": "Journal Article (PDF, Publisher)",
        "doi_url": "DOI: 10.1016/j.cortex.2020.04.003 (Cortex 130: 426–440)",
        "notes": "Large-cohort investigation into cognitive significance of aphantasia vs hyperphantasia."
    },
    {
        "category": "Scientific Journal Articles",
        "title": "Aphantasia and hyperphantasia: exploring imagery vividness extremes",
        "authors": "Adam Zeman",
        "year": "2024",
        "file": "Zeman_2024_Trends_in_Cognitive_Sciences.pdf",
        "type": "Review Article (PDF, Publisher)",
        "doi_url": "DOI: 10.1016/j.tics.2024.02.007 (Trends in Cognitive Sciences 28: 467–480)",
        "notes": "Comprehensive review of brain connectivity and imagery extremes."
    },
    {
        "category": "Scientific Journal Articles",
        "title": "The prevalence of aphantasia (imagery weakness) in the general population",
        "authors": "Carla J. Dance, Adam Ipser, Julia Simner",
        "year": "2022",
        "file": "Dance_2022_Prevalence_of_Aphantasia_Consciousness_Cognition.pdf",
        "type": "Journal Article (PDF, Publisher)",
        "doi_url": "DOI: 10.1016/j.concog.2021.103243 (Consciousness and Cognition 97: 103243)",
        "notes": "Population study finding ~4% prevalence of aphantasia and imagery weakness."
    },
    {
        "category": "Scientific Journal Articles",
        "title": "The blind mind: No sensory visual imagery in aphantasia",
        "authors": "Rebecca Keogh, Joel Pearson",
        "year": "2018",
        "file": "Keogh_2018_Blind_mind_biorxiv.pdf",
        "type": "Research Article (PDF, BioRxiv)",
        "doi_url": "DOI: 10.1016/j.cortex.2017.10.012 (Cortex 105: 53–60)",
        "notes": "Objective psychophysical proof of absent sensory imagery using binocular rivalry priming."
    },
    {
        "category": "Scientific Journal Articles",
        "title": "Revisiting the blind mind: Still no evidence for sensory visual imagery in individuals with aphantasia",
        "authors": "Rebecca Keogh, Joel Pearson",
        "year": "2024",
        "file": "Keogh_2024_Revisiting_the_blind_mind.pdf",
        "type": "Journal Article (PDF, Open Access)",
        "doi_url": "DOI: 10.1016/j.neures.2024.01.008 (Neuroscience Research 201: 27–30)",
        "notes": "Follow-up study with 50+ participants confirming absent sensory visual imagery."
    },
    {
        "category": "Scientific Journal Articles",
        "title": "Multisensory subtypes of aphantasia: Mental imagery as supramodal perception in reverse",
        "authors": "Alexei Joel Dawes, Rebecca Keogh, Joel Pearson",
        "year": "2024",
        "file": "Dawes_2024_Multisensory_subtypes_of_aphantasia.pdf",
        "type": "Journal Article (PDF, Open Access)",
        "doi_url": "DOI: 10.1016/j.neures.2023.11.009 (Neuroscience Research 201: 50–59)",
        "notes": "Identifies subtypes of aphantasia across vision, sound, touch, taste, smell, and motion."
    },
    {
        "category": "Scientific Journal Articles",
        "title": "The potential risks of opening the mind's eye with psychedelic therapies",
        "authors": "Roger Koenig-Robert, Rebecca Keogh, Joel Pearson",
        "year": "2025",
        "file": "Koenig_Robert_2025_Psychedelic_therapies_Cortex.pdf",
        "type": "Journal Article (PDF, Open Access)",
        "doi_url": "DOI: 10.1016/j.cortex.2025.08.002 (Cortex 191: 167–171)",
        "notes": "Analysis of psychedelic-induced visual imagery in aphantasia and clinical risks."
    },
    {
        "category": "Scientific Journal Articles",
        "title": "The critical role of mental imagery in human emotion: insights from fear-based imagery and aphantasia",
        "authors": "Marcus Wicken, Rebecca Keogh, Joel Pearson",
        "year": "2021",
        "file": "Wicken_2021_Emotion_biorxiv.pdf",
        "type": "Research Article (PDF, BioRxiv)",
        "doi_url": "DOI: 10.1098/rspb.2021.0267 (Proc. R. Soc. B 288: 20210267)",
        "notes": "Physiological study measuring skin conductance during fear-based imagery."
    },
    {
        "category": "Scientific Journal Articles",
        "title": "Visual working memory performance in aphantasia",
        "authors": "Jacobs C., Schwarzkopf D.S., Silvanto J.",
        "year": "2018",
        "file": "Jacobs_2018_Visual_working_memory.pdf",
        "type": "Research Article (PDF, UCL Discovery)",
        "doi_url": "UCL Discovery eprint: 10066302 / Cortex",
        "notes": "Examines high-precision visual working memory performance in aphantasia."
    },
    {
        "category": "Scientific Journal Articles",
        "title": "Proposal for a consistent definition of aphantasia and hyperphantasia",
        "authors": "Merlin Monzel, David Mitchell, Fiona Macpherson, Joel Pearson, Adam Zeman",
        "year": "2022",
        "file": "Monzel_2022_Proposal_Consistent_Definition_Cortex.pdf",
        "type": "Journal Article (PDF, Cortex)",
        "doi_url": "DOI: 10.1016/j.cortex.2022.04.003 (Cortex 152: 74–76)",
        "notes": "Standardized consensus criteria for defining aphantasia and hyperphantasia."
    },
    {
        "category": "Scientific Journal Articles",
        "title": "Imagine, and you will find – Lack of attentional guidance through visual imagery in aphantasics",
        "authors": "Merlin Monzel, Kristof Keidel, Martin Reuter",
        "year": "2021",
        "file": "Monzel_2021_Imagine_and_you_will_find.pdf",
        "type": "Journal Article (PDF, Springer)",
        "doi_url": "DOI: 10.3758/s13414-021-02307-z (Attention, Perception, & Psychophysics 83: 2486–2497)",
        "notes": "Investigates how visual imagery guides attention during search tasks."
    },
    {
        "category": "Scientific Journal Articles",
        "title": "Where’s Wanda? The influence of visual imagery vividness on visual search speed",
        "authors": "Merlin Monzel, Martin Reuter",
        "year": "2023",
        "file": "Monzel_2023_Wheres_Wanda.pdf",
        "type": "Journal Article (PDF, Springer)",
        "doi_url": "DOI: 10.3758/s13414-022-02645-6 (Attention, Perception, & Psychophysics)",
        "notes": "Naturalistic hidden-object experiment testing visual search speed."
    },
    {
        "category": "Scientific Journal Articles",
        "title": "Statistics of Mental Imagery",
        "authors": "Francis Galton",
        "year": "1880",
        "file": "Galton_1880_Statistics.html",
        "type": "Classic Full-Text Paper (HTML)",
        "doi_url": "DOI: 10.1093/mind/os-V.19.301 / Mind, os-V(19): 301–318",
        "notes": "The historic first scientific investigation of variations in the mind's eye (breakfast table query)."
    },

    # Essays & Personal Accounts
    {
        "category": "Essays & Personal Accounts",
        "title": "Aphantasia: How it feels to be blind in your mind",
        "authors": "Blake Ross",
        "year": "2016",
        "file": "Blake_Ross_2016_Aphantasia_Essay.pdf",
        "type": "Archival Essay (PDF, University of Edinburgh)",
        "doi_url": "Facebook Note (2016-04-22) / Preserved by Edinburgh Medical School",
        "notes": "The viral essay by the co-creator of Mozilla Firefox that sparked global awareness."
    },
    {
        "category": "Essays & Personal Accounts",
        "title": "Aphantasia & memory",
        "authors": "Lynne Kelly",
        "year": "2020",
        "file": "Lynne_Kelly_2020_Aphantasia_and_Memory.html",
        "type": "Online Essay (HTML)",
        "doi_url": "https://www.lynnekelly.com.au/?page_id=4236",
        "notes": "Author and memory expert explains using memory palaces without mental imagery."
    },

    # Journalism & Media Sources
    {
        "category": "Journalism & Media Articles",
        "title": "Aphantasia: A life without mental images",
        "authors": "James Gallagher",
        "year": "2015",
        "file": "Gallagher_BBC_2015.html",
        "type": "News Article (HTML)",
        "doi_url": "https://www.bbc.com/news/health-34039054 (BBC News)",
        "notes": "Early BBC coverage of Adam Zeman's 2015 paper."
    },
    {
        "category": "Journalism & Media Articles",
        "title": "Aphantasia: Ex-Pixar chief Ed Catmull says 'my mind's eye is blind'",
        "authors": "James Gallagher",
        "year": "2019",
        "file": "Gallagher_BBC_2019_EdCatmull.html",
        "type": "News Article (HTML)",
        "doi_url": "https://www.bbc.com/news/health-47830256 (BBC News)",
        "notes": "Ed Catmull on surveying 540 Pixar artists and finding varying visualization abilities."
    },
    {
        "category": "Journalism & Media Articles",
        "title": "Picture This? Some Just Can’t",
        "authors": "Carl Zimmer",
        "year": "2015",
        "file": "NYT_Zimmer_2015_Picture_This.html",
        "type": "Science Article (HTML)",
        "doi_url": "https://carlzimmer.com / The New York Times (2015-06-23)",
        "notes": "Major New York Times feature that introduced aphantasia to the American public."
    },
    {
        "category": "Journalism & Media Articles",
        "title": "If you can't imagine things, how can you learn?",
        "authors": "Mo Costandi",
        "year": "2016",
        "file": "Costandi_Guardian_2016.html",
        "type": "Journalism Article (HTML)",
        "doi_url": "https://www.theguardian.com/education/2016/jun/04/aphantasia-no-visual-imagination-impact-learning (The Guardian)",
        "notes": "Discussion of aphantasia and learning strategies."
    },
    {
        "category": "Journalism & Media Articles",
        "title": "My mind’s eye is blind – so what’s going on in my brain?",
        "authors": "Dustin Grinnell",
        "year": "2016",
        "file": "NewScientist_Grinnell_2016.html",
        "type": "Science Article (HTML)",
        "doi_url": "https://www.newscientist.com/article/2083706-my-minds-eye-is-blind-so-whats-going-on-in-my-brain/ (New Scientist)",
        "notes": "First-person neuroscience inquiry into brain mechanisms of aphantasia."
    },
    {
        "category": "Journalism & Media Articles",
        "title": "Aldous Huxley, Short of Sight",
        "authors": "Clive James",
        "year": "2003",
        "file": "NewYorker_Huxley_2003.html",
        "type": "Essay / Review (HTML)",
        "doi_url": "https://www.newyorker.com/magazine/2003/03/17/aldous-huxley-short-of-sight (The New Yorker)",
        "notes": "Literary analysis of Huxley's perception and visual imagination."
    },
    {
        "category": "Journalism & Media Articles",
        "title": "Derek Parfit’s quest for perfection",
        "authors": "Bryan Appleyard",
        "year": "2018",
        "file": "NewStatesman_Parfit_2018.html",
        "type": "Longform Feature (HTML)",
        "doi_url": "https://www.newstatesman.com (New Statesman)",
        "notes": "Profile of British philosopher Derek Parfit, his photography, and aphantasia."
    },
    {
        "category": "Journalism & Media Articles",
        "title": "Influencerin berichtet über seltenes Gehirn-Phänomen – leidest auch du darunter? (Bonnie Strange)",
        "authors": "Watson.ch",
        "year": "2020",
        "file": "Watson_2020.html",
        "type": "News Article (HTML)",
        "doi_url": "https://www.watson.ch/!793821185",
        "notes": "Report on model/actress Bonnie Strange speaking publicly about having aphantasia."
    },
    {
        "category": "Journalism & Media Articles",
        "title": "Ein Leben ohne Bilder im Kopf - Aphantasie",
        "authors": "SRF (Schweizer Radio und Fernsehen)",
        "year": "2022",
        "file": "SRF_2022.html",
        "type": "Science Article (HTML)",
        "doi_url": "https://www.srf.ch/wissen/mensch/ein-leben-ohne-bilder-im-kopf-aphantasie-wie-es-ist-wenn-man-sich-nichts-vorstellen-kann",
        "notes": "Interview with researcher Merlin Monzel about discovering his own aphantasia."
    },
    {
        "category": "Journalism & Media Articles",
        "title": "Warum deine Welt anders aussieht als meine",
        "authors": "Republik.ch",
        "year": "2024",
        "file": "Republik_2024.html",
        "type": "Magazine Article (HTML)",
        "doi_url": "https://www.republik.ch/2024/01/20/warum-deine-welt-anders-aussieht-als-meine",
        "notes": "In-depth article on internal monologue, inner voice, and anendophasia."
    },
    {
        "category": "Journalism & Media Articles",
        "title": "Anendophasie: Wenn man keine innere Stimme hört",
        "authors": "Psylex.de",
        "year": "2024",
        "file": "Psylex_2024.html",
        "type": "Psychology Article (HTML)",
        "doi_url": "https://psylex.de/anendophasie-wenn-man-keine-innere-stimme-hoert/",
        "notes": "Overview of anendophasia (absence of an inner speech voice)."
    },

    # Broadcast Media & External Links
    {
        "category": "Broadcast Media & Web Links",
        "title": "Aphantasia: When The Mental Image Is Missing (Quirks and Quarks)",
        "authors": "CBC Radio One",
        "year": "2016",
        "file": "CBC_Quirks_2016.html",
        "type": "Radio Feature & Web Article (HTML)",
        "doi_url": "https://www.cbc.ca/radio/quirks/quirks-quarks-for-jun-25-2016-1.3645555/aphantasia-when-the-mental-image-is-missing-1.3651056",
        "notes": "Canadian Broadcasting Corporation science coverage of aphantasia."
    },
    {
        "category": "Broadcast Media & Web Links",
        "title": "Aphantasia Research Project Bonn",
        "authors": "Universität Bonn",
        "year": "2020-Present",
        "file": "Uni_Bonn_Project.html",
        "type": "Research Project Portal (HTML)",
        "doi_url": "https://www.psychologie.uni-bonn.de/de/institut/abteilungen/differentielle-und-biologische-psychologie/forschung-und-projekte-1/aphantasie",
        "notes": "Official portal of the Bonn Aphantasia Research Project led by Merlin Monzel."
    },
    {
        "category": "Broadcast Media & Web Links",
        "title": "The Eye's Mind Study",
        "authors": "University of Edinburgh",
        "year": "2020-Present",
        "file": "edinburgh_our_research.html",
        "file2": "edinburgh_eyes_mind.html",
        "type": "Research Hub (HTML)",
        "doi_url": "https://medicine-vet-medicine.ed.ac.uk/eyes-mind",
        "notes": "Research hub directed by Prof. Adam Zeman studying imagery extremes."
    },
    {
        "category": "Broadcast Media & Web Links",
        "title": "Auf dem inneren Auge blind (Artikelsammlung)",
        "authors": "Spektrum der Wissenschaft",
        "year": "Archive",
        "file": "Spektrum_Afantasie.html",
        "type": "Article Collection (HTML)",
        "doi_url": "https://www.spektrum.de/suche/#/q/Afantasie/SortDesc/Neueste%20Zuerst",
        "notes": "Spektrum der Wissenschaft article archive on Afantasie."
    },
    {
        "category": "Broadcast Media & Web Links",
        "title": "Afantasie - Leben ohne Vorstellungskraft",
        "authors": "Galileo / ProSieben",
        "year": "2020",
        "file": "Galileo_ProSieben.html",
        "type": "Television Episode Web Page (HTML)",
        "doi_url": "https://www.prosieben.de/serien/galileo/videos/aphantasie-was-ist-das",
        "notes": "German TV broadcast report on living without mental imagery."
    }
]

md_lines = [
    "# Downloaded Sources Index — Aphantasie (wiki.txt)",
    "",
    "This directory contains full-text publications, books, journal articles, essays, and media sources referenced in `wiki.txt`.",
    "",
    f"**Total Downloaded Items Cataloged:** {len(catalog)}",
    f"**Total Files in `sources/` Directory:** {len(files_info)}",
    "",
    "---",
    "",
    "## Summary Table",
    "",
    "| # | Title / Work | Author(s) | Year | Format / Type | Local File(s) | Size |",
    "|---|---|---|---|---|---|---|"
]

idx = 1
for item in catalog:
    f1 = item['file']
    s1 = files_info.get(f1, {}).get('size_str', 'N/A')
    file_display = f"[`{f1}`]({f1})"
    if 'file2' in item and item['file2'] in files_info:
        f2 = item['file2']
        s2 = files_info.get(f2, {}).get('size_str', '')
        file_display += f"<br>[`{f2}`]({f2})"
        s1 = f"{s1} / {s2}"
    md_lines.append(f"| {idx:02d} | **{item['title']}** | {item['authors']} | {item['year']} | {item['type']} | {file_display} | {s1} |")
    idx += 1

md_lines.append("")
md_lines.append("---")
md_lines.append("")
md_lines.append("## Detailed Catalog by Category")
md_lines.append("")

current_cat = None
for item in catalog:
    if item['category'] != current_cat:
        current_cat = item['category']
        md_lines.append(f"### {current_cat}")
        md_lines.append("")

    f1 = item['file']
    s1 = files_info.get(f1, {}).get('size_str', 'N/A')
    md_lines.append(f"#### {item['title']}")
    md_lines.append(f"- **Authors:** {item['authors']}")
    md_lines.append(f"- **Publication / Year:** {item['year']}")
    md_lines.append(f"- **Identifier / Reference:** {item['doi_url']}")
    md_lines.append(f"- **Local Download File:** [`{f1}`]({f1}) ({s1})")
    if 'file2' in item and item['file2'] in files_info:
        f2 = item['file2']
        s2 = files_info.get(f2, {}).get('size_str', '')
        md_lines.append(f"- **Additional Download File:** [`{f2}`]({f2}) ({s2})")
    md_lines.append(f"- **Notes:** {item['notes']}")
    md_lines.append("")

with open(os.path.join(sources_dir, 'SOURCES_INDEX.md'), 'w', encoding='utf-8') as f:
    f.write("\n".join(md_lines))

with open('SOURCES_INDEX.md', 'w', encoding='utf-8') as f:
    f.write("\n".join(md_lines))

print("Generated SOURCES_INDEX.md successfully!")
