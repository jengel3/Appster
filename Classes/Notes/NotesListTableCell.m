#import "NotesListTableCell.h"
#import "../PureLayout/PureLayout.h"

#define kLabelHorizontalInsets 15.0f
#define kLabelVerticalInsets 10.0f

@implementation NotesListTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
      
    self.titleLabel = [UILabel newAutoLayoutView];
    [self.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [self.titleLabel setNumberOfLines:1];
    [self.titleLabel setTextAlignment:NSTextAlignmentLeft];

    self.bodyLabel = [UILabel newAutoLayoutView];
    [self.bodyLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.bodyLabel setNumberOfLines:0];
    [self.bodyLabel setTextAlignment:NSTextAlignmentLeft];

    self.authorLabel = [UILabel newAutoLayoutView];
    [self.authorLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [self.authorLabel setNumberOfLines:1];
    [self.authorLabel setTextAlignment:NSTextAlignmentLeft];

    [self.contentView addSubview:self.bodyLabel];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.authorLabel];
      
  }
  
  return self;
}

- (void)updateConstraints {
  if (!self.didSetupConstraints) {
      
    [NSLayoutConstraint autoSetPriority:UILayoutPriorityRequired forConstraints:^{
        [self.titleLabel autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
    }];

    [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kLabelVerticalInsets];
    [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kLabelHorizontalInsets];
    [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kLabelHorizontalInsets];

    //

    [self.bodyLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.titleLabel withOffset:kLabelVerticalInsets];

    [NSLayoutConstraint autoSetPriority:UILayoutPriorityRequired forConstraints:^{
      [self.bodyLabel autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
    }];
    [self.bodyLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kLabelHorizontalInsets];
    [self.bodyLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kLabelHorizontalInsets];

    //

    [self.authorLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.bodyLabel withOffset:kLabelVerticalInsets];

    [NSLayoutConstraint autoSetPriority:UILayoutPriorityRequired forConstraints:^{
      [self.authorLabel autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
    }];
    [self.authorLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kLabelVerticalInsets];
    [self.authorLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kLabelHorizontalInsets];
    [self.authorLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kLabelHorizontalInsets];
    
    self.didSetupConstraints = YES;
  }
    
  [super updateConstraints];
}

@end