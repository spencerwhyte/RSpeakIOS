//
//  Cloud.h
//  IOSAnonQuestion
//
//  Created by Spencer Whyte on 2014-03-15.
//  Copyright (c) 2014 Spencer Whyte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Question.h"
#import "AFNetworking.h"
#import "DeviceInformation.h"
#import "Thread.h"
#import "Message.h"
#import "Settings.h"
#import "NSString+Date.h"

@interface Cloud : NSObject<NSFetchedResultsControllerDelegate>

@property NSString * baseURL;
@property NSString * protocolVersion;
@property (nonatomic) NSManagedObjectContext * managedObjectContext;
@property NSFetchedResultsController * messageFetchedResultsController;
@property NSFetchedResultsController * questionFetchedResultsController;
@property BOOL wasUnreachable;

@property (nonatomic) int totalRequestsInProgress;


-(void)synchronize;

+(Cloud*)sharedInstance;





@end
