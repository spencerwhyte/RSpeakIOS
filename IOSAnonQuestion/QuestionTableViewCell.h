//
//  QuestionTableViewCell.h
//  IOSAnonQuestion
//
//  Created by Spencer Whyte on 2014-05-19.
//  Copyright (c) 2014 Spencer Whyte. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Question.h"

@interface QuestionTableViewCell : UITableViewCell

@property (nonatomic, strong) Question * question;

@end
