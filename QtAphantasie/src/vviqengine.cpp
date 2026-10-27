#include "vviqengine.h"
#include <cmath>

VviqEngine::VviqEngine(QObject *parent)
    : QObject(parent)
{
}

QString VviqEngine::getScenarioTitle(int scenarioIndex) const
{
    switch (scenarioIndex) {
    case 0:
        return tr("Scenario 1: Familiar Relative or Friend");
    case 1:
        return tr("Scenario 2: The Rising Sun");
    case 2:
        return tr("Scenario 3: A Familiar Shop");
    case 3:
        return tr("Scenario 4: A Country Scene");
    default:
        return QString();
    }
}

QString VviqEngine::getScenarioDescription(int scenarioIndex) const
{
    switch (scenarioIndex) {
    case 0:
        return tr("Think of some relative or friend whom you frequently see (but who is not with you at present) and consider carefully the picture that comes before your mind's eye.");
    case 1:
        return tr("Visualize the rising sun. Look carefully at the picture that comes before your mind's eye.");
    case 2:
        return tr("Think of the front of a shop which you often go to. Consider the picture that comes before your mind's eye.");
    case 3:
        return tr("Finally, think of a country scene which involves trees, mountains and a lake. Consider the picture that comes before your mind's eye.");
    default:
        return QString();
    }
}

QVariantMap VviqEngine::getItem(int index) const
{
    QVariantMap map;
    if (index < 0 || index >= 16)
        return map;

    int scenario = index / 4;
    int itemInScenario = index % 4;

    map["index"] = index;
    map["scenario"] = scenario;
    map["scenarioTitle"] = getScenarioTitle(scenario);
    map["scenarioDescription"] = getScenarioDescription(scenario);

    QString text;
    switch (index) {
    case 0:
        text = tr("The exact contours of face, head, shoulders and body.");
        break;
    case 1:
        text = tr("Characteristic poses of head, stances, etc.");
        break;
    case 2:
        text = tr("The precise carriage, length of step, etc. in walking.");
        break;
    case 3:
        text = tr("The different colors worn in some familiar clothes.");
        break;
    case 4:
        text = tr("The sun is rising above the horizon into a hazy sky.");
        break;
    case 5:
        text = tr("The sky clears and surrounds the sun with blueness.");
        break;
    case 6:
        text = tr("Clouds. A storm blows up, with flashes of lightning.");
        break;
    case 7:
        text = tr("A rainbow appears.");
        break;
    case 8:
        text = tr("The overall appearance of the shop from the opposite side of the road.");
        break;
    case 9:
        text = tr("A window display including the shape, color, and details of individual items for sale.");
        break;
    case 10:
        text = tr("You are near the entrance. The color, shape and details of the door.");
        break;
    case 11:
        text = tr("You enter the shop and go to the counter. The counter, assistant, and money exchanging.");
        break;
    case 12:
        text = tr("The contours of the landscape (trees, bushes, mountains).");
        break;
    case 13:
        text = tr("The color and shape of the trees and plants.");
        break;
    case 14:
        text = tr("The color and shape of a lake, river, or water.");
        break;
    case 15:
        text = tr("A strong wind blows on trees and water waves.");
        break;
    default:
        break;
    }

    map["text"] = text;
    map["itemNumber"] = index + 1;
    return map;
}

QString VviqEngine::getRatingLabel(int score) const
{
    switch (score) {
    case 1:
        return tr("No image at all");
    case 2:
        return tr("Vague & dim");
    case 3:
        return tr("Moderately clear");
    case 4:
        return tr("Clear & vivid");
    case 5:
        return tr("Perfect vision");
    default:
        return QString();
    }
}

QString VviqEngine::getRatingDescription(int score) const
{
    switch (score) {
    case 1:
        return tr("No image at all, you only 'know' that you are thinking of the object.");
    case 2:
        return tr("Vague and dim image; fleeting and difficult to hold in mind.");
    case 3:
        return tr("Moderately clear and reasonably vivid mental image.");
    case 4:
        return tr("Clear and reasonably vivid, comparable to actual viewing.");
    case 5:
        return tr("Perfectlys clear and as vivid as normal vision.");
    default:
        return QString();
    }
}

QString VviqEngine::classifyVviq(int totalScore) const
{
    if (totalScore <= 16) {
        return tr("Total Aphantasia");
    } else if (totalScore <= 31) {
        return tr("Congenital / Marked Aphantasia");
    } else if (totalScore <= 54) {
        return tr("Hypophantasia (Weak Imagery)");
    } else if (totalScore <= 74) {
        return tr("Typical Imagery Vividness");
    } else {
        return tr("Hyperphantasia (Extreme Imagery)");
    }
}

QString VviqEngine::classifyVviqCode(int totalScore) const
{
    if (totalScore <= 16) {
        return QStringLiteral("total_aphantasia");
    } else if (totalScore <= 31) {
        return QStringLiteral("aphantasia");
    } else if (totalScore <= 54) {
        return QStringLiteral("hypophantasia");
    } else if (totalScore <= 74) {
        return QStringLiteral("typical");
    } else {
        return QStringLiteral("hyperphantasia");
    }
}

QString VviqEngine::classifyVviqExplanation(int totalScore) const
{
    if (totalScore <= 16) {
        return tr("You scored 16 out of 80 points. According to established scientific consensus (Dance et al. 2022; Zeman et al. 2015, 2020), this corresponds to complete / total aphantasia. You process visual concepts abstractly and semantically without voluntary internal visual representations.");
    } else if (totalScore <= 31) {
        return tr("You scored %1 out of 80 points. Scores below 32 are classified in scientific literature as marked aphantasia (Dance et al. 2022). While occasional fleeting flashes or faint silhouettes may occur, voluntary visual reconstruction is severely attenuated.");
    } else if (totalScore <= 54) {
        return tr("You scored %1 out of 80 points. This falls into the hypophantasia range (32-54 points). You have partial or dim voluntary mental imagery, with noticeable variation in clarity, detail, or stability across different scenarios.");
    } else if (totalScore <= 74) {
        return tr("You scored %1 out of 80 points. This represents the typical / normal range of human visual imagination (55-74 points, population mean ~56.8), characterized by clear and reasonably vivid mental pictures.");
    } else {
        return tr("You scored %1 out of 80 points. Scores of 75 and above denote hyperphantasia (Zeman et al. 2020), an imagery capability that is as vivid, sharp, and rich in color as real-world ocular perception.");
    }
}

double VviqEngine::calculatePercentile(int score) const
{
    // Population parameters from Dance, Ipser, & Simner (2022): mean = 56.8, SD = 12.5 (N = 1,004)
    const double mean = 56.8;
    const double sd = 12.5;
    double z = (score - mean) / (sd * std::sqrt(2.0));
    double percentile = 0.5 * (1.0 + std::erf(z)) * 100.0;
    if (percentile < 0.1) percentile = 0.1;
    if (percentile > 99.9) percentile = 99.9;
    return std::round(percentile * 10.0) / 10.0;
}

QString VviqEngine::classifyMultisensory(int vviqScore, const QVariantMap &psiqScores) const
{
    if (vviqScore >= 32) {
        return tr("Typical Multi-Modal Profile");
    }

    double sumNonVisual = 0.0;
    int count = 0;
    QStringList modalities = {"auditory", "tactile", "kinesthetic", "olfactory", "gustatory", "emotional"};
    for (const QString &mod : modalities) {
        if (psiqScores.contains(mod)) {
            sumNonVisual += psiqScores.value(mod).toDouble();
            count++;
        }
    }

    double avgNonVisual = (count > 0) ? (sumNonVisual / count) : 3.0;

    if (avgNonVisual >= 2.5) {
        return tr("Unimodal Visual Aphantasia");
    } else {
        return tr("Multisensory Aphantasia");
    }
}

QString VviqEngine::classifyMultisensoryExplanation(int vviqScore, const QVariantMap &psiqScores) const
{
    if (vviqScore >= 32) {
        return tr("Your visual imagery is in the typical or hypophantasia range. Your multi-modal sensory profile shows normal cross-sensory imagination.");
    }

    double sumNonVisual = 0.0;
    int count = 0;
    QStringList modalities = {"auditory", "tactile", "kinesthetic", "olfactory", "gustatory", "emotional"};
    for (const QString &mod : modalities) {
        if (psiqScores.contains(mod)) {
            sumNonVisual += psiqScores.value(mod).toDouble();
            count++;
        }
    }

    double avgNonVisual = (count > 0) ? (sumNonVisual / count) : 3.0;

    if (avgNonVisual >= 2.5) {
        return tr("Based on Dawes et al. (2024), your results indicate Unimodal Visual Aphantasia. Your lack of imagery is selective to the visual modality, while non-visual channels (such as hearing, touch, or motor simulation) remain functional and provide excellent anchors for neurocognitive training.");
    } else {
        return tr("Based on Dawes et al. (2024), your results indicate Multisensory Aphantasia. Your imagery reduction spans multiple sensory domains beyond vision. Training protocols will begin with semantic, proprioceptive, and physiological afterimage stimuli rather than auditory or sensory pegs.");
    }
}

QVariantList VviqEngine::getAppleLevels() const
{
    QVariantList list;

    auto addLevel = [&](int level, const QString &title, const QString &desc, const QString &quote) {
        QVariantMap m;
        m["level"] = level;
        m["title"] = title;
        m["description"] = desc;
        m["quote"] = quote;
        list.append(m);
    };

    addLevel(1, tr("Level 1: Photorealistic"),
             tr("Vivid color, 3D depth, specular lighting, realistic skin texture, and shadow on the table."),
             tr("\"I see a crisp, photorealistic red apple with shiny reflections and a wooden table.\""));

    addLevel(2, tr("Level 2: Vivid"),
             tr("Identifiable red apple with clear shape and color, but slightly softer textures or simpler lighting."),
             tr("\"I clearly see a red apple. The colors are definite, though not quite like a real photograph.\""));

    addLevel(3, tr("Level 3: Moderate"),
             tr("Subdued colors, simplified illustration or cartoon-like appearance. Somewhat flat and static."),
             tr("\"I see an apple shape with some red, but it feels like a drawing or muted sketch.\""));

    addLevel(4, tr("Level 4: Faint / Vague"),
             tr("Translucent, dim, or fleeting outline. Mostly grayish silhouette, difficult to stabilize."),
             tr("\"I catch a brief, smoky gray outline or faint shape that disappears when I focus on it.\""));

    addLevel(5, tr("Level 5: Complete Aphantasia"),
             tr("Absolute blackness. No visual sensation whatsoever. Conceptual knowledge only."),
             tr("\"I know what an apple is, its taste and shape, but when I close my eyes there is only pitch blackness.\""));

    return list;
}

QVariantList VviqEngine::getMultisensoryModalityList() const
{
    QVariantList list;

    auto addMod = [&](const QString &key, const QString &name, const QString &prompt) {
        QVariantMap m;
        m["key"] = key;
        m["name"] = name;
        m["prompt"] = prompt;
        list.append(m);
    };

    addMod("auditory", tr("Auditory (Inner Hearing)"),
           tr("Imagine hearing the clear sound of a familiar friend's laugh or a ringing telephone."));

    addMod("tactile", tr("Tactile (Touch & Texture)"),
           tr("Imagine running your fingertips over coarse sandpaper or touching warm velvet fabric."));

    addMod("kinesthetic", tr("Kinesthetic (Motor & Balance)"),
           tr("Imagine the physical sensation in your legs and lungs when running up a flight of stairs."));

    addMod("olfactory", tr("Olfactory (Smell)"),
           tr("Imagine the distinctive aroma of fresh ground coffee or ozone after rain."));

    addMod("gustatory", tr("Gustatory (Taste)"),
           tr("Imagine the intense taste of biting into a fresh sour lemon slice."));

    addMod("emotional", tr("Emotional (Affective Bodily Sensation)"),
           tr("Imagine the somatic bodily feeling of sudden joyous excitement or profound calm."));

    return list;
}
