#ifndef TRAININGENGINE_H
#define TRAININGENGINE_H

#include <QObject>
#include <QVariantList>
#include <QVariantMap>

class TrainingEngine : public QObject
{
    Q_OBJECT

public:
    explicit TrainingEngine(QObject *parent = nullptr);

    Q_INVOKABLE int totalWeeks() const { return 6; }
    Q_INVOKABLE int daysPerWeek() const { return 7; }
    Q_INVOKABLE int totalSessions() const { return 42; }

    Q_INVOKABLE QVariantMap getSessionDetails(int week, int day) const;
    Q_INVOKABLE QVariantMap getWeekOverview(int week) const;
    Q_INVOKABLE QVariantList getAllWeeks() const;
};

#endif // TRAININGENGINE_H
