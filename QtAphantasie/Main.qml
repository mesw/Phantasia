import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "qml/components"
import "qml/views"

Window {
    id: appWindow
    width: 1200
    height: 820
    minimumWidth: 800
    minimumHeight: 600
    visible: true
    title: qsTr("Phantasia | Vividness Assessment & Neurocognitive Training")
    color: Theme.bgDark

    property int activeTab: 0

    Column {
        anchors.fill: parent
        spacing: 0

        // Navigation Bar
        NavigationHeader {
            id: navHeader
            width: parent.width
            currentTab: appWindow.activeTab
            onTabChanged: function(tabIndex) {
                appWindow.activeTab = tabIndex;
            }
            onDownloadDataRequested: {
                dataModal.open();
            }
        }

        // Main View Container
        Item {
            width: parent.width
            height: parent.height - navHeader.height

            AssessmentView {
                anchors.fill: parent
                visible: appWindow.activeTab === 0
                onNavigateToTraining: {
                    appWindow.activeTab = 1;
                }
                onDownloadDataRequested: {
                    dataModal.open();
                }
            }

            TrainingView {
                anchors.fill: parent
                visible: appWindow.activeTab === 1
            }

            ProgressView {
                anchors.fill: parent
                visible: appWindow.activeTab === 2
                onDownloadDataRequested: {
                    dataModal.open();
                }
            }

            AboutView {
                anchors.fill: parent
                visible: appWindow.activeTab === 3
                onDownloadDataRequested: {
                    dataModal.open();
                }
            }
        }
    }

    // Informed Consent Modal (Mandatory on First Run)
    ConsentDialog {
        id: consentDialog
        visible: !storageManager.consentAccepted
    }

    // Data Sovereignty & Export Modal
    DataEthicsModal {
        id: dataModal
    }

    Component.onCompleted: {
        if (!storageManager.consentAccepted) {
            consentDialog.open();
        }
    }
}
