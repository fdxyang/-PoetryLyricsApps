//
//  PoetryCoreData.h
//  poetryapps
//
//  Created by GIGIGUN on 2013/11/26.
//  Copyright (c) 2013年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PoetryAppDelegate.h"

#define POETRY_GUARD_CORE_DATA_ENTITY           @"GuardReading"
#define POETRY_CORE_DATA_ENTITY                 @"Poetrys"
#define POETRY_RES_CORE_DATA_ENTITY             @"ResponsivePrayer"
#define POETRY_HISTORY_CORE_DATA_ENTITY         @"PoetrysHistory"
#define POETRY_NOW_READING_CORE_DATA_ENTITY     @"NowReading" //[CASPER] Add for reading view

#define POETRY_CORE_DATA_NAME_KEY               @"name"
#define POETRY_CORE_DATA_CONTENT_KEY            @"content"
#define POETRY_CORE_DATA_CREATION_TIME_KEY      @"creationDate"
#define POETRY_CORE_DATA_INDEX_KEY              @"index"        // [CASPER] Add index
#define POETRY_CORE_DATA_CATERORY_KEY           @"category"     // [CASPER] Add category


//#define DEBUG_COREDATA
#ifdef DEBUG_COREDATA
#   define CORE_DATA_LOG(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define CORE_DATA_LOG(...)
#endif

#define CORE_DATA_ERROR_LOG(fmt, ...) NSLog((@"ERROR !! %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

@interface PoetryCoreData : NSObject

typedef enum {
    GUARD_READING = 0x00,
    POETRYS,
    RESPONSIVE_PRAYER,
} POETRY_CATEGORY;

@property (nonatomic, strong)   NSManagedObjectContext  *context;

-(PoetryCoreData*) init;

// Poetry list Methods
-(BOOL) PoetryCoreDataSave : (NSDictionary *) PoetryDic inCategory : (POETRY_CATEGORY) Category;
-(NSMutableArray*) Poetry_CoreDataFetchDataInCategory : (POETRY_CATEGORY) Category;
-(NSArray*) Poetry_CoreDataSearchWithPoetryName : (NSString *) SearchName InCategory : (POETRY_CATEGORY) Category;
-(NSArray*) Poetry_CoreDataSearchWithPoetryContent : (NSString *) SearchString InCategory : (POETRY_CATEGORY) Category;
-(NSDictionary *) Poetry_GetPreviousWithCurrentData : (NSDictionary *) NowReading;
-(NSDictionary *) Poetry_GetNextWithCurrentData : (NSDictionary *) NowReading;


// Poetry history Methods
-(BOOL) PoetryCoreDataSaveIntoHistory : (NSDictionary *) PoetryDic;
-(NSMutableArray*) Poetry_CoreDataFetchDataInHistory;
-(NSUInteger) Poetry_CoreDataGetNumberInHistory;
-(BOOL) Poetry_CoreDataDeleteOldestInHistory;
-(NSArray*) Poetry_CoreDataSearchWithPoetryContentInHistory : (NSString *) SearchString;
-(NSArray*) Poetry_CoreDataSearchWithPoetryNameInHistory : (NSString *) SearcgName;

// Now reading methods

@property (nonatomic, getter = Poetry_CoreDataReadingExist) BOOL isReadingExist;
-(BOOL) Poetry_CoreDataReadingExist;
-(BOOL) PoetryCoreDataSaveIntoNowReading : (NSDictionary *) PoetryDic;
-(NSDictionary*) Poetry_CoreDataFetchDataInReading;


@end
