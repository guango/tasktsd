//
//  AnotherBubbleView.h
//  TaskTSD
//
//  Created by Ziv Levy on 8/9/14.
//  Copyright (c) 2014 UZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

@interface AnotherBubbleView : UITextView

- (id)initWithTask:(Task *)task;

@property (nonatomic, retain) NSString* taskId;

@end
