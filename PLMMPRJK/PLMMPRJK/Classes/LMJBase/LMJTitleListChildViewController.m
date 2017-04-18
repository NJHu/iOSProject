//
//  LMJTitleListChildViewController.m
//  GoMeYWLC
//
//  Created by NJHu on 2017/1/17.
//  Copyright © 2017年 NJHu. All rights reserved.
//

#import "LMJTitleListChildViewController.h"

@interface LMJTitleListChildTableViewController ()

@end

@implementation LMJTitleListChildTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self setupTitleListChildViewUI];
}

- (void)setupTitleListChildViewUI
{
    self.view.frame = Main_Screen_Bounds;
    
    UIEdgeInsets edgeInset = self.tableView.contentInset;
    
    edgeInset.top +=  64 + LMJTitlesListsParentViewControllerTitleHeight;
    edgeInset.bottom += self.parentViewController.tabBarController.tabBar.mj_h;
    
    self.tableView.contentInset = edgeInset;
    
    
}

@end





@interface LMJTitleListChildCollectionViewController ()

@end

@implementation LMJTitleListChildCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupTitleListChildViewUI];
}

- (void)setupTitleListChildViewUI
{
    self.view.frame = Main_Screen_Bounds;
    
    UIEdgeInsets edgeInset = self.collectionView.contentInset;
    
    edgeInset.top +=  64 + LMJTitlesListsParentViewControllerTitleHeight;
    edgeInset.bottom += self.parentViewController.tabBarController.tabBar.mj_h;
    
    self.collectionView.contentInset = edgeInset;
    
    
}

@end
