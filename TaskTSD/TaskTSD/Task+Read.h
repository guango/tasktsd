//
//  Task+Read.h
//  TaskTSD
//
//  Created by Ziv Levy on 12/27/14.
//  Copyright (c) 2014 UZ. All rights reserved.
//

#import "Task.h"

@interface Task (Read)

+ (Task *)managedTaskWithTaskId:(NSString *)taskId inManagedObjectContext:(NSManagedObjectContext *)context;

@end
