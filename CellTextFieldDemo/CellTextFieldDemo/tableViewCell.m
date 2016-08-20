//
//  tableViewCell.m
//  CellTextFieldDemo
//
//  Created by likai on 16/8/20.
//  Copyright © 2016年 kkk. All rights reserved.
//

#import "tableViewCell.h"
#import <PureLayout/PureLayout.h>

#define HEXCOLOR(rgbValue)  [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface tableViewCell()

@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation tableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self addSubViews];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - [TextField]

- (void)textFieldDidChange:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(TextFiledEditChanged:textField:)]) {
        [self.delegate TextFiledEditChanged:self textField:textField];
    }
}

- (void)addSubViews {
    
    [self.contentView addSubview:self.bottomLine];
    [self.contentView addSubview:self.leftLabel];
    [self.contentView addSubview:self.rightTextField];
    
    [self setContraint];
}

- (void)setContraint {
    
    [self.bottomLine autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0];
    [self.bottomLine autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0];
    [self.bottomLine autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0];
    [self.bottomLine autoSetDimension:ALDimensionHeight toSize:0.5];
    
    [self.leftLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0];
    [self.leftLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0];
    [self.leftLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.bottomLine];
    [self.leftLabel autoSetDimension:ALDimensionWidth toSize:90.0];
    
    [self.rightTextField autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0];
    [self.rightTextField autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5.0];
    [self.rightTextField autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.bottomLine];
    [self.rightTextField autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.leftLabel];
    
}

#pragma mark - Getters and Setters

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [UILabel newAutoLayoutView];
        _leftLabel.backgroundColor = [UIColor clearColor];
        _leftLabel.textAlignment = NSTextAlignmentLeft;
        _leftLabel.font = [UIFont systemFontOfSize:16.f];
        _leftLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
    }
    return _leftLabel;
}

- (UITextField *)rightTextField {
    if (!_rightTextField) {
        _rightTextField = [UITextField newAutoLayoutView];
        _rightTextField.backgroundColor = [UIColor clearColor];
        _rightTextField.font = [UIFont systemFontOfSize:16.f];
        _rightTextField.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
        _rightTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_rightTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
    }
    return _rightTextField;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [UIView newAutoLayoutView];
        _bottomLine.backgroundColor = HEXCOLOR(0xe5e5e5);
    }
    return _bottomLine;
}

@end
