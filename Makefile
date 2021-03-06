ARCHS = armv7 arm64
TARGET = iphone:clang:latest:8.0
TARGET_IPHONEOS_DEPLOYMENT_VERSION = 8.0
THEOS_PACKAGE_DIR_NAME = debs
ADDITIONAL_OBJCFLAGS = -fobjc-arc

include theos/makefiles/common.mk

APPLICATION_NAME = Appster
Appster_FILES = main.m appstersettings/AppsterSettings.mm $(shell find $(THEOS)/include/SettingsKit -name '*.m') $(wildcard Classes/**/*.m) $(wildcard Classes/*.m) $(wildcard Classes/*.mm)
Appster_FRAMEWORKS = UIKit CoreGraphics MessageUI SafariServices Social QuartzCore
Appster_PRIVATE_FRAMEWORKS = ChatKit Preferences
Appster_LDFLAGS = -lsqlite3 -all_load -ObjC
Appster_LIBRARIES = applist
Appster_LDFLAGS += -Wl,-segalign,4000


include $(THEOS_MAKE_PATH)/application.mk

after-install::
	install.exec "killall -9 Appster"
SUBPROJECTS += appstersettings
SUBPROJECTS += appsterupdatehider
include $(THEOS_MAKE_PATH)/aggregate.mk
