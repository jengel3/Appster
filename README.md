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
- Search for specific tweaks or apps with the search bar
- Open Apps in iFile or Filza to view content, or preview them in iTunes
- Sort apps and tweaks based on name, identifier, or developer.
- Set a default sort order and default email for exporting
- Hide App Store updates with the press of a button
- Configure Appster just like any other tweak in the settings app
- Calculate total size of installed tweaks


## Release 0.0.8
- Fix installed files list
- Changes to simple/detailed export lists for both applications and tweaks
- Display iTunes metadata in iTunes applications - purchase date, release date, purchaser, genre, etc
- Export and view Cydia sources
- Open application folders in iFile
- Open iTunes applications in the app store
- Export messages - export the entire database to transfer to another phone, or export a single conversation or chat with all messages and timestamps
- Export notes - export the entire database to transfer to another device, or just export a list of notes. Displays the title, body, authoring account, and a creation timestamp
- Made changes to the author/maintainer contact buttons for Cydia tweaks, less useless information
- WIP settings menu - will include information like a default email and other options

## Release 1.0.0
- Make installed files list uneditable
- Add default sort order for tweaks/apps
- Finish developers section in settings
- Choose to not export system applications
- Remove tweaks that haev been uninstalled
- Add application/tweak icon and description to detail view
- Add 3D Shortcut Icons
- Add appster:// URL scheme
- View depictions in Appster, or open in Cydia
- Hide AppStore Updates
- Sort applications/tweaks with a menu
- Option to use Filza instead of iFile
- New Splash screens & icon set
- Export information about a single application
- Hide search bars until pulled down
- Make export emails look nicer
- Add default recipient email to settings
- Calculate total size of installed tweaks