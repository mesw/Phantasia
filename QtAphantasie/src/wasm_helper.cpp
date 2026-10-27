#include "wasm_helper.h"
#include <QDebug>

#ifdef __EMSCRIPTEN__
#include <emscripten.h>
#else
#include <QDesktopServices>
#include <QUrl>
#include <QStandardPaths>
#include <QFile>
#include <QDir>
#endif

void WasmHelper::downloadFile(const QString &filename, const QString &content, const QString &mimeType)
{
#ifdef __EMSCRIPTEN__
    QByteArray base64Data = content.toUtf8().toBase64();
    QString js = QString(
        "var a = document.createElement('a');"
        "a.download = '%1';"
        "a.href = 'data:%2;charset=utf-8;base64,%3';"
        "document.body.appendChild(a);"
        "a.click();"
        "document.body.removeChild(a);"
    ).arg(filename, mimeType, QString::fromLatin1(base64Data));

    emscripten_run_script(js.toUtf8().constData());
#else
    QString downloadDir = QStandardPaths::writableLocation(QStandardPaths::DownloadLocation);
    if (downloadDir.isEmpty()) {
        downloadDir = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
    }
    QString fullPath = QDir(downloadDir).filePath(filename);
    QFile file(fullPath);
    if (file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        file.write(content.toUtf8());
        file.close();
        qInfo() << "Saved data export file to:" << fullPath;
        QDesktopServices::openUrl(QUrl::fromLocalFile(downloadDir));
    } else {
        qWarning() << "Failed to write data export file to:" << fullPath;
    }
#endif
}

void WasmHelper::openUrlInBrowser(const QString &url)
{
#ifdef __EMSCRIPTEN__
    QString js = QString("window.open('%1', '_blank');").arg(url);
    emscripten_run_script(js.toUtf8().constData());
#else
    QDesktopServices::openUrl(QUrl(url));
#endif
}
