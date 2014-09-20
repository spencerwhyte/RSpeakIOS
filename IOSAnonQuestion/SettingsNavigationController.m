//
//  SettingsNavigationController.m
//  IOSAnonQuestion
//
//  Created by Spencer Whyte on 2014-03-15.
//  Copyright (c) 2014 Spencer Whyte. All rights reserved.
//

#import "SettingsNavigationController.h"
#import "SettingsTableViewController.h"

@interface SettingsNavigationController ()

@end

@implementation SettingsNavigationController

- (id)init
{
    SettingsTableViewController * settingsTableViewController = [[SettingsTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    self = [super initWithRootViewController:settingsTableViewController];
    if (self) {
        self.tabBarItem.title = @"Settings";
        
        self.tabBarItem.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"settings" ofType:@"png"]];
        
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
