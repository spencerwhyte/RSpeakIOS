//
//  Thread.m
//  IOSAnonQuestion
//
//  Created by Spencer Whyte on 2014-05-19.
//  Copyright (c) 2014 Spencer Whyte. All rights reserved.
//

#import "Thread.h"
#import "Message.h"
#import "Question.h"


@implementation Thread

@dynamic responderDeviceID;
@dynamic dateOfCreation;
@dynamic messages;
@dynamic question;
@dynamic threadID;

-(Message*)mostRecentMessage{
    Message * mostRecent = nil;
    for(Message * m in self.messages){
        if(mostRecent == nil || m.dateOfCreation.timeIntervalSince1970 > mostRecent.dateOfCreation.timeIntervalSince1970){
            mostRecent = m;
        }
    }
    return mostRecent;
}

@end
