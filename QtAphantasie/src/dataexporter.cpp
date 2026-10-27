#include "dataexporter.h"
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QDateTime>
#include <QSysInfo>

QString DataExporter::exportToJson(const QVariantList &assessments, const QVariantList &trainingSessions)
{
    QJsonObject root;
    root["application"] = QStringLiteral("Aphantasia Test & Training Client");
    root["version"] = QStringLiteral("1.0.0");
    root["export_timestamp"] = QDateTime::currentDateTimeUtc().toString(Qt::ISODateWithMs);
    root["disclaimer"] = QStringLiteral("Research and educational self-exploration only. Not a medical device. Data stored locally on participant device.");

    QJsonObject participantMetadata;
    participantMetadata["platform"] = QSysInfo::prettyProductName();
    participantMetadata["kernel_type"] = QSysInfo::kernelType();
    root["metadata"] = participantMetadata;

    QJsonArray assessArray;
    for (const QVariant &item : assessments) {
        QVariantMap map = item.toMap();
        QJsonObject obj = QJsonObject::fromVariantMap(map);
        assessArray.append(obj);
    }
    root["assessments"] = assessArray;

    QJsonArray trainArray;
    for (const QVariant &item : trainingSessions) {
        QVariantMap map = item.toMap();
        QJsonObject obj = QJsonObject::fromVariantMap(map);
        trainArray.append(obj);
    }
    root["training_sessions"] = trainArray;

    QJsonDocument doc(root);
    return QString::fromUtf8(doc.toJson(QJsonDocument::Indented));
}

QString DataExporter::exportAssessmentsToCsv(const QVariantList &assessments)
{
    QString csv;
    csv += "timestamp,apple_test_level,vviq_total_score,vviq_category,percentile,psiq_auditory,psiq_tactile,psiq_kinesthetic,psiq_olfactory,psiq_gustatory,psiq_emotional,item1,item2,item3,item4,item5,item6,item7,item8,item9,item10,item11,item12,item13,item14,item15,item16\n";

    for (const QVariant &item : assessments) {
        QVariantMap m = item.toMap();
        QVariantMap psiq = m.value("psiqScores").toMap();
        QVariantList items = m.value("itemAnswers").toList();

        QString line = QString("\"%1\",%2,%3,\"%4\",%5,%6,%7,%8,%9,%10,%11")
                           .arg(m.value("timestamp").toString())
                           .arg(m.value("appleLevel").toInt())
                           .arg(m.value("vviqScore").toInt())
                           .arg(m.value("category").toString().replace("\"", "\"\""))
                           .arg(m.value("percentile").toDouble(), 0, 'f', 1)
                           .arg(psiq.value("auditory", 0).toDouble())
                           .arg(psiq.value("tactile", 0).toDouble())
                           .arg(psiq.value("kinesthetic", 0).toDouble())
                           .arg(psiq.value("olfactory", 0).toDouble())
                           .arg(psiq.value("gustatory", 0).toDouble())
                           .arg(psiq.value("emotional", 0).toDouble());

        for (int i = 0; i < 16; ++i) {
            int val = (i < items.size()) ? items.at(i).toInt() : 0;
            line += QString(",%1").arg(val);
        }
        line += "\n";
        csv += line;
    }

    return csv;
}

QString DataExporter::exportTrainingToCsv(const QVariantList &trainingSessions)
{
    QString csv;
    csv += "timestamp,week,day,global_day,vividness_rating,duration_seconds,sensory_notes\n";

    for (const QVariant &item : trainingSessions) {
        QVariantMap m = item.toMap();
        int week = m.value("week").toInt();
        int day = m.value("day").toInt();
        int globalDay = (week - 1) * 7 + day;

        QString notes = m.value("notes").toString().replace("\"", "\"\"");

        QString line = QString("\"%1\",%2,%3,%4,%5,%6,\"%7\"\n")
                           .arg(m.value("timestamp").toString())
                           .arg(week)
                           .arg(day)
                           .arg(globalDay)
                           .arg(m.value("rating").toInt())
                           .arg(m.value("durationSeconds").toInt())
                           .arg(notes);
        csv += line;
    }

    return csv;
}

QString DataExporter::exportCombinedCsv(const QVariantList &assessments, const QVariantList &trainingSessions)
{
    QString csv;
    csv += "# ==========================================================\n";
    csv += "# APHANTASIA RESEARCH & TRAINING - LOCAL PARTICIPANT DATA\n";
    csv += QString("# Export Timestamp: %1\n").arg(QDateTime::currentDateTimeUtc().toString(Qt::ISODateWithMs));
    csv += "# Disclaimer: Research & educational use only. Not a medical device.\n";
    csv += "# ==========================================================\n\n";

    csv += "# --- SECTION 1: ASSESSMENT BATTERY (VVIQ, Apple Test, Psi-Q) ---\n";
    csv += exportAssessmentsToCsv(assessments);
    csv += "\n# --- SECTION 2: 6-WEEK FUNCTIONAL IMAGERY TRAINING SESSIONS ---\n";
    csv += exportTrainingToCsv(trainingSessions);

    return csv;
}
