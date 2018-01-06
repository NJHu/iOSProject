# UICKeyChainStore
[![CI Status](http://img.shields.io/travis/kishikawakatsumi/UICKeyChainStore.svg?style=flat)](https://travis-ci.org/kishikawakatsumi/UICKeyChainStore)
[![Coverage Status](https://img.shields.io/coveralls/kishikawakatsumi/UICKeyChainStore.svg?style=flat)](https://coveralls.io/r/kishikawakatsumi/UICKeyChainStore?branch=master)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Version](https://img.shields.io/cocoapods/v/UICKeyChainStore.svg?style=flat)](http://cocoadocs.org/docsets/UICKeyChainStore)
[![License](https://img.shields.io/cocoapods/l/UICKeyChainStore.svg?style=flat)](http://cocoadocs.org/docsets/UICKeyChainStore)
[![Platform](https://img.shields.io/cocoapods/p/UICKeyChainStore.svg?style=flat)](http://cocoadocs.org/docsets/UICKeyChainStore)

UICKeyChainStore is a simple wrapper for Keychain that works on iOS and OS X. Makes using Keychain APIs as easy as NSUserDefaults.

## Looking for the library written in Swift?

Try [KeychainAccess](https://github.com/kishikawakatsumi/KeychainAccess).  
[KeychainAccess](https://github.com/kishikawakatsumi/KeychainAccess) is next generation of UICKeyChainStore.

## Transitioning from 1.x to 2.0

**`synchronize` method is deprecated. Calling this method is no longer required (Just ignored).**

## Features

- Simple interface
- Support access group
- [Support accessibility](#accessibility)
- [Support iCloud sharing](#icloud_sharing)
- **[Support TouchID and Keychain integration (iOS 8+)](#touch_id_integration)**
- **[Support Shared Web Credentials (iOS 8+)](#shared_web_credentials)**
- Works on both iOS & OS X
- Supported watchOS 2

## Usage

### Basics

#### Saving Application Password

```objective-c
UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.example.github-token"];
keychain[@"kishikawakatsumi"] = @"01234567-89ab-cdef-0123-456789abcdef";
```

#### Saving Internet Password

```objective-c
UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithServer:[NSURL URLWithString:@"https://github.com"]
                                                          protocolType:UICKeyChainStoreProtocolTypeHTTPS];
keychain[@"kishikawakatsumi"] = @"01234567-89ab-cdef-0123-456789abcdef";
```

### Instantiation

#### Create Keychain for Application Password

```objective-c
UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.example.github-token"];
```

```objective-c
UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"kishikawakatsumi.git"
                                                            accessGroup:@"12ABCD3E4F.shared"];
```

#### Create Keychain for Internet Password

```objective-c
UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithServer:[NSURL URLWithString:@"https://github.com"]
                                                          protocolType:UICKeyChainStoreProtocolTypeHTTPS];
```

```objective-c
UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithServer:[NSURL URLWithString:@"https://github.com"]
                                                          protocolType:UICKeyChainStoreProtocolTypeHTTPS
                                                    authenticationType:UICKeyChainStoreAuthenticationTypeHTMLForm];
```

### Adding an item

#### subscripting

```objective-c
keychain[@"kishikawakatsumi"] = @"01234567-89ab-cdef-0123-456789abcdef"
```

#### set method

```objective-c
[keychain setString:@"01234567-89ab-cdef-0123-456789abcdef" forKey:@"kishikawakatsumi"];
```

#### error handling

```objective-c
if (![keychain setString:@"01234567-89ab-cdef-0123-456789abcdef" forKey:@"kishikawakatsumi"]) {
    // error has occurred
}
```

```objective-c
NSError *error;
[keychain setString:@"01234567-89ab-cdef-0123-456789abcdef" forKey:@"kishikawakatsumi" error:&error];
if (error) {
    NSLog(@"%@", error.localizedDescription);
}
```

### Obtaining an item

#### subscripting (automatically converts to string)

```objective-c
NSString *token = keychain[@"kishikawakatsumi"]
```

#### get methods

##### as String

```objective-c
NSString *token = [keychain stringForKey:@"kishikawakatsumi"];
```

##### as NSData

```objective-c
NSData *data = [keychain dataForKey:@"kishikawakatsumi"];
```

#### error handling

**First, get the `failable` (value or error) object**

```objective-c
NSError *error;
NSString *token = [keychain stringForKey:@"" error:&error];
if (error) {
    NSLog(@"%@", error.localizedDescription);
}
```

### Removing an item

#### subscripting

```objective-c
keychain[@"kishikawakatsumi"] = nil
```

#### remove method

```objective-c
[keychain removeItemForKey:@"kishikawakatsumi"];
```

#### error handling

```objective-c
if (![keychain removeItemForKey:@"kishikawakatsumi"]) {
    // error has occurred
}
```

```objective-c
NSError *error;
[keychain removeItemForKey:@"kishikawakatsumi" error:&error];
if (error) {
    NSLog(@"%@", error.localizedDescription);
}
```

### Label and Comment

```objective-c
UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithServer:[NSURL URLWithString:@"https://github.com"]
                                                          protocolType:UICKeyChainStoreProtocolTypeHTTPS];
[keychain setString:@"01234567-89ab-cdef-0123-456789abcdef"
             forKey:@"kishikawakatsumi"
              label:@"github.com (kishikawakatsumi)"
            comment:@"github access token"];
```

### Configuration (Accessibility, Sharing, iCould Sync)

#### <a name="accessibility"> Accessibility

##### Default accessibility matches background application (=kSecAttrAccessibleAfterFirstUnlock)

```objective-c
UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.example.github-token"];
```

##### For background application

###### Creating instance

```objective-c
UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.example.github-token"];
keychain.accessibility = UICKeyChainStoreAccessibilityAfterFirstUnlock;

keychain[@"kishikawakatsumi"] = @"01234567-89ab-cdef-0123-456789abcdef"
```

##### For foreground application

###### Creating instance

```objective-c
UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.example.github-token"];
keychain.accessibility = UICKeyChainStoreAccessibilityWhenUnlocked;

keychain[@"kishikawakatsumi"] = @"01234567-89ab-cdef-0123-456789abcdef"
```

#### Sharing Keychain items

```objective-c
UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"kishikawakatsumi.git"
                                                            accessGroup:@"12ABCD3E4F.shared"];
```

#### <a name="icloud_sharing"> Synchronizing Keychain items with iCloud

###### Creating instance

```objective-c
UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.example.github-token"];
keychain.synchronizable = YES;

keychain[@"kishikawakatsumi"] = @"01234567-89ab-cdef-0123-456789abcdef"
```

### <a name="touch_id_integration"> Touch ID integration

**Any Operation that require authentication must be run in the background thread.**  
**If you run in the main thread, UI thread will lock for the system to try to display the authentication dialog.**

#### Adding a Touch ID protected item

If you want to store the Touch ID protected Keychain item, specify `accessibility` and `authenticationPolicy` attributes.  

```objective-c
UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.example.github-token"];

dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    [keychain setAccessibility:UICKeyChainStoreAccessibilityWhenPasscodeSetThisDeviceOnly
          authenticationPolicy:UICKeyChainStoreAuthenticationPolicyUserPresence];

    keychain[@"kishikawakatsumi"] = @"01234567-89ab-cdef-0123-456789abcdef"
});
```

#### Updating a Touch ID protected item

The same way as when adding.  

**Do not run in the main thread if there is a possibility that the item you are trying to add already exists, and protected.**
**Because updating protected items requires authentication.**

Additionally, you want to show custom authentication prompt message when updating, specify an `authenticationPrompt` attribute.
If the item not protected, the `authenticationPrompt` parameter just be ignored.

```objective-c
UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.example.github-token"];

dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    [keychain setAccessibility:UICKeyChainStoreAccessibilityWhenPasscodeSetThisDeviceOnly
          authenticationPolicy:UICKeyChainStoreAuthenticationPolicyUserPresence];
    keychain.authenticationPrompt = @"Authenticate to update your access token";

    keychain[@"kishikawakatsumi"] = @"01234567-89ab-cdef-0123-456789abcdef"
});
```

#### Obtaining a Touch ID protected item

The same way as when you get a normal item. It will be displayed automatically Touch ID or passcode authentication If the item you try to get is protected.  
If you want to show custom authentication prompt message, specify an `authenticationPrompt` attribute.
If the item not protected, the `authenticationPrompt` parameter just be ignored.

```objective-c
UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.example.github-token"];

dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    [keychain setAccessibility:UICKeyChainStoreAccessibilityWhenPasscodeSetThisDeviceOnly
          authenticationPolicy:UICKeyChainStoreAuthenticationPolicyUserPresence];
    keychain.authenticationPrompt = @"Authenticate to update your access token";

    NSString *token = keychain[@"kishikawakatsumi"];
});
```

#### Removing a Touch ID protected item

The same way as when you remove a normal item.
There is no way to show Touch ID or passcode authentication when removing Keychain items.

```objective-c
UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.example.github-token"];

keychain[@"kishikawakatsumi"] = nil;
```

### <a name="shared_web_credentials"> Shared Web Credentials

> Shared web credentials is a programming interface that enables native iOS apps to share credentials with their website counterparts. For example, a user may log in to a website in Safari, entering a user name and password, and save those credentials using the iCloud Keychain. Later, the user may run a native app from the same developer, and instead of the app requiring the user to reenter a user name and password, shared web credentials gives it access to the credentials that were entered earlier in Safari. The user can also create new accounts, update passwords, or delete her account from within the app. These changes are then saved and used by Safari.  
<https://developer.apple.com/library/ios/documentation/Security/Reference/SharedWebCredentialsRef/>

```objective-c
UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithServer:[NSURL URLWithString:@"https://kishikawakatsumi.com"]
protocolType:UICKeyChainStoreProtocolTypeHTTPS];
NSString *username = @"kishikawakatsumi@mac.com";
NSString *password = keychain[username];
if (password) {
    // If found password in the Keychain,
    // then log into the server
} else {
    // If not found password in the Keychain,
    // try to read from Shared Web Credentials
    [keychain sharedPasswordForAccount:username completion:^(NSString *password, NSError *error) {
        if (password) {
            // If found password in the Shared Web Credentials,
            // then log into the server
            // and save the password to the Keychain

            keychain[username] = password
        } else {
            // If not found password either in the Keychain also Shared Web Credentials,
            // prompt for username and password

            // Log into server

            // If the login is successful,
            // save the credentials to both the Keychain and the Shared Web Credentials.

            keychain[username] = password
            [keychain setSharedPassword:password forAccount:username completion:nil];
        }
    }];
}
```

#### Request all associated domain's credentials

```objective-c
[UICKeyChainStore requestSharedWebCredentialWithCompletion:^(NSArray *credentials, NSError *error) {

}];
```

#### Generate strong random password

Generate strong random password that is in the same format used by Safari autofill (xxx-xxx-xxx-xxx).  

```objective-c
NSString *password = [UICKeyChainStore generatePassword];
NSLog(@"%@", password); // => Nhu-GKm-s3n-pMx
```

#### How to set up Shared Web Credentials

> 1. Add a com.apple.developer.associated-domains entitlement to your app. This entitlement must include all the domains with which you want to share credentials.

> 2. Add an apple-app-site-association file to your website. This file must include application identifiers for all the apps with which the site wants to share credentials, and it must be properly signed.

> 3. When the app is installed, the system downloads and verifies the site association file for each of its associated domains. If the verification is successful, the app is associated with the domain.

**More details:**  
<https://developer.apple.com/library/ios/documentation/Security/Reference/SharedWebCredentialsRef/>

### Debugging

#### Display all stored items if print keychain object

```objective-c
UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithServer:[NSURL URLWithString:@"https://github.com"]
                                                          protocolType:UICKeyChainStoreProtocolTypeHTTPS];
NSLog(@"%@", keychain);
```

```
=>
(
{
    accessibility = ak;
    authenticationType = dflt;
    class = InternetPassword;
    key = kishikawakatsumi;
    protocol = htps;
    server = "github.com";
    synchronizable = 0;
    value = "01234567-89ab-cdef-0123-456789abcdef";
}    {
    accessibility = ck;
    authenticationType = dflt;
    class = InternetPassword;
    key = hirohamada;
    protocol = htps;
    server = "github.com";
    synchronizable = 1;
    value = "11111111-89ab-cdef-1111-456789abcdef";
}    {
    accessibility = ak;
    authenticationType = dflt;
    class = InternetPassword;
    key = honeylemon;
    protocol = htps;
    server = "github.com";
    synchronizable = 0;
    value = "22222222-89ab-cdef-2222-456789abcdef";
})
```

#### Obtaining all stored keys

```objective-c
UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithServer:[NSURL URLWithString:@"https://github.com"]
                                                          protocolType:UICKeyChainStoreProtocolTypeHTTPS];

NSArray *keys = keychain.allKeys;
for (NSString *key in keys) {
    NSLog(@"key: %@", key);
}
```

```
=>
key: kishikawakatsumi
key: hirohamada
key: honeylemon
```

#### Obtaining all stored items

```objective-c
UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithServer:[NSURL URLWithString:@"https://github.com"]
                                                          protocolType:UICKeyChainStoreProtocolTypeHTTPS];

NSArray *items = keychain.allItems;
for (NSString *item in items) {
    NSLog(@"item: %@", item);
}
```

```
=>

item: {
    accessibility = ak;
    authenticationType = dflt;
    class = InternetPassword;
    key = kishikawakatsumi;
    protocol = htps;
    server = "github.com";
    synchronizable = 0;
    value = "01234567-89ab-cdef-0123-456789abcdef";
}
item: {
    accessibility = ck;
    authenticationType = dflt;
    class = InternetPassword;
    key = hirohamada;
    protocol = htps;
    server = "github.com";
    synchronizable = 1;
    value = "11111111-89ab-cdef-1111-456789abcdef";
}
item: {
    accessibility = ak;
    authenticationType = dflt;
    class = InternetPassword;
    key = honeylemon;
    protocol = htps;
    server = "github.com";
    synchronizable = 0;
    value = "22222222-89ab-cdef-2222-456789abcdef";
}
```

### Convenient class methods

Add items using default service name (=bundle identifer).

```objective-c
[UICKeyChainStore setString:@"01234567-89ab-cdef-0123-456789abcdef" forKey:@"kishikawakatsumi"];
```

Or specify the service name.

```objective-c
[UICKeyChainStore setString:@"01234567-89ab-cdef-0123-456789abcdef"
                     forKey:@"kishikawakatsumi"
                    service:@"com.example.github-token"];
```

---
Remove items.

```objective-c
[UICKeyChainStore removeItemForKey:@"kishikawakatsumi" service:@"com.example.github-token"];
```

To set nil value also works remove item for the key.

```objective-c
[UICKeyChainStore setString:nil forKey:@"kishikawakatsumi" service:@"com.example.github-token"];
```

## Requirements

iOS 4.3 or later
OS X 10.7 or later

## Installation

### CocoaPods

UICKeyChainStore is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

`pod 'UICKeyChainStore'`

##### For watchOS 2

```ruby
use_frameworks!

target 'EampleApp' do
  pod 'UICKeyChainStore'
end

target 'EampleApp WatchKit Extension' do
  platform :watchos, '2.0'
  pod 'UICKeyChainStore'
end
```

### Carthage

UICKeyChainStore is available through [Carthage](https://github.com/Carthage/Carthage). To install
it, simply add the following line to your Cartfile:

`github "kishikawakatsumi/UICKeyChainStore"`

### To manually add to your project

1. Add `Security.framework` to your target.
2. Copy files in Lib (`UICKeyChainStore.h` and `UICKeyChainStore.m`) to your project.

## Author

kishikawa katsumi, kishikawakatsumi@mac.com

## License

[Apache]: http://www.apache.org/licenses/LICENSE-2.0
[MIT]: http://www.opensource.org/licenses/mit-license.php
[GPL]: http://www.gnu.org/licenses/gpl.html
[BSD]: http://opensource.org/licenses/bsd-license.php

UICKeyChainStore is available under the [MIT license][MIT]. See the LICENSE file for more info.
