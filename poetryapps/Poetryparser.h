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
-(NSMutableString*)isOpenFileSuccessful:(NSString*)fileName;
-(NSString *)parsePoetryContentBySymbol:(NSString *)input;

@end
