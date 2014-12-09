//
//  StoreTableViewCell.m
//  DeveloperTest
//
//  Created by Ilya Maier on 08.12.14.
//  Copyright (c) 2014 Mera. All rights reserved.
//

#import "StoreTableViewCell.h"

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

@end
