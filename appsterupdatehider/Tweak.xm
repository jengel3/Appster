#import <UIKit/UIKit.h>
#import "AppStoreHeaders.h"
#import <notify.h>

#define valuesPath @"/User/Library/Preferences/com.jake0oo0.appster.plist"
NSArray *hiddenUpdates;

%group appStoreHooks
%hook ASUpdatesViewController
-(void)_setUpdatesPageWithUpdates:(id)updates fromCache:(char)cached {
  NSMutableArray *original = [updates mutableCopy];
  NSArray *copy = [updates copy];
  int count = 0;
  for (SSSoftwareUpdate *update in copy) {
    if (update.updateState == 0) {
      count++;
      if ([hiddenUpdates containsObject:update.bundleIdentifier]) {
        count--;
        [original removeObject:update];
      }
    }
  }
  [[UIApplication sharedApplication] setApplicationIconBadgeNumber:count];
  updates = [original copy];
  cached = NO;
  %orig;
}
%end
%end

static void loadPrefs() {
  NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:valuesPath];
  hiddenUpdates = nil;
  hiddenUpdates = [settings objectForKey:@"hidden_updates"];
  NSLog(@"CONTENT %@", [settings objectForKey:@"default_email"]);
  if (!hiddenUpdates) {
    hiddenUpdates = [[NSArray alloc] init];
  }
}

static void handlePrefsChange(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
  loadPrefs();
}

%ctor {
  CFNotificationCenterAddObserver(
    CFNotificationCenterGetDarwinNotifyCenter(), 
    NULL,
    &handlePrefsChange,
    (CFStringRef)@"com.jake0oo0.appster/settingsChanged",
    NULL, 
    CFNotificationSuspensionBehaviorCoalesce);

  loadPrefs();

  // hiddenUpdates = [NSArray arrayWithObjects:@"com.toyopagroup.picaboo", nil];
  // hiddenUpdates = [[NSArray alloc] init];
  %init(appStoreHooks);
}