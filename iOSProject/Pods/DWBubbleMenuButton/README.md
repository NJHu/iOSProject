DWBubbleMenuButton
==================
DWBubbleMenuButton is a simple animation class for expanding and collapsing a variable sized menu. 

![](demo.gif)

Project allows for expanding menus in left, right, up, and down directions. Using the class is as simple as setting your home button and adding an array of menu buttons.

CocoaPods
==================
```
pod 'DWBubbleMenuButton', '~> 1.0'
```

Usage
==================
Create a home button
```objective-c
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeSystem];

    [menuButton setTitle:@"Menu" forState:UIControlStateNormal];
```

Create an instance of DWBubbleMenuButton
```objective-c
    DWBubbleMenuButton *bubbleMenuButton = [[DWBubbleMenuButton alloc] initWithFrame:CGRectMake(20.f,
                                                                                                20.f,
                                                                                                100.f,
                                                                                                100.f)
                                                                  expansionDirection:DirectionDown];
    bubbleMenuButton.homeButtonView = menuButton;
```

Add buttons to your bubble menu
```objective-c
    [bubbleMenuButton addButtons:@[ /* your buttons */]];
    
    /* OR */
    
    [bubbleMenuButton addButton:/* your button */];
```

DWBubbleMenuButton will automatically handle the animation, frame changes, and showing your menu buttons in the proper order
