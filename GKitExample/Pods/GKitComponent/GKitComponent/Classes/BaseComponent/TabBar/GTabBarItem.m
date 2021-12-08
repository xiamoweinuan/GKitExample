//
//  DRTabBarItem.m
//  DRLive
//
//  Created by tg on 2020/9/10.
//  Copyright © 2020 DRLive. All rights reserved.
//

#import "GTabBarItem.h"
#import "GHeader.h"
@implementation GTabBarItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.titleLbl];
    [self addSubview:self.imgView];
    [self addSubview:self.selectedImgView];
    [self addSubview:self.badgeLbl];
    
    
    CGFloat dis = 5.0f;
    self.titleLbl.frame = CGRectMake(0, self.bounds.size.height - 14-dis, self.bounds.size.width, 14);

    self.imgView.frame = CGRectMake(0, dis, 53/2, 48/2);
    self.imgView.center = CGPointMake(self.bounds.size.width / 2, self.imgView.centerY);
    
    self.selectedImgView.frame = CGRectMake(0, dis, 53/2, 48/2);
    self.selectedImgView.center = CGPointMake(self.bounds.size.width / 2, self.selectedImgView.centerY);
    
//    self.animateImgView.frame = CGRectMake(0, 0, 32, 32);
//    self.animateImgView.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2 );
    
    self.badgeLbl.center = CGPointMake((CGRectGetMaxX(self.imgView.frame) - 5), (self.imgView.bounds.origin.y) + 5);

    
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    if (_selected) {
        self.selectedImgView.hidden = NO;
        [self.selectedImgView startAnimating];
//        [self animationWithSelectedImg];
//        self.animateImgView.hidden = NO;
//        self.animateImgView
        self.imgView.hidden = YES;
//        self.titleLbl.hidden = YES;
        self.titleLbl.textColor = kRedColor;

    }else {
        [self.selectedImgView stopAnimating];
        self.selectedImgView.hidden = YES;
        self.imgView.hidden = NO;
        self.titleLbl.hidden = NO;
        self.titleLbl.textColor = kRedColor;

    }
    
}

/** 动画 */
- (void)animationWithSelectedImg {
    CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulse.duration = 0.15;
    pulse.repeatCount= 1;
    pulse.autoreverses= YES;
    pulse.fromValue= [NSNumber numberWithFloat:0.8];
    pulse.toValue= [NSNumber numberWithFloat:1.2];
    [self.selectedImgView.layer addAnimation:pulse forKey:nil];
}

- (UILabel *)titleLbl {
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.font = [UIFont systemFontOfSize:10];
        
        _titleLbl.textColor = kColorHex(0xA6B0BD);
        _titleLbl.textAlignment = NSTextAlignmentCenter;
        _titleLbl.text = @"首页";
    }
    return _titleLbl;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.userInteractionEnabled = YES;
        _imgView.contentMode =  UIViewContentModeScaleAspectFill;
        
    }
    return _imgView;
}

- (UIImageView *)selectedImgView {
    if (!_selectedImgView) {
        _selectedImgView = [[UIImageView alloc] init];
        _selectedImgView.userInteractionEnabled = YES;
        _selectedImgView.hidden = YES;//选中图片默认隐藏
        _selectedImgView.contentMode =  UIViewContentModeScaleAspectFill;
    }
    return _selectedImgView;
}

- (UILabel *)badgeLbl {
    if (!_badgeLbl) {
        _badgeLbl = [[UILabel alloc] init];
        _badgeLbl.font = [UIFont systemFontOfSize:12];
        _badgeLbl.textColor = [UIColor whiteColor];
        _badgeLbl.textAlignment = NSTextAlignmentCenter;
        _badgeLbl.hidden = YES;
        _badgeLbl.backgroundColor = kColorStringHex(@"FF3A30");

    }
    return _badgeLbl;
}

//-(UIImageView *)animateImgView{
//    if (!_animateImgView) {
//        _animateImgView = [[UIImageView alloc] init];
//        _animateImgView.userInteractionEnabled = YES;
//        _animateImgView.hidden = YES;//选中图片默认隐藏
//    }
//    return _animateImgView;
//
//
//}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.badgeLbl sizeToFit];
    //为了左右两边切圆角留间距
    CGSize size = [@"#" sizeWithAttributes:@{NSFontAttributeName: self.badgeLbl.font}];
    float width = self.badgeLbl.bounds.size.width + size.width ;
    float height = self.badgeLbl.bounds.size.height ;
    if (width < height) {
        width = height;
    }
    self.badgeLbl.layer.cornerRadius = height / 2;
    self.badgeLbl.clipsToBounds = YES;
    CGRect frame = self.badgeLbl.frame;
    frame.size.width = width;
    frame.size.height = height;
    self.badgeLbl.frame = frame;
    
}

- (void)sizeToFit {
    [super sizeToFit];
    
}


@end
