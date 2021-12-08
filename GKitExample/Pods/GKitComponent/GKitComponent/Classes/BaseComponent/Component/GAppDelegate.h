//
//  GAppDelegate.h
//  GKitComponent
//
//  Created by gaoshuangone@qq.com on 12/07/2021.
//  Copyright (c) 2021 gaoshuangone@qq.com. All rights reserved.
//

@import UIKit;
@protocol AppDelegateProtocol <NSObject>
@optional
/**子类可以实现这个这个方法自定义tabbarController*/
-(id)getRootViewController;

@end
/**UIApplicationMain中直接加载使用或者
 子类中调用  [super application:application didFinishLaunchingWithOptions:launchOptions];
 */
@interface GAppDelegate : UIResponder <UIApplicationDelegate,AppDelegateProtocol>

@property (strong, nonatomic) UIWindow *window;

@end


