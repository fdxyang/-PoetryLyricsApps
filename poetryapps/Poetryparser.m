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

-(NSString *)parsePoetryContentBySymbol:(NSString *)input
{
    NSString *fileContents;
    NSMutableString *poetryParserContent = [[NSMutableString alloc]init];
    NSMutableString *templine = [[NSMutableString alloc]init];
    NSUInteger wordcount=0;
    NSUInteger index = 0,lineattrcount=0;
    fileContents = input;
    
    NSArray *lineArr = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    for (NSString *line in lineArr)
    {
        lineattrcount = lineattrcount+1;
        if(![line length])
        {
            [poetryParserContent appendString:@"\n"];
        }
        else
        {
            for(int i=0;i<[line length];i++)
            {
                //NSLog(@"%@",[line substringWithRange:NSMakeRange(i,1)]);
                
                if([[line substringWithRange:NSMakeRange(i,1)] isEqualToString:@"："] ||
                   [[line substringWithRange:NSMakeRange(i,1)] isEqualToString:@"。"] ||
                   [[line substringWithRange:NSMakeRange(i,1)] isEqualToString:@"；"] ||
                   [[line substringWithRange:NSMakeRange(i,1)] isEqualToString:@"，"] ||
                   [[line substringWithRange:NSMakeRange(i,1)] isEqualToString:@"！"] ||
                   [[line substringWithRange:NSMakeRange(i,1)] isEqualToString:@"、"])
                {
                    //NSLog(@"debug 1");
                    //NSLog(@"kk index = %ld,wordcount=%ld",index,wordcount);
                    
                    if(wordcount+1 < 10 && (index+wordcount+1) < 10)
                    {
                        [poetryParserContent appendString:templine];
                        [poetryParserContent appendString:[line substringWithRange:NSMakeRange(i,1)]];
                        
                        if(index+wordcount+1 < 10)
                        {
                            index = index+wordcount+1;
                        }
                        else
                        {
                            NSLog(@"debug 1 Error!!");
                        }
                    }
                    else // too long, must have another line
                    {
                        if(wordcount+1 > 10 && (index+wordcount+1) >= 10)
                        {
                            [poetryParserContent appendString:@"\n"];
                            [poetryParserContent appendString:templine];
                            [poetryParserContent appendString:[line substringWithRange:NSMakeRange(i,1)]];
                            [poetryParserContent appendString:@"\n"];
                            [templine setString:@""];
                            wordcount=0;
                            index=0;
                            continue;
                        }
                        else
                        {
                            index = wordcount+1;
                        }
                        
                        [poetryParserContent appendString:@"\n"];
                        [poetryParserContent appendString:templine];
                        [poetryParserContent appendString:[line substringWithRange:NSMakeRange(i,1)]];
                    }
                    
                    [templine setString:@""];
                    wordcount = 0;
                }
                else if([[line substringWithRange:NSMakeRange(i,1)] isEqualToString:@"."])
                {
                    [poetryParserContent appendString:templine];
                    [poetryParserContent appendString:[line substringWithRange:NSMakeRange(i,1)]];
                    [poetryParserContent appendString:@"\n"];
                    [templine setString:@""];
                    wordcount = 0;
                    index=0;
                }
                else if([[line substringWithRange:NSMakeRange(i,1)] isEqualToString:@"	"])
                {
                    wordcount = 0;
                    index=0;
                    continue;
                }
                else
                {
                    if([[line substringWithRange:NSMakeRange(i,1)] isEqualToString:@"1"]||
                       [[line substringWithRange:NSMakeRange(i,1)] isEqualToString:@"2"]||
                       [[line substringWithRange:NSMakeRange(i,1)] isEqualToString:@"3"]||
                       [[line substringWithRange:NSMakeRange(i,1)] isEqualToString:@"4"]||
                       [[line substringWithRange:NSMakeRange(i,1)] isEqualToString:@"5"]||
                       [[line substringWithRange:NSMakeRange(i,1)] isEqualToString:@"6"]||
                       [[line substringWithRange:NSMakeRange(i,1)] isEqualToString:@"7"]||
                       [[line substringWithRange:NSMakeRange(i,1)] isEqualToString:@"8"]||
                       [[line substringWithRange:NSMakeRange(i,1)] isEqualToString:@"9"])
                    {
                        if(lineattrcount != [lineArr count])
                            [poetryParserContent appendString:@"\n"];
                    }
                    
                    [templine appendString:[line substringWithRange:NSMakeRange(i,1)]];
                    
                    wordcount = wordcount+1;
                    
                    if(wordcount >= 9)
                    {
                        if(index+wordcount >= 9)
                        {
                            [poetryParserContent appendString:@"\n"];
                        }

                        [poetryParserContent appendString:templine];
                        [poetryParserContent appendString:@"\n"];
                        [templine setString:@""];
                        wordcount=0;
                        index=0;
                    }
                    else if(lineattrcount == [lineArr count] && i == ([line length]-1))
                    {
                        [poetryParserContent appendString:@"\n\n"];
                        [poetryParserContent appendString:templine];
                    }
                }
                
                //NSLog(@"index = %ld,wordcount=%ld,lineattr = %ld,lineattrcount=%ld",index,wordcount,[lineArr count],lineattrcount);
                //NSLog(@"poetryParserContent = %@",poetryParserContent);
            }
        }
    }
    
    return poetryParserContent;
    
}

-(NSString *)parsePoetryContentBySymbolAndAdjustFontSize:(NSString *)input Fontsize:(NSUInteger)size
{
    NSString *fileContents;
    NSMutableString *poetryParserContent = [[NSMutableString alloc]init];
    NSMutableString *templine = [[NSMutableString alloc]init];
    NSUInteger wordcount=0;
    NSUInteger index = 0,lineattrcount=0;
    NSUInteger lineNum = 0;
    fileContents = input;
    
    //NSLog(@"kk input = %@",input);
    
    switch (size) {
        case POETRY_SETIING_FONT_SIZE_DEFAULT:
            lineNum = 12;
            break;
            
        case POETRY_SETIING_FONT_SIZE_SMALL:
            lineNum = 14;
            break;
            
        case POETRY_SETIING_FONT_SIZE_LARGE:
            lineNum = 9;
            break;
            
        default:
            break;
    };
    
    NSArray *lineArr = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    for (NSString *line in lineArr)
    {
        lineattrcount = lineattrcount+1;
        if(![line length])
        {
            [poetryParserContent appendString:@"\n"];
        }
        else
        {
            for(int i=0;i<[line length];i++)
            {
                //NSLog(@"%@",[line substringWithRange:NSMakeRange(i,1)]);
                
                if([[line substringWithRange:NSMakeRange(i,1)] isEqualToString:@"："] ||
                   [[line substringWithRange:NSMakeRange(i,1)] isEqualToString:@"。"] ||
                   [[line substringWithRange:NSMakeRange(i,1)] isEqualToString:@"；"] ||
                   [[line substringWithRange:NSMakeRange(i,1)] isEqualToString:@"，"] ||
                   [[line substringWithRange:NSMakeRange(i,1)] isEqualToString:@"！"] ||
                   [[line substringWithRange:NSMakeRange(i,1)] isEqualToString:@"、"])
                {
                    //NSLog(@"debug 1");
                    //NSLog(@"kk index = %ld,wordcount=%ld",index,wordcount);
                    
                    if(wordcount+1 < lineNum+1 && (index+wordcount+1) < lineNum+1)
                    {
                        [poetryParserContent appendString:templine];
                        [poetryParserContent appendString:[line substringWithRange:NSMakeRange(i,1)]];
                        
                        if(index+wordcount+1 < lineNum+1)
                        {
                            index = index+wordcount+1;
                        }
                        else
                        {
                            NSLog(@"debug 1 Error!!");
                        }
                    }
                    else // too long, must have another line
                    {
                        if(wordcount+1 > lineNum+1 && (index+wordcount+1) >= lineNum+1)
                        {
                            [poetryParserContent appendString:@"\n"];
                            [poetryParserContent appendString:templine];
                            [poetryParserContent appendString:[line substringWithRange:NSMakeRange(i,1)]];
                            [poetryParserContent appendString:@"\n"];
                            [templine setString:@""];
                            wordcount=0;
                            index=0;
                            continue;
                        }
                        else
                        {
                            index = wordcount+1;
                        }
                        
                        [poetryParserContent appendString:@"\n"];
                        [poetryParserContent appendString:templine];
                        [poetryParserContent appendString:[line substringWithRange:NSMakeRange(i,1)]];
                    }
                    
                    [templine setString:@""];
                    wordcount = 0;
                }
                else if([[line substringWithRange:NSMakeRange(i,1)] isEqualToString:@"."])
                {
                    [poetryParserContent appendString:templine];
                    [poetryParserContent appendString:[line substringWithRange:NSMakeRange(i,1)]];
                    [poetryParserContent appendString:@"\n"];
                    [templine setString:@""];
                    wordcount = 0;
                    index=0;
                }
                else if([[line substringWithRange:NSMakeRange(i,1)] isEqualToString:@"	"])
                {
                    wordcount = 0;
                    index=0;
                    continue;
                }
                else
                {
                    if([[line substringWithRange:NSMakeRange(i,1)] isEqualToString:@"1"]||
                       [[line substringWithRange:NSMakeRange(i,1)] isEqualToString:@"2"]||
                       [[line substringWithRange:NSMakeRange(i,1)] isEqualToString:@"3"]||
                       [[line substringWithRange:NSMakeRange(i,1)] isEqualToString:@"4"]||
                       [[line substringWithRange:NSMakeRange(i,1)] isEqualToString:@"5"]||
                       [[line substringWithRange:NSMakeRange(i,1)] isEqualToString:@"6"]||
                       [[line substringWithRange:NSMakeRange(i,1)] isEqualToString:@"7"]||
                       [[line substringWithRange:NSMakeRange(i,1)] isEqualToString:@"8"]||
                       [[line substringWithRange:NSMakeRange(i,1)] isEqualToString:@"9"])
                    {
                        if(lineattrcount != [lineArr count])
                            [poetryParserContent appendString:@"\n"];
                    }
                    
                    [templine appendString:[line substringWithRange:NSMakeRange(i,1)]];
                    
                    wordcount = wordcount+1;
                    
                    if(wordcount >= lineNum)
                    {
                        if(index+wordcount >= lineNum)
                        {
                            [poetryParserContent appendString:@"\n"];
                        }
                        
                        [poetryParserContent appendString:templine];
                        [poetryParserContent appendString:@"\n"];
                        [templine setString:@""];
                        wordcount=0;
                        index=0;
                    }
                    else if(lineattrcount == [lineArr count] && i == ([line length]-1))
                    {
                        [poetryParserContent appendString:@"\n\n"];
                        [poetryParserContent appendString:templine];
                    }
                }
                
                //NSLog(@"index = %ld,wordcount=%ld,lineattr = %ld,lineattrcount=%ld",index,wordcount,[lineArr count],lineattrcount);
                //NSLog(@"poetryParserContent = %@",poetryParserContent);
            }
        }
    }
    
    return poetryParserContent;
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

/*
 Example:
 
 NSMutableString *poetryContent2 = [[NSMutableString alloc]init];
 
 Poetryparser *parser = [[Poetryparser alloc]init];
 poetryContent2 = [parser isOpenFileSuccessful:@"717.txt"];
 if(poetryContent2 != nil)
 {
    NSLog(@"kk test output = %@",poetryContent2);
    [parser parsePoetryContentBySymbol:poetryContent2];
 }
 else
    NSLog(@"kk ng");
 
*/

@end
