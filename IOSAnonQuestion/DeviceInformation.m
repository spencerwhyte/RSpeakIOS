//
//  DeviceInformation.m
//  IOSAnonQuestion
//
//  Created by Spencer Whyte on 2014-05-11.
//  Copyright (c) 2014 Spencer Whyte. All rights reserved.
//

#import "DeviceInformation.h"

@implementation DeviceInformation

-(id)init{
    if(self = [super init]){
        self.tokenCount = -1;
        self.deviceID = @"spencerwhyte";
    }
    return self;
}

+(DeviceInformation*)sharedInstance{
    static DeviceInformation * deviceInformation;
    if(deviceInformation == nil){
        deviceInformation = [[DeviceInformation alloc] init];
    }
    return deviceInformation;
}


@end
