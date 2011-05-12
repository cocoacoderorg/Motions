//
//  Motion.m
//  Motions
//
//  Created by James Hillhouse on 3/31/11.
//  Copyright 2011 PortableFrontier. All rights reserved.
//




#import "Spacecraft.h"

#import <UIKit/UIKit.h>


#define kMaxPitchAngle  65.0
#define kMaxRollAngle   65.0
#define kMaxYawAngle    65.0




CGFloat DegreesToRadians(CGFloat degrees) { return degrees * M_PI / 180.0; };
CGFloat RadiansToDegrees(CGFloat radians) { return radians * 180.0 / M_PI; };



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

@synthesize longitudinalTranslation;
@synthesize lateralTranslation;
@synthesize verticalTranslation;


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

- (void)setPitchFromInput:(NSNumber *)pitchInput
{    
    if ( ( NSInteger )RadiansToDegrees( [pitchInput floatValue] ) < ( NSInteger )( kMaxRollAngle - 5.0 )  && ( NSInteger )RadiansToDegrees( [pitchInput floatValue] ) > ( NSInteger )( -kMaxPitchAngle + 5.0 ) )
    {
        pitch = [NSNumber numberWithDouble:[pitchInput doubleValue]];
        self.pitchTranslation = [NSNumber numberWithDouble:[pitchInput doubleValue] * [self.pitchSensitivity doubleValue]];
    }
    else
    {
        pitch = [NSNumber numberWithDouble:( M_PI / 3.0 < [pitchInput floatValue] ) ? M_PI / 3.0 : -M_PI / 3.0];
        self.pitchTranslation = [NSNumber numberWithDouble:[pitchInput doubleValue] * [self.pitchSensitivity doubleValue]];
    }
}



- (void)setRollFromInput:(NSNumber *)rollInput
{
    if ( ( NSInteger )RadiansToDegrees( [rollInput floatValue] ) < ( NSInteger )( kMaxRollAngle - 5.0 )  && ( NSInteger )RadiansToDegrees( [rollInput floatValue] ) > ( NSInteger )( -kMaxRollAngle + 5.0 ) )
    {
        roll = [NSNumber numberWithDouble:[rollInput doubleValue]];
        self.rollTranslation = [NSNumber numberWithDouble:[rollInput doubleValue] * [self.rollSensitivity doubleValue]];
    }
    else
    {
        roll = [NSNumber numberWithDouble:( M_PI / 3.0 < [rollInput floatValue] ) ? M_PI / 3.0 : -M_PI / 3.0];
        self.rollTranslation = [NSNumber numberWithDouble:[rollInput doubleValue] * [self.rollSensitivity doubleValue]];
    }
}



- (void)setYawFromInput:(NSNumber *)yawInput
{
    if ( ( NSInteger )RadiansToDegrees( [yawInput floatValue] ) < ( NSInteger )( kMaxYawAngle - 5.0 )  && ( NSInteger )RadiansToDegrees( [yawInput floatValue] ) > ( NSInteger )( -kMaxYawAngle + 5.0 ) )
    {
        yaw = [NSNumber numberWithDouble:[yawInput doubleValue]];
        self.yawTranslation = [NSNumber numberWithDouble:[yawInput doubleValue] * [self.yawSensitivity doubleValue]];
    }
    else
    {
        yaw = [NSNumber numberWithDouble:( M_PI / 3.0 < [yawInput floatValue] ) ? M_PI / 3.0 : -M_PI / 3.0];
        self.yawTranslation = [NSNumber numberWithDouble:[yawInput doubleValue] * [self.yawSensitivity doubleValue]];
    }
}



- (void)setLongitudinalTranslationFromInput:(NSNumber *)longitudinalInput
{
    longitudinalTranslation = [NSNumber numberWithDouble:[longitudinalInput doubleValue]];
}



- (void)setLateralTranslationFromInput:(NSNumber *)lateralInput
{
    lateralTranslation = [NSNumber numberWithDouble:[lateralInput doubleValue]];
}



- (void)setVerticalTranslationFromInput:(NSNumber *)verticalInput
{
    verticalTranslation = [NSNumber numberWithDouble:[verticalInput doubleValue]];
}


@end
