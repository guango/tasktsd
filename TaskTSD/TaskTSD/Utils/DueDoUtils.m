//
//  DueDoUtilss.m
//  DueDo
//
//  Created by Ziv Levy on 9/22/14.
//  Copyright (c) 2014 Ziv Levy. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "DueDoUtils.h"

@implementation DueDoUtils
/*
+(BOOL)isContactsPermissionGranted {
	__block BOOL ret = NO;
	CFErrorRef error = NULL;
	if (ABAddressBookRequestAccessWithCompletion != NULL) { // we're on iOS6

		dispatch_semaphore_t sema = dispatch_semaphore_create(0);
		ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
		ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
			ret = granted;
			dispatch_semaphore_signal(sema);
		});
		if (addressBook) {
			CFRelease(addressBook);
		}

		dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
	}
	else { // we're on iOS5 or older
		ret = YES;
	}

	return ret;
}
*/

@end
