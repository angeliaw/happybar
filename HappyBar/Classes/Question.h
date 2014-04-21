//
//  Question.h
//  HappyBar
//
//  Created by Angelia on 13-2-15.
//  Copyright (c) 2013年 WANG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Question : NSObject{
    
    NSString *qid;
    NSString *content;
    NSString *type;
    NSString *grade;
}

@property (nonatomic,copy) NSString *qid;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *grade;

- (id)initWithQid:(NSString*)xqid content:(NSString *)xcontent type:(NSString*)xtype grade:(NSString *)xgrade;
@end
