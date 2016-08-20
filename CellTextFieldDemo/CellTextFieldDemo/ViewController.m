//
//  ViewController.m
//  CellTextFieldDemo
//
//  Created by likai on 16/8/19.
//  Copyright © 2016年 kkk. All rights reserved.
//

#import "ViewController.h"
#import "tableViewCell.h"

#import "ValidateUtil.h"
#import "FormatUtil.h"

#import <PureLayout/PureLayout.h>
#import <TPKeyboardAvoiding/TPKeyboardAvoidingTableView.h>
#import <APNumberPad/APNumberPad.h>
#import <APNumberPad/APNumberPadDefaultStyle.h>

NSString * const kTableViewCellIdentifier = @"kTableViewCellIdentifier";

typedef NS_ENUM(NSInteger, TextFieldRowIndex) {
    TextFieldRowIndexName           = 0,
    TextFieldRowIndexNickName       = 1,
    TextFieldRowIndexEmail          = 2,
    TextFieldRowIndexPassword       = 3,
    TextFieldRowIndexTelePhone      = 4,
    TextFieldRowIndexIdCode         = 5,
    TextFieldRowIndexDesc           = 6
};

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, TextFieldChangedDelegate, APNumberPadDelegate>
{
    NSInteger nameMaxLength_;
}

@property (nonatomic, strong) TPKeyboardAvoidingTableView *tableView;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *idCode;
@property (nonatomic, copy) NSString *telePhone;
@property (nonatomic, copy) NSString *desc;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self dataInit];
    
    [self setupCustomView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier];
    if(!cell) {
        cell = [[tableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTableViewCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.rightTextField.delegate = self;
    }
    
    NSInteger rowTag = indexPath.row;
    cell.rightTextField.tag = rowTag;
    cell.rightTextField.userInteractionEnabled = YES;
    cell.rightTextField.keyboardType = UIKeyboardTypeDefault;
    cell.rightTextField.secureTextEntry = NO;
    cell.rightTextField.inputView = nil;
    
    if (rowTag == TextFieldRowIndexName) {
        
        cell.leftLabel.text = @"Name";
        [self makeTextField:self.name placeholder:@"John Alplpus" textField:cell.rightTextField];
        
    } else if (rowTag == TextFieldRowIndexNickName) {
        
        cell.leftLabel.text = @"NickName";
        [self makeTextField:self.nickName placeholder:@"As I say, nickName" textField:cell.rightTextField];
        
    } else if (rowTag == TextFieldRowIndexEmail) {
        
        cell.leftLabel.text = @"Email";
        [self makeTextField:self.email placeholder:@"xxxx@gmail.com" textField:cell.rightTextField];
        
        cell.rightTextField.keyboardType = UIKeyboardTypeEmailAddress;//email键盘

    } else if (rowTag == TextFieldRowIndexPassword) {
        
        cell.leftLabel.text = @"Password";
        [self makeTextField:self.password placeholder:@"Required" textField:cell.rightTextField];
        
        cell.rightTextField.secureTextEntry = YES;
        
    } else if (rowTag == TextFieldRowIndexDesc) {
        
        cell.leftLabel.text = @"Description";
        [self makeTextField:self.desc placeholder:@"Add a io" textField:cell.rightTextField];

    } else if (rowTag == TextFieldRowIndexTelePhone) {
        
        cell.leftLabel.text = @"TelePhone";
        [self makeTextField:self.telePhone placeholder:@"Tele Number" textField:cell.rightTextField];
        
        cell.rightTextField.keyboardType = UIKeyboardTypeNumberPad;//数字键盘
        
    } else if (rowTag == TextFieldRowIndexIdCode) {
        
        cell.leftLabel.text = @"Identity";
        [self makeTextField:self.idCode placeholder:@"Identity Number" textField:cell.rightTextField];
        
        cell.rightTextField.inputView = ({
            APNumberPad *numberPad = [APNumberPad numberPadWithDelegate:self numberPadStyleClass:[APNumberPadDefaultStyle class]];
            [numberPad.leftFunctionButton setTitle:@"X" forState:UIControlStateNormal];
            numberPad;
        });
        
    }
    
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self hideKeyboard];
}

#pragma mark - APNumberPadDelegate

- (void)numberPad:(APNumberPad *)numberPad functionButtonAction:(UIButton *)functionButton textInput:(UIResponder<UITextInput> *)textInput {
    UITextField *idCodeField = [self getTextFieldTag:TextFieldRowIndexIdCode];
    if ([textInput isEqual:idCodeField]) {
        NSString *currentStr = idCodeField.text;
        NSString *toBeString = [NSString stringWithFormat:@"%@X", currentStr];
        if ([ValidateUtil isIdentityCard:toBeString]) {
            [textInput insertText:@"X"];
        }
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSInteger tag = textField.tag;
    if (tag == TextFieldRowIndexIdCode) {
        return [FormatUtil formatIdentityNumber:textField shouldChangeCharactersInRange:range replacementString:string];
    } else if (tag == TextFieldRowIndexTelePhone) {
        //手机号11位
        return [FormatUtil formatExactCountNum:11 textField:textField shouldChangeCharactersInRange:range replacementString:string];
    } else if (tag == TextFieldRowIndexName) {
        return [FormatUtil formatExactCountWord:(int)nameMaxLength_ textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    return YES;
}

- (void)TextFiledEditChanged:(tableViewCell *)cell textField:(UITextField *)textField {
    NSInteger tag = cell.rightTextField.tag;
    NSString *toBeString = textField.text;
    if (tag == TextFieldRowIndexName) {
        //防止键盘关联导致问题，故截取掉
        if (toBeString.length > nameMaxLength_) {
            textField.text = [textField.text substringToIndex:nameMaxLength_];
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    NSString *currentStr = textField.text;
    NSInteger tag = textField.tag;
    if (tag == TextFieldRowIndexName) {
        self.name = currentStr;
    } else if (tag == TextFieldRowIndexNickName) {
        self.nickName = currentStr;
    } else if (tag == TextFieldRowIndexEmail) {
        self.email = currentStr;
    } else if (tag == TextFieldRowIndexPassword) {
        self.password = currentStr;
    } else if (tag == TextFieldRowIndexTelePhone) {
        self.telePhone = currentStr;
    } else if (tag == TextFieldRowIndexIdCode) {
        self.idCode = currentStr;
    } else if (tag == TextFieldRowIndexDesc) {
        self.desc = currentStr;
    }
}

#pragma mark - Custom Methods

- (void)dataInit {
    
    nameMaxLength_ = 10;
    
    self.name        = @"";
    self.nickName    = @"";
    self.email       = @"";
    self.password    = @"";
    self.telePhone   = @"";
    self.idCode      = @"";
    self.desc        = @"";
}

- (void)setupCustomView {
    
    [self.view addSubview:self.tableView];
    
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    
    [self setContraint];
}

- (void)setContraint {
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0];
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0];
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0];
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0];
}

- (UITextField *)getTextFieldTag:(NSInteger)tag {
    tableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:tag inSection:0]];
    UITextField *textField = cell.rightTextField;
    return textField;
}

- (void)makeTextField:(NSString *)text placeholder: (NSString *)placeholder textField:(UITextField *)tf {
    tf.placeholder = placeholder ;
    tf.text = text;
}

- (void)hideKeyboard {
    [self.view endEditing:YES];
}

#pragma mark - Getters & Setters

- (TPKeyboardAvoidingTableView *)tableView {
    if (!_tableView) {
        _tableView = [TPKeyboardAvoidingTableView newAutoLayoutView];
        _tableView.delegate =self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _tableView;
}

@end
