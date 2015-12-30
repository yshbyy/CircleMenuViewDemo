//
//  MenuMainButton.m
//  CustomView
//
//  Created by yshbyy on 15/5/11.
//  Copyright (c) 2015年 BaoliNetworkTechnology. All rights reserved.
//

#import "HYCircleMenuMainButton.h"

@implementation HYCircleMenuMainButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL isInside = [super pointInside:point withEvent:event];
    
    //如果super调用不响应，则不用判断如下
    if (isInside)
    {
        //判断point是否在圆内
        CGFloat centerXY = self.bounds.size.width / 2;
        CGFloat pointToCenter = sqrt((point.x - centerXY) * (point.x - centerXY) + (point.y - centerXY) * (point.y - centerXY));
        
        if (pointToCenter > centerXY)
        {
            isInside = NO;
        }
    }
    
    return isInside;
}
@end
