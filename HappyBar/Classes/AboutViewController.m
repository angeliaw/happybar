//
//  AboutViewController.m
//  HappyBar
//
//  Created by Angelia on 13-3-6.
//  Copyright (c) 2013年 WANG. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()
@property (nonatomic,retain) IBOutlet UIButton *btnHome;
@property (nonatomic,retain) IBOutlet UILabel *appName;
@property (nonatomic,retain) IBOutlet UILabel *versionNo;
@property (nonatomic,retain) IBOutlet UILabel *companyName;

@end

@implementation AboutViewController
@synthesize btnHome;
@synthesize appName,versionNo,companyName;

#pragma mark - private functions

- (void)backToHome
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - view controller

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
    
    [btnHome addTarget:self action:@selector(backToHome) forControlEvents:UIControlEventTouchUpInside];
    
    [appName setText:@"酒吧乐乐"];
    [appName setTextColor:[UIColor whiteColor]];
    
    [versionNo setText:@"V1.0"];
    [versionNo  setTextColor:[UIColor whiteColor]];
    [companyName setText:@"SimpleBest,Inc.2013"];
    [companyName  setTextColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
