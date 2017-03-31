//
//  UISearchBar+Blocks.m
//  UISearchBarBlocks
//
//  Created by Håkon Bogen on 20.10.13.
//  Copyright (c) 2013 Håkon Bogen. All rights reserved.
//

#import "UISearchBar+Blocks.h"
#import <objc/runtime.h>

/* Only for convenience and readabilty in delegate methods */
typedef BOOL (^UISearchBarReturnBlock) (UISearchBar *searchBar);
typedef void (^UISearchBarVoidBlock) (UISearchBar *searchBar);
typedef void (^UISearchBarSearchTextBlock) (UISearchBar *searchBar,NSString *searchText);
typedef BOOL (^UISearchBarInRangeReplacementTextBlock) (UISearchBar *searchBar,NSRange range,NSString *text);
typedef void (^UISearchBarScopeIndexBlock)(UISearchBar *searchBar, NSInteger selectedScope);

@implementation UISearchBar (Blocks)


static const void *UISearchBarDelegateKey                                = &UISearchBarDelegateKey;
static const void *UISearchBarShouldBeginEditingKey                      = &UISearchBarShouldBeginEditingKey;
static const void *UISearchBarTextDidBeginEditingKey                     = &UISearchBarTextDidBeginEditingKey;
static const void *UISearchBarShouldEndEditingKey                        = &UISearchBarShouldEndEditingKey;
static const void *UISearchBarTextDidEndEditingKey                       = &UISearchBarTextDidEndEditingKey;
static const void *UISearchBarTextDidChangeKey                           = &UISearchBarTextDidChangeKey;
static const void *UISearchBarShouldChangeTextInRangeKey                 = &UISearchBarShouldChangeTextInRangeKey;
static const void *UISearchBarSearchButtonClickedKey                                = &UISearchBarSearchButtonClickedKey;
static const void *UISearchBarBookmarkButtonClickedKey                                = &UISearchBarBookmarkButtonClickedKey;
static const void *UISearchBarCancelButtonClickedKey                                = &UISearchBarCancelButtonClickedKey;
static const void *UISearchBarResultsListButtonClickedKey                                = &UISearchBarResultsListButtonClickedKey;
static const void *UISearchBarSelectedScopeButtonIndexDidChangeKey                                = &UISearchBarSelectedScopeButtonIndexDidChangeKey;




#pragma mark UISearchBar delegate Methods
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar;
{
    UISearchBarReturnBlock block = searchBar.completionShouldBeginEditingBlock;
    if (block) {
        return block(searchBar);
    }
    id delegate = objc_getAssociatedObject(self, UISearchBarDelegateKey);
    
    if (delegate && [delegate respondsToSelector:@selector(searchBarShouldBeginEditing:)]){
        return [delegate searchBarShouldBeginEditing:searchBar];
    }
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    UISearchBarVoidBlock block = searchBar.completionTextDidBeginEditingBlock;
    if (block) {
        block(searchBar);
    }
    id delegate = objc_getAssociatedObject(self, UISearchBarDelegateKey);
    
    if (delegate && [delegate respondsToSelector:@selector(searchBarTextDidBeginEditing:)]){
        [delegate searchBarTextDidBeginEditing:searchBar];
    }
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    UISearchBarReturnBlock block = searchBar.completionShouldEndEditingBlock;
    if (block) {
        return block(searchBar);
    }
    id delegate = objc_getAssociatedObject(self, UISearchBarDelegateKey);
    
    if (delegate && [delegate respondsToSelector:@selector(searchBarShouldEndEditing:)]){
        return [delegate searchBarShouldEndEditing:searchBar];
    }
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    UISearchBarVoidBlock block = searchBar.completionTextDidEndEditingBlock;
    if (block) {
        block(searchBar);
    }
    id delegate = objc_getAssociatedObject(self, UISearchBarDelegateKey);
    
    if (delegate && [delegate respondsToSelector:@selector(searchBarTextDidEndEditing:)]){
        [delegate searchBarTextDidEndEditing:searchBar];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    UISearchBarSearchTextBlock block = searchBar.completionTextDidChangeBlock;
    if (block) {
        block(searchBar,searchText);
    }
    id delegate = objc_getAssociatedObject(self, UISearchBarDelegateKey);
    
    if (delegate && [delegate respondsToSelector:@selector(searchBar:textDidChange:)]){
        [delegate searchBar:searchBar textDidChange:searchText];
    }
}
// called when text changes (including clear)
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    UISearchBarInRangeReplacementTextBlock block = searchBar.completionShouldChangeTextInRangeBlock;
    if (block) {
        return block(searchBar,range,text);
    }
    id delegate = objc_getAssociatedObject(self, UISearchBarDelegateKey);
    
    if (delegate && [delegate respondsToSelector:@selector(searchBar:shouldChangeTextInRange:replacementText:)]){
        return [delegate searchBar:searchBar shouldChangeTextInRange:range replacementText:text];
    }
    return YES;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    UISearchBarVoidBlock block = searchBar.completionSearchButtonClickedBlock;
    if (block) {
        block(searchBar);
    }
    id delegate = objc_getAssociatedObject(self, UISearchBarDelegateKey);
    
    if (delegate && [delegate respondsToSelector:@selector(searchBarSearchButtonClicked:)]){
        [delegate searchBarSearchButtonClicked:searchBar];
    }
}

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar
{
    UISearchBarVoidBlock block = searchBar.completionBookmarkButtonClickedBlock;
    if (block) {
        block(searchBar);
    }
    id delegate = objc_getAssociatedObject(self, UISearchBarDelegateKey);
    
    if (delegate && [delegate respondsToSelector:@selector(searchBarBookmarkButtonClicked:)]){
        [delegate searchBarBookmarkButtonClicked:searchBar];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    UISearchBarVoidBlock block = searchBar.completionCancelButtonClickedBlock;
    if (block) {
        block(searchBar);
    }
    id delegate = objc_getAssociatedObject(self, UISearchBarDelegateKey);
    
    if (delegate && [delegate respondsToSelector:@selector(searchBarCancelButtonClicked:)]){
        [delegate searchBarCancelButtonClicked:searchBar];
    }
}

- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar
{
    UISearchBarVoidBlock block = searchBar.completionResultsListButtonClickedBlock;
    if (block) {
        block(searchBar);
    }
    id delegate = objc_getAssociatedObject(self, UISearchBarDelegateKey);
    
    if (delegate && [delegate respondsToSelector:@selector(searchBarResultsListButtonClicked:)]){
        [delegate searchBarResultsListButtonClicked:searchBar];
    }
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    UISearchBarScopeIndexBlock block = searchBar.completionSelectedScopeButtonIndexDidChangeBlock;
    if (block) {
        block(searchBar,selectedScope);
    }
    id delegate = objc_getAssociatedObject(self, UISearchBarDelegateKey);
    
    if (delegate && [delegate respondsToSelector:@selector(searchBar:selectedScopeButtonIndexDidChange:)]){
        [delegate searchBar:searchBar selectedScopeButtonIndexDidChange:selectedScope];
    }
}


#pragma mark Block setting/getting methods
- (BOOL (^)(UISearchBar *))completionShouldBeginEditingBlock
{
    return objc_getAssociatedObject(self, UISearchBarShouldBeginEditingKey);
}

- (void)setCompletionShouldBeginEditingBlock:(BOOL (^)(UISearchBar *))searchBarShouldBeginEditingBlock
{
    [self setDelegateIfNoDelegateSet];
    objc_setAssociatedObject(self, UISearchBarShouldBeginEditingKey, searchBarShouldBeginEditingBlock, OBJC_ASSOCIATION_COPY);
}

- (void (^)(UISearchBar *))completionTextDidBeginEditingBlock
{
    return objc_getAssociatedObject(self, UISearchBarTextDidBeginEditingKey);
}

- (void)setCompletionTextDidBeginEditingBlock:(void (^)(UISearchBar *))searchBarTextDidBeginEditingBlock
{
    [self setDelegateIfNoDelegateSet];
    objc_setAssociatedObject(self, UISearchBarTextDidBeginEditingKey, searchBarTextDidBeginEditingBlock, OBJC_ASSOCIATION_COPY);
}

- (BOOL (^)(UISearchBar *))completionShouldEndEditingBlock
{
    return objc_getAssociatedObject(self, UISearchBarShouldEndEditingKey);
}

- (void)setCompletionShouldEndEditingBlock:(BOOL (^)(UISearchBar *))searchBarShouldEndEditingBlock
{
    [self setDelegateIfNoDelegateSet];
    objc_setAssociatedObject(self, UISearchBarShouldEndEditingKey, searchBarShouldEndEditingBlock, OBJC_ASSOCIATION_COPY);
}

- (void (^)(UISearchBar *))completionTextDidEndEditingBlock
{
    return objc_getAssociatedObject(self, UISearchBarTextDidEndEditingKey);
}

- (void)setCompletionTextDidEndEditingBlock:(void (^)(UISearchBar *))searchBarTextDidEndEditingBlock
{
    [self setDelegateIfNoDelegateSet];
    objc_setAssociatedObject(self, UISearchBarTextDidEndEditingKey, searchBarTextDidEndEditingBlock, OBJC_ASSOCIATION_COPY);
}

- (void (^)(UISearchBar *, NSString *))completionTextDidChangeBlock
{
    return objc_getAssociatedObject(self, UISearchBarTextDidChangeKey);
}

- (void)setCompletionTextDidChangeBlock:(void (^)(UISearchBar *, NSString *))searchBarTextDidChangeBlock
{
    [self setDelegateIfNoDelegateSet];
    objc_setAssociatedObject(self, UISearchBarTextDidChangeKey, searchBarTextDidChangeBlock, OBJC_ASSOCIATION_COPY);
}

- (BOOL (^)(UISearchBar *, NSRange, NSString *))completionShouldChangeTextInRangeBlock
{
    return objc_getAssociatedObject(self, UISearchBarShouldChangeTextInRangeKey);
}

- (void)setCompletionShouldChangeTextInRangeBlock:(BOOL (^)(UISearchBar *, NSRange, NSString *))searchBarShouldChangeTextInRangeBlock
{
    [self setDelegateIfNoDelegateSet];
    objc_setAssociatedObject(self, UISearchBarShouldChangeTextInRangeKey, searchBarShouldChangeTextInRangeBlock, OBJC_ASSOCIATION_COPY);
}

- (void (^)(UISearchBar *))completionSearchButtonClickedBlock
{
    return objc_getAssociatedObject(self, UISearchBarSearchButtonClickedKey);
}

- (void)setCompletionSearchButtonClickedBlock:(void (^)(UISearchBar *))searchBarSearchButtonClickedBlock
{
    [self setDelegateIfNoDelegateSet];
    objc_setAssociatedObject(self, UISearchBarSearchButtonClickedKey, searchBarSearchButtonClickedBlock, OBJC_ASSOCIATION_COPY);
}

- (void (^)(UISearchBar *))completionBookmarkButtonClickedBlock
{
    return objc_getAssociatedObject(self, UISearchBarBookmarkButtonClickedKey);
}

- (void)setCompletionBookmarkButtonClickedBlock:(void (^)(UISearchBar *))searchBarBookmarkButtonClickedBlock
{
    [self setDelegateIfNoDelegateSet];
    objc_setAssociatedObject(self, UISearchBarBookmarkButtonClickedKey, searchBarBookmarkButtonClickedBlock, OBJC_ASSOCIATION_COPY);
}

- (void (^)(UISearchBar *))completionCancelButtonClickedBlock
{
    return objc_getAssociatedObject(self, UISearchBarCancelButtonClickedKey);
}

- (void)setCompletionCancelButtonClickedBlock:(void (^)(UISearchBar *))searchBarCancelButtonClickedBlock
{
    [self setDelegateIfNoDelegateSet];
    objc_setAssociatedObject(self, UISearchBarCancelButtonClickedKey, searchBarCancelButtonClickedBlock, OBJC_ASSOCIATION_COPY);
}

- (void (^)(UISearchBar *))completionResultsListButtonClickedBlock
{
    return objc_getAssociatedObject(self, UISearchBarResultsListButtonClickedKey);
}

- (void)setCompletionResultsListButtonClickedBlock:(void (^)(UISearchBar *))searchBarResultsListButtonClickedBlock
{
    [self setDelegateIfNoDelegateSet];
    objc_setAssociatedObject(self, UISearchBarResultsListButtonClickedKey, searchBarResultsListButtonClickedBlock, OBJC_ASSOCIATION_COPY);
}

- (void (^)(UISearchBar *, NSInteger))completionSelectedScopeButtonIndexDidChangeBlock
{
    return objc_getAssociatedObject(self, UISearchBarSelectedScopeButtonIndexDidChangeKey);
}

- (void)setCompletionSelectedScopeButtonIndexDidChangeBlock:(void (^)(UISearchBar *, NSInteger))searchBarSelectedScopeButtonIndexDidChangeBlock
{
    [self setDelegateIfNoDelegateSet];
    objc_setAssociatedObject(self, UISearchBarSelectedScopeButtonIndexDidChangeKey, searchBarSelectedScopeButtonIndexDidChangeBlock, OBJC_ASSOCIATION_COPY);
}

- (void)setDelegateIfNoDelegateSet
{
    if (self.delegate != (id<UISearchBarDelegate>)self) {
        objc_setAssociatedObject(self, UISearchBarDelegateKey, self.delegate, OBJC_ASSOCIATION_ASSIGN);
        self.delegate = (id<UISearchBarDelegate>)self;
    }
}

@end
