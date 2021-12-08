//
//  GBaseNavViewController.m
//  DRLive
//
//  Created by tg on 2020/9/11.
//  Copyright © 2020 DRLive. All rights reserved.
//

#import "GBaseNavViewController.h"
//#import "UIView+GradualLayer.h"
@class GHeader;
@interface GBaseNavViewController ()<UIGestureRecognizerDelegate>

@end

@implementation GBaseNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];//防止构建的试图没有默认颜色导致变成黑色
       [[UINavigationBar appearance] setTranslucent:NO];
       //背景色
//       [[UINavigationBar appearance] setBarTintColor:kColorMaimLight];
       //标题字体
       [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:19],NSFontAttributeName, nil ]];
    
//    UIView* backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kTopHeight)];

//     [backgroundView  addGradualLayerWithColors:@[(__bridge id)kColorStringHex(@"#12c2e9").CGColor,(__bridge id)kColorStringHex(@"#c471ed").CGColor,(__bridge id)kColorStringHex(@"#f64f59").CGColor] withEndPoint:CGPointMake(1, 0) withFrame:[UIApplication sharedApplication].delegate.window.bounds];
    //调用UIView 类扩展方法
//    [backgroundView addGradualLayerWithColors:@[(__bridge id)kColorStringHex(@"#7F00FF").CGColor,(__bridge id)kColorStringHex(@"#E100FF").CGColor]];
//    [backgroundView addGradualLayerWithColors:nil];
    
//    UIImage *backImage = [self convertViewToImage:backgroundView];
//    [self.navigationBar setBackgroundImage:backImage forBarMetrics:UIBarMetricsDefault];
    self.statusBarStyle = UIStatusBarStyleLightContent;
    // Do any additional setup after loading the view.
}
- (UIImage*)convertViewToImage:(UIView*)view{
    CGSize s = view.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return self.statusBarStyle;
}
- (BOOL)prefersStatusBarHidden{
    return NO;
}
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation{
    return UIStatusBarAnimationNone;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [super pushViewController:viewController animated:animated];
    [self.navigationItem.backBarButtonItem setTintColor:[UIColor whiteColor]];
    
    //开启iOS7的滑动返回效果
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = self;
    }

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
