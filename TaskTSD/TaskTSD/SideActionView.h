//
//  SideActionView.h
//  DueDo
//
//  Created by Ziv Levy on 5/22/15.
//  Copyright (c) 2015 UZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum SideActionViewType
{
    Delegate,
    Done,
    Delete,
    Schedule,
    
    // not a real enum - it is just for count
    sideTypeSize
    
} SideActionViewType;

@interface SideActionView : UIView

@property SideActionViewType actionType;

//+ (CGRect)createRectAccordingToType:(SideActionViewType) type;

- (id)initWithType:(SideActionViewType)type;

@end
