//
//  CellViewController.h
//  DeveloperTest
//
//  Created by Ilya Maier on 08.12.14.
//  Copyright (c) 2014 Mera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreTableViewCell.h"

@interface StoreCellViewController : UIViewController

@property (retain, nonatomic) IBOutlet StoreTableViewCell *cell;

-(instancetype)init;

@end
