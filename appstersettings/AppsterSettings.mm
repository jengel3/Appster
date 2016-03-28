#import <Preferences/Preferences.h>
#import <SettingsKit/SKListControllerProtocol.h>
#import <SettingsKit/SKTintedListController.h>
#import <SettingsKit/SKPersonCell.h>
#import <SettingsKit/SKSharedHelper.h>
#import "AppsterSettings.h"

#define valuesPath @"/User/Library/Preferences/com.jake0oo0.appster.plist"

@interface DeveloperCell : SKPersonCell
@end

@interface DesignerCell : SKPersonCell
@end

@interface DevelopersListCell : SKTintedListController <SKListControllerProtocol>
@end


@implementation DeveloperCell
-(NSString *)personDescription { return @"Lead Developer"; }
-(NSString *)name { return @"Jake0oo0"; }
-(NSString *)twitterHandle { return @"itsjake88"; }
-(NSString *)imageName { return @"Jake@2x.png"; }
@end

@implementation DesignerCell
-(NSString *)personDescription { return @"Lead Designer"; }
-(NSString *)name { return @"AOkhtenberg"; }
-(NSString *)twitterHandle { return @"AOkhtenberg"; }
-(NSString *)imageName { return @"AOkhtenberg@2x.png"; }
@end

@implementation DevelopersListCell
-(BOOL)showHeartImage {
  return NO;
}

-(void)openJakeTwitter {
  [SKSharedHelper openTwitter:@"itsjake88"];
}

-(void)openAOkTwitter {
  [SKSharedHelper openTwitter:@"AOkhtenberg"];
}

-(NSArray *)customSpecifiers {
  return @[
    @{
      @"cell": @"PSLinkCell",
      @"cellClass": @"DeveloperCell",
      @"height": @100,
      @"action": @"openJakeTwitter"
    },
    @{
      @"cell": @"PSLinkCell",
      @"cellClass": @"DesignerCell",
      @"height": @100,
      @"action": @"openAOkTwitter"
    }
  ];
}
@end

@implementation AppsterSettingsListController
-(UIColor *)tintColor { 
  return [UIColor colorWithRed:0.19 green:0.56 blue:0.84 alpha:1.0]; // instagram color
}
-(BOOL)tintNavigationTitleText { 
  return YES; 
}

-(NSString *)shareMessage {
    return @"I'm using #Appster by @itsjake88 to export content from my iDevice. Check it out!";
}

-(NSString *)headerText { 
  return @"Appster"; 
}

-(NSString *)headerSubText {
  return @"View and Export Device Data";
}

-(NSString *)customTitle { 
  return @"Appster"; 
}
-(NSArray *)customSpecifiers {
  return @[
    @{
      @"cell": @"PSGroupCell",
      @"label": @"Appster Settings"
    },
    @{
      @"cell": @"PSEditTextCell",
      @"default": @"",
      @"defaults": @"com.jake0oo0.appstersettings",
      @"key": @"default_email",
      @"label": @"Default Email",
      @"PostNotification": @"com.jake0oo0.appster/settingsChanged"
    },
    @{
      @"cell": @"PSLinkListCell",
      @"default": @1,
      @"defaults": @"com.jake0oo0.appstersettings",
      @"key": @"file_explorer",
      @"label": @"File Exploring App",
      @"PostNotification": @"com.jake0oo0.appster/settingsChanged",
      @"validTitles": @[
        @"iFile",
        @"Filza"
      ],
      @"validValues": @[
        @1,
        @2
      ],
      @"detail": @"PSListItemsController"
    },
    @{
      @"cell": @"PSGroupCell",
      @"label": @"Applications"
    },
    @{
      @"cell": @"PSSwitchCell",
      @"default": @NO,
      @"defaults": @"com.jake0oo0.appstersettings",
      @"key": @"export_system",
      @"label": @"Export System Apps",
      @"PostNotification": @"com.jake0oo0.appster/settingsChanged",
      @"cellClass": @"SKTintedSwitchCell"
    },
    @{
      @"cell": @"PSLinkListCell",
      @"default": @"alpha_asc",
      @"defaults": @"com.jake0oo0.appstersettings",
      @"key": @"apps_default_sort",
      @"label": @"Default Sort",
      @"PostNotification": @"com.jake0oo0.appster/settingsChanged",
      @"validTitles": @[
        @"Alpha (A-Z)",
        @"Alpha (Z-A)",
        @"Developer (A-Z)",
        @"Identifier (A-Z)"
      ],
      @"validValues": @[
        @"alpha_asc",
        @"alpha_desc",
        @"developer_asc",
        @"identifier_asc"
      ],
      @"detail": @"PSListItemsController"
    },
    @{
      @"cell": @"PSGroupCell",
      @"label": @"Cydia Tweaks"
    },
    @{
      @"cell": @"PSLinkListCell",
      @"default": @"alpha_asc",
      @"defaults": @"com.jake0oo0.appstersettings",
      @"key": @"tweaks_default_sort",
      @"label": @"Default Sort",
      @"PostNotification": @"com.jake0oo0.appster/settingsChanged",
      @"validTitles": @[
        @"Alpha (A-Z)",
        @"Alpha (Z-A)",
        @"Developer (A-Z)",
        @"Package (A-Z)"
      ],
      @"validValues": @[
        @"alpha_asc",
        @"alpha_desc",
        @"developer_asc",
        @"identifier_asc"
      ],
      @"detail": @"PSListItemsController"
    },
    @{
      @"cell": @"PSGroupCell",
      @"label": @"Developers"
    },
    @{
      @"cell": @"PSLinkCell",
      @"cellClass": @"SKTintedCell",
      @"detail": @"DevelopersListCell",
      @"label": @"Developers"
    },
  ];
}

// http://iphonedevwiki.net/index.php/PreferenceBundles
-(id) readPreferenceValue:(PSSpecifier *)specifier {
  NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:valuesPath];
  if (!settings[specifier.properties[@"key"]]) {
    return specifier.properties[@"default"];
  }
  return settings[specifier.properties[@"key"]];
}
 
-(void) setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
  NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
  [defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:valuesPath]];
  [defaults setObject:value forKey:specifier.properties[@"key"]];
  [defaults writeToFile:valuesPath atomically:NO];
  CFStringRef toPost = (__bridge CFStringRef)specifier.properties[@"PostNotification"];
  if (toPost) CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), toPost, NULL, NULL, YES);
}
// end
@end
