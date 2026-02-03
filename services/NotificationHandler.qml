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
        required property int notificationId

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

        // TODO add time here + timestamp in notifTab
        // property Timer timer // TODO
    }

    property list<NotificationWrapper> list: []
    property list<NotificationWrapper> recent: []

    property var groupsByAppName: ListModel {}

    property int idOffset

    signal initDone
    signal groupsUpdated

    // ******************************
    // Update Functions
    // ******************************
    
    function initialize() {}

    Component.onCompleted: {
        notifFileView.reload();
    }

    onListChanged: {
        updateGroups();
    }

    function updateGroups() {
        const groups = root.groupsByAppName;

        list.forEach(notif => {
            const name = notif.appName;
            let groupIndex = getGroupIndex(name);

            if (groupIndex == -1) {
                groups.append({
                    appName: name,
                    appIcon: notif.appIcon,
                    notifications: [],
                });
                groupIndex = groups.count - 1;
            }

            const group = groups.get(groupIndex);
            const index = getNotifIndex(group, notif);
            if (index == -1) {
                group.notifications.append(notif);
            }
        });

        for (let i = 0; i < groups.count; i++) {
            const name = groups.get(i).appName;
            if (groups.get(i).notifications.count == 0) {
                groups.remove(i, 1);
                i--;
            }
        }
    }

    function getGroupIndex(appName) {
        const groups = root.groupsByAppName;
        for (let i = 0; i < groups.count; i++) {
            if (groups.get(i).appName == appName) {
                return i;
            }
        }
        return -1;
    }

    function getNotifIndex(group, notif) {
        const notifs = group.notifications;
        for (let i = 0; i < notifs.count; i++) {
            if (notifs.get(i).notificationId == notif.notificationId) {
                return i;
            }
        }
        return -1;
    }


    // ******************************
    // Action Functions
    // ******************************
    function discardNotification(id) {
        console.log("Discarding notification #" + id);
        const index = root.list.findIndex(notif => notif.notificationId === id);
        const notifServerIndex = notifServer.trackedNotifications.values.findIndex(notif => {
            const value = ((notif.id + root.idOffset) == id);
            return value;
        });

        const group = root.groupsByAppName.get(getGroupIndex(root.list[index].appName));
        const notificationModel = group.notifications;
        for (let i = 0; i < notificationModel.count; i++) {
            if (notificationModel.get(i).notificationId == id) {
                notificationModel.remove(i, 1);
                break;
            }
        }

        if (index >= 0) {
            root.list.splice(index, 1);
            notifFileView.setText(stringifyList(root.list));
        } else {
            root.updateGroups();
        }
        if (notifServerIndex >= 0) {
            notifServer.trackedNotifications.values[notifServerIndex].dismiss();
        }
    }

    function discardAllNotifications() {
        root.groupsByAppName.clear();
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
                    "notification": null,
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
