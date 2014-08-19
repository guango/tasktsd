//
//  FirstViewController.m
//  TaskTSD
//
//  Created by UZ on 8/1/14.
//  Copyright (c) 2014 UZ. All rights reserved.
//

#import "FirstViewController.h"
#import "AnotherBubbleView.h"
#import "TaskTSDconfig.h"
#import "RadarView.h"


@interface FirstViewController ()


@end

@implementation FirstViewController

float origX;
float origY;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

	//draw background circles

	RadarView *radar = [[RadarView alloc] initWithFrame:self.view.bounds];
	radar.backgroundColor = [UIColor clearColor];
	[self.view addSubview:radar];

	// Do any additional setup after loading the view, typically from a nib.
	// Load tasks from DB


}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	// if texting resign keyboard
	BOOL isTexting = NO;
	for (UIView *subView in self.view.subviews)
	{
		if ([subView isFirstResponder])
		{
			isTexting = YES;
			[subView resignFirstResponder];
			break;
		}
	}

	// if not texting create new task @ screen (x,y)
	if (!isTexting)
	{
		UITouch *touch = [[event allTouches] anyObject];
		CGPoint location = [touch locationInView:touch.view];
		UIPanGestureRecognizer *bubblePanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveBubble:)];

		AnotherBubbleView * bubbleViewLocal = [[AnotherBubbleView alloc] initWithFrame:CGRectMake(location.x - kTaskTSD_defaultTaskWidth / 2, location.y - kTaskTSD_DefaultTaskHeight / 2, kTaskTSD_defaultTaskWidth, kTaskTSD_DefaultTaskHeight)];
		bubbleViewLocal.backgroundColor = [self getRandomColor];

		bubbleViewLocal.layer.cornerRadius = kTaskTSD_DefaultTaskCornerRadius;

		[bubbleViewLocal addGestureRecognizer:bubblePanGesture];

		[self.view addSubview:bubbleViewLocal];
		[bubbleViewLocal becomeFirstResponder];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)moveBubble:(UIPanGestureRecognizer *)pan
{
    if([pan state] == UIGestureRecognizerStateBegan){
        origX = pan.view.center.x;
        origY = pan.view.center.y;
    }

    CGPoint newCenter;
    newCenter.x = origX + [pan translationInView:pan.view].x;
    newCenter.y = origY + [pan translationInView:pan.view].y;
    pan.view.center = newCenter;
}

-(UIColor *)getRandomColor {
	CGFloat red = ( arc4random() % 256 / 256.0 );
	CGFloat green = ( arc4random() % 256 / 256.0 );
	CGFloat blue = ( arc4random() % 256 / 256.0 );
	return [UIColor colorWithRed:red green:green blue:blue alpha:0.5f];
}

@end
