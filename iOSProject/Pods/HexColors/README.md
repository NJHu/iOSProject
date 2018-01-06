<p align="center">
    <img src="HexColors.png" alt="HexColors" title="HexColors">
</p>

[![Platform](https://img.shields.io/badge/platform-iOS%20%7C%20watchOS%20%7C%20tvOS%20%7C%20macOS-lightgrey.svg)](https://github.com/mrs-/HexColors)
[![Xcode](https://img.shields.io/badge/Xcode-9.0-blue.svg)](https://developer.apple.com/xcode)
[![Swift](https://img.shields.io/badge/Swift-4.0-orange.svg)](https://swift.org)
![Downloads Month](https://img.shields.io/cocoapods/dm/HexColors.svg)
![Cocoapods](https://cocoapod-badges.herokuapp.com/v/HexColors/badge.png)
[![Build Status](https://travis-ci.org/mRs-/HexColors.svg?branch=master)](https://travis-ci.org/mrs-/HexColors)
[![codecov](https://codecov.io/gh/mRs-/HexColors/branch/master/graph/badge.svg)](https://codecov.io/gh/mRs-/HexColors)

HexColors is an extension for UIColor and NSColor to support for creating colors from a hex string like #FF0088 or 8844FF and back to a String. Completely rewritten in Swift 3!

If you want to use this in Objective-C jump to the 4.X version tag.
If you want to use this in Swift < 3.2 use the 5.X version tag.

# RELEASE 6.0.0
Swift 4.0 compatiblity

# Examples
How to use HexColors in the different systems.

## iOS / watchOS / tvOS

### Generating UIColors

``` swift
let colorWithHex = UIColor("#ff8942")
let colorWithoutHex = UIColor("ff8942")
let colorWithHexAndAlhpa = UIColor("#ff8942DF")
let colorWithoutHexAndAlhpa = UIColor("ff8942DF")
let shortColorWithHex = UIColor("#fff")
let shortColorWithoutHex = UIColor("fff")
let shortColorWithHexAndAlpha = UIColor("#FFFD")
let shortColorWithoutHexAndAlpha = UIColor("#FFFD")
```

### Generating Hex Strings from UIColor
``` swift
let colorWithHex = UIColor("#ff8942")
let stringFromColor = colorWithHex.hex
```

## macOS

### Generating NSColor
``` swift
let colorWithHex = NSColor("#ff8942")
let colorWithoutHex = NSColor("ff8942")
let colorWithHexAndAlhpa = NSColor("#ff8942DF")
let colorWithoutHexAndAlhpa = NSColor("ff8942DF")
let shortColorWithHex = NSColor("#fff")
let shortColorWithoutHex = NSColor("fff")
let shortColorWithHexAndAlpha = NSColor("#FFFD")
let shortColorWithoutHexAndAlpha = NSColor("#FFFD")
```

### Generating Hex Strings from NSColor
``` swift
let colorWithHex = NSColor("#ff8942")
let stringFromColor = colorWithHex.hex
```

# Installation

## Requirements
HexColors requires **>= iOS 8.0** and **>=macOS 10.9**.

## Cocoapods
Add HexColors to your Podfile:
``` ruby
pod 'HexColors'
```
* `pod install HexColors`

## Carthage
Add HexColors to your Cartfile:
```
github "mRs-/HexColors"
```

## Swift Package Manager
To work with the Swift Package Manager you need to add a Package.swift file and defining your package.

``` swift
import PackageDescription

let package = Package(
    name: "YourPackageName",
    dependencies: [
        .Package(url: "https://github.com/mRs-/HexColors", majorVersion: 5),
    ]
)
```

Then execute the Swift Package Manager with the following Shell commands:
``` bash
swift build
.build/debug/YourPackageName
``` 

## Manual
Simply just drag and drop the HexColors.swift in your project.

# Credits
HexColors was created by [Marius Landwehr](https://github.com/mRs-) because of the pain to create Colors from a API (mostly hex) converting to a UI/NSColor.

# Creator
[Marius Landwehr](https://github.com/mRs-) [@mariusLAN](https://twitter.com/mariusLAN)

# License
HexColors is available under the MIT license. See the LICENSE file for more info.
