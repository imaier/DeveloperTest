//
//  Store+Create.m
//  StoreViewer
//
//  Created by Ilya Maier on 29.10.14.
//  Copyright (c) 2014 Mera. All rights reserved.
//

#import "Store+Create.h"
#import "StoreFetcher.h"

@implementation Store (Create)

+ (Store *)storeWithInfo:(NSDictionary*)storeDictionary inManagedObjectContext:(NSManagedObjectContext*)context
{
    Store *store = nil;
    
    NSString *storeID = storeDictionary[STORE_ID];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Store"];
    request.predicate = [NSPredicate predicateWithFormat:@"storeID = %@", storeID];
    
    NSError *errror;
    NSArray *matches = [context executeFetchRequest:request error:&errror];
    
    if (!matches || errror || [matches count] > 1) {
        //handle error
    } else if ([matches count]) { // record found
        store = [matches firstObject];
    } else { // does not exist  yet 
        store = [NSEntityDescription insertNewObjectForEntityForName:@"Store" inManagedObjectContext:context];
    }
    store.name = storeDictionary[STORE_NAME];
    store.phone = storeDictionary[STORE_PHONE];
    store.storeID = storeID;
    store.address = storeDictionary[STORE_ADDRESS];
    store.city = storeDictionary[STORE_CITY];
    store.longitude = [NSNumber numberWithDouble:[((NSString*)storeDictionary[STORE_LONGITUDE]) doubleValue]];
    store.latitude = [NSNumber numberWithDouble:[((NSString*)storeDictionary[STORE_LATITUDE]) doubleValue]];
    store.state = storeDictionary[STORE_STATE];
    store.storeLogoURL = storeDictionary[STORE_LOGO_URL];
    store.zipcode = storeDictionary[STORE_ZIPCODE];
    
    return store;
}

+ (void)loadFromStoreInfoArray:(NSArray*)stores inManagedObjectContext:(NSManagedObjectContext*)context
{
    for (NSDictionary *storeInfo in stores) {
        [Store storeWithInfo: storeInfo inManagedObjectContext:context];
    }
}



@end
