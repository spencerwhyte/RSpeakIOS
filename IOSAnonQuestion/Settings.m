//
//  Settings.m
//  IOSAnonQuestion
//
//  Created by Spencer Whyte on 2014-05-11.
//  Copyright (c) 2014 Spencer Whyte. All rights reserved.
//

#import "Settings.h"


@implementation Settings

static Settings * sharedSettings = nil;

+(Settings *)sharedInstance{
    if(sharedSettings == nil){
        sharedSettings = [[Settings alloc] init];
    }
    return sharedSettings;
}

-(void)ensureDefaults{

    if([self defaultRecipientsCount] == 0){ // It has not yet been initialized
        [self setDefaultRecipientsCount:1]; // Set it to the default
    }
    
    
}

-(id)init{
    if(self = [super init]){
        [self ensureDefaults];
    }
    return self;
}

-(NSInteger)defaultRecipientsCount{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    return [defaults integerForKey:keyDefaultRecipientsCount];
}

-(void)setDefaultRecipientsCount:(NSInteger)recipients{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:recipients forKey:keyDefaultRecipientsCount];
    [defaults synchronize];
}

-(BOOL)didRegister{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:keyDidRegister];
}

-(void)setRegistered:(BOOL)registered{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:registered forKey:keyDidRegister];
    [defaults synchronize];
}


-(BOOL)didRegisterForPushNotifications{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:keyDidRegisterForPushNotifications];
}

-(void)setRegisteredForPushNotifications:(BOOL)registeredForPushNotifications{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:registeredForPushNotifications forKey:keyDidRegisterForPushNotifications];
    [defaults synchronize];
}


-(BOOL)hasAquiredPushNotificationID{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    return ([defaults stringForKey:keyPushNotificationID]  != nil);
}

-(void)setPushNotificationID:(NSString*)newPushNotificationID{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:newPushNotificationID forKey:keyPushNotificationID];
    [defaults synchronize];
}

-(NSString*)pushNotificationID{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    return [defaults stringForKey:keyPushNotificationID];
}

-(NSString *)deviceID{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}


-(NSString *)deviceType{
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

@end
