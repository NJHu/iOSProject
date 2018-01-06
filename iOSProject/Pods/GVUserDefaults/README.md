# GVUserDefaults - NSUserDefaults access via properties

[![Badge w/ Version](https://cocoapod-badges.herokuapp.com/v/GVUserDefaults/badge.png)](http://cocoadocs.org/docsets/GVUserDefaults)
[![Badge w/ Platform](https://cocoapod-badges.herokuapp.com/p/GVUserDefaults/badge.svg)](http://cocoadocs.org/docsets/GVUserDefaults)

Tired of writing all that code to get and set defaults in NSUserDefaults? Want to have code completion and compiler checks by using properties instead?

## Usage
Create a category on `GVUserDefaults`, add some properties in the .h file and make them `@dynamic` in the .m file.

    // .h
    @interface GVUserDefaults (Properties)
    @property (nonatomic, weak) NSString *userName;
    @property (nonatomic, weak) NSNumber *userId;
    @property (nonatomic) NSInteger integerValue;
    @property (nonatomic) BOOL boolValue;
    @property (nonatomic) float floatValue;
    @end

    // .m
    @implementation GVUserDefaults (Properties)
    @dynamic userName;
    @dynamic userId;
    @dynamic integerValue;
    @dynamic boolValue;
    @dynamic floatValue;
    @end

Now, instead of using `[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]`, you can simply use `[GVUserDefaults standardUserDefaults].userName`.

You can even save defaults by setting the property:

    [GVUserDefaults standardUserDefaults].userName = @"myusername";


### Key prefix
The keys in NSUserDefaults are the same name as your properties. If you'd like to prefix or alter them, add a `transformKey:` method to your category. For example, to turn "userName" into "NSUserDefaultUserName":

    - (NSString *)transformKey:(NSString *)key {
        key = [key stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[key substringToIndex:1] uppercaseString]];
        return [NSString stringWithFormat:@"NSUserDefault%@", key];
    }

### Registering defaults
Registering defaults can be done as usual, on NSUserDefaults directly (use the same prefix, if any!).

    NSDictionary *defaults = @{
        @"NSUserDefaultUserName": @"default",
        @"NSUserDefaultUserId": @1,
        @"NSUserDefaultBoolValue": @YES
    };

    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];

However, it's a lot easier to create a setupDefaults method on the category, which takes care of the transformed keys automatically:

    - (NSDictionary *)setupDefaults {
        return @{
            @"userName": @"default",
            @"userId": @1,
            @"boolValue": @YES
        };
    }

### NSUserDefaults initWithSuitName support
Simply create a methods called `suitName` in your category and return the suitName you wish to use:

    - (NSString *)suitName {
        return @"com.example.mySuitName";
    }


### Performance
Performance is nearly identical to using NSUserDefaults directly. We're talking about a difference of 0.05 milliseconds or less.


## Install
Install via [CocoaPods](http://cocoapods.org) (`pod 'GVUserDefaults'`) or drag the code in the GVUserDefaults subfolder to your project.


## Issues and questions
Have a bug? Please [create an issue on GitHub](https://github.com/gangverk/GVUserDefaults/issues)!


## Contributing
GVUserDefaults is an open source project and your contribution is very much appreciated.

1. Check for [open issues](https://github.com/gangverk/GVUserDefaults/issues) or [open a fresh issue](https://github.com/gangverk/GVUserDefaults/issues/new) to start a discussion around a feature idea or a bug.
2. Fork the [repository on Github](https://github.com/gangverk/GVUserDefaults) and make your changes on the **develop** branch (or branch off of it). Please retain the code style that is used in the project.
3. Write tests, make sure everything passes.
4. Send a pull request.


## License
GVUserDefaults is available under the MIT license. See the LICENSE file for more info.


## Thanks
A huge thank you goes to [ADVUserDefaults](https://github.com/advantis/ADVUserDefaults) for its method of creating accessors for primitive types.