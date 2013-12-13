//
//  PoetryViewController.m
//  poetryapps
//
//  Created by Goda on 2013/11/25.
//  Copyright (c) 2013年 cc. All rights reserved.
//

#import "PoetryViewController.h"
#import "PoetryCoreData.h"
#import "PoetrySettingCoreData.h"
@interface PoetryViewController ()

@end

@implementation PoetryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Kevin add timer for test
    NSTimeInterval time1 = [[NSDate date] timeIntervalSince1970];
    long int date1 = (long int)time1;
    //NSLog(@"date1\n%lu", date1);
    // Kevin add timer for test
    
    PoetrySettingCoreData *setting = [[PoetrySettingCoreData alloc] init];
    [setting PoetrySetting_Create];
    
    PoetryCoreData *PoetryDataBase = [[PoetryCoreData alloc] init];
    
    if(!setting.DataSaved)
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *FilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"poetryapps.app/"];
        NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:FilePath error:NULL];
        NSLog(@"file path = %@",FilePath);
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
            
            //NSLog(@"filePath2 = %@",filePath2);
            
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
                    NSLog(@"Core data is Error!!!!!!!!!");
                
                [poetryContent setString:@""];
                lineCount = 0;
            }
        }
        
        [setting PoetrySetting_SetDataSaved:YES];
    }
    
    // Kevin add timer for test
    NSTimeInterval time2 = [[NSDate date] timeIntervalSince1970];
    long int date2 = (long int)time2;
    //NSLog(@"date2\n%lu", date2);
    
    long int d3 = date2 - date1;
    NSLog(@"d3:%lu", d3);
    // Kevin add timer for test
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
