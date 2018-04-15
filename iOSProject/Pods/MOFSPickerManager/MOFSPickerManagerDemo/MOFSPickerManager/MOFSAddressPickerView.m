//
//  MOFSAddressPickerView.m
//  MOFSPickerManager
//
//  Created by luoyuan on 16/8/31.
//  Copyright © 2016年 luoyuan. All rights reserved.
//

#import "MOFSAddressPickerView.h"

#define UISCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define UISCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface MOFSAddressPickerView() <UIPickerViewDelegate, UIPickerViewDataSource, NSXMLParserDelegate>

@property (nonatomic, strong) NSXMLParser *parser;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) NSMutableArray<AddressModel *> *dataArr;

@property (nonatomic, assign) NSInteger selectedIndex_province;
@property (nonatomic, assign) NSInteger selectedIndex_city;
@property (nonatomic, assign) NSInteger selectedIndex_area;

@property (nonatomic, assign) BOOL isGettingData;
@property (nonatomic, strong) void (^getDataCompleteBlock)(void);

@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (nonatomic, assign) BOOL isSection; //0 < numberOfSection <= 3

@end

@implementation MOFSAddressPickerView

#pragma mark - setter

- (void)setNumberOfSection:(NSInteger)numberOfSection {
    if (numberOfSection <= 0 || numberOfSection > 3) {
        _numberOfSection = 3;
    } else {
        _numberOfSection = numberOfSection;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadAllComponents];
    });
}

#pragma mark - create UI

- (instancetype)initWithFrame:(CGRect)frame {
    
    self.semaphore = dispatch_semaphore_create(1);
    
    [self initToolBar];
    [self initContainerView];
    
    CGRect initialFrame;
    if (CGRectIsEmpty(frame)) {
        initialFrame = CGRectMake(0, self.toolBar.frame.size.height, UISCREEN_WIDTH, 216);
    } else {
        initialFrame = frame;
    }
    self = [super initWithFrame:initialFrame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.delegate = self;
        self.dataSource = self;
        
        [self initBgView];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [self getData];
            dispatch_queue_t queue = dispatch_queue_create("my.current.queue", DISPATCH_QUEUE_CONCURRENT);
            dispatch_barrier_async(queue, ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self reloadAllComponents];
                });
            });
        });
    }
    return self;
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated {
    if (component >= self.numberOfComponents) {
        return;
    }
    [super selectRow:row inComponent:component animated:animated];
    switch (component) {
        case 0:
            self.selectedIndex_province = row;
            self.selectedIndex_city = 0;
            self.selectedIndex_area = 0;
            if (self.numberOfSection > 1) {
                [self reloadComponent:1];
            }
            if (self.numberOfSection > 2) {
                [self reloadComponent:2];
            }
            break;
        case 1:
            self.selectedIndex_city = row;
            self.selectedIndex_area = 0;
            if (self.numberOfSection > 2) {
                [self reloadComponent:2];
            }
            break;
        case 2:
            self.selectedIndex_area = row;
            break;
        default:
            break;
    }
}

- (void)initToolBar {
    self.toolBar = [[MOFSToolView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 44)];
    self.toolBar.backgroundColor = [UIColor whiteColor];
}

- (void)initContainerView {
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT)];
    self.containerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.containerView.userInteractionEnabled = YES;
    [self.containerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenWithAnimation)]];
}

- (void)initBgView {
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, UISCREEN_HEIGHT - self.frame.size.height - 44, UISCREEN_WIDTH, self.frame.size.height + self.toolBar.frame.size.height)];
}

#pragma mark - Action

- (void)showMOFSAddressPickerCommitBlock:(void(^)(NSString *address, NSString *zipcode))commitBlock cancelBlock:(void(^)(void))cancelBlock {
    if (self.numberOfSection <= 0 || self.numberOfComponents > 3) {
        self.numberOfSection = 3;
    }
    [self showWithAnimation];
    
    __weak typeof(self) weakSelf = self;
    self.toolBar.cancelBlock = ^ {
        if (cancelBlock) {
            [weakSelf hiddenWithAnimation];
            cancelBlock();
        }
    };
    
    self.toolBar.commitBlock = ^ {
        if (commitBlock) {
            [weakSelf hiddenWithAnimation];
            if (weakSelf.dataArr.count > 0) {
               AddressModel *addressModel = weakSelf.dataArr[weakSelf.selectedIndex_province];
                CityModel *cityModel;
                DistrictModel *districtModel;
                if (addressModel.list.count > 0) {
                    cityModel = addressModel.list[weakSelf.selectedIndex_city];
                }
                if (cityModel && cityModel.list.count > 0) {
                    districtModel = cityModel.list[weakSelf.selectedIndex_area];
                }
                
                NSString *address;
                NSString *zipcode;
                if (!cityModel || weakSelf.numberOfComponents == 1) {
                    address = [NSString stringWithFormat:@"%@",addressModel.name];
                    zipcode = [NSString stringWithFormat:@"%@",addressModel.zipcode];
                } else {
                    if (!districtModel || weakSelf.numberOfComponents == 2) {
                        address = [NSString stringWithFormat:@"%@-%@",addressModel.name,cityModel.name];
                        zipcode = [NSString stringWithFormat:@"%@-%@",addressModel.zipcode,cityModel.zipcode];
                    } else {
                        address = [NSString stringWithFormat:@"%@-%@-%@",addressModel.name,cityModel.name,districtModel.name];
                        zipcode = [NSString stringWithFormat:@"%@-%@-%@",addressModel.zipcode,cityModel.zipcode,districtModel.zipcode];
                    }
                }
                
                
                commitBlock(address, zipcode);
            }
        }
    };
}

- (void)showWithAnimation {
    [self addViews];
    self.containerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    CGFloat height = self.bgView.frame.size.height;
    self.bgView.center = CGPointMake(UISCREEN_WIDTH / 2, UISCREEN_HEIGHT + height / 2);
    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.center = CGPointMake(UISCREEN_WIDTH / 2, UISCREEN_HEIGHT - height / 2);
        self.containerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    }];
    
}

- (void)hiddenWithAnimation {
    CGFloat height = self.bgView.frame.size.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.center = CGPointMake(UISCREEN_WIDTH / 2, UISCREEN_HEIGHT + height / 2);
        self.containerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    } completion:^(BOOL finished) {
        [self hiddenViews];
    }];
}

- (void)addViews {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.containerView];
    [window addSubview:self.bgView];
    [self.bgView addSubview:self.toolBar];
    [self.bgView addSubview:self];
}

- (void)hiddenViews {
    [self removeFromSuperview];
    [self.toolBar removeFromSuperview];
    [self.bgView removeFromSuperview];
    [self.containerView removeFromSuperview];
}

#pragma mark - get data

- (void)getData {
    self.isGettingData = YES;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"province_data" ofType:@"xml"];
    if (path == nil) {
        for (NSBundle *bundle in [NSBundle allFrameworks]) {
            path = [bundle pathForResource:@"province_data" ofType:@"xml"];
            if (path != nil) {
                break;
            }
        }
    }
    
    if (path == nil) {
        self.isGettingData = NO;
        if (self.getDataCompleteBlock) {
            self.getDataCompleteBlock();
        }
        return;
    }
    
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    if (_dataArr.count != 0) {
        [_dataArr removeAllObjects];
    }
    
    self.parser = [[NSXMLParser alloc] initWithData:[NSData dataWithContentsOfFile:path]];
    self.parser.delegate = self;
    [self.parser parse];
    
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    if ([elementName isEqualToString:@"province"]) {
        AddressModel *model = [[AddressModel alloc] initWithDictionary:attributeDict];
        model.index = [NSString stringWithFormat:@"%lu", (unsigned long)self.dataArr.count];
        [self.dataArr addObject:model];
    } else if ([elementName isEqualToString:@"city"]) {
        CityModel *model = [[CityModel alloc] initWithDictionary:attributeDict];
        model.index = [NSString stringWithFormat:@"%lu", (unsigned long)self.dataArr.lastObject.list.count];
        [self.dataArr.lastObject.list addObject:model];
    } else if ([elementName isEqualToString:@"district"]) {
        DistrictModel *model = [[DistrictModel alloc] initWithDictionary:attributeDict];
        model.index = [NSString stringWithFormat:@"%lu", (unsigned long)self.dataArr.lastObject.list.lastObject.list.count];
        [self.dataArr.lastObject.list.lastObject.list addObject: model];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    self.isGettingData = NO;
    if (self.getDataCompleteBlock) {
        self.getDataCompleteBlock();
    }
}

#pragma mark - search

- (void)searchType:(SearchType)searchType key:(NSString *)key block:(void(^)(NSString *result))block {
    
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    
    NSString *valueName = @"";
    NSString *type = @"";
    
    if (searchType == SearchTypeAddressIndex) {
        valueName = @"index";
        type = @"name";
    } else if (searchType == SearchTypeZipcodeIndex) {
        valueName = @"index";
        type = @"zipcode";
    } else {
        valueName = searchType == SearchTypeAddress ? @"name" : @"zipcode";
        type = searchType == SearchTypeAddress ? @"zipcode" : @"name";
    }
    
    if (self.isGettingData || !self.dataArr || self.dataArr.count == 0) {
        __weak typeof(self) weakSelf = self;
        self.getDataCompleteBlock = ^{
            if (block) {
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    block([weakSelf searchByKey:key valueName:valueName type:type]);
                });
                
                dispatch_semaphore_signal(weakSelf.semaphore);
            }
        };
    } else {
        if (block) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                block([self searchByKey:key valueName:valueName type:type]);
            });
            dispatch_semaphore_signal(self.semaphore);
        }
    }

}


- (NSString *)searchByKey:(NSString *)key valueName:(NSString *)valueName type:(NSString *)type {
    
    if ([key isEqualToString:@""] || !key) {
        return @"";
    }
    
    NSArray *arr = [key componentsSeparatedByString:@"-"];
    if (arr.count > 3) {
        return @"error0"; //最多只能输入省市区三个部分
    }
    AddressModel *addressModel = (AddressModel *)[self searchModelInArr:_dataArr key:arr[0] type:type];
    if (addressModel) {
        if (arr.count == 1) { //只输入了省份
            return [addressModel valueForKey:valueName];
        }
        CityModel *cityModel = (CityModel *)[self searchModelInArr:addressModel.list key:arr[1] type:type];
        if (cityModel) {
            if (arr.count == 2) { //只输入了省份+城市
                return [NSString stringWithFormat:@"%@-%@",[addressModel valueForKey:valueName],[cityModel valueForKey:valueName]];
            }
            DistrictModel *districtModel = (DistrictModel *)[self searchModelInArr:cityModel.list key:arr[2] type:type];
            if (districtModel) {
                return [NSString stringWithFormat:@"%@-%@-%@",[addressModel valueForKey:valueName],[cityModel valueForKey:valueName],[districtModel valueForKey:valueName]];
            } else {
                return @"error3"; //输入区错误
            }
        } else {
            return @"error2"; //输入城市错误
        }
    } else {
        return @"error1"; //输入省份错误
    }


}

- (NSObject *)searchModelInArr:(NSArray *)arr key:(NSString *)key type:(NSString *)type {
    
    NSObject *object;
    
    for (NSObject *obj in arr) {
        if ([key isEqualToString:[obj valueForKey:type]]) {
            object = obj;
            break;
        }
    }
    
    return object;
}


#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.numberOfSection;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
     AddressModel *addressModel;
    if (self.dataArr.count > 0) {
        addressModel = self.dataArr[self.selectedIndex_province];
    }
   
    CityModel *cityModel;
    if (addressModel && addressModel.list.count > 0) {
        cityModel = addressModel.list[self.selectedIndex_city];
    }
    if (self.dataArr.count != 0) {
        if (component == 0) {
            return self.dataArr.count;
        } else if (component == 1) {
            return addressModel == nil ? 0 : addressModel.list.count;
        } else if (component == 2) {
            return cityModel == nil ? 0 : cityModel.list.count;
        } else {
            return 0;
        }
    } else {
        return 0;
    }

}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (component == 0) {
        AddressModel *addressModel = self.dataArr[row];
        return addressModel.name;
    } else if (component == 1) {
        AddressModel *addressModel = self.dataArr[self.selectedIndex_province];
        CityModel *cityModel = addressModel.list[row];
        return cityModel.name;
    } else if (component == 2) {
        AddressModel *addressModel = self.dataArr[self.selectedIndex_province];
        CityModel *cityModel = addressModel.list[self.selectedIndex_city];
        DistrictModel *districtModel = cityModel.list[row];
        return districtModel.name;
    } else {
        return nil;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:
            self.selectedIndex_province = row;
            self.selectedIndex_city = 0;
            self.selectedIndex_area = 0;
            if (self.numberOfSection > 1) {
                [pickerView reloadComponent:1];
                [pickerView selectRow:0 inComponent:1 animated:NO];
            }
            if (self.numberOfSection > 2) {
                [pickerView reloadComponent:2];
                [pickerView selectRow:0 inComponent:2 animated:NO];
            }
            break;
        case 1:
            self.selectedIndex_city = row;
            self.selectedIndex_area = 0;
            if (self.numberOfSection > 2) {
                [pickerView reloadComponent:2];
                [pickerView selectRow:0 inComponent:2 animated:NO];
            }
            break;
        case 2:
            self.selectedIndex_area = row;
            break;
        default:
            break;
    }
}

- (void)dealloc {
   
}

@end
