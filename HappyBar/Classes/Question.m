//
//  Question.m
//  HappyBar
//
//  Created by Angelia on 13-2-15.
//  Copyright (c) 2013年 WANG. All rights reserved.
//

#import "Question.h"

@implementation Question
@synthesize qid,content,type,grade;

- (id)initWithQid:(NSString *)xqid content:(NSString *)xcontent type:(NSString*)xtype grade:(NSString *)xgrade
{
    self = [super init];
    if (self) {
        self.qid = xqid;
        self.content =  xcontent;
        self.type = xtype;
        self.grade = xgrade;
    }
    return self;
}

- (void)dealloc{
    [super dealloc];
}

@end
