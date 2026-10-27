#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include <QIcon>
#include <QFontDatabase>
#include <QDebug>
#include "src/languagemanager.h"
#include "src/storagemanager.h"
#include "src/vviqengine.h"
#include "src/trainingengine.h"

int main(int argc, char *argv[])
{
    // Force the Basic Qt Quick Controls style for consistent dark-theme rendering
    // and to prevent OS-native styles (e.g. Windows) from overriding button colors with black text
    QQuickStyle::setStyle("Basic");

    QGuiApplication app(argc, argv);
    app.setOrganizationName("AphantasiaStudy");
    app.setOrganizationDomain("aphantasiastudy.org");
    app.setApplicationName("QtAphantasie");
    app.setApplicationVersion("1.0.0");

    // ── Emoji font ────────────────────────────────────────────────────────
    // Loaded on all platforms; critical for WASM which has no system fonts.
    // The font covers emoji codepoints as a fallback — Latin text is
    // unaffected because Qt always prefers the primary font for those.
#ifdef HAS_EMOJI_FONT
    const int id = QFontDatabase::addApplicationFont(
        QStringLiteral(":/fonts/NotoColorEmoji.ttf"));
    if (id == -1)
        qWarning("Failed to load NotoColorEmoji.ttf from resources");
#endif

    QQmlApplicationEngine engine;

    QObject::connect(&engine, &QQmlApplicationEngine::warnings, [](const QList<QQmlError> &warnings) {
        for (const auto &w : warnings) {
            fprintf(stderr, "QML WARNING: %s\n", qPrintable(w.toString()));
            fflush(stderr);
        }
    });

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
        [](const QUrl &url) {
            fprintf(stderr, "CRITICAL: Object creation failed for URL: %s\n", qPrintable(url.toString()));
            fflush(stderr);
            QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);

    engine.loadFromModule("QtAphantasie", "Main");

    return app.exec();
}
