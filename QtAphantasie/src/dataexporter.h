#ifndef DATAEXPORTER_H
#define DATAEXPORTER_H

#include <QString>
#include <QVariantList>
#include <QVariantMap>

class DataExporter
{
public:
    static QString exportToJson(const QVariantList &assessments, const QVariantList &trainingSessions);
    static QString exportAssessmentsToCsv(const QVariantList &assessments);
    static QString exportTrainingToCsv(const QVariantList &trainingSessions);
    static QString exportCombinedCsv(const QVariantList &assessments, const QVariantList &trainingSessions);
};

#endif // DATAEXPORTER_H
