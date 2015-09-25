#import "AppListViewController.h"
#import "TweakListViewController.h"
#import "AppleExportHubViewController.h"
#import "InstalledFilesViewController.h"

@interface AppsterApplication: UIApplication <UIApplicationDelegate> {
	UIWindow *_window;
	UITabBarController *_tabBarController;
}
@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UITabBarController *tabBarController;
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

@end
