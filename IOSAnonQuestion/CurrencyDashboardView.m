//
//  CurrencyDashboardView.m
//  IOSAnonQuestion
//
//  Created by Spencer Whyte on 2014-05-11.
//  Copyright (c) 2014 Spencer Whyte. All rights reserved.
//

#import "CurrencyDashboardView.h"

@implementation CurrencyDashboardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //self.backgroundColor = [UIColor greenColor];
    
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Coins2" ofType:@"png"];
        
        UIImage * image = [UIImage imageWithContentsOfFile:filePath];
        
        UIImageView * coins = [[UIImageView alloc] initWithImage:image];
        
        coins.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width/3, frame.size.height);
        
        self.coinDisplay = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/3, 0, 2*frame.size.width/3, frame.size.height)];
        
        self.indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(frame.size.width/3, 0, 2*frame.size.width/3, frame.size.height)];
        self.indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        //[self.indicatorView startAnimating];
        self.indicatorView.hidden = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(synchronizeDeviceInformationDidBegin) name:@"synchronizeDeviceInformationDidBegin" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(synchronizeDeviceInformationDidSucceed) name:@"synchronizeDeviceInformationDidSucceed" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(synchronizeDeviceInformationDidFail) name:@"synchronizeDeviceInformationDidFail" object:nil];
        
        
        [self addSubview:coins];
        [self addSubview:self.coinDisplay];
        [self addSubview:self.indicatorView];
         
        
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



#pragma mark UI update methods

-(void)startAnimatingSynchronization{
    self.indicatorView.hidden = NO;
    [self.indicatorView startAnimating];
}

-(void)stopAnimatingSynchronization{
    self.indicatorView.hidden = YES;
    [self.indicatorView stopAnimating];
}

-(void)updateCoinDisplay{
    self.coinDisplay.textAlignment = NSTextAlignmentCenter;
    if([DeviceInformation sharedInstance].tokenCount == -1){
        self.coinDisplay.text = @"?";
    }else{
        self.coinDisplay.text = [NSString stringWithFormat:@"%d", [DeviceInformation sharedInstance].tokenCount];
    }
    //self.coinDisplay.hidden = YES;
}


#pragma mark NSNotificationCenter synchronization

-(void)synchronizeDeviceInformationDidBegin{
    NSLog(@"Got Begin");
    [self startAnimatingSynchronization];
}

-(void)synchronizeDeviceInformationDidSucceed{
    NSLog(@"Got End");
    [self updateCoinDisplay];
    [self stopAnimatingSynchronization];
}

-(void)synchronizeDeviceInformationDidFail{
    [self stopAnimatingSynchronization];
    [self updateCoinDisplay];
    // Not sure what to do about this yet, depends if we have ever synced before
}




@end
