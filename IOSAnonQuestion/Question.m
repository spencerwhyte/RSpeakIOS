//
//  Question.m
//  IOSAnonQuestion
//
//  Created by Spencer Whyte on 2014-05-19.
//  Copyright (c) 2014 Spencer Whyte. All rights reserved.
//

#import "Question.h"
#import "Thread.h"


@implementation Question

@dynamic senderDeviceID;
@dynamic content;
@dynamic dateOfCreation;
@dynamic threads;
@dynamic questionID;
@dynamic hasBeenPostedToServer;
@dynamic maxNumberOfThreads;


-(BOOL)isAddressedSoleyToMe{
    NSString * responder = [[self.threads anyObject] responderDeviceID];
    NSString * mine = [[Settings sharedInstance] deviceID];
    NSLog(@"%@ V %@", responder, mine);
    return [responder isEqualToString: mine];
}

@end
