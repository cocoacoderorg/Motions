//
//  MotionsAppDelegate.h
//  Motions
//
//  Created by James Hillhouse on 3/30/11.
//  Copyright 2011 PortableFrontier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface MotionsAppDelegate : NSObject <UIApplicationDelegate> 
{
    CMMotionManager                 *motionManager;
}

@property (nonatomic, retain)       IBOutlet        UIWindow                    *window;

@property (nonatomic, retain)       IBOutlet        UINavigationController      *navigationController;

@property (readonly)                                CMMotionManager             *motionManager;

@end
