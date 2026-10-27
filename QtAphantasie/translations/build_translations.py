import xml.etree.ElementTree as ET
import subprocess
import os

# Mapping of English source strings to validated German psychological translations
translations_de = {
    # --- Main & Navigation ---
    "Phantasia | Vividness Assessment & Neurocognitive Training": "Phantasia | Kognitive Profilierung & Neurokognitives Training",
    "Phantasia": "Phantasia",
    "Aphantasia Platform | Vividness Assessment & Neurocognitive Training": "Afantasie-Plattform | Kognitive Profilierung & Neurokognitives Training",
    "Aphantasia": "Afantasie",
    "RESEARCH": "FORSCHUNG",
    "Vividness Assessment & Neurocognitive Training": "Kognitive Profilierung & Neurokognitives Training",
    "Assessment": "Erfassung",
    "6-Week Training": "6-Wochen-Training",
    "Progress": "Fortschritt",
    "Ethics & Sources": "Ethik & Quellen",
    "Download My Data": "Meine Daten herunterladen",
    "Source Code": "Quellcode",

    # --- Consent Dialog ---
    "Informed Consent & Study Information": "Einwilligungserklärung & Studieninformation",
    "Research Ethics, Data Sovereignty & Non-Medical Device Notice": "Forschungsethik, Datensouveränität & Hinweis zum Nicht-Medizinprodukt",
    "Research & Educational Instrument — Not a Medical Device": "Forschungs- und Bildungsinstrument — Kein Medizinprodukt",
    "This application is developed strictly for empirical research, cognitive self-exploration, and educational purposes. It is NOT a medical device, does not provide medical or psychiatric diagnoses, and is not a substitute for clinical psychological therapy or medical care.": "Diese Anwendung wurde ausschließlich für empirische Forschung, kognitive Selbsterkundung und Bildungszwecke entwickelt. Sie ist KEIN Medizinprodukt, liefert keine medizinischen oder psychiatrischen Diagnosen und ersetzt keine klinisch-psychologische Therapie oder ärztliche Betreuung.",
    "Data Sovereignty: Your Data Stays Exclusively on Your Device": "Datensouveränität: Ihre Daten verbleiben ausschließlich auf Ihrem Gerät",
    "The application operates strictly local-first. None of your assessment answers, scores, training logs, or IP addresses are transmitted to external servers, cloud databases, or third-party trackers. All state is held in your browser's private local sandbox. You can download your data at any time via 'Download My Data' (JSON or CSV) or permanently delete it with one click.": "Die Anwendung arbeitet strikt lokal (Local-First). Weder Ihre Antworten, Punktwerte, Trainingsprotokolle noch IP-Adressen werden an externe Server, Cloud-Datenbanken oder Tracker übertragen. Alle Daten verbleiben in der privaten lokalen Sandbox Ihres Browsers. Sie können Ihre Daten jederzeit über 'Meine Daten herunterladen' (JSON oder CSV) exportieren oder mit einem Klick unwiderruflich löschen.",
    "Scientific Basis & Transparency:": "Wissenschaftliche Grundlagen & Transparenz:",
    "The evaluations adapt the gold-standard Visual Imagery Questionnaire (VVIQ; Marks 1973) and multisensory profiling (Dawes et al. 2024). The 6-week curriculum operationalizes Functional Imagery Training (FIT) derived from neuroscientific intervention protocols (Rhodes et al. 2024; Monzel 2025; Zeman 2024). Full algorithms and scoring rubrics are openly auditable via the public GitHub repository.": "Die Erfassung adaptiert den standardisierten Visual Imagery Questionnaire (VVIQ; Marks 1973) sowie multisensorisches Profiling (Dawes et al. 2024). Das 6-Wochen-Curriculum operationalisiert Functional Imagery Training (FIT) basierend auf neurowissenschaftlichen Interventionsprotokollen (Rhodes et al. 2024; Monzel 2025; Zeman 2024). Sämtliche Algorithmen und Bewertungsrubriken sind über das öffentliche GitHub-Repository transparent einsehbar.",
    "View Source Code (GitHub)": "Quellcode ansehen (GitHub)",
    "I Understand & Consent to Participate": "Ich verstehe und willige in die Teilnahme ein",

    # --- Assessment View Stepper ---
    "Step 1 of 3: Intuitive Onboarding (\"The Apple Test\")": "Schritt 1 von 3: Intuitiver Einstieg (\"Der Apfel-Test\")",
    "Step 2 of 3: Standardized VVIQ Evaluation (Marks 1973)": "Schritt 2 von 3: Standardisierte VVIQ-Erfassung (Marks 1973)",
    "Step 3 of 3: Multi-Sensory Modality Check (Dawes et al. 2024)": "Schritt 3 von 3: Multisensorische Profilprüfung (Dawes et al. 2024)",
    "Assessment Summary & Baseline Profile": "Auswertungsbericht & Ausgangsprofil",
    "Close your eyes, imagine a red apple on a table, and select the illustration closest to your subjective experience.": "Schließen Sie die Augen, stellen Sie sich einen roten Apfel auf einem Tisch vor und wählen Sie die Illustration, die Ihrem Erleben am nächsten kommt.",
    "16 standardized psychometric items across 4 vivid real-world visualization scenarios.": "16 standardisierte psychometrische Items in 4 anschaulichen Alltagsszenarien.",
    "Evaluating non-visual sensory modalities (hearing, touch, movement, smell, taste, emotion).": "Erfassung nicht-visueller Sinnesmodalitäten (Hören, Tasten, Motorik, Riechen, Schmecken, Emotion).",
    "Your validated cognitive vividness classification, percentile rank, and training recommendations.": "Ihre wissenschaftliche Klassifikation der Vorstellungskraft, Prozentrang und Trainingsempfehlungen.",
    "Confirm Selection & Continue to Full VVIQ Evaluation (Step 2) →": "Auswahl bestätigen & weiter zum vollständigen VVIQ-Test (Schritt 2) →",
    "Confirm Selection & Continue to Step 2 (VVIQ) →": "Auswahl bestätigen & weiter zu Schritt 2 (VVIQ) →",
    "← Back to Step 1 (Apple Test)": "← Zurück zu Schritt 1 (Apfel-Test)",
    "← Back to Step 2 (VVIQ)": "← Zurück zu Schritt 2 (VVIQ)",
    "Selected Apple Level %1 of 5": "Ausgewählte Apfel-Stufe %1 von 5",
    "Keyboard: Press 1-5 to select, Enter to advance": "Tastatur: 1–5 zur Auswahl, Eingabetaste zum Fortfahren",
    "Apple": "Apfel",
    "VVIQ": "VVIQ",
    "Multisensory": "Multisensorik",
    "Report": "Bericht",
    "PeakFrequency: Resonance Breathing Pacer": "PeakFrequency: Resonanzfrequenz-Atemtaktgeber",
    "Open external guided resonance pacer (~5.5-6 bpm / 0.1 Hz) ↗": "Externen geführten Resonanztaktgeber (~5,5–6 Atemzüge/Min., 0,1 Hz) öffnen ↗",
    "Open Pacer ↗": "Taktgeber öffnen ↗",
    "Shortcut: Press 1-5 to rate • Left Arrow for previous": "Tasten: 1–5 zur Bewertung • Pfeiltaste links für vorherige Frage",

    # --- Apple Test Levels ---
    "Level 1: Photorealistic": "Stufe 1: Fotorealistisch",
    "Vivid color, 3D depth, specular lighting, realistic skin texture, and shadow on the table.": "Lebendige Farben, räumliche Tiefe, Glanzlicht, realistische Schalenstruktur und Schattenwurf auf dem Tisch.",
    "\"I see a crisp, photorealistic red apple with shiny reflections and a wooden table.\"": "\"Ich sehe einen gestochen scharfen, fotorealistischen roten Apfel mit Glanzreflexen auf einem Holztisch.\"",
    "Level 2: Vivid": "Stufe 2: Lebendig & Klar",
    "Identifiable red apple with clear shape and color, but slightly softer textures or simpler lighting.": "Erkennbarer roter Apfel mit klarer Form und Farbe, jedoch weicheren Texturen oder einfacherem Licht.",
    "\"I clearly see a red apple. The colors are definite, though not quite like a real photograph.\"": "\"Ich sehe deutlich einen roten Apfel. Die Farben sind klar, wenn auch nicht ganz wie auf einem echten Foto.\"",
    "Level 3: Moderate": "Stufe 3: Mäßig / Illustriert",
    "Subdued colors, simplified illustration or cartoon-like appearance. Somewhat flat and static.": "Gedämpfte Farben, vereinfachte Darstellung wie eine Zeichnung oder Comicgrafik. Eher flach und statisch.",
    "\"I see an apple shape with some red, but it feels like a drawing or muted sketch.\"": "\"Ich sehe eine Apfelform mit etwas Rot, aber es wirkt wie eine Zeichnung oder Skizze.\"",
    "Level 4: Faint / Vague": "Stufe 4: Schwach / Vage",
    "Translucent, dim, or fleeting outline. Mostly grayish silhouette, difficult to stabilize.": "Durchscheinender, trüber oder flüchtiger Umriss. Meist grau, schwer vor dem inneren Auge zu halten.",
    "\"I catch a brief, smoky gray outline or faint shape that disappears when I focus on it.\"": "\"Ich erhasche einen kurzen, rauchig-grauen Umriss, der verschwindet, sobald ich mich darauf konzentriere.\"",
    "Level 5: Complete Aphantasia": "Stufe 5: Vollständige Afantasie",
    "Absolute blackness. No visual sensation whatsoever. Conceptual knowledge only.": "Vollkommene Dunkelheit. Keinerlei visuelle Empfindung. Ausschließlich begriffliches Wissen.",
    "\"I know what an apple is, its taste and shape, but when I close my eyes there is only pitch blackness.\"": "\"Ich weiß, was ein Apfel ist, kenne Form und Geschmack, aber wenn ich die Augen schließe, sehe ich nur Schwarz.\"",
    "Absolute Blackness": "Vollkommene Dunkelheit",

    # --- VVIQ Scenarios ---
    "Scenario 1: Familiar Relative or Friend": "Szenario 1: Eine vertraute verwandte oder befreundete Person",
    "Scenario 2: The Rising Sun": "Szenario 2: Die aufgehende Sonne",
    "Scenario 3: A Familiar Shop": "Szenario 3: Ein vertrautes Geschäft",
    "Scenario 4: A Country Scene": "Szenario 4: Eine Naturlandschaft",
    "Think of some relative or friend whom you frequently see (but who is not with you at present) and consider carefully the picture that comes before your mind's eye.": "Denken Sie an eine verwandte oder befreundete Person, die Sie häufig sehen (die jedoch gegenwärtig nicht anwesend ist), und betrachten Sie sorgfältig das Bild vor Ihrem inneren Auge.",
    "Visualize the rising sun. Look carefully at the picture that comes before your mind's eye.": "Stellen Sie sich die aufgehende Sonne vor. Betrachten Sie aufmerksam das Bild vor Ihrem inneren Auge.",
    "Think of the front of a shop which you often go to. Consider the picture that comes before your mind's eye.": "Denken Sie an die Schaufensterfront eines Geschäfts, das Sie oft besuchen. Betrachten Sie das Bild vor Ihrem inneren Auge.",
    "Finally, think of a country scene which involves trees, mountains and a lake. Consider the picture that comes before your mind's eye.": "Denken Sie schließlich an eine Landschaft mit Bäumen, Bergen und einem See. Betrachten Sie das Bild vor Ihrem geistigen Auge.",

    # --- VVIQ Items 1-16 ---
    "The exact contours of face, head, shoulders and body.": "Die genauen Umrisse von Gesicht, Kopf, Schultern und Körper.",
    "Characteristic poses of head, stances, etc.": "Charakteristische Haltungen des Kopfes, Körperhaltungen usw.",
    "The precise carriage, length of step, etc. in walking.": "Die genaue Körperhaltung, Schrittlänge usw. beim Gehen.",
    "The different colors worn in some familiar clothes.": "Die verschiedenen Farben vertrauter Kleidungsstücke.",
    "The sun is rising above the horizon into a hazy sky.": "Die Sonne geht über dem Horizont in einen dunstigen Himmel auf.",
    "The sky clears and surrounds the sun with blueness.": "Der Himmel klart auf und umgibt die Sonne mit strahlendem Blau.",
    "Clouds. A storm blows up, with flashes of lightning.": "Wolken ziehen auf. Ein Unwetter braut sich zusammen, mit Blitzen.",
    "A rainbow appears.": "Ein Regenbogen erscheint.",
    "The overall appearance of the shop from the opposite side of the road.": "Das Gesamterscheinungsbild des Geschäfts von der gegenüberliegenden Straßenseite.",
    "A window display including the shape, color, and details of individual items for sale.": "Die Schaufensterauslage einschließlich Form, Farbe und Details einzelner Waren.",
    "You are near the entrance. The color, shape and details of the door.": "Sie stehen nahe dem Eingang. Farbe, Form und Details der Eingangstür.",
    "You enter the shop and go to the counter. The counter, assistant, and money exchanging.": "Sie betreten das Geschäft und gehen zur Kasse. Die Theke, das Personal und das Bezahlen.",
    "The contours of the landscape (trees, bushes, mountains).": "Die Umrisse der Landschaft (Bäume, Büsche, Berge).",
    "The color and shape of the trees and plants.": "Farbe und Form der Bäume und Pflanzen.",
    "The color and shape of a lake, river, or water.": "Farbe und Form des Sees, Flusses oder Wassers.",
    "A strong wind blows on trees and water waves.": "Ein starker Wind weht durch die Bäume und erzeugt Wellen auf dem Wasser.",

    # --- VVIQ Rating Scale ---
    "No image at all": "Überhaupt kein Bild",
    "Vague & dim": "Vage & trüb",
    "Moderately clear": "Mäßig klar",
    "Clear & vivid": "Klar & lebendig",
    "Perfect vision": "Perfekt & real",
    "No image at all, you only 'know' that you are thinking of the object.": "Überhaupt kein Bild, Sie 'wissen' nur, dass Sie an das Objekt denken.",
    "Vague and dim image; fleeting and difficult to hold in mind.": "Vages und trübes inneres Bild; flüchtig und schwer festzuhalten.",
    "Moderately clear and reasonably vivid mental image.": "Mäßig klares und ausreichend lebendiges Vorstellungsbild.",
    "Clear and reasonably vivid, comparable to actual viewing.": "Klar und ziemlich lebendig, vergleichbar mit realem Betrachten.",
    "Perfectlys clear and as vivid as normal vision.": "Vollkommen klar und so lebendig wie tatsächliches reales Sehen.",
    "Question %1 of 16": "Frage %1 von 16",
    "%1% Completed": "%1% Abgeschlossen",
    "Rate the vividness of the image in your mind's eye:": "Bewerten Sie die Lebendigkeit des Bildes vor Ihrem inneren Auge:",
    "Previous Item": "Vorherige Frage",

    # --- VVIQ Classifications ---
    "Total Aphantasia": "Vollständige Afantasie",
    "Congenital / Marked Aphantasia": "Ausgeprägte / Angeborene Afantasie",
    "Hypophantasia (Weak Imagery)": "Hypofantasie (Geringe Vorstellungskraft)",
    "Typical Imagery Vividness": "Typische Vorstellungskraft",
    "Hyperphantasia (Extreme Imagery)": "Hyperfantasie (Extreme Vorstellungskraft)",
    "You scored 16 out of 80 points. According to established scientific consensus (Dance et al. 2022; Zeman et al. 2015, 2020), this corresponds to complete / total aphantasia. You process visual concepts abstractly and semantically without voluntary internal visual representations.": "Sie haben 16 von 80 Punkten erreicht. Nach dem wissenschaftlichen Konsens (Dance et al. 2022; Zeman et al. 2015, 2020) entspricht dies einer vollständigen Afantasie. Sie verarbeiten visuelle Konzepte abstrakt und semantisch ohne willentliche innere Bilder.",
    "You scored %1 out of 80 points. Scores below 32 are classified in scientific literature as marked aphantasia (Dance et al. 2022). While occasional fleeting flashes or faint silhouettes may occur, voluntary visual reconstruction is severely attenuated.": "Sie haben %1 von 80 Punkten erreicht. Punktwerte unter 32 werden in der Fachliteratur als ausgeprägte Afantasie klassifiziert (Dance et al. 2022). Während gelegentliche flüchtige Eindrücke auftreten können, ist eine willentliche visuelle Rekonstruktion stark gehemmt.",
    "You scored %1 out of 80 points. This falls into the hypophantasia range (32-54 points). You have partial or dim voluntary mental imagery, with noticeable variation in clarity, detail, or stability across different scenarios.": "Sie haben %1 von 80 Punkten erreicht. Dies fällt in den Bereich der Hypofantasie (32-54 Punkte). Sie verfügen über eine teilweise oder trübe Vorstellungskraft mit spürbaren Schwankungen in Klarheit und Stabilität.",
    "You scored %1 out of 80 points. This represents the typical / normal range of human visual imagination (55-74 points, population mean ~56.8), characterized by clear and reasonably vivid mental pictures.": "Sie haben %1 von 80 Punkten erreicht. Dies entspricht dem typischen Durchschnittsbereich menschlicher Vorstellungskraft (55-74 Punkte, Mittelwert ~56,8) mit klaren inneren Bildern.",
    "You scored %1 out of 80 points. Scores of 75 and above denote hyperphantasia (Zeman et al. 2020), an imagery capability that is as vivid, sharp, and rich in color as real-world ocular perception.": "Sie haben %1 von 80 Punkten erreicht. Werte ab 75 bezeichnen eine Hyperfantasie (Zeman et al. 2020) – eine Vorstellungskraft, die so scharf, detailreich und farbintensiv ist wie reales Sehen.",

    # --- Multisensory Profiling ---
    "Auditory (Inner Hearing)": "Auditorisch (Inneres Hören)",
    "Imagine hearing the clear sound of a familiar friend's laugh or a ringing telephone.": "Stellen Sie sich den klaren Klang des Lachens einer befreundeten Person oder eines Telefonklingelns vor.",
    "Tactile (Touch & Texture)": "Taktil (Berührung & Oberflächen)",
    "Imagine running your fingertips over coarse sandpaper or touching warm velvet fabric.": "Stellen Sie sich vor, mit den Fingerspitzen über raues Schleifpapier oder warmen Samtstoff zu streichen.",
    "Kinesthetic (Motor & Balance)": "Kinästhetisch (Bewegung & Körpersinn)",
    "Imagine the physical sensation in your legs and lungs when running up a flight of stairs.": "Stellen Sie sich das körperliche Gefühl in Beinen und Lunge beim Hinaufrennen einer Treppe vor.",
    "Olfactory (Smell)": "Olfaktorisch (Geruch)",
    "Imagine the distinctive aroma of fresh ground coffee or ozone after rain.": "Stellen Sie sich den intensiven Duft von frisch gemahlenem Kaffee oder Ozon nach einem Sommerregen vor.",
    "Gustatory (Taste)": "Gustatorisch (Geschmack)",
    "Imagine the intense taste of biting into a fresh sour lemon slice.": "Stellen Sie sich den intensiven Geschmack vor, in eine frische, saure Zitronenscheibe zu beißen.",
    "Emotional (Affective Bodily Sensation)": "Emotional (Körperliche Gefühlsempfindung)",
    "Imagine the somatic bodily feeling of sudden joyous excitement or profound calm.": "Stellen Sie sich das körperliche Empfinden plötzlicher freudiger Erregung oder tiefer Ruhe vor.",
    "Step 3: Multi-Sensory Profiling (Dawes et al. 2024)": "Schritt 3: Multisensorisches Profiling (Dawes et al. 2024)",
    "Assessing non-visual modalities to identify whether aphantasia is unimodal (visual-only) or multisensory.": "Prüfung nicht-visueller Sinneskanäle zur Bestimmung, ob die Afantasie unimodal (rein visuell) oder multisensorisch ausgeprägt ist.",
    "Generate Assessment Summary & Baseline Profile →": "Auswertungsbericht & Ausgangsprofil erstellen →",
    "Typical Multi-Modal Profile": "Typisches multi-modales Profil",
    "Unimodal Visual Aphantasia": "Unimodale visuelle Afantasie",
    "Multisensory Aphantasia": "Multisensorische Afantasie",
    "Your visual imagery is in the typical or hypophantasia range. Your multi-modal sensory profile shows normal cross-sensory imagination.": "Ihre visuelle Vorstellungskraft liegt im typischen Bereich oder im Bereich der Hypofantasie. Ihr Sinnesprofil zeigt normale Fähigkeiten.",
    "Based on Dawes et al. (2024), your results indicate Unimodal Visual Aphantasia. Your lack of imagery is selective to the visual modality, while non-visual channels (such as hearing, touch, or motor simulation) remain functional and provide excellent anchors for neurocognitive training.": "Gemäß Dawes et al. (2024) weisen Ihre Ergebnisse auf eine Unimodale Visuelle Afantasie hin. Die verminderte Vorstellungskraft betrifft rein den visuellen Kanal, während Hören, Tasten oder Motorik intakt sind und ideale Ankerpunkte für das Training bieten.",
    "Based on Dawes et al. (2024), your results indicate Multisensory Aphantasia. Your imagery reduction spans multiple sensory domains beyond vision. Training protocols will begin with semantic, proprioceptive, and physiological afterimage stimuli rather than auditory or sensory pegs.": "Gemäß Dawes et al. (2024) weisen Ihre Ergebnisse auf eine Multisensorische Afantasie hin. Die reduzierte Vorstellungskraft erstreckt sich über mehrere Sinne. Das Training setzt daher primär auf semantische, propriozeptive und physiologische Nachbildreize.",

    # --- Assessment Report ---
    "out of 80": "von 80 Punkten",
    "Percentile: %1%": "Prozentrang: %1%",
    "Cross-Sensory Modality Profile (Scale 1 to 5)": "Sinnesmodalitäten-Profil (Skala 1 bis 5)",
    "Visual (VVIQ)": "Visuell (VVIQ)",
    "Auditory": "Auditorisch (Hören)",
    "Tactile": "Taktil (Fühlen)",
    "Kinesthetic": "Kinästhetisch (Motorik)",
    "Olfactory": "Olfaktorisch (Riechen)",
    "Gustatory": "Gustatorisch (Schmecken)",
    "Emotional": "Emotional (Körpergefühl)",
    "Start 6-Week Functional Training →": "6-Wochen-Training starten →",
    "Download Participant Data": "Teilnehmerdaten herunterladen",
    "Retake Test": "Test wiederholen",

    # --- Breathing Pacer ---
    "Inhale": "Einatmen",
    "Hold": "Halten",
    "Exhale": "Ausatmen",
    "Remaining: %1:%2": "Verbleibend: %1:%2",

    # --- Afterimage Viewer ---
    "Fixate strictly on center dot: %1s": "Fixieren Sie strikt den Mittelpunkt: %1s",
    "Close Your Eyes Now": "Schließen Sie jetzt die Augen",
    "Observe the retinal afterimage on your dark visual field.\nNote its shape, complementary colors, and contour stability.": "Beobachten Sie das retinale Nachbild auf Ihrem dunklen Sehfeld.\nAchten Sie auf Form, Komplementärfarben und Umrissstabilität.",
    "Afterimage Faded (Log %1s)": "Nachbild verblasst (%1s protokollieren)",
    "Restart Fixation": "Fixierung neustarten",

    # --- Mental Rotation Viewer ---
    "Rotation: %1°": "Rotation: %1°",
    "Pause Spin": "Rotation anhalten",
    "Auto Spin": "Auto-Drehung",
    "Switch to 2D": "Zu 2D wechseln",
    "Switch to 3D": "Zu 3D wechseln",

    # --- Layer Assembly Viewer ---
    "1. Outline": "1. Umriss",
    "2. Color": "2. Farbe",
    "3. Texture": "3. Textur",
    "4. Light": "4. Licht",

    # --- Training Dashboard ---
    "6-Week Functional Imagery Training (FIT)": "6-Wochen Functional Imagery Training (FIT)",
    "15 MIN/DAY": "15 MIN/TAG",
    "Rhodes et al. (2024) protocol: Neuroplastic scaffolding curriculum adapted for aphantasic cognition.": "Protokoll nach Rhodes et al. (2024): Neuroplastisches Scaffolding-Curriculum, angepasst an afantasische Kognition.",
    "Completed: %1 / 42 Sessions": "Abgeschlossen: %1 / 42 Einheiten",
    "Streak: %1 Days": "Serie: %1 Tage",
    "Launch Today's Session\n(Week %1, Day %2) →": "Heutige Einheit starten\n(Woche %1, Tag %2) →",
    "Curriculum Schedule & Modules:": "Curriculum-Ablauf & Module:",
    "Day %1": "Tag %1",

    # --- Training Weeks Overview ---
    "Week 1: Multi-Modal Anchoring & Sensory Scaffolding": "Woche 1: Multisensorische Verankerung & Scaffolding",
    "Building non-visual mental anchors through touch, sound, and spatial proprioception.": "Aufbau nicht-visueller mentaler Anker durch Tastsinn, Klang und räumliche Propriozeption.",
    "Rhodes et al. (2024); Dawes et al. (2024); Kelly (2020)": "Rhodes et al. (2024); Dawes et al. (2024); Kelly (2020)",
    "Week 2: High-Contrast Forms & Negative Afterimages": "Woche 2: Kontrastreiche Formen & Negative Nachbilder",
    "Stimulating the primary visual pathway using retinal excitation and conscious stabilization.": "Stimulation der primären visuellen Leitungsbahnen durch retinale Erregung und Stabilisierung.",
    "Rhodes et al. (2024); Zeman (2024); Keogh & Pearson (2024)": "Rhodes et al. (2024); Zeman (2024); Keogh & Pearson (2024)",
    "Week 3: Component Decomposition & Layered Assembly": "Woche 3: Komponenten-Zerlegung & Schichtweiser Aufbau",
    "Deconstructing objects into discrete cognitive layers: geometry, color, texture, and light.": "Zerlegung von Objekten in kognitive Einzelschichten: Geometrie, Farbe, Textur und Licht.",
    "Monzel (2025); Rhodes et al. (2024)": "Monzel (2025); Rhodes et al. (2024)",
    "Week 4: Spatial Transformation & Mental Rotation": "Woche 4: Räumliche Transformation & Mentale Rotation",
    "Developing dynamic visual-spatial manipulation, perspective shifting, and 3D mental rotation.": "Entwicklung visuell-räumlicher Manipulation, Perspektivwechsel und 3D-Mentalrotation.",
    "Shepard & Metzler (1971); Monzel (2021); Zeman (2024)": "Shepard & Metzler (1971); Monzel (2021); Zeman (2024)",
    "Week 5: Affective & Dynamic Scene Synthesis": "Woche 5: Affektive & Dynamische Szenensynthese",
    "Leveraging emotional valence, autobiographical memory, and rich multi-sensory integration.": "Nutzung emotionaler Valenz, autobiografischer Erinnerungen und multisensorischer Integration.",
    "Rhodes et al. (2024); Wicken et al. (2021)": "Rhodes et al. (2024); Wicken et al. (2021)",
    "Week 6: Real-World Integration & Maintenance": "Woche 6: Alltagsintegration & Nachhaltigkeit",
    "Applying mental imagery strategies to daily memory, motor execution, and longitudinal tracking.": "Anwendung mentaler Vorstellungsstrategien auf Gedächtnis, Handlungsplanung und Re-Test.",
    "Rhodes et al. (2024); Kelly (2020); Marks (1973)": "Rhodes et al. (2024); Kelly (2020); Marks (1973)",

    # --- Training Session Player ---
    "Exit Session": "Einheit verlassen",
    "1. Breath Calibration (2m)": "1. Atemkalibrierung (2m)",
    "2. Guided Exercise (8m)": "2. Angeleitete Übung (8m)",
    "3. Reflection & Rating (2m)": "3. Reflexion & Bewertung (2m)",
    "Proceed to Exercise (Phase 2) →": "Weiter zur Übung (Phase 2) →",
    "Scientific Basis: %1": "Wissenschaftliche Grundlage: %1",
    "Guided Neurocognitive Contemplation": "Angeleitete neurokognitive Kontemplation",
    "Close your eyes or soften your gaze. Work through the step-by-step instructions above. Avoid forcing mental imagery; focus attentively on physical textures, spatial orientations, or somatic feelings.": "Schließen Sie die Augen oder richten Sie den Blick ins Leere. Folgen Sie den Schritten oben. Erzwingen Sie keine Bilder; fokussieren Sie auf Texturen, räumliche Orientierung oder Körperempfindungen.",
    "Exercise Time Remaining: %1:%2": "Verbleibende Übungszeit: %1:%2",
    "Pause": "Pause",
    "Resume": "Fortsetzen",
    "Proceed to Reflection (Phase 3) →": "Weiter zur Reflexion (Phase 3) →",
    "1. How vivid, stable, or clear was your mental experience today?": "1. Wie lebendig, stabil oder klar war Ihr inneres Erleben heute?",
    "1: No sensation": "1: Keine Empfindung",
    "2: Dim / Vague": "2: Trüb / Vage",
    "3: Moderate": "3: Mäßig",
    "4: Clear / Vivid": "4: Klar / Lebendig",
    "5: Lifelike": "5: Lebensecht",
    "2. Sensory Reflection & Modality Notes:": "2. Sensorische Reflexion & Notizen:",
    "Which sensory anchor felt most effective (e.g. tactile coldness, spatial coordinates, acoustic echo, word facts)?": "Welcher Sinnesanker war am effektivsten (z.B. taktile Kälte, Raumkoordinaten, akustisches Echo, Wortwissen)?",
    "Enter your observations here...": "Tragen Sie hier Ihre Beobachtungen ein...",
    "Save Session & Complete Day %1 ✓": "Einheit speichern & Tag %1 abschließen ✓",
    "Phase 1: Calibrating Breath & Relaxation": "Phase 1: Atemkalibrierung & Entspannung",
    "Phase 3: Self-Rating & Sensory Reflection": "Phase 3: Selbstbewertung & Sinnesreflexion",
    "Find a comfortable seated position with upright spine. Inhale deeply for 4 seconds as the circle expands, hold for 4 seconds, exhale smoothly for 4 seconds as it contracts, and hold for 4 seconds. Let extraneous muscular tension release with each breath cycle.": "Nehmen Sie eine aufrechte, bequeme Haltung ein. Atmen Sie 4 Sekunden lang tief ein, während der Kreis wächst, halten Sie 4 Sekunden, atmen Sie 4 Sekunden ruhig aus und halten Sie 4 Sekunden. Lassen Sie muskuläre Anspannung mit jedem Atemzug los.",
    "Rate the vividness or stability of your experience today on a 1-5 scale. Note down which sensory modality (tactile, spatial, auditory, semantic) felt most accessible and anchored your mental representation.": "Bewerten Sie die Lebendigkeit oder Stabilität auf einer Skala von 1-5. Notieren Sie, welcher Sinneskanal (taktil, räumlich, akustisch, semantisch) Ihre innere Repräsentation am besten verankert hat.",
    "Week %1, Day %2 • %3": "Woche %1, Tag %2 • %3",
    "Logged afterimage duration: %1s": "Protokollierte Nachbilddauer: %1s",

    # --- Data Ethics Modal ---
    "Data Sovereignty & Export Center": "Datensouveränität & Export-Zentrum",
    "Your data belongs exclusively to you. All assessments, VVIQ scores, and daily training logs are stored strictly inside your browser's private local sandbox. No data is ever transmitted to remote servers.": "Ihre Daten gehören ausschließlich Ihnen. Sämtliche Testergebnisse, VVIQ-Werte und Trainingsprotokolle verbleiben in der lokalen Sandbox Ihres Browsers und werden niemals an Server übertragen.",
    "Export Participant Records:": "Teilnehmerdaten exportieren:",
    "Download JSON (.json)": "JSON herunterladen (.json)",
    "Download CSV (.csv)": "CSV herunterladen (.csv)",
    "Erase All Local Participant Data": "Alle lokalen Teilnehmerdaten löschen",
    "Clear All Data": "Alle Daten löschen",
    "Are you sure? This will irreversibly delete all your test scores and training logs from this browser.": "Sind Sie sicher? Dies löscht alle Testergebnisse und Trainingsprotokolle unwiderruflich aus diesem Browser.",
    "Yes, Permanently Delete All Data": "Ja, alle Daten unwiderruflich löschen",
    "Cancel": "Abbrechen",

    # --- Progress View & Chart ---
    "Longitudinal Progress & Training Metrics": "Langzeit-Verlauf & Trainingsmetriken",
    "Track your mental imagery trajectory, daily micro-session ratings, and baseline comparison.": "Verfolgen Sie Ihre Vorstellungskraft, tägliche Bewertungen und den Vergleich zur Ausgangsmessung.",
    "Export Data": "Daten exportieren",
    "Training Ratings & Adherence Timeline": "Bewertungsverlauf & Trainingsadhärenz",
    "Total Logged: %1 micro-sessions": "Insgesamt erfasst: %1 Trainingseinheiten",
    "No training sessions completed yet.": "Noch keine Trainingseinheiten abgeschlossen.",
    "Complete your first 15-minute session to begin longitudinal tracking.": "Schließen Sie Ihre erste 15-minütige Einheit ab, um den Verlauf zu starten.",
    "Baseline VVIQ": "Ausgangswert VVIQ",
    "Not taken": "Nicht durchgeführt",
    "Current Curriculum Progress": "Aktueller Trainingsstand",
    "Week %1, Day %2": "Woche %1, Tag %2",
    "Adherence Streak": "Regelmäßigkeit",
    "%1 Days": "%1 Tage",
    "Standardized Evaluation Log (VVIQ & Apple Test)": "Protokoll der standardisierten Tests (VVIQ & Apfel-Test)",
    "Apple Test: Level %1": "Apfel-Test: Stufe %1",
    "VVIQ Score: %1 / 80": "VVIQ-Wert: %1 / 80",
    "%1% Rank": "%1% Rang",
    "No baseline assessment recorded yet. Launch the Assessment tab to complete your initial evaluation.": "Bislang kein Ausgangstest erfasst. Starten Sie im Reiter 'Erfassung', um Ihre Basismessung durchzuführen.",

    # --- About View ---
    "The gold-standard 16-item self-report questionnaire for voluntary visual mental imagery vividness.": "Der 16-Item-Goldstandard-Fragebogen zur Erfassung der willentlichen visuellen Vorstellungskraft.",
    "Formally established the term Aphantasia and standardized VVIQ classification.": "Etablierte den Fachbegriff Afantasie und standardisierte die VVIQ-Klassifikation.",
    "Established standard population norms: scores < 32 indicate marked aphantasia (score 16 = total aphantasia); population mean = 56.8.": "Etablierte Populationsnormen: Werte < 32 zeigen Afantasie an (Wert 16 = vollständige Afantasie; Mittelwert = 56,8).",
    "Established hyperphantasia threshold (75-80 pts) and frontoparietal-occipitotemporal neuroplastic connectivity model.": "Etablierte den Hyperfantasie-Schwellenwert (75-80 Pkt.) und das frontoparietal-okzipitotemporale Konnektivitätsmodell.",
    "Demonstrated that aphantasia can be unimodal (visual only) or multisensory (multi-modal attenuation).": "Wies nach, dass Afantasie unimodal (rein visuell) oder multisensorisch (mehrere Sinne betreffend) auftreten kann.",
    "Psychophysical binocular rivalry priming proving aphantasia is a genuine sensory absence rather than metacognitive bias.": "Psychophysikalisches Priming (Binokulare Rivalität) belegt, dass Afantasie ein echtes sensorisches Phänomen ist.",
    "Foundational basis for 6-week curriculum: demonstrated that structured Functional Imagery Training significantly increases imagery capacity.": "Grundlage des 6-Wochen-Trainings: Belegte, dass Functional Imagery Training (FIT) die Vorstellungskraft signifikant steigert.",
    "Exhaustive synthesis of cognitive compensation strategies: propositional networks, spatial models, and dual-coding.": "Umfassende Dissertation über kognitive Kompensationsstrategien: propositionale Netzwerke und Spatial-Scaffolding.",
    "Download Participant Data (JSON / CSV)": "Teilnehmerdaten herunterladen (JSON / CSV)",
    "View Public Source Code on GitHub ↗": "Öffentlichen Quellcode auf GitHub ansehen ↗",
    "• <b>Research Use Only:</b> This application is developed strictly for research, self-exploration, and educational study. It is <b>not a medical device</b> and does not diagnose, treat, or prevent clinical psychological conditions.<br><br>• <b>Data Sovereignty:</b> Operates 100% local-first. All scores, responses, and session notes stay in your private browser sandbox (IndexedDB / localStorage) and are never automatically transmitted to any server.<br><br>• <b>User Portability:</b> You may download your entire dataset anytime in standardized JSON or CSV format, or permanently erase it with one click.": "• <b>Ausschließlich zu Forschungszwecken:</b> Diese Anwendung dient rein wissenschaftlicher Selbsterkundung und Bildungszwecken. Sie ist <b>kein Medizinprodukt</b> und stellt keine klinischen Diagnosen.<br><br>• <b>Datensouveränität:</b> Arbeitet 100% lokal. Alle Testergebnisse und Notizen verbleiben in der privaten Browser-Sandbox und werden niemals übertragen.<br><br>• <b>Datenportabilität:</b> Sie können Ihren Datensatz jederzeit als standardisiertes JSON oder CSV exportieren oder mit einem Klick löschen.",

    # --- Legal & Qt GPLv3 Licensing ---
    "Scientific Basis & Research Ethics": "Wissenschaftliche Grundlagen & Forschungsethik",
    "Open-science platform combining validated psychometrics, neurocognitive training, and GPLv3 open source.": "Open-Science-Plattform, die validierte Psychometrie, neurokognitives Training und GPLv3-Open-Source vereint.",
    "Ethics & Research Declaration": "Ethik- & Forschungserklärung",
    "Core Scientific Publications & Theoretical Foundations": "Wesentliche wissenschaftliche Publikationen & theoretische Grundlagen",
    "Qt Framework & Open Source Licensing (GNU GPLv3)": "Qt-Framework & Open-Source-Lizenzierung (GNU GPLv3)",
    "WebAssembly Static Linking & Copyright Compliance": "Statische Bindung in WebAssembly & Urheberrechts-Konformität",
    "• <b>GNU General Public License v3.0:</b> Phantasia is free, open-source software licensed under the GNU General Public License version 3 (GPLv3).<br><br>• <b>Qt Framework & Static Linking:</b> This application is built with the Qt 6 framework (Qt Quick, Qt Quick Controls 2, Qt QML, Qt Gui, Qt Core). In the WebAssembly build running in the browser, all Qt libraries and C++ application modules are statically linked into a single WebAssembly binary (<code>appQtAphantasie.wasm</code>). Statically linking GPLv3 libraries combines them into a single executable work under GPLv3, which Phantasia adheres to in full.<br><br>• <b>Source Code Availability (GPLv3 §6):</b> In accordance with GPLv3 Section 6, the complete machine-readable source code, CMake scripts, assets, and instructions to rebuild and relink the application are freely accessible at <b>https://github.com/mesw/phantasia</b>. Users have the full freedom to inspect, modify, and rebuild the application, or relink it with modified Qt versions.<br><br>• <b>Trademark & Copyright:</b> Qt is a registered trademark of The Qt Company Ltd. and its subsidiaries. Qt is copyright © The Qt Company Ltd. and other contributors.<br><br>• <b>Third-Party Assets:</b> Noto Color Emoji font is copyright © Google LLC and licensed under the SIL Open Font License 1.1. PeakFrequency breathing pacer is developed by mesw under MIT/Open Access.<br><br>• <b>Disclaimer of Warranty (GPLv3 §§ 15 & 16):</b> This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for details.": "• <b>GNU General Public License v3.0:</b> Phantasia ist freie Open-Source-Software, lizenziert unter der GNU General Public License Version 3 (GPLv3).<br><br>• <b>Qt-Framework & statische Bindung:</b> Diese Anwendung basiert auf dem Qt 6-Framework (Qt Quick, Qt Quick Controls 2, Qt QML, Qt Gui, Qt Core). Im im Browser ausgeführten WebAssembly-Build sind alle Qt-Bibliotheken und C++-Anwendungsmodule statisch in eine einzige WebAssembly-Binärdatei (<code>appQtAphantasie.wasm</code>) eingebunden. Das statische Binden von GPLv3-Bibliotheken verbindet diese zu einem gemeinsamen Werk unter der GPLv3, der Phantasia vollständig unterliegt.<br><br>• <b>Verfügbarkeit des Quellcodes (GPLv3 §6):</b> Gemäß GPLv3 Abschnitt 6 sind der vollständige maschinenlesbare Quellcode, CMake-Build-Skripte, Ressourcen und Anleitungen zum Neukompilieren und Relinken öffentlich frei zugänglich unter <b>https://github.com/mesw/phantasia</b>. Nutzer besitzen die Freiheit, die Software zu prüfen, zu modifizieren und mit angepassten Qt-Versionen neu zu linken.<br><br>• <b>Marken & Urheberrecht:</b> Qt ist eine eingetragene Marke der The Qt Company Ltd. und ihrer Tochtergesellschaften. Qt ist urheberrechtlich geschützt © The Qt Company Ltd. und andere Mitwirkende.<br><br>• <b>Ressourcen Dritter:</b> Die Schriftart Noto Color Emoji steht unter der SIL Open Font License 1.1 (Copyright © Google LLC). Der PeakFrequency-Resonanzatemer wird von mesw unter MIT/Open Access bereitgestellt.<br><br>• <b>Gewährleistungsausschluss (GPLv3 §§ 15 & 16):</b> Die Veröffentlichung dieses Programms erfolgt in der Hoffnung, dass es von Nutzen sein wird, aber OHNE IRGENDEINE GARANTIE, sogar ohne die implizite Garantie der MARKTREIFE oder der VERWENDBARKEIT FÜR EINEN BESTIMMTEN ZWECK. Details siehe GNU General Public License.",
    "View Full GPLv3 License Text": "Vollständigen GPLv3-Lizenztext ansehen",
    "Qt Licensing Terms ↗": "Qt-Lizenzbestimmungen ↗",
    "GNU GPLv3 Official Text ↗": "Offizieller GNU GPLv3-Text ↗",
    "Open Source & Qt Framework License (GPLv3):": "Open-Source- & Qt-Framework-Lizenz (GPLv3):",
    "Phantasia is free software released under the GNU General Public License v3.0 (GPLv3). It incorporates the Qt 6 Toolkit (The Qt Company Ltd.) which is statically linked in the WebAssembly application binary. In compliance with GPLv3 Section 6, full source code and build instructions are publicly available on GitHub.": "Phantasia ist freie Software, veröffentlicht unter der GNU General Public License v3.0 (GPLv3). Sie enthält das Qt 6 Toolkit (The Qt Company Ltd.), das in der WebAssembly-Anwendungsbinärdatei statisch gebunden ist. Gemäß GPLv3 Abschnitt 6 sind der vollständige Quellcode und die Build-Anleitungen öffentlich auf GitHub verfügbar.",
    "License (GPLv3)": "Lizenz (GPLv3)",
    "Close Dialog": "Dialog schließen",
    "GNU General Public License v3.0 (GPLv3)": "GNU General Public License v3.0 (GPLv3)",
    "Qt Toolkit & WebAssembly Static Linking Compliance": "Qt Toolkit & WebAssembly-Konformität bei statischer Bindung",
    "Close License Dialog": "Lizenzdialog schließen",
    "Open Source Static Linking Disclosure & Legal Compliance:": "Offenlegung der statischen Open-Source-Bindung & rechtliche Konformität:",
    "• <b>Qt Framework:</b> This application is built with the Qt 6 Toolkit (The Qt Company Ltd.) under the GNU General Public License v3.0.<br>• <b>Static Linking:</b> In WebAssembly, Qt libraries and C++ application code are compiled into a unified binary (<code>appQtAphantasie.wasm</code>). As a statically linked work under GPLv3, Phantasia is released in its entirety under GPLv3.<br>• <b>Source Availability (GPLv3 §6):</b> Full source code, build scripts, and relinking recipes are freely available at <b>https://github.com/mesw/phantasia</b>.<br>• <b>Trademarks:</b> Qt is a registered trademark of The Qt Company Ltd. and its subsidiaries.": "• <b>Qt-Framework:</b> Diese Anwendung basiert auf dem Qt 6 Toolkit (The Qt Company Ltd.) unter der GNU General Public License v3.0.<br>• <b>Statische Bindung:</b> In WebAssembly sind Qt-Bibliotheken und C++-Code zu einer einheitlichen Binärdatei (<code>appQtAphantasie.wasm</code>) kompiliert. Als statisch gebundenes Werk unter der GPLv3 wird Phantasia vollständig unter der GPLv3 veröffentlicht.<br>• <b>Verfügbarkeit des Quellcodes (GPLv3 §6):</b> Vollständiger Quellcode, Build-Skripte und Anleitungen zum Relinken stehen frei auf <b>https://github.com/mesw/phantasia</b> zur Verfügung.<br>• <b>Marken:</b> Qt ist eine eingetragene Marke der The Qt Company Ltd. und ihrer Tochtergesellschaften.",
    "GNU GPLv3 (gnu.org) ↗": "GNU GPLv3 (gnu.org) ↗",
    "GitHub Repository ↗": "GitHub-Repository ↗",
    "Close": "Schließen",
    "Level %1: %2": "Stufe %1: %2",
    "← Previous Item": "← Vorheriges Item",
}

def translate_file(input_path, output_path, lang):
    tree = ET.parse(input_path)
    root = tree.getroot()

    translated_count = 0
    missing_count = 0

    for context in root.findall('context'):
        for msg in context.findall('message'):
            src = msg.find('source')
            if src is None or not src.text:
                continue
            src_text = src.text
            trans = msg.find('translation')
            if trans is None:
                trans = ET.SubElement(msg, 'translation')

            if lang == "de":
                if src_text in translations_de:
                    trans.text = translations_de[src_text]
                    if 'type' in trans.attrib:
                        del trans.attrib['type']
                    translated_count += 1
                else:
                    # Fallback / partial heuristic
                    trans.text = src_text
                    trans.attrib['type'] = 'unfinished'
                    missing_count += 1
            else: # en
                trans.text = src_text
                if 'type' in trans.attrib:
                    del trans.attrib['type']
                translated_count += 1

    tree.write(output_path, encoding='utf-8', xml_declaration=True)
    print(f"[{lang}] Generated {output_path}: {translated_count} translated, {missing_count} unfinished")

def main():
    base_dir = os.path.dirname(os.path.abspath(__file__))
    ts_de = os.path.join(base_dir, 'aphantasia_de.ts')
    ts_en = os.path.join(base_dir, 'aphantasia_en.ts')

    translate_file(ts_de, ts_de, "de")
    translate_file(ts_en, ts_en, "en")

    # Run lrelease to compile .qm files
    lrelease_path = r"C:\Qt\6.8.3\mingw_64\bin\lrelease.exe"
    if os.path.exists(lrelease_path):
        qm_de = os.path.join(base_dir, 'aphantasia_de.qm')
        qm_en = os.path.join(base_dir, 'aphantasia_en.qm')
        subprocess.run([lrelease_path, ts_de, '-qm', qm_de], check=True)
        subprocess.run([lrelease_path, ts_en, '-qm', qm_en], check=True)
        print("Compiled .qm catalogs successfully.")
        
        # Also copy to root translations/ directory
        root_trans = os.path.join(base_dir, '..', '..', 'translations')
        if os.path.exists(root_trans):
            import shutil
            for f in ['aphantasia_de.ts', 'aphantasia_en.ts', 'aphantasia_de.qm', 'aphantasia_en.qm']:
                shutil.copy2(os.path.join(base_dir, f), os.path.join(root_trans, f))
            print("Copied translation files to root translations/ directory.")

if __name__ == '__main__':
    main()
