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
    CMMotionManager                 *motionManager;
    CMAttitude                      *deviceAttitude;
    CMAttitude                      *defaultAttitude;
    CMAcceleration                  *deviceAcceleration;
    
    CGFloat                         translationX;
    CGFloat                         translationY;
    
    BOOL                            animating;
    NSInteger                       animationFrameInterval;
    CADisplayLink                   *displayLink;
    
    UIImageView                     *craftImageView;
    
    UITextField                     *pitchTextField;
    UITextField                     *rollTextField;
    UITextField                     *yawTextField;
    
    UITextField                     *origPitchTextField;
    UITextField                     *origRollTextField;
    UITextField                     *origYawTextField;
    
    Spacecraft                      *spacecraft;
}

// CADisplayLink Properties
@property (readonly, nonatomic, getter=isAnimating) BOOL                        animating;
@property (nonatomic)                               NSInteger                   animationFrameInterval;

@property (readonly)                                CMMotionManager             *motionManager;
@property (nonatomic, retain)                       CMAttitude                  *deviceAttitude;
@property (nonatomic, retain)                       CMAttitude                  *defaultAttitude;
@property (nonatomic, readwrite)                       CMAcceleration              *deviceAcceleration;

@property (nonatomic, retain)       IBOutlet        UIImageView                 *craftImageView;

@property (nonatomic, retain)       IBOutlet        UITextField                 *pitchTextField;
@property (nonatomic, retain)       IBOutlet        UITextField                 *rollTextField;
@property (nonatomic, retain)       IBOutlet        UITextField                 *yawTextField;

@property (nonatomic, retain)       IBOutlet        UITextField                 *origPitchTextField;
@property (nonatomic, retain)       IBOutlet        UITextField                 *origRollTextField;
@property (nonatomic, retain)       IBOutlet        UITextField                 *origYawTextField;

@property (nonatomic, retain)                       Spacecraft                  *spacecraft;


// Animation Methods
- (void)startAnimation;
- (void)stopAnimation;

// Roll, Pitch, Yaw Default Setting Method
- (IBAction)setDefaultAttitude;


@end
