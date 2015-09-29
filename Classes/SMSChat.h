@interface SMSChat : NSObject
  @property (nonatomic, retain) NSString *guid;
  @property (nonatomic, retain) NSString *chatId;
  // -(id)initWithResult:(sqlite3_stmt *)statement;
@end