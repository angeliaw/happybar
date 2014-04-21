//
//  MoreGamesViewController.m
//  HappyBar
//
//  Created by Angelia on 13-3-6.
//  Copyright (c) 2013年 WANG. All rights reserved.
//

#import "MoreGamesViewController.h"

@interface MoreGamesViewController ()
@property (nonatomic,retain) IBOutlet UIButton *btnHome;

@end

@implementation MoreGamesViewController
@synthesize btnHome;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
