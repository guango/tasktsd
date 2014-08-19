//
//  RadarView.m
//  TaskTSD
//
//  Created by Ziv Levy on 8/19/14.
//  Copyright (c) 2014 UZ. All rights reserved.
//

#import "RadarView.h"

@implementation RadarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGRect rectangle = CGRectMake(60, 170, 500, 500);
    CGContextAddEllipseInRect(context, rectangle);
    CGContextStrokePath(context);

}

@end
