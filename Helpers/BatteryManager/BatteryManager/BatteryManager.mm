#line 1 "/Users/matt/iOS/Projects/Xen-HTML/Helpers/BatteryManager/BatteryManager/BatteryManager.xm"
#import "XENBMResources.h"
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <objc/runtime.h>


#define $_MSFindSymbolCallable(image, name) make_sym_callable(MSFindSymbol(image, name))

@interface WKBrowsingContextController : NSObject
- (void *)_pageRef; 
@end

@interface WKContentView : NSObject
@property (nonatomic, readonly) WKBrowsingContextController *browsingContextController;
@end

@interface WKWebView (XH_Extended)
@property (nonatomic) BOOL _xh_isPaused;
@end

@interface XENHWidgetController : UIViewController


@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIWebView *legacyWebView;

@property (nonatomic, readwrite) BOOL isPaused;

@end

@interface XENHResources : NSObject
+ (BOOL)displayState; 
@end


enum class ActivityStateChangeDispatchMode { Deferrable, Immediate };
struct WebCoreActivityState {
    enum Flag {
        WindowIsActive = 1 << 0,
        IsFocused = 1 << 1,
        IsVisible = 1 << 2,
        IsVisibleOrOccluded = 1 << 3,
        IsInWindow = 1 << 4,
        IsVisuallyIdle = 1 << 5,
        IsAudible = 1 << 6,
        IsLoading = 1 << 7,
        IsCapturingMedia = 1 << 8,
    };
};




static void (*WebPageProxy$activityStateDidChange)(void *_this, unsigned int flags, bool wantsSynchronousReply, ActivityStateChangeDispatchMode dispatchMode);


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class WKWebView; @class XENHWidgetController; 


#line 56 "/Users/matt/iOS/Projects/Xen-HTML/Helpers/BatteryManager/BatteryManager/BatteryManager.xm"
static void (*_logos_orig$SpringBoard$XENHWidgetController$setPaused$animated$)(_LOGOS_SELF_TYPE_NORMAL XENHWidgetController* _LOGOS_SELF_CONST, SEL, BOOL, BOOL); static void _logos_method$SpringBoard$XENHWidgetController$setPaused$animated$(_LOGOS_SELF_TYPE_NORMAL XENHWidgetController* _LOGOS_SELF_CONST, SEL, BOOL, BOOL); static BOOL (*_logos_orig$SpringBoard$WKWebView$_isBackground)(_LOGOS_SELF_TYPE_NORMAL WKWebView* _LOGOS_SELF_CONST, SEL); static BOOL _logos_method$SpringBoard$WKWebView$_isBackground(_LOGOS_SELF_TYPE_NORMAL WKWebView* _LOGOS_SELF_CONST, SEL); 


static inline void setWKWebViewActivityState(WKWebView *webView, bool isPaused) {
    if (!webView)
        return;
    
    webView._xh_isPaused = isPaused;
    
    
    WKContentView *contentView = MSHookIvar<WKContentView*>(webView, "_contentView");
    if (!contentView.browsingContextController) {
        XENlog(@"Missing contentView.browsingContextController");
        return;
    }
    
    void *page = MSHookIvar<void*>(contentView.browsingContextController, "_page");
    if (!page) {
        if (!contentView.browsingContextController) XENlog(@"Missing _page");
        return;
    }
    
    WebPageProxy$activityStateDidChange(page, WebCoreActivityState::Flag::IsVisible, false, ActivityStateChangeDispatchMode::Deferrable);
        
    XENlog(@"Did set webview running state to %@, for URL: %@", isPaused ? @"paused" : @"active", webView.URL);
}




static void _logos_method$SpringBoard$XENHWidgetController$setPaused$animated$(_LOGOS_SELF_TYPE_NORMAL XENHWidgetController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, BOOL paused, BOOL animated) {
    
    if (self.webView && self.isPaused != paused) {
        setWKWebViewActivityState(self.webView, paused);
    }
    
    _logos_orig$SpringBoard$XENHWidgetController$setPaused$animated$(self, _cmd, paused, animated);
}






__attribute__((used)) static BOOL _logos_method$SpringBoard$WKWebView$_xh_isPaused(WKWebView * __unused self, SEL __unused _cmd) { NSValue * value = objc_getAssociatedObject(self, (void *)_logos_method$SpringBoard$WKWebView$_xh_isPaused); BOOL rawValue; [value getValue:&rawValue]; return rawValue; }; __attribute__((used)) static void _logos_method$SpringBoard$WKWebView$set_xh_isPaused(WKWebView * __unused self, SEL __unused _cmd, BOOL rawValue) { NSValue * value = [NSValue valueWithBytes:&rawValue objCType:@encode(BOOL)]; objc_setAssociatedObject(self, (void *)_logos_method$SpringBoard$WKWebView$_xh_isPaused, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }

static BOOL _logos_method$SpringBoard$WKWebView$_isBackground(_LOGOS_SELF_TYPE_NORMAL WKWebView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    if (self._xh_isPaused) {
        return YES;
    } else {
        return _logos_orig$SpringBoard$WKWebView$_isBackground(self, _cmd);
    }
}





static inline bool _xenhtml_bm_validate(void *pointer, NSString *name) {
    XENlog(@"DEBUG :: %@ is%@ a valid pointer", name, pointer == NULL ? @" NOT" : @"");
    return pointer != NULL;
}

static __attribute__((constructor)) void _logosLocalCtor_165a0459(int __unused argc, char __unused **argv, char __unused **envp) {
    {}
    
    BOOL sb = [[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.springboard"];
    
    if (sb) {
        
        WebPageProxy$activityStateDidChange = (void (*)(void*, unsigned int, bool, ActivityStateChangeDispatchMode)) $_MSFindSymbolCallable(NULL, "__ZN6WebKit12WebPageProxy22activityStateDidChangeEjbNS0_31ActivityStateChangeDispatchModeE");
        
        if (!_xenhtml_bm_validate((void*)WebPageProxy$activityStateDidChange, @"WebPageProxy::activityStateDidChange"))
            return;

        {Class _logos_class$SpringBoard$XENHWidgetController = objc_getClass("XENHWidgetController"); MSHookMessageEx(_logos_class$SpringBoard$XENHWidgetController, @selector(setPaused:animated:), (IMP)&_logos_method$SpringBoard$XENHWidgetController$setPaused$animated$, (IMP*)&_logos_orig$SpringBoard$XENHWidgetController$setPaused$animated$);Class _logos_class$SpringBoard$WKWebView = objc_getClass("WKWebView"); MSHookMessageEx(_logos_class$SpringBoard$WKWebView, @selector(_isBackground), (IMP)&_logos_method$SpringBoard$WKWebView$_isBackground, (IMP*)&_logos_orig$SpringBoard$WKWebView$_isBackground);{ char _typeEncoding[1024]; sprintf(_typeEncoding, "%s@:", @encode(BOOL)); class_addMethod(_logos_class$SpringBoard$WKWebView, @selector(_xh_isPaused), (IMP)&_logos_method$SpringBoard$WKWebView$_xh_isPaused, _typeEncoding); sprintf(_typeEncoding, "v@:%s", @encode(BOOL)); class_addMethod(_logos_class$SpringBoard$WKWebView, @selector(set_xh_isPaused:), (IMP)&_logos_method$SpringBoard$WKWebView$set_xh_isPaused, _typeEncoding); } }
    }
}