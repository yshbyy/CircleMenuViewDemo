//
//  MenuItemButton.m
//  CustomView
//
//  Created by yshbyy on 15/5/9.
//  Copyright (c) 2015年 BaoliNetworkTechnology. All rights reserved.
//

#import "HYCircleMenuItemButton.h"
#import "HYCircleMenuItem.h"

//图片宽高取按钮可操作区域宽高的较小值的0.6,如果这个值大于40，那图片固定为40大小。
#define IMAGEWIDTH (MIN(self.frame.size.width, _contentHeight)*0.6>30?30:MIN(self.frame.size.width, _contentHeight)*0.6)

@interface HYCircleMenuItemButton()

@end

@implementation HYCircleMenuItemButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL isInside = [super pointInside:point withEvent:event];
    
    //如果本身就不响应（isInside = NO），就不要判断下面一堆了
    if (isInside)
    {
        //判断点击区域是否在自定义扇形框架内
        //point相对与旋转中心点的距离
        CGFloat distance = sqrt((point.x - _pointOfAround.x) * (point.x - _pointOfAround.x) + (point.y - _pointOfAround.y) * (point.y - _pointOfAround.y));
        //垂直范围判断
        BOOL notInVertical = distance < _radiusSmall || distance > _radiusBig;
        //水平范围判断
        BOOL notInHorizontal;
        //斜率
        CGFloat kSlope;
        if (point.x > _pointOfAround.x)
        {
            kSlope = (_pointOfAround.y - point.y) / (point.x - _pointOfAround.x);
        }
        else
        {
            kSlope = (_pointOfAround.y - point.y) / (_pointOfAround.x - point.x);
        }
        CGFloat angle = atan(kSlope);//反正切求角度
        //水平范围
        notInHorizontal = (M_PI * 2 - angle) > _angleForBig.start || (M_PI * 2 - angle) < _angleForBig.end;
        
        //如果point不在扇形范围内，touch事件不返回
        if (notInVertical || notInHorizontal)
        {
            isInside = NO;
        }
    }
    return isInside;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    return view;
}
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, self.contentColor.CGColor);//边框颜色
    CGContextSetFillColorWithColor(context, self.contentColor.CGColor);//填充颜色
    CGContextSetLineWidth(context, 1.0);//边框宽度
    CGContextSetAlpha(context, _contentAlpha);
    
    //大圆弧
    CGContextAddArc(context, _pointOfAround.x, _pointOfAround.y, _radiusBig, _angleForBig.start, _angleForBig.end, 1);
    //连接线
    CGFloat x = rect.size.width/2 - _radiusSmall * sin(M_PI_2 * 3 - _angleForsmall.end);
    CGFloat y = rect.size.height;
    CGContextAddLineToPoint(context, x, y);
    //小圆弧
    CGContextAddArc(context, _pointOfAround.x, _pointOfAround.y, _radiusSmall, _angleForsmall.end, _angleForsmall.start, 0);
    //封闭
    CGContextDrawPath(context, kCGPathFill);
}

#pragma mark - Button的titleLable和imageView位置重新布置  固定图片大小，label高度
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat height = _contentHeight;
    CGFloat width = contentRect.size.width;
    NSAssert(height >= 50 && width >= 40, @"按钮的宽/高必须大于40/50!");
    
    CGRect rect = CGRectMake((width - IMAGEWIDTH)/2, (height - IMAGEWIDTH - 20)>0?(height - IMAGEWIDTH - 20)/2:0, IMAGEWIDTH, IMAGEWIDTH);
    return rect;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat height = _contentHeight;
    CGFloat width = contentRect.size.width;
    NSAssert(height >= 50 && width >= 40, @"按钮的宽/高必须大于40/50!");
    
    CGRect rect = CGRectMake(0, (height - IMAGEWIDTH - 20)/2 + IMAGEWIDTH, width, 20);
    return rect;
}

#pragma mark - 结构体（画弧起止弧度）设置方法
MenuButtonAngle MenuButtonAngleMake(CGFloat start, CGFloat end)
{
    MenuButtonAngle angle;
    angle.start = start;
    angle.end = end;
    return angle;
}

#pragma mark - Property Setters
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (void)setPointOfAround:(CGPoint)pointOfAround
{
    _pointOfAround = pointOfAround;
    [self setNeedsDisplay];
}

- (void)setAngleForBig:(MenuButtonAngle)angleForBig
{
    _angleForBig = angleForBig;
    [self setNeedsDisplay];
}

- (void)setAngleForsmall:(MenuButtonAngle)angleForsmall
{
    _angleForsmall = angleForsmall;
    [self setNeedsDisplay];
}

- (void)setRadiusBig:(CGFloat)radiusBig
{
    _radiusBig = radiusBig;
    [self setNeedsDisplay];
}

- (void)setRadiusSmall:(CGFloat)radiusSmall
{
    _radiusSmall = radiusSmall;
    [self setNeedsDisplay];
}

- (void)setItem:(HYCircleMenuItem *)item
{
    _item = item;
    [self setTitle:item.title forState:UIControlStateNormal];
    [self setImage:item.image forState:UIControlStateNormal];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:12];
}
@end
