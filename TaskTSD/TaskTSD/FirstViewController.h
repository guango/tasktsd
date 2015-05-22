//
//  FirstViewController.h
//  TaskTSD
//
//  Created by UZ on 8/1/14.
//  Copyright (c) 2014 UZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"

@interface FirstViewController : CoreDataTableViewController <UITextViewDelegate, UIGestureRecognizerDelegate> {
    
    NSArray *sideViews;
}



// The Model for this class.
// Essentially specifies the database to look in to find all Groups to display in this table.
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
