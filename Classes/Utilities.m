#import "Utilities.h"

@implementation Utilities
+ (NSString *)emailForControl:(NSString *)ctrl {
  NSError *regErr = NULL;
  NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\<([^<>]+)\\>" 
    options:NSRegularExpressionCaseInsensitive 
    error:&regErr];

  NSRange range = [regex rangeOfFirstMatchInString:ctrl options:kNilOptions range:NSMakeRange(0, [ctrl length])];
  if (range.location != NSNotFound) {
    ctrl = [ctrl substringWithRange:range];
    return [[ctrl stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@"<" withString:@""];
  }
  return nil;
}

+ (NSString *)usernameForControl:(NSString *)ctrl andEmail:(NSString *)email {
  ctrl = [ctrl stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<%@>", email] withString:@""];
  return [ctrl stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (UIImage *)imageWithImage: (UIImage *) sourceImage scaledToWidth: (float) i_width {
  float oldWidth = sourceImage.size.width;
  float scaleFactor = i_width / oldWidth;

  float newHeight = sourceImage.size.height * scaleFactor;
  float newWidth = oldWidth * scaleFactor;

  UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
  [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
  UIGraphicsEndImageContext();
  return newImage;
}

+ (int)sortForKey:(NSString *)key {
  if ([key isEqualToString:@"alpha_asc"]) {
    return 1;
  } else if ([key isEqualToString:@"alpha_desc"]) {
    return 2;
  } else if ([key isEqualToString:@"developer_asc"]) {
    return 3;
  } else if ([key isEqualToString:@"identifier_asc"]) {
    return 4;
  }
  return 1;
}
@end