#import <MessageUI/MessageUI.h> 
#import <MessageUI/MFMailComposeViewController.h> 

@interface SettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>
  @property (nonatomic, retain) UITableView *settingsTable;
@end