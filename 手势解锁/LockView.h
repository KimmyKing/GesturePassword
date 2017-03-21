//
//  LockView.h
//  手势解锁
//
//  Created by Cain on 16/5/22.
//  Copyright © 2016年 Cain. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LockView;

@protocol LockViewDelegate <NSObject>

- (void)LockView:(LockView *)lockView password:(NSString *)password;

@end

@interface LockView : UIView

@property (nonatomic , weak)id<LockViewDelegate>delegate;
@property (nonatomic , copy)NSString *errorPassword;


@end
