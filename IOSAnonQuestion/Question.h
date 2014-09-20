//
//  Question.h
//  IOSAnonQuestion
//
//  Created by Spencer Whyte on 2014-05-19.
//  Copyright (c) 2014 Spencer Whyte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Thread;

@interface Question : NSManagedObject
@property (nonatomic, retain) NSString * questionID;
@property (nonatomic, retain) NSString * senderDeviceID;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * dateOfCreation;
@property (nonatomic, retain) NSSet *threads;
@property (nonatomic) BOOL hasBeenPostedToServer;
@property (nonatomic) int maxNumberOfThreads;
@end

@interface Question (CoreDataGeneratedAccessors)

- (void)addThreadsObject:(Thread *)value;
- (void)removeThreadsObject:(Thread *)value;
- (void)addThreads:(NSSet *)values;
- (void)removeThreads:(NSSet *)values;

@end
