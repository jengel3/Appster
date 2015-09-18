#import "AppListViewController.h"
#import "TweakListViewController.h"

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


	NSArray *controllers = [NSArray arrayWithObjects:appListNav, tweakListNav, nil];
	self.tabBarController.viewControllers = controllers;

	self.window.backgroundColor = [UIColor whiteColor];
	self.window.rootViewController = tabBarController;

	[self.window makeKeyAndVisible];
}


@end

// vim:ft=objc
