//
//  ThreadsTableViewController.h
//  IOSAnonQuestion
//
//  Created by Spencer Whyte on 2014-05-22.
//  Copyright (c) 2014 Spencer Whyte. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

#import "Thread.h"

#import "Message.h"

#import "MessagesViewController.h"

#import "Question.h"

@interface ThreadsTableViewController : UITableViewController<NSFetchedResultsControllerDelegate>

@property Question * question;
@property NSManagedObjectContext * managedObjectContext;

@end
