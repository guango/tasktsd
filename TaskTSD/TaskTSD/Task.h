//
//  Task.h
//  TaskTSD
//
//  Created by Ziv Levy on 12/27/14.
//  Copyright (c) 2014 UZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Task : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * taskId;
@property (nonatomic, retain) NSNumber * priority;
@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSNumber * width;
@property (nonatomic, retain) NSNumber * xPosition;
@property (nonatomic, retain) NSNumber * yPosition;

@end
