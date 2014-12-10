//
//  StoreTableViewCell.h
//  DeveloperTest
//
//  Created by Ilya Maier on 10.12.14.
//  Copyright (c) 2014 Mera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Store.h"

@interface StoreTableViewCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIImageView *logoImage;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (retain, nonatomic) IBOutlet UILabel *phoneLabel;
@property (retain, nonatomic) IBOutlet UILabel *addressLabel;


-(void)prepareCelltoDisplayWithStore:(Store *)store;

@end
