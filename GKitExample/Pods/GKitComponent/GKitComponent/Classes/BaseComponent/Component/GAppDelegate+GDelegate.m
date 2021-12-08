//
//  GAppDelegate+GLanguage.m
//  GKitComponent
//
//  Created by gaoshuang on 2021/12/7.
//

#import "GAppDelegate+GDelegate.h"
#import "NSObject+swizzle.h"
#import "GBaseNavViewController.h"
#import "GBaseViewController.h"
#import "GTabBarController.h"
#import "GRouter.h"

@implementation GAppDelegate (GDelegate)

- (BOOL)applicationExchangeMethod:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self applicationExchangeMethod:application didFinishLaunchingWithOptions:launchOptions];
    
    
    [self setupTabBarRootViewController:0  WithBlock:nil];
    
    
    [self.window makeKeyAndVisible];
    
    return  YES;
}
-(void)setupTabBarRootViewController:(NSInteger)index WithBlock:(void (^)(void))block{
    
    
    if ([UIApplication sharedApplication].delegate.window) {//可能释放不了，可以loginvc当作window或者子vc
        
        [[UIApplication sharedApplication].delegate.window.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [UIApplication sharedApplication].delegate.window.rootViewController =nil;
    }
    GTabBarController* tab = nil;
    if ([self respondsToSelector:@selector(getRootViewController)]) {
        
        tab = [self getRootViewController];
    }else{
        
        tab  =[[GTabBarController alloc]initWithTabBarControlerWithChildVCArray:@[[[GRouter shard] findModWithName:@"GBaseViewController"],[[GRouter shard] findModWithName:@"GBaseViewController"],[[GRouter shard] findModWithName:@"GBaseViewController"],[[GRouter shard] findModWithName:@"GBaseViewController"]]
                                                                     titleArray:@[@"1",@"2",@"3",@"4"]
                                                                     imageArray:@[]
                                                             selectedImageArray:@[]
                                                              withAnimateImages:@[]];
    }
    
    
    // 设置一个自定义 View,大小等于 tabBar 的大小
    UIView *bgView = [[UIView alloc] initWithFrame:tab.tabBar.bounds];
    // 给自定义 View 设置颜色
    bgView.backgroundColor = [UIColor lightGrayColor];
    // 将自定义 View 添加到 tabBar 上
    [tab.drTabBar insertSubview:bgView atIndex:0];
    if (index !=0) {
        tab.selectedIndex = index;
    }
    [UIView transitionWithView:[UIApplication sharedApplication].delegate.window
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        [UIApplication sharedApplication].delegate.window.rootViewController = tab;
        [UIView setAnimationsEnabled:oldState];
    } completion:^(BOOL finished) {
        
    }];
    
    
    
}
+ (void)load {
    //SceneDelegate暂时用不到
#if __has_include("SceneDelegate.h")
    [[SceneDelegate class] swizzingMethod:@selector(scene:willConnectToSession:options:) withMethod:@selector(sceneExchangeMethod:willConnectToSession:options:)];
#endif



    [self swizzingMethod:@selector(application:didFinishLaunchingWithOptions:) withMethod:@selector(applicationExchangeMethod:didFinishLaunchingWithOptions:)];
}
@end
