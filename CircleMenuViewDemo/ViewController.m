//
//  ViewController.m
//  CircleMenuViewDemo
//
//  Created by yshbyy on 15/12/30.
//  Copyright © 2015年 yshbyy. All rights reserved.
//

#import "ViewController.h"
#import "HYCircleMenu.h"

@interface ViewController ()<HYCircleMenuViewDelegate,HYCircleMenuViewDatasource>

@property (nonatomic, strong) HYCircleMenuView *menuView;
@property (weak, nonatomic) IBOutlet UILabel *itemCountLabel;
@property (nonatomic, assign) NSInteger items;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _items = 5;
    
    _menuView = [[HYCircleMenuView alloc] initWithFrame:CGRectMake(0, 0, 250, 250) andDelegate:self andDatasource:self];
    _menuView.center = self.view.center;
    _menuView.itemRotation = YES;
    _menuView.spacingForItems = 5;
    _menuView.gapForItemsAndMainButton = 3;
    _menuView.radiusInside = 55;
    [_menuView setUp];
    [_menuView.mainButton setTitle:@"主菜单" forState:UIControlStateNormal];
    [self.view addSubview:_menuView];
}

#pragma mark - HYCircleMenuViewDelegate
- (void)circleMenuViewdidSelectMainButton:(HYCircleMenuView *)menuView
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"主菜单" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [av show];
}
- (void)circleMenuView:(HYCircleMenuView *)menuView didSelectedAtIndex:(NSInteger)index
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"子菜单：%ld",(long)index] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [av show];
}
#pragma mark - HYCircleMenuViewDatasource
- (NSInteger)numberOfItemsInCircleMenu:(HYCircleMenuView *)menuView
{
    return _items;
}
- (HYCircleMenuItem *)circleMenuView:(HYCircleMenuView *)menuView itemForIndex:(NSInteger)index
{
    HYCircleMenuItem *item = [[HYCircleMenuItem alloc] init];
    switch (index)
    {
        case 0:
            item.title = @"呵呵";
//            item.image = [UIImage imageNamed:]
            break;
        case 1:
            item.title = @"哈哈";
            //            item.image = [UIImage imageNamed:]
            break;
        case 2:
            item.title = @"嘿嘿";
            //            item.image = [UIImage imageNamed:]
            break;
        case 3:
            item.title = @"咻咻";
            //            item.image = [UIImage imageNamed:]
            break;
        case 4:
            item.title = @"呼呼";
            //            item.image = [UIImage imageNamed:]
            break;
        default:
            item.title = @"加加";
            break;
    }
    return item;
}

- (IBAction)changeItemRotation:(UISwitch *)sender {
    _menuView.itemRotation = sender.on;
    [_menuView refreshViews];
}
- (IBAction)changeItemSpacing:(UISlider *)sender {
    _menuView.spacingForItems = sender.value;
    [_menuView refreshViews];
}
- (IBAction)changeItemAndMenuSpacing:(UISlider *)sender {
    _menuView.gapForItemsAndMainButton = sender.value;
    [_menuView refreshViews];
}
- (IBAction)changeRadiusInside:(UISlider *)sender {
    _menuView.radiusInside = sender.value;
    [_menuView refreshViews];
    
}
- (IBAction)jianjian:(UIButton *)sender{
    
    if (_items > 2)
    {
        _items--;
        [_menuView refreshViews];
    }
    self.itemCountLabel.text = [NSString stringWithFormat:@"%ld",(long)_items];
}
- (IBAction)jiajia:(id)sender {
    if (_items < 15)
    {
        _items++;
        [_menuView refreshViews];
    }
    self.itemCountLabel.text = [NSString stringWithFormat:@"%ld",(long)_items];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
