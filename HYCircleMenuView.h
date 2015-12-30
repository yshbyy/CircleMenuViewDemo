//
//  CircleMenu.h
//  SheJiQuan
//
//  Created by yshbyy on 15/5/6.
//  Copyright (c) 2015年 haiyabtx. All rights reserved.
//

#import <UIKit/UIKit.h>


//TODO: 配色接口设置
@class HYCircleMenuView,HYCircleMenuItem,HYCircleMenuMainButton;

/**
 *  代理协议
 */
@protocol HYCircleMenuViewDelegate <NSObject>

@optional
/**
 *  选中按钮
 *
 *  @param menuView 菜单视图
 *  @param index    按钮下标
 */
- (void)circleMenuView:(HYCircleMenuView *)menuView
    didSelectedAtIndex:(NSInteger)index;

/**
 *  选中主按钮
 *
 *  @param menuView 菜单视图
 */
- (void)circleMenuViewdidSelectMainButton:(HYCircleMenuView *)menuView;
@end

/**
 *  数据源协议
 */
@protocol HYCircleMenuViewDatasource <NSObject>

/**
 *  item个数
 *
 *  @param menuView 菜单视图
 *
 *  @return item数
 */
- (NSInteger)numberOfItemsInCircleMenu:(HYCircleMenuView *)menuView;
/**
 *  按钮
 *
 *  @param menuView 菜单视图
 *  @param index    按钮下标
 *
 *  @return 一个按钮
 */
- (HYCircleMenuItem *)circleMenuView:(HYCircleMenuView *)menuView itemForIndex:(NSInteger)index;

@end

@interface HYCircleMenuView : UIView

@property (nonatomic, readonly, weak) id<HYCircleMenuViewDelegate> delegate;
@property (nonatomic, readonly, weak) id<HYCircleMenuViewDatasource> datasource;

/**
 *  item是否旋转，默认不旋转
 */
@property (nonatomic, assign) BOOL itemRotation;

/**
 *  按钮之间的间隔角度倍数。
 *  此属性设置为1时，item间隙角度为“M_PI/1000”，间隙值为“M_PI/1000 * (self.frame.size.height/2)”。
 *  间隙值可通过“gapForItems”属性获取。
 *  默认为10。
 */
@property (nonatomic, assign) NSInteger spacingForItems;

/**  item按钮间隙值  */
@property (nonatomic, readonly, assign) CGFloat gapForItems;

/** 
 *  item按钮和主按钮间隙值。默认等于“gapForItems”
 *  如果你使用点语法设置“spacingForItems”，那么此属性将与“gapForItems”相等，所以如果你想单独设置此属性，请在设置“spacingForItems”之后设置。
 */
@property (nonatomic, assign) CGFloat gapForItemsAndMainButton;

/**  内圆大小  */
@property (nonatomic, assign) CGFloat radiusInside;

/**  
 *  环绕item按钮背景颜色。
 *  默认此属性后，主菜单按钮也会设置同样的值，若想单独设置主菜单按钮，请在设置此属性后设置“mainButton”
 */
@property (nonatomic, strong) UIColor *itemColor;

/**  
 *  环绕item按钮内容颜色
 *  默认此属性后，主菜单按钮也会设置同样的值，若想单独设置主菜单按钮，请在设置此属性后设置“mainButton”
 */
@property (nonatomic, strong) UIColor *itemTintColor;

/**  
 *  环绕item按钮透明度。
 *  如果想让主菜单按钮跟item按钮的透明度不一样，请在设置此属性后设置“mainButton”
 */
@property (nonatomic, assign) CGFloat itemAlpha;

/**  主按钮。需在调用show之后获取此属性，否则返回nil  */
@property (nonatomic, readonly, getter=getMainButton, strong) HYCircleMenuMainButton *mainButton;

/**
 *  便利构造器
 *
 *  @param frame      frame
 *  @param delegate   代理
 *  @param datasource 数据源代理
 *
 *  @return 一个环形菜单
 */
-(instancetype)initWithFrame:(CGRect)frame
                 andDelegate:(id<HYCircleMenuViewDelegate>)delegate
               andDatasource:(id<HYCircleMenuViewDatasource>)datasource;

/**
 *  重新加载视图
 */
- (void)refreshViews;

/**
 *  加载视图。
 *  加载视图后，本类所有属性不可更改，要设置属性，请在调用此方法之前设置。请确认属性都已设置OK，否则将使用默认属性。
 */
- (void)setUp;

/**
 *  获取对应index的item
 *
 *  @param index index
 *
 *  @return item
 */
- (HYCircleMenuItem *)itemForIndex:(NSInteger)index;
@end
