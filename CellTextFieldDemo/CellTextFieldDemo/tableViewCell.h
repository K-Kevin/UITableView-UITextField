//
//  tableViewCell.h
//  CellTextFieldDemo
//
//  Created by likai on 16/8/20.
//  Copyright © 2016年 kkk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class tableViewCell;
@protocol TextFieldChangedDelegate <NSObject>

- (void)TextFiledEditChanged:(tableViewCell *)cell textField:(UITextField *)textField;

@end

@interface tableViewCell : UITableViewCell

@property (nonatomic, weak) id<TextFieldChangedDelegate> delegate;

@property (nonatomic, strong) UILabel *leftLabel;

@property (nonatomic, strong) UITextField *rightTextField;

@end
