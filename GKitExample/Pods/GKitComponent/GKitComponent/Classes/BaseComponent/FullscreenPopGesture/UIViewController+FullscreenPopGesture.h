//
//  UIViewController+FullscreenPopGesture.h
//  FullScreenGest
//
//  Created by ZhiHua Shen on 2018/4/24.
//  Copyright © 2018年 ZhiHua Shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (FullscreenPopGesture)
//导航条是否隐藏，默认NO
@property (nonatomic,assign) BOOL prefersNavigationBarHidden;
//当前控制器是否开启手势,默认NO
@property (nonatomic,assign) BOOL interactivePopDisabled;

@end

/*
 - (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
 
 if (self.contentOffset.x <= 0) {
 if ([otherGestureRecognizer.delegate isKindOfClass:NSClassFromString(@"UINavigationController")]) {
 return YES;
 }
 }
 return NO;;
 }
 */
