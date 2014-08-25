//
//  RadarView.m
//  TaskTSD
//
//  Created by Ziv Levy on 8/19/14.
//  Copyright (c) 2014 UZ. All rights reserved.
//

#import "RadarView.h"
#import "TaskTSDconfig.h"

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
- (void)drawRect:(CGRect)rect {
	
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.2f green:0.7f blue:0.9 alpha:0.3f].CGColor);
	int y = 350.0f;
	for(int i = 0; i < kTaskTSD_DefaultRadarTimezones; i++){
		CGRect rectangle = CGRectMake(-self.bounds.size.width / 2, y, kTaskTSD_DefaultRadarRadius * self.bounds.size.width,kTaskTSD_DefaultRadarRadius * self.bounds.size.width);

        CGContextFillEllipseInRect(context, rectangle);
        CGContextAddEllipseInRect(context, rectangle);
		CGContextStrokePath(context);
        
		y -= 100;
	}
}


@end
