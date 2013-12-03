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



// 刪除 Core Data 中特定的資料
-(BOOL) Poetry_CoreDataDelete:(NSManagedObject*) Poetry
{
    
    [_context deleteObject:Poetry];
    
    NSError *error = nil;
    
    if (![_context save:&error]) {
        NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
        return NO;
    }
    
    return YES;
}



#pragma mark - Poetry Core Data Methods
// Save Poetry
-(BOOL) PoetryCoreDataSave : (NSDictionary *) PoetryDic inCategory : (POETRY_CATEGORY) Category;
{
    NSString *PoetryCoreDataEntityName;
    
    switch (Category) {
            
        case GUARD_READING:
            PoetryCoreDataEntityName = POETRY_GUARD_CORE_DATA_ENTITY;
            break;
            
        case POETRYS:
            PoetryCoreDataEntityName = POETRY_CORE_DATA_ENTITY;
            break;
            
        case RESPONSIVE_PRAYER:
            PoetryCoreDataEntityName = POETRY_RES_CORE_DATA_ENTITY;
            break;
            
        default:
            break;
    }
    
    NSManagedObject *NewPoetry = [NSEntityDescription insertNewObjectForEntityForName:PoetryCoreDataEntityName inManagedObjectContext:_context];
    
    [NewPoetry setValue:[PoetryDic valueForKey:POETRY_CORE_DATA_NAME_KEY] forKey:POETRY_CORE_DATA_NAME_KEY];
    [NewPoetry setValue:[PoetryDic valueForKey:POETRY_CORE_DATA_CONTENT_KEY] forKey:POETRY_CORE_DATA_CONTENT_KEY];
    [NewPoetry setValue:[PoetryDic valueForKey:POETRY_CORE_DATA_INDEX_KEY] forKey:POETRY_CORE_DATA_INDEX_KEY];
    
    NSDate *CreationDate = [NSDate date];
    [NewPoetry setValue: CreationDate forKey:POETRY_CORE_DATA_CREATION_TIME_KEY];
    
    NSError *error = nil;
    if (![_context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        return NO;
    }

    return YES;

}

// 取出 Core Data 中所有 Poetry 的資料，Array 中存的是 NSManagedObject
-(NSMutableArray*) Poetry_CoreDataFetchDataInCategory : (POETRY_CATEGORY) Category
{
    NSMutableArray *Poetrys = [[NSMutableArray alloc] init];
    
    NSString *PoetryCoreDataEntityName;
    
    switch (Category) {
            
        case GUARD_READING:
            PoetryCoreDataEntityName = POETRY_GUARD_CORE_DATA_ENTITY;
            break;
            
        case POETRYS:
            PoetryCoreDataEntityName = POETRY_CORE_DATA_ENTITY;
            break;
            
        case RESPONSIVE_PRAYER:
            PoetryCoreDataEntityName = POETRY_RES_CORE_DATA_ENTITY;
            break;
            
        default:
            break;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:PoetryCoreDataEntityName];
    Poetrys = [[_context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    return Poetrys;
}



// 在 Poetry 中搜尋 Poetry Name
-(NSArray*) Poetry_CoreDataSearchWithPoetryName : (NSString *) SearchName InCategory : (POETRY_CATEGORY) Category
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSString *BookCoreDataEntityName;
    
    switch (Category) {
            
        case GUARD_READING:
            BookCoreDataEntityName = POETRY_GUARD_CORE_DATA_ENTITY;
            break;
            
        case POETRYS:
            BookCoreDataEntityName = POETRY_CORE_DATA_ENTITY;
            break;
            
        case RESPONSIVE_PRAYER:
            BookCoreDataEntityName = POETRY_RES_CORE_DATA_ENTITY;
            break;
            
        default:
            break;
    }
    
	// NSSortDescriptor tells defines how to sort the fetched results
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:POETRY_CORE_DATA_NAME_KEY ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
    // fetchRequest needs to know what entity to fetch
	NSEntityDescription *entity = [NSEntityDescription entityForName:BookCoreDataEntityName inManagedObjectContext:_context];
	[fetchRequest setEntity:entity];
    
    NSFetchedResultsController  *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:_context sectionNameKeyPath:nil cacheName:@"Root"];
    
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"name contains[cd] %@", SearchName];
    
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


// 在 Poetry 中搜尋 String
-(NSArray*) Poetry_CoreDataSearchWithPoetryContent : (NSString *) SearchString InCategory : (POETRY_CATEGORY) Category
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSString *BookCoreDataEntityName;
    
    switch (Category) {
        case GUARD_READING:
            BookCoreDataEntityName = POETRY_GUARD_CORE_DATA_ENTITY;
            break;
            
        case POETRYS:
            BookCoreDataEntityName = POETRY_CORE_DATA_ENTITY;
            break;
            
        case RESPONSIVE_PRAYER:
            BookCoreDataEntityName = POETRY_RES_CORE_DATA_ENTITY;
            break;
            
        default:
            break;
    }
    
	// NSSortDescriptor tells defines how to sort the fetched results
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:POETRY_CORE_DATA_CONTENT_KEY ascending:YES];
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


-(NSUInteger) Poetry_CoreDataGetNumber
{
    NSString *PoetryCoreDataEntityName = POETRY_CORE_DATA_ENTITY;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:PoetryCoreDataEntityName inManagedObjectContext:_context]];
    
    [request setIncludesSubentities:NO]; //Omit subentities. Default is YES (i.e. include subentities)
    
    NSError *err;
    NSUInteger count = [_context countForFetchRequest:request error:&err];
    if(count == NSNotFound) {
        //Handle error
    }
    
    return count;
}


#pragma mark - History Core Data Methods

// Save Poetry into History
-(BOOL) PoetryCoreDataSaveIntoHistory : (NSDictionary *) PoetryDic
{
    NSString *PoetryCoreDataEntityName = POETRY_HISTORY_CORE_DATA_ENTITY;
    NSManagedObject *NewPoetry = [NSEntityDescription insertNewObjectForEntityForName:PoetryCoreDataEntityName inManagedObjectContext:_context];
    
    [NewPoetry setValue:[PoetryDic valueForKey:POETRY_CORE_DATA_NAME_KEY] forKey:POETRY_CORE_DATA_NAME_KEY];
    [NewPoetry setValue:[PoetryDic valueForKey:POETRY_CORE_DATA_CONTENT_KEY] forKey:POETRY_CORE_DATA_CONTENT_KEY];
    [NewPoetry setValue:[PoetryDic valueForKey:POETRY_CORE_DATA_INDEX_KEY] forKey:POETRY_CORE_DATA_INDEX_KEY];
    [NewPoetry setValue:[PoetryDic valueForKey:POETRY_CORE_DATA_CATERORY_KEY] forKey:POETRY_CORE_DATA_CATERORY_KEY];
    
    
    NSError *error = nil;
    if (![_context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        return NO;
    }
    
    return YES;
    
}


// 取出 History 中所有 Poetry 的資料，Array 中存的是 NSManagedObject
-(NSMutableArray*) Poetry_CoreDataFetchDataInHistory
{
    NSMutableArray *Poetrys = [[NSMutableArray alloc] init];
    
    NSString *PoetryCoreDataEntityName = POETRY_HISTORY_CORE_DATA_ENTITY;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:PoetryCoreDataEntityName];
    Poetrys = [[_context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    return Poetrys;
}


-(NSUInteger) Poetry_CoreDataGetNumberInHistory
{
    NSString *PoetryCoreDataEntityName = POETRY_HISTORY_CORE_DATA_ENTITY;

    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:PoetryCoreDataEntityName inManagedObjectContext:_context]];
    
    [request setIncludesSubentities:NO]; //Omit subentities. Default is YES (i.e. include subentities)
    
    NSError *err;
    NSUInteger count = [_context countForFetchRequest:request error:&err];
    if(count == NSNotFound) {
        //Handle error
    }
    
    return count;
}

// Delete the Oldest object in history
-(BOOL) Poetry_CoreDataDeleteOldestInHistory
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:POETRY_HISTORY_CORE_DATA_ENTITY inManagedObjectContext:_context];
    [request setEntity:entity];
    
    // Specify that the request should return dictionaries.
    [request setResultType:NSDictionaryResultType];
    
    // Create an expression for the key path.
    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:POETRY_CORE_DATA_CREATION_TIME_KEY];
    
    // Create an expression to represent the minimum value at the key path 'creationDate'
    NSExpression *minExpression = [NSExpression expressionForFunction:@"min:" arguments:[NSArray arrayWithObject:keyPathExpression]];
    
    // Create an expression description using the minExpression and returning a date.
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    
    // The name is the key that will be used in the dictionary for the return value.
    [expressionDescription setName:@"minDate"];
    [expressionDescription setExpression:minExpression];
    [expressionDescription setExpressionResultType:NSDateAttributeType];
    
    // Set the request's properties to fetch just the property represented by the expressions.
    [request setPropertiesToFetch:[NSArray arrayWithObject:expressionDescription]];
    
    // Execute the fetch.
    NSError *error = nil;
    NSArray *objects = [_context executeFetchRequest:request error:&error];
    if (objects == nil) {
        // Handle the error.
        return NO;
    }
    else {
        if ([objects count] > 0) {
            NSLog(@"Minimum date: %@", [[objects objectAtIndex:0] valueForKey:@"minDate"]);
            [self Poetry_CoreDataDelete:[objects objectAtIndex:0]];

        }
    }
    return YES;

}


// 在 History 中搜尋 Poetry Name
-(NSArray*) Poetry_CoreDataSearchWithPoetryNameInHistory : (NSString *) SearcgName
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSString *BookCoreDataEntityName = POETRY_HISTORY_CORE_DATA_ENTITY;
    
    
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


// 在 History 中搜尋 String
-(NSArray*) Poetry_CoreDataSearchWithPoetryContentInHistory : (NSString *) SearchString
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSString *BookCoreDataEntityName = POETRY_HISTORY_CORE_DATA_ENTITY;
    
    
	// NSSortDescriptor tells defines how to sort the fetched results
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:POETRY_CORE_DATA_CONTENT_KEY ascending:YES];
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

#pragma mark - Now Reading Core Data Methods
// Save Poetry into now reading
-(BOOL) PoetryCoreDataSaveIntoNowReading : (NSDictionary *) PoetryDic
{
    NSString *PoetryCoreDataEntityName = POETRY_NOW_READING_CORE_DATA_ENTITY;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:PoetryCoreDataEntityName inManagedObjectContext:_context]];
    
    NSError *err;
    NSArray *FetchResult = [_context executeFetchRequest:request error:&err];
    NSUInteger count = [FetchResult count];
    
    if (count == 1) {
        
        NSLog(@"In Poetry NowReading : Update NowReading ");
        
        NSManagedObject *Reading = [FetchResult objectAtIndex:0];
        
        // TODO: [CASPER] Add another Attr for Setting
        [Reading setValue: [PoetryDic valueForKey:POETRY_CORE_DATA_NAME_KEY] forKey:POETRY_CORE_DATA_NAME_KEY];
        [Reading setValue: [PoetryDic valueForKey:POETRY_CORE_DATA_CONTENT_KEY] forKey:POETRY_CORE_DATA_CONTENT_KEY];
        [Reading setValue: [PoetryDic valueForKey:POETRY_CORE_DATA_INDEX_KEY] forKey:POETRY_CORE_DATA_INDEX_KEY];
        [Reading setValue: [PoetryDic valueForKey:POETRY_CORE_DATA_CATERORY_KEY] forKey:POETRY_CORE_DATA_CATERORY_KEY];

        
        
    } else if (count == 0) {
        
        NSLog(@"First Time use, create reading");

        // TODO: [CASPER] Add another Attr for Setting
        NSManagedObject *Reading = [NSEntityDescription insertNewObjectForEntityForName:PoetryCoreDataEntityName inManagedObjectContext:_context];
        
        [Reading setValue: [PoetryDic valueForKey:POETRY_CORE_DATA_NAME_KEY] forKey:POETRY_CORE_DATA_NAME_KEY];
        [Reading setValue: [PoetryDic valueForKey:POETRY_CORE_DATA_CONTENT_KEY] forKey:POETRY_CORE_DATA_CONTENT_KEY];
        [Reading setValue: [PoetryDic valueForKey:POETRY_CORE_DATA_INDEX_KEY] forKey:POETRY_CORE_DATA_INDEX_KEY];
        [Reading setValue: [PoetryDic valueForKey:POETRY_CORE_DATA_CATERORY_KEY] forKey:POETRY_CORE_DATA_CATERORY_KEY];

        
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



-(BOOL) Poetry_CoreDataReadingExist
{
    NSString *PoetryCoreDataEntityName = POETRY_NOW_READING_CORE_DATA_ENTITY;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:PoetryCoreDataEntityName inManagedObjectContext:_context]];
    
    [request setIncludesSubentities:NO]; //Omit subentities. Default is YES (i.e. include subentities)
    
    NSError *err;
    NSUInteger count = [_context countForFetchRequest:request error:&err];
    if(count == NSNotFound) {
        //Handle error
    } else if (count == 0) {
        
        return NO;
        
    } else if (count == 1) {
        
        return YES;
        
    } else {
        
        NSLog(@"ERROR!, please check! it should not be here");
        
    }
    
    return YES;
}


-(NSDictionary*) Poetry_CoreDataFetchDataInReading
{
    NSMutableArray *Poetrys = [[NSMutableArray alloc] init];
    
    NSString *PoetryCoreDataEntityName = POETRY_NOW_READING_CORE_DATA_ENTITY;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:PoetryCoreDataEntityName];
    Poetrys = [[_context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSDictionary *ReturnDic = (NSDictionary*)[Poetrys objectAtIndex:0];

    return ReturnDic;
}



@end
