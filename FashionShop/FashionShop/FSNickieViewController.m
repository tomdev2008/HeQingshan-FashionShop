//
//  FSNickieViewController.m
//  FashionShop
//
//  Created by gong yi on 11/30/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSNickieViewController.h"
#import "UIViewController+Loading.h"
#import "FSUserProfileRequest.h"
#import "MacDefine.h"

@interface FSNickieViewController ()
{
    UITextField *_activityField;
    UITextField *_phoneField;
    UITextField *_nickField;
    UITextField *_signField;
    UIButton *_btnSex;
    
    UIView *pickerView;
    UIPickerView *_picker;
    
    BOOL pickerIsShow;  //当前picker是否显示
    int tableYOffset;
}

-(void)initPickerView;

@end

@implementation FSNickieViewController
@synthesize currentUser;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)initPickerView
{
    if (pickerView) {
        [pickerView removeFromSuperview];
    }
    pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HIGH, APP_WIDTH, 262)];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 46)];
    imgView.image = [UIImage imageNamed:@"picker_head_bg.png"];
    imgView.backgroundColor = [UIColor grayColor];
    [pickerView addSubview:imgView];
    
    UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(8, 8, 50, 30);
    [cancelButton setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"btn_short_left.png"] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(cancelPickerView:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [pickerView addSubview:cancelButton];
    
    UIButton * okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [okButton setFrame:CGRectMake(APP_WIDTH - 58, 8, 50, 30)];
    [okButton setTitle:NSLocalizedString(@"OK", nil) forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [okButton setBackgroundImage:[UIImage imageNamed:@"btn_short_right.png"] forState:UIControlStateNormal];
    [okButton addTarget:self action:@selector(okPickerView:) forControlEvents:UIControlEventTouchUpInside];
    okButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [pickerView addSubview:okButton];
    
    _picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 46, APP_WIDTH, 216)];
    _picker.delegate = self;
    _picker.dataSource = self;
    _picker.showsSelectionIndicator = YES;
    [pickerView addSubview:_picker];
    
    [theApp.window insertSubview:pickerView atIndex:1000];
}

-(void)showPickerView
{
    if (pickerView.frame.origin.y <= SCREEN_HIGH && !pickerIsShow)
    {
        pickerIsShow = YES;
        [_activityField resignFirstResponder];
        if ([_btnSex.titleLabel.text isEqualToString:NSLocalizedString(@"Male", nil)]) {
            [_picker selectRow:0 inComponent:0 animated:NO];
        }
        else{
            [_picker selectRow:1 inComponent:0 animated:NO];
        }
        
        tableYOffset = self.tbAction.contentOffset.y;
        [UIView animateWithDuration:0.3f animations:^{
            CGRect rect = pickerView.frame;
            rect.origin.y -= pickerView.frame.size.height;
            pickerView.frame = rect;
        } completion:nil];
        [_picker reloadAllComponents];
    }
}

-(void)hidenPickerView:(BOOL)animated
{
    if (pickerView.frame.origin.y <= SCREEN_HIGH-pickerView.frame.size.height && pickerIsShow)
    {
        if (animated) {
            pickerIsShow = NO;
            [UIView animateWithDuration:0.3f animations:^{
                CGRect rect = pickerView.frame;
                rect.origin.y += pickerView.frame.size.height;
                pickerView.frame = rect;
            } completion:nil];
        }
        else {
            pickerIsShow = NO;
            CGRect rect = pickerView.frame;
            rect.origin.y += pickerView.frame.size.height;
            pickerView.frame = rect;
        }
        
    }
}

-(void)cancelPickerView:(UIButton*)sender
{
    [self hidenPickerView:YES];
}

-(void)okPickerView:(UIButton*)sender
{
    [self hidenPickerView:YES];
    if ([_picker selectedRowInComponent:0] == 0) {
        [_btnSex setTitle:NSLocalizedString(@"Male", nil) forState:UIControlStateNormal];
    }
    if ([_picker selectedRowInComponent:0] == 1) {
        [_btnSex setTitle:NSLocalizedString(@"Female", nil) forState:UIControlStateNormal];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"USER_SETTING_EDITNGINFO", nil);
    
    [self bindControl];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self hidenPickerView:YES];
}

- (void)bindControl
{
    UIBarButtonItem *baritemCancel = [self createPlainBarButtonItem:@"goback_icon.png" target:self action:@selector(onButtonBack:)];
    UIBarButtonItem *baritemShare = [self createPlainBarButtonItem:@"ok_icon.png" target:self action:@selector(doSave:)];
    [self.navigationItem setLeftBarButtonItem:baritemCancel];
    [self.navigationItem setRightBarButtonItem:baritemShare];
    
    _tbAction.backgroundView = [[UIView alloc]init];
    _tbAction.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1.0f];
    [_tbAction reloadData];
    
    [self initPickerView];
}
- (BOOL)validateUser:(NSMutableString **)errorin
{
    if (!errorin)
        *errorin = [@"" mutableCopy];
    NSMutableString *error = *errorin;
    if (_nickField.text.length<=0)
    {
        [error appendString:NSLocalizedString(@"USER_NICKIE_VALIDATE_ZERO", nil)];;
        return false;
    } else if(_nickField.text.length>10)
    {
        [error appendString:NSLocalizedString(@"USER_NICKIE_VALIDATE_TOO_LONG", nil)];;
        return false;
    }
//    else if (_txtPhone.text.length>0)
//    {
//        NSString *phone = _txtPhone.text;
//        NSError *error1 = NULL;
//        NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber error:&error1];
//        NSArray *matches = [detector matchesInString:phone options:0 range:NSMakeRange(0, [phone length])];
//        if (!(matches != nil && matches.count ==1)) {
//            [error appendString:NSLocalizedString(@"USER_NICKIE_VALIDATE_PHONE", nil)];
//            return false;
//        }
//    }
    return true;
}

#pragma UITableViewController delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    int yHeight = 44;
    int xOffset = 10;
    int yOffset = 11.5;
    switch (indexPath.row) {
        case 0:
        {
            UILabel* _nickNameLb = [[UILabel alloc] initWithFrame:CGRectMake(xOffset, yOffset, 44, 0)];
            _nickNameLb.text = NSLocalizedString(@"User Nickie", nil);
            _nickNameLb.textColor = [UIColor lightGrayColor];
            _nickNameLb.textAlignment = UITextAlignmentRight;
            _nickNameLb.backgroundColor = [UIColor clearColor];
            [_nickNameLb sizeToFit];
            
            
            if (!_nickField) {
                _nickField = [[UITextField alloc] initWithFrame:CGRectMake(_nickNameLb.frame.origin.x + _nickNameLb.frame.size.width, 0, 300-_nickNameLb.frame.size.width - _nickNameLb.frame.origin.x, yHeight)];
                _nickField.placeholder = NSLocalizedString(@"Input Nickie Tip", nil);
                _nickField.delegate = self;
                _nickField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                _nickField.text = currentUser.nickie;
            }
            
            [cell.contentView addSubview:_nickNameLb];
            [cell.contentView addSubview:_nickField];
        }
            break;
        case 1:
        {
            UILabel* _phoneLb = [[UILabel alloc] initWithFrame:CGRectMake(xOffset, yOffset, yHeight, 0)];
            _phoneLb.text = NSLocalizedString(@"Contact phone tip", nil);
            _phoneLb.textColor = [UIColor lightGrayColor];
            _phoneLb.textAlignment = UITextAlignmentRight;
            _phoneLb.backgroundColor = [UIColor clearColor];
            [_phoneLb sizeToFit];
            NSLog(@"%@", NSStringFromCGRect(_phoneLb.frame));
            
            if (!_phoneField) {
                _phoneField = [[UITextField alloc] initWithFrame:CGRectMake(_phoneLb.frame.origin.x + _phoneLb.frame.size.width, 0, 300-_phoneLb.frame.size.width - _phoneLb.frame.origin.x, yHeight)];
                _phoneField.delegate = self;
                _phoneField.placeholder = NSLocalizedString(@"Input Phone Tip", nil);
                _phoneField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            }
            
            [cell.contentView addSubview:_phoneLb];
            [cell.contentView addSubview:_phoneField];
        }
            break;
        case 2:
        {
            UILabel* _sexLb = [[UILabel alloc] initWithFrame:CGRectMake(xOffset, yOffset, 44, 0)];
            _sexLb.text = NSLocalizedString(@"Gender Tip", nil);
            _sexLb.textColor = [UIColor lightGrayColor];
            _sexLb.textAlignment = UITextAlignmentRight;
            _sexLb.backgroundColor = [UIColor clearColor];
            [_sexLb sizeToFit];
            
            if (!_btnSex) {
                _btnSex = [UIButton buttonWithType:UIButtonTypeCustom];
                UIEdgeInsets _inset = _btnSex.contentEdgeInsets;
                _inset.right = 35;
                _btnSex.contentEdgeInsets = _inset;
                [_btnSex setTitle:NSLocalizedString(@"Male", nil) forState:UIControlStateNormal];
                [_btnSex setBackgroundImage:[UIImage imageNamed:@"gendar_icon.png"] forState:UIControlStateNormal];
                [_btnSex setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                _btnSex.frame = CGRectMake(_sexLb.frame.origin.x + _sexLb.frame.size.width + 15, 7, 90, 30);
                [_btnSex addTarget:self action:@selector(selectSex:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            [cell.contentView addSubview:_sexLb];
            [cell.contentView addSubview:_btnSex];
        }
            break;
        case 3:
        {
            UILabel* _signLb = [[UILabel alloc] initWithFrame:CGRectMake(xOffset, yOffset, 44, 0)];
            _signLb.text = NSLocalizedString(@"Signature Tip", nil);
            _signLb.textColor = [UIColor lightGrayColor];
            _signLb.textAlignment = UITextAlignmentRight;
            _signLb.backgroundColor = [UIColor clearColor];
            [_signLb sizeToFit];
            
            if (!_signField) {
                _signField = [[UITextField alloc] initWithFrame:CGRectMake(_signLb.frame.origin.x + _signLb.frame.size.width, 0, 300-_signLb.frame.size.width - _signLb.frame.origin.x, yHeight)];
                _signField.placeholder = NSLocalizedString(@"Signature place holder", nil);
                _signField.delegate = self;
                _signField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            }
            
            [cell.contentView addSubview:_signLb];
            [cell.contentView addSubview:_signField];
        }
            break;
        default:
            break;
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectSex:(id)sender {
    if (pickerIsShow) {
        [self hidenPickerView:YES];
    }
    else {
        [self showPickerView];
    }
}

- (IBAction)onButtonBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doSave:(id)sender {
    NSMutableString *error = [@"" mutableCopy];
    if([self validateUser:&error])
    {
        FSUserProfileRequest *request = [[FSUserProfileRequest alloc] init];
        //request.routeResourcePath = RK_REQUEST_USER_PROFILE_UPDATE;
        request.userToken = currentUser.uToken;
        request.nickie = [_nickField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
        request.phone = [_phoneField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
        //request.desc = [_signField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
        //request.gender = [NSNumber numberWithInt:gender];
        [self beginLoading:self.view];
        [request send:[FSUser class] withRequest:request completeCallBack:^(FSEntityBase *resp) {
            if (!resp.isSuccess)
            {
                [self reportError:resp.description];
            }
            else
            {
                currentUser.nickie = request.nickie;
                [self reportError:NSLocalizedString(@"COMM_OPERATE_COMPL", nil)];
            }
            [self endLoading:self.view];
        }];
    }
    else
    {
        [self reportError:error];
    }
}
- (void)viewDidUnload {
    [self setTbAction:nil];
    [super viewDidUnload];
}

#pragma UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
}
#pragma UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (row == 0) {
        return NSLocalizedString(@"Male", nil);
    }
    if (row == 1) {
        return  NSLocalizedString(@"Female", nil);
    }
    return @"";
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self hidenPickerView:YES];
    _activityField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

@end
