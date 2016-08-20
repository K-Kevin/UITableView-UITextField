//
//  FormatUtil.m
//  CellTextFieldDemo
//
//  Created by likai on 16/8/20.
//  Copyright © 2016年 kkk. All rights reserved.
//

#import "FormatUtil.h"

@implementation FormatUtil

+ (BOOL)formatExactCountNum:(int)textMaxNum textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (string.length == 0) {//delete
        return YES;
    }
    
    //copy & paste
    int tnum = [self countWord:string];
    if (tnum + textField.text.length > textMaxNum) {
        return NO;
    }
    
    //normal input
    NSScanner *scan = [NSScanner scannerWithString:string];
    NSInteger val;
    BOOL isPureInteger = [scan scanInteger:&val] && [scan isAtEnd];
    if (isPureInteger) {
        if (range.location >= textMaxNum) {
            return NO;
        } else {
            return YES;
        }
    } else {
        return NO;
    }
}

+ (BOOL)formatIdentityNumber:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string.length == 0) {
        return YES;
    }
    
    int textNum = 18;
    
    int tnum = [self countWord:string];
    if (tnum + textField.text.length > textNum) {
        return NO;
    }
    
    if (range.location >= textNum) {
        return NO;
    } else {
        if (range.location >= 17) {
            NSString *resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
            NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789Xx\b"];
            if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location == NSNotFound) {
                textField.text = resultString;
            }
            return NO;
        } else {
            NSScanner *scan = [NSScanner scannerWithString:string];
            NSInteger val;
            BOOL isPureInteger = [scan scanInteger:&val] && [scan isAtEnd];
            if (isPureInteger) {
                return YES;
            } else {
                return NO;
            }
        }
    }
}

+ (BOOL)formatExactCountWord:(int)wordMaxNum textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string.length == 0) {
        return YES;
    }
    
    int tnum = [self countWord:string];
    if (tnum + textField.text.length > wordMaxNum) {
        return NO;
    }
    
    if (range.location >= wordMaxNum) {
        return NO;
    } else {
        return YES;
    }
}

+ (int)countWord:(NSString*)text {
    NSUInteger count = [text length];
    int chineseNum = 0;
    int charNum = 0;
    int blankNum = 0;
    unichar trimChar = 0x2006;
    for(int i = 0; i < count; i++){
        trimChar = [text characterAtIndex:i];
        if(isblank(trimChar)){
            blankNum++;
        }else if(isascii(trimChar)){
            charNum++;
        }else{
            chineseNum++;
        }
    }
    return charNum + chineseNum + blankNum;
}

@end
