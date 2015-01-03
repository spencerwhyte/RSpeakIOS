

#import <UIKit/UIKit.h>
#import "UIBubbleTableViewDataSource.h"
#import "Thread.h"
#import "Message.h"
#import "DeviceInformation.h"
#import "UIBubbleTableView.h"
#import "UIBubbleTableViewDataSource.h"
#import "NSBubbleData.h"
#import "Question.h"
#import "JSQMessages.h"
#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@interface MessagesViewController : JSQMessagesViewController <JSQMessagesCollectionViewDataSource,JSQMessagesCollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate>
@property NSManagedObjectContext * managedObjectContext;
@property Thread * thread;
@property UIImageView * outgoingBubbleImageView;
@property UIImageView * incomingBubbleImageView;
@property UIImageView * questionBubbleImageView;

- (NSString *)sender;
@end
