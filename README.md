# Aphantasia Test & Training Application

An interactive, web-based platform combining standardized psychometric evaluation and structured neurocognitive training for **aphantasia** (the inability to voluntarily generate visual mental imagery).

Built with **C++** and **Qt Quick (QML)**, compiled to **Single-Threaded WebAssembly (Wasm)**, and hosted directly on **GitHub Pages**.

> [!IMPORTANT]
> **Research and Educational Use Only — Not a Medical Device**  
> This application is developed strictly for research, self-exploration, and educational purposes. It is **not a medical device**, does not provide clinical diagnoses, and is not intended to treat, cure, or prevent any medical or psychological condition. Users participate in an investigative self-exploration study. All personal data remains strictly on the user's device and is never automatically collected or transmitted.

---

## 1. Project Motivation & Scope

As documented in research literature and summarized in `wiki.txt`, aphantasia represents a significant cognitive variation in human subjective experience, affecting approximately 4% of the population. While traditionally considered a fixed trait, recent neuroscientific studies—notably by Rhodes et al. (2024) at the University of Plymouth—have demonstrated that mental imagery abilities can be systematically strengthened through structured, multi-week sensory training protocols.

This project delivers a unified, zero-install web application that:
1. **Assesses** voluntary visual and multi-modal imagery vividness using scientifically validated instruments (VVIQ, Apple Test, and multi-sensory profiling).
2. **Trains** mental imagery capacity through a progressive, 6-week neurocognitive exercise curriculum designed specifically for low-imagers and aphantasics.
3. **Bilingual Accessibility:** Developed bilingually from the outset in **German** and **English** using Qt's `QTranslator` system, with translations systematically verified using `linguist.exe`.

---

## 2. Relevant Scientific Sources

The design of both the test batteries and the training curriculum is derived directly from empirical literature referenced in the project knowledge base:

### A. Foundations for Testing & Diagnostics
* **Marks, D. F. (1973):** *Visual Imagery Questionnaire (VVIQ)*.
  * *Relevance:* The gold-standard 16-item self-report questionnaire for voluntary visual mental imagery vividness.
* **Zeman, A., Dewar, M., & Della Sala, S. (2015):** *Lives without imagery – Congenital aphantasia.* *Cortex*, 73, 378–380.
  * *Relevance:* Formally established the condition name *Aphantasia* and standardized the use of the VVIQ for clinical and research classification.
* **Dance, C. J., Ipser, A., & Simner, J. (2022):** *The prevalence of aphantasia (imagery weakness) in the general population.* *Consciousness and Cognition*, 97, 103243.
  * *Relevance:* Established standard population norms and threshold cutoffs: scores **< 32** indicate aphantasia (with **16** representing complete / total aphantasia).
* **Zeman, A., et al. (2020):** *Phantasia–The psychological significance of lifelong visual imagery vividness extremes.* *Cortex*, 130, 426–440.
  * *Relevance:* Established the upper extreme threshold: scores of **75–80** denote hyperphantasia.
* **Monzel, M., Mitchell, D., Macpherson, F., Pearson, J., & Zeman, A. (2022):** *Proposal for a consistent definition of aphantasia and hyperphantasia.* *Cortex*, 152, 74–76.
  * *Relevance:* Multi-laboratory consensus definitions and diagnostic criteria for cognitive imagery extremes.
* **Dawes, A. J., Keogh, R., & Pearson, J. (2024):** *Multisensory subtypes of aphantasia: Mental imagery as supramodal perception in reverse.* *Neuroscience Research*, 201, 50–59.
  * *Relevance:* Proves that aphantasia can be unimodal (purely visual) or multisensory (affecting auditory, tactile, gustatory, or kinesthetic imagery). Informs the multi-sensory profiling step.
* **Keogh, R., & Pearson, J. (2018, 2024):** *The blind mind: No sensory visual imagery in aphantasia* & *Revisiting the blind mind.* *Cortex* & *Neuroscience Research*.
  * *Relevance:* Validated objective psychophysical methods (e.g., binocular rivalry priming) establishing that aphantasia is a genuine sensory-perceptual absence rather than a metacognitive reporting bias.

### B. Foundations for Imagery Training & Scaffolding
* **Rhodes, J., Nedza, K., May, J., & Clements, L. (2024):** *Imagery training for athletes with low imagery abilities.* *Journal of Applied Sport Psychology*, DOI: 10.1080/10413200.2024.2337019.
  * *Relevance:* **Core training foundation.** Demonstrated that a 6-week personalized **Functional Imagery Training (FIT)** protocol significantly increased mental imagery capabilities in individuals with low baseline imagery / aphantasia, with gains maintained at a 6-month follow-up.
* **Zeman, A. (2024):** *Aphantasia and hyperphantasia: exploring imagery vividness extremes.* *Trends in Cognitive Sciences*, 28(5), 467–480.
  * *Relevance:* Outlines the frontoparietal-occipitotemporal brain connectivity model underlying imagery, supporting the hypothesis that top-down communication networks exhibit neuroplastic adaptability.
* **Monzel, M. (2025):** *Aphantasie: Fakt oder Fiktion? Experimentell-neurowissenschaftliche Untersuchungen zur Charakterisierung von Personen ohne sensorisches Vorstellungsvermögen.* Doctoral Dissertation, University of Bonn.
  * *Relevance:* Comprehensive synthesis of cognitive strategies (such as propositional thought and dual-coding mechanisms) used by aphantasics to navigate spatial, attentional, and memory tasks.
* **Kelly, L. (2020):** *Aphantasia & memory.*
  * *Relevance:* Demonstrates how non-visual spatial and tactile scaffolding can be utilized to anchor internal mental models.

---

## 3. Research Ethics, Disclaimer & Data Sovereignty Requirements

Because this application serves as an empirical research and cognitive training instrument, it must implement strict informed consent, privacy safeguards, and user autonomy controls directly within the user interface before any assessment or training begins.

### A. Mandatory In-App Disclaimer & Participant Information
Before users can launch either the testing questionnaire or the training modules, the application displays a mandatory, non-dismissible onboarding dialog that explicitly states:
1. **Research Study Participation:** Users are informed that they are engaging in a scientific self-exploration and research project investigating voluntary visual imagery and neurocognitive training methodologies.
2. **Non-Medical Device Declaration:** Clear statement that the application is **not a medical device**, does not provide medical or psychiatric advice, and should not replace professional clinical consultation or treatment.

### B. Data Sovereignty ("Your Data Is Yours")
* **No Automatic Transmission or Telemetry:** The application operates strictly as a local-first client. No test answers, scores, training logs, IP addresses, or telemetry data are automatically transmitted to external servers, cloud databases, or third parties.
* **Client-Side Storage:** All user data (VVIQ scores, Apple Test selection, Psi-Q ratings, daily training progress) is stored exclusively in the local browser environment (`localStorage` / IndexedDB via Emscripten's virtual file system).

### C. User Data Export & Portability
* **User Data Download:** Users have unconditional access to a dedicated **"Download My Data"** feature accessible at any time from both the test results and training dashboard screens.
* **Standard Formats:** Data can be exported as clean, human-readable **JSON** or **CSV** files containing timestamped assessment scores, individual item responses, and training session logs.
* **Data Erasure:** A one-click **"Clear All Data"** option allows users to permanently delete all local storage keys at any time.

### D. Source Code Transparency & Open Science
* **Open Source Accessibility:** A permanent **"View Source Code"** link is embedded directly in the application's header and disclaimer modal, linking directly to the public GitHub repository.
* **Full Algorithmic Transparency:** Users and researchers can inspect and verify the exact scoring formulas, question sequences, timing mechanisms, and training algorithms implemented in the C++ and Qt Quick codebase.

---

## 4. Accessibility, Neuro-Inclusivity & Audio Guidance (WCAG 2.1 AA/AAA)

To ensure that the application is fully accessible and welcoming to users with visual impairments, aphantasic individuals, and neurodivergent participants, the platform adheres to rigorous accessibility standards:

### A. High Contrast Visual Design (WCAG AAA)
* **Contrast Compliance:** All text colors exceed WCAG 2.1 AA requirements (4.5:1 for normal text) and achieve **WCAG AAA** ratios:
  * Primary Text (`#FFFFFF` on `#0B0F19`): **18.7:1** contrast ratio.
  * Secondary Text (`#E2E8F0` on `#1E293B`): **11.2:1** contrast ratio.
  * Muted / Meta Text (`#94A3B8` on `#0B0F19`): **7.6:1** contrast ratio.
* **Cross-Platform Basic Style Enforcement:** Native OS styles (such as Windows default UxTheme) that historically forced low-contrast dark text onto dark backgrounds are permanently overridden via `QQuickStyle::setStyle("Basic")`. Button captions and states remain consistently bright and legible on Windows, macOS, Linux, and WebAssembly.
* **Distinct Focus Rings:** A high-visibility cyan focus indicator (`Theme.focusRing: #38BDF8`, 9.4:1 contrast) outlines any element currently holding keyboard focus.

### B. Keyboard-Only Navigation & Straightforward Wizards
The entire user journey can be completed without a mouse or touch screen:
* **The Assessment Wizard:**
  * **Step 1 (The Apple Test):** Press number keys `1` through `5` to instantly select vividness levels. Press `Enter` or `Space` to confirm and advance.
  * **Step 2 (VVIQ Questionnaire):** Press keys `1` through `5` to submit item ratings and auto-advance. Press `Left Arrow` or `Backspace` to return to the previous question.
  * **Persistent Wizard Navigation Bar:** Pinned at the bottom of the viewport, the wizard footer is **always visible** (never pushed below the fold), providing clear "← Zurück / Previous" and "Weiter / Next →" controls.
* **Navigation Header & Tabs:** `Tab` and `Shift+Tab` navigate through the 4 application areas (Diagnostic, 6-Week Training, Progress, Ethics & Sources). `Enter` or `Space` activates the tab.
* **Training Session Player:**
  * `Space` bar pauses and resumes active exercise countdowns.
  * Number keys `1`, `2`, and `3` switch between Phase 1 (Breathing), Phase 2 (Exercise), and Phase 3 (Reflection).
  * `Enter` triggers session completion and logging.

### C. Audio Guidance & Text-to-Speech (TTS) Architecture
* **Spoken Guidance for Every Exercise:** Recognizing that individuals with visual impairments or aphantasia benefit profoundly from acoustic guidance, comprehensive spoken scripts for all 42 training sessions and diagnostic tests are documented in [`docs/AUDIO_GUIDANCE_TTS.md`](file:///c:/Users/MiCHi/Documents/Aphantasie/docs/AUDIO_GUIDANCE_TTS.md).
* **ElevenLabs Eleven v4 Optimization:** Scripts are specifically tuned for ElevenLabs `Eleven v4` / `Eleven Multilingual v2` voice models, utilizing calming, empathetic pacing and sparing audio pause tags (e.g. `<break time="1.5s" />`) for guided introspective reflection.

### D. Resonance Frequency Breathing & PeakFrequency Integration
* Prior to each cognitive training exercise, users complete a 2-minute autonomic calibration phase.
* To support guided resonance frequency breathing (~5.5 to 6 breaths per minute, 0.1 Hz) that balances heart-rate variability (HRV) and autonomic tone, the application links directly to [**PeakFrequency**](https://mesw.github.io/PeakFrequency/), an open-source resonance pacer.

---

## 5. Test Procedure Outline

The diagnostic section guides users through a multi-tiered evaluation to determine their imagery profile:

```
[ Step 1: The Apple Test ] ➔ [ Step 2: Full VVIQ Assessment ] ➔ [ Step 3: Multisensory Profiling ] ➔ [ Results & Baseline ]
 (Quick intuitive gauge)        (Standardized 16-80 score)           (Visual, Auditory, Kinesthetic)     (Diagnostic Report)
```

### Step 1: Intuitive Onboarding ("The Apple Test")
* **Purpose:** Provides a rapid, zero-friction introduction to mental imagery variation.
* **Procedure:** The user is asked to close their eyes and imagine a red apple sitting on a table. They select one of 5 visual representations:
  * **Level 1 (Photorealistic):** Full color, lighting, texture, and three-dimensional depth.
  * **Level 2 (Vivid):** Clear shape and color, minor detail attenuation.
  * **Level 3 (Moderate):** Identifiable shape, subdued colors, somewhat cartoonish or dim.
  * **Level 4 (Faint / Vague):** Translucent outline, gray/dull silhouette, unstable image.
  * **Level 5 (Complete Aphantasia):** Absolute blackness / conceptual knowledge only ("I know what an apple is, but I see nothing").

### Step 2: Standardized VVIQ Evaluation
* **Instrument:** 16 standard items based on Marks (1973), structured into 4 contextual scenarios:
  1. *Scenario A:* Visualizing a close relative or friend (face, stance, head movements, expressions).
  2. *Scenario B:* Visualizing the rising sun (horizon, sky colors, clouds, morning light).
  3. *Scenario C:* Visualizing a familiar shop or storefront (overall facade, window display, entrance, detail inside).
  4. *Scenario D:* Visualizing a natural country scene (trees, lake/river, wind breeze on water, landscape colors).
* **Rating Scale (1 to 5 per item):**
  * `1` = No image at all, only "knowing" that you are thinking of the object.
  * `2` = Vague and dim image.
  * `3` = Moderately clear and vivid.
  * `4` = Clear and reasonably vivid.
  * `5` = Perfectly clear and as vivid as normal vision.
* **Scoring & Classification (Dance et al. 2022; Zeman et al. 2020):**
  * **16 Points:** Total Aphantasia (complete absence of voluntary visual imagery).
  * **17 – 31 Points:** Congenital / Marked Aphantasia (severely impoverished imagery).
  * **32 – 54 Points:** Hypophantasia (sub-typical, vague imagery).
  * **55 – 74 Points:** Typical Imagery Vividness.
  * **75 – 80 Points:** Hyperphantasia (extremely vivid, lifelike visualization).

### Step 3: Multisensory Profile Check (Psi-Q Subscales)
* Evaluates non-visual sensory modalities (Auditory, Tactile, Kinesthetic/Motor, Olfactory, Gustatory, Emotional) based on Dawes et al. (2024).
* Identifies whether the user has **unimodal aphantasia** (visual only) or **multisensory aphantasia** (multi-modal absence). This distinction is vital for tailoring the initial training anchors.

### Step 4: Diagnostic Summary & Export
* Generates an interactive visual profile showing vividness percentiles.
* Saves the baseline evaluation in browser local storage for longitudinal tracking against post-training re-tests.

---

## 6. Training Procedure Outline

The training curriculum adapts the **Functional Imagery Training (FIT)** protocol developed by Rhodes et al. (2024) into an accessible, self-paced digital program. It spans **6 weeks**, with daily micro-sessions lasting **10 to 15 minutes**.

```
[ Week 1: Multi-Modal Anchoring ] ➔ [ Week 2: Contrast & Afterimages ] ➔ [ Week 3: Feature Assembly ]
                   ⬇                                                                     ⬇
[ Post-Training Re-Assessment ]   ⬅   [ Week 6: Everyday Integration ]   ⬅   [ Week 4-5: Dynamic Scenes ]
```

### The 6-Week Progressive Curriculum

#### Week 1: Sensory Scaffolding & Multi-Modal Anchoring
* **Focus:** Establishing mental anchors using intact non-visual modalities (touch, proprioception, sound).
* **Technique:**
  * Physical-to-mental transfer: Users interact with a tactile object (e.g., a textured coin or key) with eyes open, close their eyes, and focus purely on tactile and auditory recall before attempting any visual reproduction.
  * Building semantic-spatial models: Constructing spatial relationships conceptually (relative positions, geometry, temperatures) without forcing a visual render.

#### Week 2: High-Contrast Forms & Negative Afterimages
* **Focus:** Engaging the primary visual pathways through physiological stimulation.
* **Technique:**
  * Screen-based afterimage conditioning: Viewing high-contrast monochromatic geometries (white circles, crosses on black backgrounds) for 30 seconds, then closing eyes to observe retinal afterimages.
  * Transitioning afterimages into voluntary mental stabilization exercises.

#### Week 3: Component Decomposition & Layered Assembly
* **Focus:** Gradual reconstruction of single objects rather than complex holistic scenes.
* **Technique:**
  * Stepwise feature stacking:
    1. *Geometry:* Imagine only the silhouette / boundary line.
    2. *Surface:* Add a single flat primary color.
    3. *Texture & Material:* Add reflections, roughness, or matte finish.
    4. *Illumination:* Introduce a directional light source and mental shadow.

#### Week 4: Spatial Transformation & Mental Rotation
* **Focus:** Moving from static forms to active visual-spatial manipulation.
* **Technique:**
  * Interactive 2D/3D transformations: Rotating simple 3D geometric shapes (cubes, pyramids, letters) in mental space.
  * Mental zooming and panning: Changing the focal distance and perspective around a fixed imagined object.

#### Week 5: Affective & Dynamic Scene Synthesis
* **Focus:** Leveraging emotional and autobiographical salience to amplify visualization vividness.
* **Technique:**
  * Incorporating emotional valence: Mental rehearsal of relaxing or rewarding scenarios (walking in nature, preparing food, athletic movements).
  * Multisensory integration: Fusing sound (ambient audio cues), tactile sensations, and visual elements simultaneously.

#### Week 6: Real-World Integration & Maintenance
* **Focus:** Applying mental imagery strategies to everyday cognition and memory tasks.
* **Technique:**
  * Dual-coding memory encoding: Using spatial and visual pegboards for recall.
  * Motor imagery: Visualizing personal physical actions and movement sequences before execution.
  * **Post-Training Assessment:** Re-administering the VVIQ and Apple Test to measure progress against the Week 1 baseline.

### Daily Session Structure (10–15 minutes)
1. **Calibrating Breath & Relaxation (2 min):** Reducing extraneous sensory noise.
2. **Guided Scaffolding Exercise (8 min):** Step-by-step visual/spatial prompt with visual timers and optional audio guidance.
3. **Self-Rating & Reflection (2 min):** Logging vividness ratings (1–5) and sensory notes in the local progress tracker.

---

## 7. Technology Stack & Architecture

To achieve zero installation, instant load times, and universal cross-device execution, the application is engineered as a modern **WebAssembly** client:

```
+-----------------------------------------------------------+
|                   Browser / GitHub Pages                  |
|                                                           |
|   +---------------------------------------------------+   |
|   |             Qt Quick 2 / QML Layer                |   |
|   |   (Declarative UI, Touch/Mouse, SVG Graphics,     |   |
|   |    Visualizer Components, Responsive Layouts)     |   |
|   +---------------------------------------------------+   |
|                             ▲                             |
|                             │ Q_PROPERTY / Signals        |
|                             ▼                             |
|   +---------------------------------------------------+   |
|   |                 C++ Core Engine                   |   |
|   |   (VVIQ Test Machine, Scoring Algorithm,          |   |
|   |    6-Week Protocol Scheduler, Metrics Store)      |   |
|   +---------------------------------------------------+   |
|                             │                             |
|                             ▼                             |
|   +---------------------------------------------------+   |
|   |            Emscripten HTML5 / Web Storage         |   |
|   |    (IndexedDB / LocalStorage, Single-Thread Wasm) |   |
|   +---------------------------------------------------+   |
+-----------------------------------------------------------+
```

### Core Technologies
* **Language:** Modern **C++** (C++17 or C++20 standard).
  * High performance, strict type safety, zero garbage-collection latency.
  * Encapsulates all domain logic: psychometric state machines, scoring algorithms, session timers, and progress calculation.
* **UI Framework:** **Qt 6 / Qt Quick (QML)**.
  * Declarative, hardware-accelerated user interface running over WebGL / WebGPU canvas.
  * Fluid transitions, high-DPI scaling, and responsive design adapting seamlessly to mobile, tablet, and desktop screens.
* **Target Runtime:** **WebAssembly (Wasm)** compiled via **Emscripten SDK (`emscripten`)**.
  * Executes directly inside any modern web browser at near-native speed without plugins.

### Concurrency & Threading Model: Single-Threaded WebAssembly
* **Design Decision:** The WebAssembly binary is compiled strictly in **single-thread mode** (without Emscripten `pthreads` / `SharedArrayBuffer`).
* **Critical Advantages for GitHub Pages Hosting:**
  * Multi-threaded WebAssembly requires `SharedArrayBuffer`, which modern browsers only enable when the hosting web server serves strict Cross-Origin Isolation HTTP headers:
    * `Cross-Origin-Opener-Policy: same-origin`
    * `Cross-Origin-Embedder-Policy: require-corp`
  * Standard GitHub Pages static hosting **does not** permit customizing HTTP response headers.
  * By building as a single-threaded WebAssembly application, the app works **out-of-the-box on standard GitHub Pages** with zero proxy hacks or service worker headers workarounds, ensuring 100% compatibility across Chrome, Firefox, Safari, Edge, iOS Safari, and Android Chrome.
  * Event-driven timers, asynchronous animations, and non-blocking state transitions are managed natively via Qt's event loop and QML animation system on the main browser thread.

### Internationalization & Bilingual Architecture (QTranslator & Qt Linguist)
* **Bilingual Design from Inception:** The application is architected and implemented bilingually from day one, launching initially with **German (`de_DE`)** and **English (`en_US`)**. All assessment questions, psychometric prompts, instructional guides, disclaimers, and UI labels are fully localized.
* **Qt Translation Framework (`QTranslator`):**
  * Translatable strings are strictly wrapped using `qsTr()` / `qsTrId()` within Qt Quick (QML) and `QObject::tr()` / `QT_TR_NOOP()` in C++.
  * Dynamic in-app language switching is supported at runtime without reloading the web page or interrupting active sessions: the C++ application engine installs the target `QTranslator`, re-evaluates bound strings, and updates the QML interface reactively.
* **Translation Quality & Verification via `linguist.exe`:**
  * Translation files (`.ts` XML sources) are extracted via `lupdate` (configured via CMake `qt_add_translations`).
  * All translations—particularly the nuanced psychological formulations of VVIQ scenarios and sensory training steps—are reviewed and verified using **`linguist.exe` (Qt Linguist)** to ensure contextual correctness, grammatical precision, and terminological alignment with German literature (e.g., Monzel 2025) and original English sources (Marks 1973, Rhodes 2024).
  * Validated translation catalogs are compiled into binary `.qm` files using `lrelease` and embedded directly into the WebAssembly executable via the Qt Resource System (`qrc:/translations/`) for zero network latency.

### Data Persistence
* User test scores, session history, and training streaks are stored locally within the browser sandbox using HTML5 `localStorage` / `IndexedDB` via Emscripten virtual file system persistence. No remote server or external account registration is required, guaranteeing complete user privacy.

---

## 8. Directory Structure Overview

```text
Aphantasie/
├── README.md                     # Project outline, scientific basis, and architecture (this file)
├── wiki.txt                      # Original Wikipedia reference article and citations
├── translations/                 # Bilingual translation catalogs (verified with linguist.exe)
│   ├── aphantasia_de.ts          # German translation source (XML)
│   ├── aphantasia_en.ts          # English translation source (XML)
│   ├── aphantasia_de.qm          # Compiled binary German catalog
│   └── aphantasia_en.qm          # Compiled binary English catalog
├── sources/                      # Full-text research library (PDFs, books, HTML archives)
│   ├── SOURCES_INDEX.md          # Exhaustive catalog of all downloaded research papers & books
│   ├── Dance_2022_Prevalence_...pdf
│   ├── Zeman_2015_Lives_without_imagery_...pdf
│   ├── Zeman_2020_Phantasia_...pdf
│   ├── Zeman_2024_Trends_in_Cognitive_Sciences.pdf
│   ├── Keogh_2018_Blind_mind_...pdf
│   ├── Keogh_2024_Revisiting_the_blind_mind.pdf
│   ├── Dawes_2024_Multisensory_subtypes_...pdf
│   ├── Monzel_2025_Dissertation_BonnDoc.pdf
│   ├── Ribot_1897_Evolution_des_idees_generales.pdf
│   ├── Hadamard_1945_Psychology_of_Invention_...pdf
│   ├── Huxley_2004_Doors_of_Perception.pdf
│   ├── Larner_Dictionary_of_Neurological_Signs.pdf
│   └── ... (additional scientific articles and media archives)
└── sources_download_scripts/     # Automated retrieval and parsing scripts
```

---

## 9. Next Steps & Development Roadmap

1. **Architecture & Project Setup:**
   * Create `CMakeLists.txt` configured for Qt 6 WebAssembly toolchain.
   * Configure single-threaded compilation flags (`-s USE_PTHREADS=0`).
   * Setup `qt_add_translations` in CMake to generate and compile bilingual catalogs (`aphantasia_de.ts`, `aphantasia_en.ts`).
2. **Translation Verification Workflow:**
   * Extract translatable strings using `lupdate`.
   * Verify and refine German and English strings in `linguist.exe`.
   * Compile `.qm` bundles using `lrelease` and bundle into Qt resources.
3. **C++ Core Engine Implementation:**
   * Implement `LanguageManager` encapsulating `QTranslator` runtime switching.
   * Implement `VviqTestEngine` with 16 standardized questions and verified scoring rubrics.
   * Implement `TrainingScheduleManager` managing the 6-week progressive curriculum.
   * Implement local storage serializer for test records and progress metrics.
   * Implement `DataExporter` generating standardized JSON and CSV exports of local participant logs.
4. **Qt Quick UI Implementation:**
   * Design modern, serene visual style with accessible color contrast and typography.
   * Add bilingual language toggle (DE / EN) in the navigation bar.
   * Build mandatory **Informed Consent & Research Disclaimer Dialog** (declaring research nature, non-medical device status, and local data policy).
   * Build header controls with one-click **"Download My Data"** and **"View Source Code"** (GitHub repository link).
   * Build interactive Apple Test onboarding screen.
   * Build step-by-step VVIQ questionnaire flow.
   * Build daily guided training player with visual cues, timers, and instructions.
   * Build progress dashboard displaying longitudinal imagery scores.
5. **CI/CD & Deployment:**
   * Configure GitHub Actions workflow for automated CMake build via Emscripten.
   * Deploy compiled WebAssembly artifacts directly to GitHub Pages.
