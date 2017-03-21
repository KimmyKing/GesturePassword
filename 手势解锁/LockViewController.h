//
//  LockViewController.h
//  手势解锁
//
//  Created by Cain on 16/5/22.
//  Copyright © 2016年 Cain. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , LockViewType) {
    // 绘制解锁密码
    LockViewTypeDraw,
    
    // 输入解锁密码
    LockViewTypeUnlock
};


@interface LockViewController : UIViewController

@property (nonatomic , assign)NSInteger type;

@end
