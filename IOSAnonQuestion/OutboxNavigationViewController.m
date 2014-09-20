//
//  MessagesNavigationViewController.m
//  IOSAnonQuestion
//
//  Created by Spencer Whyte on 2014-03-15.
//  Copyright (c) 2014 Spencer Whyte. All rights reserved.
//

#import "OutboxNavigationViewController.h"
#import "OutboxTableViewController.h"

@interface OutboxNavigationViewController ()

@end

@implementation OutboxNavigationViewController

- (id)init
{
    OutboxTableViewController * messagesTableViewController = [[OutboxTableViewController alloc] init];
    self = [super initWithRootViewController:messagesTableViewController];
    if (self) {
        self.tabBarItem.title = @"Outbox";
        
        UIImage * inboxIcon = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"upload" ofType:@"png"]];
        
        self.tabBarItem.image = inboxIcon;

    }
    return self;
}

-(void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext{
    _managedObjectContext = managedObjectContext;
    ((OutboxTableViewController*)[self.viewControllers objectAtIndex:0]).managedObjectContext = self.managedObjectContext;
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
