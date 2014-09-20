//
//  BoxTableViewController.m
//  IOSAnonQuestion
//
//  Created by Spencer Whyte on 2014-05-22.
//  Copyright (c) 2014 Spencer Whyte. All rights reserved.
//

#import "BoxTableViewController.h"



@interface BoxTableViewController ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end
@implementation BoxTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.navigationItem.leftBarButtonItem = [[CurrencyBarButtonItem alloc] initWithCustomView:nil];
        
        UIRefreshControl * refreshControl = [[UIRefreshControl alloc] init];
        [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
        [self setRefreshControl:refreshControl];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didStartSynchronizing) name:@"CloudDidStartSynchronizing" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishSynchronizing) name:@"CloudDidFinishSynchronizing" object:nil];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

-(void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext{
    _managedObjectContext = managedObjectContext;
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}


-(void)refreshTable{
    
    [[Cloud sharedInstance] synchronize];
    
}

#pragma mark Cloud NSNotifications

-(void)didStartSynchronizing{
    NSLog(@"");
    if(!self.refreshControl.isRefreshing){
        [self.refreshControl beginRefreshing];
    }
}

-(void)didFinishSynchronizing{
    if(self.refreshControl.isRefreshing){
        [self.refreshControl endRefreshing];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return [self.fetchedResultsController sections].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
	
    if ([self.fetchedResultsController sections].count > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        numberOfRows = [sectionInfo numberOfObjects];
        
    }
    NSLog(@"%d %d", section, numberOfRows);
    return numberOfRows;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * cellIdentifier = @"QuestionTableViewCell";
    QuestionTableViewCell *questionCell =
    (QuestionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(questionCell == nil){
        questionCell = [[QuestionTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    [self configureCell:questionCell atIndexPath:indexPath];
    
    return questionCell;
}

- (void)configureCell:(QuestionTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
	Question * question = (Question *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.question = question;
    
    /*
    if(question.threads.count == 1){
        
        NSString * deviceID = @"android";
        
        NSLog(@"%@", question.senderDeviceID);
        NSEntityDescription * description = [NSEntityDescription entityForName:@"Thread" inManagedObjectContext:self.managedObjectContext];
        Thread * t = [[Thread alloc] initWithEntity:description insertIntoManagedObjectContext:self.managedObjectContext];
        t.responderDeviceID = deviceID;
        t.dateOfCreation = [NSDate date];
        t.question = question;
     
        description = [NSEntityDescription entityForName:@"Message" inManagedObjectContext:self.managedObjectContext];
        Message * m1 = [[Message alloc] initWithEntity:description insertIntoManagedObjectContext:self.managedObjectContext];
        m1.senderDeviceID = deviceID;
        m1.dateOfCreation = [NSDate date];
        m1.content = @"There is no good answer to this question";
        
        Message * m2 = [[Message alloc] initWithEntity:description insertIntoManagedObjectContext:self.managedObjectContext];
        m2.senderDeviceID = [[DeviceInformation sharedInstance] deviceID];
        m2.dateOfCreation = [NSDate date];
        m2.content = @"What a waste of points";
        
        Message * m3 = [[Message alloc] initWithEntity:description insertIntoManagedObjectContext:self.managedObjectContext];
        m3.senderDeviceID = deviceID;
        m3.dateOfCreation = [NSDate date];
        m3.content = @"Its only one point";
        
        Message * m4 = [[Message alloc] initWithEntity:description insertIntoManagedObjectContext:self.managedObjectContext];
        m4.senderDeviceID = [[DeviceInformation sharedInstance] deviceID];
        m4.dateOfCreation = [NSDate date];
        m4.content = @"The lazy fox jumped over the read dog";
        
        Message * m5 = [[Message alloc] initWithEntity:description insertIntoManagedObjectContext:self.managedObjectContext];
        m5.senderDeviceID = deviceID;
        m5.dateOfCreation = [NSDate date];
        m5.content = @"Thats just a typing lesson";
        
        [t addMessagesObject:m1];
        [t addMessagesObject:m2];
        [t addMessagesObject:m3];
        [t addMessagesObject:m4];
        [t addMessagesObject:m5];
        
        NSError * error;
        [self.managedObjectContext save:&error];
        
    }
    */
     
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // If someone has answered the question, then we should show them the different threads that are going on
    
     Question * question = (Question *)[self.fetchedResultsController objectAtIndexPath:indexPath];
     NSLog(@"Selected Date: %@" , question.dateOfCreation);
     if(question.threads.count == 1){ // Jump to the individual thread
         Thread * thread = [question.threads anyObject];
         MessagesViewController * messagesTableViewController = [MessagesViewController messagesViewController];
         messagesTableViewController.thread = thread;
         messagesTableViewController.managedObjectContext = self.managedObjectContext;
         messagesTableViewController.hidesBottomBarWhenPushed = YES;
         [self.navigationController pushViewController:messagesTableViewController animated:YES];
     }else if(question.threads.count > 1){ // Look at all of the threads
         
         ThreadsTableViewController * threadsTableViewController = [[ThreadsTableViewController alloc] initWithStyle:UITableViewStylePlain];
         threadsTableViewController.question = question;
         threadsTableViewController.managedObjectContext = self.managedObjectContext;
         [self.navigationController pushViewController:threadsTableViewController animated:YES];
     }
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        Question * question = (Question *)[self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.managedObjectContext deleteObject:question];
        NSError * error;
        [self.managedObjectContext save:&error];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSPredicate*)predicate{
    return nil;
}

- (NSFetchedResultsController *)fetchedResultsController {
    // Do we need to refetch the results?
    // Set up the fetched results controller if needed.
    if (_fetchedResultsController == nil) {
        // Create the fetch request for the entity.
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        // Edit the entity name as appropriate.
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Question" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        [fetchRequest setPredicate:[self predicate]];
        
        // Edit the sort key as appropriate.
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateOfCreation" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        
        aFetchedResultsController.delegate = self;
        self.fetchedResultsController = aFetchedResultsController;
        
        NSError * error;
        NSArray * res = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        NSLog(@"%@", res);
        
        // This is the reason Why
    }
	return _fetchedResultsController;
}



/**
 Delegate methods of NSFetchedResultsController to respond to additions, removals and so on.
 */
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    
	// The fetch controller is about to start sending change notifications, so prepare the table view for updates.
	[self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
	UITableView *tableView = self.tableView;
	
	switch(type) {
		case NSFetchedResultsChangeInsert:
			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeUpdate:
			[self configureCell:(QuestionTableViewCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
			break;
			
		case NSFetchedResultsChangeMove:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
	}
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
	switch(type) {
		case NSFetchedResultsChangeInsert:
			[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
	// The fetch controller has sent all current change notifications,
    // so tell the table view to process all updates.
	[self.tableView endUpdates];
}


@end
