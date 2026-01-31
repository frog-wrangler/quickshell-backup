pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications

Singleton {
    id: root

    // ******************************
    // Stored Values
    // ******************************
    component NotificationWrapper: QtObject {
        id: wrapper
        required property string notificationId

        property Notification notification
        property list<var> actions: notification?.actions.map(action => ({
                    "identifier": action.identifier,
                    "text": action.text
                })) ?? []
        property string appIcon: notification?.appIcon ?? ""
        property string appName: notification?.appName ?? ""
        property string body: notification?.body ?? ""
        property string image: notification?.image ?? ""
        property string summary: notification?.summary ?? ""
        property string urgency: notification?.urgency.toString() ?? "normal"

        property Timer timer // TODO
    }

    property list<NotificationWrapper> list: []
    property list<NotificationWrapper> recent: []

    property var groupsByAppName: ({})
    property var appNameList: []

    property int idOffset

    signal initDone
    signal groupsUpdated // TODO remove if unused


    // ******************************
    // Update Functions
    // ******************************

    Component.onCompleted: {
        notifFileView.reload();
    }
    
    onListChanged: {
        updateGroups();
    }

    function updateGroups() {
        list.forEach(notif => {
            const name = notif.appName;
            if (!root.groupsByAppName[name]) {
                root.groupsByAppName[name] = {
                    appName: name,
                    appIcon: notif.appIcon,
                    notifications: [],
                };
            }

            const group = root.groupsByAppName[name];
            if (!group.notifications.includes[notif]) {
                group.notifications.push(notif);
            }
        });

        for (const [appName, notifDetails] of Object.entries(root.groupsByAppName)) {
            if (!root.appNameList.includes(appName)) {
                root.appNameList.push(appName);
            }
        }

        root.appNameList = root.appNameList.filter(appName => {
            if (root.groupsByAppName[appName].notifications.length == 0) {
                delete root.groupsByAppName[appName]
                root.appNameList.splice(root.appNameList.indexOf(appName), 1);
                return false;
            }
            return true;
        });

        root.groupsUpdated();
    }


    // ******************************
    // Action Functions
    // ******************************
    function discardNotification(id) {
        console.log("Discarding notification #" + id);
        const index = root.list.findIndex(notif => notif.notificationId === id);
        console.log("offset = " + root.idOffset);
        const notifServerIndex = notifServer.trackedNotifications.values.findIndex(notif => notif.id + root.idOffset === id);
        console.log("index = " + index + ", serverIndex = " + notifServerIndex);
        if (index >= 0) {
            console.log("Discarding the list notif...");
            console.log("#1: " + JSON.stringify(root.list, null, "\t"));
            root.list.splice(index, 1);
            notifFileView.setText(stringifyList(root.list));
            console.log("#2: " + JSON.stringify(root.list, null, "\t"));
        }
        console.log("Tracked notifications: " + JSON.stringify(notifServer.trackedNotifications, null, "\t"));
        if (notifServerIndex >= 0) {
            console.log("Discarding the server notif...");
            notifServer.trackedNotifications.values[notifServerIndex].dismiss();
        }
        root.updateGroups();
    }

    function discardAllNotifications() {
        root.list = [];
        notifFileView.setText(stringifyList(root.list));
        notifServer.trackedNotifications.values.forEach(notif => {
            notif.dismiss();
        });
    }

    // function timeoutNotification(id) {} // TODO

    // function timeoutAllNotifications() {} // TODO

    function attemptInvokeAction(id, notifIdentifier) {
        console.log("Attempting to invoke action w/ identifier: " + notifIdentifier + " and id #" + id);
        const notifServerIndex = notifServer.trackedNotifications.values.findIndex(notif => notif.id + root.idOffset === id);
        console.log("Notification server id: " + notifServerIndex);
        if (notifServerIndex !== -1) {
            const serverNotif = notifServer.trackedNotifications.values[notifServerIndex];
            const action = serverNotif.actions.find(action => action.identifier === notifIdentifier);
            console.log("Found action: " + JSON.stringify(action));
            action.invoke();
        } else {
            console.log("Notification not found in server");
        }
    }


    // ******************************
    // Conversion Functions
    // ******************************
    function stringifyList(list) {
        return JSON.stringify(list.map(notif => {
            return {
                "notificationId": notif.notificationId,
                "actions": notif.actions,
                "appIcon": notif.appIcon,
                "appName": notif.appName,
                "body": notif.body,
                "image": notif.image,
                "summary": notif.summary,
                "urgency": notif.urgency
            };
        }), null, 2);
    }


    // ******************************
    // Notification Server Integration
    // ******************************
    property Component notifComp: NotificationWrapper {}

    NotificationServer {
        id: notifServer

        actionsSupported: true
        bodyHyperlinksSupported: true
        bodyImagesSupported: true
        bodyMarkupSupported: true
        bodySupported: true
        imageSupported: true
        keepOnReload: false
        persistenceSupported: true

        onNotification: notification => {
            notification.tracked = true;
            const newNotifObject = root.notifComp.createObject(root, {
                "notificationId": notification.id + root.idOffset,
                "notification": notification,
            });

            // root.list = [...root.list, newNotifObject];
            root.list.push(newNotifObject);
            console.log("Recieved notification! Total: " + root.list.length);

            notifFileView.setText(root.stringifyList(root.list));
        }
    }

    FileView {
        id: notifFileView
        path: ".config/quickshell/data/notificationLog.json"

        onLoaded: {
            const fileContents = notifFileView.text();
            root.list = JSON.parse(fileContents).map(notif => {
                return root.notifComp.createObject(root, {
                    "notificationId": notif.notificationId,
                    "actions": [], // TODO
                    "appIcon": notif.appIcon,
                    "appName": notif.appName,
                    "body": notif.body,
                    "image": notif.image,
                    "summary": notif.summary,
                    "urgency": notif.urgency
                });
            });

            let maxId = 0;
            root.list.forEach(notif => {
                maxId = Math.max(maxId, notif.notificationId);
            });

            root.idOffset = maxId;
            root.initDone();
        }

        onLoadFailed: error => {
            if (error == FileViewError.FileNotFound) {
                console.log("Notifications file not found, creating new file.");
                root.list = [];
                notifFileView.setText(root.stringifyList(root.list));
            } else {
                console.log("Error loading notifications file: " + error);
            }
        }
    }
}
