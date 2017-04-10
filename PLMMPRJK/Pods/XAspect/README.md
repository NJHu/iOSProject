# XAspect

XAspect is an Objective-C framework for [Aspect-Oriented Programming] to make your code more **reusable** and **maintainable**.

It provides macros and APIs for **binding your aspect implementation to the target Objective-C methods whether you have the source implementation or not, even to the Apple's SDK!**

XAspect decouples the aspect logic (or [cross-cutting concerns]) from your project and encapsulates those aspects into separated aspect files. Once the program is loaded, XAspect will automatically merge those patches into your program by [**method swizzling**][method swizzling].

> If you already know what XAspect is, you could skip the following sections and jump right into the [table of contents (the section 'More Information')](#more_information).


Installation
------------

#### (1) Via CocoaPods

XAspect is distributed via [CocoaPods]. Add this line in your **Podfile** and then perform `$ pod install`:

	pod 'XAspect'

#### (2) Include Source Code Manually

You can also simply include XAspect in your project manually. Just add all of the source files and folders in the `XAspect/` directory to your project.

At a Glance
-----------

Using XAspect is a little like writing **patches** or **plugins** for source code. With a couple of lines to create an aspect context, you could start writing your patch implementation. XAspect will automatically merge those patches into your program when the program finishes loading.

For example, say you want to log a message every time an object is initialized, you need to observe the invocation of `-[NSObject init]`. With XAspect, You can easily add `NSLog()` statements to `-[NSObject init]`.

You could try this by yourself by either

 1. Finding the following sample code in *Aspect-ObjectAllocation.m* in the *XAspectDev* project in the repository and uncommenting the `AspectPatch()` implementation, or

 2. Creating a *Aspect-ObjectAllocation.m* in your project and adding the following code (you should also install XAspect):


```objc
// In an aspect file you create (.m file).
#import <Foundation/Foundation.h>
#import <XAspect/XAspect.h>

// A aspect namespace for the aspect implementation field (mandatory).
#define AtAspect ObjectLifetime

// Create an aspect patch field for the class you want to add the aspect patches to.
#define AtAspectOfClass NSObject
@classPatchField(NSObject)

// Intercept the target objc message.
AspectPatch(-, instancetype, init)
{
	// Add your custom implementation here.
	NSLog(@"[Init]: %@", NSStringFromClass([self class]));

	// Forward the message to the source implementation.
	return XAMessageForward(init);
}

@end
#undef AtAspectOfClass
#undef AtAspect
```



Run the program. After the program has loaded, you'll see messages when any object is initialized:

```
 [Init]: NSUserDefaults
 [Init]: NSProcessInfo
 [Init]: CFPrefsSource
 ...
```

You could also add **before advice** to `-dealloc` to print the deallocated objects for specific classes. 

```objc
#import <XAspect/XAspect.h>
#import <UIKit/UIKit.h>

// -----------------------------------------------------------------------------
#define AtAspect DeallocTracker
// -----------------------------------------------------------------------------

#define AtAspectOfClass NSObject
@classPatchField(NSObject)

AspectPatch(-, void, dealloc)
{
  static NSArray *klasses;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    // Add classes here which you want to track when they were deallocated.
    klasses = @[[UITableView class],
                [UITableViewController class],
                ];
  });

  Class klass = [self class];
  if ([klasses containsObject:klass]) {
    NSLog(@"--%@ <%p> dealloc", NSStringFromClass(klass), self);
  }
  XAMessageForwardDirectly(dealloc);
}

@end
#undef AtAspectOfClass
```


XAspect aims to separate aspect code from the source implementation, and inject them back when the program is loaded.

For more information about XAspect, please read the [introduction][Introduction] and the [documentation][Documentation].


### Benefits using XAspect

Using XAspect has some benefits:

 * **Change behaviors without changing the source.** XAspect lets you decouple your aspect implementation ([*cross-cutting concern*][cross-cutting concern]) from classes and source files. This means that it sticks to the [Open/Closed Principle (OCP)][OCP] when you need to modify the aspect features/behaviors in your project.
 * **Encapsulate your aspect implementation in one file.** XAspect lets you implement your aspect implementation patches in one file. You only need to focus in one file to do aspect-oriented programming across the whole project. This means that your aspect code is more *maintainable* and *reusable*. You can simply reuse them by copying the aspect files into another project with a little modification if needed.
 * **Amenable to version control.** Because of the encapsulation, changes from one aspect are encapsulated in one files, you can commit your aspect patches in one file. It means that you don't need to branch your source while you're developing multiple aspects through multiple classes and files.
 * **Avoid replacing the original implementation by Safe Category.** XAspect also adopted *Safe Category* derived from [libextobjc]. With Safe Category, it is guaranteed that your category implementation will be the only implementation for the target selector — it won't replace or be replaced by other implementations. If there are more than one implementations for the same target selector, XAspect will identify the conflict when the program is loaded.


### This framework is for you if:

 - You want to decouple different aspects in one class and separate them in different places.
 - You want to encapsulate changes across classes for the same aspect into one file so as to simplify maintenance, code review, and version control. It may lower the cost of maintenance.
 - You develop multiple aspects at the same time. You want to decouple them and encapsulate them separately to reduce the complexity of development.
 - You want to pack an aspect (concept/feature) into a file, and make it highly reusable.
 - You want to bridges the implementation between a third party library and your project without changing both of their source codes.


### Downsides and Restrictions

There are some downsides and restrictions. Please read the section ['Downsides and Restrictions'][Downsides and Restrictions] in Documentation.


## More Information

 1. [Introduction]
	* What is XAspect: the Aims of XAspect
	* How to Use XAspect: Getting Started
 2. [Documentation]
	* Aspect Field and Patch Field
	* Patches
	* Downsides and Restrictions



## About

### Maintenance Policy and Development Notes
Any help or contribution is welcome. Please read the [Development Notes] to find what you can help.

### Author
* Xaree Lee (李岡諭, Kang-Yu Lee), an iOS developer from Taiwan.
    - <xareelee@gmail.com>

### License
XAspect is available under the MIT license. See the [LICENSE] file for more info.



<!--File Links-->
[Introduction]: Documents/Introduction_of_XAspect.md#introduction-of-xaspect
[Getting Started]: Documents/Getting_Started_using_XAspect.md
[XAspect Inside]: Documents/XAspect_Inside.md
[Documentation]: Documents/Documentation.md#documentation
[Downsides and Restrictions]: Documents/Documentation.md#downsides-and-restrictions
[Development Notes]: Documents/DevelopmentNotes.md
[LICENSE]: LICENSE.md


<!--Links-->
[Aspect-Oriented Programming]: http://en.wikipedia.org/wiki/Aspect-oriented_programming
[CocoaPods]: http://cocoapods.org
[Xaree Lee]: https://github.com/xareelee
[cross-cutting concern]: http://en.wikipedia.org/wiki/Cross-cutting_concern
[OCP]: http://en.wikipedia.org/wiki/Open/closed_principle
[cross-cutting concerns]: http://en.wikipedia.org/wiki/Cross-cutting_concern
[DSL]: http://en.wikipedia.org/wiki/Domain-specific_language
[method swizzling]: http://nshipster.com/method-swizzling/
[libextobjc]: https://github.com/jspahrsummers/libextobjc
