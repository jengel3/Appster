@interface AppsterSettings : NSObject
@property (nonatomic, retain) NSMutableDictionary *preferences;
-(id)init;
-(NSMutableDictionary*)loadData;
-(BOOL)reload;
-(void)setValue:(id)val forKey:(id)key;
-(id)valueForKey:(NSString*)key;
-(id)valueForKey:(NSString*)key orDefault:(id)def;
@end