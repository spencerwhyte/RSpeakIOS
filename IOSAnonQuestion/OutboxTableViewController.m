//
//  MessagesTableViewController.m
//  IOSAnonQuestion
//
//  Created by Spencer Whyte on 2014-03-15.
//  Copyright (c) 2014 Spencer Whyte. All rights reserved.
//

#import "OutboxTableViewController.h"




@implementation OutboxTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.navigationItem.title = @"Outbox";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(askQuestion:)];
        
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
    NSPredicate * outboxOnly = [NSPredicate predicateWithFormat:@"senderDeviceID == %@", [DeviceInformation sharedInstance].deviceID];
    return outboxOnly;
}


#pragma mark Button press actions


-(void)askQuestion:(id)sender{

    AskQuestionNavigationController * askQuestionNavigationController = [[AskQuestionNavigationController alloc] init];
    askQuestionNavigationController.managedObjectContext = self.managedObjectContext;
    [self presentViewController:askQuestionNavigationController animated:YES completion:^(void){
        
    }];
}




@end
