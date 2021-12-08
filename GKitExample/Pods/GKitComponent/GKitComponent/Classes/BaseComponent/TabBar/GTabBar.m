//
//  DRTabBar.m
//  DRLive
//
//  Created by tg on 2020/9/10.
//  Copyright © 2020 DRLive. All rights reserved.
//

#import "GTabBar.h"
#import "GTabBarItem.h"
#import "UITabBar+GBadge.h"
#import "GMacros.h"
@interface GTabBar()
@property (nonatomic, strong) UIButton *centerBtn;
/**
  中间按钮图片
 */
@property (nonatomic, strong) UIImage *centerImage;
/**
  中间按钮偏移量，默认是居中
 */
@property (nonatomic, assign) CGFloat centerOffsetY;

/**
  中间按钮的宽和高，默认使用图片宽高
*/
@property (nonatomic, assign) CGFloat centerWidth, centerHeight;
@end
@implementation GTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

//删除系统tabbar的UITabBarButton
- (void)layoutSubviews {
    [super layoutSubviews];
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [view removeFromSuperview];
        }
    }
//    self.layer.masksToBounds = NO;
  //  _centerBtn.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - _centerWidth)/2.0,  -10, _centerWidth, _centerHeight);
  _centerBtn.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - _centerWidth)/2.0, 0, _centerWidth, _centerHeight);
    _centerBtn.layer.shadowPath = [UIBezierPath bezierPathWithRect:_centerBtn.bounds].CGPath;//阴影的位置
    _centerBtn.layer.cornerRadius = _centerWidth/2;
    
}

+ (instancetype)tabBarWithFrame:(CGRect)frame titleArray:(NSArray <NSString *> *)titleArray imageArray:(NSArray <NSString *>*)imageArray selectedImageArray:(NSArray <NSString *> *)selectedImageArray withAnimateImages:(NSArray <NSArray *>*)animateArray withCenterImage:(UIImage* )centerImage{
    GTabBar *tabBar = [[GTabBar alloc] initWithFrame:frame];
    tabBar.titleArray = titleArray;
    tabBar.imageArray = imageArray;
    tabBar.animuteImageArray = animateArray;
    tabBar.selectedImageArray = selectedImageArray;
    tabBar.centerImage = centerImage;
    [tabBar setupUI];
    return tabBar;
    
    
}

- (void)setupUI {
  
//    self.tintColor = kRedColor;
//    self.backgroundColor = [UIColor whiteColor];
    CGFloat  dis = 0;
    for (int i = 0; i < self.titleArray.count; i++) {
        
        dis =i * (kMainScreenWide / self.titleArray.count);
        if (_centerBtn && self.titleArray.count==4 && (i==1||i==2)) {
          dis =i * ((kMainScreenWide-_centerWidth) / self.titleArray.count);
            if (i==1) {
                dis-=6;
            }else if(i==2){
                dis+=_centerWidth+6;

            }
        }
        
        GTabBarItem *item = [[GTabBarItem alloc] initWithFrame:CGRectMake(dis, 0, (kMainScreenWide / self.titleArray.count), 49)];
                
        if (self.imageArray.count>i) {
       
            item.imgView.image = [UIImage imageNamed:self.imageArray[i]];
            item.selectedImgView.image = [UIImage imageNamed:self.selectedImageArray[i]];
            
        }
            item.selectedImgView.animationDuration = 0.6f;
            item.selectedImgView.animationRepeatCount = 1;
            item.titleLbl.text = self.titleArray[i];
            item.tag = i ;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemAction:)];
            [item addGestureRecognizer:tap];
        
        [self addSubview:item];
        [self.itemArray addObject:item];
    }
    self.selectedIndex = 0;
}


- (void)itemAction:(UITapGestureRecognizer *)sender {
    BOOL isCanAction = YES;
    if ([self.JZLTabBarDelegate respondsToSelector:@selector(willSelectedJZLTabBarItemAtIndex:)]) {
        isCanAction =   [self.JZLTabBarDelegate willSelectedJZLTabBarItemAtIndex:sender.view.tag];
    }
    
    if (isCanAction) {
          self.selectedIndex = sender.view.tag;
          if ([self.JZLTabBarDelegate respondsToSelector:@selector(selectedJZLTabBarItemAtIndex:)]) {
              [self.JZLTabBarDelegate selectedJZLTabBarItemAtIndex:sender.view.tag];
          }
    }
  
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {

    [self.itemArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GTabBarItem *item = (GTabBarItem *)obj;
        if (idx == selectedIndex) {
            item.selected = YES;
        }else {
            item.selected = NO;
        }
    }];
    _selectedIndex = selectedIndex;
    
}

#pragma mark - 设置角标
- (void)showBadge:(NSString *)badge atIndex:(NSInteger)index {
    [super showBadge:badge atIndex:index];
    if (index >= self.itemArray.count) {
        return;
    }
    GTabBarItem * item = self.itemArray[index];
    //角标为0,自动隐藏
    if ([badge integerValue] == 0) {
        item.badgeLbl.hidden = YES;
    }else {
        item.badgeLbl.hidden = NO;
        item.badgeLbl.text = badge;
    }
    [item setNeedsLayout];
    [item layoutIfNeeded];
    
}

#pragma mark - 自定义角标颜色和背景颜色
- (void)showBadge:(NSString *)badge badgeColor:(UIColor *)badgeColor badgeBackgroundColor:(UIColor *)backgroundColor atIndex:(NSInteger)index {
    [super showBadge:badge badgeColor:badgeColor badgeBackgroundColor:backgroundColor atIndex:index];
    if (index >= self.itemArray.count) {
        return;
    }
    GTabBarItem * item = self.itemArray[index];
    //角标为0,自动隐藏
    if ([badge integerValue] == 0) {
        item.badgeLbl.hidden = YES;
    }else {
        item.badgeLbl.hidden = NO;
        item.badgeLbl.text = badge;
        item.badgeLbl.textColor = badgeColor;
        item.badgeLbl.backgroundColor = backgroundColor;
    }
    [item setNeedsLayout];
    [item layoutIfNeeded];
}

#pragma mark - 清除角标
- (void)clearBadgeAtIndex:(NSInteger)index {
    [super clearBadgeAtIndex:index];
    if (index >= self.itemArray.count) {
        return;
    }
    GTabBarItem * item = self.itemArray[index];
    item.badgeLbl.text = nil;
    item.badgeLbl.hidden = YES;
}


#pragma mark - lazy
- (NSMutableArray *)itemArray {
    if (!_itemArray) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSArray array];
    }
    return _titleArray;
}

- (NSArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSArray array];
    }
    return _imageArray;
}

- (NSArray *)selectedImageArray {
    if (!_selectedImageArray) {
        _selectedImageArray = [NSArray array];
    }
    return _selectedImageArray;
}

#pragma mark- centerBtn
- (void)setCenterImage:(UIImage *)centerImage {
    _centerImage = centerImage;
    // 如果设置了宽高则使用设置的大小
    if (self.centerWidth <= 0 && self.centerHeight <= 0){
        //根据图片调整button的位置(默认居中，如果图片中心在tabbar的中间最上部，这个时候由于按钮是有一部分超出tabbar的，所以点击无效，要进行处理)
        _centerWidth = centerImage.size.width;
        _centerHeight = centerImage.size.height;
    }
    
    _centerWidth = 49;
    _centerHeight = 49;
    [self.centerBtn setBackgroundImage:centerImage forState:UIControlStateNormal];
}
-(UIButton*)centerBtn{
    if (!_centerBtn) {
        _centerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_centerBtn addTarget:self action:@selector(buttonCenterClick) forControlEvents:UIControlEventTouchUpInside];
        _centerBtn.layer.shadowColor = kRedColor.CGColor;//阴影颜色
        _centerBtn.layer.shadowOffset = CGSizeMake(0, .5f);//阴影的大小，x往右和y往下是正
        _centerBtn.layer.shadowRadius = 10;     //阴影的扩散范围，相当于blur radius，也是shadow的渐变距离，从外围开始，往里渐变shadowRadius距离
        _centerBtn.layer.shadowOpacity = .2f;    //阴影的不透明度
        _centerBtn.adjustsImageWhenHighlighted = NO;//去除高亮
        _centerBtn.layer.masksToBounds = YES;   //很重要的属性，可以用此属性来防止子元素大小溢出父元素，如若防止溢出，请设为 true
         [self insertSubview:_centerBtn atIndex:0];
        
    }
    return _centerBtn;
}
-(void)buttonCenterClick{
    if ([self.JZLTabBarDelegate respondsToSelector:@selector(selectedJZLTabBarCenter)]) {
       [self.JZLTabBarDelegate selectedJZLTabBarCenter];
    }
}
//处理超出区域点击无效的问题
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    if (self.hidden){
        return [super hitTest:point withEvent:event];
    }else {
        //转换坐标
        CGPoint tempPoint = [self.centerBtn convertPoint:point fromView:self];
        //判断点击的点是否在按钮区域内
        if (CGRectContainsPoint(self.centerBtn.bounds, tempPoint)){
            //返回按钮
            return _centerBtn;
        }else {
            return [super hitTest:point withEvent:event];
        }
    }
}
@end
