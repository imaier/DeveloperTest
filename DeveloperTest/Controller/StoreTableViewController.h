//
//  TableViewController.h
//  DeveloperTest
//
//  Created by Ilya Maier on 08.12.14.
//  Copyright (c) 2014 Mera. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StoreTableViewController : UITableViewController

@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;

-(instancetype)init;

@end
