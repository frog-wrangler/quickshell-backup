pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Networking
import qs.config

Singleton {
    id: root

    // ************************************************
    // Properties and property initialization & updating
    // ************************************************
    function init() {}

    property var devices: Networking.devices.values
    property var wifiDevice
    readonly property var networks: wifiDevice?.networks
    readonly property var active: networks?.values.find(network => network.state == ConnectionState.Connected)

    onDevicesChanged: {
        root.wifiDevice = root.devices.find(dev => dev.type == DeviceType.Wifi);
    }

    onWifiDeviceChanged: {
        if (wifiDevice)
            wifiDevice.scannerEnabled = true; // TODO CHANGE THIS TO SAVE POWER
    }

    Component.onCompleted: {
        Networking.wifiEnabled = GlobalStates.wifiActive;
    }

    Connections {
        target: GlobalStates
        function onWifiActiveChanged() {
            Networking.wifiEnabled = GlobalStates.wifiActive;
        }
    }

    // ************************************************
    // Functions for external use
    // ************************************************
    property var nmstate: wifiDevice?.nmState ?? -1
    property var devMode: wifiDevice?.mode ?? -1

    property string nmstateString: "TODO"
    property string devModeString: ""

    onDevModeChanged: {
        devModeString = deviceModeToString();
    }

    function deviceModeToString() {
        let mode = "";
        switch (devMode) {
            case WifiDeviceMode.Mesh:
                mode = "Mesh";
                break;
            case WifiDeviceMode.Station:
                mode = "Station";
                break;
            case WifiDeviceMode.AccessPoint:
                mode = "AccessPoint";
                break;
            case WifiDeviceMode.Unknown:
                mode = "Unknown";
                break;
            case WifiDeviceMode.AdHoc:
                mode = "AdHoc";
                break;
        }
        return mode;
    }

    function nmConnectionStateReasonToString(network: WifiNetwork): string {
        let reason = "";
        switch (network?.nmReason ?? -1) {
            case NMConnectionStateReason.DependencyFailed:
                reason = "DependencyFailed";
                break;
            case NMConnectionStateReason.DeviceRealizeFailed:
                reason = "DeviceRealizeFailed";
                break;
            case NMConnectionStateReason.DeviceDisconnected:
                reason = "DeviceDisconnected";
                break;
            case NMConnectionStateReason.IpConfigInvalid:
                reason = "IpConfigInvalid";
                break;
            case NMConnectionStateReason.ServiceStartTimeout:
                reason = "ServiceStartTimeout";
                break;
            case NMConnectionStateReason.None:
                reason = "None";
                break;
            case NMConnectionStateReason.ServiceStartFailed:
                reason = "ServiceStartFailed";
                break;
            case NMConnectionStateReason.NoSecrets:
                reason = "NoSecrets";
                break;
            case NMConnectionStateReason.UserDisconnected:
                reason = "UserDisconnected";
                break;
            case NMConnectionStateReason.ServiceStopped:
                reason = "ServiceStopped";
                break;
            case NMConnectionStateReason.Unknown:
                reason = "Unknown";
                break;
            case NMConnectionStateReason.ConnectTimeout:
                reason = "ConnectTimeout";
                break;
            case NMConnectionStateReason.LoginFailed:
                reason = "LoginFailed";
                break;
            case NMConnectionStateReason.ConnectionRemoved:
                reason = "ConnectionRemoved";
                break;
        }
        return reason;
    }

    function securityTypeToString(network: WifiNetwork): string {
        let type = "";
        switch (network?.security ?? -1) {
            case WifiSecurityType.WpaEap:
                type = "WpaEap";
                break;
            case WifiSecurityType.Wpa3SuiteB192:
                type = "Wpa3SuiteB192";
                break;
            case WifiSecurityType.DynamicWep:
                type = "DynamicWep";
                break;
            case WifiSecurityType.Wpa2Eap:
                type = "Wpa2Eap";
                break;
            case WifiSecurityType.Wpa2Psk:
                type = "Wpa2Psk";
                break;
            case WifiSecurityType.Leap:
                type = "Leap";
                break;
            case WifiSecurityType.Owe:
                type = "Owe";
                break;
            case WifiSecurityType.Unknown:
                type = "Unknown";
                break;
            case WifiSecurityType.WpaPsk:
                type = "WpaPsk";
                break;
            case WifiSecurityType.StaticWep:
                type = "StaticWep";
                break;
            case WifiSecurityType.Open:
                type = "Open";
                break;
            case WifiSecurityType.Sae:
                type = "Sae";
                break;
        }
        return type;
    }
}
