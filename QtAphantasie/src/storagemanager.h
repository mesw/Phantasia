#ifndef STORAGEMANAGER_H
#define STORAGEMANAGER_H

#include <QObject>
#include <QVariantList>
#include <QVariantMap>

class StorageManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool consentAccepted READ consentAccepted WRITE setConsentAccepted NOTIFY consentAcceptedChanged)
    Q_PROPERTY(bool hasBaseline READ hasBaseline NOTIFY baselineChanged)
    Q_PROPERTY(int latestVviqScore READ latestVviqScore NOTIFY baselineChanged)
    Q_PROPERTY(QString latestCategory READ latestCategory NOTIFY baselineChanged)
    Q_PROPERTY(int latestAppleLevel READ latestAppleLevel NOTIFY baselineChanged)
    Q_PROPERTY(double latestPercentile READ latestPercentile NOTIFY baselineChanged)
    Q_PROPERTY(int completedSessionsCount READ completedSessionsCount NOTIFY trainingProgressChanged)
    Q_PROPERTY(int trainingStreak READ trainingStreak NOTIFY trainingProgressChanged)
    Q_PROPERTY(int currentWeek READ currentWeek NOTIFY trainingProgressChanged)
    Q_PROPERTY(int currentDay READ currentDay NOTIFY trainingProgressChanged)

public:
    explicit StorageManager(QObject *parent = nullptr);

    bool consentAccepted() const;
    void setConsentAccepted(bool accepted);

    bool hasBaseline() const;
    int latestVviqScore() const;
    QString latestCategory() const;
    int latestAppleLevel() const;
    double latestPercentile() const;

    int completedSessionsCount() const;
    int trainingStreak() const;
    int currentWeek() const;
    int currentDay() const;

    Q_INVOKABLE void saveConsent(bool accepted);
    Q_INVOKABLE void saveAssessmentResult(int appleLevel, int vviqScore, const QString &category, double percentile, const QVariantMap &psiqScores, const QVariantList &itemAnswers);
    Q_INVOKABLE QVariantList getAssessmentHistory() const;
    Q_INVOKABLE QVariantMap getLatestAssessment() const;

    Q_INVOKABLE void saveTrainingSession(int week, int day, int rating, const QString &notes, int durationSeconds);
    Q_INVOKABLE QVariantList getTrainingHistory() const;
    Q_INVOKABLE bool isSessionCompleted(int week, int day) const;
    Q_INVOKABLE int getSessionRating(int week, int day) const;

    Q_INVOKABLE void clearAllData();

    Q_INVOKABLE QString exportDataAsJson() const;
    Q_INVOKABLE QString exportDataAsCsv() const;
    Q_INVOKABLE void downloadDataAsJson();
    Q_INVOKABLE void downloadDataAsCsv();
    Q_INVOKABLE void openSourceCodeUrl();
    Q_INVOKABLE void openUrl(const QString &url);
    Q_INVOKABLE QString getGpl3LicenseText() const;

signals:
    void consentAcceptedChanged();
    void baselineChanged();
    void trainingProgressChanged();
    void dataCleared();

private:
    void reloadCache();
    bool m_consentAccepted = false;
    QVariantList m_assessments;
    QVariantList m_trainingSessions;
};

#endif // STORAGEMANAGER_H
