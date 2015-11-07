# Appster

Appster is a work-in-progress replacement for the now-defunct Cydia application, AppInfo. Appster aims to reproduce many of the features in AppInfo, and already supports basic features such as exporting application and tweak lists.

## Features
* Export installed applications
* Export installed Cydia tweaks & extensions
* Export and view a list of SMS and iMessages via email

## Building
* Appster is built using [theos](https://github.com/DHowett/theos)
* Adjust the theos symlink to your installation path
* Run ```make clean package install THEOS_DEVICE_IP=xxx THEOS_DEVICE_PORT=xxx``` to build and install Appster on your device

## Dependencies
* [PureLayout](https://github.com/PureLayout/PureLayout) for easy UI design without the XCode interface builder
* [MBProgressHud](https://github.com/jdg/MBProgressHUD) for showing quick alerts and popups
* [AppList](https://github.com/rpetrich/AppList) for retrieving a list of installed applications

## Copyright

All rights reserved to Jake0oo0. Appster may not be redistributed by any user or apt repository without permission from the active authors and maintainers. 