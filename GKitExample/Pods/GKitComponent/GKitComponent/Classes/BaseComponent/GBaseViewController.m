//
//  DRBaseViewController.m
//  DRLive
//
//  Created by tg on 2020/9/11.
//  Copyright © 2020 DRLive. All rights reserved.
//

#import "GBaseViewController.h"
#import "GHeader.h"
#import "GRouter.h"
//#import "UIButton+LXMImagePosition.h"
@interface GBaseViewController ()
@end

@implementation GBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
     self.navigationController.navigationBar.translucent = NO;//不透明 默认为YES
    self.tabBarController.tabBar.translucent = NO;//不透明 默认为YES
     self.edgesForExtendedLayout = UIRectEdgeNone;//约束viewdidappear后处于nav到tab之间，不延伸
     self.extendedLayoutIncludesOpaqueBars = NO;//默认 为NO仅对不透明生效，不遮挡
    //设置ScrollView偏移量
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
//    如果translucent为YES透明情况下，edgesForExtendedLayout = UIRectEdgeAll
    
    /*
    if (@available(iOS 11.0, *)) {
      translucent = YES透明情况下，如果self.edgesForExtendedLayout = UIRectEdgeNone，想让scrollView延伸到nav下边需要设置
     translucent = YES透明情况下，如果self.edgesForExtendedLayout = UIRectEdgeAll，还未滚动时就会被navigationBar遮挡住
        scrollView最顶部内容出现在navigationBar下面，并且在往上滚动时能够透过navigationBar看到滚动上去的view的内容（实际上就是给view增加了内边距contentInset）
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
     
     
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    } else {
    scrollView最顶部内容出现在navigationBar下面，并且在往上滚动时能够透过navigationBar看到滚动上去的view的内容（实际上就是给view增加了内边距contentInset）
        self.automaticallyAdjustsScrollViewInsets = NO;默认值是YES
    }
     */
    
 
    

    self.view.backgroundColor = [UIColor whiteColor];//解决push的时候卡顿一下
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kColorStringHex(@"#000000"),NSFontAttributeName:[UIFont systemFontOfSize:5]}];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];//去掉分可先

    if (self.navigationController.viewControllers.count>1) {
        [self setNavBackItemWithBlock:^{
            
        }];
    }
    // Do any additional setup after loading the view.
}
-(void)setNavBackItemWithBlock:(void  (^)( void ))block{
//        self.navigationController.navigationBar.barTintColor = kCommondMinBGColor;
    
//        WEAKSELF
        [self  setNavigationItem:^(ButtonItemCoutum *button) {
//          button.g_ImageName_Normal(@"common_backWhite");
            button.frame = CGRectMake(0, 0, 20, 20);
            button.type = Type_Left;
//            [button setImagePosition:LXMImagePositionLeft spacing:22];
        } withBlock:^(TypeItem type) {
//            [weakSelf popCanvas];
            [[GRouter shard]popCanvas];
            if (block) {
                block();
            }
        }];
}
- (void)dealloc {
    NSLog(@"------%@ dealloc-------",NSStringFromClass([self class]));
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
