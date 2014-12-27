//
//  Task+Create.h
//  TaskTSD
//
//  Created by Ziv Levy on 12/27/14.
//  Copyright (c) 2014 UZ. All rights reserved.
//

#import "Task.h"

@interface Task (Create)

+ (Task *)managedTaskWithTaskId:(NSString *)taskId
                           text:(NSString *)text
                        andRect:(CGRect) rect
         inManagedObjectContext:(NSManagedObjectContext *)context;

@end
