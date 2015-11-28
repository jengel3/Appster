# Appster

Appster is a work-in-progress replacement for the now-defunct Cydia application, AppInfo. Appster aims to reproduce many of the features in AppInfo, and already supports basic features such as exporting application and tweak lists.

## Features
* Export installed applications
* Export installed Cydia tweaks & extensions
* Export and view a list of SMS and iMessages via email
* Export and view notes saved on your device

## Building
* Appster is built using [theos](https://github.com/DHowett/theos). Follow the [setup](http://iphonedevwiki.net/index.php/Theos/Setup) guide to install it.
* Install [SettingsKit](https://github.com/mlnlover11/SettingsKit).
* Run ```make clean package install THEOS_DEVICE_IP=xxx THEOS_DEVICE_PORT=xxx``` to build and install Appster on your device

## Dependencies
* [PureLayout](https://github.com/PureLayout/PureLayout) for easy UI design without the XCode interface builder
* [MBProgressHud](https://github.com/jdg/MBProgressHUD) for showing quick alerts and popups
* [AppList](https://github.com/rpetrich/AppList) for retrieving a list of installed applications
* [SettingsKit](https://github.com/mlnlover11/SettingsKit) for making the settings panel look nice

## License

All rights reserved to Jake0oo0. Appster may not be redistributed by any user or apt repository without permission from the active authors and maintainers. 

# Depiction

Appster allows you to view and export content from your iDevice.

- Export messages and notes as a text list or the database file
- Export installed Cydia tweaks and extensions via Email
- Open tweaks in Cydia, view installed files, preview depictions
- Export App Store and Apple tweaks via email
- Open Apps in iFile or Filza to view content, or preview them in iTunes
- Sort apps and tweaks based on name, identifier, or developer.
- Set a default sort order and default email for exporting
- Hide App Store updates with the press of a button
