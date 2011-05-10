//
//  Motion.h
//  Motions
//
//  Created by James Hillhouse on 3/31/11.
//  Copyright 2011 PortableFrontier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@interface Spacecraft : NSObject 
{
    UIImage             *spacecraftImage;
    
    NSNumber            *x;
    NSNumber            *y;
    NSNumber            *z;
    
    NSNumber            *pitch;
    NSNumber            *roll;
    NSNumber            *yaw;
    
    NSNumber            *pitchTranslation;
    NSNumber            *rollTranslation;
    NSNumber            *yawTranslation;
    
    NSNumber            *pitchSensitivity;
    NSNumber            *rollSensitivity;
    NSNumber            *yawSensitivity;
}

@property (nonatomic, retain)       UIImage             *spacecraftImage;

@property (nonatomic, retain)       NSNumber            *x;
@property (nonatomic, retain)       NSNumber            *y;
@property (nonatomic, retain)       NSNumber            *z;

@property (nonatomic, retain, setter = setRollFromInput:)        NSNumber            *roll;
@property (nonatomic, retain, setter = setPitchFromInput:)       NSNumber            *pitch;
@property (nonatomic, retain, setter = setYawFromInput:)         NSNumber            *yaw;

@property (nonatomic, retain)       NSNumber            *pitchTranslation;
@property (nonatomic, retain)       NSNumber            *rollTranslation;
@property (nonatomic, retain)       NSNumber            *yawTranslation;

@property (nonatomic, retain)       NSNumber            *pitchSensitivity;
@property (nonatomic, retain)       NSNumber            *rollSensitivity;
@property (nonatomic, retain)       NSNumber            *yawSensitivity;



@end