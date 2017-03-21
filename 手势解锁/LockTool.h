//
//  LockTool.h
//  手势解锁
//
//  Created by Cain on 16/5/24.
//  Copyright © 2016年 Cain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LockTool : NSObject

// 帮用户进行密码管理
// 工具类  --> 专门为程序做单一事情

+ (void)savePassword:(NSString *)password;

+ (NSString *)getPassword;

@end
