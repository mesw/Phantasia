import json
import xml.etree.ElementTree as ET
import subprocess
import os

day_translations = {
    # Day 1
    "Day 1: Tactile Blueprinting": "Tag 1: Taktiles Blueprinting",
    "Physical-to-mental tactile transfer using familiar textured objects.": "Taktiler Transfer vom Realobjekt ins mentale Erleben anhand vertrauter Texturen.",
    "Hold a textured physical object (e.g. a coin, a key, or an embossed stone) in your hand. Feel its edges, ridges, and surface temperature with your fingertips for 60 seconds with eyes open. Then close your eyes. Reconstruct purely the tactile sensations: the metallic coldness, the sharp ridges, the weight in your palm. Do not force any visual picture. Focus 100% on tactile proprioception.": "Halten Sie einen strukturierten Gegenstand (Münze, Schlüssel, Stein) 60 Sekunden lang in der Hand. Ertasten Sie Kanten, Rillen und Temperatur bei offenen Augen. Schließen Sie dann die Augen. Rekonstruieren Sie rein das taktile Empfinden: die metallische Kühle, die Riefen, das Gewicht in der Handfläche. Erzwingen Sie kein visuelles Bild. Konzentrieren Sie sich zu 100% auf die taktile Propriozeption.",
    "Anchoring conceptual models in intact somatosensory cortices builds top-down frontoparietal scaffolding (Dawes et al. 2024; Kelly 2020).": "Die Verankerung in intakten somatosensorischen Arealen bildet ein neuronales Gerüst über frontoparietale Netzwerke (Dawes et al. 2024; Kelly 2020).",

    # Day 2
    "Day 2: Spatial Coordinate Mapping": "Tag 2: Räumliche Koordinatenkartierung",
    "Constructing a 3x3 mental coordinate grid without visual rendering.": "Aufbau eines mentalen 3x3-Koordinatenrasters ohne bildhafte Visualisierung.",
    "Mentally construct a 3x3 grid in the space directly before your chest. Assign objects to positions: Top-Left = Book, Center = Water Glass, Bottom-Right = Key. Mentally reach toward each position, feeling the physical spatial distance and coordinates. Move between positions without requiring a picture.": "Konstruieren Sie mental ein 3x3-Gitter im Raum vor Ihrer Brust. Weisen Sie Positionen Objekte zu: Oben-Links = Buch, Mitte = Wasserglas, Unten-Rechts = Schlüssel. Greifen Sie mental nach jeder Position und spüren Sie die räumliche Distanz und Richtung, ohne ein Bild zu benötigen.",
    "Visuospatial working memory and egocentric spatial coordinates operate independently of visual imagery vividness (Monzel 2025; Jacobs et al. 2018).": "Visuoräumliches Arbeitsgedächtnis und egozentrische Koordinaten arbeiten unabhängig von visueller Bildhaftigkeit (Monzel 2025; Jacobs et al. 2018).",

    # Day 3
    "Day 3: Acoustic Resonance Anchors": "Tag 3: Akustische Resonanz-Anker",
    "Recalling auditory pitch, timbre, and rhythm as mental anchors.": "Abruf von Tonhöhe, Klangfarbe und Rhythmus als mentale Gedächtnisanker.",
    "Focus on a specific acoustic event: the rhythmic ticking of a clock, raindrops pattering on a window, or a familiar doorbell. Replay the sound in your mind with exact timing, pitch, and timbre. Notice the spatial direction from which the sound originates.": "Fokussieren Sie ein bestimmtes Geräusch: das Ticken einer Uhr, Regentropfen am Fenster oder eine Türklingel. Spielen Sie den Klang im Geist mit exaktem Timing, Tonhöhe und Klangfarbe ab. Achten Sie auf die räumliche Richtung.",
    "Dawes et al. (2024) demonstrated that auditory imagery is preserved in unimodal aphantasics and can prime visual association networks.": "Dawes et al. (2024) zeigten, dass auditorische Vorstellungskraft bei unimodaler Aphantasie intakt ist und Assoziationsareale bahnen kann.",

    # Day 4
    "Day 4: Thermal & Weight Invariance": "Tag 4: Thermische & Schwere-Invarianz",
    "Synthesizing physical mass and thermal contrast internally.": "Mentale Synthese von physikalischer Masse und thermischem Kontrast.",
    "Imagine holding an ice cube in your left hand and a warm ceramic mug of tea in your right hand. Alternate your mental attention between the intense cold melting in your left palm and the soothing radiant heat warming your right fingers.": "Stellen Sie sich vor, in der linken Hand einen Eiswürfel und in der rechten eine warme Keramiktasse Tee zu halten. Wechseln Sie die Aufmerksamkeit zwischen der schmelzenden Kälte links und der wohligen Wärme rechts.",
    "Somatosensory integration activates insular and parietal neural pathways that strengthen subsequent multi-modal imagery (Rhodes et al. 2024).": "Somatosensorische Integration aktiviert insuläre und parietale Pfade, die spätere multisensorische Vorstellungen stärken (Rhodes et al. 2024).",

    # Day 5
    "Day 5: Semantic Feature Association": "Tag 5: Semantische Merkmalsassoziation",
    "Propositional attribute matrices for object reconstruction.": "Propositionale Eigenschaftsmatrizen zur mentalen Objektrekonstruktion.",
    "Choose an everyday object (e.g., an apple). Do not try to visualize it immediately. Instead, systematically list its propositional attributes: Shape = spherical with indentations; Material = organic skin; Weight = ~180g; Smell = crisp sweet floral; Sound = sharp crunch. Feel the structural completeness of the concept.": "Wählen Sie ein Alltagsobjekt (z.B. einen Apfel). Versuchen Sie nicht, ihn bildhaft zu sehen, sondern listen Sie propositionale Merkmale auf: Form = kugelähnlich mit Dellen; Schale = glatt; Gewicht = ~180g; Duft = fruchtig; Klang = knackig. Spüren Sie die begriffliche Vollständigkeit.",
    "Monzel (2025) highlights propositional knowledge and semantic networks as the core compensatory cognitive mechanism in aphantasia.": "Monzel (2025) hebt propositionales Wissen und semantische Netzwerke als zentralen kognitiven Kompensationsmechanismus bei Aphantasie hervor.",

    # Day 6
    "Day 6: Dual-Modal Cross-Priming": "Tag 6: Dual-modales Cross-Priming",
    "Simultaneously binding sound and tactile texture.": "Gleichzeitige Verknüpfung von Klang und taktiler Oberflächentextur.",
    "Combine two non-visual modalities: imagine writing on a dry chalkboard with a crisp piece of chalk. Feel the chalk dust and friction on your fingertips while mentally hearing the squeak and tap of the chalk against the slate.": "Verbinden Sie zwei nicht-visuelle Sinne: Stellen Sie sich vor, mit Kreide auf eine Tafel zu schreiben. Spüren Sie die Kreidestaub-Reibung an den Fingerspitzen und hören Sie gleichzeitig das Klacken und Quietschen auf dem Schiefer.",
    "Multi-sensory binding recruits supramodal associative regions in the temporal and parietal lobes (Dawes et al. 2024).": "Multisensorische Bindung rekrutiert supramodale Assoziationsareale in Temporal- und Parietallappen (Dawes et al. 2024).",

    # Day 7
    "Day 7: Week 1 Integration & Restorative Consolidation": "Tag 7: Konsolidierung & Erholung Woche 1",
    "Reviewing non-visual anchors and assessing ease of activation.": "Überprüfung der nicht-visuellen Anker und Bewertung der Abrufbarkeit.",
    "Revisit your strongest anchor from Days 1-6 (tactile, spatial, auditory, or thermal). Spend 8 minutes gently activating this anchor and holding it stable for 30-second intervals. Celebrate the clarity of your non-visual cognitive models.": "Wiederholen Sie Ihren stärksten Anker der Tage 1-6 (taktil, räumlich, akustisch oder thermisch). Halten Sie ihn für 30-Sekunden-Intervalle stabil. Schätzen Sie die Klarheit Ihrer nicht-visuellen Modelle.",
    "Weekly consolidation periods prevent cognitive fatigue and facilitate synaptic consolidation (Rhodes et al. 2024).": "Wöchentliche Konsolidierungsphasen beugen kognitiver Ermüdung vor und fördern synaptische Konsolidierung (Rhodes et al. 2024).",

    # Day 8
    "Day 8: High-Contrast Monochromatic Cross": "Tag 8: Kontrastreiches monochromes Kreuz",
    "Retinal afterimage induction via 30-second fixation.": "Induktion eines retinalen Nachbilds durch 30-sekündige Fixation.",
    "Fixate your gaze strictly upon the small red dot in the center of the high-contrast white cross for exactly 30 seconds. Do not let your eyes wander. When the timer ends and the screen turns black, gently close your eyes. Observe the dark cross / complementary retinal afterimage floating before you. Try to hold its outline steady without blinking.": "Fixieren Sie den kleinen roten Punkt in der Mitte des weißen Kreuzes genau 30 Sekunden lang. Wenn der Bildschirm schwarz wird, schließen Sie sanft die Augen. Beobachten Sie das dunkle Nachbild vor Ihrem inneren Auge und versuchen Sie, seine Kontur stabil zu halten.",
    "Retinal afterimages provide a physiological visual signal to V1/V2, bypassing impaired top-down generation while exercising mental image stabilization (Rhodes et al. 2024).": "Retinale Nachbilder senden ein physiologisches Signal an V1/V2, umgehen die gehemmte Top-Down-Generierung und trainieren die Stabilisierung (Rhodes et al. 2024).",

    # Day 9
    "Day 9: Concentric Rings & Radial Patterns": "Tag 9: Konzentrische Ringe & Radiale Muster",
    "Observing retinal contrast dissipation and edge contours.": "Beobachtung des retinalen Kontrastabbaus und der Kantenkonturen.",
    "Fixate on the center point of the high-contrast alternating black and white rings for 30 seconds. When the timer signals, close your eyes. Notice the concentric rings inverted in brightness. Track how long the geometric edges remain detectable in your visual field.": "Fixieren Sie den Mittelpunkt der schwarz-weißen Ringe 30 Sekunden lang. Schließen Sie danach die Augen. Beobachten Sie die helligkeitsinvertierten Ringe und stoppen Sie, wie lange die geometrischen Kanten sichtbar bleiben.",
    "Concentric high-spatial-frequency patterns maximally stimulate oriented receptive fields in early visual cortex (Hubel & Wiesel; Zeman 2024).": "Muster mit hoher Ortsfrequenz stimulieren orientierungsselektive rezeptive Felder im visuellen Kortex maximal (Hubel & Wiesel; Zeman 2024).",

    # Day 10
    "Day 10: Geometric Silhouette Stabilization": "Tag 10: Stabilisierung geometrischer Silhouetten",
    "Actively holding a fading afterimage in mental focus.": "Aktives Halten eines verblassenden Nachbildes im mentalen Fokus.",
    "Fixate on the high-contrast geometric shape (equilateral triangle) for 30 seconds. Close your eyes. When the afterimage begins to fade, actively mentally reinforce the three vertices: 'Point A at top, Point B bottom-left, Point C bottom-right'. Note whether verbal labelling prolongs the visual sensation.": "Fixieren Sie das Dreieck 30 Sekunden lang. Schließen Sie die Augen. Wenn das Nachbild verblasst, verstärken Sie mental die Eckpunkte: 'Punkt A oben, Punkt B unten links, Punkt C unten rechts'. Prüfen Sie, ob verbale Benennung das Bild verlängert.",
    "Dual-coding (verbal propositional reinforcement coupled with sensory afterimage) enhances attentional persistence (Monzel 2025).": "Duale Kodierung (verbale Verstärkung gekoppelt mit Nachbild) steigert die Aufmerksamkeitspersistenz (Monzel 2025).",

    # Day 11
    "Day 11: Chromatic Complementary Afterimages": "Tag 11: Chromatische Komplementär-Nachbilder",
    "Color-opponent retinal stimulation (Red/Cyan).": "Farbopponente retinale Stimulation (Rot/Cyan).",
    "Fixate upon the saturated red circular disc for 30 seconds. Close your eyes. Observe the complementary cyan/blue-green hue that emerges on the dark visual field. Pay close attention to the hue saturation and the border between the circle and the dark surround.": "Fixieren Sie die rote Kreisscheibe 30 Sekunden lang. Schließen Sie die Augen. Beobachten Sie den komplementären cyan-türkisen Farbton, der auf dem dunklen Feld entsteht. Achten Sie auf Farbsättigung und Begrenzung.",
    "Color-opponent retinal ganglion cells create vivid complementary afterimages that activate chromatic processing pathways in area V4.": "Farbopponente Ganglienzellen erzeugen Komplementärnachbilder, die chromatische Verarbeitungspfade in Areal V4 ansprechen.",

    # Day 12
    "Day 12: Saccadic Motion & Afterimage Tracking": "Tag 12: Sakkadische Bewegung & Nachbild-Tracking",
    "Moving an afterimage across the internal visual field.": "Gezieltes Verschieben eines Nachbildes im inneren Sehfeld.",
    "Induce the cross afterimage (30s fixation). With eyes closed, slowly shift your physical gaze to the upper-left, then center, then upper-right. Notice how the afterimage tracks your eye movements. Practice intentionally 'pinning' the image in one mental quadrant.": "Erzeugen Sie das Kreuz-Nachbild (30s Fixation). Bewegen Sie die geschlossenen Augen langsam nach oben links, zur Mitte, nach oben rechts. Beobachten Sie, wie das Nachbild der Blickrichtung folgt, und versuchen Sie, es an einer Stelle zu fixieren.",
    "Dissociating retinocentric from spatiocentric visual coordinates strengthens frontoparietal attentional steering (Keogh & Pearson 2024).": "Die Dissoziation retinozentrischer und spatiozentrischer Koordinaten stärkt die frontoparietale Aufmerksamkeitssteuerung (Keogh & Pearson 2024).",

    # Day 13
    "Day 13: Bridging Afterimage to Voluntary Imagery": "Tag 13: Brückenschlag vom Nachbild zur willentlichen Vorstellung",
    "Transitioning from a fading retinal image into mental recall.": "Übergang vom verblassenden physiologischen Nachbild zum bewussten Abruf.",
    "Induce the geometric afterimage. As it fades toward blackness, immediately transition into mentally reconstructing the identical shape using your spatial knowledge from Week 1. Try to maintain the 'feeling of shape' even as the physiological retinal signal disappears.": "Erzeugen Sie das Nachbild. Sobald es verblasst, rekonstruieren Sie die identische Form mental mit Ihrem räumlichen Wissen aus Woche 1. Halten Sie das 'Gefühl der Form' auch nach Verschwinden des Netzhautsignals aufrecht.",
    "The critical breakthrough in Functional Imagery Training is transitioning from bottom-up perceptual signal to top-down voluntary maintenance (Rhodes et al. 2024).": "Der Durchbruch im Functional Imagery Training liegt im Übergang von Bottom-Up-Signalen zur willentlichen Top-Down-Aufrechterhaltung (Rhodes et al. 2024).",

    # Day 14
    "Day 14: Week 2 Retinal Integration Review": "Tag 14: Retinale Integration & Wochenüberprüfung",
    "Assessing afterimage duration, color fidelity, and stability.": "Messung von Nachbilddauer, Farbtreue und Haltestabilität.",
    "Conduct two consecutive 30-second afterimage sessions. Measure the duration (in seconds) that the afterimage remains observable. Log whether the edges felt sharper or lasted longer compared to Day 8.": "Führen Sie zwei Durchgänge durch. Messen Sie die Dauer (in Sekunden), die das Nachbild sichtbar bleibt. Notieren Sie, ob Kanten schärfer wirkten als an Tag 8.",
    "Systematic tracking of visual persistence provides objective behavioral markers of sensory engagement.": "Die systematische Erfassung visueller Persistenz liefert objektive Verhaltensmarker der sensorischen Aktivierung.",

    # Day 15
    "Day 15: Layer 1 - Geometric Wireframe": "Tag 15: Schicht 1 - Geometrisches Drahtgitter",
    "Focusing exclusively on boundary lines and silhouettes.": "Fokussierung ausschließlich auf Begrenzungslinien und Umrisse.",
    "Study the single object outline (an apple silhouette). Do not think about color, texture, or lighting. Focus solely on the outer contour: the curved sides, the top cleft where the stem sits, the gentle tapered bottom. Close your eyes and trace this outline in mental space.": "Betrachten Sie die Apfelsilhouette. Denken Sie weder an Farbe noch an Licht. Konzentrieren Sie sich rein auf die äußere Kontur: Wölbungen, Stielbucht oben, Verjüngung unten. Zeichnen Sie diese Linie mit geschlossenen Augen mental nach.",
    "Decomposing complex scenes into isolated dimensional layers prevents cognitive overload in low baseline imagers (Rhodes et al. 2024).": "Die Zerlegung komplexer Szenen in Einzelschichten verhindert kognitive Überlastung bei geringer Basiskapazität (Rhodes et al. 2024).",

    # Day 16
    "Day 16: Layer 2 - Flat Monochromatic Color Fill": "Tag 16: Schicht 2 - Flächige Farbfüllung",
    "Applying a uniform, unshaded color field within boundaries.": "Auftragen eines einheitlichen, unschattierten Farbfeldes in den Grenzen.",
    "Recall the silhouette from Day 15. Now imagine filling the interior with a single uniform, flat hue: deep crimson red. No highlights, no shadows, no texture—just a solid block of color inside the boundary lines.": "Rufen Sie die Silhouette von Tag 15 ab. Füllen Sie das Innere nun mit einer einheitlichen, flachen Farbe: Tiefrot. Keine Glanzpunkte, keine Schatten, keine Textur – nur ein sattes Farbfeld innerhalb der Kontur.",
    "Separating chromatic assignment from illumination reduces working memory demands during feature synthesis.": "Die Trennung von Farbzuweisung und Beleuchtung entlastet das Arbeitsgedächtnis bei der Merkmalszusammensetzung.",

    # Day 17
    "Day 17: Layer 3 - Surface Texture & Material": "Tag 17: Schicht 3 - Oberflächentextur & Material",
    "Integrating tactile roughness, smoothness, and waxiness.": "Integration von taktiler Glätte, Wachsigkeit und Haptik.",
    "Onto the colored shape, superimpose the tactile surface quality: the smooth waxy skin of an apple, tiny natural stipples, and a stiff brown fibrous stem. Use your Week 1 tactile anchors to ground the surface feel.": "Fügen Sie die taktile Oberflächenbeschaffenheit hinzu: die wachsige, glatte Schale, winzige Punkte und den faserigen braunen Stiel. Nutzen Sie Ihre Tastanker aus Woche 1.",
    "Connecting tactile memory to visual surface representation activates the ventral visual stream and collateral sulcus (Monzel 2025).": "Die Verknüpfung taktiler Erinnerungen mit visueller Oberfläche aktiviert den ventralen Pfad und den Sulcus collateralis (Monzel 2025).",

    # Day 18
    "Day 18: Layer 4 - Directional Light & Cast Shadow": "Tag 18: Schicht 4 - Gerichtetes Licht & Schattenwurf",
    "Introducing a light source and mental illumination.": "Einführung einer Lichtquelle und mentaler Schattierung.",
    "Position an imaginary light source at the top-left (10 o'clock position). Picture a soft white reflection gleam on the upper-left curve of the apple, and a crescent of darker shading on the lower-right side, with a soft oval shadow cast onto the table below.": "Platzieren Sie eine gedachte Lichtquelle oben links (10-Uhr-Position). Stellen Sie sich einen weißen Glanzfleck oben links, dunklere Schattierung unten rechts und einen weichen ovalen Schattenwurf auf dem Tisch vor.",
    "Illumination modeling recruits 3D shape-from-shading mechanisms in parietal-occipital circuits (Zeman 2024).": "Beleuchtungsmodelle nutzen Mechanismen der 3D-Form-aus-Schattierung in parieto-okzipitalen Netzwerken (Zeman 2024).",

    # Day 19
    "Day 19: Complete Object Synthesis (The Apple)": "Tag 19: Gesamtsynthese des Objekts (Der Apfel)",
    "Stacking all 4 layers sequentially into a cohesive representation.": "Sequenzielles Aufeinanderschichten aller 4 Ebenen zu einem Ganzen.",
    "Systematically construct the complete object in 4 timed 2-minute steps: Step 1 (0-2m): Contour silhouette; Step 2 (2-4m): Red color fill; Step 3 (4-6m): Waxy texture & stem; Step 4 (6-8m): Light highlight & cast shadow. Observe how stacking makes visualization manageable.": "Bauen Sie das Objekt in vier 2-Minuten-Schritten auf: Schritt 1 (0-2m): Umrisslinie; Schritt 2 (2-4m): Rote Farbfüllung; Schritt 3 (4-6m): Wachsige Textur & Stiel; Schritt 4 (6-8m): Glanzlicht & Schattenwurf. Erleben Sie, wie Zerlegung Vorstellungen handhabbar macht.",
    "Stepwise feature stacking directly mirrors the core protocol of Rhodes et al. (2024), yielding measurable gains in athletes with imagery deficits.": "Schrittweises Schichten entspricht dem FIT-Kernprotokoll nach Rhodes et al. (2024), das messbare Zuwächse erzielte.",

    # Day 20
    "Day 20: Layered Assembly with Familiar Everyday Objects": "Tag 20: Schichtenaufbau mit Alltagsgegenständen",
    "Applying the 4-layer method to a ceramic coffee mug.": "Anwendung der 4-Schichten-Methode auf eine Kaffeetasse.",
    "Apply the 4-layer method to a new object: a coffee mug. 1) Cylinder outline with a looped handle; 2) Glossy ceramic cobalt-blue color; 3) Cool smooth porcelain texture; 4) Bright light reflection on the rim and dark shadow inside the hollow interior.": "Wenden Sie die 4 Ebenen auf eine Tasse an: 1) Zylinderform mit Henkel; 2) Kobaltblaue Farbe; 3) Kühle, glatte Porzellanhaptik; 4) Glanzreflex am Rand und Schatten im Inneren.",
    "Generalizing the feature-stacking strategy to varied shapes reinforces cognitive schema transfer.": "Die Übertragung der Strategie auf neue Formen festigt den kognitiven Schematransfer.",

    # Day 21
    "Day 21: Week 3 Scaffolding Synthesis & Review": "Tag 21: Scaffolding-Synthese & Wochenreview",
    "Consolidating the 4-layer decomposition pipeline.": "Festigung des 4-Schichten-Zerlegungsablaufs.",
    "Select any object currently in the room. Deconstruct it mentally into its 4 layers (Outline, Color, Texture, Lighting) over 8 minutes. Rate how structured the mental assembly feels compared to attempting an immediate holistic visual image.": "Wählen Sie ein beliebiges Objekt im Raum. Zerlegen Sie es 8 Minuten lang mental in die 4 Schichten (Umriss, Farbe, Textur, Licht). Bewerten Sie die Struktur im Vergleich zu unzerlegten Versuchen.",
    "Rhodes et al. (2024) noted that low-imagers frequently fail when trying to summon holistic images instantly; stepwise assembly solves this barrier.": "Personen mit geringer Vorstellungskraft scheitern oft am sofortigen ganzheitlichen Bild; stufenweiser Aufbau überwindet diese Hürde (Rhodes et al. 2024).",

    # Day 22
    "Day 22: 2D Planar Mental Rotation": "Tag 22: Planare 2D-Mentalrotation",
    "Rotating letters and asymmetrical symbols in 2D space.": "Rotation von Buchstaben und asymmetrischen Symbolen in der Ebene.",
    "Examine the letter 'F' displayed on screen. Mentally rotate it clockwise by 90 degrees (facing downward). Then rotate it another 90 degrees (facing upside down). Trace where the crossbars point at each step. Verify against the interactive rotating preview.": "Betrachten Sie das 'F'. Drehen Sie es mental um 90 Grad im Uhrzeigersinn (nach unten gerichtet), dann um weitere 90 Grad (auf den Kopf). Prüfen Sie, wohin die Querbalken zeigen, und vergleichen Sie mit dem Regler.",
    "Classic Shepard & Metzler (1971) paradigm: mental rotation speed is proportional to angular disparity, utilizing motor and premotor cortex.": "Klassisches Paradigma nach Shepard & Metzler (1971): Die Rotationszeit ist proportional zum Drehwinkel unter Nutzung motorischer Areale.",

    # Day 23
    "Day 23: 3D Isometric Wireframe Cube": "Tag 23: Isometrischer 3D-Drahtgitterwürfel",
    "Tracking vertices and edges during 3D spatial rotation.": "Verfolgung von Ecken und Kanten während räumlicher 3D-Drehung.",
    "Look at the 3D isometric wireframe cube. Identify the front-top-right corner. Mentally rotate the cube slowly around its vertical axis by 45 degrees. Which vertex comes toward you? Which face disappears into the background? Use the interactive rotation controller to verify.": "Betrachten Sie den 3D-Würfel. Identifizieren Sie die vordere rechte obere Ecke. Drehen Sie den Würfel mental um 45 Grad um die Hochachse. Welche Ecke nähert sich? Verifizieren Sie mit der 3D-Steuerung.",
    "3D mental rotation activates the intraparietal sulcus and dorsal visual stream, which remain intact in congenital aphantasia (Monzel 2021).": "3D-Mentalrotation aktiviert den Sulcus intraparietalis und dorsalen Pfad, welche bei angeborener Aphantasie intakt sind (Monzel 2021).",

    # Day 24
    "Day 24: Mental Zooming & Scale Alteration": "Tag 24: Mentaler Zoom & Skalierung",
    "Dynamically varying mental focal length from macro to detail.": "Dynamische Veränderung der mentalen Brennweite von Makro bis Detail.",
    "Mentally picture a grandfather clock from 5 meters away (full wooden cabinet, ticking pendulum). Now mentally 'zoom in' like a camera lens until you are 10 centimeters from the watch face, inspecting the metallic hands and roman numerals. Zoom smoothly back out.": "Stellen Sie sich eine Standuhr aus 5 Metern Entfernung vor. Zoomen Sie wie mit einem Kameraobjektiv heran, bis Sie 10 Zentimeter vor dem Zifferblatt sind. Zoomen Sie wieder ruhig zurück.",
    "Mental zoom exercises recruit topographic visual buffers and attentional magnification mechanisms.": "Mentale Zoomübungen aktivieren retinotope visuelle Puffer und Mechanismen der Aufmerksamkeitsvergrößerung.",

    # Day 25
    "Day 25: Mental Orbiting (Camera Perspective Shifts)": "Tag 25: Mentales Umkreisen (Perspektivwechsel)",
    "Moving your viewpoint around a stationary central object.": "Verschiebung des eigenen Blickwinkels um ein ruhendes Objekt.",
    "Picture a wooden chair in the center of the room. Keep the chair completely still, but imagine walking in a smooth circle around it. View it from the front, from the side profile, from directly behind the backrest, and from the other side.": "Stellen Sie sich einen Stuhl in der Raummitte vor. Halten Sie den Stuhl unbeweglich, umrunden Sie ihn mental im Kreis und betrachten Sie ihn von vorne, der Seite und von hinten.",
    "Allocentric to egocentric reference frame transformations stimulate hippocampal and retro-splenial spatial navigation networks.": "Allolozentrische zu egozentrischen Transformationen stimulieren hippocampale und retrospleniale Navigationsnetzwerke.",

    # Day 26
    "Day 26: Spatial Unfolding (Net to 3D Polyhedron)": "Tag 26: Räumliches Auffalten (Körpernetz zu 3D)",
    "Folding a 2D cross-shaped net into a 3D closed box.": "Falten eines 2D-Kreuznetzes zu einer geschlossenen 3D-Schachtel.",
    "Visualize a flat cross made of 6 squares (a cube net). Mentally fold the bottom flap up 90 degrees to form the front wall. Fold the left and right flaps up to form side walls. Fold the top square over to form the lid. Confirm the completed 3D box.": "Stellen Sie sich ein Würfelnetz aus 6 Quadraten vor. Klappen Sie die Seitenlaschen um 90 Grad nach oben und das obere Quadrat als Deckel um. Bestätigen Sie die geschlossene Schachtel.",
    "Spatial origami and paper-folding tasks measure pure spatial transformation without requiring photorealistic color rendering.": "Aufgaben zum räumlichen Falten erfassen reine Raumtransformationen unabhängig von fotorealistischer Farbwiedergabe.",

    # Day 27
    "Day 27: Multi-Object Spatial Choreography": "Tag 27: Räumliche Multi-Objekt-Choreografie",
    "Maintaining spatial relationships between 3 interacting objects.": "Aufrechterhaltung räumlicher Relationen zwischen drei interagierenden Objekten.",
    "Place 3 items in mental space on a tabletop: a red apple, a glass bottle, and a small coin. Mentally swap the positions of the apple and bottle. Then slide the coin between them. Track the relative left/right and front/back spatial distances at each movement.": "Platzieren Sie 3 Objekte auf einem Tisch: Apfel, Glasflasche, Münze. Tauschen Sie gedanklich die Position von Apfel und Flasche. Schieben Sie die Münze dazwischen. Verfolgen Sie die Abstände.",
    "Multi-object spatial tracking recruits parietal working memory buffers and strengthens spatial relational models.": "Räumliches Multi-Objekt-Tracking stärkt parietale Puffer und relationale Modelle.",

    # Day 28
    "Day 28: Week 4 Spatial Manipulation Review": "Tag 28: Wochenüberprüfung Räumliche Manipulation",
    "Evaluating speed and confidence of 3D mental rotation.": "Bewertung von Geschwindigkeit und Sicherheit bei der 3D-Mentalrotation.",
    "Take a 3D pyramid or cube. Rotate it smoothly along two axes simultaneously (yaw and pitch) for 8 minutes. Log whether keeping track of vertices felt more intuitive and fluid compared to Day 22.": "Drehen Sie einen 3D-Würfel 8 Minuten lang flüssig um zwei Achsen gleichzeitig. Protokollieren Sie, ob das Verfolgen der Ecken intuitiver fiel als an Tag 22.",
    "Spatial manipulation mastery provides the structural skeleton for complex scene generation in Weeks 5 and 6.": "Die Beherrschung räumlicher Manipulation bildet das tragende Gerüst für komplexe Szenen in Woche 5 und 6.",

    # Day 29
    "Day 29: Emotionally Salient Natural Landscape": "Tag 29: Emotional bedeutsame Naturlandschaft",
    "Using emotional calm and safety to amplify sensory details.": "Nutzung emotionaler Ruhe und Geborgenheit zur Verstärkung von Sinnesdetails.",
    "Choose an outdoor setting where you felt profound peace (e.g. a secluded pine forest or a tranquil lakeshore). Re-activate the visceral feeling of safety and calm in your chest. Let this emotional tone draw in the ambient details: the gentle breeze on your face, the smell of pine needles, the green canopy.": "Wählen Sie einen Ort in der Natur, an dem Sie tiefe Ruhe spürten (Wald, Seeufer). Rufen Sie das Gefühl von Geborgenheit im Brustraum wach. Lassen Sie diese Emotion Details herbeiziehen: Windhauch, Nadelduft, Blätterdach.",
    "Emotional valence activates the amygdala and ventromedial prefrontal cortex, which powerfully boost visual cortex sensitivity (Wicken et al. 2021; Rhodes et al. 2024).": "Emotionale Valenz aktiviert Amygdala und vmPFC, was die Empfindlichkeit des visuellen Kortex nachweislich steigert (Wicken et al. 2021; Rhodes et al. 2024).",

    # Day 30
    "Day 30: Soundscape-Driven Visual Construction": "Tag 30: Klanggestützte Szenenkonstruktion",
    "Using rich acoustic soundscapes to generate spatial imagery.": "Einsatz dichter Klanglandschaften zur Erzeugung räumlicher Vorstellungen.",
    "Imagine sitting on a sea cliff. First, fill your mind with sound: rhythmic roaring waves crashing against rocks below, distant seagulls calling, wind gusting past your ears. As the soundscape stabilizes, allow the visual horizon and white ocean foam to materialize from the sound sources.": "Stellen Sie sich vor, an einer Klippe zu sitzen. Hören Sie zuerst die Brandung, Möwenrufe, Windstöße. Wenn die Klangkulisse steht, lassen Sie daraus die Brandungsgischt und den Horizont entstehen.",
    "Auditory-to-visual cross-modal transfer is one of the most effective compensatory pathways identified in low-imagery athletes (Rhodes et al. 2024).": "Auditorisch-visueller Transfer ist einer der effektivsten Kompensationspfade bei Sportlern mit schwacher Vorstellungskraft (Rhodes et al. 2024).",

    # Day 31
    "Day 31: Kinesthetic Motor Imagery Rehearsal": "Tag 31: Kinästhetische Bewegungsvorstellung",
    "Internal physical sensation of athletic or expressive movement.": "Spüren des Körpers bei sportlichen oder ausdrucksstarken Bewegungsabläufen.",
    "Mentally perform a physical movement you know well: swimming a stroke, swinging a racket, or dancing. Feel the exact muscle contractions, the balance adjustments, the acceleration, and the air resistance. Experience the movement from the first-person perspective ('internal imagery').": "Führen Sie eine vertraute Bewegung mental durch: Schwimmzug, Schlag, Tanzschritt. Spüren Sie Muskelanspannung, Gleichgewicht und Luftwiderstand aus der Ich-Perspektive.",
    "Motor imagery activates supplementary motor area (SMA) and primary motor cortex even in individuals with complete visual aphantasia.": "Motorische Vorstellung aktiviert das SMA und den motorischen Kortex auch bei vollständiger Aphantasie nachweisbar.",

    # Day 32
    "Day 32: Autobiographical Room Recall": "Tag 32: Autobiografische Raumerinnerung",
    "Reconstructing a familiar physical room from childhood.": "Rekonstruktion eines vertrauten Raumes aus der Kindheit.",
    "Think of a bedroom or living room from your childhood or past. Stand mentally at the doorway. What was immediately to your left? Where was the window? What was the floor covering? Combine spatial memory with nostalgic emotional resonance to tour the room.": "Denken Sie an ein Zimmer Ihrer Kindheit. Stehen Sie mental an der Türschwelle: Was war links? Wo das Fenster? Welcher Bodenbelag? Durchschreiten Sie den Raum mit nostalgischer Resonanz.",
    "Autobiographical memory retrieval engages the default mode network (DMN), linking episodic knowledge with spatial layouts.": "Autobiografischer Abruf aktiviert das Default Mode Network (DMN) und verknüpft Episoden mit räumlichen Grundrissen.",

    # Day 33
    "Day 33: Multi-Sensory Meal Experience": "Tag 33: Multisensorisches Mahlzeiterlebnis",
    "Fusing taste, aroma, warmth, and visual table arrangement.": "Verbindung von Geschmack, Duft, Temperatur und Tischumgebung.",
    "Imagine preparing your favorite comforting meal. Experience the aroma wafting from the pan, the sizzle of food cooking, the weight of the fork, the temperature of the first bite, and the rich flavor on your tongue. Bring all senses together simultaneously.": "Stellen Sie sich die Zubereitung Ihres Lieblingsgerichts vor: Pfannenduft, Bratgeräusch, Gabelgewicht, Temperatur des ersten Bissens und Geschmack auf der Zunge. Vereinen Sie alle Sinne.",
    "Flavor and food imagery maximally engage multi-sensory orbitofrontal and gustatory cortices, providing rich multi-modal reinforcement.": "Geschmacksvorstellungen sprechen orbitofrontale Areale an und bieten eine exzellente multisensorische Verstärkung.",

    # Day 34
    "Day 34: Dynamic Weather Transition": "Tag 34: Dynamischer Wetterübergang",
    "Visualizing continuous change: sunlight breaking through storm clouds.": "Vorstellung kontinuierlicher Veränderung: Sonnenstrahlen durchbrechen Gewitterwolken.",
    "Start with a dark, overcast, rainy sky. Hear the rain and feel the damp chill. Now mentally simulate gradual change: the clouds thinning, a golden beam of sunlight piercing through, the raindrops sparkling in the light, and a colorful rainbow forming across the sky (Scenario B of VVIQ).": "Beginnen Sie mit verregnetem Himmel, Regenrauschen und Kühle. Simulieren Sie den Wandel: Wolken reißen auf, ein Sonnenstrahl bricht durch, Tropfen glitzern und ein Regenbogen spannt sich über den Himmel (VVIQ-Szenario B).",
    "Simulating temporal dynamism trains temporal-parietal continuity in voluntary visualization.": "Die Simulation zeitlicher Dynamik trainiert temporo-parietale Kontinuität in der willentlichen Vorstellung.",

    # Day 35
    "Day 35: Week 5 Multisensory Immersion Review": "Tag 35: Wochenüberprüfung Multisensorische Immersion",
    "Assessing the richness of emotionally grounded scenes.": "Bewertung der Detaildichte emotional verankerter Szenen.",
    "Spend 8 minutes in your favorite synthesized scenario from Days 29-34. Notice whether sensory details arrive more effortlessly when anchored in physical feelings and emotional valence.": "Verweilen Sie 8 Minuten in Ihrem bevorzugten Szenario der Tage 29-34. Prüfen Sie, ob Details müheloser entstehen, wenn sie emotional verankert sind.",
    "Consolidation of multi-modal associative circuits prior to real-world integration.": "Konsolidierung multisensorischer Assoziationsschaltkreise vor der Alltagsanwendung.",

    # Day 36
    "Day 36: Dual-Coding Spatial Pegboard": "Tag 36: Dual-kodierende räumliche Pegboard-Methode",
    "Applying spatial anchors and semantic pegs for memory recall.": "Einsatz räumlicher Anker und semantischer Merkposten für das Gedächtnis.",
    "Learn a list of 5 unrelated items using spatial pegs in your current room (e.g., 1=Doorway, 2=Sofa, 3=Desk, 4=Window, 5=Bookshelf). Place an unusual item at each location using the 4-layer method. Walk mentally through the room and retrieve all 5 items effortlessly.": "Lernen Sie 5 Begriffe über Raumanker in Ihrem Zimmer (1=Tür, 2=Sofa, 3=Schreibtisch, 4=Fenster, 5=Regal). Platzieren Sie dort Objekte mit der 4-Ebenen-Methode und rufen Sie sie im Geiste ab.",
    "The Method of Loci operates through spatial mapping and intact hippocampal navigation, offering immense memory utility for aphantasics (Kelly 2020).": "Die Loci-Methode nutzt intakte hippocampale Raumnavigation und bietet enorme Gedächtnisvorteile für Aphantasiker (Kelly 2020).",

    # Day 37
    "Day 37: Pre-Action Mental Rehearsal": "Tag 37: Mentale Handlungsvorbereitung",
    "Mentally walking through a planned real-world task before doing it.": "Mentales Durchspielen einer geplanten Alltagsaufgabe vor der Ausführung.",
    "Select a practical task you need to complete today (e.g. preparing an ingredient, packing a bag, or walking a specific route). Rehearse every physical step in advance in your mind: opening drawers, selecting objects, checking off items. Notice how this primes real execution.": "Wählen Sie eine heutige Aufgabe (Kochen, Tasche packen, Route gehen). Gehen Sie jeden Schritt im Vorfeld im Geist durch: Schublade öffnen, Dinge greifen. Spüren Sie die Bahnung für die Praxis.",
    "Functional Imagery Training (FIT) utilizes pre-action mental simulation to boost performance, goal adherence, and self-efficacy (Rhodes et al. 2024).": "FIT nutzt mentale Simulation vor der Handlung, um Leistung, Zieltreue und Selbstwirksamkeit zu steigern (Rhodes et al. 2024).",

    # Day 38
    "Day 38: Creative Problem Solving via Spatial Models": "Tag 38: Problemlösung über räumliche Modelle",
    "Rearranging furniture or conceptual layouts mentally.": "Mentales Umstellen von Möbeln oder Konzeptentwürfen.",
    "Imagine wanting to rearrange a room or fit multiple large suitcases into the trunk of a car. Use your Week 4 mental rotation and Week 1 spatial mapping skills to test different configurations mentally before touching any physical object.": "Stellen Sie sich vor, Koffer im Kofferraum zu verstauen oder Möbel umzustellen. Nutzen Sie Mentalrotation und Raumkartierung, um Konfigurationen vorab mental zu testen.",
    "Spatial reasoning without visual phenomenology is a documented cognitive strength in aphantasic individuals (Zeman 2010; Monzel 2025).": "Räumliches Denken ohne Bildphänomenologie ist eine dokumentierte Stärke von Personen mit Aphantasie (Zeman 2010; Monzel 2025).",

    # Day 39
    "Day 39: Cognitive Flexibility & Strategy Switching": "Tag 39: Kognitive Flexibilität & Strategiewechsel",
    "Consciously toggling between propositional, spatial, and visual modes.": "Bewusster Wechsel zwischen propositionalem, räumlichem und visuellem Modus.",
    "Take a single concept (e.g. 'A sailboat at sunset'). Spend 2 minutes experiencing it purely propositionally (word lists and facts). Then spend 2 minutes experiencing it spatially (distances, mast height, hull angle). Then spend 2 minutes checking for visual flashes. Observe the differences.": "Wählen Sie ein Konzept ('Segelboot im Sonnenuntergang'). Erleben Sie es 2 Min. rein propositional (Fakten), 2 Min. räumlich (Distanzen, Masthöhe) und 2 Min. visuell suchend. Vergleichen Sie die Modi.",
    "Metacognitive flexibility allows individuals to deploy the optimal cognitive strategy for specific tasks (Monzel 2025).": "Metakognitive Flexibilität ermöglicht es, die für jede Aufgabe optimale Kognitionsstrategie einzusetzen (Monzel 2025).",

    # Day 40
    "Day 40: Lifelong Imagery Maintenance Protocol": "Tag 40: Nachhaltige Alltagsroutine",
    "Establishing a sustainable daily 5-minute micro-routine.": "Etablierung einer nachhaltigen täglichen 5-Minuten-Mikroroutine.",
    "Design your personal sustainable maintenance habit: 1 minute breathing calibration, 3 minutes with your most effective exercise (e.g. afterimage conditioning or 4-layer assembly), and 1 minute reflection. Consistency preserves neuroplastic gains long-term.": "Entwickeln Sie Ihre persönliche 5-Minuten-Gewohnheit: 1 Min. Atmung, 3 Min. Ihrer effektivsten Übung (Nachbild oder 4 Ebenen) und 1 Min. Reflexion. Kontinuität sichert Plastizitätsgewinne.",
    "Rhodes et al. (2024) proved that training gains were maintained at a 6-month follow-up when key exercises were periodically integrated into daily habits.": "Rhodes et al. (2024) belegten, dass Trainingsgewinne bei regelmäßiger Erhaltung auch nach 6 Monaten stabil blieben.",

    # Day 41
    "Day 41: Post-Training Assessment Preparation": "Tag 41: Vorbereitung auf den Re-Test",
    "Reflecting on the 6-week journey and internal changes.": "Reflexion der 6-wöchigen Entwicklung und inneren Veränderungen.",
    "Review your training streak and logged notes from Week 1 to Week 6. Notice how your relationship with your inner mind has evolved—whether through increased visual flashes, heightened tactile/spatial clarity, or deeper appreciation of your unique cognitive architecture.": "Blicken Sie auf Ihre Notizen aus Woche 1 bis 6 zurück. Beobachten Sie, wie sich Ihr inneres Erleben verändert hat – durch mehr visuelle Eindrücke, klarere Raummodelle oder Akzeptanz der eigenen Denkweise.",
    "Preparing cognitive state for unbiased psychometric post-training re-evaluation.": "Vorbereitung des kognitiven Zustands auf eine unvoreingenommene psychometrische Re-Test-Erfassung.",

    # Day 42
    "Day 42: Final Post-Training Re-Assessment": "Tag 42: Finaler Abschluss-Re-Test",
    "Re-taking the VVIQ & Apple Test to quantify longitudinal progress.": "Wiederholung von VVIQ & Apfel-Test zur Quantifizierung des Fortschritts.",
    "Congratulations on completing the full 6-week curriculum! Today you will retake the standardized VVIQ and Apple Test under identical conditions to your Week 1 baseline. The application will compute your longitudinal score delta and generate your comprehensive completion report.": "Herzlichen Glückwunsch zum Abschluss des 6-Wochen-Curriculums! Heute wiederholen Sie den standardisierten VVIQ und Apfel-Test unter identischen Bedingungen. Die App berechnet Ihre Zuwächse und erstellt den Abschlussbericht.",
    "Empirical re-administration of validated psychometric instruments to evaluate intervention efficacy (Rhodes et al. 2024; Marks 1973).": "Empirische Wiederholungsmessung validierter Instrumente zur Überprüfung der Interventionseffektivität (Rhodes et al. 2024; Marks 1973)."
}

# Update aphantasia_de.ts with all translations
ts_de = 'QtAphantasie/translations/aphantasia_de.ts'
tree = ET.parse(ts_de)
root = tree.getroot()

updated_count = 0
for context in root.findall('context'):
    for msg in context.findall('message'):
        src = msg.find('source')
        if src is not None and src.text in day_translations:
            trans = msg.find('translation')
            if trans is None:
                trans = ET.SubElement(msg, 'translation')
            trans.text = day_translations[src.text]
            if 'type' in trans.attrib:
                del trans.attrib['type']
            updated_count += 1

tree.write(ts_de, encoding='utf-8', xml_declaration=True)
print(f"Updated {updated_count} day translations in {ts_de}")

# Run lrelease to compile
lrelease = r"C:\Qt\6.8.3\mingw_64\bin\lrelease.exe"
qm_de = 'QtAphantasie/translations/aphantasia_de.qm'
subprocess.run([lrelease, ts_de, '-qm', qm_de], check=True)

# Also copy to root translations
import shutil
shutil.copy2(ts_de, 'translations/aphantasia_de.ts')
shutil.copy2(qm_de, 'translations/aphantasia_de.qm')
shutil.copy2('QtAphantasie/translations/aphantasia_en.ts', 'translations/aphantasia_en.ts')
shutil.copy2('QtAphantasie/translations/aphantasia_en.qm', 'translations/aphantasia_en.qm')
print("Successfully compiled and mirrored translations to root.")
