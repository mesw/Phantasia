#ifndef WASM_HELPER_H
#define WASM_HELPER_H

#include <QString>

class WasmHelper
{
public:
    static void downloadFile(const QString &filename, const QString &content, const QString &mimeType);
    static void openUrlInBrowser(const QString &url);
};

#endif // WASM_HELPER_H
