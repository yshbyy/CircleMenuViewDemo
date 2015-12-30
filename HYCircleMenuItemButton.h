//
//  MenuItemButton.h
//  CustomView
//
//  Created by yshbyy on 15/5/9.
//  Copyright (c) 2015年 BaoliNetworkTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYCircleMenuItem;

struct MenuButtonAngle
{
    CGFloat start;
    CGFloat end;
};
typedef struct MenuButtonAngle MenuButtonAngle;

MenuButtonAngle MenuButtonAngleMake(CGFloat start, CGFloat end);
//{
//    MenuButtonAngle angle;
//    angle.start = start;
//    angle.end = end;
//    return angle;
//}

@interface HYCircleMenuItemButton : UIButton

@property (nonatomic, assign) CGPoint         pointOfAround;//按钮围绕的中心
@property (nonatomic, assign) CGFloat         radiusBig;//外圆半径
@property (nonatomic, assign) CGFloat         radiusSmall;//内圆半径
@property (nonatomic, assign) MenuButtonAngle angleForBig;//绘制按钮外圆起止弧度
@property (nonatomic, assign) MenuButtonAngle angleForsmall;//绘制按钮内圆起止弧度
@property (nonatomic, strong) HYCircleMenuItem *item;//按钮文字和图片
@property (nonatomic, assign) CGFloat contentHeight;//内容高度，image和titleLabel所在rect的高
@property (nonatomic, assign) CGFloat contentAlpha;//绘制内容的透明度
@property (nonatomic, strong) UIColor *contentColor;//绘制内容的背景色

@end
