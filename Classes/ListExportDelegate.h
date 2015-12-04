@protocol ListExportDelegate <NSObject>
@optional
-(NSString*)getSubject;
@required
-(NSMutableString*)getBody:(int)mode;
@end