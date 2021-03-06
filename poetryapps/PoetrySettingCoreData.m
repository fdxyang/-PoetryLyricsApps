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
        [NewPoetry setValue: [NSNumber numberWithBool:NO] forKey:POETRY_CORE_DATA_SETTING_DATA_SAVED];
        [NewPoetry setValue: [NSNumber numberWithInt:0] forKey:POETRY_CORE_DATA_SETTING_DATA_SAVED_INDEX];
        [NewPoetry setValue: [NSNumber numberWithBool:NO] forKey:POETRY_CORE_DATA_SETTING_TUTORIAL];

        
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
        SETTING_LOG(@"In Poetry Setting : Set to default");

        NSManagedObject *Setting = [FetchResult objectAtIndex:0];
        
        // TODO: [CASPER] Add another Attr for Setting
        [Setting setValue: [NSNumber numberWithInt:POETRY_SETIING_FONT_SIZE_DEFAULT] forKey:POETRY_CORE_DATA_SETTING_FONT_SIZE];
        [Setting setValue:[NSNumber numberWithInt:POETRY_SETTING_THEME_DEFAULT] forKey:POETRY_CORE_DATA_SETTING_THEME];
        
        
    } else if (count == 0) {
        
        // Setting not exist, create one
        SETTING_ERROR_LOG(@"Setting not found Create Setting DB");
        
        // TODO: [CASPER] Add another Attr for Setting
        NSManagedObject *NewPoetry = [NSEntityDescription insertNewObjectForEntityForName:PoetryCoreDataEntityName inManagedObjectContext:_context];
        
        [NewPoetry setValue: [NSNumber numberWithInt:POETRY_SETIING_FONT_SIZE_DEFAULT] forKey:POETRY_CORE_DATA_SETTING_FONT_SIZE];
        [NewPoetry setValue: [NSNumber numberWithInt:POETRY_SETTING_THEME_DEFAULT] forKey:POETRY_CORE_DATA_SETTING_THEME];
        [NewPoetry setValue: [NSNumber numberWithBool:NO] forKey:POETRY_CORE_DATA_SETTING_DATA_SAVED];
        [NewPoetry setValue: [NSNumber numberWithInt:0] forKey:POETRY_CORE_DATA_SETTING_DATA_SAVED_INDEX];
        [NewPoetry setValue: [NSNumber numberWithBool:NO] forKey:POETRY_CORE_DATA_SETTING_TUTORIAL];


    } else {
        
        SETTING_ERROR_LOG(@"ERROR!!! Multiple Setting");

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


-(UInt16) PoetrySetting_GetDataSavedIndex
{
    NSDictionary *SettingDic = [self PoetrySetting_ReadSetting];
    NSNumber *SavedIndex = [SettingDic valueForKey:POETRY_CORE_DATA_SETTING_DATA_SAVED];
    UInt16 DataSavedIndex = [SavedIndex intValue];
    return DataSavedIndex;
}



#pragma mark - SaveFlag
-(BOOL) PoetrySetting_GetDataSavedFlag
{
    NSDictionary *SettingDic = [self PoetrySetting_ReadSetting];
    NSNumber *Saved = [SettingDic valueForKey:POETRY_CORE_DATA_SETTING_DATA_SAVED];
    BOOL DataSaved = [Saved boolValue];
    return DataSaved;
}


#pragma mark - TutorialFlag
-(BOOL) PoetrySetting_SetTutorialViewShowed : (BOOL) Showed
{
    NSString *PoetryCoreDataEntityName = POETRY_CORE_DATA_SETTING_ENTITY;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:PoetryCoreDataEntityName inManagedObjectContext:_context]];
    
    NSError *err;
    NSArray *FetchResult = [_context executeFetchRequest:request error:&err];
    NSUInteger count = [FetchResult count];
    
    if (count == 1) {
        
        // Setting is exist, update to default value
        NSLog(@"Set to data saved as %d", Showed);
        
        NSManagedObject *Setting = [FetchResult objectAtIndex:0];
        
        [Setting setValue: [NSNumber numberWithBool:Showed] forKey:POETRY_CORE_DATA_SETTING_TUTORIAL];
        
    } else if (count == 0) {
        
        // Setting not exist, create one
        NSLog(@"UPDATE- Normally it should not be here!!!");
        
        NSManagedObject *NewPoetry = [NSEntityDescription insertNewObjectForEntityForName:PoetryCoreDataEntityName inManagedObjectContext:_context];
        
        [NewPoetry setValue: [NSNumber numberWithInt:_SettingFontSize] forKey:POETRY_CORE_DATA_SETTING_FONT_SIZE];
        [NewPoetry setValue: [NSNumber numberWithInt:_SettingTheme] forKey:POETRY_CORE_DATA_SETTING_THEME];
        [NewPoetry setValue: [NSNumber numberWithBool:Showed] forKey:POETRY_CORE_DATA_SETTING_DATA_SAVED];
        
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

-(BOOL) PoetrySetting_GetTutorialShowedFlag
{
    NSDictionary *SettingDic = [self PoetrySetting_ReadSetting];
    NSNumber *Showed = [SettingDic valueForKey:POETRY_CORE_DATA_SETTING_TUTORIAL];
    BOOL AlreadyShowed = [Showed boolValue];
    return AlreadyShowed;
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


-(BOOL) PoetrySetting_SetDataSaved : (BOOL) DataSaved
{
    
    NSString *PoetryCoreDataEntityName = POETRY_CORE_DATA_SETTING_ENTITY;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:PoetryCoreDataEntityName inManagedObjectContext:_context]];
    
    NSError *err;
    NSArray *FetchResult = [_context executeFetchRequest:request error:&err];
    NSUInteger count = [FetchResult count];
    
    if (count == 1) {
        
        // Setting is exist, update to default value
        SETTING_LOG(@"Set to data saved as %d", DataSaved);
        
        NSManagedObject *Setting = [FetchResult objectAtIndex:0];
        
        // TODO: [CASPER] Add another Attr for Setting
        [Setting setValue: [NSNumber numberWithBool:DataSaved] forKey:POETRY_CORE_DATA_SETTING_DATA_SAVED];
        
    } else if (count == 0) {
        
        // Setting not exist, create one
        SETTING_LOG(@"UPDATE- Normally it should not be here!!!");
        
        // TODO: [CASPER] Add another Attr for Setting
        NSManagedObject *NewPoetry = [NSEntityDescription insertNewObjectForEntityForName:PoetryCoreDataEntityName inManagedObjectContext:_context];
        
        [NewPoetry setValue: [NSNumber numberWithInt:_SettingFontSize] forKey:POETRY_CORE_DATA_SETTING_FONT_SIZE];
        [NewPoetry setValue: [NSNumber numberWithInt:_SettingTheme] forKey:POETRY_CORE_DATA_SETTING_THEME];
        [NewPoetry setValue: [NSNumber numberWithBool:DataSaved] forKey:POETRY_CORE_DATA_SETTING_DATA_SAVED];
        
    } else {
        
        SETTING_ERROR_LOG(@"ERROR!!! Multiple Setting");
        
    }
    
    NSError *error = nil;
    if (![_context save:&error]) {
        SETTING_LOG(@"Can't Save! %@ %@", error, [error localizedDescription]);
        return NO;
    }
    
    
    return YES;
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
        SETTING_LOG(@"In Poetry Setting : Set to default");
        
        NSManagedObject *Setting = [FetchResult objectAtIndex:0];
        
        // TODO: [CASPER] Add another Attr for Setting
        [Setting setValue: [NSNumber numberWithInt:LocalFontSize] forKey:POETRY_CORE_DATA_SETTING_FONT_SIZE];
        
    } else if (count == 0) {
        
        // Setting not exist, create one
        SETTING_LOG(@"UPDATE- Normally it should not be here!!!");
        
        // TODO: [CASPER] Add another Attr for Setting
        NSManagedObject *NewPoetry = [NSEntityDescription insertNewObjectForEntityForName:PoetryCoreDataEntityName inManagedObjectContext:_context];
        
        [NewPoetry setValue: [NSNumber numberWithInt:LocalFontSize] forKey:POETRY_CORE_DATA_SETTING_FONT_SIZE];
        [NewPoetry setValue: [NSNumber numberWithInt:_SettingTheme] forKey:POETRY_CORE_DATA_SETTING_THEME];
        [NewPoetry setValue: [NSNumber numberWithBool:NO] forKey:POETRY_CORE_DATA_SETTING_DATA_SAVED];

    } else {
        
        SETTING_LOG(@"ERROR!!! Multiple Setting");
        
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
        SETTING_ERROR_LOG(@"UPDATE- Normally it should not be here!!!");
        NSManagedObject *NewPoetry = [NSEntityDescription insertNewObjectForEntityForName:PoetryCoreDataEntityName inManagedObjectContext:_context];
        
        [NewPoetry setValue: [NSNumber numberWithInt:_SettingFontSize] forKey:POETRY_CORE_DATA_SETTING_FONT_SIZE];
        [NewPoetry setValue: [NSNumber numberWithInt:_SettingTheme] forKey:POETRY_CORE_DATA_SETTING_THEME];
        [NewPoetry setValue: [NSNumber numberWithBool:NO] forKey:POETRY_CORE_DATA_SETTING_DATA_SAVED];

    } else {
        
        SETTING_LOG(@"ERROR!!! Multiple Setting");
        
    }
    
    NSError *error = nil;
    if (![_context save:&error]) {
        SETTING_ERROR_LOG(@"Can't Save! %@ %@", error, [error localizedDescription]);
        return NO;
    }
    
    
    return YES;
}




-(BOOL) PoetrySetting_SetDataSavedIndex : (UInt16) IndexSaved
{
    
    NSString *PoetryCoreDataEntityName = POETRY_CORE_DATA_SETTING_ENTITY;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:PoetryCoreDataEntityName inManagedObjectContext:_context]];
    
    NSError *err;
    NSArray *FetchResult = [_context executeFetchRequest:request error:&err];
    NSUInteger count = [FetchResult count];
    
    if (count == 1) {
        
        // Setting is exist, update to default value
        SETTING_LOG(@"Set to data saved as %d", DataSaved);
        
        NSManagedObject *Setting = [FetchResult objectAtIndex:0];
        
        // TODO: [CASPER] Add another Attr for Setting
        [Setting setValue: [NSNumber numberWithInt:IndexSaved] forKey:POETRY_CORE_DATA_SETTING_DATA_SAVED_INDEX];
        
    } else if (count == 0) {
        
        // Setting not exist, create one
        SETTING_ERROR_LOG(@"UPDATE- Normally it should not be here!!!");
        
        // TODO: [CASPER] Add another Attr for Setting
        NSManagedObject *NewPoetry = [NSEntityDescription insertNewObjectForEntityForName:PoetryCoreDataEntityName inManagedObjectContext:_context];
        
        [NewPoetry setValue: [NSNumber numberWithInt:_SettingFontSize] forKey:POETRY_CORE_DATA_SETTING_FONT_SIZE];
        [NewPoetry setValue: [NSNumber numberWithInt:_SettingTheme] forKey:POETRY_CORE_DATA_SETTING_THEME];
        [NewPoetry setValue: [NSNumber numberWithBool:NO] forKey:POETRY_CORE_DATA_SETTING_DATA_SAVED];
        [NewPoetry setValue: [NSNumber numberWithInt:0] forKey:POETRY_CORE_DATA_SETTING_DATA_SAVED_INDEX];
        
    } else {
        
        SETTING_ERROR_LOG(@"ERROR!!! Multiple Setting");
        
    }
    
    NSError *error = nil;
    if (![_context save:&error]) {
        SETTING_LOG(@"Can't Save! %@ %@", error, [error localizedDescription]);
        return NO;
    }
    
    
    return YES;
}


/*
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
        SETTING_LOG(@"In Poetry Setting : Set to default");
        
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
*/
@end
