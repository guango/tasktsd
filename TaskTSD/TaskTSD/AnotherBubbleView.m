//
//  AnotherBubbleView.m
//  TaskTSD
//
//  Created by Ziv Levy on 8/9/14.
//  Copyright (c) 2014 UZ. All rights reserved.
//

#import "AnotherBubbleView.h"

@implementation AnotherBubbleView

@synthesize taskId;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.taskId = [[NSUUID UUID] UUIDString];
    }
    return self;
}

- (id)initWithTask:(Task *)task
{
    CGRect rect = CGRectMake(task.xPosition.floatValue, task.yPosition.floatValue, task.width.floatValue, task.height.floatValue);
    self = [super initWithFrame:rect];
    if (self) {
        self.taskId = task.taskId;
        self.text = task.text;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (void)layoutSubviews
{
	[super layoutSubviews];
}

@end
