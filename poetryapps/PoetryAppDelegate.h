//
//  PoetryAppDelegate.h
//  poetryapps
//
//  Created by Goda on 2013/11/25.
//  Copyright (c) 2013年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PoetryAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


// [CASPER] Core Data
@property (readonly, strong, nonatomic) NSManagedObjectContext          *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel            *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator    *persistentStoreCoordinator;



@end
