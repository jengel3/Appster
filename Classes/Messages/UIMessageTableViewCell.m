#import "UIMessageTableViewCell.h"
#import "../PureLayout/PureLayout.h"

#define horizontalInset 15.0f
#define verticalInset 10.0f

@implementation UIMessageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.msgLabel = [UILabel newAutoLayoutView];
    [self.msgLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.msgLabel setNumberOfLines:0];
    [self.msgLabel setTextAlignment:NSTextAlignmentLeft];

    self.timestampLabel = [UILabel newAutoLayoutView];
    [self.timestampLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [self.timestampLabel setNumberOfLines:1];
    [self.timestampLabel setTextAlignment:NSTextAlignmentLeft];

    [self.contentView addSubview:self.msgLabel];
    [self.contentView addSubview:self.timestampLabel];
  }
  
  return self;
}

- (void)updateConstraints {
  if (!self.didSetupConstraints) {
      
    // setup content 
    [NSLayoutConstraint autoSetPriority:UILayoutPriorityRequired forConstraints:^{
      [self.msgLabel autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
    }];

    [self.msgLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:verticalInset];
    [self.msgLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:horizontalInset];
    [self.msgLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:horizontalInset];


    // setup timestamp
    [self.timestampLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.msgLabel withOffset:verticalInset];

    [NSLayoutConstraint autoSetPriority:UILayoutPriorityRequired forConstraints:^{
      [self.timestampLabel autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
    }];
    [self.timestampLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:verticalInset];
    [self.timestampLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:horizontalInset];
    [self.timestampLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:horizontalInset];
    
    self.didSetupConstraints = YES;
  }
    
  [super updateConstraints];
}

@end