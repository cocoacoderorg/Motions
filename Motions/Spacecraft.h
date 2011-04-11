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
    
    CGFloat             pitch;
    CGFloat             roll;
    CGFloat             yaw;
    
    CGFloat             lateralAcceration;
    CGFloat             longitudinalAcceleration;
}

@property (nonatomic, retain)       UIImage             *spacecraftImage;

@property (nonatomic, retain)       NSNumber            *x;
@property (nonatomic, retain)       NSNumber            *y;
@property (nonatomic, retain)       NSNumber            *z;

@property                           CGFloat             pitch;
@property                           CGFloat             roll;
@property                           CGFloat             yaw;

@property                           CGFloat             lateralAcceleration;
@property                           CGFloat             longitudinalAcceleration;

@end
