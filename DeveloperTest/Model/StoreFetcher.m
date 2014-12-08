//
//  StoreFetcher.m
//  StoreViewer
//
//  Created by Ilya Maier on 22.10.14.
//  Copyright (c) 2014 Mera. All rights reserved.
//

#import "StoreFetcher.h"
#import <UIKit/UIKit.h>

@implementation StoreFetcher

+ (NSURL*)URLforStoreDB
{
    return [NSURL URLWithString:@"http://strong-earth-32.heroku.com/stores.aspx"];
}


+ (NSArray*)fetchStores
{
    NSURL *url = [StoreFetcher URLforStoreDB];
    NSData *jsonData = nil;
    @try {
        jsonData = [NSData dataWithContentsOfURL:url];
    }
    @catch (NSException *exception) {
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Dowload Error"
                                                           message:@"Server data is not available now. Cached data may be not latest."
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [theAlert show];
        return nil;
    }
    @finally {
        NSDictionary *propertyList = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:NULL];
        
        return [propertyList valueForKeyPath:STORE_RESULTS_STORES];
    }
}

@end
