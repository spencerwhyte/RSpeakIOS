//
//  CurrencyDashboardView.h
//  IOSAnonQuestion
//
//  Created by Spencer Whyte on 2014-05-11.
//  Copyright (c) 2014 Spencer Whyte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "DeviceInformation.h"

@interface CurrencyDashboardView : UIView <NSFetchedResultsControllerDelegate>
@property UILabel * coinDisplay;
@property UIActivityIndicatorView * indicatorView;
@end
