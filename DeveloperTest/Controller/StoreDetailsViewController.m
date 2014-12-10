//
//  StoreDetailsViewController.m
//  DeveloperTest
//
//  Created by Ilya Maier on 08.12.14.
//  Copyright (c) 2014 Mera. All rights reserved.
//

#import "StoreDetailsViewController.h"
#import "ImageFetcher.h"

#define DETAILS_VIEW_NIB @"StoreDetailsViewController"

@interface StoreDetailsViewController ()
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (retain, nonatomic) IBOutlet UIImageView *logoImage;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *phoneLabel;
@property (retain, nonatomic) IBOutlet UILabel *addressLabel;
@property (retain, nonatomic) IBOutlet UILabel *cityLabel;
@property (retain, nonatomic) IBOutlet UILabel *stateLabel;
@property (retain, nonatomic) IBOutlet UILabel *zipcodeLabel;
@end

@implementation StoreDetailsViewController

-(instancetype)initWithStore:(Store *)store
{
    self = [super initWithNibName:DETAILS_VIEW_NIB bundle:nil];

    if (self) {
        self.store = store;
    }
    
    return self;
}

- (void)fillData
{
    self.title              = self.store.name;
    
    self.nameLabel.text     = self.store.name;
    self.phoneLabel.text    = self.store.phone;
    self.addressLabel.text  = self.store.address;
    self.cityLabel.text     = self.store.city;
    self.stateLabel.text    = self.store.state;
    self.zipcodeLabel.text  = self.store.zipcode;
    
    self.logoImage.image = nil;
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    
    [[ImageFetcher sharedInstance] loadImageAsyncWithImageURL:self.store.storeLogoURL andCompletionBlock:^(UIImage *image, NSString *imageURL) {
        dispatch_async(dispatch_get_main_queue(),^{
            if ([imageURL isEqual:self.store.storeLogoURL]) {
                self.logoImage.image = image;
                [self.activityIndicator stopAnimating];
                self.activityIndicator.hidden = YES;
            }
        });
    }];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self fillData];
}

-(void)setStore:(Store *)store
{
    [store retain];
    [_store release];
    _store = store;
    if (self.isViewLoaded && self.view.window) {
        //view is visible
        [self fillData];
    }
}

-(void)dealloc
{
    [_store release];
    [_activityIndicator release];
    [_logoImage release];
    [_nameLabel release];
    [_phoneLabel release];
    [_addressLabel release];
    [_cityLabel release];
    [_stateLabel release];
    [_zipcodeLabel release];
    [super dealloc];
}

@end
