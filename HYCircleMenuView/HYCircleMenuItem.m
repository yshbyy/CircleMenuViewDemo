//
//  MenuItem.m
//  CustomView
//
//  Created by yshbyy on 15/5/9.
//  Copyright (c) 2015年 BaoliNetworkTechnology. All rights reserved.
//

#import "HYCircleMenuItem.h"

@implementation HYCircleMenuItem

+ (instancetype)itemWithTitle:(NSString *)title image:(UIImage *)image
{
    HYCircleMenuItem *item = [[HYCircleMenuItem alloc] init];
    item.title = title;
    item.image = image;
    return item;
}

@end
