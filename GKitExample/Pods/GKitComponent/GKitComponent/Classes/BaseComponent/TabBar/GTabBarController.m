//
//  DRTabBarController.m
//  DRLive
//
//  Created by tg on 2020/9/10.
//  Copyright © 2020 DRLive. All rights reserved.
//

#import "GTabBarController.h"
#import "GBaseViewController.h"
#import "GTabBarItem.h"
#import "GBaseNavViewController.h"
#import "GRouter.h"
@interface GTabBarController ()<DRLTabBarDelegate>
@property (nonatomic, strong) NSArray *vcArray;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *selectedImageArray;
@property (nonatomic, strong) NSArray *animuteImageArray;
@end

@implementation GTabBarController

- (instancetype)initWithTabBarControlerWithChildVCArray:(NSArray <UIViewController *>*)childVCArray titleArray:(NSArray <NSString *> *)titleArray imageArray:(NSArray <NSString *>*)imageArray selectedImageArray:(NSArray <NSString *> *)selectedImageArray withAnimateImages:(NSArray <NSArray *>*)animateArray{
    
    self = [super init];
    if (self) {
        _vcArray = childVCArray;
        _titleArray = titleArray;
        _imageArray = imageArray;
        _selectedImageArray = selectedImageArray;
        _animuteImageArray = animateArray;
        [self createTabBarControlerWithChildVCArray:_vcArray titleArray:_titleArray imageArray:_imageArray selectedImageArray:_selectedImageArray withAnimateImages:_animuteImageArray];

    }
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor  = [UIColor whiteColor];
    
    
    
    
    
    //隐藏分割线
    [UITabBar appearance].clipsToBounds = YES;
    // Do any additional setup after loading the view.
    
    
}
- (void)createTabBarControlerWithChildVCArray:(NSArray <UIViewController *>*)childVCArray titleArray:(NSArray <NSString *> *)titleArray imageArray:(NSArray <NSString *>*)imageArray selectedImageArray:(NSArray <NSString *> *)selectedImageArray withAnimateImages:(NSArray <NSArray *>*)animateArray {
    self.selectedIndex = 0;

    NSMutableArray* arrayVc = @[].mutableCopy;
    for (UIViewController *viewController in childVCArray) {
        
        [[GRouter shard]addMod:viewController];
        GBaseNavViewController *navigationController = [[GBaseNavViewController alloc] initWithRootViewController:viewController];
        [arrayVc addObject:navigationController];
    }
    self.drTabBar = [GTabBar tabBarWithFrame:self.tabBar.bounds titleArray:titleArray imageArray:imageArray selectedImageArray:selectedImageArray withAnimateImages:animateArray withCenterImage:[UIImage imageNamed:@"tab_center"]];
    self.drTabBar.JZLTabBarDelegate = self;
    //    // 设置一个自定义 View,大小等于 tabBar 的大小
    //    UIView *bgView = [[UIView alloc] initWithFrame:self.tabBar.bounds];
    //    // 给自定义 View 设置颜色
    //    bgView.backgroundColor = kWhiteColor;
    //    // 将自定义 View 添加到 tabBar 上
    //    [self.drTabBar insertSubview:bgView atIndex:0];
    
    /*
     //设置背景
     [self.drTabBar setBackgroundImage:[[UIImage alloc]init]];
     [self.drTabBar setBackgroundImage:[self imageWithColor:[UIColor redColor]]];
     */
    
    
    
    [self setValue:self.drTabBar forKeyPath:@"tabBar"];
    self.viewControllers = arrayVc;
    self.selectedIndex = 0;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - cansTabBarDelegate
- (void)selectedJZLTabBarItemAtIndex:(NSInteger)index {
    self.selectedIndex = index;
}

-(BOOL)willSelectedJZLTabBarItemAtIndex:(NSInteger)index{
    //    GBaseNavViewController* vc =  self.viewControllers[index];
    
    //    if (![ vc.topViewController isKindOfClass:[HomeViewController class]]
    
    
    return YES;
}
- (void)selectedJZLTabBarCenter{
    
    
}
#pragma mark - 重写selectedIndex的set方法
- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    [super setSelectedIndex:selectedIndex];
    self.drTabBar.selectedIndex = selectedIndex;
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
