#import "Applications/AppListViewController.h"
#import "Tweaks/TweakListViewController.h"
#import "AppleExportHubViewController.h"
#import "Tweaks/InstalledFilesViewController.h"
#import <UIKit/UIKit.h>
#import <notify.h>


@interface AppsterApplication: UIApplication <UIApplicationDelegate> {
	UIWindow *_window;
	UITabBarController *_tabBarController;
}
@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UITabBarController *tabBarController;
@end

@interface UIApplicationShortcutItem
	@property (nonatomic, strong) NSString *type;
@end

@implementation AppsterApplication
@synthesize window;
@synthesize tabBarController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.tabBarController = [[UITabBarController alloc] init];


	AppListViewController *appList = [[AppListViewController alloc] init];
	UINavigationController *appListNav = [[UINavigationController alloc] initWithRootViewController:appList];
	appListNav.tabBarItem.image = [UIImage imageNamed:@"iTunes.png"];

	TweakListViewController *tweakList = [[TweakListViewController alloc] init];
	UINavigationController *tweakListNav = [[UINavigationController alloc] initWithRootViewController:tweakList];
	tweakListNav.tabBarItem.image = [UIImage imageNamed:@"Cydia.png"];

	AppleExportHubViewController *exportHub = [[AppleExportHubViewController alloc] init];
	UINavigationController *exportNav = [[UINavigationController alloc] initWithRootViewController:exportHub];
	exportNav.tabBarItem.image = [UIImage imageNamed:@"Apple@3x.png"];

	NSArray *controllers = [NSArray arrayWithObjects:appListNav, tweakListNav, exportNav, nil];
	self.tabBarController.viewControllers = controllers;

	self.window.backgroundColor = [UIColor whiteColor];
	self.window.rootViewController = self.tabBarController;

	[self.window makeKeyAndVisible];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [self applicationDidFinishLaunching:application];

  return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	if ([[url host] isEqualToString:@"tweaks"]) {
		[self.tabBarController setSelectedIndex:1];
	} else if ([[url host] isEqualToString:@"apps"]) {
		[self.tabBarController setSelectedIndex:0];
	}

	return YES;
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
  if ([shortcutItem.type isEqualToString:@"com.jake0oo0.appster.open-tweaks"]) {
    [self.tabBarController setSelectedIndex:1];
  } else if ([shortcutItem.type isEqualToString:@"com.jake0oo0.appster.open-apps"]) {
  	[self.tabBarController setSelectedIndex:2];
  } else if ([shortcutItem.type isEqualToString:@"com.jake0oo0.appster.open-content"]) {
  	[self.tabBarController setSelectedIndex:3];
  }
}
@end
