#import "ListExportController.h"
#import "Settings.h"
#import <MessageUI/MessageUI.h> 
#import <MessageUI/MFMailComposeViewController.h> 

@implementation ListExportController
- (void)showExport:(id)sender {
  [self exportContent:0];
}

- (void)exportContent:(int)mode {
  if (self.delegate && [self.delegate respondsToSelector:@selector(getBody:)]) {
    if ([MFMailComposeViewController canSendMail]) {
      MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
      mailCont.mailComposeDelegate = self;
      mailCont.modalPresentationStyle = UIModalPresentationFullScreen;

      NSString *subject = nil;

      if ([self.delegate respondsToSelector:@selector(getSubject)]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSDate *now = [NSDate date];

        NSDateFormatterStyle style = NSDateFormatterShortStyle;
        [formatter setTimeStyle:style];
        [formatter setDateStyle:style];

        NSString *timestamp = [formatter stringFromDate:now];

        subject = [NSString stringWithFormat:[self.delegate getSubject], timestamp];
      }

      [mailCont setSubject:subject];

      AppsterSettings *settings = [[AppsterSettings alloc] init];
      NSString *defaultEmail = [settings valueForKey:@"default_email"];
      if (defaultEmail) {
        [mailCont setToRecipients:@[defaultEmail]];
      } else {
        [mailCont setToRecipients:nil];
      }

      NSString *body = [self.delegate getBody:mode];

      [mailCont setMessageBody:body isHTML:YES];

      [self presentViewController:mailCont animated:YES completion:nil];
    }
  }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
  [self dismissViewControllerAnimated:YES completion:nil];
}
@end