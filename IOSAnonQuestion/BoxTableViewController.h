//
//  BoxTableViewController.h
//  IOSAnonQuestion
//
//  Created by Spencer Whyte on 2014-05-22.
//  Copyright (c) 2014 Spencer Whyte. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

#import "AskQuestionNavigationController.h"

#import "CurrencyBarButtonItem.h"

#import "QuestionTableViewCell.h"

#import "Question.h"

#import "ThreadsTableViewController.h"

#import "DeviceInformation.h"

#import "BoxTableViewController.h"

#import "Thread.h"

#import "Message.h"

#import "MessagesViewController.h"

#import "Cloud.h"

@interface BoxTableViewController : UITableViewController<NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
