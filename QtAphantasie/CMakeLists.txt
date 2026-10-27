cmake_minimum_required(VERSION 3.16)

project(QtAphantasie VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick QuickControls2)

qt_standard_project_setup(REQUIRES 6.8)

if(EMSCRIPTEN)
    # Configure single-threaded WebAssembly for standard static GitHub Pages hosting
    add_compile_options(-sUSE_PTHREADS=0)
    add_link_options(-sUSE_PTHREADS=0)
endif()

qt_add_executable(appQtAphantasie
    main.cpp
    src/languagemanager.h
    src/languagemanager.cpp
    src/storagemanager.h
    src/storagemanager.cpp
    src/vviqengine.h
    src/vviqengine.cpp
    src/trainingengine.h
    src/trainingengine.cpp
    src/dataexporter.h
    src/dataexporter.cpp
    src/wasm_helper.h
    src/wasm_helper.cpp
)

set_source_files_properties(qml/components/Theme.qml
    PROPERTIES
        QT_QML_SINGLETON_TYPE TRUE
)

qt_add_qml_module(appQtAphantasie
    URI QtAphantasie
    QML_FILES
        Main.qml
        qml/components/Theme.qml
        qml/components/NavigationHeader.qml
        qml/components/ConsentDialog.qml
        qml/components/AppleTestCard.qml
        qml/components/VviqQuestionnaire.qml
        qml/components/MultisensoryCheck.qml
        qml/components/DiagnosticReport.qml
        qml/components/TrainingDashboard.qml
        qml/components/TrainingSessionPlayer.qml
        qml/components/BreathingPacer.qml
        qml/components/AfterimageViewer.qml
        qml/components/MentalRotationViewer.qml
        qml/components/LayerAssemblyViewer.qml
        qml/components/ProgressChart.qml
        qml/components/DataEthicsModal.qml
        qml/views/AssessmentView.qml
        qml/views/TrainingView.qml
        qml/views/ProgressView.qml
        qml/views/AboutView.qml
)

qt_add_resources(appQtAphantasie "translations"
    PREFIX "/"
    FILES
        translations/aphantasia_de.qm
        translations/aphantasia_en.qm
)

# ── Emoji font ─────────────────────────────────────────────────────────────
# Source: Google Noto Color Emoji font
# License: SIL Open Font License 1.1 — free to embed in any application.
set(EMOJI_FONT "${CMAKE_CURRENT_SOURCE_DIR}/../third_party/noto-emoji/fonts/NotoColorEmoji.ttf")
if(NOT EXISTS "${EMOJI_FONT}")
    set(EMOJI_FONT "${CMAKE_SOURCE_DIR}/third_party/noto-emoji/fonts/NotoColorEmoji.ttf")
endif()

if(EXISTS "${EMOJI_FONT}")
    set_source_files_properties("${EMOJI_FONT}"
        PROPERTIES QT_RESOURCE_ALIAS "NotoColorEmoji.ttf"
    )
    qt_add_resources(appQtAphantasie "appfonts"
        PREFIX "/fonts"
        FILES "${EMOJI_FONT}"
        BIG_RESOURCES
    )
    target_compile_definitions(appQtAphantasie PRIVATE HAS_EMOJI_FONT)
    message(STATUS "Emoji font found: ${EMOJI_FONT}")
else()
    message(WARNING "Emoji font not found at ${EMOJI_FONT}")
endif()

if(EMSCRIPTEN)
    target_compile_definitions(appQtAphantasie PRIVATE APHANTASIA_WASM)
    target_link_options(appQtAphantasie PRIVATE "SHELL:-s ALLOW_MEMORY_GROWTH=1")
endif()

set_target_properties(appQtAphantasie PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appQtAphantasie
    PRIVATE
        Qt6::Quick
        Qt6::QuickControls2
)

include(GNUInstallDirs)
install(TARGETS appQtAphantasie
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
