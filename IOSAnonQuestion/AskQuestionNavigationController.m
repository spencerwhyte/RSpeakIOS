//
//  AskQuestionNavigationController.m
//  IOSAnonQuestion
//
//  Created by Spencer Whyte on 2014-03-15.
//  Copyright (c) 2014 Spencer Whyte. All rights reserved.
//

#import "AskQuestionNavigationController.h"
#import "AskQuestionTableViewController.h"

@interface AskQuestionNavigationController ()

@end

@implementation AskQuestionNavigationController

- (id)init
{
    AskQuestionTableViewController * askQuestionTableViewController = [[AskQuestionTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    self = [super initWithRootViewController:askQuestionTableViewController];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext{
    _managedObjectContext = managedObjectContext;
    ((AskQuestionTableViewController*)[self.viewControllers objectAtIndex:0]).managedObjectContext = self.managedObjectContext;
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
