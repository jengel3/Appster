@interface TweakInfo : NSObject
  @property (nonatomic, retain) NSString *package;
  @property (nonatomic, retain) NSString *name;

  @property (nonatomic, retain) NSString *author;
  @property (nonatomic, retain) NSString *authorEmail;
  @property (nonatomic, retain) NSString *maintainer;
  @property (nonatomic, retain) NSString *maintainerEmail;
  @property (nonatomic, retain) NSString *version;
  @property (nonatomic, retain) NSString *description;
  @property (nonatomic, retain) NSString *architecture;
  @property (nonatomic, retain) NSString *installSize;
  @property (nonatomic, retain) NSString *section;
  @property (nonatomic, retain) NSString *depiction;
  @property (nonatomic, retain) NSDictionary *rawData;

  -(id)initWithIdentifier:(NSString*)ident andInfo:(NSDictionary*)tweakMap;
  +(id)tweakForProperty:(NSString*)prop withValue:(NSString*)val andData:(NSMutableArray*)data;
@end