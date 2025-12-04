pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications

Singleton {
    id: root

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
        property double time
        property Timer timer

        onNotificationChanged: {
            if (notification === null)
                NotificationHandler.discardNotification(notificationId);
        }
    }

    property list<NotificationWrapper> list: []
    property var latestTimeForApp: ({})
    property var groupsByAppName: root.getGroupsByAppName(list)
    property var appNameList: root.getAppNameList(groupsByAppName)

    property int idOffset
    signal initDone
    signal notify(notification: var)
    signal discard(id: int)
    signal discardAll
    signal timeout(id: int)

    onListChanged: {
        // Update latest time per app
        root.list.forEach(notif => {
            const prevTime = root.latestTimeForApp[notif.appName];
            if (!prevTime || notif.time > prevTime) {
                root.latestTimeForApp[notif.appName] = Math.max(prevTime || 0, notif.time);
            }
        });

        // Remove apps without any notifications
        Object.keys(root.latestTimeForApp).forEach(appName => {
            if (!root.list.some(notif => notif.appName === appName)) {
                delete root.latestTimeForApp[appName];
            }
        });
    }

    function getGroupsByAppName(list) {
        const groups = {};
        list.forEach(notif => {
            if (!groups[notif.appName]) {
                groups[notif.appName] = {
                    appName: notif.appName,
                    appIcon: notif.appIcon,
                    notifications: [],
                    time: 0
                };
            }
            groups[notif.appName].notifications.push(notif);
            groups[notif.appName].time = latestTimeForApp[notif.appName] || notif.time;
        });
        return groups;
    }

    function getAppNameList(groups) {
        return Object.keys(groups).sort((a, b) => {
            return groups[b].time - groups[a].time;
        });
    }

    function stringifyList(list) {
        return JSON.stringify(list.map(notif => notifToJSON(notif)), null, 2);
    }

    function notifToString(notif) {
        return JSON.stringify(notifToJSON(notif), null, 2);
    }

    function notifToJSON(notif) {
        return {
            "notificationId": notif.notificationId,
            "actions": notif.actions,
            "appIcon": notif.appIcon,
            "appName": notif.appName,
            "body": notif.body,
            "image": notif.image,
            "summary": notif.summary,
            "time": notif.time,
            "urgency": notif.urgency
        };
    }

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
                "time": Date.now()
            });

            root.list = [...root.list, newNotifObject];
            root.notify(newNotifObject);
            console.log("Recieved notification! Total: " + root.list.length);

            notifFileView.setText(root.stringifyList(root.list));
        }
    }

    function discardNotification(id) {
        console.log("Discarding notification #" + id);
        const index = root.list.findIndex(notif => notif.notificationId === id);
        const notifServerIndex = notifServer.trackedNotifications.values.findIndex(notif => notif.id + root.idOffset === id);
        if (index !== -1) {
            root.list.splice(index, 1);
            notifFileView.setText(stringifyList(root.list));
            triggerListChange();
        }
        if (notifServerIndex !== -1) {
            notifServer.trackedNotifications.values[notifServerIndex].dismiss();
        }
        root.discard(id);
    }

    function discardAllNotifications() {
        root.list = [];
        triggerListChange();
        notifFileView.setText(stringifyList(root.list));
        notifServer.trackedNotifications.values.forEach(notif => {
            notif.dismiss();
        });
        root.discardAll();
    }

    // function timeoutNotification(id) {}

    // function timeoutAllNotifications() {}

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
        root.discardNotification(id);
    }

    function triggerListChange() {
        root.list = root.list.slice(0);
    }

    function refresh() {
        notifFileView.reload();
    }

    Component.onCompleted: {
        refresh();
    }

    FileView {
        id: notifFileView
        path: ".config/quickshell/data/notificationLog.json"

        onLoaded: {
            const fileContents = notifFileView.text();
            root.list = JSON.parse(fileContents).map(notif => {
                return root.notifComp.createObject(root, {
                    "notificationId": notif.notificationId,
                    "actions": [],
                    "appIcon": notif.appIcon,
                    "appName": notif.appName,
                    "body": notif.body,
                    "image": notif.image,
                    "summary": notif.summary,
                    "time": notif.time,
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
