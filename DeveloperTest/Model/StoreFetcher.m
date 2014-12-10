//
//  StoreFetcher.m
//  DeveloperTest
//
//  Created by Ilya Maier on 08.12.14.
//  Copyright (c) 2014 Mera. All rights reserved.
//

#import "StoreFetcher.h"
#import <UIKit/UIKit.h>
#import "LocalizedStrings.h"

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
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:STORE_FETCHER_DOWNLOAD_ERROR_TITLE
                                                           message:STORE_FETCHER_DOWNLOAD_ERROR_DISCRIPTION
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [theAlert show];
        [theAlert release];
        return nil;
    }
    @finally {
        NSDictionary *propertyList = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:NULL];
        
        return [propertyList valueForKeyPath:STORE_RESULTS_STORES];
    }
}

@end
