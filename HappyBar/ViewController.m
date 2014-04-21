//
//  ViewController.m
//  HappyBar
//
//  Created by Angelia on 13-2-7.
//  Copyright (c) 2013年 WANG. All rights reserved.
//

#import "ViewController.h"
#import "TellTruthViewController.h"
#import "AboutViewController.h"
#import "MoreGamesViewController.h"

@interface ViewController ()
@property (nonatomic,retain) IBOutlet UIButton *btnTellTruth;
@property (nonatomic,retain) IBOutlet UIButton *btnMoreGames;
@property (nonatomic,retain) IBOutlet UIButton *btnAbout;

@end

@implementation ViewController
@synthesize btnTellTruth;
@synthesize btnMoreGames;
@synthesize btnAbout;

- (void)launchTellTruth{
    
    TellTruthViewController *tellTruth = [[TellTruthViewController alloc]init];
    [self presentViewController:tellTruth animated:YES completion:^{}];
    [tellTruth release];
}

- (void)lauchAbout{
    
    AboutViewController *about = [[AboutViewController alloc]init];
    [self presentViewController:about animated:YES completion:^{}];
    [about release];
}

- (void)launchMoreGames{
//    MoreGamesViewController *more = [[MoreGamesViewController alloc]init];
//    [self presentViewController:more animated:YES completion:^{}];
//    [more release];
    //show shake animation
    //UIImageView *aboutView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"waiting.png"]];
    UIView *aboutView = [[UIView alloc]initWithFrame:CGRectMake(60, 170, 200, 160)];
//    [aboutView  setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, 200, 60)];
    label.text = @"更多游戏敬请期待......";
    [label setTextColor:[UIColor whiteColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
    [label setFont:[UIFont boldSystemFontOfSize:22]];
    [aboutView addSubview:label];
    [label release];
    
    aboutView.alpha = 0;
    aboutView.center = CGPointMake(160, 270);
    aboutView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [self.view addSubview:aboutView];
    
    [UIView animateWithDuration:1
                     animations:^{
                         aboutView.center = CGPointMake(160, 270);
                         aboutView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                         aboutView.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:2.0
                                          animations:^{
                                              aboutView.center = CGPointMake(160, 270);
                                              aboutView.transform = CGAffineTransformMakeScale(1.04, 1.04);
                                          } completion:^(BOOL finished) {
                                          }];
                         [UIView animateWithDuration:2
                                               delay:0.6
                                             options:UIViewAnimationOptionAllowUserInteraction
                                          animations:^{
                                              aboutView.alpha = 0;
                                          } completion:^(BOOL finished) {
                                              [aboutView removeFromSuperview];
                                              [aboutView release];
                                          }];
                         
                     }];

    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
    
    [btnTellTruth setTitle:@"真心话" forState:UIControlStateNormal];
    [btnTellTruth setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btnTellTruth setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnTellTruth addTarget:self action:@selector(launchTellTruth) forControlEvents:UIControlEventTouchUpInside];
    
    [btnMoreGames setTitle:@"更多游戏" forState:UIControlStateNormal];
    [btnMoreGames setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btnMoreGames setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnMoreGames addTarget:self action:@selector(launchMoreGames) forControlEvents:UIControlEventTouchUpInside];
    
    [btnAbout addTarget:self action:@selector(lauchAbout) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
