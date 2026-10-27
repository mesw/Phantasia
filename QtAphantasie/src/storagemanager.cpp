#include "storagemanager.h"
#include "dataexporter.h"
#include "wasm_helper.h"
#include <QSettings>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QDateTime>
#include <QDebug>

StorageManager::StorageManager(QObject *parent)
    : QObject(parent)
{
    reloadCache();
}

void StorageManager::reloadCache()
{
    QSettings settings("AphantasiaStudy", "QtAphantasie");
    m_consentAccepted = settings.value("consentAccepted", false).toBool();

    QString assessJson = settings.value("assessmentsJson", "").toString();
    m_assessments.clear();
    if (!assessJson.isEmpty()) {
        QJsonDocument doc = QJsonDocument::fromJson(assessJson.toUtf8());
        if (doc.isArray()) {
            m_assessments = doc.array().toVariantList();
        }
    }

    QString trainJson = settings.value("trainingJson", "").toString();
    m_trainingSessions.clear();
    if (!trainJson.isEmpty()) {
        QJsonDocument doc = QJsonDocument::fromJson(trainJson.toUtf8());
        if (doc.isArray()) {
            m_trainingSessions = doc.array().toVariantList();
        }
    }
}

bool StorageManager::consentAccepted() const
{
    return m_consentAccepted;
}

void StorageManager::setConsentAccepted(bool accepted)
{
    if (m_consentAccepted != accepted) {
        m_consentAccepted = accepted;
        QSettings settings("AphantasiaStudy", "QtAphantasie");
        settings.setValue("consentAccepted", m_consentAccepted);
        emit consentAcceptedChanged();
    }
}

void StorageManager::saveConsent(bool accepted)
{
    setConsentAccepted(accepted);
}

bool StorageManager::hasBaseline() const
{
    return !m_assessments.isEmpty();
}

int StorageManager::latestVviqScore() const
{
    if (m_assessments.isEmpty())
        return 0;
    return m_assessments.last().toMap().value("vviqScore", 0).toInt();
}

QString StorageManager::latestCategory() const
{
    if (m_assessments.isEmpty())
        return QString();
    return m_assessments.last().toMap().value("category", "").toString();
}

int StorageManager::latestAppleLevel() const
{
    if (m_assessments.isEmpty())
        return 0;
    return m_assessments.last().toMap().value("appleLevel", 0).toInt();
}

double StorageManager::latestPercentile() const
{
    if (m_assessments.isEmpty())
        return 0.0;
    return m_assessments.last().toMap().value("percentile", 0.0).toDouble();
}

int StorageManager::completedSessionsCount() const
{
    return m_trainingSessions.size();
}

int StorageManager::trainingStreak() const
{
    return m_trainingSessions.size();
}

int StorageManager::currentWeek() const
{
    int count = m_trainingSessions.size();
    int week = (count / 7) + 1;
    if (week > 6) week = 6;
    return week;
}

int StorageManager::currentDay() const
{
    int count = m_trainingSessions.size();
    int day = (count % 7) + 1;
    if (day > 7) day = 7;
    return day;
}

void StorageManager::saveAssessmentResult(int appleLevel, int vviqScore, const QString &category, double percentile, const QVariantMap &psiqScores, const QVariantList &itemAnswers)
{
    QVariantMap record;
    record["timestamp"] = QDateTime::currentDateTimeUtc().toString(Qt::ISODateWithMs);
    record["appleLevel"] = appleLevel;
    record["vviqScore"] = vviqScore;
    record["category"] = category;
    record["percentile"] = percentile;
    record["psiqScores"] = psiqScores;
    record["itemAnswers"] = itemAnswers;

    m_assessments.append(record);

    QJsonArray arr = QJsonArray::fromVariantList(m_assessments);
    QJsonDocument doc(arr);
    QSettings settings("AphantasiaStudy", "QtAphantasie");
    settings.setValue("assessmentsJson", QString::fromUtf8(doc.toJson(QJsonDocument::Compact)));

    emit baselineChanged();
}

QVariantList StorageManager::getAssessmentHistory() const
{
    return m_assessments;
}

QVariantMap StorageManager::getLatestAssessment() const
{
    if (m_assessments.isEmpty())
        return QVariantMap();
    return m_assessments.last().toMap();
}

void StorageManager::saveTrainingSession(int week, int day, int rating, const QString &notes, int durationSeconds)
{
    // Check if session for this week/day already exists, if so update it, else append
    bool updated = false;
    for (int i = 0; i < m_trainingSessions.size(); ++i) {
        QVariantMap s = m_trainingSessions[i].toMap();
        if (s.value("week").toInt() == week && s.value("day").toInt() == day) {
            s["rating"] = rating;
            s["notes"] = notes;
            s["durationSeconds"] = durationSeconds;
            s["timestamp"] = QDateTime::currentDateTimeUtc().toString(Qt::ISODateWithMs);
            m_trainingSessions[i] = s;
            updated = true;
            break;
        }
    }

    if (!updated) {
        QVariantMap s;
        s["week"] = week;
        s["day"] = day;
        s["rating"] = rating;
        s["notes"] = notes;
        s["durationSeconds"] = durationSeconds;
        s["timestamp"] = QDateTime::currentDateTimeUtc().toString(Qt::ISODateWithMs);
        m_trainingSessions.append(s);
    }

    QJsonArray arr = QJsonArray::fromVariantList(m_trainingSessions);
    QJsonDocument doc(arr);
    QSettings settings("AphantasiaStudy", "QtAphantasie");
    settings.setValue("trainingJson", QString::fromUtf8(doc.toJson(QJsonDocument::Compact)));

    emit trainingProgressChanged();
}

QVariantList StorageManager::getTrainingHistory() const
{
    return m_trainingSessions;
}

bool StorageManager::isSessionCompleted(int week, int day) const
{
    for (const QVariant &v : m_trainingSessions) {
        QVariantMap s = v.toMap();
        if (s.value("week").toInt() == week && s.value("day").toInt() == day) {
            return true;
        }
    }
    return false;
}

int StorageManager::getSessionRating(int week, int day) const
{
    for (const QVariant &v : m_trainingSessions) {
        QVariantMap s = v.toMap();
        if (s.value("week").toInt() == week && s.value("day").toInt() == day) {
            return s.value("rating", 0).toInt();
        }
    }
    return 0;
}

void StorageManager::clearAllData()
{
    QSettings settings("AphantasiaStudy", "QtAphantasie");
    settings.remove("consentAccepted");
    settings.remove("assessmentsJson");
    settings.remove("trainingJson");

    m_consentAccepted = false;
    m_assessments.clear();
    m_trainingSessions.clear();

    emit consentAcceptedChanged();
    emit baselineChanged();
    emit trainingProgressChanged();
    emit dataCleared();
}

QString StorageManager::exportDataAsJson() const
{
    return DataExporter::exportToJson(m_assessments, m_trainingSessions);
}

QString StorageManager::exportDataAsCsv() const
{
    return DataExporter::exportCombinedCsv(m_assessments, m_trainingSessions);
}

void StorageManager::downloadDataAsJson()
{
    QString content = exportDataAsJson();
    QString filename = QString("aphantasia_study_export_%1.json")
                           .arg(QDateTime::currentDateTime().toString("yyyyMMdd_hhmmss"));
    WasmHelper::downloadFile(filename, content, "application/json");
}

void StorageManager::downloadDataAsCsv()
{
    QString content = exportDataAsCsv();
    QString filename = QString("aphantasia_study_export_%1.csv")
                           .arg(QDateTime::currentDateTime().toString("yyyyMMdd_hhmmss"));
    WasmHelper::downloadFile(filename, content, "text/csv");
}

void StorageManager::openSourceCodeUrl()
{
    WasmHelper::openUrlInBrowser("https://github.com/Michi-D/Aphantasie");
}
