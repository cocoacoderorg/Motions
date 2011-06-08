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

@synthesize xAccelTextField;
@synthesize yAccelTextField;

@synthesize spacecraft;




#pragma mark - View Controller Methods




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
//    CMMotionManager *aMotionManager = nil;
    
    id appDelegate = [UIApplication sharedApplication].delegate;
    if ([appDelegate respondsToSelector:@selector(motionManager)])
    {
        motionManager = [appDelegate motionManager];
    }
    return motionManager;
}




#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.userAccel = YES;
    
    
    //
    // Do any additional setup after loading the view from its nib.
    //
    self.spacecraft = [[Spacecraft alloc] init];
    
    self.motionManager.deviceMotionUpdateInterval = 1.0 / 80.0; // 80 Hz
    self.motionManager.accelerometerUpdateInterval = 1.0 / 40.0; // 40 Hz
    
    
    //
    // Variables for displayLink and animating the screen
    //
    animating = FALSE;
    animationFrameInterval = 1;
    self.displayLink = nil;
    
    self.craftImageView.image = self.spacecraft.spacecraftImage;
    
    translationX = 0.0;
    translationY = 0.0;
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
    //    self.defaultAttitude = self.motionManager.deviceMotion.attitude;
    self.userAccel = YES;
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.xAccelTextField = nil;
    self.yAccelTextField = nil;
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
        CADisplayLink *aDisplayLink = [[UIScreen mainScreen] displayLinkWithTarget:self selector:@selector(drawView)];
        [aDisplayLink setFrameInterval:animationFrameInterval];
        [aDisplayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        self.displayLink = aDisplayLink;
        
        animating = TRUE;
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



- (void)diplayCraftAttitudeData
{
    //
    // Don't forget to rework NSString for Localization
    //
    
    
    //
    // Display the updated data, the original data, and the bias data
    //
    NSNumber *xAccel = [NSNumber numberWithDouble:self.motionManager.deviceMotion.userAcceleration.x];
    NSString *xAccelString = [NSString stringWithFormat:@"%2.0f", [xAccel doubleValue]];
    xAccelString = [xAccelString stringByAppendingString:@"°"];
    self.xAccelTextField.text = xAccelString;
    
    
    NSNumber *yAccel = [NSNumber numberWithDouble:self.motionManager.deviceMotion.userAcceleration.y];
    NSString *yAccelString = [NSString stringWithFormat:@"%2.0f", [yAccel doubleValue]];
    yAccelString = [yAccelString stringByAppendingString:@"°"];
    self.yAccelTextField.text = yAccelString;
}



#define MOTION_USERACCEL_SCALE  35.0
#define MOTION_ACCEL_SCALE      10.0

- (void)craftTranslation
{
    CGRect mainViewFrame = self.view.frame;
    CGRect craftViewFrame = self.craftView.frame;
    
    
    //
    // Acceleration for left-right, front-back movement
    //
    if (self.userAccel) 
    {
        [self.spacecraft setLongitudinalTranslationFromInput:[NSNumber numberWithDouble:self.motionManager.deviceMotion.userAcceleration.y]];
        [self.spacecraft setLateralTranslationFromInput:[NSNumber numberWithDouble:self.motionManager.deviceMotion.userAcceleration.x]];
    }
    else
    {
        [self.spacecraft setLongitudinalTranslationFromInput:[NSNumber numberWithDouble:self.motionManager.accelerometerData.acceleration.y]];
        [self.spacecraft setLateralTranslationFromInput:[NSNumber numberWithDouble:self.motionManager.accelerometerData.acceleration.x]];
    }
    
    CGFloat accelMultiplier = ( TRUE == self.userAccel ) ? MOTION_USERACCEL_SCALE : MOTION_ACCEL_SCALE;

    //
    // X-Translation
    //
    craftViewFrame.origin.x += [self.spacecraft.lateralTranslation floatValue] * accelMultiplier;
    if ( !CGRectContainsRect(mainViewFrame, craftViewFrame ) )
    {
        craftViewFrame.origin.x = self.craftView.frame.origin.x;
    }
    
    //
    // Y-Translation
    //
    craftViewFrame.origin.y -= [self.spacecraft.longitudinalTranslation floatValue] * accelMultiplier;
    if ( !CGRectContainsRect(mainViewFrame, craftViewFrame ) )
    {
        craftViewFrame.origin.y = self.craftView.frame.origin.y;
    }    
    
    self.craftView.frame = craftViewFrame;
    
    self.spacecraft.x = [NSNumber numberWithFloat:self.craftView.center.x];
    self.spacecraft.y = [NSNumber numberWithFloat:self.craftView.center.y];
    self.spacecraft.z = [NSNumber numberWithFloat:self.craftView.layer.zPosition];
}




- (void)drawView
{
    [self diplayCraftAttitudeData];
    
    [self craftTranslation];
}



#pragma mark - Action Methods
- (IBAction)userAcceleration
{
    self.userAccel = ( TRUE == self.userAccel ) ? NO : YES;
    
    [self setDefaultAttitude];
}



- (IBAction)setDefaultAttitude
{
    self.defaultAttitude = self.motionManager.deviceMotion.attitude;
    self.craftView.center = CGPointMake(160.0, 260.0);
}


@end