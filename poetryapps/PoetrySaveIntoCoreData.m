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
        NSString *title,*titleB, *filePath2,*fileBPath,*contentB;
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
            titleB = [NSString stringWithFormat:@"/%dB.txt",count+1];
            fileBPath = [FilePath stringByAppendingString:titleB];
            
            if ([fileManager fileExistsAtPath:filePath2] == YES)
            {
                
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
            
            if([fileManager fileExistsAtPath:fileBPath] == YES)
            {
                contentB = [[NSString  alloc] initWithContentsOfFile:fileBPath encoding:NSUTF8StringEncoding error:nil];
                
                for (NSString *line in [contentB componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]])
                {
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
    else
    {
        //NSLog(@"check 2");
        if([self isCheckPlistFileExist])
        {
            //NSLog(@"check 3");
            if([self isUpdatePlistFile])
            {
                //NSLog(@"success!!");
                /*
                //check plist
                NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"addNewFileList" ofType:@"plist"];
                NSMutableDictionary *plistData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
                NSFileManager *fileManager = [NSFileManager defaultManager];
                
                //判斷plist檔案存在時才刪除
                if ([fileManager fileExistsAtPath: filePath]) {
                    [fileManager removeItemAtPath:filePath error:NULL];
                    
                    [textView setText:@"資料清除成功！"];
                }*/
            }
        }
    }
    return TRUE;
}

- (NSArray*) getPlistContent
{
    //NSLog(@"check9");
    NSMutableArray *plistFileList = [[NSMutableArray alloc]init];
    //NSLog(@"check91");
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"addNewFileList" ofType:@"plist"];
    //NSLog(@"check92");
    NSMutableDictionary *plistData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    //NSLog(@"check93");
    
    NSString *str;
    //NSLog(@"check94");
    for(int i = 0 ;i < 721 ; i++)
    {
        str = [NSString stringWithFormat:@"file_%d",i];
        //NSLog(@"%d",i);
        if([plistData objectForKey:str])
        {
            NSLog(@"kk plist file = %@",[plistData objectForKey:str]);
            //NSLog(@"check 4");
            [plistFileList addObject:[plistData objectForKey:str]];
            //NSLog(@"check 5");
            //NSLog(@"plistFileList = %@",plistFileList);
        }
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
    //NSLog(@"PLIST = %@",getPlist);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *FilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"poetryapps.app/"];
    NSInteger poetryIndex = 0,categoryIndex = 0;
    POETRY_CATEGORY category = GUARD_READING;
    NSString *file,*filename;
    PoetryCoreData *PoetryDataBase = [[PoetryCoreData alloc] init];
    BOOL isUpdate = TRUE;
    
    //NSLog(@"getlist count = %ld,getplist = %@",[getPlist count],[getPlist objectAtIndex:0]);
    for(int i=0;i<[getPlist count];i++)
    {
        poetryIndex = [[getPlist objectAtIndex:i] integerValue];
        
        if(poetryIndex <= 650 && poetryIndex >= 1)
        {
            category = POETRYS;
            categoryIndex = poetryIndex-1;
        }
        else if(poetryIndex >650 && poetryIndex <= 716)
        {
            category = RESPONSIVE_PRAYER;
            categoryIndex = poetryIndex - 651;
        }
        else if(poetryIndex > 716 && poetryIndex <= 721)
        {
            category = GUARD_READING;
            categoryIndex = poetryIndex - 717;
        }
        else
        {
            category = POETRYS;
        }
        
        //NSLog(@"index = %d,category = %d",categoryIndex,category);
        NSDictionary *originalPoetry = (NSDictionary*)[[PoetryDataBase Poetry_CoreDataFetchDataInCategory:category] objectAtIndex:categoryIndex];
        NSDictionary *NewPoetry = originalPoetry; //[Casper] add
        
        //NSLog(@"poetry content = %@",[originalPoetry valueForKey:POETRY_CORE_DATA_NAME_KEY]);
        filename = [NSString stringWithFormat:@"/%@.txt",[getPlist objectAtIndex:i]];
        file = [FilePath stringByAppendingString:filename];
        
        if ([fileManager fileExistsAtPath:file] == YES)
        {
            //NSDictionary *Dic;// = [poetryContent objectAtIndex:[[getPlist objectAtIndex:i] integerValue]];
            NSString *content = [[NSString  alloc] initWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
            //NSLog(@"content = %@",content);
            
            [NewPoetry setValue:content forKey:POETRY_CORE_DATA_CONTENT_KEY];
            [NewPoetry setValue:[originalPoetry valueForKey:POETRY_CORE_DATA_INDEX_KEY] forKey:POETRY_CORE_DATA_INDEX_KEY];
            [NewPoetry setValue:[originalPoetry valueForKey:POETRY_CORE_DATA_NAME_KEY] forKey:POETRY_CORE_DATA_NAME_KEY];
            [NewPoetry setValue:[originalPoetry valueForKey:POETRY_CORE_DATA_CATERORY_KEY] forKey:POETRY_CORE_DATA_INDEX_KEY];
            //NSLog(@"NewPoetry = %@", [NewPoetry valueForKey:POETRY_CORE_DATA_NAME_KEY]);
            
            isUpdate = [PoetryDataBase Poetry_CoreDataUpdatePoetryInCoreData:originalPoetry ByNewPoetry:NewPoetry];
            
            if (!isUpdate)
            {
                NSLog(@"UPDATE ERROR!!");
                return FALSE;
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
    
    return TRUE;
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
