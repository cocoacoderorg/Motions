//
//  main.m
//  Motions
//
//  Created by James Hillhouse on 3/30/11.
//  Copyright 2011 PortableFrontier. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MotionsAppDelegate.h"

int main(int argc, char *argv[])
{
    //
    // Pre-ARC Canned Code
    //
    //    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    //    int retVal = UIApplicationMain(argc, argv, nil, nil);
    //    [pool release];
    //    return retVal;
    
    int retVal = 0;
    @autoreleasepool {
        retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([MotionsAppDelegate class]));
    }
    return retVal;
}
