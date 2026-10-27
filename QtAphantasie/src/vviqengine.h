#ifndef VVIQENGINE_H
#define VVIQENGINE_H

#include <QObject>
#include <QVariantList>
#include <QVariantMap>

class VviqEngine : public QObject
{
    Q_OBJECT

public:
    explicit VviqEngine(QObject *parent = nullptr);

    Q_INVOKABLE int itemCount() const { return 16; }
    Q_INVOKABLE QVariantMap getItem(int index) const;

    Q_INVOKABLE int scenarioCount() const { return 4; }
    Q_INVOKABLE QString getScenarioTitle(int scenarioIndex) const;
    Q_INVOKABLE QString getScenarioDescription(int scenarioIndex) const;

    Q_INVOKABLE QString getRatingLabel(int score) const;
    Q_INVOKABLE QString getRatingDescription(int score) const;

    Q_INVOKABLE QString classifyVviq(int totalScore) const;
    Q_INVOKABLE QString classifyVviqCode(int totalScore) const;
    Q_INVOKABLE QString classifyVviqExplanation(int totalScore) const;
    Q_INVOKABLE double calculatePercentile(int score) const;

    Q_INVOKABLE QString classifyMultisensory(int vviqScore, const QVariantMap &psiqScores) const;
    Q_INVOKABLE QString classifyMultisensoryExplanation(int vviqScore, const QVariantMap &psiqScores) const;

    Q_INVOKABLE QVariantList getAppleLevels() const;
    Q_INVOKABLE QVariantList getMultisensoryModalityList() const;
};

#endif // VVIQENGINE_H
