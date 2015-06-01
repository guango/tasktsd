//
//  FirstViewController.m
//  TaskTSD
//
//  Created by UZ on 8/1/14.
//  Copyright (c) 2014 UZ. All rights reserved.
//

#import "FirstViewController.h"
#import "BubbleView.h"
#import "TaskTSDconfig.h"
#import "RadarView.h"
#import "Task+Create.h"
#import "Task+Read.h"
#import "SideActionView.h"


@interface FirstViewController ()


@end

@implementation FirstViewController

float origX;
float origY;
BOOL bubbleBelowKeyboardHeight = NO;
float currentViewOffsetOnKeyboard;
float lastScale;

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    if (managedObjectContext) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
        
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"yPosition" ascending:YES selector:@selector(compare:)]];
        request.predicate = nil; // all Activities
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    } else {
        self.fetchedResultsController = nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

	//draw background circles

	RadarView *radar = [[RadarView alloc] initWithFrame:self.view.bounds];
	radar.backgroundColor = [UIColor clearColor];
	[self.view addSubview:radar];
    [self registerForKeyboardNotifications];
    
    [self createSideActionViews];

	// Do any additional setup after loading the view, typically from a nib.
	// Load tasks from DB
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.managedObjectContext) {
        [self useDemoDocument];
    }
}

-(void)createSideActionViews {
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:sideTypeSize];
    for (int i = 0; i < sideTypeSize; ++i) {
        UIView *view = [[SideActionView alloc] initWithType:(SideActionViewType)i];
        [arr addObject:view];
        if(view){
            [self.view addSubview:view];
        }
    }
    
    sideViews = [NSArray arrayWithArray:arr];
}

-(void)loadTasks {
    
    NSError *error;
    [self.fetchedResultsController performFetch:&error];
    if (error) {
        NSLog(@"[%@ %@] %@ (%@)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [error localizedDescription], [error localizedFailureReason]);
    }
    
    NSArray* results = [self.fetchedResultsController fetchedObjects];
    if(results){
        NSLog(@"loaded %d results", (int)[results count]);
        for (Task* task in results) {
            BubbleView * bubbleViewLocal = [[BubbleView alloc] initWithTask:task];
            bubbleViewLocal.backgroundColor = [self getRandomColor];
            bubbleViewLocal.font = [UIFont systemFontOfSize:kTaskTSD_DefaultFontSize];
            bubbleViewLocal.layer.cornerRadius = kTaskTSD_DefaultTaskCornerRadius;
            
            UIPanGestureRecognizer *bubblePanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandler:)];
            bubblePanGesture.delegate = self;
            UIPinchGestureRecognizer *bubblePinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(onPinchBubble:)];
            UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureHandler:)];
            [swipeGesture requireGestureRecognizerToFail:bubblePanGesture];
            
            [bubbleViewLocal addGestureRecognizer:swipeGesture];
            [bubbleViewLocal addGestureRecognizer:bubblePanGesture];
            [bubbleViewLocal addGestureRecognizer:bubblePinchGesture];
            bubbleViewLocal.delegate = self;
            
            
            [self.view addSubview:bubbleViewLocal];
        }
    };
}

// Either creates, opens or just uses the demo document
//   (actually, it will never "just use" it since it just creates the UIManagedDocument instance here;
//    the "just uses" case is just shown that if someone hands you a UIManagedDocument, it might already
//    be open and so you can just use it if it's documentState is UIDocumentStateNormal).
//
// Creating and opening are asynchronous, so in the completion handler we set our Model (managedObjectContext).

- (void)useDemoDocument
{
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"Tasks Document"];
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
        [document saveToURL:url
           forSaveOperation:UIDocumentSaveForCreating
          completionHandler:^(BOOL success) {
              if (success) {
                  self.managedObjectContext = document.managedObjectContext;
              }
          }];
    } else if (document.documentState == UIDocumentStateClosed) {
        [document openWithCompletionHandler:^(BOOL success) {
            if (success) {
                self.managedObjectContext = document.managedObjectContext;
                [self loadTasks];
            }
        }];
    } else {
        self.managedObjectContext = document.managedObjectContext;
        [self loadTasks];
    }
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

	if(!isTexting){

		// if not texting create new task @ screen (x,y)
		UITouch *touch = [[event allTouches] anyObject];
		CGPoint location = [touch locationInView:touch.view];
		UIPanGestureRecognizer *bubblePanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandler:)];
		bubblePanGesture.delegate = self;
        UIPinchGestureRecognizer *bubblePinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(onPinchBubble:)];
		UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureHandler:)];
		[swipeGesture requireGestureRecognizerToFail:bubblePanGesture];
        
		BubbleView * bubbleViewLocal = [[BubbleView alloc] initWithFrame:CGRectMake(location.x - kTaskTSD_defaultTaskWidth / 2, location.y - kTaskTSD_DefaultTaskHeight / 2, kTaskTSD_defaultTaskWidth, kTaskTSD_DefaultTaskHeight)];
		bubbleViewLocal.backgroundColor = [self getRandomColor];
        bubbleViewLocal.font = [UIFont systemFontOfSize:kTaskTSD_DefaultFontSize];
        bubbleViewLocal.layer.cornerRadius = kTaskTSD_DefaultTaskCornerRadius;

		[bubbleViewLocal addGestureRecognizer:swipeGesture];
		[bubbleViewLocal addGestureRecognizer:bubblePanGesture];
        [bubbleViewLocal addGestureRecognizer:bubblePinchGesture];
		bubbleViewLocal.delegate = self;


		[self.view addSubview:bubbleViewLocal];
        [self setBubbleBelowKeyboardHeight:bubbleViewLocal];
		[bubbleViewLocal becomeFirstResponder];
    }
}

- (BOOL)textViewShouldBeginEditing:(BubbleView *)textView {

	[self.view bringSubviewToFront:textView];
	textView.textAlignment = NSTextAlignmentNatural;
	[UIView animateWithDuration:0.2 animations:^{
		textView.alpha = 0.95;
	}];


	return YES;
}

- (BOOL)textViewShouldEndEditing:(BubbleView *)textView {

    Task *task = [Task managedTaskWithTaskId:textView.taskId text:textView.text andRect:textView.frame inManagedObjectContext:self.managedObjectContext];
    task.text = textView.text;
    NSError *error;
    [self.managedObjectContext save:&error];
    if(error){
        NSLog(@"SAVE ERROR");
    }
	[UIView animateWithDuration:0.5 animations:^{
		textView.alpha = 0.7;
		textView.textAlignment = NSTextAlignmentCenter;
	} completion:^(BOOL finished) {
        
    }];
    

	return YES;
}

-(void)setBubbleBelowKeyboardHeight:(BubbleView *)bubble
{
    float bottomBorderHeight = bubble.frame.origin.y + bubble.frame.size.height;
    
    float totalHeightMinusKeyboard = self.view.frame.size.height - (432 / 2);
    
    if(totalHeightMinusKeyboard - bottomBorderHeight < 0){
        bubbleBelowKeyboardHeight = YES;
        currentViewOffsetOnKeyboard = totalHeightMinusKeyboard - bottomBorderHeight;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {

	// check that it is the pan gesture
	if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]])
	{
		UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
		CGPoint velocity = [pan velocityInView:gestureRecognizer.view];
		// added an arbitrary velocity for failure
		if (ABS(velocity.x) > 450)
		{
			// fail if the swipe was fast enough - this should allow the swipe gesture to be invoked
			return NO;
		}
	}
	return YES;
}

- (void)swipeGestureHandler:(UISwipeGestureRecognizer *)swipeGesture {

	if(swipeGesture.state == UIGestureRecognizerStateRecognized){
		if (swipeGesture.direction == UISwipeGestureRecognizerDirectionRight) {
			[UIView animateWithDuration:0.5 animations:^{
				CGFloat rotationAngel = (CGFloat) (6 * M_PI / 16);
				CGFloat scale = 0.1;
				CGAffineTransform transform = CGAffineTransformMakeRotation(rotationAngel);
				CGAffineTransform scaleTransform = CGAffineTransformScale(transform, scale, scale);
				swipeGesture.view.transform = scaleTransform;
				swipeGesture.view.alpha = 0.0;
			} completion:^(BOOL finished) {
				NSLog(@"gone!");
                BubbleView * view = (BubbleView *)swipeGesture.view;
                if(view){
                    NSString* taskId = view.taskId;
                    if(taskId){
                        Task* task = [Task managedTaskWithTaskId:taskId inManagedObjectContext:self.managedObjectContext];
                        if(task){
                            [self.managedObjectContext deleteObject:task];
                        
                        }
                    }
                }
                [swipeGesture.view removeFromSuperview];
			}];
		}
	}
}

-(void)panGestureHandler:(UIPanGestureRecognizer *)pan
{
    if([pan state] == UIGestureRecognizerStateBegan){
        origX = pan.view.center.x;
        origY = pan.view.center.y;
        [self changeSideActionViewsOpacity:kSideBarOnFocusOpacity];
    }
    
    if([pan state] == UIGestureRecognizerStateEnded){
        [self changeSideActionViewsOpacity:kSideBarDefaultOpacity];
    }

    CGPoint newCenter;
    newCenter.x = origX + [pan translationInView:pan.view].x;
    newCenter.y = origY + [pan translationInView:pan.view].y;
    pan.view.center = newCenter;
}

-(void)changeSideActionViewsOpacity:(CGFloat)alpha {
    for (UIView *view in sideViews) {
        view.alpha = alpha;
    }
}

-(void)onPinchBubble:(UIPinchGestureRecognizer *)pinch
{
    if([pinch state] == UIGestureRecognizerStateBegan) {
        // Reset the last scale, necessary if there are multiple objects with different scales
        lastScale = [pinch scale];
    }
    
    if ([pinch state] == UIGestureRecognizerStateBegan ||
        [pinch state] == UIGestureRecognizerStateChanged) {
        
        CGFloat currentScale = [[[pinch view].layer valueForKeyPath:@"transform.scale"] floatValue];
        
        CGFloat newScale = 1 -  (lastScale - [pinch scale]);
        newScale = MIN(newScale, kTaskTSD_DefaultMaxScale / currentScale);
        newScale = MAX(newScale, kTaskTSD_DefaultMinScale / currentScale);
        CGAffineTransform transform = CGAffineTransformScale([[pinch view] transform], newScale, newScale);
        [pinch view].transform = transform;
        
        lastScale = [pinch scale];  // Store the previous scale factor for the next pinch gesture call
    }
    
    if ( [pinch.view isKindOfClass:[BubbleView class]] ){
        BubbleView *taskBubble = (BubbleView *)pinch.view;
        
        Task *task = [Task managedTaskWithTaskId:taskBubble.taskId text:taskBubble.text andRect:taskBubble.frame inManagedObjectContext:self.managedObjectContext];
        task.xPosition = [NSNumber numberWithFloat:taskBubble.frame.origin.x];
        task.yPosition = [NSNumber numberWithFloat:taskBubble.frame.origin.y];
        task.height = [NSNumber numberWithFloat:taskBubble.frame.size.height];
        task.width = [NSNumber numberWithFloat:taskBubble.frame.size.width];
        NSError *error;
        [self.managedObjectContext save:&error];
        
    }
}


- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}


-(void)keyboardWillShow:(NSNotification*)aNotification
{
    if(bubbleBelowKeyboardHeight){
        CGRect bkgndRect = self.view.frame;
        
        // we are adding a negative value
        bkgndRect.origin.y += currentViewOffsetOnKeyboard - kTaskTSD_DefaultKeyboradOffsetPadding;
        
        [UIView animateWithDuration:0.5 animations:^{
            [self.view setFrame:bkgndRect];
        }];
    }
}

-(void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    if(bubbleBelowKeyboardHeight){
        CGRect bkgndRect = self.view.frame;
        // we are substracting a negative value
        bkgndRect.origin.y -= currentViewOffsetOnKeyboard - kTaskTSD_DefaultKeyboradOffsetPadding;
        [UIView animateWithDuration:0.5 animations:^{
            [self.view setFrame:bkgndRect];
        }];
    }
    bubbleBelowKeyboardHeight = NO;
    
    
}


-(UIColor *)getRandomColor {
	CGFloat red = ( arc4random() % 256 / 256.0 );
	CGFloat green = ( arc4random() % 256 / 256.0 );
	CGFloat blue = ( arc4random() % 256 / 256.0 );
	return [UIColor colorWithRed:red green:green blue:blue alpha:0.7f];
}

@end
