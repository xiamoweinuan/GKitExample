//
//  FMModAppDelegate.h
//  CCRouter
//
//  Created by Chonghua Yu on 2018/11/8.
//  Copyright © 2018 keruyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//所有容器内的注册的组件必须遵循的协议

@protocol GModProtocol <NSObject>

@required
- (UIViewController *)rootViewControllerForMod;
- (UIView *)rootView;

@optional

- (void)modDidFinishLaunchingWithOptions:(NSDictionary *)options;
- (void)modDidFinishLaunchingWithOptions:(NSDictionary *)options withBlock:(void (^)(UIView*))block;

- (void)modInitWithBlock:(void (^)(id))block;

- (void)modWillResignActive;

- (void)modDidEnterBackground;

- (void)modWillEnterForeground;

- (void)modDidBecomeActive;

- (void)modWillTerminate;

- (void)modDidReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

@end
