//
//  PoetryCoreData.h
//  poetryapps
//
//  Created by GIGIGUN on 2013/11/26.
//  Copyright (c) 2013年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PoetryAppDelegate.h"

#define POETRY_CORE_DATA_ENTITY                 @"Poetrys"
#define POETRY_HISTORY_CORE_DATA_ENTITY         @"PoetrysHistory"

#define POETRY_CORE_DATA_NAME_KEY               @"name"
#define POETRY_CORE_DATA_CONTENT_KEY            @"content"
#define POETRY_CORE_DATA_CREATION_TIME_KEY      @"creationDate"

@interface PoetryCoreData : NSObject

@property (nonatomic, strong)   NSManagedObjectContext  *context;

-(PoetryCoreData*) init;

// Poetry list Methods
-(BOOL) PoetryCoreDataSave : (NSDictionary *) PoetryDic;
-(NSMutableArray*) Poetry_CoreDataFetchData;
-(NSArray*) Poetry_CoreDataSearchWithPoetryName : (NSString *) SearcgName;
-(NSArray*) Poetry_CoreDataSearchWithPoetryContent : (NSString *) SearchString;

// Poetry history Methods
-(BOOL) PoetryCoreDataSaveIntoHistory : (NSDictionary *) PoetryDic;
-(NSMutableArray*) Poetry_CoreDataFetchDataInHistory;
-(NSUInteger) Poetry_CoreDataGetNumberInHistory;
-(BOOL) Poetry_CoreDataDeleteOldestInHistory;


@end
