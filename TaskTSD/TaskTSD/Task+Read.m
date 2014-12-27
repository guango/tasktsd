//
//  Task+Read.m
//  TaskTSD
//
//  Created by Ziv Levy on 12/27/14.
//  Copyright (c) 2014 UZ. All rights reserved.
//

#import "Task+Read.h"

@implementation Task (Read)

+ (Task *)managedTaskWithTaskId:(NSString *)taskId inManagedObjectContext:(NSManagedObjectContext *)context {
    
    Task *task = nil;
    
    if (taskId) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
        request.predicate = [NSPredicate predicateWithFormat:@"taskId = %@", taskId];
        NSError *error;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        if (!matches || ([matches count] > 1)) {
            // handle error
        } else if (![matches count]) {
            // nothing has been found
        } else {
            task = [matches lastObject];
        }
    }
    
    return task;
    
}

@end
