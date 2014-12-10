//
//  StoreTableViewCell.m
//  DeveloperTest
//
//  Created by Ilya Maier on 10.12.14.
//  Copyright (c) 2014 Mera. All rights reserved.
//

#import "StoreTableViewCell.h"
#import "ImageFetcher.h"

@interface StoreTableViewCell ()
@property (retain, nonatomic) NSURL *logoURL;
@end

@implementation StoreTableViewCell

-(void)dealloc
{
    [_logoImage release];
    [_activityIndicator release];
    [_phoneLabel release];
    [_addressLabel release];
    [_logoURL release];
    [super dealloc];
}

-(void)prepareCelltoDisplayWithStore:(Store *)store
{
    self.phoneLabel.text = store.phone;
    self.addressLabel.text = store.address;
    
    self.logoURL = [NSURL URLWithString:store.storeLogoURL];
    [NSString stringWithString:store.storeLogoURL];
    self.logoImage.image = nil;
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    
    [[ImageFetcher sharedInstance] loadImageAsyncWithImageURL:store.storeLogoURL andCompletionBlock:^(UIImage *image, NSString *imageURL) {
        dispatch_async(dispatch_get_main_queue(),^{
            if ([self.logoURL isEqual:[NSURL URLWithString:imageURL]]) {
                self.logoImage.image = image;
                [self.activityIndicator stopAnimating];
                self.activityIndicator.hidden = YES;
            }
        });
    }];
}

@end
