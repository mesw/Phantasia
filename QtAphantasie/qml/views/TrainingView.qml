import QtQuick
import QtQuick.Controls
import "../components"

Item {
    id: root

    property bool isPlayingSession: false
    property int selectedWeek: 1
    property int selectedDay: 1

    TrainingDashboard {
        anchors.fill: parent
        visible: !root.isPlayingSession
        onLaunchSession: function(week, day) {
            root.selectedWeek = week;
            root.selectedDay = day;
            root.isPlayingSession = true;
        }
    }

    TrainingSessionPlayer {
        anchors.fill: parent
        visible: root.isPlayingSession
        week: root.selectedWeek
        day: root.selectedDay
        onSessionCompleted: {
            root.isPlayingSession = false;
        }
        onExitRequested: {
            root.isPlayingSession = false;
        }
    }
}
