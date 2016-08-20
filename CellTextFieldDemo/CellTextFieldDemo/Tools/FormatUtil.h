//
//  FormatUtil.h
//  CellTextFieldDemo
//
//  Created by likai on 16/8/20.
//  Copyright © 2016年 kkk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FormatUtil : NSObject

+ (BOOL)formatExactCountNum:(int)textMaxNum textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

+ (BOOL)formatExactCountWord:(int)wordMaxNum textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

+ (BOOL)formatIdentityNumber:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

@end
