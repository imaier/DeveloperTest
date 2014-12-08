//
//  DetailsViewController.m
//  DeveloperTest
//
//  Created by Ilya Maier on 08.12.14.
//  Copyright (c) 2014 Mera. All rights reserved.
//

#import "DetailsViewController.h"
#import "ImageCache.h"

@interface DetailsViewController ()
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (retain, nonatomic) IBOutlet UIImageView *logoImage;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *phoneLabel;
@property (retain, nonatomic) IBOutlet UILabel *addressLabel;
@property (retain, nonatomic) IBOutlet UILabel *cityLabel;
@property (retain, nonatomic) IBOutlet UILabel *stateLabel;
@property (retain, nonatomic) IBOutlet UILabel *zipcodeLabel;
@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)fillData
{
    self.nameLabel.text     = self.store.name;
    self.phoneLabel.text    = self.store.phone;
    self.addressLabel.text  = self.store.address;
    self.cityLabel.text     = self.store.city;
    self.stateLabel.text    = self.store.state;
    self.zipcodeLabel.text  = self.store.zipcode;
    
    self.logoImage.image = nil;
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    [self.activityIndicator hidesWhenStopped];
    
    [[ImageCache sharedInstance] loadImageAsyncWithImageURL:self.store.storeLogoURL andCompletionBlock:^(UIImage *image, NSString *imageURL) {
        dispatch_async(dispatch_get_main_queue(),^{
            if ([imageURL isEqual:self.store.storeLogoURL]) {
                self.logoImage.image = image;
                [self.activityIndicator stopAnimating];
                self.activityIndicator.hidden = YES;
            }
        });
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self fillData];
}

-(void)setStore:(Store *)store
{
    _store = store;
    if (self.isViewLoaded && self.view.window) {
        //view is visible
        [self fillData];
    }
}

@end
