#import <AppList/AppList.h>
#import <MessageUI/MessageUI.h> 
#import <MessageUI/MFMailComposeViewController.h> 

@interface AppListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>
	@property (nonatomic, retain) ALApplicationList *applications;
	@property (nonatomic, retain) NSMutableArray *appList;
	@property (nonatomic, retain) UITableView *appTable;
	@property (nonatomic, retain) NSArray* hiddenDisplayIdentifiers;
@end