#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>
#include "src/languagemanager.h"
#include "src/storagemanager.h"
#include "src/vviqengine.h"
#include "src/trainingengine.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setOrganizationName("AphantasiaStudy");
    app.setOrganizationDomain("aphantasiastudy.org");
    app.setApplicationName("QtAphantasie");
    app.setApplicationVersion("1.0.0");

    QQmlApplicationEngine engine;

    LanguageManager languageManager;
    StorageManager storageManager;
    VviqEngine vviqEngine;
    TrainingEngine trainingEngine;

    languageManager.init(&engine);

    engine.rootContext()->setContextProperty("languageManager", &languageManager);
    engine.rootContext()->setContextProperty("storageManager", &storageManager);
    engine.rootContext()->setContextProperty("vviqEngine", &vviqEngine);
    engine.rootContext()->setContextProperty("trainingEngine", &trainingEngine);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.loadFromModule("QtAphantasie", "Main");

    return app.exec();
}
