//
//  VIDCollectionViewVideoCell.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/9/23.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "VIDCollectionViewVideoCell.h"

@interface VIDCollectionViewVideoCell ()


@property (weak, nonatomic  ) IBOutlet UILabel              *titleLabel;
@property (nonatomic, weak) IBOutlet UIButton                      *playBtn;

@end

@implementation VIDCollectionViewVideoCell


+ (instancetype)videoCellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath
{
    VIDCollectionViewVideoCell *cell = nil;
    
    
    if (cell == nil) {
        
        @try {
            
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
            
        } @catch (NSException *exception) {
            
            NSLog(@"%@", exception);
            
            if (!cell) {
                
                UINib *cellNib = [UINib nibWithNibName:NSStringFromClass(self) bundle:[NSBundle mainBundle]];
                
                if (!cellNib) {
                    [collectionView registerClass:self forCellWithReuseIdentifier:NSStringFromClass(self)];
                }else
                {
                    [collectionView registerNib:cellNib forCellWithReuseIdentifier:NSStringFromClass(self)];
                }
                
            }
            
        } @finally {
            
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
        }
        
    }
    
    return cell;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUIOnce];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupUIOnce];
}

- (void)setupUIOnce
{
    
    self.picView.tag = 1033;
    self.picView.userInteractionEnabled = YES;
    [self.picView addSubview:self.playBtn];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    
}

- (void)setModel:(ZFVideoModel *)model {
    
    [self.picView sd_setImageWithURL:[NSURL URLWithString:model.coverForFeed] placeholderImage:[UIImage imageWithColor:[UIColor RandomColor]]];
    
    self.titleLabel.text = model.title;
}

- (IBAction)play:(UIButton *)sender {
    if (self.playBlock) {
        self.playBlock(sender);
    }
}

@end
