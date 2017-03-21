//
//  LockTool.m
//  手势解锁
//
//  Created by Cain on 16/5/24.
//  Copyright © 2016年 Cain. All rights reserved.
//

#import "LockTool.h"

@implementation LockTool

+ (void)savePassword:(NSString *)password {
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"password"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+(NSString *)getPassword {
    
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
}

@end
