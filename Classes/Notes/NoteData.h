@interface NoteData : NSObject
  @property (nonatomic) NSInteger pk;
  @property (nonatomic, retain) NSString *title;
  @property (nonatomic, retain) NSAttributedString *body;
  @property (nonatomic, retain) NSString *author;
  @property (nonatomic, retain) NSDate *createdAt;
  @property (nonatomic, retain) NSDate *updatedAt;
@end