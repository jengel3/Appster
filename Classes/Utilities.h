@interface Utilities : NSObject 
+ (NSString *)emailForControl:(NSString *)ctrl;
+ (NSString *)usernameForControl:(NSString *)ctrl andEmail:(NSString *)email;
+ (UIImage *)imageWithImage:(UIImage *) sourceImage scaledToWidth:(float) i_width;
+ (int)sortForKey:(NSString *)key;
@end