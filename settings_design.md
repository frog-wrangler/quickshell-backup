
Settings Design
===

API
---

+ The settings application will update over <u>ipc handlers</u>
+ The quickshell shell will pull from the Settings service exclusively and do nothing else

+ Must have an object or multiple objects that bind with QML to automatically update
+ Must be constant time retrieval
+ An update to one should not update all

Internal
---

+ Use a map?
+ Have a 'bus' ipc handler to handle all traffic from settings application
    * i.e. Single input, single output

