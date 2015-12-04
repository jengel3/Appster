#import "Settings.h"
#import "ListExportDelegate.h"
#import <MessageUI/MessageUI.h> 

@interface ListExportController : UIViewController <MFMailComposeViewControllerDelegate>
@property (nonatomic, retain) id<ListExportDelegate> delegate;
-(void)exportContent:(int)mode;
-(void)showExport:(id)sender;
@end