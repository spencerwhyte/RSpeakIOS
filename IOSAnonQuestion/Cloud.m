//
//  Cloud.m
//  IOSAnonQuestion
//
//  Created by Spencer Whyte on 2014-03-15.
//  Copyright (c) 2014 Spencer Whyte. All rights reserved.
//

#import "Cloud.h"


static Cloud * sharedInstance = nil;

@implementation Cloud
/*
 Singleton support
 */
+(Cloud *)sharedInstance{
    if(sharedInstance == nil){
        sharedInstance = [[Cloud alloc] init];
    }
    return sharedInstance;
}

-(id)init{
    if(self = [super init]){
        #if TARGET_IPHONE_SIMULATOR
            self.baseURL = @"127.0.0.1:8000";
        #elif TARGET_OS_IPHONE
            self.baseURL = @"169.254.2.225:8000";
        #endif
        
        self.protocolVersion = @"v1";
        
        self.wasUnreachable = YES;
        
        self.totalRequestsInProgress = 0;
        
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            
            switch (status) {
                case AFNetworkReachabilityStatusNotReachable:
                    NSLog(@"Unreachable");
                    self.wasUnreachable = YES;
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    NSLog(@"WIFI");
                    // Just gained connectivity possibly
                    if(self.wasUnreachable){
                        [self regainedConnectivity];
                        self.wasUnreachable = NO;
                    }
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    NSLog(@"3G");
                    
                    if(self.wasUnreachable){
                        [self regainedConnectivity];
                        self.wasUnreachable = NO;
                    }

                    break;
                default:
                    NSLog(@"Unkown network status");
                    
                    break;
                    
                    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
            }
        }];
        
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        
        
    }
    return self;
}

-(void)regainedConnectivity{
    [self synchronize];
}


-(void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext{
    _managedObjectContext = managedObjectContext;
    // Set up our fetched results controller to give us the messages that have not been posted yet
    
    // Keep an eye on the messages
    [self createMessageFetchedResultsController];
    // Keep an eye on the questions
    [self createQuestionFetchedResultsController];
    
}

-(void)createQuestionFetchedResultsController{
    
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Question" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate * p =[NSPredicate predicateWithFormat:@"hasBeenPostedToServer == NO"];
    [fetchRequest setPredicate:p];
    
    /// Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateOfCreation" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    aFetchedResultsController.delegate = self;
    self.questionFetchedResultsController = aFetchedResultsController;
    
    NSError * error;
    [self.questionFetchedResultsController performFetch:&error];
    
}


-(void)createMessageFetchedResultsController{
    
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Message" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate * p =[NSPredicate predicateWithFormat:@"hasBeenPostedToServer == NO"];
    [fetchRequest setPredicate:p];
    
    /// Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateOfCreation" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    aFetchedResultsController.delegate = self;
    self.messageFetchedResultsController = aFetchedResultsController;
    
    NSError * error;
    [self.messageFetchedResultsController performFetch:&error];
    
    
    //NSLog(@"EXECUTE: %@", res);
    // This is the reason Why
}



// Begin content change
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    NSLog(@"controllerWillChangeContent");
}

/*
 Changed a particular object, who cares!
 */
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    NSLog(@"didChangeObject");
}


// Change a particular value
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
   // This never seems to happen
    NSLog(@"This is a rare occurance! Look this up in the code!");
}

// End content change
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    NSLog(@"controllerDidChangeContent");
    [self synchronize];
}

// Upload all of the messages that we have sent
-(void)pushMessages{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString * deviceID = [[Settings sharedInstance] deviceID];

    NSString * url = [self apiURLWithPath:@"/response/"];
    
    NSArray * messages = self.messageFetchedResultsController.fetchedObjects;
    
    for(Message * m in messages){
        
        self.totalRequestsInProgress++; // We need to keep track of all of these upload operations
    
        NSDictionary *parameters = @{@"device_id": deviceID, @"content":m.content, @"thread_id": [NSNumber numberWithLongLong: m.thread.threadID ]};
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation * operation, id responseObject){
            // Success
            NSError * error;
            NSDictionary* json = [NSJSONSerialization
                                  JSONObjectWithData:responseObject
                                  options:NSJSONReadingMutableContainers
                                  error:&error];
            
            NSLog(@"MEssages push response JSON: %@", json);
            
            m.hasBeenPostedToServer = YES;
            [self.managedObjectContext save:&error];
            
            self.totalRequestsInProgress--; // We need to keep track of all of these upload operations
            
        }
              failure:^(AFHTTPRequestOperation * operation, NSError * error){
                  NSLog(@"Failed to respond to question: %@", error);
                    self.totalRequestsInProgress--; // We need to keep track of all of these upload operations
                  
              }
         ];
        
        
        
    }
}


-(NSString*)apiURL{
    return [NSString stringWithFormat:@"http://%@/%@", self.baseURL, self.protocolVersion];
}

-(NSString*)apiURLWithPath:(NSString *)path{
    return [[self apiURL] stringByAppendingString:path];
}

/**
 Tells the server about our existance
 **/
-(void)registerDevice{
    NSLog(@"Register Device");
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString * url = [self apiURLWithPath:@"/device/"];
    

    NSString * deviceID = [[Settings sharedInstance] deviceID];
    NSString * deviceType = [[Settings sharedInstance] deviceType];
    
    NSDictionary * parameters = @{@"device_id":deviceID,@"model":deviceType, @"os":@"IOS"};
    
    self.totalRequestsInProgress++;
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Just successfully registered the device with ID: %@ and type: %@", deviceID, deviceType);
        [[Settings sharedInstance] setRegistered:YES];
        
        self.totalRequestsInProgress--;
        
        [self synchronize]; // Get back to whatever else we were going to do
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error registering: %@", error);
        self.totalRequestsInProgress--;
    }];
}

-(void)registerForPushNotifications{
    NSLog(@"Registering For Push Notifications");
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString * url = [self apiURLWithPath:@"/register/push_notification_id/"];
    
    
    NSString * deviceID = [[Settings sharedInstance] deviceID];
    
    
    NSString * pushNotificationID = [[Settings sharedInstance] pushNotificationID];
    
    
    NSLog(@"Device ID: %@", deviceID);
    NSLog(@"Push Notification ID: %@", pushNotificationID);
    
    NSDictionary * parameters = @{@"device_id":deviceID,@"push_notification_id":pushNotificationID};
    
    self.totalRequestsInProgress++;
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Just successfully registered the device apple: %@ and pushid: %@", deviceID, pushNotificationID);
        [[Settings sharedInstance] setRegisteredForPushNotifications:YES];
        
        [self synchronize]; // Go back to whatever else we were going to use
        
        self.totalRequestsInProgress--;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error registering: %@", error);
        self.totalRequestsInProgress--;
    }];
    
    
}


/*
    Asks all of the questions that are waiting to go out
*/

-(void)pushQuestions{
    NSLog(@"Pushing questions");
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString * deviceID = [[Settings sharedInstance] deviceID];

    NSString * url = [self apiURLWithPath:@"/question/"];
    
    for(Question * q in self.questionFetchedResultsController.fetchedObjects){
        self.totalRequestsInProgress++;
    
        NSDictionary *parameters = @{@"device_id": deviceID, @"content":q.content, @"max_new_threads" : [NSNumber numberWithInt:q.maxNumberOfThreads]};
        
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation * operation, id responseObject){
            // Success
            NSError * error;
            NSDictionary* json = [NSJSONSerialization
                                  JSONObjectWithData:responseObject
                                  options:NSJSONReadingMutableContainers
                                  error:&error];
            
            NSLog(@"%@", json);
            
            // Parse the response
            int64_t questionID = [[json valueForKey:@"question_id"] longLongValue];
            q.questionID = questionID;
            
            NSArray * threads = [json valueForKey:@"threads"];
            
            for(NSDictionary * currentThread in threads){
                NSEntityDescription * description = [NSEntityDescription entityForName:@"Thread" inManagedObjectContext:q.managedObjectContext];
                Thread * t = [[Thread alloc] initWithEntity:description insertIntoManagedObjectContext:q.managedObjectContext];
                t.responderDeviceID = [currentThread valueForKey:@"responder_device_id"];
                t.threadID = [[currentThread valueForKey:@"thread_id"] integerValue];
                t.dateOfCreation = [NSDate date];
                t.question = q;
            }
            
            q.hasBeenPostedToServer=YES;
            [self.managedObjectContext save:&error];
            
            self.totalRequestsInProgress--;
        } failure:^(AFHTTPRequestOperation * operation, NSError * error){
            NSLog(@"We were not able to ask our question: %@", error);
            
            self.totalRequestsInProgress--;
        }];
    }
}


/*
 Asks the server what they know about us
 */
-(void)retrieveCreditScore{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"synchronizeDeviceInformationDidBegin" object:nil];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString * deviceID = [[Settings sharedInstance] deviceID];
    NSDictionary *parameters = @{@"device_id": deviceID};
    NSString * url = [self apiURLWithPath:@"/account/"];
    
    self.totalRequestsInProgress++;
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation * operation, id responseObject){
        // Success
        NSError * error;
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:responseObject
                              options:NSJSONReadingMutableContainers
                              error:&error];
        
        NSLog(@"JSON: %@", json);
        [DeviceInformation sharedInstance].tokenCount = [[json valueForKey:@"credit_points"] integerValue];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"synchronizeDeviceInformationDidSucceed" object:nil];
        
        self.totalRequestsInProgress--;
    }
         failure:^(AFHTTPRequestOperation * operation, NSError * error){
             NSLog(@"We did not find out our credit score: %@", error);
             [[NSNotificationCenter defaultCenter] postNotificationName:@"synchronizeDeviceInformationDidFail" object:nil];
             self.totalRequestsInProgress--;
         }
     ];
}

-(void)retrieveUpdates{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString * deviceID = [[Settings sharedInstance] deviceID];
    NSDictionary *parameters = @{@"device_id": deviceID};
    NSString * url = [self apiURLWithPath:@"/update/"];
    
    NSLog(@"Device ID: %@", deviceID);
    NSLog(@"Parameters: %@", parameters);
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation * operation, id responseObject){
        // Success
        NSError * error;
        
        NSString * a = operation.responseString;
        
        NSLog(@"SERVER RESPONSE: %@", a);
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:responseObject
                              options:NSJSONReadingMutableContainers
                              error:&error];
        
        
        NSArray * questionUpdates = [json valueForKey:@"question_updates"];
        NSLog(@"Question Updates %@", questionUpdates);
        if(![questionUpdates isEqual:[NSNull null]]){
            for(NSDictionary * update in questionUpdates){
                
                NSString * content = [update valueForKey:@"content"];
                NSString * time = [update valueForKey:@"time_posted"];
                int64_t questionID = [[update valueForKey:@"pk"] longLongValue];
                NSString * askerDeviceID = [update valueForKey:@"asker_device"];
                
                NSEntityDescription * questionEntityDescription = [NSEntityDescription entityForName:@"Question" inManagedObjectContext:self.managedObjectContext];
                Question * question = [[Question alloc] initWithEntity:questionEntityDescription insertIntoManagedObjectContext:self.managedObjectContext];
                
                question.content = content;
                question.dateOfCreation = [time date];
                question.senderDeviceID = askerDeviceID;
                question.questionID = questionID;
                question.hasBeenPostedToServer = YES;
                
                NSError * error;
                [self.managedObjectContext save:&error];
                
            }
        }
        
        NSArray * threadUpdates = [json valueForKey:@"thread_updates"];
        NSLog(@"Thread Updates: %@", threadUpdates);
        if(![responseObject isEqual:[NSNull null]]){
            for(NSDictionary * update in threadUpdates){
                
                
                int64_t thread_id = [[update valueForKey:@"pk"] longLongValue];
                NSString * answerer_device = [update valueForKey:@"answerer_device"];
                int64_t question_id = [[update valueForKey:@"question_id"] longLongValue];
                
                // Look up the question by id
                
                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                NSEntityDescription *entity = [NSEntityDescription entityForName:@"Question" inManagedObjectContext:self.managedObjectContext];
                [fetchRequest setEntity:entity];
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(questionID = %lld)", question_id];
                [fetchRequest setPredicate:predicate];
                
                NSArray * results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
                Question  * question = [results objectAtIndex:0];
                
                
                
                NSEntityDescription * threadEntityDescription = [NSEntityDescription entityForName:@"Thread" inManagedObjectContext:self.managedObjectContext];
                Thread  * thread = [[Thread alloc] initWithEntity:threadEntityDescription insertIntoManagedObjectContext:self.managedObjectContext];
                
                thread.threadID = thread_id;
                thread.question = question;
                thread.responderDeviceID = answerer_device;
                
                [question addThreadsObject:thread];
            
            
                NSError * error;
                [self.managedObjectContext save:&error];
                
            }
        }
        
        
        
        NSArray * responseUpdates = [json valueForKey:@"response_updates"];
        NSLog(@"Response Updates: %@", responseUpdates);
        if(![responseUpdates isEqual:[NSNull null]]){
        
            for(NSDictionary * response in responseUpdates){
                
                int64_t threadID = [[response valueForKey:@"thread"] longLongValue];
                
                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                NSEntityDescription *entity = [NSEntityDescription entityForName:@"Thread" inManagedObjectContext:self.managedObjectContext];
                [fetchRequest setEntity:entity];
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(threadID = %lld)", threadID];
                [fetchRequest setPredicate:predicate];
                
                
                NSArray * results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
                Thread * thread = [results objectAtIndex:0];
                
                NSEntityDescription * messageEntityDescription = [NSEntityDescription entityForName:@"Message" inManagedObjectContext:self.managedObjectContext];
                
                Message * message = [[Message alloc] initWithEntity:messageEntityDescription insertIntoManagedObjectContext:self.managedObjectContext];
                message.content = [response valueForKey:@"response_content"];
                message.dateOfCreation = [[response valueForKey:@"time_posted"] date];
                message.thread = thread;
                message.senderDeviceID = [response valueForKey:@"responder_device"];
                
                NSError * error;
                [self.managedObjectContext save:&error];
                
                
            }
            
        }
        
        NSLog(@"%@", json);
    }
          failure:^(AFHTTPRequestOperation * operation, NSError * error){
              NSLog(@"We were not able to retreive updates: %@", error);
              
          }
     ];
}

-(void)setTotalRequestsInProgress:(int)totalRequestsInProgress{
    _totalRequestsInProgress = totalRequestsInProgress;
    if(totalRequestsInProgress == 0){ // This means that we just finished all of our http operations
        
        NSLog(@"Sending out that ns notification");
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CloudDidFinishSynchronizing" object:nil];
        
        if(self.shouldSynchronizeAgainSoon){
            self.shouldSynchronizeAgainSoon = NO;
            [self synchronize];
        }
        
    }
}
/*
 Goes to the server and asks for all of the information that we have not yet seen
 
 For all thread responses, we get the information and pass it back as an array.
 The delegate can worry about putting the information in the data stores and forcing the UI update.
 
 TODO: Need to make sure that this never goes into a cycle. If the cloud does something to update the model, the cloud will get a callback telling it to synchronize. Right now it isn't that bad, it will synchronize twice. However this could get bad.
 */
-(void)synchronize{
    if(!self.isSynchronizing){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CloudDidStartSynchronizing" object:nil];
        
        NSLog(@"%@", [[Settings sharedInstance] deviceID]);
        if(![[Settings sharedInstance] didRegister]){ // If we have not registered this device
            [self registerDevice];
        }else{ // If we have not registered the device, we probably shouldnt do anything else with the server
            
            if(![[Settings sharedInstance] didRegisterForPushNotifications] && [[Settings sharedInstance] hasAquiredPushNotificationID]){ // We should probably register for push notifications if we can
                [self registerForPushNotifications];
            }else{
                /*
                Should return a list of URLS that we should hit for new information
                We need to be careful here
             
                */
                // Check and see if our credit score has changed etc.
                [self retrieveCreditScore];
                
                // Check and see if we have any updates to our model
                [self retrieveUpdates];
                
                // Upload our latest questions
                [self pushQuestions];
                
                // Upload our latest messages
                [self pushMessages];
            }
        }
    }else{
        // We wanted to synchronize, but we were already trying to synchronize
        // Therefore we should take note of this fact so that we can synchronize again after the current synchronization finishes.
        
        self.shouldSynchronizeAgainSoon = YES;
        
    }
}

-(BOOL)isSynchronizing{
    return !(self.totalRequestsInProgress == 0);
}


@end
