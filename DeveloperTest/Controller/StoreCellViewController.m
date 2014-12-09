//
//  CellViewController.m
//  DeveloperTest
//
//  Created by Ilya Maier on 08.12.14.
//  Copyright (c) 2014 Mera. All rights reserved.
//

#import "StoreCellViewController.h"

#define CELL_VIEW_NIB @"StoreCellViewController"

@interface StoreCellViewController ()

@end

@implementation StoreCellViewController

-(instancetype)init
{
    self = [super initWithNibName:CELL_VIEW_NIB bundle:nil];
    
    return self;
}

- (void)dealloc {
    [_cell release];
    [super dealloc];
}
@end
