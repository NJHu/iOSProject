#	LxGridView

######	Imitate Apple iOS system Desktop icons arrangement and interaction by inheriting UICollectionView!
*	![demo](demo.gif)
---
###	Installation
	You only need drag directory LxGridView to your project.
### Podfile
    pod 'LxGridView', '~> 1.0.0'
###	Support	
	Minimum support iOS version: iOS 6.0
###	Usage

`You can use LxGridView as convenient as UICollectionView.`

	_gridViewFlowLayout = [[LxGridViewFlowLayout alloc]init];
	//	... config _gridViewFlowLayout
	
	_gridView = [[LxGridView alloc]initWithFrame:GRIDVIEW_FRAME collectionViewLayout:_gridViewFlowLayout];
	//	... config _gridView
	
	[_gridView registerClass:[LxGridViewCell class] forCellWithReuseIdentifier:GRIDVIEW_CELL_REUSE_IDENTIFIER];

	//	implement delegate method
	- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
	{
	    return self.dataArray.count;
	}
	
	- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
	{
	    LxGridViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:LxGridViewCellReuseIdentifier forIndexPath:indexPath];
	    
	    cell.delegate = self;
	    cell.editing = _gridView.editing;
	    
	    //	...	config cell
	    
	    return cell;
	}
	
	- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath willMoveToIndexPath:(NSIndexPath *)destinationIndexPath
	{
	    NSDictionary * dataDict = self.dataArray[sourceIndexPath.item];
	    [self.dataArray removeObjectAtIndex:sourceIndexPath.item];
	    [self.dataArray insertObject:dataDict atIndex:destinationIndexPath.item];
	}
	
	- (void)deleteButtonClickedInGridViewCell:(LxGridViewCell *)gridViewCell
	{
	    NSIndexPath * gridViewCellIndexPath = [_gridView indexPathForCell:gridViewCell];
	    
	    if (gridViewCellIndexPath) {
	        [self.dataArray removeObjectAtIndex:gridViewCellIndexPath.item];
	        [_gridView performBatchUpdates:^{
	            [_gridView deleteItemsAtIndexPaths:@[gridViewCellIndexPath]];
	        } completion:nil];
	    }
	}

---
###	License
LxGridView is available under the Apache License 2.0. See the LICENSE file for more info.
