#import <Preferences/Preferences.h>
#import <SettingsKit/SKListControllerProtocol.h>
#import <SettingsKit/SKTintedListController.h>
#import <SettingsKit/SKPersonCell.h>
#import <SettingsKit/SKSharedHelper.h>

@interface AppsterSettingsListController: SKTintedListController <SKListControllerProtocol>
@end

@interface DeveloperCell : SKPersonCell
@end

@interface DesignerCell : SKPersonCell
@end

@interface DevelopersListCell : SKTintedListController <SKListControllerProtocol>
@end
