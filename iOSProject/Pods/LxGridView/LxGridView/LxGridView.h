//
//  LxGridView.h
//  LxGridView
//

#import <UIKit/UIKit.h>
#import "LxGridViewCell.h"
#import "LxGridViewFlowLayout.h"

#define stringify   __STRING


@interface LxGridView : UICollectionView

@property (nonatomic,assign) BOOL editing;

@end
