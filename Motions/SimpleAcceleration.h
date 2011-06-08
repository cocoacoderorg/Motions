//
//  SimpleAcceleration.h
//  Motions
//
//  Created by James Hillhouse on 4/10/11.
//  Copyright 2011 PortableFrontier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>


@class Spacecraft;


@interface SimpleAcceleration : UIViewController 
{    
    BOOL                            userAccel;
    
    CMMotionManager                 *motionManager;
    CMAttitude                      *deviceAttitude;
    CMAttitude                      *defaultAttitude;
    CMAcceleration                  *deviceAcceleration;
    
    CGFloat                         translationX;
    CGFloat                         translationY;
    
    BOOL                            animating;
    NSInteger                       animationFrameInterval;
    CADisplayLink                   *__unsafe_unretained displayLink;
    
    UIView                          *craftView;
    UIImageView                     *craftImageView;
    
    UITextField                     *xAccelTextField;
    UITextField                     *yAccelTextField;
    
    Spacecraft                      *spacecraft;
}

@property                                           BOOL                        userAccel;

// CADisplayLink Properties
@property (readonly, nonatomic, getter=isAnimating) BOOL                        animating;
@property (nonatomic)                               NSInteger                   animationFrameInterval;

@property (readonly)                                CMMotionManager             *motionManager;
@property (nonatomic, retain)                       CMAttitude                  *deviceAttitude;
@property (nonatomic, retain)                       CMAttitude                  *defaultAttitude;
@property (nonatomic, readwrite)                    CMAcceleration              *deviceAcceleration;

@property (nonatomic, retain)       IBOutlet        UIView                      *craftView;
@property (nonatomic, retain)       IBOutlet        UIImageView                 *craftImageView;

@property (nonatomic, retain)       IBOutlet        UITextField                 *xAccelTextField;
@property (nonatomic, retain)       IBOutlet        UITextField                 *yAccelTextField;

@property (nonatomic, retain)                       Spacecraft                  *spacecraft;


// Animation Methods
- (void)startAnimation;
- (void)stopAnimation;

// Roll, Pitch, Yaw Default Setting Method
- (IBAction)userAcceleration;
- (IBAction)setDefaultAttitude;


@end
