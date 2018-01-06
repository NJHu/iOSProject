//
//  LxGridViewCell.h
//  LxGridView
//

#import <UIKit/UIKit.h>


static CGFloat const LxGridView_DELETE_RADIUS = 10;
static CGFloat const ICON_CORNER_RADIUS = 10;

@class LxGridViewCell;

@protocol LxGridViewCellDelegate <NSObject>

- (void)deleteButtonClickedInGridViewCell:(LxGridViewCell *)gridViewCell;

@end

@interface LxGridViewCell : UICollectionViewCell

@property (nonatomic,assign) id<LxGridViewCellDelegate> delegate;
@property (nonatomic,retain) UIImageView * iconImageView;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,assign) BOOL editing;

- (UIView *)snapshotView;

@end
