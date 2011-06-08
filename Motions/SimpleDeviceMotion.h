//
//  SimpleDeviceMotion.h
//  Motions
//
//  Created by James Hillhouse on 3/31/11.
//  Copyright 2011 PortableFrontier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>


@class Spacecraft;
@class HudView;


extern NSString *Show_HoverView;


@interface SimpleDeviceMotion : UIViewController 
{    
    CMMotionManager                 *motionManager;
    CMAttitude                      *deviceAttitude;
    CMAttitude                      *defaultAttitude;
    CMAcceleration                  *deviceAcceleration;
    
    NSInteger                       oldTranslationX;
    NSInteger                       translationX;
    
    NSInteger                       oldTranslationY;
    NSInteger                       translationY;
    
    BOOL                            animating;
    NSInteger                       animationFrameInterval;

    CADisplayLink                   *__unsafe_unretained displayLink;
    
    UIView                          *craftView;
    UIImageView                     *craftImageView;
    
    UITextField                     *pitchTextField;
    UITextField                     *rollTextField;
    UITextField                     *yawTextField;
    
    UITextField                     *origPitchTextField;
    UITextField                     *origRollTextField;
    UITextField                     *origYawTextField;
    
    HudView                         *hudView;
	UIButton                        *settingsButton;
    
    Spacecraft                      *spacecraft;
    UIButton *myLilOtherButton;
}

// CADisplayLink Properties
@property (readonly)                                CMMotionManager             *motionManager;
@property (nonatomic, retain)                       CMAttitude                  *deviceAttitude;
@property (nonatomic, retain)                       CMAttitude                  *defaultAttitude;
@property (nonatomic, readwrite)                    CMAcceleration              *deviceAcceleration;

@property (readonly, nonatomic, getter=isAnimating) BOOL                        animating;
@property (nonatomic)                               NSInteger                   animationFrameInterval;

@property (nonatomic, retain)       IBOutlet        UIView                      *craftView;
@property (nonatomic, retain)       IBOutlet        UIImageView                 *craftImageView;

@property (nonatomic, retain)       IBOutlet        UITextField                 *pitchTextField;
@property (nonatomic, retain)       IBOutlet        UITextField                 *rollTextField;
@property (nonatomic, retain)       IBOutlet        UITextField                 *yawTextField;

@property (nonatomic, retain)       IBOutlet        UITextField                 *origPitchTextField;
@property (nonatomic, retain)       IBOutlet        UITextField                 *origRollTextField;
@property (nonatomic, retain)       IBOutlet        UITextField                 *origYawTextField;

@property (nonatomic, retain)       IBOutlet        HudView                     *hudView;
@property (nonatomic, retain)       IBOutlet        UIButton                    *settingsButton;           

@property (nonatomic, retain)                       Spacecraft                  *spacecraft;


// Animation Methods
- (void)startAnimation;
- (void)stopAnimation;

// Roll, Pitch, Yaw Default Setting Method
- (IBAction)showHUD;
- (IBAction)setDefaultAttitude;


@end
