//
//  Settings.h
//  IOSAnonQuestion
//
//  Created by Spencer Whyte on 2014-05-11.
//  Copyright (c) 2014 Spencer Whyte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Keys.h"
#import <sys/utsname.h>

@interface Settings : NSObject

+(Settings*)sharedInstance;
-(NSInteger)defaultRecipientsCount;
-(void)setDefaultRecipientsCount:(NSInteger)recipients;
-(BOOL)didRegister;
-(void)setRegistered:(BOOL)registered;

-(NSString*)deviceID;
-(NSString*)deviceType;

@end
