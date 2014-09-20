//
//  DeviceInformation.h
//  IOSAnonQuestion
//
//  Created by Spencer Whyte on 2014-05-11.
//  Copyright (c) 2014 Spencer Whyte. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceInformation : NSObject
@property NSDate * lastUpdated; // The last date we asked the server for the information
@property NSInteger tokenCount;
@property NSString * deviceID;

+(DeviceInformation*)sharedInstance;

@end
