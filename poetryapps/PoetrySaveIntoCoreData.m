//
//  PoetrySaveIntoCoreData.m
//  poetryapps
//
//  Created by Goda on 2013/12/19.
//  Copyright (c) 2013年 cc. All rights reserved.
//

#import "PoetrySaveIntoCoreData.h"

@implementation PoetrySaveIntoCoreData

-(PoetrySaveIntoCoreData*) init
{
    self = [super init];
    
    if ( self )
    {
        
    }
    
    return self;
}
    
- (BOOL)isCoreDataSave
{
    PoetrySettingCoreData *setting = [[PoetrySettingCoreData alloc] init];
    [setting PoetrySetting_Create];
    
    PoetryCoreData *PoetryDataBase = [[PoetryCoreData alloc] init];
    
    //NSFileManager *fileManager2 = [NSFileManager defaultManager];
    //NSString *FilePath2 = [NSHomeDirectory() stringByAppendingPathComponent:@"poetryapps.app/"];
    
    //NSArray *directoryContent2 = NSSearchPathForDirectoriesInDomains (NSLibraryDirectory, NSUserDomainMask, YES);
    //NSString *path = [[directoryContent2 objectAtIndex:0] stringByAppendingString:@"/Preferences/"];
    
    //NSLog(@"file manager = %@, filepath = %@,dic = %@,path = %@",fileManager2,FilePath2,[directoryContent2 objectAtIndex:0],path);
    
    if(!setting.DataSaved)
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *FilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"poetryapps.app/"];
        NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:FilePath error:NULL];
        NSString *title, *filePath2,*content;
        NSString *fileContents;
        NSMutableString *poetryContent = [[NSMutableString alloc]init];
        int lineCount = 0;
        int index = 0;
        
        BOOL isSave = FALSE;
        for (int count = 0; count < (int)[directoryContent count]; count++)
        {
            //NSLog(@"File %d: %@", (count + 1), [directoryContent objectAtIndex:count]);
            title = [NSString stringWithFormat:@"/%d.txt",count+1];
            filePath2 = [FilePath stringByAppendingString:title];
            
            if ([fileManager fileExistsAtPath:filePath2] == YES)
            {
                // save core data
                //NSLog(@"file exists - %@",filePath2);
                
                
                content = [[NSString  alloc] initWithContentsOfFile:filePath2 encoding:NSUTF8StringEncoding error:nil];
                
                fileContents = [NSString stringWithContentsOfFile:filePath2 encoding:NSUTF8StringEncoding error:NULL];
                for (NSString *line in [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]]) {
                    // Do something
                    //NSLog(@"line = %@",line);
                    if (lineCount == 0)
                    {
                        title = line;
                    }
                    else
                    {
                        [poetryContent appendString:@"\n"];
                        [poetryContent appendString:line];
                    }
                    lineCount++;
                }
                
                //NSLog(@"poetry content = %@",poetryContent);
                
                
                
                NSDictionary *PoetryDic;
                
                if(count < 650)// 0-649
                {
                    PoetryDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 title, POETRY_CORE_DATA_NAME_KEY,
                                 poetryContent, POETRY_CORE_DATA_CONTENT_KEY,
                                 [NSNumber numberWithInt:count+1],POETRY_CORE_DATA_INDEX_KEY,
                                 nil];
                    isSave = [PoetryDataBase PoetryCoreDataSave:PoetryDic inCategory:POETRYS];
                }
                else if(count >= 650 && count < 716) // 650-716
                {
                    index = index+1;
                    PoetryDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 title, POETRY_CORE_DATA_NAME_KEY,
                                 poetryContent, POETRY_CORE_DATA_CONTENT_KEY,
                                 [NSNumber numberWithInt:index],POETRY_CORE_DATA_INDEX_KEY,
                                 nil];
                    isSave = [PoetryDataBase PoetryCoreDataSave:PoetryDic inCategory:RESPONSIVE_PRAYER];
                    if(index == 66)
                    index = 0;
                }
                else //717-721
                {
                    index = index+1;
                    PoetryDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 title, POETRY_CORE_DATA_NAME_KEY,
                                 poetryContent, POETRY_CORE_DATA_CONTENT_KEY,
                                 [NSNumber numberWithInt:index],POETRY_CORE_DATA_INDEX_KEY,
                                 nil];
                    isSave = [PoetryDataBase PoetryCoreDataSave:PoetryDic inCategory:GUARD_READING];
                    if(index == 5)
                    index = 0;
                }
                
                if(!isSave)
                {
                    NSLog(@"Core data is Error!!!!!!!!!");
                    return FALSE;
                }
                
                [poetryContent setString:@""];
                lineCount = 0;
            }
        }
        
        [setting PoetrySetting_SetDataSaved:YES];
    }
    return TRUE;
}

- (NSArray*) getPlistContent
{
    NSMutableArray *plistFileList = [[NSMutableArray alloc]init];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"addNewFileList" ofType:@"plist"];
    NSMutableDictionary *plistData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSString *str;
    for(int i = 0 ;i < 1000 ; i++)
    {
        str = [NSString stringWithFormat:@"file_%d",i];
        
        if([plistData objectForKey:str])
        {
            NSLog(@"kk plist file = %@",[plistData objectForKey:str]);
            [plistFileList addObject:[plistData objectForKey:str]];
        }
        else
            break;
    }
    
    return plistFileList;
}

- (BOOL)isCheckPlistFileExist
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"addNewFileList" ofType:@"plist"];
    NSMutableDictionary *plistData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    
    NSString *str;
    for(int i = 0 ;i < 721 ; i++)
    {
        str = [NSString stringWithFormat:@"file_%d",i+1];
        
        if([plistData objectForKey:str])
        {
            NSLog(@"kk plist file = %@",[plistData objectForKey:str]);
            return TRUE;
        }
        else
            break;
    }
    
    return FALSE;
}

- (BOOL)isUpdatePlistFile
{
    NSArray *getPlist = [[NSArray alloc] initWithArray:[self getPlistContent]];
    NSLog(@"PLIST = %@",getPlist);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *FilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"poetryapps.app/"];
    //NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:FilePath error:NULL];
    NSUInteger poetryIndex = 0;
    POETRY_CATEGORY category = GUARD_READING;
    
    //NSLog(@"directoryContent = %@",directoryContent);
    NSString *file,*filename;
    
    PoetryCoreData *PoetryDataBase = [[PoetryCoreData alloc] init];
    NSMutableArray *poetryContent;
    
    // Point to Library directory
    //NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Library"];
    //NSLog(@"documentsDirectory = %@",documentsDirectory);
    
    BOOL isUpdate = TRUE;
    
    for(int i=0;i<[getPlist count];i++)
    {
        poetryIndex = [[getPlist objectAtIndex:i] integerValue];
        
        if(poetryIndex <= 650 && poetryIndex >= 1)
        {
            category = GUARD_READING;
        }
        else if(poetryIndex >650 && poetryIndex <= 716)
        {
            category = POETRYS;
        }
        else if(poetryIndex > 716 && poetryIndex <= 721)
        {
            category = RESPONSIVE_PRAYER;
        }
        else
        {
            category = GUARD_READING;
        }
        
        poetryContent = [PoetryDataBase Poetry_CoreDataFetchDataInCategory:category];
        
        filename = [NSString stringWithFormat:@"/%@.txt",[getPlist objectAtIndex:i]];
        file = [FilePath stringByAppendingString:filename];
        
        if ([fileManager fileExistsAtPath:file] == YES)
        {
            NSDictionary *Dic;
            NSString *content = [[NSString  alloc] initWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
            NSLog(@"content = %@",content);
            [Dic setValue:content forKey:POETRY_CORE_DATA_CONTENT_KEY];
            
            isUpdate = [PoetryDataBase Poetry_CoreDataUpdatePoetryInCoreData:nil ByNewPoetry:Dic];
            
            if (!isUpdate)
            {
                NSLog(@"UPDATE ERROR!!");
            }
            else
            {
                NSLog(@"update ok");
            }
        }
        else //not exist file
        {
            NSLog(@"not exist file!! error!!!");
        }
    }
    
    return FALSE;
}

/*
 Core data update poetry API
 Input :
 (NSDictionary *) OldPoetry, (NSDictionary *) NewPoetry
 
 Output :
 Success or not
 
 Use case :
 1. Get the poetry dictionary by the usual way.
 2. Package the new poetry
 3. Put the new poetry dictionary in "NewPoetry" argument
 
 Following is the example FYR :
 
 NSLog(@"CASPER TEST !!!");
 NSDictionary *Dic = _PoetryNowReading;
 [Dic setValue:@"CASPER TEST" forKey:POETRY_CORE_DATA_CONTENT_KEY];
 NSLog(@"Return = %d", [_PoetryDatabase Poetry_CoreDataUpdatePoetryInCoreData:_PoetryNowReading ByNewPoetry:Dic]);
 */
@end
