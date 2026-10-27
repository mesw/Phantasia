import QtQuick

pragma Singleton

QtObject {
    // Background Colors
    readonly property color bgDark: "#0B0F19"
    readonly property color bgCard: "#131C2E"
    readonly property color bgCardElevated: "#1E293B"
    readonly property color bgInput: "#0F172A"
    readonly property color bgGlass: "#202A40"

    // Border Colors
    readonly property color borderDim: "#1E293B"
    readonly property color borderMedium: "#334155"
    readonly property color borderBright: "#475569"

    // Primary Accents
    readonly property color primary: "#6366F1"        // Indigo
    readonly property color primaryLight: "#818CF8"
    readonly property color primaryHover: "#4F46E5"
    readonly property color primaryGlow: "#4338CA"

    // Secondary Accents
    readonly property color accent: "#8B5CF6"         // Violet
    readonly property color accentLight: "#A78BFA"
    readonly property color cyan: "#06B6D4"
    readonly property color cyanLight: "#22D3EE"
    readonly property color emerald: "#10B981"
    readonly property color emeraldLight: "#34D399"
    readonly property color amber: "#F59E0B"
    readonly property color rose: "#F43F5E"

    // Text Colors
    readonly property color textPrimary: "#F8FAFC"
    readonly property color textSecondary: "#94A3B8"
    readonly property color textMuted: "#64748B"
    readonly property color textLink: "#38BDF8"

    // Radii
    readonly property real radiusSm: 6
    readonly property real radiusMd: 12
    readonly property real radiusLg: 16
    readonly property real radiusXl: 24
    readonly property real radiusPill: 999

    // Font Sizes
    readonly property int fontXs: 11
    readonly property int fontSm: 13
    readonly property int fontMd: 15
    readonly property int fontLg: 18
    readonly property int fontXl: 22
    readonly property int fontTitle: 28
    readonly property int fontHuge: 36
}
