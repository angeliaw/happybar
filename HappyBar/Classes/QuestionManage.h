//
//  QuestionManage.h
//  HappyBar
//
//  Created by Angelia on 13-2-15.
//  Copyright (c) 2013年 WANG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "Question.h"

@interface QuestionManage : NSObject{
   
    sqlite3 *questionsMng; //questions database
//    NSString *dbFilePath; // database file path
    
}

@property (nonatomic) sqlite3 *questionsMng;

- (NSString *)dataFilePath;
- (BOOL)openDatabase;
- (void)initDatabase;
- (void)closeDatabase;


- (BOOL)insertQuestion:(NSString *)qid content:(NSString *)content type:(NSString*)type grade:(NSString*)grade;
- (NSString *) getQuestionsContentbyId:(NSString*)qid;
- (void) getQuestionsContent:(NSMutableArray*)nContent;
- (void) getQuestionsContentByType:(NSMutableArray*)nContent type:(NSString*)xType;
- (void) getQuestionsContentByGrade:(NSMutableArray*)nContent grade:(NSString*)xGrade;
- (void) getQuestionsContent:(NSMutableArray*)nContent type:(NSString*)xType grade:(NSString*)xGrade;

- (void) getQuestions:(NSMutableArray*)nQuestions;
- (BOOL)clearQuestions;
- (BOOL) isTableExisted:(NSString *)tableName database:(sqlite3*)sqlitedb;


- (void)testDB;
@end
