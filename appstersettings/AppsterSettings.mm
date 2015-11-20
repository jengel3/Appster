#import <Preferences/Preferences.h>
#import <SettingsKit/SKListControllerProtocol.h>
#import <SettingsKit/SKTintedListController.h>
#import <SettingsKit/SKPersonCell.h>
#import <SettingsKit/SKSharedHelper.h>

@interface AppsterSettingsListController: SKTintedListController <SKListControllerProtocol>
@end

@interface DeveloperCell : SKPersonCell
@end
@implementation DeveloperCell
-(NSString*)personDescription { return @"Lead Developer"; }
-(NSString*)name { return @"Jake0oo0"; }
-(NSString*)twitterHandle { return @"itsjake88"; }
-(NSString*)imageName { return @"Jake0oo0@2x.png"; }
@end

@interface DesignerCell : SKPersonCell
@end
@implementation DesignerCell
-(NSString*)personDescription { return @"Lead Designer"; }
-(NSString*)name { return @"AOkhtenberg"; }
-(NSString*)twitterHandle { return @"AOkhtenberg"; }
-(NSString*)imageName { return @"AOkhtenberg@2x.png"; }
@end


@interface DevelopersListCell : SKTintedListController <SKListControllerProtocol>
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

-(NSArray*)customSpecifiers {
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
-(UIColor*)tintColor { 
  return [UIColor colorWithRed:0.19 green:0.56 blue:0.84 alpha:1.0]; 
}
-(BOOL)tintNavigationTitleText { 
  return YES; 
}

-(NSString*)shareMessage {
    return @"I'm using Appster by @itsjake88 to export content from my iDevice. Check it out!";
}

-(NSString*)headerText { 
  return @"Appster"; 
}

-(NSString*)headerSubText {
  return @"View and Export Device Data";
}

-(NSString*)customTitle { 
  return @"Appster"; 
}
-(NSArray*) customSpecifiers {
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
@end
