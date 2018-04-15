//
//  MOFSPickerManager.h
//  MOFSPickerManager
//
//  Created by luoyuan on 16/8/26.
//  Copyright © 2016年 luoyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOFSDatePicker.h"
#import "MOFSPickerView.h"
#import "MOFSAddressPickerView.h"

typedef void (^DatePickerCommitBlock)(NSDate * _Nonnull date);
typedef void (^DatePickerCancelBlock)(void);

typedef void (^PickerViewCommitBlock)(NSString * _Nonnull string);
typedef void (^PickerViewCustomCommitBlock)(id model);
typedef void (^PickerViewCancelBlock)(void);

@interface MOFSPickerManager : NSObject

+ (MOFSPickerManager *_Nonnull)shareManger;

@property (nonatomic, strong) MOFSDatePicker * _Nonnull datePicker;

@property (nonatomic, strong) MOFSPickerView * _Nonnull pickView;

@property (nonatomic, strong) MOFSAddressPickerView * _Nonnull addressPicker;

// ================================DatePicker===================================//

/**
 * show default datePicker.
 * default datePickerMode : UIDatePickerModeDate.
 * default cancelTitle : "取消".
 * default commitTitle : "确定".
 * default title : "".
 * @param tag : will remeber the last date you had select.
 */
- (void)showDatePickerWithTag:(NSInteger)tag commitBlock:(DatePickerCommitBlock _Nullable )commitBlock cancelBlock:(DatePickerCancelBlock _Nullable )cancelBlock;

/**
 * show default datePicker with your custom datePickerMode.
 * default cancelTitle : "取消".
 * default commitTitle : "确定".
 * default title : "".
 * @param tag : will remeber the last date you had select.
 * @param mode : UIDatePickerMode
 */
- (void)showDatePickerWithTag:(NSInteger)tag datePickerMode:(UIDatePickerMode)mode commitBlock:(DatePickerCommitBlock _Nullable )commitBlock cancelBlock:(DatePickerCancelBlock _Nullable )cancelBlock;

/**
 * show datePicker with your custom datePickerMode ,title , cancelTitle , commitTitle.
 * @param tag : will remeber the last date you had select.
 * @param title : toolbar title
 * @param cancelTitle : "".
 * @param commitTitle : "".
 * @param mode : UIDatePickerMode.
 */
- (void)showDatePickerWithTag:(NSInteger)tag title:(NSString *_Nullable)title cancelTitle:(NSString *_Nullable)cancelTitle commitTitle:(NSString *_Nullable)commitTitle datePickerMode:(UIDatePickerMode)mode commitBlock:(DatePickerCommitBlock _Nullable )commitBlock cancelBlock:(DatePickerCancelBlock _Nullable )cancelBlock;

/**
 * show datePicker with your custom datePickerMode ,firstDate , minDate , maxDate.
 * @param firstDate : show date.
 * @param minDate : minimumDate.
 * @param maxDate : maximumDate.
 * @param mode : UIDatePickerMode.
 */
- (void)showDatePickerWithTag:(NSInteger)tag firstDate:(NSDate *_Nullable)firstDate minDate:(NSDate *_Nullable)minDate maxDate:(NSDate *_Nullable)maxDate datePickerMode:(UIDatePickerMode)mode commitBlock:(DatePickerCommitBlock _Nullable )commitBlock cancelBlock:(DatePickerCancelBlock _Nullable )cancelBlock;

/**
 * show datePicker with your custom datePickerMode ,firstDate ,title , cancelTitle , commitTitle , minDate , maxDate.
 * @param title : toolbar title
 * @param cancelTitle : "".
 * @param commitTitle : "".
 * @param firstDate : show date.
 * @param minDate : minimumDate.
 * @param maxDate : maximumDate.
 * @param mode : UIDatePickerMode.
 * @param tag : will remeber the last date you had select.
 */
- (void)showDatePickerWithTitle:(NSString *_Nullable)title cancelTitle:(NSString *_Nullable)cancelTitle commitTitle:(NSString *_Nullable)commitTitle firstDate:(NSDate *_Nullable)firstDate minDate:(NSDate *_Nullable)minDate maxDate:(NSDate *_Nullable)maxDate datePickerMode:(UIDatePickerMode)mode tag:(NSInteger)tag commitBlock:(DatePickerCommitBlock _Nullable )commitBlock cancelBlock:(DatePickerCancelBlock _Nullable )cancelBlock;




// ================================pickerView===================================//

- (void)showPickerViewWithDataArray:(NSArray<NSString *> *_Nullable)array tag:(NSInteger)tag title:(NSString *_Nullable)title cancelTitle:(NSString *_Nullable)cancelTitle commitTitle:(NSString *_Nullable)commitTitle commitBlock:(PickerViewCommitBlock _Nullable )commitBlock cancelBlock:(PickerViewCancelBlock _Nullable )cancelBlock;


- (void)showPickerViewWithCustomDataArray:(NSArray *_Nullable)array keyMapper:(NSString *)keyMapper tag:(NSInteger)tag title:(NSString *_Nullable)title cancelTitle:(NSString *_Nullable)cancelTitle commitTitle:(NSString *_Nullable)commitTitle commitBlock:(PickerViewCustomCommitBlock _Nullable)commitBlock cancelBlock:(PickerViewCancelBlock _Nullable )cancelBlock;

//===============================addressPicker===================================//

/**
 *  show addressPicker with your custom title, cancelTitle, commitTitle
 *
 *  @param title       your custom title
 *  @param cancelTitle your custom cancelTitle
 *  @param commitTitle your custom commitTitle
 *  @param commitBlock commitBlock
 *  @param cancelBlock cancelBlock
 */
- (void)showMOFSAddressPickerWithTitle:(NSString *_Nullable)title cancelTitle:(NSString *_Nullable)cancelTitle commitTitle:(NSString *_Nullable)commitTitle commitBlock:(void(^_Nullable)(NSString * _Nullable address, NSString * _Nullable zipcode))commitBlock cancelBlock:(void(^_Nullable)(void))cancelBlock;

/**
 *  show addressPicker with your custom title, cancelTitle, commitTitle
 *
 *  @param title       your custom title
 *  @param address     default address
 *  @param cancelTitle your custom cancelTitle
 *  @param commitTitle your custom commitTitle
 *  @param commitBlock commitBlock
 *  @param cancelBlock cancelBlock
 */
- (void)showMOFSAddressPickerWithDefaultAddress:(NSString *_Nullable)address title:(NSString *_Nullable)title cancelTitle:(NSString *_Nullable)cancelTitle commitTitle:(NSString *_Nullable)commitTitle commitBlock:(void(^_Nullable)(NSString * _Nullable address, NSString * _Nullable zipcode))commitBlock cancelBlock:(void(^_Nullable)(void))cancelBlock;

/**
 *  show addressPicker with your custom title, cancelTitle, commitTitle
 *
 *  @param zipcode     default zipcode
 *  @param title       your custom title
 *  @param cancelTitle your custom cancelTitle
 *  @param commitTitle your custom commitTitle
 *  @param commitBlock commitBlock
 *  @param cancelBlock cancelBlock
 */
- (void)showMOFSAddressPickerWithDefaultZipcode:(NSString *_Nullable)zipcode title:(NSString *_Nullable)title cancelTitle:(NSString *_Nullable)cancelTitle commitTitle:(NSString *_Nullable)commitTitle commitBlock:(void(^_Nullable)(NSString * _Nullable address, NSString * _Nullable zipcode))commitBlock cancelBlock:(void(^_Nullable)(void))cancelBlock;

/**
 *  searchAddressByZipcode
 *
 *  @param zipcode zipcode
 *  @param block block
 */
- (void)searchAddressByZipcode:(NSString *_Nullable)zipcode block:(void(^_Nullable)(NSString * _Nullable address))block;

/**
 *  searchZipCodeByAddress
 *
 *  @param address address
 *  @param block block
 */
- (void)searchZipCodeByAddress:(NSString *_Nullable)address block:(void(^_Nullable)(NSString * _Nullable zipcode))block;


/**
 *  searchIndexByAddress
 *
 *  @param address address
 *  @param block block
 */
- (void)searchIndexByAddress:(NSString *_Nullable)address block:(void(^_Nullable)(NSString * _Nullable address))block;


/**
 *  searchIndexByZipCode
 *
 *  @param zipcode address
 *  @param block block
 */
- (void)searchIndexByZipCode:(NSString *_Nullable)zipcode block:(void(^_Nullable)(NSString * _Nullable address))block;

@end
