//
//  InboxNavigationViewController.m
//  IOSAnonQuestion
//
//  Created by Spencer Whyte on 2014-03-15.
//  Copyright (c) 2014 Spencer Whyte. All rights reserved.
//

#import "InboxNavigationViewController.h"
#import "InboxTableViewController.h"
@interface InboxNavigationViewController ()

@end

@implementation InboxNavigationViewController

- (id)init
{
    InboxTableViewController * inboxTableViewController = [[InboxTableViewController alloc] init];
    self = [super initWithRootViewController:inboxTableViewController];
    if (self) {
        self.tabBarItem.title = @"Inbox";
        self.tabBarItem.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"download" ofType:@"png"]];
        
    }
    return self;
}

-(void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext{
    _managedObjectContext = managedObjectContext;
    ((InboxTableViewController*)[self.viewControllers objectAtIndex:0]).managedObjectContext = self.managedObjectContext;
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
