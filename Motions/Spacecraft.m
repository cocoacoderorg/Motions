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

@synthesize pitchTranslation;
@synthesize rollTranslation;
@synthesize yawTranslation;

@synthesize pitchSensitivity;
@synthesize rollSensitivity;
@synthesize yawSensitivity;



#pragma mark - init & dealloc methods

- (void)dealloc
{
    [spacecraftImage release];
    
    [x release];
    [y release];
    [z release];
    
    [pitch release];
    [roll release];
    [yaw release];
    
    [pitchTranslation release];
    [rollTranslation release];
    [yawTranslation release];
    
    [pitchSensitivity release];
    [rollSensitivity release];
    [yawSensitivity release];
    
    [super dealloc];
}



- (id)init
{
    if ((self = [super init])) 
    {
        self.spacecraftImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SR-71-Color" ofType:@"png"]];
        
        self.x = [NSNumber numberWithDouble:0.0];
        self.y = [NSNumber numberWithDouble:0.0];
        self.z = [NSNumber numberWithDouble:0.0];
        
        self.pitch = [NSNumber numberWithDouble:0.0];
        self.roll = [NSNumber numberWithDouble:0.0];
        self.yaw = [NSNumber numberWithDouble:0.0];
        
        self.pitchTranslation = [NSNumber numberWithDouble:0.0];
        self.rollTranslation = [NSNumber numberWithDouble:0.0];
        self.yawTranslation = [NSNumber numberWithDouble:0.0];
        
        self.pitchSensitivity = [NSNumber numberWithDouble:6.0];
        self.rollSensitivity = [NSNumber numberWithDouble:6.0];
        self.yawSensitivity = [NSNumber numberWithDouble:4.0];
    }
    
    NSLog(@"-init Pitch, roll, yaw = %f, %f, %f", [self.pitch floatValue], [self.roll floatValue], [self.yaw floatValue]);
    return self;
}



#pragma mark - Translation Methods

//
// Translation Methods...very much in flux, so be patient and check to see if code has been updated.
//

- (void)setPitchFromInput:(NSNumber *)pitchInput
{
    pitch = [NSNumber numberWithDouble:[pitchInput doubleValue]];
    self.pitchTranslation = [NSNumber numberWithDouble:[pitchInput doubleValue] * [self.pitchSensitivity doubleValue]];
}



- (void)setRollFromInput:(NSNumber *)rollInput
{
    roll = [NSNumber numberWithDouble:[rollInput doubleValue]];
    self.rollTranslation = [NSNumber numberWithDouble:[rollInput doubleValue] * [self.rollSensitivity doubleValue]];
}



- (void)setYawFromInput:(NSNumber *)yawInput
{
    yaw = [NSNumber numberWithDouble:[yawInput doubleValue]];
    self.yawTranslation = [NSNumber numberWithDouble:sin([yawInput doubleValue])];
}






@end
