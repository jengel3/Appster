#import "SMSMessage.h"
#import <sqlite3.h>

@implementation SMSMessage
  -(id)initWithResult:(id)res {
    sqlite3_stmt *statement = (__bridge sqlite3_stmt*) res;
    NSString *msg = [NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statement, 0)];
    NSString *timestamp = [NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statement, 1)];
    NSString *me = [NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statement, 2)];

    self.date = timestamp;
    self.text = msg;
    self.isFromMe = [me boolValue];

    return self;
  }
@end