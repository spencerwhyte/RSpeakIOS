//
//  LimitedTextView.h
//  IOSAnonQuestion
//
//  Created by Spencer Whyte on 2014-05-11.
//  Copyright (c) 2014 Spencer Whyte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LimitedTextView : UIView<UITextViewDelegate>

@property UITextView * textView;
@property UILabel * characterCountDisplay;

@end
