//
//  Poetryparser.m
//  poetryapps
//
//  Created by Goda on 2014/1/20.
//  Copyright (c) 2014年 cc. All rights reserved.
//

#import "Poetryparser.h"

@implementation Poetryparser

-(Poetryparser *) init
{
    self = [super init];
    if(self)
    {
        
    }
    
    return self;
    
}

-(NSString *)parsePoetryContent:(NSString *)input
{
    
    NSString *fileContents;
    NSMutableString *poetryParserContent = [[NSMutableString alloc]init];
    int lineCount = 0;
    NSUInteger tmpcount2=0,arrCount=0;
    NSUInteger index = 0;
    fileContents = input;
    
    for (NSString *line in [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]])
    {
        // Do something
        //NSLog(@"line = %@",line);
        //NSLog(@"%d:%@,line length = %ld",lineCount,line,[line length]);
        
        // separate "，" because "，" is so many
        NSArray *strArray = [line componentsSeparatedByString:@"，"];
        //NSLog(@"array = %@,length = %ld",strArray,[strArray count]);
        arrCount = [strArray count];
        
        for(int i=0;i<arrCount;i++)
        {
            tmpcount2 = [[strArray objectAtIndex:i] length];
            
            //NSLog(@"index = %ld,tmpcount2=%ld,i=%d,arrCount = %ld",index,tmpcount2,i,arrCount);
            
            if(tmpcount2 == 0)
            {
                index=0;
                [poetryParserContent appendString:@"\n"];
                continue;
            }
            
            // start + string length + "，"
            index = index+tmpcount2+1;
            //NSLog(@"index = %ld",index);
            if(index < 10)
            {
                if([[strArray objectAtIndex:i] hasPrefix:@"1."] |
                   [[strArray objectAtIndex:i] hasPrefix:@"2."] |
                   [[strArray objectAtIndex:i] hasPrefix:@"3."] |
                   [[strArray objectAtIndex:i] hasPrefix:@"4."] |
                   [[strArray objectAtIndex:i] hasPrefix:@"5."] |
                   [[strArray objectAtIndex:i] hasPrefix:@"6."] |
                   [[strArray objectAtIndex:i] hasPrefix:@"7."] |
                   [[strArray objectAtIndex:i] hasPrefix:@"8."] |
                   [[strArray objectAtIndex:i] hasPrefix:@"9."] |
                   [[strArray objectAtIndex:i] hasPrefix:@"【"] )
                {
                    [poetryParserContent appendString:@"\n"];
                    [poetryParserContent appendString:[strArray objectAtIndex:i]];
                    [poetryParserContent appendString:@"\n"];
                    index=0;
                }
                else if([[strArray objectAtIndex:i] hasSuffix:@"。" ]|
                        [[strArray objectAtIndex:i] hasSuffix:@"！" ]|
                        [[strArray objectAtIndex:i] hasSuffix:@"、" ]|
                        [[strArray objectAtIndex:i] hasSuffix:@"；" ]|
                        [[strArray objectAtIndex:i] hasSuffix:@"「" ]|
                        [[strArray objectAtIndex:i] hasSuffix:@"」"] |
                        [[strArray objectAtIndex:i] hasSuffix:@"】"] |
                        [[strArray objectAtIndex:i] hasSuffix:@"）"] |
                        [[strArray objectAtIndex:i] hasSuffix:@"："] )
                {
                    [poetryParserContent appendString:@"\n"];
                    [poetryParserContent appendString:[strArray objectAtIndex:i]];
                }
                else
                {
                    [poetryParserContent appendString:[strArray objectAtIndex:i]];
                    [poetryParserContent appendString:@"，"];
                    //NSLog(@"kk content test1 = %@",poetryParserContent);
                }
            }
            else
            {
                index = [[strArray objectAtIndex:i] length]+1;
                if([[strArray objectAtIndex:i] hasSuffix:@"。" ]|
                   [[strArray objectAtIndex:i] hasSuffix:@"！" ]|
                   [[strArray objectAtIndex:i] hasSuffix:@"、" ]|
                   [[strArray objectAtIndex:i] hasSuffix:@"；" ]|
                   [[strArray objectAtIndex:i] hasSuffix:@"「" ]|
                   [[strArray objectAtIndex:i] hasSuffix:@"」"] |
                   [[strArray objectAtIndex:i] hasSuffix:@"】"] |
                   [[strArray objectAtIndex:i] hasSuffix:@"）"] |
                   [[strArray objectAtIndex:i] hasSuffix:@"："] )
                {
                    //[poetryParserContent appendString:@"\n"];
                    //poetryParserContent = [self parseLineContent:[strArray objectAtIndex:i] Result:poetryParserContent];
                    //[poetryParserContent appendString:@"\n"];
                    if([[strArray objectAtIndex:i] length] < 10)
                        [poetryParserContent appendString:@"\n"];
                    
                    [poetryParserContent appendString:[strArray objectAtIndex:i]];
                }
                else if([[strArray objectAtIndex:i] hasPrefix:@"1."] |
                        [[strArray objectAtIndex:i] hasPrefix:@"2."] |
                        [[strArray objectAtIndex:i] hasPrefix:@"3."] |
                        [[strArray objectAtIndex:i] hasPrefix:@"4."] |
                        [[strArray objectAtIndex:i] hasPrefix:@"5."] |
                        [[strArray objectAtIndex:i] hasPrefix:@"6."] |
                        [[strArray objectAtIndex:i] hasPrefix:@"7."] |
                        [[strArray objectAtIndex:i] hasPrefix:@"8."] |
                        [[strArray objectAtIndex:i] hasPrefix:@"9."] |
                        [[strArray objectAtIndex:i] hasPrefix:@"【"] )
                {
                    //[poetryParserContent appendString:@"\n"];
                    [poetryParserContent appendString:[strArray objectAtIndex:i]];
                    [poetryParserContent appendString:@"\n"];
                }
                else
                {
                    if([[strArray objectAtIndex:i] length] < 10)
                        [poetryParserContent appendString:@"\n"];
                    [poetryParserContent appendString:[strArray objectAtIndex:i]];
                    [poetryParserContent appendString:@"，"];
                }
                
                //NSLog(@"kk content test2 = %@",poetryParserContent);
            }
            //NSLog(@"i = %d,tempcount2 = %ld",i,tmpcount2);
        }
        NSLog(@"kk content test = %@",poetryParserContent);
        lineCount++;
    }
    NSLog(@"content = %@",fileContents);
    
    return poetryParserContent;
}

-(NSMutableString*)parseLineContent:(NSString*)input Result:(NSMutableString*)output
{
    NSArray *symbolatr = [[NSArray alloc]initWithObjects:@"！",@"。",@"、",@"；", nil];
    NSMutableDictionary *symbolcount = [[NSMutableDictionary alloc]init];
    NSUInteger target=0,targetIndex=0;
    
    NSString *str;
    for(int i=0; i<[symbolatr count];i++)
    {
        NSArray *strArray = [input componentsSeparatedByString:[symbolatr objectAtIndex:i]];
        str = [NSString stringWithFormat:@"%d",i];
        [symbolcount setObject:[[NSNumber alloc] initWithInt:(int)[strArray count]] forKey:str];
        NSLog(@" kk number = %@",[symbolcount objectForKey:str]);

        if([strArray count] > target)
        {
            target = [strArray count];
            targetIndex = i;
        }
    }
    
    // no symbol can separate
    if([[symbolcount objectForKey:@"0"] isEqual: @"1"] &&
       [[symbolcount objectForKey:@"1"] isEqual: @"1"] &&
       [[symbolcount objectForKey:@"2"] isEqual: @"1"] &&
       [[symbolcount objectForKey:@"3"] isEqual: @"1"] )
    {
        [output appendString:input];
    }
    else
    {
        NSArray *strResultArray = [input componentsSeparatedByString:[symbolatr objectAtIndex:targetIndex]];
        NSUInteger index = 0;
        
        for(int i=0;i<[strResultArray count];i++)
        {
            index = index+[[strResultArray objectAtIndex:i] length]+1;
            
            if([[strResultArray objectAtIndex:i] length] == 0)
                continue;
            
            if(index < 10)
            {
                [output appendString:[strResultArray objectAtIndex:i]];
                [output appendString:[symbolatr objectAtIndex:targetIndex]];
            }
            else
            {
                [output appendString:[strResultArray objectAtIndex:i]];
                [output appendString:[symbolatr objectAtIndex:targetIndex]];
                [output appendString:@"\n"];
            }
        }
    }
    
    return output;
}

-(NSMutableString*)isOpenFileSuccessful:(NSString*)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *FilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"poetryapps.app/"];
    NSString *filePath,*tempstring;
    NSUInteger lineCount = 0;
    NSMutableString *content = [[NSMutableString alloc]init];
    
    
    filePath = [NSString stringWithFormat:@"%@/%@",FilePath,fileName];
    
    NSLog(@"filename = %@, file path = %@",fileName,filePath);
    
    if ([fileManager fileExistsAtPath:filePath] == YES)
    {
        tempstring = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
        //NSLog(@"tempstring = %@",tempstring);
        
        for (NSString *line in [tempstring componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]]) {
            // Do something
            //NSLog(@"line = %@",line);
            
            if (lineCount == 0)
            {
                
            }
            else
            {
                [content appendString:@"\n"];
                [content appendString:line];
            }
            lineCount++;
        }
        
        //NSLog(@"output = %@",content);
    }
    else
        return nil;
    
    return content;
}

@end
