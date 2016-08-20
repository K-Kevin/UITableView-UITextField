//
//  ValidateUtil.m
//  CellTextFieldDemo
//
//  Created by likai on 16/8/20.
//  Copyright © 2016年 kkk. All rights reserved.
//

#import "ValidateUtil.h"

@implementation ValidateUtil

+ (BOOL)isIdentityCard:(NSString *)string {
    NSString *pattern = @"^(\\d{18}$|^\\d{17}(\\d|X|x))$";
    NSPredicate *mobilePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    return [mobilePredicate evaluateWithObject:string];
}

@end
