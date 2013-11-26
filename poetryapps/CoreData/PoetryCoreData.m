//
//  PoetryCoreData.m
//  poetryapps
//
//  Created by GIGIGUN on 2013/11/26.
//  Copyright (c) 2013年 cc. All rights reserved.
//

#import "PoetryCoreData.h"

@implementation PoetryCoreData


-(PoetryCoreData*) init
{
    self = [super init];
    
    if ( self ) {
        
        PoetryAppDelegate *theAppDelegate = (PoetryAppDelegate*) [UIApplication sharedApplication].delegate;
        _context = [theAppDelegate managedObjectContext];
        
    }
    
    return self;
}

// Save Poetry
-(BOOL) PoetryCoreDataSave : (NSDictionary *) PoetryDic
{
    NSString *PoetryCoreDataEntityName = POETRY_CORE_DATA_ENTITY;
    NSManagedObject *NewPoetry = [NSEntityDescription insertNewObjectForEntityForName:PoetryCoreDataEntityName inManagedObjectContext:_context];
    
    [NewPoetry setValue:[PoetryDic valueForKey:POETRY_CORE_DATA_NAME_KEY] forKey:POETRY_CORE_DATA_NAME_KEY];
    [NewPoetry setValue:[PoetryDic valueForKey:POETRY_CORE_DATA_CONTENT_KEY] forKey:POETRY_CORE_DATA_CONTENT_KEY];
    
    
    NSError *error = nil;
    if (![_context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        return NO;
    }

    return YES;

}


// 取出 Core Data 中所有 Poetry 的資料，Array 中存的是 NSManagedObject
-(NSMutableArray*) Poetry_CoreDataFetchData
{
    NSMutableArray *Poetrys = [[NSMutableArray alloc] init];
    
    NSString *PoetryCoreDataEntityName = POETRY_CORE_DATA_ENTITY;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:PoetryCoreDataEntityName];
    Poetrys = [[_context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    return Poetrys;
}



// 在 Poetry 中搜尋 Poetry Name
-(NSArray*) Poetry_CoreDataSearchWithPoetryName : (NSString *) SearcgName
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSString *BookCoreDataEntityName = POETRY_CORE_DATA_ENTITY;
    
    
	// NSSortDescriptor tells defines how to sort the fetched results
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:POETRY_CORE_DATA_NAME_KEY ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
    // fetchRequest needs to know what entity to fetch
	NSEntityDescription *entity = [NSEntityDescription entityForName:BookCoreDataEntityName inManagedObjectContext:_context];
	[fetchRequest setEntity:entity];
    
    NSFetchedResultsController  *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:_context sectionNameKeyPath:nil cacheName:@"Root"];
    
    
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"name contains[cd] %@", SearcgName];
    
    [fetchedResultsController.fetchRequest setPredicate:predicate];
    
	NSError *error = nil;
	if (![fetchedResultsController performFetch:&error])
	{
		// Handle error
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
    
    return fetchedResultsController.fetchedObjects;
    
}


// 在 Poetry 中搜尋 Poetry Name
-(NSArray*) Poetry_CoreDataSearchWithPoetryContent : (NSString *) SearchString
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSString *BookCoreDataEntityName = POETRY_CORE_DATA_ENTITY;
    
    
	// NSSortDescriptor tells defines how to sort the fetched results
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:POETRY_CORE_DATA_NAME_KEY ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
    // fetchRequest needs to know what entity to fetch
	NSEntityDescription *entity = [NSEntityDescription entityForName:BookCoreDataEntityName inManagedObjectContext:_context];
	[fetchRequest setEntity:entity];
    
    NSFetchedResultsController  *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:_context sectionNameKeyPath:nil cacheName:@"Root"];
    
    
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"content contains[cd] %@", SearchString];
    
    [fetchedResultsController.fetchRequest setPredicate:predicate];
    
	NSError *error = nil;
	if (![fetchedResultsController performFetch:&error])
	{
		// Handle error
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
    
    return fetchedResultsController.fetchedObjects;
    
}





@end
