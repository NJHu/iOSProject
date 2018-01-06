<img src="https://raw.github.com/Marxon13/M13ProgressSuite/master/ReadmeResources/M13ProgressSuiteBanner.png">
M13ProgressSuite
================

A set of classes used to display progress information to users on iOS.

Includes:
---------
* A interchangeable set of progress view of diffrent styles. All the progress views are based on the same superclass, allowing any of them to be switched with any other easily.
* A progress bar for UINavigationBar that works like Apple's Messages app. It also has the added feature of having an indeterminate style.
* A HUD overlay that works over any UIView. Uses the M13ProgressView class to allow easy customizablility of the progress view.
* A progress view that is styled like terminal.
* Complete documentation of each class.

UINavigationController (M13ProgressViewBar)
---------------------
Adds a progress bar to the UINavigationController's UINavigationBar. The progress bar is controlled through the UINavigationController. 

<img src="https://raw.github.com/Marxon13/M13ProgressSuite/master/ReadmeResources/UINavigationBar.gif">

<img src="https://raw.github.com/Marxon13/M13ProgressSuite/master/ReadmeResources/UINavigationBarIndeterminate.gif">


M13ProgressHUD
---------------
A customizable HUD that displays progress, and status information to the user. It uses the M13ProgressView class to allow easy changing of the progress view style.

<img src="https://raw.github.com/Marxon13/M13ProgressSuite/master/ReadmeResources/HUDBasic.gif">


M13ProgressConsole
------------------
A progress view styled like Terminal on OS X.

<img src="https://raw.github.com/Marxon13/M13ProgressSuite/master/ReadmeResources/ConsolePercent.gif">

<img src="https://raw.github.com/Marxon13/M13ProgressSuite/master/ReadmeResources/ConsoleDots.gif">

<img src="https://raw.github.com/Marxon13/M13ProgressSuite/master/ReadmeResources/ConsoleDotsRaise.gif">

M13ProgressViews
----------------
A set of progess view based off of the same superclass. Allowing easy switching between progress view. Each progress view has success and failure actions, an indeterminate mode, and appearance customization features.

***Bar***

<img src="https://raw.github.com/Marxon13/M13ProgressSuite/master/ReadmeResources/Bar.gif">

<img src="https://raw.github.com/Marxon13/M13ProgressSuite/master/ReadmeResources/BarIndeterminate.gif">

***Bordered Bar***

<img src="https://raw.github.com/Marxon13/M13ProgressSuite/master/ReadmeResources/BorderedBar.gif">

<img src="https://raw.github.com/Marxon13/M13ProgressSuite/master/ReadmeResources/BorderedIndeterminate.gif">

***Filtered Image***

<img src="https://raw.github.com/Marxon13/M13ProgressSuite/master/ReadmeResources/FilteredImage.gif">

***Image***

<img src="https://raw.github.com/Marxon13/M13ProgressSuite/master/ReadmeResources/Image.gif">

<img src="https://raw.github.com/Marxon13/M13ProgressSuite/master/ReadmeResources/ImageHidden.gif">

***Pie***

<img src="https://raw.github.com/Marxon13/M13ProgressSuite/master/ReadmeResources/Pie.gif">

<img src="https://raw.github.com/Marxon13/M13ProgressSuite/master/ReadmeResources/PieIndeterminate.gif">

***Ring***

<img src="https://raw.github.com/Marxon13/M13ProgressSuite/master/ReadmeResources/Ring.gif">

<img src="https://raw.github.com/Marxon13/M13ProgressSuite/master/ReadmeResources/RingIndeterminate.gif">

**Segmented Bar***

<img src="https://raw.github.com/Marxon13/M13ProgressSuite/master/ReadmeResources/SegmentedBar.gif">

<img src="https://raw.github.com/Marxon13/M13ProgressSuite/master/ReadmeResources/SegmentedBarIndeterminate.gif">

***Segmented Ring***

<img src="https://raw.github.com/Marxon13/M13ProgressSuite/master/ReadmeResources/SegmentedRing.gif">

<img src="https://raw.github.com/Marxon13/M13ProgressSuite/master/ReadmeResources/SegmentedRingStraight.gif">

<img src="https://raw.github.com/Marxon13/M13ProgressSuite/master/ReadmeResources/SegmentedRingIndeterminate.gif">

***Striped Bar***

<img src="https://raw.github.com/Marxon13/M13ProgressSuite/master/ReadmeResources/Striped.gif">

<img src="https://raw.github.com/Marxon13/M13ProgressSuite/master/ReadmeResources/StripedIndeterminate.gif">

Progress View Usage:
--------------------

All progress bars follow the same general usage:

```
// Create the progress view.
M13ProgressViewBar *progressView = [[M13ProgressViewBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 5.0)];

// Configure the progress view here.

// Add it to the view.
[self.view addSubview: progressView];

// Update the progress as needed
[progressView setProgress: 0.1 animated: YES];

```

HUD Usage:
----------

```
// Create the HUD
M13ProgressHUD *HUD = [[M13ProgressHUD alloc] initWithProgressView:[[M13ProgressViewRing alloc] init]];

// Configure the progress view
HUD.progressViewSize = CGSizeMake(60.0, 60.0);
HUD.animationPoint = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2);

// Add the HUD to the window. (Or any UIView)
UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
[window addSubview:HUD];

// Show the HUD
[HUD show:YES];

//Update the HUD progress
[HUD setProgress:0.5 animated:YES];

// Update the HUD status
HUD.status = @"Processing";

// Hide the HUD
[HUD show:NO];

```

Contact Me:
-------------
If you have any questions comments or suggestions, send me a message. If you find a bug, or want to submit a pull request, let me know.

License:
--------
MIT License

> Copyright (c) 2013 Brandon McQuilkin
> 
> Permission is hereby granted, free of charge, to any person obtaining 
>a copy of this software and associated documentation files (the  
>"Software"), to deal in the Software without restriction, including 
>without limitation the rights to use, copy, modify, merge, publish, 
>distribute, sublicense, and/or sell copies of the Software, and to 
>permit persons to whom the Software is furnished to do so, subject to  
>the following conditions:
> 
> The above copyright notice and this permission notice shall be 
>included in all copies or substantial portions of the Software.
> 
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
>EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
>MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
>IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
>CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
>TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
>SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
