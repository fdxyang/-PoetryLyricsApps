//
//  PoetrySaveIntoCoreData.h
//  poetryapps
//
//  Created by Goda on 2013/12/19.
//  Copyright (c) 2013年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PoetryCoreData.h"
#import "PoetrySettingCoreData.h"
#import "General.h"

@interface PoetrySaveIntoCoreData : NSObject

-(PoetrySaveIntoCoreData*) init;
- (BOOL)isCoreDataSave;
- (NSArray*) getPlistContent;
- (BOOL)isCheckPlistFileExist;
- (BOOL)isUpdatePlistFile;
- (void) isAddNewFile;
@end
