//
//  QuestionTableViewCell.m
//  IOSAnonQuestion
//
//  Created by Spencer Whyte on 2014-05-19.
//  Copyright (c) 2014 Spencer Whyte. All rights reserved.
//

#import "QuestionTableViewCell.h"

@implementation QuestionTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setQuestion:(Question *)question{
    _question = question;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    [dateFormatter setDoesRelativeDateFormatting:YES];
    
   
    NSString *dateString = [dateFormatter stringFromDate:question.dateOfCreation];
    
    NSLog(@"dateString: %@", dateString);
    // Output
    // dateString: après-après-demain
    
    if(!dateString){
        dateString = @"";
    }
    self.textLabel.text = self.question.content;
    if(self.question.hasBeenPostedToServer){ // If this is still waiting to be uploaded
        if(question.threads.count == 0){
            self.detailTextLabel.text = [@"No Answerers - " stringByAppendingString:dateString];
        }else if(question.threads.count == 1){
            self.detailTextLabel.text = [@"1 Answerer - " stringByAppendingString:dateString];
        }else{
            self.detailTextLabel.text = [NSString stringWithFormat:[@"%d Answerers - " stringByAppendingString:dateString], self.question.threads.count];
        }
        self.detailTextLabel.textColor = [UIColor blackColor];
    }else{
        self.detailTextLabel.textColor = [UIColor redColor];
        self.detailTextLabel.text = @"Question Yet to Reach Server";
    }

}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
