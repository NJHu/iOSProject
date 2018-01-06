//
//  LxGridViewCell.m
//  LxGridView
//

#import "LxGridView.h"


static NSString * const kVibrateAnimation = @stringify(kVibrateAnimation);
static CGFloat const VIBRATE_DURATION = 0.1;
static CGFloat const VIBRATE_RADIAN = M_PI / 96;

@interface LxGridViewCell ()

@property (nonatomic,assign) BOOL vibrating;

@end

@implementation LxGridViewCell
{
    UIButton * _deleteButton;
    UILabel * _titleLabel;
}
@synthesize editing = _editing;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        [self setupEvents];
    }
    return self;
}

- (void)setup
{
    self.iconImageView = [[UIImageView alloc]init];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.iconImageView.layer.cornerRadius = ICON_CORNER_RADIUS;
    self.iconImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.iconImageView];
    
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteButton setImage:[UIImage imageNamed:@"delete_collect_btn"] forState:UIControlStateNormal];
    [self.contentView addSubview:_deleteButton];
    _deleteButton.hidden = YES;
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.text = @"title";
    _titleLabel.font = [UIFont systemFontOfSize:12];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_titleLabel];
    
    self.iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    _deleteButton.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSLayoutConstraint * iconImageViewLeftConstraint =
    [NSLayoutConstraint constraintWithItem:self.iconImageView
                                 attribute:NSLayoutAttributeLeft
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.contentView
                                 attribute:NSLayoutAttributeLeft
                                multiplier:1
                                  constant:0];
    
    NSLayoutConstraint * iconImageViewRightConstraint =
    [NSLayoutConstraint constraintWithItem:self.iconImageView
                                 attribute:NSLayoutAttributeRight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.contentView
                                 attribute:NSLayoutAttributeRight
                                multiplier:1
                                  constant:0];
    
    NSLayoutConstraint * iconImageViewTopConstraint =
    [NSLayoutConstraint constraintWithItem:self.iconImageView
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.contentView
                                 attribute:NSLayoutAttributeTop
                                multiplier:1
                                  constant:0];
    
    NSLayoutConstraint * iconImageViewHeightConstraint =
    [NSLayoutConstraint constraintWithItem:self.iconImageView
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.iconImageView
                                 attribute:NSLayoutAttributeHeight
                                multiplier:1
                                  constant:0];
    
    [self.contentView addConstraints:@[iconImageViewLeftConstraint,iconImageViewRightConstraint,iconImageViewTopConstraint,iconImageViewHeightConstraint]];
    
    NSLayoutConstraint * deleteButtonTopConstraint =
    [NSLayoutConstraint constraintWithItem:_deleteButton
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.iconImageView
                                 attribute:NSLayoutAttributeTop
                                multiplier:1
                                  constant:-_deleteButton.currentImage.size.height/2];
    
    NSLayoutConstraint * deleteButtonLeftConstraint =
    [NSLayoutConstraint constraintWithItem:_deleteButton
                                 attribute:NSLayoutAttributeLeft
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.iconImageView
                                 attribute:NSLayoutAttributeLeft
                                multiplier:1
                                  constant:-_deleteButton.currentImage.size.width/2];
    
    NSLayoutConstraint * deleteButtonWidthConstraint =
    [NSLayoutConstraint constraintWithItem:_deleteButton
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeWidth
                                multiplier:1
                                  constant:_deleteButton.currentImage.size.width];
    
    NSLayoutConstraint * deleteButtonHeightConstraint =
    [NSLayoutConstraint constraintWithItem:_deleteButton
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeHeight
                                multiplier:1
                                  constant:_deleteButton.currentImage.size.height];

    [self.contentView addConstraints:@[deleteButtonLeftConstraint,deleteButtonTopConstraint,deleteButtonWidthConstraint,deleteButtonHeightConstraint]];
    
    NSLayoutConstraint * centerXConstraint =
    [NSLayoutConstraint constraintWithItem:_titleLabel
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.iconImageView
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1
                                  constant:0];
    
    NSLayoutConstraint * titleLabelTopConstraint =
    [NSLayoutConstraint constraintWithItem:_titleLabel
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.iconImageView
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1
                                  constant:3];
    
    NSLayoutConstraint * titleLabelWidthConstraint =
    [NSLayoutConstraint constraintWithItem:_titleLabel
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.iconImageView
                                 attribute:NSLayoutAttributeWidth
                                multiplier:1
                                  constant:0];
    
    NSLayoutConstraint * titleLabelHeightConstraint =
    [NSLayoutConstraint constraintWithItem:_titleLabel
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeHeight
                                multiplier:1
                                  constant:15];
    
    [self.contentView addConstraints:@[centerXConstraint, titleLabelTopConstraint, titleLabelWidthConstraint, titleLabelHeightConstraint]];
}

- (void)setupEvents
{
    [_deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.iconImageView.userInteractionEnabled = YES;
}

- (void)deleteButtonClicked:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(deleteButtonClickedInGridViewCell:)]) {
        [self.delegate deleteButtonClickedInGridViewCell:self];
    }
}

- (BOOL)vibrating
{
    return [self.iconImageView.layer.animationKeys containsObject:kVibrateAnimation];
}

- (void)setVibrating:(BOOL)vibrating
{
    BOOL _vibrating = [self.layer.animationKeys containsObject:kVibrateAnimation];
    
    if (_vibrating && !vibrating) {
        [self.layer removeAnimationForKey:kVibrateAnimation];
    }
    else if (!_vibrating && vibrating) {
        CABasicAnimation * vibrateAnimation = [CABasicAnimation animationWithKeyPath:@stringify(transform.rotation.z)];
        vibrateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        vibrateAnimation.fromValue = @(- VIBRATE_RADIAN);
        vibrateAnimation.toValue = @(VIBRATE_RADIAN);
        vibrateAnimation.autoreverses = YES;
        vibrateAnimation.duration = VIBRATE_DURATION;
        vibrateAnimation.repeatCount = CGFLOAT_MAX;
        [self.layer addAnimation:vibrateAnimation forKey:kVibrateAnimation];
    }
}

- (BOOL)editing
{
    return self.vibrating;
}

- (void)setEditing:(BOOL)editing
{
    self.vibrating = editing;
    _deleteButton.hidden = !editing;
}

- (void)setTitle:(NSString *)title
{
    _titleLabel.text = title;
}

- (NSString *)title
{
    return _titleLabel.text;
}

- (UIView *)snapshotView
{
    UIView * snapshotView = [[UIView alloc]init];
    
    UIView * cellSnapshotView = nil;
    UIView * deleteButtonSnapshotView = nil;
    
    if ([self respondsToSelector:@selector(snapshotViewAfterScreenUpdates:)]) {
        cellSnapshotView = [self snapshotViewAfterScreenUpdates:NO];
    }
    else {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage * cellSnapshotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        cellSnapshotView = [[UIImageView alloc]initWithImage:cellSnapshotImage];
    }
    
    if ([_deleteButton respondsToSelector:@selector(snapshotViewAfterScreenUpdates:)]) {
        deleteButtonSnapshotView = [_deleteButton snapshotViewAfterScreenUpdates:NO];
    }
    else {
        UIGraphicsBeginImageContextWithOptions(_deleteButton.bounds.size, _deleteButton.opaque, 0);
        [_deleteButton.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage * deleteButtonSnapshotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        deleteButtonSnapshotView = [[UIImageView alloc]initWithImage:deleteButtonSnapshotImage];
    }
    
    snapshotView.frame = CGRectMake(-deleteButtonSnapshotView.frame.size.width / 2,
                                    -deleteButtonSnapshotView.frame.size.height / 2,
                                    deleteButtonSnapshotView.frame.size.width / 2 + cellSnapshotView.frame.size.width,
                                    deleteButtonSnapshotView.frame.size.height / 2 + cellSnapshotView.frame.size.height);
    cellSnapshotView.frame = CGRectMake(deleteButtonSnapshotView.frame.size.width / 2,
                                        deleteButtonSnapshotView.frame.size.height / 2,
                                        cellSnapshotView.frame.size.width,
                                        cellSnapshotView.frame.size.height);
    deleteButtonSnapshotView.frame = CGRectMake(0, 0,
                                                deleteButtonSnapshotView.frame.size.width,
                                                deleteButtonSnapshotView.frame.size.height);
    
    [snapshotView addSubview:cellSnapshotView];
    [snapshotView addSubview:deleteButtonSnapshotView];
    
    return snapshotView;
}

@end
