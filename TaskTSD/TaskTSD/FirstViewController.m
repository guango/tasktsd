//
//  FirstViewController.m
//  TaskTSD
//
//  Created by UZ on 8/1/14.
//  Copyright (c) 2014 UZ. All rights reserved.
//

#import "FirstViewController.h"
#import "BubbleView.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

float origX;
float origY;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

	BubbleView * bubbleView = [[BubbleView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
	bubbleView.backgroundColor = [UIColor clearColor];
    UIPanGestureRecognizer *bubblePanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveBubble:)];

    [bubbleView addGestureRecognizer:bubblePanGesture];
    
	[self.view addSubview:bubbleView];
	
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
    
    //NSLog(@"Panned %f, %f", [pan translationInView:pan.view].x, [pan translationInView:pan.view].y );
}

@end
