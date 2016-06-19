//
//  ViewController.m
//  shootVideoDemo
//
//  Created by 赵一帆 on 15/12/7.
//  Copyright © 2015年 ZYF. All rights reserved.
//

#import "ViewController.h"
#import "CaptureViewController.h"
#import "DraftboxViewController.h"
#import "MBProgressHUD.h"
#define SCREENWITH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define BUTTONHEIGHT 30.0f
static NSString * const kvideo =@"拍视频";

@interface ViewController ()

@property (nonatomic, strong) UIButton * creatButton;

@end

@implementation ViewController
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor =[UIColor whiteColor];
    
    [self.view addSubview:self.creatButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upload:) name:@"tip" object:nil];
    
}
-(void)upload:(NSNotification*)noti
{
    UIColor *color =[UIColor whiteColor];
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode =MBProgressHUDModeText;
    hud.labelText =@"上传成功";
    hud .labelColor =color;
    [hud removeFromSuperViewOnHide];
    [hud hide:YES afterDelay:1.0];
}
-(UIButton*)creatButton
{
    if (!_creatButton)
    {
        _creatButton =[UIButton buttonWithType:UIButtonTypeSystem];
        _creatButton.frame =CGRectMake(0,SCREENHEIGHT -BUTTONHEIGHT , SCREENWITH, BUTTONHEIGHT);
        _creatButton. backgroundColor =[UIColor redColor];
        [_creatButton setTitle:kvideo forState:UIControlStateNormal];
        [_creatButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_creatButton addTarget:self action:@selector(shootVideo:) forControlEvents:UIControlEventTouchUpInside];
    }
        return _creatButton;
}
-(void)shootVideo:(UIButton*)sender
{
    DraftboxViewController * picker = [DraftboxViewController new];
//    picker.lastVC = self;
    UINavigationController *pp = [[UINavigationController alloc] initWithRootViewController:picker];
    [self presentViewController:pp animated:YES completion:nil];
    NSLog(@"已经点击了");

}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
