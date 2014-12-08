//
//  Store.h
//  DeveloperTest
//
//  Created by Ilya Maier on 08.12.14.
//  Copyright (c) 2014 Mera. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Store.h"


@interface Store (Create)

+ (Store *)storeWithInfo:(NSDictionary*)storeDictionary inManagedObjectContext:(NSManagedObjectContext*)context;

+ (void)loadFromStoreInfoArray:(NSArray*)stores inManagedObjectContext:(NSManagedObjectContext*)context;

@end
