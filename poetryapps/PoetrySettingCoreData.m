//
//  PoetrySettingCoreData.m
//  poetryapps
//
//  Created by GIGIGUN on 2013/11/30.
//  Copyright (c) 2013年 cc. All rights reserved.
//

#import "PoetrySettingCoreData.h"

@implementation PoetrySettingCoreData

-(PoetrySettingCoreData*) init
{
    
    self = [super init];
    
    if ( self ) {
        
        PoetryAppDelegate *theAppDelegate = (PoetryAppDelegate*) [UIApplication sharedApplication].delegate;
        _context = [theAppDelegate managedObjectContext];
        
    }
    
    return self;

}



-(BOOL) PoetrySetting_SetDefault
{
    
    NSString *PoetryCoreDataEntityName = POETRY_CORE_DATA_SETTING_ENTITY;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:PoetryCoreDataEntityName inManagedObjectContext:_context]];
    
    NSError *err;
    NSArray *FetchResult = [_context executeFetchRequest:request error:&err];
    NSUInteger count = [FetchResult count];
    
    if (count == 1) {
        
        // Setting is exist, update to default value
        NSLog(@"In Poetry Setting : Set to default");

        NSManagedObject *Setting = [FetchResult objectAtIndex:0];
        
        // TODO: [CASPER] Add another Attr for Setting
        [Setting setValue: [NSNumber numberWithInt:POETRY_SETIING_DEFAULT_FONT_SIZE] forKey:POETRY_CORE_DATA_SETTING_FONT_SIZE];
        
        
        
    } else if (count == 0) {
        
        // Setting not exist, create one
        NSLog(@"First time in setting : Create Setting DB");
        
        // TODO: [CASPER] Add another Attr for Setting
        NSManagedObject *NewPoetry = [NSEntityDescription insertNewObjectForEntityForName:PoetryCoreDataEntityName inManagedObjectContext:_context];
        
        [NewPoetry setValue: [NSNumber numberWithInt:POETRY_SETIING_DEFAULT_FONT_SIZE] forKey:POETRY_CORE_DATA_SETTING_FONT_SIZE];
        
    } else {
        
        NSLog(@"ERROR!!! Multiple Setting");
    }
    
    
    NSError *error = nil;
    if (![_context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        
        return NO;
    }
    
    
    return YES;
}


-(NSDictionary*) PoetrySetting_ReadSetting
{
    NSMutableArray *Poetrys = [[NSMutableArray alloc] init];
    
    NSString *PoetryCoreDataEntityName = POETRY_CORE_DATA_SETTING_ENTITY;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:PoetryCoreDataEntityName];
    Poetrys = [[_context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    NSDictionary *ReturnDic = (NSDictionary*)[Poetrys objectAtIndex:0];
    
    return ReturnDic;
}

-(UInt16) PoetrySetting_GetFontSizeSetting
{
    NSDictionary *SettingDic = [self PoetrySetting_ReadSetting];
    
    NSNumber *FontSizeSetting = [SettingDic valueForKey:POETRY_CORE_DATA_SETTING_FONT_SIZE];
    
    return [FontSizeSetting unsignedIntegerValue];
}



@end
