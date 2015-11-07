@interface SMSMessage : NSObject
  @property (nonatomic) BOOL isFromMe;
  @property (nonatomic, retain) NSString *text;
  @property (nonatomic, retain) NSDate *date;
  -(id)initWithResult:(id)res;
@end