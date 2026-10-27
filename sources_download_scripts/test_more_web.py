import urllib.request
import os
import json

urls_to_test = [
    ("Exeter_Blog_2015.html", "https://web.archive.org/web/20160913092711/http://blogs.exeter.ac.uk/exeterblog/blog/2015/08/26/aphantasia/"),
    ("RND_2022.html", "https://www.rnd.de/gesundheit/auf-dem-inneren-auge-blind-was-ist-afantasie-BKEYHLZXWJETXGW4T7KQ7GD5G4.html"),
    ("NYT_Zimmer_2015.html", "https://www.nytimes.com/2015/06/23/science/aphantasia-minds-eye-blind.html"),
    ("NewScientist_Grinnell_2016.html", "https://www.newscientist.com/article/2083706-my-minds-eye-is-blind-so-whats-going-on-in-my-brain/"),
    ("Blake_Ross_2016.html", "https://web.archive.org/web/20160424074213/https://www.facebook.com/notes/blake-ross/aphantasia-how-it-feels-to-be-blind-in-your-mind/10156834777480504/"),
    ("Gallagher_BBC_2019_EdCatmull.html", "https://www.bbc.com/news/health-47830256"),
    ("Lynne_Kelly_2020.html", "https://web.archive.org/web/20210728214436/https://www.lynnekelly.com.au/?page_id=4236"),
    ("NewYorker_Huxley_2003.html", "https://www.newyorker.com/magazine/2003/03/17/aldous-huxley-short-of-sight"),
    ("NewStatesman_Parfit_2018.html", "https://web.archive.org/web/20191118041834/https://www.newstatesman.com/2018/06/derek-parfit-minds-eye-photographs-philosophy-narrative-projects"),
    ("ElizAquino_2017.html", "https://web.archive.org/web/20220814033155/http://heyitseliz.com/wp/index.php/2017/03/19/review-all-things-new-lauren-miller/"),
    ("Watson_2020.html", "https://www.watson.ch/!793821185"),
    ("SRF_2022.html", "https://www.srf.ch/wissen/mensch/ein-leben-ohne-bilder-im-kopf-aphantasie-wie-es-ist-wenn-man-sich-nichts-vorstellen-kann"),
    ("Republik_2024.html", "https://www.republik.ch/2024/01/20/warum-deine-welt-anders-aussieht-als-meine"),
    ("Psylex_2024.html", "https://psylex.de/anendophasie-wenn-man-keine-innere-stimme-hoert/"),
    ("CBC_Quirks_2016.html", "https://www.cbc.ca/radio/quirks/quirks-quarks-for-jun-25-2016-1.3645555/aphantasia-when-the-mental-image-is-missing-1.3651056"),
    ("Uni_Bonn_Project.html", "https://www.psychologie.uni-bonn.de/de/institut/abteilungen/differentielle-und-biologische-psychologie/forschung-und-projekte-1/aphantasie"),
    ("Spektrum_Afantasie.html", "https://www.spektrum.de/suche/#/q/Afantasie/SortDesc/Neueste%20Zuerst"),
    ("Galileo_ProSieben.html", "https://www.prosieben.de/serien/galileo/videos/aphantasie-was-ist-das"),
    ("SWR_Wissen_2021.html", "https://www.swr.de/wissen/aphantasie-wenn-die-visuelle-vorstellungskraft-fehlt-100.html"),
    ("UCL_Discovery_Jacobs_2018.html", "https://discovery.ucl.ac.uk/id/eprint/10066302/")
]

headers = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
}

sources_dir = os.path.join(os.getcwd(), "sources")

for fname, url in urls_to_test:
    dest = os.path.join(sources_dir, fname)
    req = urllib.request.Request(url, headers=headers)
    try:
        with urllib.request.urlopen(req, timeout=15) as resp:
            content = resp.read()
            with open(dest, 'wb') as f:
                f.write(content)
            print(f"OK: {fname} ({len(content)} bytes)")
    except Exception as e:
        print(f"FAIL: {fname} from {url}: {e}")
