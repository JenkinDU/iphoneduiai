//
//  SetEmailViewController.m
//  iphoneduiai
//
//  Created by yinliping on 12-10-7.
//  Copyright (c) 2012年 duiai.com. All rights reserved.
//

#import "SetEmailViewController.h"
#import "CustomBarButtonItem.h"
#import "Utils.h"
#import <RestKit/RestKit.h>
#import <RestKit/JSONKit.h>
#import "SVProgressHUD.h"

@interface SetEmailViewController ()

@end

@implementation SetEmailViewController


-(void)loadView
{
    [super loadView];
    
    NSDictionary *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];

    self.view.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];

    UIView *emailView = [[[UIView alloc]initWithFrame:CGRectMake(10, 15, 300, 44)]autorelease];
    emailView.backgroundColor = [UIColor whiteColor];
    UILabel *emailLabel = [[[UILabel alloc]initWithFrame:CGRectMake(7, 15, 40, 16)]autorelease];
    emailLabel.text = @"邮箱";
    emailLabel.font = [UIFont systemFontOfSize:16.0f];
    emailField = [[[UITextField alloc]initWithFrame:CGRectMake(80, 13, 170, 18)]autorelease];
    emailField.textColor = RGBCOLOR(179, 179, 179);
    emailField.font = [UIFont systemFontOfSize:14.0f];
    emailField.enabled = NO;
    emailField.text = user[@"username"];
    [emailView addSubview:emailLabel];
    [emailView addSubview:emailField];
    [emailField becomeFirstResponder ];
    [self.view addSubview:emailView];
    
    UIButton *verifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    verifyButton.frame = CGRectMake(10, 70, 300, 44);
    verifyButton.backgroundColor =RGBCOLOR(191, 235, 114);
    [verifyButton setTitle:@"主动验证邮箱" forState:UIControlStateNormal];
    [verifyButton addTarget:self action:@selector(sendEMail) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:verifyButton];
    
    
    UILabel *tipLabel = [[[UILabel alloc]initWithFrame:CGRectMake(10, 120, 300, 60)]autorelease];
    tipLabel.text =  @"邮箱用来登陆对爱和找回密码的唯一账号。\n如需要更改邮件绑定，请使用新邮箱发送一封标题为100010310的邮件到love@duiai.com,发送成功后即可自动绑定。\n更换绑定后，请使用新邮箱登陆。";
    tipLabel.numberOfLines = 0;
    tipLabel.lineBreakMode = UILineBreakModeCharacterWrap;
    tipLabel.font = [UIFont systemFontOfSize:10];
    tipLabel.textColor = RGBCOLOR(139, 139, 139);
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.opaque = YES;
    tipLabel.shadowColor = [UIColor whiteColor];
    tipLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    
    [self.view addSubview:tipLabel];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    self.navigationItem.titleView = [CustomBarButtonItem titleForNavigationItem:@"邮箱设置"];
    self.navigationItem.leftBarButtonItem = [[[CustomBarButtonItem alloc] initBackBarButtonWithTitle:@"返回"
                                                                                              target:self
                                                                                              action:@selector(backAction)] autorelease];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

//点击按钮后，触发这个方法
-(void)sendEMail
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    
    if (mailClass != nil)
    {
        if ([mailClass canSendMail])
        {
            [self displayComposerSheet];
        }
        else
        {
            [self launchMailAppOnDevice];
        }
    }
    else
    {
        [self launchMailAppOnDevice];
    }
}

//可以发送邮件的话
- (void)displayComposerSheet
{
   
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    
    
    [mc setSubject:@"10010310"];
    
    NSString *emailBody = @"对爱会员邮件验证";
    [mc setMessageBody:emailBody isHTML:YES];
    
    //设置收件人
    [mc setToRecipients:[NSArray arrayWithObject:@"love@duai.com"]];
    
    [self presentModalViewController:mc animated:YES];
    [mc release];

}
-(void)launchMailAppOnDevice
{
    NSString *recipients = @"mailto:first@example.com&subject=my email!";
    //@"mailto:first@example.com?cc=second@example.com,third@example.com&subject=my email!";
    NSString *body = @"&body=email body!";
    
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
    email = [email stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:email]];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSString *msg;
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            msg = @"邮件发送取消";
            break;
        case MFMailComposeResultSaved:
            msg = @"邮件保存成功";
            break;
        case MFMailComposeResultSent:
            msg = @"邮件发送成功";
                       break;
        case MFMailComposeResultFailed:
            msg = @"邮件发送失败";
            break;
        default:
            break;
    }
    [SVProgressHUD showSuccessWithStatus:msg];
    [self dismissModalViewControllerAnimated:YES];
}
@end
