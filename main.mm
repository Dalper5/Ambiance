//
//  main.m
//  Ambiance
//
//  Created by dalperovich on 1/23/13.
//  Copyright (c) 2013 Ambiance. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

int main(int argc, char *argv[]) {
	
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	int retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
	[pool release];
	return retVal;
}