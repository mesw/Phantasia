#include "trainingengine.h"

TrainingEngine::TrainingEngine(QObject *parent)
    : QObject(parent)
{
}

QVariantMap TrainingEngine::getWeekOverview(int week) const
{
    QVariantMap map;
    map["week"] = week;

    switch (week) {
    case 1:
        map["title"] = tr("Week 1: Multi-Modal Anchoring & Sensory Scaffolding");
        map["subtitle"] = tr("Building non-visual mental anchors through touch, sound, and spatial proprioception.");
        map["scientificBasis"] = tr("Rhodes et al. (2024); Dawes et al. (2024); Kelly (2020)");
        map["themeColor"] = "#3B82F6"; // Blue
        break;
    case 2:
        map["title"] = tr("Week 2: High-Contrast Forms & Negative Afterimages");
        map["subtitle"] = tr("Stimulating the primary visual pathway using retinal excitation and conscious stabilization.");
        map["scientificBasis"] = tr("Rhodes et al. (2024); Zeman (2024); Keogh & Pearson (2024)");
        map["themeColor"] = "#8B5CF6"; // Purple
        break;
    case 3:
        map["title"] = tr("Week 3: Component Decomposition & Layered Assembly");
        map["subtitle"] = tr("Deconstructing objects into discrete cognitive layers: geometry, color, texture, and light.");
        map["scientificBasis"] = tr("Monzel (2025); Rhodes et al. (2024)");
        map["themeColor"] = "#EC4899"; // Pink
        break;
    case 4:
        map["title"] = tr("Week 4: Spatial Transformation & Mental Rotation");
        map["subtitle"] = tr("Developing dynamic visual-spatial manipulation, perspective shifting, and 3D mental rotation.");
        map["scientificBasis"] = tr("Shepard & Metzler (1971); Monzel (2021); Zeman (2024)");
        map["themeColor"] = "#10B981"; // Emerald
        break;
    case 5:
        map["title"] = tr("Week 5: Affective & Dynamic Scene Synthesis");
        map["subtitle"] = tr("Leveraging emotional valence, autobiographical memory, and rich multi-sensory integration.");
        map["scientificBasis"] = tr("Rhodes et al. (2024); Wicken et al. (2021)");
        map["themeColor"] = "#F59E0B"; // Amber
        break;
    case 6:
        map["title"] = tr("Week 6: Real-World Integration & Maintenance");
        map["subtitle"] = tr("Applying mental imagery strategies to daily memory, motor execution, and longitudinal tracking.");
        map["scientificBasis"] = tr("Rhodes et al. (2024); Kelly (2020); Marks (1973)");
        map["themeColor"] = "#06B6D4"; // Cyan
        break;
    default:
        break;
    }

    return map;
}

QVariantList TrainingEngine::getAllWeeks() const
{
    QVariantList list;
    for (int w = 1; w <= 6; ++w) {
        list.append(getWeekOverview(w));
    }
    return list;
}

QVariantMap TrainingEngine::getSessionDetails(int week, int day) const
{
    QVariantMap map;
    if (week < 1 || week > 6 || day < 1 || day > 7)
        return map;

    int globalDay = (week - 1) * 7 + day;
    map["week"] = week;
    map["day"] = day;
    map["globalDay"] = globalDay;

    QVariantMap weekInfo = getWeekOverview(week);
    map["weekTitle"] = weekInfo.value("title");
    map["themeColor"] = weekInfo.value("themeColor");

    // Standard session durations in seconds
    map["breathDuration"] = 120; // 2 minutes
    map["exerciseDuration"] = 480; // 8 minutes
    map["reflectionDuration"] = 120; // 2 minutes

    // Default relaxation guidance
    map["breathTitle"] = tr("Phase 1: Calibrating Breath & Relaxation");
    map["breathInstructions"] = tr("Find a comfortable seated position with upright spine. Inhale deeply for 4 seconds as the circle expands, hold for 4 seconds, exhale smoothly for 4 seconds as it contracts, and hold for 4 seconds. Let extraneous muscular tension release with each breath cycle.");

    // Default reflection guidance
    map["reflectionTitle"] = tr("Phase 3: Self-Rating & Sensory Reflection");
    map["reflectionInstructions"] = tr("Rate the vividness or stability of your experience today on a 1-5 scale. Note down which sensory modality (tactile, spatial, auditory, semantic) felt most accessible and anchored your mental representation.");

    QString title;
    QString focus;
    QString exerciseMode; // "spatial_tactile", "afterimage_cross", "afterimage_rings", "afterimage_shapes", "layer_assembly", "mental_rotation_2d", "mental_rotation_3d", "affective_nature", "pegboard", "reassessment"
    QString exerciseInstructions;
    QString scientificNote;

    switch (globalDay) {
    // ----------------------------------------------------
    // WEEK 1: Multi-Modal Anchoring
    // ----------------------------------------------------
    case 1:
        title = tr("Day 1: Tactile Blueprinting");
        focus = tr("Physical-to-mental tactile transfer using familiar textured objects.");
        exerciseMode = QStringLiteral("spatial_tactile");
        exerciseInstructions = tr("Hold a textured physical object (e.g. a coin, a key, or an embossed stone) in your hand. Feel its edges, ridges, and surface temperature with your fingertips for 60 seconds with eyes open. Then close your eyes. Reconstruct purely the tactile sensations: the metallic coldness, the sharp ridges, the weight in your palm. Do not force any visual picture. Focus 100% on tactile proprioception.");
        scientificNote = tr("Anchoring conceptual models in intact somatosensory cortices builds top-down frontoparietal scaffolding (Dawes et al. 2024; Kelly 2020).");
        break;
    case 2:
        title = tr("Day 2: Spatial Coordinate Mapping");
        focus = tr("Constructing a 3x3 mental coordinate grid without visual rendering.");
        exerciseMode = QStringLiteral("spatial_tactile");
        exerciseInstructions = tr("Mentally construct a 3x3 grid in the space directly before your chest. Assign objects to positions: Top-Left = Book, Center = Water Glass, Bottom-Right = Key. Mentally reach toward each position, feeling the physical spatial distance and coordinates. Move between positions without requiring a picture.");
        scientificNote = tr("Visuospatial working memory and egocentric spatial coordinates operate independently of visual imagery vividness (Monzel 2025; Jacobs et al. 2018).");
        break;
    case 3:
        title = tr("Day 3: Acoustic Resonance Anchors");
        focus = tr("Recalling auditory pitch, timbre, and rhythm as mental anchors.");
        exerciseMode = QStringLiteral("spatial_tactile");
        exerciseInstructions = tr("Focus on a specific acoustic event: the rhythmic ticking of a clock, raindrops pattering on a window, or a familiar doorbell. Replay the sound in your mind with exact timing, pitch, and timbre. Notice the spatial direction from which the sound originates.");
        scientificNote = tr("Dawes et al. (2024) demonstrated that auditory imagery is preserved in unimodal aphantasics and can prime visual association networks.");
        break;
    case 4:
        title = tr("Day 4: Thermal & Weight Invariance");
        focus = tr("Synthesizing physical mass and thermal contrast internally.");
        exerciseMode = QStringLiteral("spatial_tactile");
        exerciseInstructions = tr("Imagine holding an ice cube in your left hand and a warm ceramic mug of tea in your right hand. Alternate your mental attention between the intense cold melting in your left palm and the soothing radiant heat warming your right fingers.");
        scientificNote = tr("Somatosensory integration activates insular and parietal neural pathways that strengthen subsequent multi-modal imagery (Rhodes et al. 2024).");
        break;
    case 5:
        title = tr("Day 5: Semantic Feature Association");
        focus = tr("Propositional attribute matrices for object reconstruction.");
        exerciseMode = QStringLiteral("spatial_tactile");
        exerciseInstructions = tr("Choose an everyday object (e.g., an apple). Do not try to visualize it immediately. Instead, systematically list its propositional attributes: Shape = spherical with indentations; Material = organic skin; Weight = ~180g; Smell = crisp sweet floral; Sound = sharp crunch. Feel the structural completeness of the concept.");
        scientificNote = tr("Monzel (2025) highlights propositional knowledge and semantic networks as the core compensatory cognitive mechanism in aphantasia.");
        break;
    case 6:
        title = tr("Day 6: Dual-Modal Cross-Priming");
        focus = tr("Simultaneously binding sound and tactile texture.");
        exerciseMode = QStringLiteral("spatial_tactile");
        exerciseInstructions = tr("Combine two non-visual modalities: imagine writing on a dry chalkboard with a crisp piece of chalk. Feel the chalk dust and friction on your fingertips while mentally hearing the squeak and tap of the chalk against the slate.");
        scientificNote = tr("Multi-sensory binding recruits supramodal associative regions in the temporal and parietal lobes (Dawes et al. 2024).");
        break;
    case 7:
        title = tr("Day 7: Week 1 Integration & Restorative Consolidation");
        focus = tr("Reviewing non-visual anchors and assessing ease of activation.");
        exerciseMode = QStringLiteral("spatial_tactile");
        exerciseInstructions = tr("Revisit your strongest anchor from Days 1-6 (tactile, spatial, auditory, or thermal). Spend 8 minutes gently activating this anchor and holding it stable for 30-second intervals. Celebrate the clarity of your non-visual cognitive models.");
        scientificNote = tr("Weekly consolidation periods prevent cognitive fatigue and facilitate synaptic consolidation (Rhodes et al. 2024).");
        break;

    // ----------------------------------------------------
    // WEEK 2: High-Contrast Forms & Negative Afterimages
    // ----------------------------------------------------
    case 8:
        title = tr("Day 8: High-Contrast Monochromatic Cross");
        focus = tr("Retinal afterimage induction via 30-second fixation.");
        exerciseMode = QStringLiteral("afterimage_cross");
        exerciseInstructions = tr("Fixate your gaze strictly upon the small red dot in the center of the high-contrast white cross for exactly 30 seconds. Do not let your eyes wander. When the timer ends and the screen turns black, gently close your eyes. Observe the dark cross / complementary retinal afterimage floating before you. Try to hold its outline steady without blinking.");
        scientificNote = tr("Retinal afterimages provide a physiological visual signal to V1/V2, bypassing impaired top-down generation while exercising mental image stabilization (Rhodes et al. 2024).");
        break;
    case 9:
        title = tr("Day 9: Concentric Rings & Radial Patterns");
        focus = tr("Observing retinal contrast dissipation and edge contours.");
        exerciseMode = QStringLiteral("afterimage_rings");
        exerciseInstructions = tr("Fixate on the center point of the high-contrast alternating black and white rings for 30 seconds. When the timer signals, close your eyes. Notice the concentric rings inverted in brightness. Track how long the geometric edges remain detectable in your visual field.");
        scientificNote = tr("Concentric high-spatial-frequency patterns maximally stimulate oriented receptive fields in early visual cortex (Hubel & Wiesel; Zeman 2024).");
        break;
    case 10:
        title = tr("Day 10: Geometric Silhouette Stabilization");
        focus = tr("Actively holding a fading afterimage in mental focus.");
        exerciseMode = QStringLiteral("afterimage_shapes");
        exerciseInstructions = tr("Fixate on the high-contrast geometric shape (equilateral triangle) for 30 seconds. Close your eyes. When the afterimage begins to fade, actively mentally reinforce the three vertices: 'Point A at top, Point B bottom-left, Point C bottom-right'. Note whether verbal labelling prolongs the visual sensation.");
        scientificNote = tr("Dual-coding (verbal propositional reinforcement coupled with sensory afterimage) enhances attentional persistence (Monzel 2025).");
        break;
    case 11:
        title = tr("Day 11: Chromatic Complementary Afterimages");
        focus = tr("Color-opponent retinal stimulation (Red/Cyan).");
        exerciseMode = QStringLiteral("afterimage_shapes");
        exerciseInstructions = tr("Fixate upon the saturated red circular disc for 30 seconds. Close your eyes. Observe the complementary cyan/blue-green hue that emerges on the dark visual field. Pay close attention to the hue saturation and the border between the circle and the dark surround.");
        scientificNote = tr("Color-opponent retinal ganglion cells create vivid complementary afterimages that activate chromatic processing pathways in area V4.");
        break;
    case 12:
        title = tr("Day 12: Saccadic Motion & Afterimage Tracking");
        focus = tr("Moving an afterimage across the internal visual field.");
        exerciseMode = QStringLiteral("afterimage_cross");
        exerciseInstructions = tr("Induce the cross afterimage (30s fixation). With eyes closed, slowly shift your physical gaze to the upper-left, then center, then upper-right. Notice how the afterimage tracks your eye movements. Practice intentionally 'pinning' the image in one mental quadrant.");
        scientificNote = tr("Dissociating retinocentric from spatiocentric visual coordinates strengthens frontoparietal attentional steering (Keogh & Pearson 2024).");
        break;
    case 13:
        title = tr("Day 13: Bridging Afterimage to Voluntary Imagery");
        focus = tr("Transitioning from a fading retinal image into mental recall.");
        exerciseMode = QStringLiteral("afterimage_shapes");
        exerciseInstructions = tr("Induce the geometric afterimage. As it fades toward blackness, immediately transition into mentally reconstructing the identical shape using your spatial knowledge from Week 1. Try to maintain the 'feeling of shape' even as the physiological retinal signal disappears.");
        scientificNote = tr("The critical breakthrough in Functional Imagery Training is transitioning from bottom-up perceptual signal to top-down voluntary maintenance (Rhodes et al. 2024).");
        break;
    case 14:
        title = tr("Day 14: Week 2 Retinal Integration Review");
        focus = tr("Assessing afterimage duration, color fidelity, and stability.");
        exerciseMode = QStringLiteral("afterimage_cross");
        exerciseInstructions = tr("Conduct two consecutive 30-second afterimage sessions. Measure the duration (in seconds) that the afterimage remains observable. Log whether the edges felt sharper or lasted longer compared to Day 8.");
        scientificNote = tr("Systematic tracking of visual persistence provides objective behavioral markers of sensory engagement.");
        break;

    // ----------------------------------------------------
    // WEEK 3: Component Decomposition & Layered Assembly
    // ----------------------------------------------------
    case 15:
        title = tr("Day 15: Layer 1 - Geometric Wireframe");
        focus = tr("Focusing exclusively on boundary lines and silhouettes.");
        exerciseMode = QStringLiteral("layer_assembly");
        exerciseInstructions = tr("Study the single object outline (an apple silhouette). Do not think about color, texture, or lighting. Focus solely on the outer contour: the curved sides, the top cleft where the stem sits, the gentle tapered bottom. Close your eyes and trace this outline in mental space.");
        scientificNote = tr("Decomposing complex scenes into isolated dimensional layers prevents cognitive overload in low baseline imagers (Rhodes et al. 2024).");
        break;
    case 16:
        title = tr("Day 16: Layer 2 - Flat Monochromatic Color Fill");
        focus = tr("Applying a uniform, unshaded color field within boundaries.");
        exerciseMode = QStringLiteral("layer_assembly");
        exerciseInstructions = tr("Recall the silhouette from Day 15. Now imagine filling the interior with a single uniform, flat hue: deep crimson red. No highlights, no shadows, no texture—just a solid block of color inside the boundary lines.");
        scientificNote = tr("Separating chromatic assignment from illumination reduces working memory demands during feature synthesis.");
        break;
    case 17:
        title = tr("Day 17: Layer 3 - Surface Texture & Material");
        focus = tr("Integrating tactile roughness, smoothness, and waxiness.");
        exerciseMode = QStringLiteral("layer_assembly");
        exerciseInstructions = tr("Onto the colored shape, superimpose the tactile surface quality: the smooth waxy skin of an apple, tiny natural stipples, and a stiff brown fibrous stem. Use your Week 1 tactile anchors to ground the surface feel.");
        scientificNote = tr("Connecting tactile memory to visual surface representation activates the ventral visual stream and collateral sulcus (Monzel 2025).");
        break;
    case 18:
        title = tr("Day 18: Layer 4 - Directional Light & Cast Shadow");
        focus = tr("Introducing a light source and mental illumination.");
        exerciseMode = QStringLiteral("layer_assembly");
        exerciseInstructions = tr("Position an imaginary light source at the top-left (10 o'clock position). Picture a soft white reflection gleam on the upper-left curve of the apple, and a crescent of darker shading on the lower-right side, with a soft oval shadow cast onto the table below.");
        scientificNote = tr("Illumination modeling recruits 3D shape-from-shading mechanisms in parietal-occipital circuits (Zeman 2024).");
        break;
    case 19:
        title = tr("Day 19: Complete Object Synthesis (The Apple)");
        focus = tr("Stacking all 4 layers sequentially into a cohesive representation.");
        exerciseMode = QStringLiteral("layer_assembly");
        exerciseInstructions = tr("Systematically construct the complete object in 4 timed 2-minute steps: Step 1 (0-2m): Contour silhouette; Step 2 (2-4m): Red color fill; Step 3 (4-6m): Waxy texture & stem; Step 4 (6-8m): Light highlight & cast shadow. Observe how stacking makes visualization manageable.");
        scientificNote = tr("Stepwise feature stacking directly mirrors the core protocol of Rhodes et al. (2024), yielding measurable gains in athletes with imagery deficits.");
        break;
    case 20:
        title = tr("Day 20: Layered Assembly with Familiar Everyday Objects");
        focus = tr("Applying the 4-layer method to a ceramic coffee mug.");
        exerciseMode = QStringLiteral("layer_assembly");
        exerciseInstructions = tr("Apply the 4-layer method to a new object: a coffee mug. 1) Cylinder outline with a looped handle; 2) Glossy ceramic cobalt-blue color; 3) Cool smooth porcelain texture; 4) Bright light reflection on the rim and dark shadow inside the hollow interior.");
        scientificNote = tr("Generalizing the feature-stacking strategy to varied shapes reinforces cognitive schema transfer.");
        break;
    case 21:
        title = tr("Day 21: Week 3 Scaffolding Synthesis & Review");
        focus = tr("Consolidating the 4-layer decomposition pipeline.");
        exerciseMode = QStringLiteral("layer_assembly");
        exerciseInstructions = tr("Select any object currently in the room. Deconstruct it mentally into its 4 layers (Outline, Color, Texture, Lighting) over 8 minutes. Rate how structured the mental assembly feels compared to attempting an immediate holistic visual image.");
        scientificNote = tr("Rhodes et al. (2024) noted that low-imagers frequently fail when trying to summon holistic images instantly; stepwise assembly solves this barrier.");
        break;

    // ----------------------------------------------------
    // WEEK 4: Spatial Transformation & Mental Rotation
    // ----------------------------------------------------
    case 22:
        title = tr("Day 22: 2D Planar Mental Rotation");
        focus = tr("Rotating letters and asymmetrical symbols in 2D space.");
        exerciseMode = QStringLiteral("mental_rotation_2d");
        exerciseInstructions = tr("Examine the letter 'F' displayed on screen. Mentally rotate it clockwise by 90 degrees (facing downward). Then rotate it another 90 degrees (facing upside down). Trace where the crossbars point at each step. Verify against the interactive rotating preview.");
        scientificNote = tr("Classic Shepard & Metzler (1971) paradigm: mental rotation speed is proportional to angular disparity, utilizing motor and premotor cortex.");
        break;
    case 23:
        title = tr("Day 23: 3D Isometric Wireframe Cube");
        focus = tr("Tracking vertices and edges during 3D spatial rotation.");
        exerciseMode = QStringLiteral("mental_rotation_3d");
        exerciseInstructions = tr("Look at the 3D isometric wireframe cube. Identify the front-top-right corner. Mentally rotate the cube slowly around its vertical axis by 45 degrees. Which vertex comes toward you? Which face disappears into the background? Use the interactive rotation controller to verify.");
        scientificNote = tr("3D mental rotation activates the intraparietal sulcus and dorsal visual stream, which remain intact in congenital aphantasia (Monzel 2021).");
        break;
    case 24:
        title = tr("Day 24: Mental Zooming & Scale Alteration");
        focus = tr("Dynamically varying mental focal length from macro to detail.");
        exerciseMode = QStringLiteral("mental_rotation_3d");
        exerciseInstructions = tr("Mentally picture a grandfather clock from 5 meters away (full wooden cabinet, ticking pendulum). Now mentally 'zoom in' like a camera lens until you are 10 centimeters from the watch face, inspecting the metallic hands and roman numerals. Zoom smoothly back out.");
        scientificNote = tr("Mental zoom exercises recruit topographic visual buffers and attentional magnification mechanisms.");
        break;
    case 25:
        title = tr("Day 25: Mental Orbiting (Camera Perspective Shifts)");
        focus = tr("Moving your viewpoint around a stationary central object.");
        exerciseMode = QStringLiteral("mental_rotation_3d");
        exerciseInstructions = tr("Picture a wooden chair in the center of the room. Keep the chair completely still, but imagine walking in a smooth circle around it. View it from the front, from the side profile, from directly behind the backrest, and from the other side.");
        scientificNote = tr("Allocentric to egocentric reference frame transformations stimulate hippocampal and retro-splenial spatial navigation networks.");
        break;
    case 26:
        title = tr("Day 26: Spatial Unfolding (Net to 3D Polyhedron)");
        focus = tr("Folding a 2D cross-shaped net into a 3D closed box.");
        exerciseMode = QStringLiteral("mental_rotation_2d");
        exerciseInstructions = tr("Visualize a flat cross made of 6 squares (a cube net). Mentally fold the bottom flap up 90 degrees to form the front wall. Fold the left and right flaps up to form side walls. Fold the top square over to form the lid. Confirm the completed 3D box.");
        scientificNote = tr("Spatial origami and paper-folding tasks measure pure spatial transformation without requiring photorealistic color rendering.");
        break;
    case 27:
        title = tr("Day 27: Multi-Object Spatial Choreography");
        focus = tr("Maintaining spatial relationships between 3 interacting objects.");
        exerciseMode = QStringLiteral("mental_rotation_3d");
        exerciseInstructions = tr("Place 3 items in mental space on a tabletop: a red apple, a glass bottle, and a small coin. Mentally swap the positions of the apple and bottle. Then slide the coin between them. Track the relative left/right and front/back spatial distances at each movement.");
        scientificNote = tr("Multi-object spatial tracking recruits parietal working memory buffers and strengthens spatial relational models.");
        break;
    case 28:
        title = tr("Day 28: Week 4 Spatial Manipulation Review");
        focus = tr("Evaluating speed and confidence of 3D mental rotation.");
        exerciseMode = QStringLiteral("mental_rotation_3d");
        exerciseInstructions = tr("Take a 3D pyramid or cube. Rotate it smoothly along two axes simultaneously (yaw and pitch) for 8 minutes. Log whether keeping track of vertices felt more intuitive and fluid compared to Day 22.");
        scientificNote = tr("Spatial manipulation mastery provides the structural skeleton for complex scene generation in Weeks 5 and 6.");
        break;

    // ----------------------------------------------------
    // WEEK 5: Affective & Dynamic Scene Synthesis
    // ----------------------------------------------------
    case 29:
        title = tr("Day 29: Emotionally Salient Natural Landscape");
        focus = tr("Using emotional calm and safety to amplify sensory details.");
        exerciseMode = QStringLiteral("affective_nature");
        exerciseInstructions = tr("Choose an outdoor setting where you felt profound peace (e.g. a secluded pine forest or a tranquil lakeshore). Re-activate the visceral feeling of safety and calm in your chest. Let this emotional tone draw in the ambient details: the gentle breeze on your face, the smell of pine needles, the green canopy.");
        scientificNote = tr("Emotional valence activates the amygdala and ventromedial prefrontal cortex, which powerfully boost visual cortex sensitivity (Wicken et al. 2021; Rhodes et al. 2024).");
        break;
    case 30:
        title = tr("Day 30: Soundscape-Driven Visual Construction");
        focus = tr("Using rich acoustic soundscapes to generate spatial imagery.");
        exerciseMode = QStringLiteral("affective_nature");
        exerciseInstructions = tr("Imagine sitting on a sea cliff. First, fill your mind with sound: rhythmic roaring waves crashing against rocks below, distant seagulls calling, wind gusting past your ears. As the soundscape stabilizes, allow the visual horizon and white ocean foam to materialize from the sound sources.");
        scientificNote = tr("Auditory-to-visual cross-modal transfer is one of the most effective compensatory pathways identified in low-imagery athletes (Rhodes et al. 2024).");
        break;
    case 31:
        title = tr("Day 31: Kinesthetic Motor Imagery Rehearsal");
        focus = tr("Internal physical sensation of athletic or expressive movement.");
        exerciseMode = QStringLiteral("affective_nature");
        exerciseInstructions = tr("Mentally perform a physical movement you know well: swimming a stroke, swinging a racket, or dancing. Feel the exact muscle contractions, the balance adjustments, the acceleration, and the air resistance. Experience the movement from the first-person perspective ('internal imagery').");
        scientificNote = tr("Motor imagery activates supplementary motor area (SMA) and primary motor cortex even in individuals with complete visual aphantasia.");
        break;
    case 32:
        title = tr("Day 32: Autobiographical Room Recall");
        focus = tr("Reconstructing a familiar physical room from childhood.");
        exerciseMode = QStringLiteral("affective_nature");
        exerciseInstructions = tr("Think of a bedroom or living room from your childhood or past. Stand mentally at the doorway. What was immediately to your left? Where was the window? What was the floor covering? Combine spatial memory with nostalgic emotional resonance to tour the room.");
        scientificNote = tr("Autobiographical memory retrieval engages the default mode network (DMN), linking episodic knowledge with spatial layouts.");
        break;
    case 33:
        title = tr("Day 33: Multi-Sensory Meal Experience");
        focus = tr("Fusing taste, aroma, warmth, and visual table arrangement.");
        exerciseMode = QStringLiteral("affective_nature");
        exerciseInstructions = tr("Imagine preparing your favorite comforting meal. Experience the aroma wafting from the pan, the sizzle of food cooking, the weight of the fork, the temperature of the first bite, and the rich flavor on your tongue. Bring all senses together simultaneously.");
        scientificNote = tr("Flavor and food imagery maximally engage multi-sensory orbitofrontal and gustatory cortices, providing rich multi-modal reinforcement.");
        break;
    case 34:
        title = tr("Day 34: Dynamic Weather Transition");
        focus = tr("Visualizing continuous change: sunlight breaking through storm clouds.");
        exerciseMode = QStringLiteral("affective_nature");
        exerciseInstructions = tr("Start with a dark, overcast, rainy sky. Hear the rain and feel the damp chill. Now mentally simulate gradual change: the clouds thinning, a golden beam of sunlight piercing through, the raindrops sparkling in the light, and a colorful rainbow forming across the sky (Scenario B of VVIQ).");
        scientificNote = tr("Simulating temporal dynamism trains temporal-parietal continuity in voluntary visualization.");
        break;
    case 35:
        title = tr("Day 35: Week 5 Multisensory Immersion Review");
        focus = tr("Assessing the richness of emotionally grounded scenes.");
        exerciseMode = QStringLiteral("affective_nature");
        exerciseInstructions = tr("Spend 8 minutes in your favorite synthesized scenario from Days 29-34. Notice whether sensory details arrive more effortlessly when anchored in physical feelings and emotional valence.");
        scientificNote = tr("Consolidation of multi-modal associative circuits prior to real-world integration.");
        break;

    // ----------------------------------------------------
    // WEEK 6: Real-World Integration & Maintenance
    // ----------------------------------------------------
    case 36:
        title = tr("Day 36: Dual-Coding Spatial Pegboard");
        focus = tr("Applying spatial anchors and semantic pegs for memory recall.");
        exerciseMode = QStringLiteral("pegboard");
        exerciseInstructions = tr("Learn a list of 5 unrelated items using spatial pegs in your current room (e.g., 1=Doorway, 2=Sofa, 3=Desk, 4=Window, 5=Bookshelf). Place an unusual item at each location using the 4-layer method. Walk mentally through the room and retrieve all 5 items effortlessly.");
        scientificNote = tr("The Method of Loci operates through spatial mapping and intact hippocampal navigation, offering immense memory utility for aphantasics (Kelly 2020).");
        break;
    case 37:
        title = tr("Day 37: Pre-Action Mental Rehearsal");
        focus = tr("Mentally walking through a planned real-world task before doing it.");
        exerciseMode = QStringLiteral("pegboard");
        exerciseInstructions = tr("Select a practical task you need to complete today (e.g. preparing an ingredient, packing a bag, or walking a specific route). Rehearse every physical step in advance in your mind: opening drawers, selecting objects, checking off items. Notice how this primes real execution.");
        scientificNote = tr("Functional Imagery Training (FIT) utilizes pre-action mental simulation to boost performance, goal adherence, and self-efficacy (Rhodes et al. 2024).");
        break;
    case 38:
        title = tr("Day 38: Creative Problem Solving via Spatial Models");
        focus = tr("Rearranging furniture or conceptual layouts mentally.");
        exerciseMode = QStringLiteral("pegboard");
        exerciseInstructions = tr("Imagine wanting to rearrange a room or fit multiple large suitcases into the trunk of a car. Use your Week 4 mental rotation and Week 1 spatial mapping skills to test different configurations mentally before touching any physical object.");
        scientificNote = tr("Spatial reasoning without visual phenomenology is a documented cognitive strength in aphantasic individuals (Zeman 2010; Monzel 2025).");
        break;
    case 39:
        title = tr("Day 39: Cognitive Flexibility & Strategy Switching");
        focus = tr("Consciously toggling between propositional, spatial, and visual modes.");
        exerciseMode = QStringLiteral("pegboard");
        exerciseInstructions = tr("Take a single concept (e.g. 'A sailboat at sunset'). Spend 2 minutes experiencing it purely propositionally (word lists and facts). Then spend 2 minutes experiencing it spatially (distances, mast height, hull angle). Then spend 2 minutes checking for visual flashes. Observe the differences.");
        scientificNote = tr("Metacognitive flexibility allows individuals to deploy the optimal cognitive strategy for specific tasks (Monzel 2025).");
        break;
    case 40:
        title = tr("Day 40: Lifelong Imagery Maintenance Protocol");
        focus = tr("Establishing a sustainable daily 5-minute micro-routine.");
        exerciseMode = QStringLiteral("pegboard");
        exerciseInstructions = tr("Design your personal sustainable maintenance habit: 1 minute breathing calibration, 3 minutes with your most effective exercise (e.g. afterimage conditioning or 4-layer assembly), and 1 minute reflection. Consistency preserves neuroplastic gains long-term.");
        scientificNote = tr("Rhodes et al. (2024) proved that training gains were maintained at a 6-month follow-up when key exercises were periodically integrated into daily habits.");
        break;
    case 41:
        title = tr("Day 41: Post-Training Assessment Preparation");
        focus = tr("Reflecting on the 6-week journey and internal changes.");
        exerciseMode = QStringLiteral("pegboard");
        exerciseInstructions = tr("Review your training streak and logged notes from Week 1 to Week 6. Notice how your relationship with your inner mind has evolved—whether through increased visual flashes, heightened tactile/spatial clarity, or deeper appreciation of your unique cognitive architecture.");
        scientificNote = tr("Preparing cognitive state for unbiased psychometric post-training re-evaluation.");
        break;
    case 42:
        title = tr("Day 42: Final Post-Training Re-Assessment");
        focus = tr("Re-taking the VVIQ & Apple Test to quantify longitudinal progress.");
        exerciseMode = QStringLiteral("reassessment");
        exerciseInstructions = tr("Congratulations on completing the full 6-week curriculum! Today you will retake the standardized VVIQ and Apple Test under identical conditions to your Week 1 baseline. The application will compute your longitudinal score delta and generate your comprehensive completion report.");
        scientificNote = tr("Empirical re-administration of validated psychometric instruments to evaluate intervention efficacy (Rhodes et al. 2024; Marks 1973).");
        break;

    default:
        break;
    }

    map["title"] = title;
    map["focus"] = focus;
    map["exerciseMode"] = exerciseMode;
    map["exerciseInstructions"] = exerciseInstructions;
    map["scientificNote"] = scientificNote;

    return map;
}
