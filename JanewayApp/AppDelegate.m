//
//  AppDelegate.m
//  JanewayApp
//
//  Created by cz5670 on 2016-05-09.
//  Copyright © 2016 winemocol. All rights reserved.
//

#import "AppDelegate.h"
#import "AtHomeTableViewController.h"
#import "Section.h"

@interface AppDelegate ()
@property (strong, nonatomic) UITabBarController *myTabBarController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    _myTabBarController = (UITabBarController *) self.window.rootViewController;
    UITabBar *tabBar = _myTabBarController.tabBar;
    
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];
    UITabBarItem *tabBarItem4 = [tabBar.items objectAtIndex:3];
    
    tabBarItem1.title = @"At Home";
    tabBarItem2.title = @"On the go";
    tabBarItem3.title = @"Bulletin";
    tabBarItem4.title = @"Info";
    
    [tabBarItem1 setImage:[UIImage imageNamed:@"AtHome"]];
    [tabBarItem2 setImage:[UIImage imageNamed:@"OnGo"]];
    [tabBarItem3 setImage:[UIImage imageNamed:@"Seasonal"]];
    [tabBarItem4 setImage:[UIImage imageNamed:@"Settings"]];
    //[self checkJson];
    [self copyDatabaseIfNeeded];
    
//    [NSTimer scheduledTimerWithTimeInterval:2.0
//                                     target:self
//                                   selector:@selector(checkJson)
//                                   userInfo:nil
//                                    repeats:YES];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "winemocol.JanewayApp" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"JanewayApp" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"JanewayApp.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}


- (NSString*) copyDatabaseIfNeeded {
    
    //Using NSFileManager we can perform many file system operations.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSString *dbPath = [self getDBPath];
    BOOL success = [fileManager fileExistsAtPath:dbPath];
    
    if(!success) {
        
        NSString *defaultDBPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"janewayDB.sqlite3"];
        // NSString *defaultDBPath = [NSBundle.mainBundle pathForResource:@"janeway" ofType:@"sqlite"];
        // NSString *defaultDBPath = [[NSBundle mainBundle] resourcePath];
        //NSString* defaultDBPath = [[NSBundle mainBundle] pathForResource:@"janeway" ofType:@"db"];
        NSLog(@"defaultDBPath : %@",defaultDBPath);
        success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        
        if (!success)
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
    NSLog(@"dbPath : %@",dbPath);
    return dbPath;
}

- (NSString *) getDBPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    //NSLog(@"dbpath : %@",documentsDir);
    return [documentsDir stringByAppendingPathComponent:@"janewayDB.sqlite3"];
}




//-(void)checkJson {
//    
//    
//    //NSLog(@"checkJson = %@",[self getTimeFromPlist]);
//    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"http://localhost/safety/getInfo.php?type=numberofItems&since=%@", [self getTimeFromPlist]]]];
//    
//    __block NSDictionary *json;
//    [NSURLConnection sendAsynchronousRequest:request
//                                       queue:[NSOperationQueue mainQueue]
//                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//                               json = [NSJSONSerialization JSONObjectWithData:data
//                                                                      options:0
//                                                                        error:nil];
//                               
////                               NSLog(@"coin");
//                               
//                               _myTabBarController = (UITabBarController *) self.window.rootViewController;
//                               UITabBar *tabBar = _myTabBarController.tabBar;
//                               UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];
//                               if ([json[@"count"] intValue] !=0) {
//                                   tabBarItem3.badgeValue = json[@"count"];
//                               } else {
//                                   [tabBarItem3 setBadgeValue:NULL];
//                               }
//                               
//                           }
//     
//     ];
//}
//
//-(NSString*)getTimeFromPlist {
// 
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString *timerInfo = [userDefaults objectForKey:@"timerInfo"];
//    //NSLog(@"checkJson = %@",timerInfo);
//    if(timerInfo !=NULL) {
//        
//        return timerInfo;
//    } else {
//        [userDefaults setObject:@"2015" forKey:@"timerInfo"];
//        return  @"2015";
//    }
//}


#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
     
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Test code, insert data into Core Data

-(void) initilizeCoreData {
    
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *moc = ad.managedObjectContext;
    Section *section = (Section *)[NSEntityDescription insertNewObjectForEntityForName:@"Section" inManagedObjectContext:moc];
    
    section.sectionTitle = @"In the Home";
    section.sectionDescription = @"dddd";
    section.sectionImage = @"atHome.png";
    section.sectionURL = @"www.google.ca";
    section.lastSectionIndicator = false;
    section.sectionID = [NSNumber numberWithInt:2];
    
    NSError *error;
    if (![moc save:&error]) {
        // Something's gone seriously wrong
        NSLog(@"Error saving new color: %@", [error localizedDescription]);
    } else {
        NSLog(@"Code data saving successfully");
    }
    
}

@end
