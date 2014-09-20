//
//  LimitedTextView.m
//  IOSAnonQuestion
//
//  Created by Spencer Whyte on 2014-05-11.
//  Copyright (c) 2014 Spencer Whyte. All rights reserved.
//

#import "LimitedTextView.h"

#define MAXIMUM_QUESTION_LENGTH 110
#define WORD_COUNT_HEIGHT 20
#define WORD_COUNT_WIDTH 75
#define WORD_COUNT_PAD 20

@implementation LimitedTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - WORD_COUNT_HEIGHT)];
        self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.textView.returnKeyType = UIReturnKeyDone;
        self.textView.delegate = self;
        self.characterCountDisplay = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-WORD_COUNT_WIDTH, frame.size.height - WORD_COUNT_HEIGHT - WORD_COUNT_PAD/2, WORD_COUNT_WIDTH, WORD_COUNT_HEIGHT)];
        self.characterCountDisplay.backgroundColor = [UIColor blackColor];
        self.characterCountDisplay.textColor = [UIColor whiteColor];
        self.characterCountDisplay.textAlignment = NSTextAlignmentCenter;
        self.characterCountDisplay.layer.cornerRadius = 5;
        self.characterCountDisplay.layer.masksToBounds = YES;
        
        [self addSubview:self.textView];
        [self addSubview: self.characterCountDisplay];
        
        [self updateCharacterCount];
        NSLog(@"EPIC FAIL");
    }
    return self;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([text rangeOfString:@"\n"].location==NSNotFound){
        // They didnt press the enter key
    }else{
        [textView resignFirstResponder];
        return NO;
    }
    return (!([textView.text length]> MAXIMUM_QUESTION_LENGTH - 1 && [text length] > range.length));
}



- (void)textViewDidChange:(UITextView *)textView
{
    [self updateCharacterCount];
}

-(void)updateCharacterCount{
    
    NSLog(@"Updating Character Count");
    self.characterCountDisplay.text = [NSString stringWithFormat:@"%d/%d", self.textView.text.length,MAXIMUM_QUESTION_LENGTH];
    
    if(MAXIMUM_QUESTION_LENGTH - self.textView.text.length < 10){
        self.characterCountDisplay.textColor = [UIColor redColor];
    }else{
        self.characterCountDisplay.textColor = [UIColor whiteColor];
    }
    CGFloat fixedWidth = self.textView.frame.size.width;
    CGSize newSize = [self.textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = self.textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    self.textView.frame = newFrame;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
