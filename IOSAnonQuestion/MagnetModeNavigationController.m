//
//  MagnetModeNavigationController.m
//  IOSAnonQuestion
//
//  Created by Spencer Whyte on 2014-03-15.
//  Copyright (c) 2014 Spencer Whyte. All rights reserved.
//

#import "MagnetModeNavigationController.h"
#import "MagnetModeTableViewController.h"

@interface MagnetModeNavigationController ()

@end

@implementation MagnetModeNavigationController

- (id)init{
    MagnetModeTableViewController * magnetModeTableViewController = [[MagnetModeTableViewController alloc] init];
    self = [super initWithRootViewController:magnetModeTableViewController];
    if (self) {
        self.tabBarItem.title = @"Magnet Mode";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
