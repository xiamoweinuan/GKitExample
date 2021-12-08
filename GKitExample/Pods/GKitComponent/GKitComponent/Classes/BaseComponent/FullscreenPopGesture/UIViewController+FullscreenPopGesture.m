//
//  UIViewController+FullscreenPopGesture.m
//  FullScreenGest
//
//  Created by ZhiHua Shen on 2018/4/24.
//  Copyright © 2018年 ZhiHua Shen. All rights reserved.
//

#import "UIViewController+FullscreenPopGesture.h"
#import <objc/runtime.h>

const void *kPrefersNavigationBarHidden = "prefersNavigationBarHidden";
const void *kInteractivePopDisabled = "interactivePopDisabled";

@implementation UIViewController (FullscreenPopGesture)

+ (void)load {
    Method originalMethod = class_getInstanceMethod([self class], @selector(viewWillAppear:));
    Method swizzledMethod = class_getInstanceMethod([self class], @selector(zh_viewWillAppear:));
    
    method_exchangeImplementations(originalMethod, swizzledMethod);
    
    Method originalMethod1 = class_getInstanceMethod([self class], @selector(viewWillDisappear:));
    Method swizzledMethod1 = class_getInstanceMethod([self class], @selector(zh_viewWillDisappear:));
    
    method_exchangeImplementations(originalMethod1, swizzledMethod1);
}

- (void)zh_viewWillAppear:(BOOL)animated {
    [self zh_viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:self.prefersNavigationBarHidden animated:animated];
}

- (void)zh_viewWillDisappear:(BOOL)animated {
    [self zh_viewWillDisappear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIViewController *viewController = self.navigationController.viewControllers.lastObject;
        if (viewController && !viewController.prefersNavigationBarHidden) {
            [self.navigationController setNavigationBarHidden:NO animated:NO];
        }
    });
}

- (BOOL)prefersNavigationBarHidden {
    NSNumber *prefersNavigationBarHidden = objc_getAssociatedObject(self, kPrefersNavigationBarHidden);
    return prefersNavigationBarHidden.boolValue;
}

- (void)setPrefersNavigationBarHidden:(BOOL)prefersNavigationBarHidden {
    objc_setAssociatedObject(self, kPrefersNavigationBarHidden, @(prefersNavigationBarHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)interactivePopDisabled {
    NSNumber *interactivePopDisabled = objc_getAssociatedObject(self, kInteractivePopDisabled);
    return interactivePopDisabled.boolValue;
}

- (void)setInteractivePopDisabled:(BOOL)interactivePopDisabled {
    objc_setAssociatedObject(self, kInteractivePopDisabled, @(interactivePopDisabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
