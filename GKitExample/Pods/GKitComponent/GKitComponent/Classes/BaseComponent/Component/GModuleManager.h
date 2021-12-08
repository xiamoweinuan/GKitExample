//
//  GModuleManager.h
//  Pods
//
//  Created by gs on 2017/7/17.
//
//

#import <Foundation/Foundation.h>

#define GModuleManager_EXTERN() \
+ (void)load \
{ \
[GModuleManager registerAppDelegateModule:self]; \
if ([self respondsToSelector:@selector(__gmodule_load)]) { \
[self performSelector:@selector(__gmodule_load)]; \
} \
} \
+ (void)__gmodule_load \

@interface GModuleManager : NSObject


+ (void) registerAppDelegateModule:(nonnull Class) moduleClass;

+ (void) registerAppDelegateObject:(nonnull id) obj;

+ (void) unregisterAppDelegateObject:(nonnull id) obj;


@end
