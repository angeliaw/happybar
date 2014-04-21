//
//  QuestionManage.m
//  HappyBar
//
//  Created by Angelia on 13-2-15.
//  Copyright (c) 2013年 WANG. All rights reserved.
//

#import "QuestionManage.h"
#define dbFileName @"database.sqlite" 


@implementation QuestionManage
@synthesize questionsMng;

#pragma mark - database functions

//Return Database path
- (NSString *)dataFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:dbFileName];
    return path;
}

//open database
- (BOOL)openDatabase{

    NSString *path = [self dataFilePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL bExist = [fileManager fileExistsAtPath:path];
    
    // database is found
    if (bExist) {
//        NSLog(@"Database file have already existed.");
        if(sqlite3_open([path UTF8String], &questionsMng) != SQLITE_OK) {
            sqlite3_close(questionsMng);
            NSLog(@"Error: open database file.");
            return NO;
        }
        return YES;
    }
    
    //create database
    if(sqlite3_open([path UTF8String], &questionsMng) == SQLITE_OK) {
        NSLog(@"database is Open!");
        [self createQuestionsTable:questionsMng]; //create table
        return YES;
    }
    else{
        sqlite3_close(questionsMng);
        NSLog(@"Error: open database file.");
        return NO;
    }
    
    return NO;
}

//init database
- (void)initDatabase{
    NSString *path = [self dataFilePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL bExist = [fileManager fileExistsAtPath:path];
    
    if (bExist) {
        int count = [self getTableQuestionCount];
        NSLog(@"count---%d",count);
        if (!count) {
            [self readPlist:@"大冒险" plistGrade:@"刺激"];
            [self readPlist:@"大冒险" plistGrade:@"温馨"];
            [self readPlist:@"真心话" plistGrade:@"刺激"];
            [self readPlist:@"真心话" plistGrade:@"温馨"];
            NSLog(@"finish init db");
        }
    }
}

- (void)closeDatabase{
    sqlite3_close(questionsMng);
}


#pragma mark-
- (void)readPlist:(NSString *)plistType plistGrade:(NSString *)plistGrade{
    
    NSString *plistName = [NSString stringWithFormat:@"%@%@", plistType, plistGrade];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary  alloc]initWithContentsOfFile:plistPath];
    
    NSDictionary *question = [dict objectForKey: @"questions"];
    
    for (NSString *str in question){
//        NSLog(@"%@", str);
//        NSLog(@"%@", plistType);
        [self insertQuestion:@"" content:str type:plistType grade:plistGrade];
    }
    
}

#pragma mark - table functions

//(id,content,type,grade)
//type:真心话，大冒险
//grade:高级，中级，普通

- (BOOL)createQuestionsTable:(sqlite3 *)database{
    char *sql = "CREATE TABLE questions (qid integer primary key, \
    content text, \
    type text, \
    grade text)";
    sqlite3_stmt *statement;
    if(sqlite3_prepare_v2(database, sql, -1, &statement, nil) != SQLITE_OK) {
        NSLog(@"Error: failed to prepare statement");
        return NO;
    }
    
    int success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    if ( success != SQLITE_DONE) {
        NSLog(@"Error: failed to:CREATE TABLE");
        return NO;
    }
    NSLog(@"Create table successed.");
    return YES;
}

- (void) getQuestions:(NSMutableArray*)nQuestions{
    sqlite3_stmt *statement = nil;
    char *sql = "SELECT * FROM questions";
    if (sqlite3_prepare_v2(questionsMng, sql, -1, &statement, NULL) != SQLITE_OK) {
        NSLog(@"Error: failed to prepare statement.");
    }

    while (sqlite3_step(statement) == SQLITE_ROW) {
        NSString *xqid       = (NSString*)sqlite3_column_text(statement, 0);
        NSString *xcontent     = (NSString*)sqlite3_column_text(statement, 1);
        NSString *xtype = (NSString*)sqlite3_column_text(statement, 2);
        NSString *xgrade    = (NSString*)sqlite3_column_text(statement, 3);
        
        Question *question = [[Question alloc] init];
        if(xqid)
            question.qid = [NSString stringWithString: xqid];
        if(xcontent)
            question.content =  [NSString stringWithString:xcontent];
        if(xtype)
            question.type = [NSString stringWithString:xtype];
        if(xgrade)
            question.grade = [NSString stringWithString:xgrade];
        
        [nQuestions addObject:question];
        [question release];
    }

    sqlite3_finalize(statement);
}

- (NSString *) getQuestionsContentbyId:(NSString*)qid{
    sqlite3_stmt *statement = nil;
    
    NSString *sql = [NSString stringWithFormat:@"SELECT  DISTINCT content FROM  questions WHERE qid='%@';",qid];
    NSString *rcontent = nil;
    
    if (sqlite3_prepare_v2(questionsMng, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            NSString *xcontent = (NSString*)sqlite3_column_text(statement, 1);
            if(xcontent)
                rcontent = [[[NSString alloc] initWithString:xcontent] autorelease];
        }
    }else{
        NSLog(@"Error: failed to prepare statement.");
    }
    
    return rcontent;
    sqlite3_finalize(statement);
}

- (void) getQuestionsContent:(NSMutableArray*)nContent{
    sqlite3_stmt *statement = nil;
    NSString *sql = @"SELECT * FROM questions";
    
    if (sqlite3_prepare_v2(questionsMng, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        
        while (sqlite3_step(statement) != SQLITE_DONE) {
            
            char *xcontent = (char*)sqlite3_column_text(statement, 1);
           // NSLog(@"-----%s",sqlite3_column_text(statement, 1));
            NSString *rcontent = nil;
            
            if(xcontent)
                rcontent = [NSString stringWithUTF8String:xcontent];
            [nContent addObject:rcontent];
        }
    }else{
        NSLog(@"Error: failed to prepare statement.");
    }
    
    sqlite3_finalize(statement);
}

- (void) getQuestionsContentByType:(NSMutableArray*)nContent type:(NSString*)xType{
    sqlite3_stmt *statement = nil;
    NSString *sql =[NSString stringWithFormat:@"SELECT * FROM questions WHERE type='%@'",xType];
//    NSLog(@"type:%@",xType);
//    NSLog(@"sql:%@",sql);
    
    if (sqlite3_prepare_v2(questionsMng, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {

        while (sqlite3_step(statement) != SQLITE_DONE) {
            
            char *ycontent = (char*)sqlite3_column_text(statement, 1);
            char *yType = (char*)sqlite3_column_text(statement, 2);

            NSString *rcontent = nil;
            
            bool result = [[NSString stringWithUTF8String:yType] isEqualToString:xType];
            
            if(ycontent && result==YES)
                rcontent = [NSString stringWithUTF8String:ycontent];
            [nContent addObject:rcontent];
        }
    }else{
        NSLog(@"Error: failed to prepare statement.");
    }
    
    sqlite3_finalize(statement);
    
}

- (void) getQuestionsContentByGrade:(NSMutableArray*)nContent grade:(NSString*)xGrade{
    sqlite3_stmt *statement = nil;
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM questions WHERE grade='%@'",xGrade];
    
    if (sqlite3_prepare_v2(questionsMng, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        
        while (sqlite3_step(statement) != SQLITE_DONE) {
            
            char *ycontent = (char*)sqlite3_column_text(statement, 1);
            char *yGrade = (char*)sqlite3_column_text(statement, 3);
            
            NSString *rcontent = nil;
            bool result = [[NSString stringWithUTF8String:yGrade] isEqualToString:xGrade];
            
            if(ycontent !=nil && result==YES)
                rcontent = [NSString stringWithUTF8String:ycontent];
            [nContent addObject:rcontent];
        }
    }else{
        NSLog(@"Error: failed to prepare statement.");
    }
    
    sqlite3_finalize(statement);
    
}

- (void) getQuestionsContent:(NSMutableArray*)nContent type:(NSString*)xType grade:(NSString*)xGrade{
    sqlite3_stmt *statement = nil;
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM questions WHERE type='%@' and grade='%@'",xType,xGrade];
    NSLog(@"sql:%@",sql);
    
    if (sqlite3_prepare_v2(questionsMng, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        
        while (sqlite3_step(statement) != SQLITE_DONE) {
            
            char *ycontent = (char*)sqlite3_column_text(statement, 1);
            char *yType = (char*)sqlite3_column_text(statement, 2);
            char *yGrade = (char*)sqlite3_column_text(statement, 3);
            
            NSString *rcontent = nil;
            bool resultG = [[NSString stringWithUTF8String:yGrade] isEqualToString:xGrade];
            bool resultT = [[NSString stringWithUTF8String:yType] isEqualToString:xType];
            
            if( resultT==YES && resultG == YES)
                rcontent = [NSString stringWithUTF8String:ycontent];
            [nContent addObject:rcontent];
        }
    }else{
        NSLog(@"Error: failed to prepare statement.");
    }
    
    sqlite3_finalize(statement);
    
}

- (BOOL) sqlExecute: (NSString *)sql {
    int ret;
    char * error;
    ret = sqlite3_exec(questionsMng, [sql UTF8String], NULL, NULL, & error);
    if( ret != SQLITE_OK )
    {
        if (error){
            NSAssert1(0, @"SQLite Sql Execute Error:%s.", error);
            sqlite3_free(error);
        }
        return NO;
    }
    
    return YES;
}

//insert one question to table
- (BOOL)insertQuestion:(NSString *)qid content:(NSString *)content type:(NSString*)type grade:(NSString*)grade
{
    sqlite3_stmt *statement;
    int result = sqlite3_prepare_v2(questionsMng, [@"insert into questions (content,type,grade) values(?,?,?);" UTF8String], -1, &statement, NULL);
//    NSLog(@"result--%d",result);
    if (result != SQLITE_OK) {
        return NO;
    }
    
    sqlite3_bind_text(statement, 1, [content UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 2, [type UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 3, [grade UTF8String], -1, SQLITE_TRANSIENT);
   
    if (sqlite3_step(statement)!=SQLITE_DONE) {
        sqlite3_finalize(statement);
        return YES;
    }
    
    sqlite3_finalize(statement);
    return YES;
}


//clear table question
- (BOOL)clearQuestions{
    NSString *path = [self dataFilePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL bExist = [fileManager fileExistsAtPath:path];
    
    //找到数据库文件
    if (bExist) {
        NSLog(@"Database file have already existed.");
        if(sqlite3_open([path UTF8String], &questionsMng) != SQLITE_OK) {
            sqlite3_close(questionsMng);
            NSLog(@"Error: open database file.");
            return NO;
        }
        
        char *sql = "DELETE FROM questions";
        sqlite3_stmt *statement;
        
        if(sqlite3_prepare_v2(questionsMng, sql, -1, &statement, nil) != SQLITE_OK) {
            NSLog(@"Error: failed to prepare statement:create questions table");
            return NO;
        }
        
        int success = sqlite3_step(statement);
        sqlite3_finalize(statement);
        
        if ( success != SQLITE_DONE) {
            NSLog(@"Error: failed to:delete TABLE questions");
            return NO;  
        }  
        
        sqlite3_close(questionsMng);
    }
    return YES;
    
}

//check if table (tableName) exists.
- (BOOL) isTableExisted:(NSString *)tableName database:(sqlite3*)sqlitedb{
    sqlite3_stmt *statement = nil;
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) FROM sqlite_master WHERE type='table' and name='%@'",tableName];

    if (sqlite3_prepare_v2(sqlitedb, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        NSLog(@"Error: failed to prepare statement with message:checkTable.");
        return YES;
    }
    
    int iNumber = 0;
    while (sqlite3_step(statement) == SQLITE_ROW) {
        iNumber = (int)sqlite3_column_int(statement, 0);
    }
    sqlite3_finalize(statement);
    
    if(iNumber == 0){
        return YES;
    }
    return NO;
}

//get table row count
- (int)getTableQuestionCount{
    
    int rc, iCount;
    sqlite3_stmt *statement = nil;
    NSString *sql = @"SELECT count(*) from questions";
    
    rc = sqlite3_prepare_v2(questionsMng, [sql UTF8String], -1, &statement, NULL);
    if (rc !=SQLITE_OK)
    {
        NSLog(@"Error: failed to prepare statement!");
        return 0;
    }
    rc = sqlite3_step(statement);
    iCount = sqlite3_column_int(statement, 0);
    sqlite3_finalize(statement);
    return iCount;
}


#pragma mark - testing code....
-(void)testDB{
    NSLog(@"testing DB");
    NSString *sql_select = @"SELECT * FROM questions";
    sqlite3_stmt *statement = nil;
    
    sqlite3_prepare_v2(questionsMng, [sql_select UTF8String], -1, &statement, NULL);
    
    int nResult = sqlite3_step(statement);
//    NSLog(@"nResult %d",nResult);
    
    NSLog(@"%d",[self getTableQuestionCount]);
    for (int fld = 0; fld < sqlite3_column_count(statement); fld++) {
//        NSLog(@"%s", sqlite3_column_name(statement, fld));
        
        while (nResult != SQLITE_DONE) {
            NSLog(@"%s|%s|%s|%s",
                                                       sqlite3_column_text(statement, 0),
                                                       sqlite3_column_text(statement, 1),
                                                       sqlite3_column_text(statement, 2),
                                                       sqlite3_column_text(statement, 3));
            nResult = sqlite3_step(statement);
        }
    }
    
}

@end
