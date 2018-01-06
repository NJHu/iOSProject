# KILabel

A simple to use drop in replacement for UILabel for iOS 7 and above that highlights links such as URLs, twitter style usernames and hashtags and makes them touchable.

<img width=320 src="https://raw.github.com/Krelborn/KILabel/master/IKLabelDemoScreenshot.png" alt="KILabel Screenshot">

## How to use it in your project
KILabel doesn't have any special dependencies so just include the files from KILabel/Source in your project. Then use the KILabel class in place of UILabel.

1. Download the latest source.
2. Add the files KILabel.m and KILabel.h to your project.
3. Either:-
    * Design your user interface as you would normally. In Interface Builder set the custom class for any UILabel you want to replace to KILabel. The label should honor all IB settings. OR
    * Create KILabel objects in code.

As Podspec is also provided so KILabel can be used by added the following line to your project's Podfile.

<pre>pod 'KILabel', '1.0.0'</pre>

You can also use KILabel with Swift. Just compile the files into your XCode project in the usual way but add the following line to your Objective-C Bridging Header.

``` objective-c
#import "KILabel.h"
```

## Things to know
* To handle taps on links attach a block to one of the label's tap handler properties (See sample code).
* Usernames and hashtag links are colored using the label's **tint** property. This can be configured through IB.
* URLs are attributed using the **NSLinkAttributeName** and are displayed accordingly.
* It should be possible to use either the label's **text** or **attributedText** properties to set the label content.
* When using the **attributedText** property, KILabel will attempt to preserve the original attributes as much as possible. If you see any problems with this let me know.
* The link highlighting and interaction can be enabled/disabled using the **automaticLinkDetectionEnabled** property.
* The constructor always sets *userInteractionEnabled* to YES. If you subsequently set it NO you will lose the ability to interact with links even it **automaticLinkDetectionEnabled** is set to YES.
* Use the **linkAtPoint** method to find out if there is link text at a point in the label's coordinate system. This returns nil if there is no link at the location, otherwise returns a dictionary with the following keys:
    * *linkType* a KILinkType value that identifies the type of link
    * *range* an NSRange that gives the range of the link within the label's text
    * *link* an NSString containing the raw text of the link
* Use the *linkDetectionTypes* property to select the type of link you want touchable by combining KILinkTypeOption bitmasks.
* If you attach attributedText with existing links attached, they will be preserved, but only touchable if URL detection is enabled. This is handy for manually cleaning up displayed URLs while preserving the original link behind the scenes.

## A bit of sample code

The code snippet below shows how to setup a label with a tap handling block. A more complete example can be seen in the KILabelDemo project included in the repository.

``` objective-c
// Create the label, you can do this in Interface Builder as well
KILabel *label = [[KILabel alloc] initWithFrame:NSRectMake(20, 64, 280, 60)];
label.text = @"Follow @krelborn or visit http://compiledcreations.com #shamelessplug";

// Attach a block to be called when the user taps a user handle
label.userHandleLinkTapHandler = ^(KILabel *label, NSString *string, NSRange range) {
  NSLog(@"User tapped %@", string);
};

// Attach a block to be called when the user taps a hashtag
label.hashtagLinkTapHandler = ^(KILabel *label, NSString *string, NSRange range) {
  NSLog(@"Hashtag tapped %@", string);
};

// Attach a block to be called when the user taps a URL
label.urlLinkTapHandler = ^(KILabel *label, NSString *string, NSRange range) {
  NSLog(@"URL tapped %@", string);
};

[self.view addSubview:label];
```

KILabel also works in Swift. Here's the above example again but in swift.

``` swift
// Create the label, you can do this in Interface Builder as well
let label = KILabel(frame: CGRect(x: 20, y: 64, width: 280, height: 60))
label.text = "Follow @krelborn or visit http://compiledcreations.com #shamelessplug"

// Attach a block to be called when the user taps a user handle
label.userHandleLinkTapHandler = { label, handle, range in
  NSLog("User handle \(handle) tapped")
}

// Attach a block to be called when the user taps a hashtag
label.hashtagLinkTapHandler = { label, hashtag, range in
  NSLog("Hashtah \(hashtag) tapped")
}

// Attach a block to be called when the user taps a URL
label.urlLinkTapHandler = { label, url, range in
  NSLog("URL \(url) tapped")
}

view.addSubview(label)
```

## Demo

The repository includes KILabelDemo, written in Objective-C, that shows a simple use of the label in a storyboard with examples for implementing touchable links.

The demo also demonstrates how to use a gesture recognizer with the label to implement a long press on a link, which uses the **linkAtPoint** method.

There's also an example using a UITableView where cells are given dynamic heights depending on the content.

## License & Credits

KILabel is available under the MIT license.

KILabel was inspired by STTweetLabel (http://github.com/SebastienThiebaud) and others such as NimbusAttributedLabel (http://latest.docs.nimbuskit.info/NimbusAttributedLabel.html). If KILabel can't help you, maybe they can.

## Contact

Open an issue to report bugs or request a feature.

Any otherfeedback welcome through the obvious channels.

- http://compiledcreations.com
- http://twitter.com/krelborn
- http://github.com/krelborn
