//
//  WebView+Debug.m
//  VOL
//
//  Created by Pablo Guillen Schlippe on 26.07.11.
//  Copyright 2011 Medienhaus. All rights reserved.
//

#ifdef DEBUG

#import <objc/runtime.h>

#import "WebView+Debug.h"

@class WebView;
@class WebFrame;
@class WebScriptCallFrame;

#pragma mark -
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
static NSString* getAddress() {
    id myhost =[NSClassFromString(@"NSHost") performSelector:@selector(currentHost)];
    
    if (myhost) {
        for (NSString* address in [myhost performSelector:@selector(addresses)]) {
            if ([address rangeOfString:@"::"].location == NSNotFound) {
                return address;
            }
        }
    }
    
    return @"127.0.0.1";
}

void enableRemoteWebInspector() {
    [NSClassFromString(@"WebView") performSelector:@selector(_enableRemoteInspector)];
    NSLog(@"Point your browser at http://%@:9999", getAddress());
}
#pragma clang diagnostic pop
#pragma mark -

@interface ScriptDebuggerDelegate : NSObject

-(id)functionNameForFrame:(WebScriptCallFrame*)frame;
-(id)callerForFrame:(WebScriptCallFrame*)frame;
-(id)exceptionForFrame:(WebScriptCallFrame*)frame;

@end

#pragma mark -

@implementation ScriptDebuggerDelegate

// We only have access to the public methods declared in the header / class
// The private methods can also be accessed but raise a warning.
// Use runtime selectors to suppress warnings 

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
#pragma clang diagnostic ignored "-Wundeclared-selector"

-(id)functionNameForFrame:(WebScriptCallFrame*)frame {
    SEL functionNameSelector = @selector(functionName);
    return [(id)frame performSelector:functionNameSelector];
}

-(id)callerForFrame:(WebScriptCallFrame*)frame {
    SEL callerSelector = @selector(caller);
    return [(id)frame performSelector:callerSelector];
}

-(id)exceptionForFrame:(WebScriptCallFrame*)frame {
    SEL exceptionSelector = @selector(exception);
    return [(id)frame performSelector:exceptionSelector];    
}

#pragma clang diagnostic pop

- (void)webView:(WebView *)webView      didParseSource:(NSString *)source
 baseLineNumber:(unsigned)lineNumber
        fromURL:(NSURL *)url
       sourceId:(int)sid
    forWebFrame:(WebFrame *)webFrame {
    if (kDidParseSource)
        NSLog(@"ScriptDebugger called didParseSource: \nsourceId=%d, \nurl=%@", sid, url);
}

// some source failed to parse
- (void)webView:(WebView *)webView failedToParseSource:(NSString *)source
 baseLineNumber:(unsigned)lineNumber
        fromURL:(NSURL *)url
      withError:(NSError *)error
    forWebFrame:(WebFrame *)webFrame {
    if (kFailedToParseSource)
        NSLog(@"ScriptDebugger called failedToParseSource:\
              \nurl=%@ \nline=%d \nerror=%@ \nsource=%@",
              url, lineNumber, error, source);
}

- (void)webView:(WebView *)webView  exceptionWasRaised:(WebScriptCallFrame *)frame
       sourceId:(int)sid
           line:(int)lineno
    forWebFrame:(WebFrame *)webFrame {
    if (kExceptionWasRaised)
        NSLog(@"ScriptDebugger exception:\
              \nsourceId=%d \nline=%d \nfunction=%@, \ncaller=%@, \nexception=%@", 
              sid,
              lineno, 
              [self functionNameForFrame:frame], 
              [self callerForFrame:frame], 
              [self exceptionForFrame:frame]);
}

// just entered a stack frame (i.e. called a function, or started global scope)
- (void)webView:(WebView *)webView    didEnterCallFrame:(WebScriptCallFrame *)frame
       sourceId:(int)sid
           line:(int)lineno
    forWebFrame:(WebFrame *)webFrame {
    if (kDidEnterCallFrame)
        NSLog(@"ScriptDebugger didEnterCallFrame:\
              \nsourceId=%d \nline=%d \nfunction=%@, \ncaller=%@, \nexception=%@", 
              sid, 
              lineno, 
              [self functionNameForFrame:frame], 
              [self callerForFrame:frame], 
              [self exceptionForFrame:frame]);
}

// about to execute some code
- (void)webView:(WebView *)webView willExecuteStatement:(WebScriptCallFrame *)frame
       sourceId:(int)sid
           line:(int)lineno
    forWebFrame:(WebFrame *)webFrame {
    if (kWillExecuteStatement)
        NSLog(@"ScriptDebugger willExecuteStatement:\
              \nsourceId=%d \nline=%d \nfunction=%@, \ncaller=%@, \nexception=%@", 
              sid, 
              lineno, 
              [self functionNameForFrame:frame], 
              [self callerForFrame:frame], 
              [self exceptionForFrame:frame]);
}

// about to leave a stack frame (i.e. return from a function)
- (void)webView:(WebView *)webView   willLeaveCallFrame:(WebScriptCallFrame *)frame
       sourceId:(int)sid
           line:(int)lineno
    forWebFrame:(WebFrame *)webFrame {
    if (kWillLeaveCallFrame)
        NSLog(@"ScriptDebugger willLeaveCallFrame:\
              \nsourceId=%d \nline=%d \nfunction=%@, \ncaller=%@, \nexception=%@", 
              sid, 
              lineno, 
              [self functionNameForFrame:frame], 
              [self callerForFrame:frame], 
              [self exceptionForFrame:frame]);
}

@end

#pragma mark -

@interface UIWebView ()

-(id)setScriptDebugDelegate:(id)delegate;

@end

#pragma mark -

@implementation UIWebView (DebugCategory)

- (void)webView:(id)sender didClearWindowObject:(id)windowObject 
		forFrame:(WebFrame*)frame {
    ScriptDebuggerDelegate* delegate = [[ScriptDebuggerDelegate alloc] init];
    objc_setAssociatedObject(sender, @"ScriptDebuggerDelegate", delegate, OBJC_ASSOCIATION_RETAIN);
    [sender setScriptDebugDelegate:delegate];
}

@end

#endif
