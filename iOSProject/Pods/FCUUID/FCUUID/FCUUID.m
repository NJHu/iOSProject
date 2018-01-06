//
//  FCUUID.m
//
//  Created by Fabio Caccamo on 26/06/14.
//  Copyright © 2016 Fabio Caccamo. All rights reserved.
//

#import "FCUUID.h"
#import "UICKeyChainStore.h"


@implementation FCUUID


NSString *const FCUUIDsOfUserDevicesDidChangeNotification = @"FCUUIDsOfUserDevicesDidChangeNotification";


NSString *const _uuidForInstallationKey = @"fc_uuidForInstallation";
NSString *const _uuidForDeviceKey = @"fc_uuidForDevice";
NSString *const _uuidsOfUserDevicesKey = @"fc_uuidsOfUserDevices";
NSString *const _uuidsOfUserDevicesToggleKey = @"fc_uuidsOfUserDevicesToggle";


+(FCUUID *)sharedInstance
{
    static FCUUID *instance = nil;
    static dispatch_once_t token;

    dispatch_once(&token, ^{
        instance = [[self alloc] init];
    });

    return instance;
}


-(instancetype)init
{
    self = [super init];

    if(self)
    {
        [self uuidsOfUserDevices_iCloudInit];
    }

    return self;
}


-(NSString *)_getOrCreateValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue userDefaults:(BOOL)userDefaults keychain:(BOOL)keychain service:(NSString *)service accessGroup:(NSString *)accessGroup synchronizable:(BOOL)synchronizable
{
    NSString *value = [self _getValueForKey:key userDefaults:userDefaults keychain:keychain service:service accessGroup:accessGroup];

    if(!value){
        value = defaultValue;
    }

    if(!value){
        value = [self uuid];
    }

    [self _setValue:value forKey:key userDefaults:userDefaults keychain:keychain service:service accessGroup:accessGroup synchronizable:synchronizable];

    return value;
}


-(NSString *)_getValueForKey:(NSString *)key userDefaults:(BOOL)userDefaults keychain:(BOOL)keychain service:(NSString *)service accessGroup:(NSString *)accessGroup
{
    NSString *value = nil;

    if(!value && keychain ){
        value = [UICKeyChainStore stringForKey:key service:service accessGroup:accessGroup];
    }

    if(!value && userDefaults ){
        value = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    }

    return value;
}


-(void)_setValue:(NSString *)value forKey:(NSString *)key userDefaults:(BOOL)userDefaults keychain:(BOOL)keychain service:(NSString *)service accessGroup:(NSString *)accessGroup synchronizable:(BOOL)synchronizable
{
    if( value && userDefaults ){
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    if( value && keychain ){
        UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:service accessGroup:accessGroup];
        [keychain setSynchronizable:synchronizable];
        [keychain setString:value forKey:key];
    }
}


-(NSString *)uuid
{
    //also known as uuid/universallyUniqueIdentifier

    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);

    NSString *uuidValue = (__bridge_transfer NSString *)uuidStringRef;
    uuidValue = [uuidValue lowercaseString];
    uuidValue = [uuidValue stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return uuidValue;
}


-(NSString *)uuidForKey:(id<NSCopying>)key
{
    if( _uuidForKey == nil ){
        _uuidForKey = [[NSMutableDictionary alloc] init];
    }

    NSString *uuidValue = [_uuidForKey objectForKey:key];

    if( uuidValue == nil ){
        uuidValue = [self uuid];

        [_uuidForKey setObject:uuidValue forKey:key];
    }

    return uuidValue;
}


-(NSString *)uuidForSession
{
    if( _uuidForSession == nil ){
        _uuidForSession = [self uuid];
    }

    return _uuidForSession;
}


-(NSString *)uuidForInstallation
{
    if( _uuidForInstallation == nil ){
        _uuidForInstallation = [self _getOrCreateValueForKey:_uuidForInstallationKey defaultValue:nil userDefaults:YES keychain:NO service:nil accessGroup:nil synchronizable:NO];
    }

    return _uuidForInstallation;
}


-(NSString *)uuidForVendor
{
    if( _uuidForVendor == nil ){
        _uuidForVendor = [[[[[UIDevice currentDevice] identifierForVendor] UUIDString] lowercaseString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }

    return _uuidForVendor;
}


-(void)uuidForDevice_updateWithValue:(NSString *)value
{
    _uuidForDevice = [NSString stringWithString:value];
    [self _setValue:_uuidForDevice forKey:_uuidForDeviceKey userDefaults:YES keychain:YES service:nil accessGroup:nil synchronizable:NO];
}


-(NSString *)uuidForDevice
{
    //also known as udid/uniqueDeviceIdentifier but this doesn't persists to system reset

    if( _uuidForDevice == nil ){
        _uuidForDevice = [self _getOrCreateValueForKey:_uuidForDeviceKey defaultValue:nil userDefaults:YES keychain:YES service:nil accessGroup:nil synchronizable:NO];
    }

    return _uuidForDevice;
}


-(NSString *)uuidForDeviceMigratingValue:(NSString *)value commitMigration:(BOOL)commitMigration
{
    if([self uuidValueIsValid:value])
    {
        NSString *oldValue = [self uuidForDevice];
        NSString *newValue = [NSString stringWithString:value];

        if([oldValue isEqualToString:newValue])
        {
            return oldValue;
        }

        if(commitMigration)
        {
            [self uuidForDevice_updateWithValue:newValue];

            NSMutableOrderedSet *uuidsOfUserDevicesSet = [[NSMutableOrderedSet alloc] initWithArray:[self uuidsOfUserDevices]];
            [uuidsOfUserDevicesSet addObject:newValue];
            [uuidsOfUserDevicesSet removeObject:oldValue];

            [self uuidsOfUserDevices_updateWithValue:[uuidsOfUserDevicesSet array]];
            [self uuidsOfUserDevices_iCloudSync];

            return [self uuidForDevice];
        }
        else {
            return oldValue;
        }
    }
    else {
        [NSException raise:@"Invalid uuid to migrate" format:@"uuid value should be a string of 32 or 36 characters."];

        return nil;
    }
}


-(NSString *)uuidForDeviceMigratingValueForKey:(NSString *)key commitMigration:(BOOL)commitMigration
{
    return [self uuidForDeviceMigratingValueForKey:key service:nil accessGroup:nil commitMigration:commitMigration];
}


-(NSString *)uuidForDeviceMigratingValueForKey:(NSString *)key service:(NSString *)service commitMigration:(BOOL)commitMigration
{
    return [self uuidForDeviceMigratingValueForKey:key service:service accessGroup:nil commitMigration:commitMigration];
}


-(NSString *)uuidForDeviceMigratingValueForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup commitMigration:(BOOL)commitMigration
{
    NSString *uuidToMigrate = [self _getValueForKey:key userDefaults:YES keychain:YES service:service accessGroup:accessGroup];

    return [self uuidForDeviceMigratingValue:uuidToMigrate commitMigration:commitMigration];
}


-(void)uuidsOfUserDevices_iCloudInit
{
    _uuidsOfUserDevices_iCloudAvailable = NO;

    if(NSClassFromString(@"NSUbiquitousKeyValueStore"))
    {
        NSUbiquitousKeyValueStore *iCloud = [NSUbiquitousKeyValueStore defaultStore];

        if(iCloud)
        {
            _uuidsOfUserDevices_iCloudAvailable = YES;

            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uuidsOfUserDevices_iCloudChange:) name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification object:nil];

            [self uuidsOfUserDevices_iCloudSync];
        }
        else {
            //NSLog(@"iCloud not available");
        }
    }
    else {
        //NSLog(@"iOS < 5");
    }
}


-(void)uuidsOfUserDevices_iCloudSync
{
    if( _uuidsOfUserDevices_iCloudAvailable )
    {
        NSUbiquitousKeyValueStore *iCloud = [NSUbiquitousKeyValueStore defaultStore];

        //if keychain contains more device identifiers than icloud, maybe that icloud has been empty, so re-write these identifiers to iCloud
        for ( NSString *uuidOfUserDevice in [self uuidsOfUserDevices] )
        {
            NSString *uuidOfUserDeviceAsKey = [NSString stringWithFormat:@"%@_%@", _uuidForDeviceKey, uuidOfUserDevice];

            if(![[iCloud stringForKey:uuidOfUserDeviceAsKey] isEqualToString:uuidOfUserDevice]){
                [iCloud setString:uuidOfUserDevice forKey:uuidOfUserDeviceAsKey];
            }
        }

        //toggle a boolean value to force notification on other devices, useful for debug
        [iCloud setBool:![iCloud boolForKey:_uuidsOfUserDevicesToggleKey] forKey:_uuidsOfUserDevicesToggleKey];
        [iCloud synchronize];
    }
}


-(void)uuidsOfUserDevices_iCloudChange:(NSNotification *)notification
{
    if( _uuidsOfUserDevices_iCloudAvailable )
    {
        NSMutableOrderedSet *uuidsSet = [[NSMutableOrderedSet alloc] initWithArray:[self uuidsOfUserDevices]];
        NSInteger uuidsCount = [uuidsSet count];

        NSUbiquitousKeyValueStore *iCloud = [NSUbiquitousKeyValueStore defaultStore];
        NSDictionary *iCloudDict = [iCloud dictionaryRepresentation];

        //NSLog(@"uuidsOfUserDevicesSync: %@", iCloudDict);

        [iCloudDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {

            NSString *uuidKey = (NSString *)key;

            if([uuidKey rangeOfString:_uuidForDeviceKey].location == 0)
            {
                if([obj isKindOfClass:[NSString class]])
                {
                    NSString *uuidValue = (NSString *)obj;

                    if([uuidKey rangeOfString:uuidValue].location != NSNotFound && [self uuidValueIsValid:uuidValue])
                    {
                        //NSLog(@"uuid: %@", uuidValue);

                        [uuidsSet addObject:uuidValue];
                    }
                    else {
                        //NSLog(@"invalid uuid");
                    }
                }
            }
        }];

        if([uuidsSet count] > uuidsCount)
        {
            [self uuidsOfUserDevices_updateWithValue:[uuidsSet array]];

            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[self uuidsOfUserDevices] forKey:@"uuidsOfUserDevices"];
            [[NSNotificationCenter defaultCenter] postNotificationName:FCUUIDsOfUserDevicesDidChangeNotification object:self userInfo:userInfo];
        }
    }
}


-(void)uuidsOfUserDevices_updateWithValue:(NSArray *)value
{
    _uuidsOfUserDevices = [value componentsJoinedByString:@"|"];
    [self _setValue:_uuidsOfUserDevices forKey:_uuidsOfUserDevicesKey userDefaults:YES keychain:YES service:nil accessGroup:nil synchronizable:YES];
}


-(NSArray *)uuidsOfUserDevices
{
    if( _uuidsOfUserDevices == nil ){
        _uuidsOfUserDevices = [self _getOrCreateValueForKey:_uuidsOfUserDevicesKey defaultValue:[self uuidForDevice] userDefaults:YES keychain:YES service:nil accessGroup:nil synchronizable:YES];
    }

    return [_uuidsOfUserDevices componentsSeparatedByString:@"|"];
}


-(NSArray *)uuidsOfUserDevicesExcludingCurrentDevice
{
    NSMutableArray *uuids = [NSMutableArray arrayWithArray:[self uuidsOfUserDevices]];
    [uuids removeObject:[self uuidForDevice]];
    return [NSArray arrayWithArray:uuids];
}


-(BOOL)uuidValueIsValid:(NSString *)uuidValue
{
    if(uuidValue != nil)
    {
        NSString *uuidPattern = @"^[0-9a-f]{32}|[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}$";
        NSRegularExpression *uuidRegExp = [NSRegularExpression regularExpressionWithPattern:uuidPattern options:NSRegularExpressionCaseInsensitive error:nil];

        NSRange uuidValueRange = NSMakeRange(0, [uuidValue length]);
        NSRange uuidMatchRange = [uuidRegExp rangeOfFirstMatchInString:uuidValue options:0 range:uuidValueRange];
        NSString *uuidMatchValue;

        if(!NSEqualRanges(uuidMatchRange, NSMakeRange(NSNotFound, 0)))
        {
            uuidMatchValue = [uuidValue substringWithRange:uuidMatchRange];

            if([uuidMatchValue isEqualToString:uuidValue])
            {
                return YES;
            }
            else {
                return NO;
            }
        }
        else {
            return NO;
        }
    }
    else {
        return NO;
    }
}


+(NSString *)uuid
{
    return [[self sharedInstance] uuid];
}


+(NSString *)uuidForKey:(id<NSCopying>)key
{
    return [[self sharedInstance] uuidForKey:key];
}


+(NSString *)uuidForSession
{
    return [[self sharedInstance] uuidForSession];
}


+(NSString *)uuidForInstallation
{
    return [[self sharedInstance] uuidForInstallation];
}


+(NSString *)uuidForVendor
{
    return [[self sharedInstance] uuidForVendor];
}


+(NSString *)uuidForDevice
{
    return [[self sharedInstance] uuidForDevice];
}


+(NSString *)uuidForDeviceMigratingValue:(NSString *)value commitMigration:(BOOL)commitMigration
{
    return [[self sharedInstance] uuidForDeviceMigratingValue:value commitMigration:commitMigration];
}


+(NSString *)uuidForDeviceMigratingValueForKey:(NSString *)key commitMigration:(BOOL)commitMigration
{
    return [[self sharedInstance] uuidForDeviceMigratingValueForKey:key service:nil accessGroup:nil commitMigration:commitMigration];
}


+(NSString *)uuidForDeviceMigratingValueForKey:(NSString *)key service:(NSString *)service commitMigration:(BOOL)commitMigration
{
    return [[self sharedInstance] uuidForDeviceMigratingValueForKey:key service:service accessGroup:nil commitMigration:commitMigration];
}


+(NSString *)uuidForDeviceMigratingValueForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup commitMigration:(BOOL)commitMigration
{
    return [[self sharedInstance] uuidForDeviceMigratingValueForKey:key service:service accessGroup:accessGroup commitMigration:commitMigration];
}


+(NSArray *)uuidsOfUserDevices
{
    return [[self sharedInstance] uuidsOfUserDevices];
}


+(NSArray *)uuidsOfUserDevicesExcludingCurrentDevice
{
    return [[self sharedInstance] uuidsOfUserDevicesExcludingCurrentDevice];
}


+(BOOL)uuidValueIsValid:(NSString *)uuidValue
{
    return [[self sharedInstance] uuidValueIsValid:uuidValue];
}


@end