//
//  AppDelegate.m
//  HKApp
//
//  Created by Casper Lee on 18/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "AppConfigFetcher.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize managedObjectModel, managedObjectContext, persistentStoreCoordinator;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  // Override point for customization after application launch.
  self.window.backgroundColor = [UIColor whiteColor];
  [self.window makeKeyAndVisible];
  
#pragma mark - Data Fetcher Test START
  [[[AppConfigFetcher alloc] init] fetchData];
  
  
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -
#pragma mark Helper Methods

- (NSString *)applicationDocumentsDirectory {
  return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

#pragma mark -
#pragma mark Core Data Stack

- (NSManagedObjectContext *)managedObjectContext {
  if (!managedObjectContext) {    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator) {
      managedObjectContext = [[NSManagedObjectContext alloc] init];
      managedObjectContext.persistentStoreCoordinator = coordinator;
    }
  }
  
  return managedObjectContext;
}


- (NSManagedObjectModel *)managedObjectModel {
  if (!managedObjectModel) {
    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];    
  }
  
  return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
  if (!persistentStoreCoordinator) {
    NSURL *storeUrl = [NSURL fileURLWithPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"Base.sqlite"]];
    
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];  
    
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {    
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      
      abort();
    } 
  }
  
  return persistentStoreCoordinator;
}


@end
