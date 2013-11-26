//
//  PoetryCoreData.m
//  poetryapps
//
//  Created by GIGIGUN on 2013/11/26.
//  Copyright (c) 2013年 cc. All rights reserved.
//

#import "PoetryCoreData.h"

@implementation PoetryCoreData


-(PoetryCoreData*) init{
    self = [super init];
    
    if ( self ) {
        
        PoetryAppDelegate *theAppDelegate = (PoetryAppDelegate*) [UIApplication sharedApplication].delegate;
        _context = [theAppDelegate managedObjectContext];
        
    }
    
    return self;
}

// Save Poetry
-(BOOL) PoetryCoreDataSave : (NSDictionary *) PoetryObj
{
    NSString *PoetryCoreDataEntityName = POETRY_CORE_DATA_ENTITY;
    NSManagedObject *NewPoetry = [NSEntityDescription insertNewObjectForEntityForName:PoetryCoreDataEntityName inManagedObjectContext:_context];
    
    
    [NewPoetry setValue:[PoetryObj valueForKey:POETRY_CORE_DATA_NAME_KEY] forKey:POETRY_CORE_DATA_NAME_KEY];
    [NewPoetry setValue:[PoetryObj valueForKey:POETRY_CORE_DATA_NAME_KEY] forKey:POETRY_CORE_DATA_NAME_KEY];
    
    
    NSError *error = nil;
    if (![_context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        return NO;
    }

    return YES;

}


// 取出 Core Data 中所有 Book 的資料，Array 中存的是 NSManagedObject
-(NSMutableArray*) Books_CoreDataFetchData
{
    NSMutableArray *Poetrys = [[NSMutableArray alloc] init];
    
    NSString *PoetryCoreDataEntityName = POETRY_CORE_DATA_ENTITY;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:PoetryCoreDataEntityName];
    Poetrys = [[_context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    return Poetrys;
}


@end
