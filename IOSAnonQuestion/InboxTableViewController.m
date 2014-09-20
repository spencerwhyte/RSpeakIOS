//
//  InboxTableViewController.m
//  IOSAnonQuestion
//
//  Created by Spencer Whyte on 2014-03-15.
//  Copyright (c) 2014 Spencer Whyte. All rights reserved.
//

#import "InboxTableViewController.h"
#import "CurrencyBarButtonItem.h"

@interface InboxTableViewController ()

@end

@implementation InboxTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.navigationItem.title = @"Inbox";
        self.navigationItem.leftBarButtonItem = [[CurrencyBarButtonItem alloc] initWithCustomView:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSPredicate*)predicate{
    NSPredicate * inboxOnly = [NSPredicate predicateWithFormat:@"senderDeviceID != %@", [DeviceInformation sharedInstance].deviceID];
    return inboxOnly;
}

@end
