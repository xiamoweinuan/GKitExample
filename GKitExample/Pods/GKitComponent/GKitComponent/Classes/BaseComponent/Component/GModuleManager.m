//
//  GModuleManager.m
//  Pods
//
//  Created by gs on 2017/7/17.
//
//

#import "GModuleManager.h"

#import <objc/runtime.h>
#import <objc/message.h>


#define ADD_SELECTOR_PREFIX(__SELECTOR__) @selector(gmodule_##__SELECTOR__)

#define SWIZZLE_DELEGATE_METHOD(__SELECTORSTRING__) \
Swizzle([delegate class], @selector(__SELECTORSTRING__), class_getClassMethod([GModuleManager class], ADD_SELECTOR_PREFIX(__SELECTORSTRING__))); \

#define APPDELEGATE_METHOD_MSG_SEND(__SELECTOR__, __ARG1__, __ARG2__) \
for (Class cls in JKModuleClasses) { \
if ([cls respondsToSelector:__SELECTOR__]) { \
[cls performSelector:__SELECTOR__ withObject:__ARG1__ withObject:__ARG2__]; \
} \
} \
\
for (id obj in JKModuleObjects) { \
id target = [obj nonretainedObjectValue];\
if ([target respondsToSelector:__SELECTOR__]) { \
[target performSelector:__SELECTOR__ withObject:__ARG1__ withObject:__ARG2__]; \
} \
}


#define SELECTOR_IS_EQUAL(__SELECTOR1__, __SELECTOR2__) \
Method m1 = class_getClassMethod([GModuleManager class], __SELECTOR1__); \
IMP imp1 = method_getImplementation(m1); \
Method m2 = class_getInstanceMethod([self class], __SELECTOR2__); \
IMP imp2 = method_getImplementation(m2); \

#define DEF_APPDELEGATE_METHOD_CONTAIN_RESULT(__ARG1__, __ARG2__) \
BOOL result = YES; \
SEL jk_selector = NSSelectorFromString([NSString stringWithFormat:@"gmodule_%@", NSStringFromSelector(_cmd)]); \
SELECTOR_IS_EQUAL(jk_selector, _cmd) \
if (imp1 != imp2) { \
result = !![self performSelector:jk_selector withObject:__ARG1__ withObject:__ARG2__]; \
} \
APPDELEGATE_METHOD_MSG_SEND(_cmd, __ARG1__, __ARG2__); \
return result; \

#define DEF_APPDELEGATE_METHOD(__ARG1__, __ARG2__) \
SEL jk_selector = NSSelectorFromString([NSString stringWithFormat:@"gmodule_%@", NSStringFromSelector(_cmd)]); \
SELECTOR_IS_EQUAL(jk_selector, _cmd) \
if (imp1 != imp2) { \
[self performSelector:jk_selector withObject:__ARG1__ withObject:__ARG2__]; \
} \
APPDELEGATE_METHOD_MSG_SEND(_cmd, __ARG1__, __ARG2__); \




#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

void Swizzle(Class class, SEL originalSelector, Method swizzledMethod)
{
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    SEL swizzledSelector = method_getName(swizzledMethod);

    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));

    if (didAddMethod && originalMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    //
    class_addMethod(class,
                    swizzledSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
}

@implementation UIApplication (GModuleManager)
- (void)module_setDelegate:(id<UIApplicationDelegate>) delegate
{

    static dispatch_once_t delegateOnceToken;
    dispatch_once(&delegateOnceToken, ^{
        SWIZZLE_DELEGATE_METHOD(applicationDidFinishLaunching:);
        SWIZZLE_DELEGATE_METHOD(application: willFinishLaunchingWithOptions:);
        SWIZZLE_DELEGATE_METHOD(application: didFinishLaunchingWithOptions:);
        SWIZZLE_DELEGATE_METHOD(applicationDidBecomeActive:)
        SWIZZLE_DELEGATE_METHOD(applicationWillResignActive:)
        SWIZZLE_DELEGATE_METHOD(application: openURL: options:)
        SWIZZLE_DELEGATE_METHOD(application: handleOpenURL:)
        SWIZZLE_DELEGATE_METHOD(application: openURL: sourceApplication: annotation:)
        SWIZZLE_DELEGATE_METHOD(applicationDidReceiveMemoryWarning:)
        SWIZZLE_DELEGATE_METHOD(applicationWillTerminate:)
        SWIZZLE_DELEGATE_METHOD(applicationSignificantTimeChange:);
        SWIZZLE_DELEGATE_METHOD(application: didRegisterForRemoteNotificationsWithDeviceToken:)
        SWIZZLE_DELEGATE_METHOD(application: didFailToRegisterForRemoteNotificationsWithError:)
        SWIZZLE_DELEGATE_METHOD(application: didReceiveRemoteNotification:)
        SWIZZLE_DELEGATE_METHOD(application: didReceiveLocalNotification:)
        SWIZZLE_DELEGATE_METHOD(application: handleEventsForBackgroundURLSession: completionHandler:)
        SWIZZLE_DELEGATE_METHOD(application: handleWatchKitExtensionRequest: reply:)
        SWIZZLE_DELEGATE_METHOD(applicationShouldRequestHealthAuthorization:)
        SWIZZLE_DELEGATE_METHOD(applicationDidEnterBackground:)
        SWIZZLE_DELEGATE_METHOD(applicationWillEnterForeground:)
        SWIZZLE_DELEGATE_METHOD(applicationProtectedDataWillBecomeUnavailable:)
        SWIZZLE_DELEGATE_METHOD(applicationProtectedDataDidBecomeAvailable:)

        SWIZZLE_DELEGATE_METHOD(remoteControlReceivedWithEvent:)
    });
    [self module_setDelegate:delegate];
}
@end

BOOL GModuleManagerClassIsRegistered(Class cls)
{
    return [objc_getAssociatedObject(cls, &GModuleManagerClassIsRegistered) ?: @YES boolValue];
}

BOOL GModuleManagerObjectIsRegistered(id x)
{
    return [objc_getAssociatedObject(x, &GModuleManagerObjectIsRegistered) ?: @YES boolValue];
}

static NSMutableArray<Class> *JKModuleClasses;

static NSMutableArray<id> *JKModuleObjects;

@interface GModuleManager()

@property (nonatomic) NSMutableDictionary *routes;

@end

@implementation GModuleManager


+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Swizzle([UIApplication class], @selector(setDelegate:), class_getInstanceMethod([UIApplication class], @selector(module_setDelegate:)));
    });
}

+ (instancetype)sharedIsntance
{
    static GModuleManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+ (void)registerAppDelegateModule:(Class) moduleClass
{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        JKModuleClasses = [NSMutableArray new];
    });

    // Register module
    [JKModuleClasses addObject:moduleClass];

    objc_setAssociatedObject(moduleClass, &GModuleManagerClassIsRegistered,
                             @NO, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void) registerAppDelegateObject:(nonnull id) obj
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        JKModuleObjects = [NSMutableArray new];
    });

    // Register module
    [JKModuleObjects addObject:[NSValue valueWithNonretainedObject:obj]];

    objc_setAssociatedObject(obj, &GModuleManagerObjectIsRegistered,
                             @NO, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void) unregisterAppDelegateObject:(nonnull id) obj
{
    for (int i = 0; i < JKModuleObjects.count ; i++) {
        NSValue *currentValue = JKModuleObjects[i];
        id currentObj = [currentValue nonretainedObjectValue];
        if (currentObj == nil || currentObj == obj) {
            [JKModuleObjects removeObject:currentValue];
            i--;
        }
    }

    //以安全的方式移除相关关联，而不是移除所有关联
    objc_setAssociatedObject(obj, &GModuleManagerObjectIsRegistered,
                             nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - AppDelegate

+ (void)gmodule_applicationDidFinishLaunching:(UIApplication *)application
{
    DEF_APPDELEGATE_METHOD(application, NULL);
}

+ (BOOL)gmodule_application:(UIApplication *)application willFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions
{
    DEF_APPDELEGATE_METHOD_CONTAIN_RESULT(application, launchOptions);
}

+ (BOOL)gmodule_application:(UIApplication *)application didFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions
{
   DEF_APPDELEGATE_METHOD_CONTAIN_RESULT(application, launchOptions);

}

+ (void)gmodule_applicationDidBecomeActive:(UIApplication *)application
{
    DEF_APPDELEGATE_METHOD(application, NULL);
}
+ (void)gmodule_applicationWillResignActive:(UIApplication *)application
{
    DEF_APPDELEGATE_METHOD(application, NULL);
}
+ (BOOL)gmodule_application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options NS_AVAILABLE_IOS(9_0); // no equiv. notification. return NO if the application can't open for some reaso
{
    BOOL result = YES;
    SEL jk_selector = NSSelectorFromString([NSString stringWithFormat:@"gmodule_%@", NSStringFromSelector(_cmd)]);
    SELECTOR_IS_EQUAL(jk_selector, _cmd)
    if (imp1 != imp2) {
        result = ((BOOL (*)(id, SEL, id, id, id))(void *)objc_msgSend)(self, jk_selector, app, url, options);
    }
    BOOL (*typed_msgSend)(id, SEL, id, id, id) = (void *)objc_msgSend;
    for (Class cls in JKModuleClasses) {
        if ([cls respondsToSelector:_cmd]) {
            typed_msgSend(cls, _cmd, app, url, options);
        }
    }

    for (NSValue * obj in JKModuleObjects) {
        id target = [obj nonretainedObjectValue];
        if ([target respondsToSelector:_cmd]) {
            typed_msgSend(target, _cmd, app, url, options);
        }
    }
    return result;
}

+ (BOOL)gmodule_application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    DEF_APPDELEGATE_METHOD_CONTAIN_RESULT(application, url);
}

+ (BOOL)gmodule_application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = YES;
    SEL jk_selector = NSSelectorFromString([NSString stringWithFormat:@"gmodule_%@", NSStringFromSelector(_cmd)]);
    SELECTOR_IS_EQUAL(jk_selector, _cmd)
    if (imp1 != imp2) {
        result = ((BOOL (*)(id, SEL, id, id, id, id))(void *)objc_msgSend)(self, jk_selector, application, url, sourceApplication, annotation);
    }
    BOOL (*typed_msgSend)(id, SEL, id, id, id, id) = (void *)objc_msgSend;
    for (Class cls in JKModuleClasses) {
        if ([cls respondsToSelector:_cmd]) {
            typed_msgSend(cls, _cmd, application, url, sourceApplication, annotation);
        }
    }

    for (NSValue * obj in JKModuleObjects) {
        id target = [obj nonretainedObjectValue];
        if ([target respondsToSelector:_cmd]) {
            typed_msgSend(target, _cmd, application, url, sourceApplication, annotation);
        }
    }
    return result;
}

+ (void)gmodule_applicationDidReceiveMemoryWarning:(UIApplication *)application;      // try to clean up as much memory as possible. next step is to terminate ap
{
    DEF_APPDELEGATE_METHOD(application, NULL);
}
+ (void)gmodule_applicationWillTerminate:(UIApplication *)application
{
    DEF_APPDELEGATE_METHOD(application, NULL);
}
+ (void)gmodule_applicationSignificantTimeChange:(UIApplication *)application;        // midnight, carrier time update, daylight savings time chang
{
    DEF_APPDELEGATE_METHOD(application, NULL);
}
+ (void)gmodule_application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken NS_AVAILABLE_IOS(3_0)
{
    DEF_APPDELEGATE_METHOD(application, deviceToken);
}
+ (void)gmodule_application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error NS_AVAILABLE_IOS(3_0)
{
    DEF_APPDELEGATE_METHOD(application, error);
}
+ (void)gmodule_application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo NS_AVAILABLE_IOS(3_0)
{
    DEF_APPDELEGATE_METHOD(application, userInfo);
}
+ (void)gmodule_application:(UIApplication *)application didReceiveLocalNotification:(NSDictionary *)userInfo NS_AVAILABLE_IOS(3_0)
{
    DEF_APPDELEGATE_METHOD(application, userInfo);
}
+ (void)gmodule_application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler NS_AVAILABLE_IOS(7_0)
{
    SEL jk_selector = NSSelectorFromString([NSString stringWithFormat:@"gmodule_%@", NSStringFromSelector(_cmd)]);
    SELECTOR_IS_EQUAL(jk_selector, _cmd)
    if (imp1 != imp2) {
        ((void (*)(id, SEL, id, id, id))(void *)objc_msgSend)(self, jk_selector, application, identifier, completionHandler);
    }
    void (*typed_msgSend)(id, SEL, id, id, id) = (void *)objc_msgSend;
    for (Class cls in JKModuleClasses) {
        if ([cls respondsToSelector:_cmd]) {
            typed_msgSend(cls, _cmd, application, identifier, completionHandler);
        }
    }

    for (NSValue * obj in JKModuleObjects) {
        id target = [obj nonretainedObjectValue];
        if ([target respondsToSelector:_cmd]) {
            typed_msgSend(target, _cmd, application, identifier, completionHandler);
        }
    }
}
+ (void)gmodule_application:(UIApplication *)application handleWatchKitExtensionRequest:(nullable NSDictionary *)userInfo reply:(void(^)(NSDictionary * __nullable replyInfo))reply NS_AVAILABLE_IOS(8_2)
{
    SEL jk_selector = NSSelectorFromString([NSString stringWithFormat:@"gmodule_%@", NSStringFromSelector(_cmd)]);
    SELECTOR_IS_EQUAL(jk_selector, _cmd)
    if (imp1 != imp2) {
        ((void (*)(id, SEL, id, id, id))(void *)objc_msgSend)(self, jk_selector, application, userInfo, reply);
    }
    void (*typed_msgSend)(id, SEL, id, id, id) = (void *)objc_msgSend;
    for (Class cls in JKModuleClasses) {
        if ([cls respondsToSelector:_cmd]) {
            typed_msgSend(cls, _cmd, application, userInfo, reply);
        }
    }

    for (NSValue * obj in JKModuleObjects) {
        id target = [obj nonretainedObjectValue];
        if ([target respondsToSelector:_cmd]) {
            typed_msgSend(target, _cmd, application, userInfo, reply);
        }
    }
}
+ (void)gmodule_applicationShouldRequestHealthAuthorization:(UIApplication *)application NS_AVAILABLE_IOS(9_0)
{
    DEF_APPDELEGATE_METHOD(application, NULL);
}
+ (void)gmodule_applicationDidEnterBackground:(UIApplication *)application NS_AVAILABLE_IOS(4_0)
{
    DEF_APPDELEGATE_METHOD(application, NULL);
}
+ (void)gmodule_applicationWillEnterForeground:(UIApplication *)application NS_AVAILABLE_IOS(4_0)
{
    DEF_APPDELEGATE_METHOD(application, NULL);
}
+ (void)gmodule_applicationProtectedDataWillBecomeUnavailable:(UIApplication *)application NS_AVAILABLE_IOS(4_0)
{
    DEF_APPDELEGATE_METHOD(application, NULL);
}
+ (void)gmodule_applicationProtectedDataDidBecomeAvailable:(UIApplication *)application    NS_AVAILABLE_IOS(4_0)
{
    DEF_APPDELEGATE_METHOD(application, NULL);
}

+ (void)gmodule_remoteControlReceivedWithEvent:(UIEvent *)event{
    DEF_APPDELEGATE_METHOD(event, NULL);
}


@end


#pragma clang diagnostic pop

#pragma clang diagnostic pop

