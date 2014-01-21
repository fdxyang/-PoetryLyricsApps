//
//  Poetryparser.h
//  poetryapps
//
//  Created by Goda on 2014/1/20.
//  Copyright (c) 2014年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Poetryparser : NSObject

-(Poetryparser *) init;
-(NSString *)parsePoetryContent:(NSString *)input;
-(NSMutableString*)isOpenFileSuccessful:(NSString*)fileName;
-(NSMutableString*)parseLineContent:(NSMutableString*)input;

@end
