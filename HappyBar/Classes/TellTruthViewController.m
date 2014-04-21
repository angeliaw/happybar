//
//  TellTruthViewController.m
//  HappyBar
//
//  Created by Angelia on 13-2-14.
//  Copyright (c) 2013年 WANG. All rights reserved.
//

#import "TellTruthViewController.h"
#import "QuestionManage.h"

#import "AURosetteView.h"
#import <AudioToolbox/AudioToolbox.h>


bool btnNextFlag;
bool btnSettingFlag;

static int orderX = 0;
bool show2QFlag; //YES, show 2 questions, NO, show 1 question
bool showInventure;//YES, show Inventure questions, NO, show TrueWords
bool showWarm;//YES, show Warm questions, NO, show gradeStimulating questions

int menuItem; //0,一个问题, 1,两个问题, 2,大冒险,3,真心话,4,温馨,5,刺激

#define kQuestionsTypeI @"大冒险"
#define kQuestionsTypeT @"真心话"

#define kQuestionsGradeW @"温馨"
#define kQuestionsGradeS @"刺激"

@interface TellTruthViewController (){
    AURosetteView* rosette;
    UITapGestureRecognizer *tap;
}
@property (nonatomic,retain) IBOutlet UIButton *btnHome;
@property (nonatomic,retain) IBOutlet UILabel *titleLabel;

@property (nonatomic,retain) IBOutlet UILabel *questionA;
@property (nonatomic,retain) IBOutlet UILabel *questionB;

@property (nonatomic,retain) IBOutlet UIButton *btnNext;
@property (nonatomic,retain) IBOutlet UIButton *btnSetting;
@property (nonatomic,retain) QuestionManage *quesM;

@end

@implementation TellTruthViewController
@synthesize btnHome;
@synthesize questionA,questionB,btnNext,btnSetting,titleLabel;
@synthesize quesM;

#pragma mark - Shake

- (BOOL) canBecomeFirstResponder
{
    return YES;
}

- (void) motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event

{
    if (motion == UIEventSubtypeMotionShake) {
        
        [self dismissMenuSettings];
        NSLog(@"Shake..........");
        
        //show shake animation
        UIImageView *aboutView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"waiting.png"]];
        aboutView.alpha = 0;
        aboutView.center = CGPointMake(160, 200);
        aboutView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        [self.view addSubview:aboutView];
        
        [UIView animateWithDuration:1
                         animations:^{
                             aboutView.center = CGPointMake(160, 200);
                             aboutView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                             aboutView.alpha = 1.0;
                         } completion:^(BOOL finished) {
                             [UIView animateWithDuration:1.5
                                              animations:^{
                                                  aboutView.center = CGPointMake(160, 200);
                                                  aboutView.transform = CGAffineTransformMakeScale(1.04, 1.04);
                                              } completion:^(BOOL finished) {
                                              }];
                             [UIView animateWithDuration:1.5
                                                   delay:0.3
                                                 options:UIViewAnimationOptionAllowUserInteraction
                                              animations:^{
                                                  aboutView.alpha = 0;
                                              } completion:^(BOOL finished) {
                                                  [aboutView removeFromSuperview];
                                                  [aboutView release];
                                              }];
                             
                         }];
        //play shake sound
        
        SystemSoundID soundID = 0;
        NSURL *soundURL = [[NSBundle mainBundle] URLForResource:@"shake" withExtension:@"wav"];
        AudioServicesCreateSystemSoundID((CFURLRef)soundURL,&soundID);
        AudioServicesPlaySystemSound(soundID);
        
        if (show2QFlag == YES) {
            orderX +=2;
            [self showQuestion];
        }
        else{
            orderX +=1;
            [self showQuestion];
        }
    }
}


#pragma mark - private functions

- (void)backToHome
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)buttonNextClicked{
    [self dismissMenuSettings];
    
//    if(btnNextFlag == YES){
//        
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
//        [UIView setAnimationBeginsFromCurrentState:YES];
//        [UIView setAnimationDuration:1];
//        //改变button的frame
////        [btnNext setFrame:CGRectMake(138, 448, 44, 44)];
//        [btnNext setTransform:CGAffineTransformMakeRotation(80)];
//        [UIView commitAnimations];
//        btnNextFlag = NO;
//        
//    }
//    else{
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
//        [UIView setAnimationBeginsFromCurrentState:YES];
//        [UIView setAnimationDuration:1];
//        //改变button的frame
////        [btnNext setFrame:CGRectMake(138, 448, 44, 44)];
//        [btnNext setTransform:CGAffineTransformMakeRotation(-30)];
//        [UIView commitAnimations];
//        btnNextFlag = YES;
//    }
//    NSLog(@"orderX:%d",orderX);
    
    if (show2QFlag == YES) {
        orderX +=2;
        [self showQuestion];
    }
    else{
        orderX +=1;
        [self showQuestion];
    }
}

- (void)buttonSettingClicked{
    if(btnSettingFlag == YES){
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:1];
        //改变button的frame
//        [btnSetting setFrame:CGRectMake(50, 355, 44, 44)];
        [btnSetting setTransform:CGAffineTransformMakeRotation(80)];
        [UIView commitAnimations];
        btnSettingFlag = NO;
        
    }
    else{
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:1];
        //改变button的frame
//        [btnSetting setFrame:CGRectMake(50, 355, 44, 44)];
        [btnSetting setTransform:CGAffineTransformMakeRotation(-30)];
        [UIView commitAnimations];
        btnSettingFlag = YES;
    }
    
}

- (void)settingsViewAdded{
    
    UIImage* choose1Image = [UIImage imageNamed:@"choose1.png"];
    UIImage* choose2Image = [UIImage imageNamed:@"choose2.png"];
    UIImage* inventureImage = [UIImage imageNamed:@"inventure.png"];
    UIImage* trueWordsImage = [UIImage imageNamed:@"trueword.png"];
   
    UIImage* gradeHImage = [UIImage imageNamed:@"gradeH.png"];
    UIImage* gradeMImage = [UIImage imageNamed:@"gradeM.png"];
    
    // create rosette items
    AURosetteItem* chooseFromOne= [[AURosetteItem alloc] initWithNormalImage:choose1Image
                                                               highlightedImage:nil
                                                                         target:self
                                                                         action:@selector(choose1Action:)];
    
    AURosetteItem* chooseFromTwo = [[AURosetteItem alloc] initWithNormalImage:choose2Image
                                                            highlightedImage:nil
                                                                      target:self
                                                                      action:@selector(choose2Action:)];
    
    AURosetteItem* inventure = [[AURosetteItem alloc] initWithNormalImage:inventureImage
                                                        highlightedImage:nil
                                                                  target:self
                                                                  action:@selector(chooseInventure:)];
    
    AURosetteItem* trueWords = [[AURosetteItem alloc] initWithNormalImage:trueWordsImage
                                                         highlightedImage:nil
                                                                   target:self
                                                                   action:@selector(chooseTrueWords:)];
    
    AURosetteItem* gradeStimulating = [[AURosetteItem alloc] initWithNormalImage:gradeHImage
                                                        highlightedImage:nil
                                                                  target:self
                                                                  action:@selector(choosegradeStimulating:)];
    
    AURosetteItem* gradeWarm = [[AURosetteItem alloc] initWithNormalImage:gradeMImage
                                                     highlightedImage:nil
                                                               target:self
                                                               action:@selector(choosegradeWarm:)];

    
    // create rosette view
    rosette = [[AURosetteView alloc] initWithItems: [NSArray arrayWithObjects:trueWords,chooseFromOne, chooseFromTwo,gradeStimulating,gradeWarm,inventure, nil]];
    [rosette setCenter:CGPointMake(160.0f, 365.0f)];
    
    [self.view addSubview:rosette];
    
    [self.view setNeedsDisplay];
}

- (void)dismissMenuSettings{
    
    if(rosette.on == YES){
        [rosette setOn:NO animated:NO];}
    
}

#pragma mark Actions

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)choose1Action:(id)sender {
    NSLog(@"choose one question");
    [rosette setOn:NO animated:YES];
    
    show2QFlag = NO;
    menuItem = 0;
//    [self show1Question];
    [self showQuestion];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)choose2Action:(id)sender {
    NSLog(@"choose one from 2");
    [rosette setOn:NO animated:YES];
    
    show2QFlag = YES;
    menuItem = 1;
//    [self show2Questions];
    [self showQuestion];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)chooseInventure:(id)sender {
    [rosette setOn:NO animated:YES];
    showInventure =YES;
    menuItem = 2;
//    [self changeQuestionType];
    [self showQuestion];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)chooseTrueWords:(id)sender {
    [rosette setOn:NO animated:YES];
    showInventure =NO;
    menuItem = 3;
//    [self changeQuestionType];
    [self showQuestion];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)choosegradeStimulating:(id)sender {
    [rosette setOn:NO animated:YES];
    showWarm = NO;
    menuItem = 5;
//    [self changeQuestionGrade];
    [self showQuestion];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)choosegradeWarm:(id)sender {
    [rosette setOn:NO animated:YES];
    showWarm = YES;
    menuItem = 4;
//    [self changeQuestionGrade];
    [self showQuestion];
}

////////////////////////////////////////////////////////////////////////////////////////////////////


- (void) showQuestionsbyRandom{
    
    NSMutableArray *nQues = [[NSMutableArray alloc]init];
    quesM = [[QuestionManage alloc]init];
    [quesM openDatabase];
    
    NSMutableArray *nCont = [[NSMutableArray alloc]init];
    [quesM getQuestionsContent:nCont];
    
    NSInteger x = nCont.count-2;
    int randomA = arc4random()%x;
    
    [questionA setText:nCont[randomA]];
    [questionA setTextColor:[UIColor grayColor]];
    [questionB setText:nCont[randomA+1]];
    [questionB setTextColor:[UIColor grayColor]];
    
    [self.view setNeedsDisplay];
    
    [quesM closeDatabase];
    [nCont release];
    [nQues release];
}

- (void) showQuestion{
    
    NSMutableArray *nQues = [[NSMutableArray alloc]init];
    quesM = [[QuestionManage alloc]init];
    [quesM openDatabase];
    
    NSMutableArray *nCont = [[NSMutableArray alloc]init];
    switch (menuItem) {
        case 0:
            [quesM getQuestionsContent:nCont];
            break;
        case 1:
            [quesM getQuestionsContent:nCont];
            break;
        case 2:
            [quesM getQuestionsContentByType:nCont type:kQuestionsTypeI];
            break;
        case 3:
            [quesM getQuestionsContentByType:nCont type:kQuestionsTypeT];
            break;
        case 4:
            [quesM getQuestionsContentByGrade:nCont grade:kQuestionsGradeW];
            break;
        case 5:
            [quesM getQuestionsContentByGrade:nCont grade:kQuestionsGradeS];
            break;
            
        default:
            break;
    }
    
    orderX = orderX%nCont.count;
    if (show2QFlag == YES) {
        [questionA setText:nCont[orderX]];
        [questionB setText:nCont[(orderX+1)%nCont.count]];
    }
    else{
        [questionA setText:nCont[orderX]];
        [questionB setText:NULL];
    }
    
    [self.view setNeedsDisplay];
    
    [quesM closeDatabase];
    [nCont release];
    [nQues release];
}


- (void) show1Question{
    
    NSMutableArray *nQues = [[NSMutableArray alloc]init];
    quesM = [[QuestionManage alloc]init];
    [quesM openDatabase];
    
    NSMutableArray *nCont = [[NSMutableArray alloc]init];
    [quesM getQuestionsContent:nCont];
    //NSLog(@"%@",nCont);
    
    orderX = orderX%nCont.count;
    
    [questionA setText:nCont[orderX]];
    [questionB setText:NULL];
    
    [self.view setNeedsDisplay];
    
    [quesM closeDatabase];
    [nCont release];
    [nQues release];
}

- (void) show2Questions{
    NSMutableArray *nQues = [[NSMutableArray alloc]init];
    quesM = [[QuestionManage alloc]init];
    [quesM openDatabase];
    
    NSMutableArray *nCont = [[NSMutableArray alloc]init];
    
    [quesM getQuestionsContent:nCont];
    
    orderX = orderX%nCont.count;
    
    [questionA setText:nCont[orderX]];
    [questionB setText:nCont[(orderX+1)%nCont.count]];
    
    [self.view setNeedsDisplay];
    
    [quesM closeDatabase];
    [nCont release];
    [nQues release];
    
}

- (void)changeQuestionType{
    NSMutableArray *nQues = [[NSMutableArray alloc]init];
    quesM = [[QuestionManage alloc]init];
    [quesM openDatabase];
    
    NSMutableArray *nCont = [[NSMutableArray alloc]init];
    
    if(showInventure == YES){
//        [quesM getQuestionsContentByType:nCont type:kQuestionsTypeI];
        if(showWarm == YES)
            [quesM getQuestionsContent:nCont type:kQuestionsTypeI grade:kQuestionsGradeW];
        else
            [quesM getQuestionsContent:nCont type:kQuestionsTypeI grade:kQuestionsGradeS];
    }else{
//        [quesM getQuestionsContentByType:nCont type:kQuestionsTypeT];
        if(showWarm == YES)
            [quesM getQuestionsContent:nCont type:kQuestionsTypeT grade:kQuestionsGradeW];
        else
            [quesM getQuestionsContent:nCont type:kQuestionsTypeT grade:kQuestionsGradeS];
    }
    
    orderX = orderX%nCont.count;
    if (show2QFlag == YES) {
        [questionA setText:nCont[orderX]];
        [questionB setText:nCont[(orderX+1)%nCont.count]];
    }
    else{
        [questionA setText:nCont[orderX]];
        [questionB setText:NULL];
    }
    
    [self.view setNeedsDisplay];
    
    [quesM closeDatabase];
    [nCont release];
    [nQues release];
    
}

- (void)changeQuestionGrade{
    NSMutableArray *nQues = [[NSMutableArray alloc]init];
    quesM = [[QuestionManage alloc]init];
    [quesM openDatabase];
    
    NSMutableArray *nCont = [[NSMutableArray alloc]init];
    
    if(showWarm == YES){
//        [quesM getQuestionsContentByGrade:nCont grade:kQuestionsGradeW];
        if(showInventure == YES)
            [quesM getQuestionsContent:nCont type:kQuestionsTypeI grade:kQuestionsGradeW];
        else
            [quesM getQuestionsContent:nCont type:kQuestionsTypeT grade:kQuestionsGradeW];
    }
    else{
//        [quesM getQuestionsContentByGrade:nCont grade:kQuestionsGradeS];
        if(showInventure == YES)
            [quesM getQuestionsContent:nCont type:kQuestionsTypeI grade:kQuestionsGradeS];
        else
            [quesM getQuestionsContent:nCont type:kQuestionsTypeI grade:kQuestionsGradeS];
    }
    
    orderX = orderX%nCont.count;
    if (show2QFlag == YES) {
        [questionA setText:nCont[orderX]];
        [questionB setText:nCont[(orderX+1)%nCont.count]];
    }
    else{
        [questionA setText:nCont[orderX]];
        [questionB setText:NULL];
    }
    
    [self.view setNeedsDisplay];
    
    [quesM closeDatabase];
    [nCont release];
    [nQues release];
}


#pragma mark - viewcontroller
- (void)dealloc{
    [btnHome release];
    [quesM release];
    
    [rosette release];
    [tap release];
    [super dealloc];
}

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
    
    //show 2 questions for default.
    show2QFlag = YES;
    showInventure = NO;
    showWarm = YES;
    menuItem = 1;
    [self showQuestion];
    
    [titleLabel setText:@"摇一摇"];
    [titleLabel setTextColor:[UIColor whiteColor]];
    
    [questionA setTextColor:[UIColor grayColor]];
    [questionA setLineBreakMode:NSLineBreakByCharWrapping];
    [questionB setTextColor:[UIColor grayColor]];
    [questionB setLineBreakMode:NSLineBreakByCharWrapping];
    
    [self settingsViewAdded];
    
    btnNextFlag = YES;
    [btnNext addTarget:self action:@selector(buttonNextClicked) forControlEvents:UIControlEventTouchUpInside];
    
    tap = [[UITapGestureRecognizer alloc]
           initWithTarget:self
           action:@selector(dismissMenuSettings)];
    
    [self.view addGestureRecognizer:tap];

}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self resignFirstResponder];
    
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
