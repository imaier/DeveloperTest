//
//  StoreDetailsViewController.h
//  DeveloperTest
//
//  Created by Ilya Maier on 08.12.14.
//  Copyright (c) 2014 Mera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Store.h"

@interface StoreDetailsViewController : UIViewController

@property (nonatomic, strong) Store *store;

-(instancetype)initWithStore:(Store *)store;

@end
