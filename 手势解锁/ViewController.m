//
//  ViewController.m
//  手势解锁
//
//  Created by Cain on 16/5/22.
//  Copyright © 2016年 Cain. All rights reserved.
//

#import "ViewController.h"
#import "LockViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark
#pragma mark 绘制手势密码
- (IBAction)didGestureButton:(id)sender {
    
    LockViewController *lockViewController = [[LockViewController alloc]init];
    
     // 设置类型
    lockViewController.type = LockViewTypeDraw;
    
    [self.navigationController pushViewController:lockViewController animated:YES];

}

#pragma mark
#pragma mark 绘制解密码
- (IBAction)didClickUnlockButton:(id)sender {
    
//    实例化控制器
    LockViewController *lockViewController = [[LockViewController alloc]init];
    
    // 实例化导航控制器
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:lockViewController];
    
    // 设置类型
    lockViewController.type =LockViewTypeUnlock;
    
    [self presentViewController:nav animated:YES completion:nil];
}

@end
