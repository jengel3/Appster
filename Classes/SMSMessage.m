#import "SMSMessage.h"

@implementation SMSMessage
  -(id)initWithResult:(id)res {
    NSString *msg = [NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(res, 0)];
    NSString *timestamp = [NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(res, 1)];
    NSString *me = [NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(res, 2)];

    self.date = timestamp;
    self.text = msg;
    self.isFromMe = [me boolValue];

    return self;
  }
@end