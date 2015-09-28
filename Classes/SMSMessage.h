@interface SMSMessage : NSObject
  @property (nonatomic, retain) BOOL isFromMe;
  @property (nonatomic, retain) NSString *text;
  @property (nonatomic, retain) NSString *date;
  -(id)initWithResult:(id)res;
@end