//
//  Task+Create.m
//  TaskTSD
//
//  Created by Ziv Levy on 12/27/14.
//  Copyright (c) 2014 UZ. All rights reserved.
//

#import "Task+Create.h"

@implementation Task (Create)

+ (Task *)managedTaskWithTaskId:(NSString *)taskId text:(NSString *)text andRect:(CGRect)rect inManagedObjectContext:(NSManagedObjectContext *)context {
    
    Task *task = nil;
    
    if (taskId) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
        
        // uncomment this if you want to sort the results order
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"text"
                                                                  ascending:YES
                                                                   selector:@selector(compare:)]];
        request.predicate = [NSPredicate predicateWithFormat:@"taskId = %@", taskId];
        
        NSError *error;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        if (!matches || ([matches count] > 1)) {
            // handle error
        } else if (![matches count]) {
            task = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:context];
            task.taskId = taskId;
            task.text = text;
            task.xPosition = [NSNumber numberWithFloat:rect.origin.x];
            task.yPosition = [NSNumber numberWithFloat:rect.origin.y];
            task.height = [NSNumber numberWithFloat:rect.size.height];
            task.width = [NSNumber numberWithFloat:rect.size.width];
            
        } else {
            task = [matches lastObject];
        }
    }
    
    return task;
    
}

@end
