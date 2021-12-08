//
//  UINavigationController+FullscreenPopGesture.m
//  FullScreenGest
//
//  Created by ZhiHua Shen on 2018/4/24.
//  Copyright © 2018年 ZhiHua Shen. All rights reserved.
//

#import "UINavigationController+FullscreenPopGesture.h"
#import "UIViewController+FullscreenPopGesture.h"
#import <objc/runtime.h>

@implementation UINavigationController (FullscreenPopGesture) 

+ (void)load {
    Method originalMethod = class_getInstanceMethod([self class], @selector(pushViewController:animated:));
    Method swizzledMethod = class_getInstanceMethod([self class], @selector(zh_pushViewController:animated:));
    
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (void)zh_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    //添加手势
    if (![self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.popGestureRecognizer]) {
        
        [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.popGestureRecognizer];
        
        NSArray *targets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
        id internalTarget = [targets.firstObject valueForKey:@"target"];
        SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");

        self.popGestureRecognizer.delegate = self;
        [self.popGestureRecognizer addTarget:internalTarget action:internalAction];
    }
    
    //判断全局手势是否开启，否则开启边缘手势
    self.interactivePopGestureRecognizer.enabled = !self.popGestureRecognizer.enabled;
    
    if (![self.viewControllers containsObject:viewController]) {
        [self zh_pushViewController:viewController animated:animated];
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    
    if (self.viewControllers.count <= 1) {
        return NO;
    }
    
    if (self.topViewController.interactivePopDisabled) {
        return NO;
    }
    
    if ([[self valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    if (translation.x <= 0) {
        return NO;
    }
    
    return YES;
}

- (UIPanGestureRecognizer *)popGestureRecognizer {
    UIPanGestureRecognizer *panGestureRecognizer = objc_getAssociatedObject(self, _cmd);
    
    if (panGestureRecognizer == nil) {
        panGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
        panGestureRecognizer.maximumNumberOfTouches = 1;
        
        objc_setAssociatedObject(self, _cmd, panGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return panGestureRecognizer;
}

//需要重写scrollVeiw
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//
//    if (self.scrollView.contentOffset.x <= 0) {
//        if ([otherGestureRecognizer.delegate isKindOfClass:NSClassFromString(@"UINavigationController")]) {
//            return YES;
//        }
//    }
//    return NO;
//}
@end
