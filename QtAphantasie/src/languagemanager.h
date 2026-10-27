#ifndef LANGUAGEMANAGER_H
#define LANGUAGEMANAGER_H

#include <QObject>
#include <QTranslator>
#include <QQmlApplicationEngine>

class LanguageManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString currentLanguage READ currentLanguage NOTIFY languageChanged)
    Q_PROPERTY(QString languageName READ languageName NOTIFY languageChanged)

public:
    explicit LanguageManager(QObject *parent = nullptr);

    void init(QQmlApplicationEngine *engine);

    QString currentLanguage() const;
    QString languageName() const;

    Q_INVOKABLE void setLanguage(const QString &lang);
    Q_INVOKABLE void toggleLanguage();

signals:
    void languageChanged();

private:
    QQmlApplicationEngine *m_engine = nullptr;
    QTranslator m_translator;
    QString m_currentLanguage = "de";
};

#endif // LANGUAGEMANAGER_H
