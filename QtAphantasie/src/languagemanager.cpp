#include "languagemanager.h"
#include <QCoreApplication>
#include <QSettings>
#include <QDebug>

LanguageManager::LanguageManager(QObject *parent)
    : QObject(parent)
{
    QSettings settings("AphantasiaStudy", "QtAphantasie");
    m_currentLanguage = settings.value("language", "de").toString();
    if (m_currentLanguage != "de" && m_currentLanguage != "en") {
        m_currentLanguage = "de";
    }
}

void LanguageManager::init(QQmlApplicationEngine *engine)
{
    m_engine = engine;
    setLanguage(m_currentLanguage);
}

QString LanguageManager::currentLanguage() const
{
    return m_currentLanguage;
}

QString LanguageManager::languageName() const
{
    return (m_currentLanguage == "de") ? QStringLiteral("Deutsch") : QStringLiteral("English");
}

void LanguageManager::setLanguage(const QString &lang)
{
    QString target = (lang.toLower() == "en") ? "en" : "de";
    m_currentLanguage = target;

    QCoreApplication::removeTranslator(&m_translator);

    QString qmPath = QString(":/translations/aphantasia_%1.qm").arg(target);
    if (m_translator.load(qmPath)) {
        QCoreApplication::installTranslator(&m_translator);
        qInfo() << "Loaded translation catalog:" << qmPath;
    } else {
        qWarning() << "Failed to load translation catalog from resource:" << qmPath;
    }

    QSettings settings("AphantasiaStudy", "QtAphantasie");
    settings.setValue("language", m_currentLanguage);

    if (m_engine) {
        m_engine->retranslate();
    }

    emit languageChanged();
}

void LanguageManager::toggleLanguage()
{
    if (m_currentLanguage == "de") {
        setLanguage("en");
    } else {
        setLanguage("de");
    }
}
