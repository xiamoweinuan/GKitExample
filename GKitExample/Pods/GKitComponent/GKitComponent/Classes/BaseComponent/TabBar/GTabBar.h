//
//  DRTabBar.h
//  DRLive
//
//  Created by tg on 2020/9/10.
//  Copyright © 2020 DRLive. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol DRLTabBarDelegate <NSObject>
/** 选中tabbar */
- (BOOL)willSelectedJZLTabBarItemAtIndex:(NSInteger)index;
/** 选中tabbar */
- (void)selectedJZLTabBarItemAtIndex:(NSInteger)index;
/** 中心tabbar点击 */
- (void)selectedJZLTabBarCenter;
@end

@interface GTabBar : UITabBar
@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *selectedImageArray;
@property (nonatomic, strong) NSArray *animuteImageArray;
@property (nonatomic, weak) id<DRLTabBarDelegate> JZLTabBarDelegate;



/** 实例化 */
+ (instancetype)tabBarWithFrame:(CGRect)frame titleArray:(NSArray <NSString *> *)titleArray imageArray:(NSArray <NSString *>*)imageArray selectedImageArray:(NSArray <NSString *> *)selectedImageArray withAnimateImages:(NSArray <NSArray *>*)animateArray withCenterImage:(UIImage*)centerImage;
@end
NS_ASSUME_NONNULL_END
