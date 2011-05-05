//
//  Motion.m
//  Motions
//
//  Created by James Hillhouse on 3/31/11.
//  Copyright 2011 PortableFrontier. All rights reserved.
//




#import "Spacecraft.h"

#import <UIKit/UIKit.h>



@interface Spacecraft() 

// 
// Nada
//

@end



@implementation Spacecraft



@synthesize spacecraftImage;

@synthesize x;
@synthesize y;
@synthesize z;

@synthesize pitch;
@synthesize roll;
@synthesize yaw;

@synthesize lateralTranslation;
@synthesize longitudinalTranslation;



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
        self.spacecraftImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SR-71-Color" ofType:@"png"]];
        
        self.x = [NSNumber numberWithFloat:0.0];
        self.y = [NSNumber numberWithFloat:0.0];
        self.z = [NSNumber numberWithFloat:0.0];
        
        self.pitch = [NSNumber numberWithFloat:0.0];
        self.roll = [NSNumber numberWithFloat:0.0];
        self.yaw = [NSNumber numberWithFloat:0.0];
        
        self.lateralTranslation = [NSNumber numberWithFloat:0.0];
        self.longitudinalTranslation = [NSNumber numberWithFloat:0.0];
    }
    return self;
}



#pragma mark - Translation Methods

//
// Translation Methods...very much in flux, so be patient and check to see if code has been updated.
//

- (void)lateralTranslationFromRoll:(NSNumber *)rollAngle
{
    self.lateralTranslation = [NSNumber numberWithDouble:[rollAngle doubleValue] * 4.0];
}



- (void)longitudinalTranslationFromThrust:(NSNumber *)thrust
{
    self.longitudinalTranslation = [NSNumber numberWithDouble:[thrust doubleValue] * 4.0];
}



@end
