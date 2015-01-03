//
//  Thread.h
//  IOSAnonQuestion
//
//  Created by Spencer Whyte on 2014-05-19.
//  Copyright (c) 2014 Spencer Whyte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Message, Question;

@interface Thread : NSManagedObject
@property (nonatomic) int64_t threadID;
@property (nonatomic, retain) NSString * responderDeviceID;
@property (nonatomic, retain) NSDate * dateOfCreation;
@property (nonatomic, retain) NSSet *messages;
@property (nonatomic, retain) Question *question;
@end

@interface Thread (CoreDataGeneratedAccessors)

- (void)addMessagesObject:(Message *)value;
- (void)removeMessagesObject:(Message *)value;
- (void)addMessages:(NSSet *)values;
- (void)removeMessages:(NSSet *)values;


-(Message*)mostRecentMessage;
@end
