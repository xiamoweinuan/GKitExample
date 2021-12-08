//
//  UINavigationController+FullscreenPopGesture.h
//  FullScreenGest
//
//  Created by ZhiHua Shen on 2018/4/24.
//  Copyright © 2018年 ZhiHua Shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (FullscreenPopGesture)<UIGestureRecognizerDelegate>

@property (nonatomic,strong,readonly) UIPanGestureRecognizer *popGestureRecognizer;

@end
