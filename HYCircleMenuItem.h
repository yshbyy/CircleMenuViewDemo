//
//  MenuItem.h
//  CustomView
//
//  Created by yshbyy on 15/5/9.
//  Copyright (c) 2015年 BaoliNetworkTechnology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HYCircleMenuItem : NSObject

/**
 *  标题
 */
@property (nonatomic, copy  ) NSString *title;
/**
 *  图片
 */
@property (nonatomic, strong) UIImage  *image;

/**
 *  便利构造器
 *
 *  @param title 标题
 *  @param image 图片
 */
+ (instancetype)itemWithTitle:(NSString *)title image:(UIImage *)image;
@end
