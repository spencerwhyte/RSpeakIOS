//
//  AskQuestionTableViewController.h
//  IOSAnonQuestion
//
//  Created by Spencer Whyte on 2014-03-15.
//  Copyright (c) 2014 Spencer Whyte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceInformation.h"
#import "LimitedTextView.h"

@interface AskQuestionTableViewController : UITableViewController
@property NSManagedObjectContext * managedObjectContext;
@property LimitedTextView * questionTextField;
@property int selectedIndex;



@end
