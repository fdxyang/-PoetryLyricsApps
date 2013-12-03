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


-(BOOL) PoetrySetting_Create
{
    NSString *PoetryCoreDataEntityName = POETRY_CORE_DATA_SETTING_ENTITY;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:PoetryCoreDataEntityName inManagedObjectContext:_context]];
    
    NSError *err;
    NSArray *FetchResult = [_context executeFetchRequest:request error:&err];
    NSUInteger count = [FetchResult count];
    if (count == 0) {
        
        // Setting not exist, create one
        NSLog(@"First time in setting : Create Setting DB");
        
        // TODO: [CASPER] Add another Attr for Setting
        NSManagedObject *NewPoetry = [NSEntityDescription insertNewObjectForEntityForName:PoetryCoreDataEntityName inManagedObjectContext:_context];
        
        [NewPoetry setValue: [NSNumber numberWithInt:POETRY_SETIING_FONT_SIZE_DEFAULT] forKey:POETRY_CORE_DATA_SETTING_FONT_SIZE];
        [NewPoetry setValue: [NSNumber numberWithInt:POETRY_SETTING_THEME_DEFAULT] forKey:POETRY_CORE_DATA_SETTING_THEME];
        
        
    } else {
    
        NSLog(@"Setting Already exist");
        return NO;
    }
    
    
    NSError *error = nil;
    if (![_context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        
        return NO;
    }
    return YES;
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
        [Setting setValue: [NSNumber numberWithInt:POETRY_SETIING_FONT_SIZE_DEFAULT] forKey:POETRY_CORE_DATA_SETTING_FONT_SIZE];
        [Setting setValue:[NSNumber numberWithInt:POETRY_SETTING_THEME_DEFAULT] forKey:POETRY_CORE_DATA_SETTING_THEME];
        
        
    } else if (count == 0) {
        
        // Setting not exist, create one
        NSLog(@"First time in setting : Create Setting DB");
        
        // TODO: [CASPER] Add another Attr for Setting
        NSManagedObject *NewPoetry = [NSEntityDescription insertNewObjectForEntityForName:PoetryCoreDataEntityName inManagedObjectContext:_context];
        
        [NewPoetry setValue: [NSNumber numberWithInt:POETRY_SETIING_FONT_SIZE_DEFAULT] forKey:POETRY_CORE_DATA_SETTING_FONT_SIZE];
        [NewPoetry setValue: [NSNumber numberWithInt:POETRY_SETTING_THEME_DEFAULT] forKey:POETRY_CORE_DATA_SETTING_THEME];
    
        
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


#pragma mark - Font Size
-(FONT_SIZE_SETTING) PoetrySetting_GetFontSizeSetting
{
    NSDictionary *SettingDic = [self PoetrySetting_ReadSetting];
    
    NSNumber *FontSizeSetting = [SettingDic valueForKey:POETRY_CORE_DATA_SETTING_FONT_SIZE];
    
    
    switch ([FontSizeSetting intValue]) {
            
        case POETRY_SETIING_FONT_SIZE_SMALL:
            return FONT_SIZE_SMALL;
            break;
            
        case POETRY_SETIING_FONT_SIZE_MEDIUM:
            return FONT_SIZE_MEDIUM;
            break;
            
        case POETRY_SETIING_FONT_SIZE_LARGE:
            return FONT_SIZE_LARGE;
            break;
            
        default:
            break;
    }

    
    return FONT_SIZE_MEDIUM;
}


-(BOOL) PoetrySetting_SetFontSize : (FONT_SIZE_SETTING) FontSizeSetting
{
    
    UInt16 LocalFontSize;
    switch (FontSizeSetting) {
            
        case FONT_SIZE_SMALL:
            
            LocalFontSize = POETRY_SETIING_FONT_SIZE_SMALL;
            break;
            
        case FONT_SIZE_MEDIUM:
            LocalFontSize = POETRY_SETIING_FONT_SIZE_MEDIUM;
            break;
            
        case FONT_SIZE_LARGE:
            LocalFontSize = POETRY_SETIING_FONT_SIZE_LARGE;
            break;
            
        default:
            break;
    }
    
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
        [Setting setValue: [NSNumber numberWithInt:LocalFontSize] forKey:POETRY_CORE_DATA_SETTING_FONT_SIZE];
        
    } else if (count == 0) {
        
        // Setting not exist, create one
        NSLog(@"UPDATE- Normally it should not be here!!!");
        
        // TODO: [CASPER] Add another Attr for Setting
        NSManagedObject *NewPoetry = [NSEntityDescription insertNewObjectForEntityForName:PoetryCoreDataEntityName inManagedObjectContext:_context];
        
        [NewPoetry setValue: [NSNumber numberWithInt:LocalFontSize] forKey:POETRY_CORE_DATA_SETTING_FONT_SIZE];
        [NewPoetry setValue: [NSNumber numberWithInt:_SettingTheme] forKey:POETRY_CORE_DATA_SETTING_THEME];

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

#pragma mark - Theme
-(THEME_SETTING) PoetrySetting_GetThemeSetting
{
    NSDictionary *SettingDic = [self PoetrySetting_ReadSetting];
    
    NSNumber *ThemeSetting = [SettingDic valueForKey:POETRY_CORE_DATA_SETTING_THEME];
    
    return (THEME_SETTING)[ThemeSetting unsignedIntegerValue];
}


-(BOOL) PoetrySetting_SetTheme : (THEME_SETTING) ThemeSetting
{
    switch (ThemeSetting) {
            
        case THEME_LIGHT_DARK:
            _SettingTheme = THEME_LIGHT_DARK;
            break;
            
        case THEME_DARK_LIGHT:
            _SettingTheme = THEME_DARK_LIGHT;
            break;
            
        default:
            break;
    }
    
    NSString *PoetryCoreDataEntityName = POETRY_CORE_DATA_SETTING_ENTITY;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:PoetryCoreDataEntityName inManagedObjectContext:_context]];
    
    NSError *err;
    NSArray *FetchResult = [_context executeFetchRequest:request error:&err];
    NSUInteger count = [FetchResult count];
    
    if (count == 1) {
        
        // Setting is exist, update to default value
        NSManagedObject *Setting = [FetchResult objectAtIndex:0];
        
        // TODO: [CASPER] Add another Attr for Setting
        [Setting setValue: [NSNumber numberWithInt:_SettingTheme] forKey:POETRY_CORE_DATA_SETTING_THEME];
        
    } else if (count == 0) {
        
        // Setting not exist, create one        
        // TODO: [CASPER] Add another Attr for Setting
        NSManagedObject *NewPoetry = [NSEntityDescription insertNewObjectForEntityForName:PoetryCoreDataEntityName inManagedObjectContext:_context];
        
        [NewPoetry setValue: [NSNumber numberWithInt:_SettingFontSize] forKey:POETRY_CORE_DATA_SETTING_FONT_SIZE];
        [NewPoetry setValue: [NSNumber numberWithInt:_SettingTheme] forKey:POETRY_CORE_DATA_SETTING_THEME];
        
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



-(BOOL) PoetrySetting_UpdateSettingWithSettingDic : (NSDictionary *) SettingDic
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
        [Setting setValue: [NSNumber numberWithInt:POETRY_SETIING_FONT_SIZE_DEFAULT] forKey:POETRY_CORE_DATA_SETTING_FONT_SIZE];
        
        
        
    } else if (count == 0) {
        
        // Setting not exist, create one
        NSLog(@"First time in setting : Create Setting DB");
        
        // TODO: [CASPER] Add another Attr for Setting
        NSManagedObject *NewPoetry = [NSEntityDescription insertNewObjectForEntityForName:PoetryCoreDataEntityName inManagedObjectContext:_context];
        
        [NewPoetry setValue: [NSNumber numberWithInt:POETRY_SETIING_FONT_SIZE_DEFAULT] forKey:POETRY_CORE_DATA_SETTING_FONT_SIZE];
        
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

@end
