//
//  CurrencyBarButtonItem.m
//  IOSAnonQuestion
//
//  Created by Spencer Whyte on 2014-05-11.
//  Copyright (c) 2014 Spencer Whyte. All rights reserved.
//

#import "CurrencyBarButtonItem.h"


@implementation CurrencyBarButtonItem

-(id)initWithCustomView:(UIView *)customView{
    CurrencyDashboardView * currencyDisplay = [[CurrencyDashboardView alloc] initWithFrame: CGRectMake(0, 0, 80, 30)];
    if(self = [super initWithCustomView:currencyDisplay]){
    
    }
    return self;
}


@end
