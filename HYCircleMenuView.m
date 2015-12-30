//
//  CircleMenu.m
//  SheJiQuan
//
//  Created by yshbyy on 15/5/6.
//  Copyright (c) 2015年 haiyabtx. All rights reserved.
//

#import "HYCircleMenuView.h"
#import "HYCircleMenuItem.h"
#import "HYCircleMenuItemButton.h"
#import "HYCircleMenuMainButton.h"

//圆心坐标，因圆在view中心，故x、y坐标一致
#define CIRCLECENTER MIN(self.frame.size.height, self.frame.size.width)/2
//item tag值基数
#define TAGBase 354
//单位间隙
#define kUnitForSpacing M_PI / 1000

@interface HYCircleMenuView()
{
    CGFloat radiusBig;
    UIColor *mainButtonBackgroundColor;
    UIColor *mainButtonTintColor;
    CGFloat mainButtonAlpha;
}

@property (nonatomic, assign) NSInteger numberOfItems;//菜单数量
@property (nonatomic, strong) NSMutableArray *items;//菜单按钮数组
@property (nonatomic, strong) HYCircleMenuMainButton *menuMainButton;//主按钮

//创建菜单
- (void)setupViews;
//初始化属性
- (void)initializePropertys;

@end

@implementation HYCircleMenuView

- (id)initWithFrame:(CGRect)frame
        andDelegate:(id<HYCircleMenuViewDelegate>)delegate
      andDatasource:(id<HYCircleMenuViewDatasource>)datasource
{
    if (self = [super initWithFrame:frame])
    {
        NSAssert(frame.size.height == frame.size.width, @"圆形菜单必须要在一个宽高相等的方框中");
        
        self.backgroundColor= [UIColor clearColor];
        
        _delegate   = delegate;
        _datasource = datasource;

        [self initializePropertys];
    }
    return self;
}

//属性初始化
- (void)initializePropertys
{
    radiusBig                 = CIRCLECENTER;
    _radiusInside             = 50;
    _spacingForItems          = 10;
    _gapForItemsAndMainButton = self.gapForItems;
    _itemColor                = [UIColor grayColor];
    _itemTintColor            = [UIColor whiteColor];
    _itemAlpha                = 0.75;
    _itemRotation             = NO;
    mainButtonBackgroundColor = _itemColor;
    mainButtonTintColor       = _itemTintColor;
    mainButtonAlpha           = _itemAlpha;
}

//加载视图
- (void)setUp
{
    [self setupViews];
    [self setupMainButton];
}

//视图加载
- (void)setupViews
{
    _items = [NSMutableArray new];
    
    NSAssert([self.datasource respondsToSelector:@selector(numberOfItemsInCircleMenu:)], @"circleMenuView必须实现“numberOfItemsInCircleMenu”");
    _numberOfItems = [self.datasource numberOfItemsInCircleMenu:self];
    
    //按钮items
    for (int index = 0; index < _numberOfItems; index++)
    {
        //均分角度（此角度用于绘制button，）
        CGFloat alpha       = (2*M_PI - _numberOfItems * _spacingForItems * kUnitForSpacing) / _numberOfItems;

        //按间隙旋转后，小圆间隙弧长与大圆间隙弧长的差
        CGFloat gapSpacing  = _spacingForItems *kUnitForSpacing * (radiusBig - _radiusInside);
        //小圆补差角度
        CGFloat gapAngle    = gapSpacing / _radiusInside;
        //按钮初始位置
        CGFloat itemButtonX = CIRCLECENTER - radiusBig * sin(alpha/2);
        CGFloat itemButtonY = 0.0;
        CGFloat itemWidth   = 2 * radiusBig * sin(alpha/2);
        CGFloat itemHeight  = radiusBig - _radiusInside * cos(alpha/2);
        
        NSAssert([self.datasource respondsToSelector:@selector(circleMenuView:itemForIndex:)], @"circleMenuView必须实现“circleMenuView:itemForIndex:”");
        HYCircleMenuItem *item = [self.datasource circleMenuView:self itemForIndex:index];
        
        //创建菜单按钮
        HYCircleMenuItemButton *itemButton  = [HYCircleMenuItemButton buttonWithType:UIButtonTypeRoundedRect];
        //将中心坐标转换成itemButton坐标系中的点
        CGPoint pointOfButtonAround = CGPointMake(CIRCLECENTER - itemButtonX, CIRCLECENTER - itemButtonY);
        
        itemButton.contentHeight   = radiusBig - _radiusInside;
        itemButton.frame           = CGRectMake(itemButtonX, itemButtonY, itemWidth, itemHeight);
        itemButton.radiusBig       = radiusBig;
        itemButton.radiusSmall     = _radiusInside;
        itemButton.pointOfAround   = pointOfButtonAround;
        itemButton.angleForBig     = MenuButtonAngleMake(M_PI_2 * 3 + alpha/2, M_PI_2 * 3 - alpha / 2);
        itemButton.angleForsmall   = MenuButtonAngleMake(M_PI_2 * 3 + (alpha - gapAngle) / 2,  M_PI_2 * 3 - (alpha - gapAngle) / 2);
        itemButton.item            = item;
        itemButton.contentColor    = _itemColor;
        itemButton.tintColor       = _itemTintColor;
        itemButton.contentAlpha    = _itemAlpha;
        itemButton.tag             = TAGBase + index;
        
        //文字，图标转回来
        if (!_itemRotation)
        {
            CGFloat contentHeight = itemButton.imageView.frame.size.height + itemButton.titleLabel.frame.size.height;//文字、图片、间隙总高度
            CGFloat imageHeight = itemButton.imageView.frame.size.height;//图片高度
            CGFloat labelHeight = itemButton.titleLabel.frame.size.height;//label高度
            CGPoint position = CGPointMake(itemButton.titleLabel.layer.position.x, itemButton.titleLabel.layer.position.y - contentHeight + labelHeight/2);
            
            itemButton.titleLabel.layer.anchorPoint = CGPointMake(0.5, 1 - contentHeight/(2*labelHeight));
            itemButton.titleLabel.layer.position = position;
            itemButton.imageView.layer.anchorPoint = CGPointMake(0.5, contentHeight / (2*imageHeight));
            itemButton.imageView.layer.position = position;
            
            itemButton.titleLabel.layer.transform = CATransform3DMakeRotation(-(alpha + _spacingForItems * kUnitForSpacing) * index, 0.01, 0, 1);
            itemButton.imageView.layer.transform = CATransform3DMakeRotation(-(alpha + _spacingForItems * kUnitForSpacing) * index, 0.01, 0, 1);
        }
        
        //设置锚点和中心位置
        itemButton.layer.anchorPoint = CGPointMake(0.5, pointOfButtonAround.y / itemHeight);
        itemButton.layer.position    = CGPointMake(CIRCLECENTER, CIRCLECENTER);
        //旋转
        itemButton.transform         = CGAffineTransformMakeRotation((alpha + _spacingForItems * kUnitForSpacing) * index);
        [itemButton addTarget:self action:@selector(btnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:itemButton];
        [_items addObject:item];
    }
}
//主按钮
- (void)setupMainButton
{
    //中心主按钮
    _menuMainButton           = [HYCircleMenuMainButton buttonWithType:UIButtonTypeRoundedRect];
    CGFloat centerButtonWidth = (_radiusInside - _gapForItemsAndMainButton) * 2;
    
    _menuMainButton.frame              = CGRectMake(0, 0, centerButtonWidth, centerButtonWidth);
    _menuMainButton.center             = CGPointMake(CIRCLECENTER, CIRCLECENTER);
    _menuMainButton.backgroundColor    = mainButtonBackgroundColor;
    _menuMainButton.tintColor          = mainButtonTintColor;
    _menuMainButton.alpha              = mainButtonAlpha;
    _menuMainButton.layer.cornerRadius = (_radiusInside - _gapForItemsAndMainButton);
    
    [_menuMainButton addTarget:self action:@selector(centerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_menuMainButton];

}
//点击item时
- (void)btnDidClick:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(circleMenuView:didSelectedAtIndex:)])
    {
        [self.delegate circleMenuView:self didSelectedAtIndex:sender.tag - TAGBase];
    }
}

//点击主按钮时
- (void)centerButtonAction:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(circleMenuViewdidSelectMainButton:)])
    {
        [self.delegate circleMenuViewdidSelectMainButton:self];
    }
}
//获取item
- (HYCircleMenuItem *)itemForIndex:(NSInteger)index
{
    return self.items[index];
}
#pragma mark - 重新加载视图
- (void)refreshViews
{
    //移除视图
    for (UIView *v in self.subviews)
    {
        if (v == _menuMainButton)
        {
            continue;
        }
        [v removeFromSuperview];
    }
    //移除数据
    [_items removeAllObjects];
    //重新加载视图
    [self setupViews];
}

#pragma mark - Property Setters
//item按钮间间隙角度单位倍数
- (void)setSpacingForItems:(NSInteger)spacingForItems
{
    _spacingForItems              = spacingForItems;
    self.gapForItemsAndMainButton = radiusBig * (_spacingForItems * kUnitForSpacing);
}

//主色调
- (void)setItemColor:(UIColor *)itemColor
{
    _itemColor = itemColor;
    mainButtonBackgroundColor = _itemColor;
}

//主内容色调
- (void)setItemTintColor:(UIColor *)itemTintColor
{
    _itemTintColor = itemTintColor;
    mainButtonTintColor = itemTintColor;
}

//透明度
- (void)setItemAlpha:(CGFloat)itemAlpha
{
    _itemAlpha = itemAlpha;
    mainButtonAlpha = _itemAlpha;
}

#pragma mark - Property Getters
//item按钮间隙值
- (CGFloat)gapForItems
{
    return radiusBig * (_spacingForItems * kUnitForSpacing);
}
//主菜单按钮
- (HYCircleMenuMainButton *)getMainButton
{
    return _menuMainButton;
}
@end
