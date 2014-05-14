//
//  AppDelegate.m
//  CoreData
//
//  Created by Pablo on 05/05/14.
//  Copyright (c) 2014 Pablo Rueda. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "Employee.h"
#import "Account.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (void)loadData {
    NSManagedObjectContext *context = self.managedObjectContext;
    
    Account *account1 = [NSEntityDescription insertNewObjectForEntityForName:@"Account" inManagedObjectContext:context];
    account1.code = @"MNS001";
    account1.name = @"MediaNet 1";
    
    Account *account2 = [NSEntityDescription insertNewObjectForEntityForName:@"Account" inManagedObjectContext:context];
    account2.code = @"MNS002";
    account2.name = @"MediaNet 2";
    
    Account *account3 = [NSEntityDescription insertNewObjectForEntityForName:@"Account" inManagedObjectContext:context];
    account3.code = @"BBVA001";
    account3.name = @"BBVA 1";
    
    Employee *employee1 = [NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:context];
    employee1.initials = @"PR";
    employee1.name = @"Pablo Rueda";
    employee1.accounts = [NSSet setWithObjects:account1, account2, nil];
    
    Employee *employee2 = [NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:context];
    employee2.initials = @"WS";
    employee2.name = @"Will Smith";
    employee2.accounts = [NSSet setWithObjects:account2, account3, nil];
    
    Employee *employee3 = [NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:context];
    employee3.initials = @"JL";
    employee3.name = @"John Lennon";
    employee3.accounts = [NSSet setWithObjects:account3, nil];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    BOOL loaded = [[NSUserDefaults standardUserDefaults] boolForKey:@"loaded"];
    if (!loaded) {
        [self loadData];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"loaded"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    // Override point for customization after application launch.
    ViewController *controller = (ViewController *)self.window.rootViewController;
    controller.managedObjectContext = self.managedObjectContext;
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoreData" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CoreData.sqlite"];
    
    /*if (![[NSFileManager defaultManager] fileExistsAtPath:[storeURL path]]) {
        NSURL *preloadURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"CoreData2" ofType:@"sqlite"]];
        NSError* err = nil;
        
        if (![[NSFileManager defaultManager] copyItemAtURL:preloadURL toURL:storeURL error:&err]) {
            NSLog(@"Oops, could copy preloaded data");
        }
    }*/
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
