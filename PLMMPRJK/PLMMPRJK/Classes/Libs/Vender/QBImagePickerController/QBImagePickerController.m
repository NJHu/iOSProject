//
//  QBImagePickerController.m
//  QBImagePickerController
//
//  Created by Tanaka Katsuma on 2013/12/30.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import "QBImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>

// Views
#import "QBImagePickerGroupCell.h"
#import "QBAssetsCollectionViewLayout.h"

// ViewControllers
#import "QBAssetsCollectionViewController.h"

ALAssetsFilter * ALAssetsFilterFromQBImagePickerControllerFilterType(QBImagePickerControllerFilterType type) {
    switch (type) {
        case QBImagePickerControllerFilterTypeNone:
            return [ALAssetsFilter allAssets];
            break;
            
        case QBImagePickerControllerFilterTypePhotos:
            return [ALAssetsFilter allPhotos];
            break;
            
        case QBImagePickerControllerFilterTypeVideos:
            return [ALAssetsFilter allVideos];
            break;
    }
}

@interface QBImagePickerController () <QBAssetsCollectionViewControllerDelegate>

@property (nonatomic, strong, readwrite) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, copy, readwrite) NSArray *assetsGroups;
@property (nonatomic, strong, readwrite) NSMutableOrderedSet *selectedAssetURLs;
@property (nonatomic, assign) BOOL firstShow;

@end

@implementation QBImagePickerController

+ (BOOL)isAccessible
{
    return ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] &&
            [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]);
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        [self setUpProperties];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setUpProperties];
}

- (void)setUpProperties
{
    // Property settings
    self.selectedAssetURLs = [NSMutableOrderedSet orderedSet];
    
    self.groupTypes = @[
                        @(ALAssetsGroupSavedPhotos),
                        @(ALAssetsGroupPhotoStream),
                        @(ALAssetsGroupAlbum)
                        ];
    self.filterType = QBImagePickerControllerFilterTypeNone;
    self.showsCancelButton = YES;
    
    // View settings
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Create assets library instance
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    self.assetsLibrary = assetsLibrary;
    
    // Register cell classes
    [self.tableView registerClass:[QBImagePickerGroupCell class] forCellReuseIdentifier:@"GroupCell"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // View controller settings
    self.title = NSLocalizedStringFromTable(@"title", @"QBImagePickerController", nil);
    self.firstShow = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Load assets groups
    [self loadAssetsGroupsWithTypes:self.groupTypes
                         completion:^(NSArray *assetsGroups) {
                             self.assetsGroups = assetsGroups;
                             [self.tableView reloadData];
                             if (self.firstShow) {
                                 self.firstShow = NO;
//                                 [self pushToCollectionVCWithIndex:0];
                             }
                         }];
    
    // Validation
    self.navigationItem.rightBarButtonItem.enabled = [self validateNumberOfSelections:self.selectedAssetURLs.count];
}


#pragma mark - Accessors

- (void)setShowsCancelButton:(BOOL)showsCancelButton
{
    _showsCancelButton = showsCancelButton;
    
    // Show/hide cancel button
    if (showsCancelButton) {
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
        [self.navigationItem setLeftBarButtonItem:cancelButton animated:NO];
    } else {
        [self.navigationItem setLeftBarButtonItem:nil animated:NO];
    }
}

- (void)setAllowsMultipleSelection:(BOOL)allowsMultipleSelection
{
    _allowsMultipleSelection = allowsMultipleSelection;
    
    // Show/hide done button
    if (allowsMultipleSelection) {
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
        [self.navigationItem setRightBarButtonItem:doneButton animated:NO];
    } else {
        [self.navigationItem setRightBarButtonItem:nil animated:NO];
    }
}


#pragma mark - Actions

- (void)done:(id)sender
{
    [self passSelectedAssetsToDelegate];
}

- (void)cancel:(id)sender
{
    // Delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(qb_imagePickerControllerDidCancel:)]) {
		[self.delegate qb_imagePickerControllerDidCancel:self];
    }
}


#pragma mark - Validating Selections

- (BOOL)validateNumberOfSelections:(NSUInteger)numberOfSelections
{
    // Check the number of selected assets
    NSUInteger minimumNumberOfSelection = MAX(1, self.minimumNumberOfSelection);
    BOOL qualifiesMinimumNumberOfSelection = (numberOfSelections >= minimumNumberOfSelection);
    
    BOOL qualifiesMaximumNumberOfSelection = YES;
    if (minimumNumberOfSelection <= self.maximumNumberOfSelection) {
        qualifiesMaximumNumberOfSelection = (numberOfSelections <= self.maximumNumberOfSelection);
    }
    
    return (qualifiesMinimumNumberOfSelection && qualifiesMaximumNumberOfSelection);
}


#pragma mark - Managing Assets

- (void)loadAssetsGroupsWithTypes:(NSArray *)types completion:(void (^)(NSArray *assetsGroups))completion
{
    __block NSMutableArray *assetsGroups = [NSMutableArray array];
    __block NSUInteger numberOfFinishedTypes = 0;
    
    for (NSNumber *type in types) {
        __weak typeof(self) weakSelf = self;
        
        [self.assetsLibrary enumerateGroupsWithTypes:[type unsignedIntegerValue]
                                          usingBlock:^(ALAssetsGroup *assetsGroup, BOOL *stop) {
                                              if (assetsGroup) {
                                                  // Filter the assets group
                                                  [assetsGroup setAssetsFilter:ALAssetsFilterFromQBImagePickerControllerFilterType(weakSelf.filterType)];
                                                  
                                                  if (assetsGroup.numberOfAssets > 0) {
                                                      // Add assets group
                                                      [assetsGroups addObject:assetsGroup];
                                                  }
                                              } else {
                                                  numberOfFinishedTypes++;
                                              }
                                              
                                              // Check if the loading finished
                                              if (numberOfFinishedTypes == types.count) {
                                                  // Sort assets groups
                                                  NSArray *sortedAssetsGroups = [self sortAssetsGroups:(NSArray *)assetsGroups typesOrder:types];
                                                  
                                                  // Call completion block
                                                  if (completion) {
                                                      completion(sortedAssetsGroups);
                                                  }
                                              }
                                          } failureBlock:^(NSError *error) {
                                              NSLog(@"Error: %@", [error localizedDescription]);
                                          }];
    }
}

- (NSArray *)sortAssetsGroups:(NSArray *)assetsGroups typesOrder:(NSArray *)typesOrder
{
    NSMutableArray *sortedAssetsGroups = [NSMutableArray array];
    
    for (ALAssetsGroup *assetsGroup in assetsGroups) {
        if (sortedAssetsGroups.count == 0) {
            [sortedAssetsGroups addObject:assetsGroup];
            continue;
        }
        
        ALAssetsGroupType assetsGroupType = [[assetsGroup valueForProperty:ALAssetsGroupPropertyType] unsignedIntegerValue];
        NSUInteger indexOfAssetsGroupType = [typesOrder indexOfObject:@(assetsGroupType)];
        
        for (NSInteger i = 0; i <= sortedAssetsGroups.count; i++) {
            if (i == sortedAssetsGroups.count) {
                [sortedAssetsGroups addObject:assetsGroup];
                break;
            }
            
            ALAssetsGroup *sortedAssetsGroup = sortedAssetsGroups[i];
            ALAssetsGroupType sortedAssetsGroupType = [[sortedAssetsGroup valueForProperty:ALAssetsGroupPropertyType] unsignedIntegerValue];
            NSUInteger indexOfSortedAssetsGroupType = [typesOrder indexOfObject:@(sortedAssetsGroupType)];
            
            if (indexOfAssetsGroupType < indexOfSortedAssetsGroupType) {
                [sortedAssetsGroups insertObject:assetsGroup atIndex:i];
                break;
            }
        }
    }
    
    return [sortedAssetsGroups copy];
}

- (void)passSelectedAssetsToDelegate
{
    // Load assets from URLs
    __block NSMutableArray *assets = [NSMutableArray array];
    __block NSUInteger tryCount = 0;
    
    for (NSURL *selectedAssetURL in self.selectedAssetURLs) {
        __weak typeof(self) weakSelf = self;
        
        // Success block
        void (^selectAsset)(ALAsset *) = ^(ALAsset *asset) {
            if (asset) {
                [assets addObject:asset];
            }
            // Check if the loading finished
            if (tryCount == weakSelf.selectedAssetURLs.count) {
                //NSLog(@"照片查找失败张数：%lu", (long)(tryCount - assets.count));
                // Delegate
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(qb_imagePickerController:didSelectAssets:)]) {
                    [weakSelf.delegate qb_imagePickerController:weakSelf didSelectAssets:[assets copy]];
                }
            }
        };
        
        [self.assetsLibrary assetForURL:selectedAssetURL resultBlock:^(ALAsset *asset) {
            if (asset) {
                tryCount++;
                selectAsset(asset);
            }else{
                // Search in the Photo Stream Album
                [weakSelf.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupPhotoStream usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                    [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stopG) {
                        if([result.defaultRepresentation.url isEqual:selectedAssetURL]) {
                            *stopG = YES;
                            *stop = YES;
                            tryCount++;
                            selectAsset(result);
                        }else if (index == 0){
                            NSLog(@"找完了");
                            tryCount++;//此处为查找失败
                            selectAsset(nil);
                        }
                    }];
                } failureBlock:^(NSError *error) {
                    NSLog(@"Error: %@", [error localizedDescription]);
                }];
            }
        } failureBlock:^(NSError *error) {
            NSLog(@"Error: %@", [error localizedDescription]);
        }];
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.assetsGroups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QBImagePickerGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupCell" forIndexPath:indexPath];
    
    ALAssetsGroup *assetsGroup = self.assetsGroups[indexPath.row];
    cell.assetsGroup = assetsGroup;
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 86.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self pushToCollectionVCWithIndex:indexPath.row];
}

- (void)pushToCollectionVCWithIndex:(NSInteger)index{
    if (index >= 0 && index < self.assetsGroups.count) {
        QBAssetsCollectionViewController *assetsCollectionViewController = [[QBAssetsCollectionViewController alloc] initWithCollectionViewLayout:[QBAssetsCollectionViewLayout layout]];
        assetsCollectionViewController.imagePickerController = self;
        assetsCollectionViewController.filterType = self.filterType;
        assetsCollectionViewController.allowsMultipleSelection = self.allowsMultipleSelection;
        assetsCollectionViewController.minimumNumberOfSelection = self.minimumNumberOfSelection;
        assetsCollectionViewController.maximumNumberOfSelection = self.maximumNumberOfSelection;
        
        ALAssetsGroup *assetsGroup = self.assetsGroups[index];
        assetsCollectionViewController.delegate = self;
        assetsCollectionViewController.assetsGroup = assetsGroup;
        
        for (NSURL *assetURL in self.selectedAssetURLs) {
            [assetsCollectionViewController selectAssetHavingURL:assetURL];
        }
        
        [self.navigationController pushViewController:assetsCollectionViewController animated:YES];
    }
}


#pragma mark - QBAssetsCollectionViewControllerDelegate

- (void)assetsCollectionViewController:(QBAssetsCollectionViewController *)assetsCollectionViewController didSelectAsset:(ALAsset *)asset
{
    if (self.allowsMultipleSelection) {
        // Add asset URL
        NSURL *assetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
        [self.selectedAssetURLs addObject:assetURL];
        
        // Validation
        self.navigationItem.rightBarButtonItem.enabled = [self validateNumberOfSelections:self.selectedAssetURLs.count];
    } else {
        // Delegate
        if (self.delegate && [self.delegate respondsToSelector:@selector(qb_imagePickerController:didSelectAsset:)]) {
			[self.delegate qb_imagePickerController:self didSelectAsset:asset];
        }
    }
}

- (void)assetsCollectionViewController:(QBAssetsCollectionViewController *)assetsCollectionViewController didDeselectAsset:(ALAsset *)asset
{
    if (self.allowsMultipleSelection) {
        // Remove asset URL
        NSURL *assetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
        [self.selectedAssetURLs removeObject:assetURL];
        
        // Validation
        self.navigationItem.rightBarButtonItem.enabled = [self validateNumberOfSelections:self.selectedAssetURLs.count];
    }
}

- (void)assetsCollectionViewControllerDidFinishSelection:(QBAssetsCollectionViewController *)assetsCollectionViewController
{
    [self passSelectedAssetsToDelegate];
}

@end
