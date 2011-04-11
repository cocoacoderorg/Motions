//
//  Motion.m
//  Motions
//
//  Created by James Hillhouse on 3/31/11.
//  Copyright 2011 PortableFrontier. All rights reserved.
//




#import "Spacecraft.h"

#import <UIKit/UIKit.h>



@implementation Spacecraft



@synthesize spacecraftImage;

@synthesize x;
@synthesize y;
@synthesize z;

@synthesize pitch;
@synthesize roll;
@synthesize yaw;

@synthesize lateralAcceleration;
@synthesize longitudinalAcceleration;



#pragma mark - init & dealloc methods

- (void)dealloc
{
    [x release];
    [y release];
    [z release];
    
    [spacecraftImage release];
    
    [super dealloc];
}



- (id)init
{
    if ((self = [super init])) 
    {
        self.spacecraftImage                = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SR-71-Color" ofType:@"png"]];
        
        self.x                              = [NSNumber numberWithFloat:0.0];
        self.y                              = [NSNumber numberWithFloat:0.0];
        self.z                              = [NSNumber numberWithFloat:0.0];
        
        self.pitch                          = 0.0;
        self.roll                           = 0.0;
        self.yaw                            = 0.0;
        
        self.lateralAcceleration            = 0.0;
        self.longitudinalAcceleration       = 0.0;
    }
    return self;
}


@end
