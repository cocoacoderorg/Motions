//
//  SimpleAcceleration.m
//  Motions
//
//  Created by James Hillhouse on 4/10/11.
//  Copyright 2011 PortableFrontier. All rights reserved.
//

#import "SimpleAcceleration.h"

#import <QuartzCore/QuartzCore.h>
#import <CoreMotion/CoreMotion.h>

#import "Spacecraft.h"



@interface SimpleAcceleration() 

@property (nonatomic, assign) CADisplayLink *displayLink;

- (void)transformCraftAttitudeInView;
- (void)craftAttitude;
//- (void)craftAcceleration; // not implemented.
- (void)diplayCraftAttitudeData;
- (void)craftTranslation;

@end


@implementation SimpleAcceleration



@synthesize userAccel;

@synthesize deviceAttitude;
@synthesize defaultAttitude;
@synthesize deviceAcceleration;

@synthesize displayLink;
@synthesize animating;
@synthesize animationFrameInterval;

@synthesize craftView;
@synthesize craftImageView;

@synthesize pitchTextField;
@synthesize rollTextField;
@synthesize yawTextField;

@synthesize origPitchTextField;
@synthesize origRollTextField;
@synthesize origYawTextField;

@synthesize spacecraft;




#pragma mark - View Controller Methods

- (void)dealloc
{
    [motionManager release];
    [deviceAttitude release];
    [defaultAttitude release];
    
    [displayLink release];
    
    [craftView release];
    [craftImageView release];
    
    [pitchTextField release];
    [rollTextField release];
    [yawTextField release];
    
    [origPitchTextField release];
    [origRollTextField release];
    [origYawTextField release];
    
    [spacecraft release];
    
    [super dealloc];
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self                                = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
    }
    return self;
}



- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}




#pragma mark - Device Motion Methods

- (CMMotionManager *)motionManager
{
//    CMMotionManager *aMotionManager                 = nil;
    
    id appDelegate                                  = [UIApplication sharedApplication].delegate;
    if ([appDelegate respondsToSelector:@selector(motionManager)])
    {
        motionManager                               = [appDelegate motionManager];
    }
    return motionManager;
}




#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.userAccel                                  = YES;
    
    // Do any additional setup after loading the view from its nib.
    self.spacecraft                                 = [[Spacecraft alloc] init];
    
    self.motionManager.deviceMotionUpdateInterval   = 1.0 / 40.0; // 40 Hz
    self.motionManager.accelerometerUpdateInterval  = 1.0 / 40.0;
    
    animating                                       = FALSE;
    animationFrameInterval                          = 1;
    self.displayLink                                = nil;
    
    self.craftImageView.image                       = self.spacecraft.spacecraftImage;
    
    translationX                                    = 0.0;
    translationY                                    = 0.0;
}



- (void)viewWillAppear:(BOOL)animated
{
    [self startAnimation];
    
    [super viewWillAppear:animated];
}



- (void)viewWillDisappear:(BOOL)animated
{
    [self stopAnimation];
    
    [super viewWillDisappear:animated];
}



- (void)viewDidAppear:(BOOL)animated
{
    //    self.defaultAttitude                            = self.motionManager.deviceMotion.attitude;
    self.userAccel                                  = YES;
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.pitchTextField                             = nil;
    self.rollTextField                              = nil;
    self.yawTextField                               = nil;
    
    self.origPitchTextField                         = nil;
    self.origRollTextField                          = nil;
    self.origYawTextField                           = nil;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}




#pragma mark - Animation Methods

//
// This is the template code from Apple's OpenGL ES Project.
//
- (NSInteger)animationFrameInterval
{
    return animationFrameInterval;
}



- (void)setAnimationFrameInterval:(NSInteger)frameInterval
{
    /*
	 Frame interval defines how many display frames must pass between each time the display link fires.
	 The display link will only fire 30 times a second when the frame internal is two on a display that refreshes 60 times a second. The default frame interval setting of one will fire 60 times a second when the display refreshes at 60 times a second. A frame interval setting of less than one results in undefined behavior.
	 */
    if (frameInterval >= 1) 
    {
        animationFrameInterval = frameInterval;
        
        if (animating) 
        {
            [self stopAnimation];
            [self startAnimation];
        }
    }
}



- (void)startAnimation
{
    //    NSLog(@"-startAnimation");
    
    //
    // This uses the "Pull" method for motion updates. One advantage of pulling motion updates is that they are called only when
    // needed. This can save battery life on the device.
    //
    if (!animating) 
    {
        //NSLog(@"animating was NO, now is YES");
        CADisplayLink *aDisplayLink                 = [[UIScreen mainScreen] displayLinkWithTarget:self selector:@selector(drawView)];
        [aDisplayLink setFrameInterval:animationFrameInterval];
        [aDisplayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        self.displayLink                            = aDisplayLink;
        
        animating                                   = TRUE;
    }
    
    if (self.motionManager.isDeviceMotionAvailable)
    {
        [self.motionManager startDeviceMotionUpdates];
        [self.motionManager startAccelerometerUpdates];
    }
    else 
    {
        // Deal with this issue...
    }
}



- (void)stopAnimation
{
    //    NSLog(@"-stopAnimation");
    if (animating) 
    {
        [self.displayLink invalidate];
        self.displayLink                            = nil;
        animating = FALSE;
    }
    
    if (self.motionManager.isDeviceMotionActive)
    {
        [self.motionManager stopDeviceMotionUpdates];
        [self.motionManager stopAccelerometerUpdates];
    }
    else 
    {
        // Deal with this issue...
    }
}



- (void)transformCraftAttitudeInView
{
    CATransform3D transformedView                   = CATransform3DIdentity;
    transformedView.m34                             = -1.0 / ( 100.0 * 10.0 );
    transformedView                                 = CATransform3DRotate(transformedView, [self.spacecraft.roll floatValue], 0.0, -1.0, 0.0);
    transformedView                                 = CATransform3DRotate(transformedView, [self.spacecraft.pitch floatValue], -1.0, 0.0, 0.0);
    transformedView                                 = CATransform3DRotate(transformedView, [self.spacecraft.yaw floatValue], 0.0, 0.0, -1.0);
    transformedView                                 = CATransform3DScale(transformedView, 1.0, 1.0, 1.0);
    self.craftView.layer.sublayerTransform          = transformedView;
    self.craftView.layer.zPosition                  = 100.0;
}



- (void)craftAttitude
{
    //
    // Calibrate for defaultAttitude
    //
    self.deviceAttitude                             = self.motionManager.deviceMotion.attitude;
    
    if (self.defaultAttitude != nil) 
    {
        [self.deviceAttitude multiplyByInverseOfAttitude:self.defaultAttitude];
    }
    
    //
    // Send the motion input to the Spacecraft object
    //
    if ( ( self.deviceAttitude.pitch ) < M_PI / 3.0  && ( self.deviceAttitude.pitch ) > -M_PI / 3.0 )
    {
        self.spacecraft.pitch                       = [NSNumber numberWithFloat:self.deviceAttitude.pitch]; 
    }
    
    if ( ( self.deviceAttitude.roll ) < M_PI / 3.0  && ( self.deviceAttitude.roll ) > -M_PI / 3.0 )
    {
        self.spacecraft.roll                        = [NSNumber numberWithFloat:self.deviceAttitude.roll];
    }
    
    if ( ( self.deviceAttitude.yaw ) < M_PI / 3.0  && ( self.deviceAttitude.yaw ) > -M_PI / 3.0 )
    {
        self.spacecraft.yaw                         = [NSNumber numberWithFloat:self.deviceAttitude.yaw];
    }
}



- (void)diplayCraftAttitudeData
{
    //
    // Don't forget to rework NSString for Localization
    //
    
    
    //
    // Display the updated data, the original data, and the bias data
    //
    NSNumber *origPitchNumber                       = [NSNumber numberWithDouble:self.motionManager.deviceMotion.attitude.pitch * 180.0 / M_PI];
    NSNumber *pitchNumber                           = [NSNumber numberWithDouble:self.deviceAttitude.pitch * 180.0 / M_PI];
    NSString *pitchString                           = [NSString stringWithFormat:@"%2.0f", [pitchNumber doubleValue]];
    pitchString                                     = [pitchString stringByAppendingString:@"°"];
    self.pitchTextField.text                        = pitchString;
    
    pitchString                                     = [NSString stringWithFormat:@"%2.0f", [origPitchNumber doubleValue]];
    pitchString                                     = [pitchString stringByAppendingFormat:@"°"];
    self.origPitchTextField.text                    = pitchString;
    
    
    NSNumber *origRollNumber                        = [NSNumber numberWithDouble:self.motionManager.deviceMotion.attitude.roll * 180.0 / M_PI];
    NSNumber *rollNumber                            = [NSNumber numberWithDouble:self.deviceAttitude.roll * 180.0 / M_PI];
    NSString *rollString                            = [NSString stringWithFormat:@"%2.0f", [rollNumber doubleValue]];
    rollString                                      = [rollString stringByAppendingString:@"°"];
    self.rollTextField.text                         = rollString;
    
    rollString                                      = [NSString stringWithFormat:@"%2.0f", [origRollNumber doubleValue]];
    rollString                                      = [rollString stringByAppendingString:@"°"];
    self.origRollTextField.text                     = rollString;
    
    
    NSNumber *origYawNumber                         = [NSNumber numberWithDouble:self.motionManager.deviceMotion.attitude.yaw * 180.0 / M_PI];
    NSNumber *yawNumber                             = [NSNumber numberWithDouble:self.deviceAttitude.yaw * 180.0 / M_PI];
    NSString *yawString                             = [NSString stringWithFormat:@"%2.0f", [yawNumber doubleValue]];
    yawString                                       = [yawString stringByAppendingString:@"°"];
    self.yawTextField.text                          = yawString;
    
    yawString                                       = [NSString stringWithFormat:@"%2.0f", [origYawNumber doubleValue]];
    yawString                                       = [yawString stringByAppendingString:@"°"];
    self.origYawTextField.text                      = yawString;
}



#define MOTION_USERACCEL_SCALE  35.0
#define MOTION_ACCEL_SCALE      10.0

- (void)craftTranslation
{
    CGRect mainViewFrame                            = self.view.frame;
    CGRect craftViewFrame                           = self.craftView.frame;
    
    
    //
    // Acceleration for left-right, front-back movement
    //
    if (self.userAccel) 
    {
        self.spacecraft.lateralAcceleration         = [NSNumber numberWithDouble:self.motionManager.deviceMotion.userAcceleration.x];
        self.spacecraft.longitudinalAcceleration    = [NSNumber numberWithDouble:self.motionManager.deviceMotion.userAcceleration.y];
    }
    else
    {
        self.spacecraft.lateralAcceleration         = [NSNumber numberWithDouble:self.motionManager.accelerometerData.acceleration.x];
        self.spacecraft.longitudinalAcceleration    = [NSNumber numberWithDouble:self.motionManager.accelerometerData.acceleration.y];
    }
    
    CGFloat accelMultiplier                         = ( self.userAccel == TRUE ) ? MOTION_USERACCEL_SCALE : MOTION_ACCEL_SCALE;

    //
    // X-Translation
    //
    craftViewFrame.origin.x                         += [self.spacecraft.lateralAcceleration floatValue] * accelMultiplier;
    if ( !CGRectContainsRect(mainViewFrame, craftViewFrame ) )
    {
        craftViewFrame.origin.x                     = self.craftView.frame.origin.x;
    }
    
    //
    // Y-Translation
    //
    craftViewFrame.origin.y                         -= [self.spacecraft.longitudinalAcceleration floatValue] * accelMultiplier;
    if ( !CGRectContainsRect(mainViewFrame, craftViewFrame ) )
    {
        craftViewFrame.origin.y                     = self.craftView.frame.origin.y;
    }    
    
    self.craftView.frame                            = craftViewFrame;
    
    self.spacecraft.x                               = [NSNumber numberWithFloat:self.craftView.center.x];
    self.spacecraft.y                               = [NSNumber numberWithFloat:self.craftView.center.y];
    self.spacecraft.z                               = [NSNumber numberWithFloat:self.craftView.layer.zPosition];
}




- (void)drawView
{
    [self craftAttitude];
    
//    [self transformCraftAttitudeInView];   
    
    [self diplayCraftAttitudeData];
    
    [self craftTranslation];
}



#pragma mark - Action Methods
- (IBAction)userAcceleration
{
    self.userAccel                                  = ( self.userAccel == TRUE ) ? NO : YES;
    
    [self setDefaultAttitude];
}



- (IBAction)setDefaultAttitude
{
    self.defaultAttitude                            = self.motionManager.deviceMotion.attitude;
    self.craftView.center                           = CGPointMake(160.0, 260.0);
}


@end