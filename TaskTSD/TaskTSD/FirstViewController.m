//
//  FirstViewController.m
//  TaskTSD
//
//  Created by UZ on 8/1/14.
//  Copyright (c) 2014 UZ. All rights reserved.
//

#import "FirstViewController.h"
#import "AnotherBubbleView.h"


@interface FirstViewController ()

@end

@implementation FirstViewController

float origX;
float origY;
#define kRANDOM 200
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

	for(int i = 0; i < 3; i++){

		int x = arc4random() % kRANDOM;
		int y = arc4random() % kRANDOM;

		UIPanGestureRecognizer *bubblePanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveBubble:)];

		AnotherBubbleView * bubbleViewLocal = [[AnotherBubbleView alloc] initWithFrame:CGRectMake(x, y, 120, 80)];
		bubbleViewLocal.backgroundColor = [self getRandomColor];

		[bubbleViewLocal addGestureRecognizer:bubblePanGesture];

		[self.view addSubview:bubbleViewLocal];
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
