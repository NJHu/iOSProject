//
//  AddressModel.m
//  MOFSPickerManager
//
//  Created by luoyuan on 16/8/31.
//  Copyright © 2016年 luoyuan. All rights reserved.
//

#import "AddressModel.h"
#import "GDataXMLNode.h"

@implementation AddressModel

- (NSMutableArray *)list {
    if (!_list) {
        _list = [NSMutableArray array];
    }
    return _list;
}

- (instancetype)initWithXML:(GDataXMLElement *)xml {
    self.name = [[xml attributeForName:@"name"] stringValue];
    if ([xml attributeForName:@"zipcode"]) {
        self.zipcode = [[xml attributeForName:@"zipcode"] stringValue];
    }
    @try {
        NSArray *arr = [xml nodesForXPath:@"city" error:nil];
        for (int i = 0 ; i < arr.count ; i++ ) {
            CityModel *model = [[CityModel alloc] initWithXML:arr[i]];
            model.index = [NSString stringWithFormat:@"%i",i];
            [self.list addObject:model];
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    return self;
}

@end

@implementation CityModel

- (NSMutableArray *)list {
    if (!_list) {
        _list = [NSMutableArray array];
    }
    return _list;
}

- (instancetype)initWithXML:(GDataXMLElement *)xml {
    self.name = [[xml attributeForName:@"name"] stringValue];
    if ([xml attributeForName:@"zipcode"]) {
        self.zipcode = [[xml attributeForName:@"zipcode"] stringValue];
    }
    @try {
        NSArray *arr = [xml nodesForXPath:@"district" error:nil];
        for (int i = 0 ; i < arr.count ; i++ ) {
            DistrictModel *model = [[DistrictModel alloc] initWithXML:arr[i]];
            model.index = [NSString stringWithFormat:@"%i",i];
            [self.list addObject:model];
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    return self;
}

@end

@implementation DistrictModel

- (instancetype)initWithXML:(GDataXMLElement *)xml {
    self.name = [[xml attributeForName:@"name"] stringValue];
    if ([xml attributeForName:@"zipcode"]) {
        self.zipcode = [[xml attributeForName:@"zipcode"] stringValue];
    }
    return self;
}

@end
