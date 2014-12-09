//
//  AppDelegate.m
//  DeveloperTest
//
//  Created by Ilya Maier on 08.12.14.
//  Copyright (c) 2014 Mera. All rights reserved.
//

#import "AppDelegate.h"
#import "StoreTableViewController.h"
#import "WebViewController.h"
#import "StoreFetcher.h"
#import "Store+Create.h"
#import "Notifications.h"
#import "LocalizedStrings.h"

#define WEB_VIEW_URL @"http://www.apple.com/"
#define STORE_TAB_IMAGE [UIImage imageNamed:@"first"]
#define WEB_TAB_IMAGE [UIImage imageNamed:@"second"]
#define DATABASE_NAME @"Default Store Database"


@interface AppDelegate ()

@property (retain, nonatomic)  UITabBarController *tabBarController;

@property (retain, nonatomic)  UIManagedDocument *storeDatabase;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if (!self.storeDatabase) {
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:DATABASE_NAME];
        self.storeDatabase = [[UIManagedDocument alloc] initWithFileURL:url];
    }
    
    UIViewController *tableViewController = [[[StoreTableViewController alloc] init] autorelease];
    UINavigationController *nc_table = [[[UINavigationController alloc] initWithRootViewController: tableViewController] autorelease];
    UIViewController *webViewController = [[[WebViewController alloc] initWithUrl:[NSURL URLWithString:WEB_VIEW_URL]] autorelease];
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:nc_table, webViewController, nil];
    UITabBarItem *item;
    item = self.tabBarController.tabBar.items[0];
    item.title = STORE_TAB_TITLE;
    item.image = STORE_TAB_IMAGE;
    item = self.tabBarController.tabBar.items[1];
    item.title = WEB_TAB_TITLE;
    item.image = WEB_TAB_IMAGE;
  
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    [self.window addSubview:self.tabBarController.view];
    self.window.rootViewController = self.tabBarController;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}
                                
                                
- (void)setStoreDatabase:(UIManagedDocument *)storeDatabase
{
    
    if (_storeDatabase != storeDatabase) {
        [storeDatabase retain];
        [_storeDatabase release];
        _storeDatabase = storeDatabase;
        [self useDocument];
    }
    
}

- (void)useDocument
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.storeDatabase.fileURL path]]) {
        // does not exist on disk, so create it
        [self.storeDatabase saveToURL:self.storeDatabase.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            [self broadcastManagedObjectContext];
            [self fetchStoreDataIntoDocument:self.storeDatabase];
        }];
    } else if (self.storeDatabase.documentState == UIDocumentStateClosed) {
        // exists on disk, but we need to open it
        [self.storeDatabase openWithCompletionHandler:^(BOOL success) {
            [self broadcastManagedObjectContext];
        }];
    } else if (self.storeDatabase.documentState == UIDocumentStateNormal) {
        // already open and ready to use
        [self broadcastManagedObjectContext];
    }
}

- (void)broadcastManagedObjectContext
{
    NSDictionary *userInfo = @{StoreDatabaseAvailabilitiyContext:self.storeDatabase.managedObjectContext};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:StoreDatabaseAvailabilitiyNotification object:self userInfo:userInfo];
}

-(NSManagedObjectContext *)managedObjectContext
{
    return self.storeDatabase.managedObjectContext;
}

- (void)fetchStoreDataIntoDocument:(UIManagedDocument *)document
{
    dispatch_queue_t fetchQ = dispatch_queue_create("Store fetcher", NULL);
    dispatch_async(fetchQ, ^{
        NSArray *stores = [StoreFetcher fetchStores];
        [document.managedObjectContext performBlock:^{
            [Store loadFromStoreInfoArray:stores inManagedObjectContext:document.managedObjectContext];
            
            [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
        }];
    });
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
    if (self.storeDatabase.documentState == UIDocumentStateNormal) {
        // already open and ready to use
        [self fetchStoreDataIntoDocument:self.storeDatabase];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
