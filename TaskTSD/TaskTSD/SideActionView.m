//
//  SideActionView.m
//  DueDo
//
//  Created by Ziv Levy on 5/22/15.
//  Copyright (c) 2015 UZ. All rights reserved.
//

#import "SideActionView.h"
#import "TaskTSDconfig.h"

#define k_SideActionWidth 30
#define k_TabBarHeight 49

@implementation SideActionView

@synthesize actionType;

- (id)initWithType:(SideActionViewType)type {
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    
    switch(type){
        case Done: {
            y = (screenHeight - k_TabBarHeight) / 2;
        }
            break;
        case Delegate: {
            
        }
            break;
        case Delete:{
            y = (screenHeight - k_TabBarHeight) / 2;
            x = screenWidth - k_SideActionWidth;
            
        }
            break;
        case Schedule:{
            x = screenWidth - k_SideActionWidth;
            
        }break;
        default:
            break;
    }
    
    CGRect rect = CGRectMake(x, y, k_SideActionWidth, ((screenHeight - k_TabBarHeight) / 2) -2);
    self = [super initWithFrame:rect];
    if (self) {
        self.actionType = type;
        self.backgroundColor = [UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:1.0];
        self.alpha = kSideBarDefaultOpacity;
    }
    return self;
}




/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
