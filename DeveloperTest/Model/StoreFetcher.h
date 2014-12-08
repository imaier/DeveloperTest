//
//  Store.h
//  DeveloperTest
//
//  Created by Ilya Maier on 08.12.14.
//  Copyright (c) 2014 Mera. All rights reserved.
//

#import <Foundation/Foundation.h>


// key to stores at top-level of Stores results
#define STORE_RESULTS_STORES @"stores"

//keys to values in a store dictionary
#define STORE_ADDRESS   @"address"
#define STORE_CITY      @"city"
#define STORE_LATITUDE  @"latitude"
#define STORE_LONGITUDE @"longitude"
#define STORE_NAME      @"name"
#define STORE_PHONE     @"phone"
#define STORE_STATE     @"state"
#define STORE_ID        @"storeID"
#define STORE_LOGO_URL  @"storeLogoURL"
#define STORE_ZIPCODE   @"zipcode"

@interface StoreFetcher : NSObject

+ (NSURL*)URLforStoreDB;

+ (NSArray*)fetchStores;


@end
