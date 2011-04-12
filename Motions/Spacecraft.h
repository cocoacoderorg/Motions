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
    
    NSNumber            *lateralAcceration;
    NSNumber            *longitudinalAcceleration;
}

@property (nonatomic, retain)       UIImage             *spacecraftImage;

@property (nonatomic, retain)       NSNumber            *x;
@property (nonatomic, retain)       NSNumber            *y;
@property (nonatomic, retain)       NSNumber            *z;

@property (nonatomic, retain)       NSNumber            *pitch;
@property (nonatomic, retain)       NSNumber            *roll;
@property (nonatomic, retain)       NSNumber            *yaw;

@property (nonatomic, retain)       NSNumber            *lateralAcceleration;
@property (nonatomic, retain)       NSNumber            *longitudinalAcceleration;

@end
