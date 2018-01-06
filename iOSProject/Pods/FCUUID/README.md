FCUUID ![Pod version](http://img.shields.io/cocoapods/v/FCUUID.svg) ![Pod platforms](http://img.shields.io/cocoapods/p/FCUUID.svg) ![Pod license](http://img.shields.io/cocoapods/l/FCUUID.svg)
===================
iOS **UUID** library as alternative to the old good **UDID** and **identifierForVendor**.  
This library provides the simplest API to obtain **universally unique identifiers with different levels of [persistence](#persistence)**.  

It's possible to retrieve the **UUIDs created for all devices of the same user**, in this way with a little bit of server-side help **it's possible manage guest accounts across multiple devices easily.**

##Requirements & dependencies
- iOS >= 5.0
- ARC enabled
- Key-value storage enabled *(target / Capabilities / iCloud / Key-value storage)*
- Security.framework
- [UICKeyChainStore](https://github.com/kishikawakatsumi/UICKeyChainStore)
- ***(optional)*** - Key-value storage enabled -> Target / Capabilities / iCloud / Key-value storage enabled if you want to **share** `uuidsOfUserDevices` values **across multiple devices using the same iCloud account**.
- ***(optional)*** - KeyChain sharing enabled (entitlements and provisioning profile) if you need to **share** the same `uuidForDevice` / `uuidsOfUserDevices` values **across multiple apps with the same bundle seed**.

##Installation

####CocoaPods:
`pod 'FCUUID'`

####Manual install:
- Copy `FCUUID` folder to your project.
- Manual install [UICKeyChainStore](https://github.com/kishikawakatsumi/UICKeyChainStore)

###Optional setup:
It is recommended to do the setup in `applicationDidFinishLaunchingWithOptions` method.
- Add an observer to the `FCUUIDsOfUserDevicesDidChangeNotification` to be notified about uuids of user devices changes.
- If necessary, **migrate from a previously used UUID or UDID** using one of the migrations methods listed in the API section (it's recommended to do migration before calling `uuidForDevice` or `uuidsForUserDevices` methods). Keep in mind that **migration works only if the existing value is a valid uuid and `uuidForDevice` has not been created yet**.
- Call any class method to enforce iCloud sync.

##API
**Get different UUIDs** (each one with its own persistency level) 

```objective-c
//changes each time (no persistent)
+(NSString *)uuid;

//changes each time (no persistent), but allows to keep in memory more temporary uuids
+(NSString *)uuidForKey:(id<NSCopying>)key;

//changes each time the app gets launched (persistent to session)
+(NSString *)uuidForSession;

//changes each time the app gets installed (persistent to installation)
+(NSString *)uuidForInstallation;

//changes each time all the apps of the same vendor are uninstalled (this works exactly as identifierForVendor)
+(NSString *)uuidForVendor;

//changes only on system reset, this is the best replacement to the good old udid (persistent to device)
+(NSString *)uuidForDevice;
//or
#import "UIDevice+FCUUID.h"
[[UIDevice currentDevice] uuid];
```
**Get the list of UUIDs of user devices**
```objective-c
//returns the list of all uuidForDevice of the same user, in this way it's possible manage guest accounts across multiple devices easily
+(NSArray *)uuidsOfUserDevices;
```
**Migrate from a previously stored UUID / UDID**  
Before migrating an existing value it's recommended to **debug it** by simply passing `commitMigration:NO` and logging the returned value.  
When you will be ready for committing the migration, use `commitMigration:YES`.  
After the migration, any future call to `uuidForDevice` will return the migrated value.
```objective-c
//these methods search for an existing UUID / UDID stored in the KeyChain or in UserDefaults for the given key / service / access-group
+(NSString *)uuidForDeviceMigratingValue:(NSString *)value commitMigration:(BOOL)commitMigration;
+(NSString *)uuidForDeviceMigratingValueForKey:(NSString *)key commitMigration:(BOOL)commitMigration;
+(NSString *)uuidForDeviceMigratingValueForKey:(NSString *)key service:(NSString *)service commitMigration:(BOOL)commitMigration;
+(NSString *)uuidForDeviceMigratingValueForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup commitMigration:(BOOL)commitMigration;
```
**Check if value is a valid UUID**
```objective-c
+(BOOL)uuidValueIsValid:(NSString *)uuidValue;
```

##Persistence 
- **`√`** *yes* 
- `-` *no* 
- **`*`** *read notes below* 

| PERSISTS              | App memory | App relaunch | Reset Advertising Identifier | App reinstall | System reboot | System upgrade | System reset |
|-----------------------|:----------:|:------------:|:----------------------------:|:-------------:|:-------------:|:--------------:|:------------:|
| `uuid`                |      -     |       -      |               -              |       -       |       -       |        -       |       -      |
| `uuidForKey:key`      |    **√**   |       -      |               -              |       -       |       -       |        -       |       -      |
| `uuidForSession`      |    **√**   |       -      |               -              |       -       |       -       |        -       |       -      |
| `uuidForInstallation` |    **√**   |     **√**    |             **√**            |       -       |     **√**     |        -       |       -      |
| `uuidForVendor`       |    **√**   |     **√**    |               -              |     **√***    |     **√**     |        -       |       -      |
| `uuidForDevice`       |    **√**   |     **√**    |             **√**            |     **√**     |     **√**     |      **√**     |    **√****   |

**(persists only if the user have not uninstalled all apps of the same vendor)*

***(persists only if the user restores a device backup which includes also keychain's data)*

##FAQ
####How can I share the device uuid between two apps?
You must have **KeyChain sharing enabled** (entitlements and provisioning profile) and your apps identifiers must have the same bundle seed.

####What happens if I call `uuidForDevice` on 2 different devices using same iCloud account and iCloud Keychain?
You will obtain 2 **different uuid(s)**, and if you call `uuidsOfUserDevices` you will obtain a list containing the uuids of both devices.

####When I reboot / upgrade / reset my device system, will device uuid change?
Please check the **persistence** table above.

##Support development

[![Donate](https://pledgie.com/campaigns/32215.png?skin_name=chrome "Click here to lend your support to: Fabio Caccamo - Open Source Projects and make a donation at pledgie.com !")](https://pledgie.com/campaigns/32215)

[![Donate](https://www.paypalobjects.com/webstatic/en_US/btn/btn_donate_pp_142x27.png)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=fabio%2ecaccamo%40gmail%2ecom&lc=IT&item_name=Fabio%20Caccamo%20%2d%20Open%20Source%20Projects&item_number=FCUUID&currency_code=EUR&bn=PP%2dDonationsBF%3abtn_donate_LG%2egif%3aNonHosted)

##License
Released under [MIT License](LICENSE).
