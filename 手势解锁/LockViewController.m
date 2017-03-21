//
//  LockViewController.m
//  手势解锁
//
//  Created by Cain on 16/5/22.
//  Copyright © 2016年 Cain. All rights reserved.
//

#import "LockViewController.h"
#import "LockView.h"
#import "LockTool.h"

@interface LockViewController ()<LockViewDelegate>

@property (nonatomic , copy)NSString *lastPassword;
@property (nonatomic , weak)UILabel * noticeLabel;

@end


@implementation LockViewController

-(void)viewDidLoad{
    [super viewDidLoad ];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpUI];
    
}

- (void)setUpUI{
    
    //添加label
    UILabel *noticeLabel  = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, 375, 40)];
    self.noticeLabel = noticeLabel;
    noticeLabel.textAlignment = NSTextAlignmentCenter;
   
//    根据控制器类型分别设置文本
    if (_type == LockViewTypeDraw) {
         noticeLabel.text = @"请绘制你的手势密码";
    }else{
        noticeLabel.text = @"请绘制解锁密码";
    }
   
    [self.view addSubview:noticeLabel];
    
    CGSize viewSize = self.view.bounds.size;
    //添加lockView(正方形 375*375)
    LockView *lockView = [[LockView alloc]initWithFrame:CGRectMake(0, 0, viewSize.width, viewSize.width)];
   
    //lockView的中心点(把lockView移到屏幕中间)
    lockView.center = CGPointMake(viewSize.width/2, viewSize.height/2);
    [self.view addSubview:lockView];
    
    lockView.delegate = self;
}

#pragma mark
#pragma mark 修改noticeLabel的不同情况下文字和颜色
- (void)LockView:(LockView *)lockView password:(NSString *)password{
    
    // 在解锁状态下, 才需要取出密码
    if (_type == LockViewTypeUnlock) {
        _lastPassword = [LockTool getPassword];
    }
    
    // 是第一次输入
    if (_lastPassword == nil) {
//        存储当前的密码
        _lastPassword = password;
        
        [self showNoticeMessageWith: @"请再次绘制密码" success:YES];
     
    }else{
        
         // 表示 第二次绘制
        if ([_lastPassword isEqualToString:password]) {
            
            // 两次绘制都相同,密码绘制正确,保存密码
            [LockTool savePassword:password];
            
            // 修改label文本显示
            [self showNoticeMessageWith:@"两次绘制相同,即将返回首页" success:YES];
            
             // 返回主界面(判断类型)
            [self backToHome];
            
        }else{
              // 密码错误
            [self showNoticeMessageWith:@"密码错误,请重新绘制" success:NO];
            
             // 通知 lockView 错误的密码, 然后, lockView 进行绘制
            lockView.errorPassword = password;
        }
    }
}

#pragma mark
#pragma mark - 返回主界面
- (void)backToHome{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (_type == LockViewTypeUnlock) {
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    });
    
}

#pragma mark
#pragma mark - 修改noticeLabel的显示效果
- (void)showNoticeMessageWith:(NSString *)text success:(BOOL)success {
    _noticeLabel.text = text;
    
    _noticeLabel.textColor = success ? [UIColor blackColor] : [UIColor redColor];
    
    _noticeLabel.transform = CGAffineTransformMakeTranslation(10, 0);
 
//    密码错误的颤抖效果
    if (!success) {
        /**
         usingSpringWithDamping: 阻力(越小震动越大)
         initialSpringVelocity:  速度
         */
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseIn animations:^{
            _noticeLabel.transform = CGAffineTransformIdentity ;
        } completion:^(BOOL finished) {
            _noticeLabel.transform = CGAffineTransformIdentity;
        }];
  }
}

@end
