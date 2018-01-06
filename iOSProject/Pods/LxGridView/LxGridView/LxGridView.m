//
//  LxGridView.m
//  LxGridView
//

#import "LxGridView.h"


@implementation LxGridView

@synthesize editing = _editing;

- (void)setEditing:(BOOL)editing
{
    _editing = editing;
    for (UICollectionViewCell * cell in self.visibleCells) {
        NSCAssert([cell isKindOfClass:[LxGridViewCell class]] || cell == nil, @"LxGridView: Must use LxGridViewCell as your collectionViewCell class!");
        LxGridViewCell * gridViewCell = (LxGridViewCell *)cell;
        gridViewCell.editing = editing;
    }
}

- (BOOL)editing
{
    return _editing;
}

@end
