//
//  SimpleDeviceMotion.m
//  Motions
//
//  Created by James Hillhouse on 3/31/11.
//  Copyright 2011 PortableFrontier. All rights reserved.
//

#import "SimpleDeviceMotion.h"

#import <QuartzCore/QuartzCore.h>
#import <CoreMotion/CoreMotion.h>

#import "Spacecraft.h"
#import "HudView.h"



#define kMaxAngle 65.0



CGFloat nDegreesToRadians(CGFloat degrees) { return degrees * M_PI / 180.0; };
CGFloat nRadiansToDegrees(CGFloat radians) { return radians * 180.0 / M_PI; };



@interface SimpleDeviceMotion() 

@property (nonatomic, assign) CADisplayLink *displayLink;

- (void)transformCraftAttitudeInView;
- (void)craftAttitude;
- (void)diplayCraftAttitudeData;
- (void)craftTranslation;
- (void)gyroNotSupported;

@end


NSString *Show_HoverView = @"SHOW";


@implementation SimpleDeviceMotion



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

@synthesize hudView;
@synthesize settingsButton;

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
    // Do any additional setup after loading the view from its nib.
    self.spacecraft = [[Spacecraft alloc] init];

    self.motionManager.deviceMotionUpdateInterval = 1.0 / 80.0; // 60 Hz

    animating = FALSE;
    animationFrameInterval = 1;
    self.displayLink = nil;
    
    self.craftImageView.image = self.spacecraft.spacecraftImage;
    
    self.hudView.hudVisible = NO;
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
}



- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.pitchTextField = nil;
    self.rollTextField = nil;
    self.yawTextField = nil;
    
    self.origPitchTextField = nil;
    self.origRollTextField = nil;
    self.origYawTextField = nil;
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
    }
    else 
    {
        NSLog(@"Oops!");
        if ([self respondsToSelector:@selector(gyroNotSupported)]) 
        {
            [self gyroNotSupported];
        }
    }
}



- (void)stopAnimation
{
    //    NSLog(@"-stopAnimation");
    if (animating) 
    {
        [self.displayLink invalidate];
        self.displayLink = nil;
        animating = FALSE;
    }
    
    if (self.motionManager.isDeviceMotionActive)
    {
        [self.motionManager stopDeviceMotionUpdates];
     }
    else 
    {
        // Deal with this issue...
    }
}




- (void)craftAttitude
{
    //
    // Calibrate for defaultAttitude
    //
    self.deviceAttitude = self.motionManager.deviceMotion.attitude;
    
    if (self.defaultAttitude != nil) 
    {
        [self.deviceAttitude multiplyByInverseOfAttitude:self.defaultAttitude];
    }
    
        
    //
    // Send the motion input to the Spacecraft object
    //
/*
    if ( ( NSInteger )RadiansToDegrees( self.deviceAttitude.pitch ) < ( NSInteger )( kMaxAngle - 5.0 )  && ( NSInteger )RadiansToDegrees( self.deviceAttitude.pitch ) > ( NSInteger )( -kMaxAngle + 5.0 ) )
    {
        [self.spacecraft setPitchFromInput:[NSNumber numberWithDouble:self.deviceAttitude.pitch]];
    }
    else
    {
        [self.spacecraft setPitchFromInput:[NSNumber numberWithDouble:( M_PI / 3.0 < self.deviceAttitude.pitch ) ? M_PI / 3.0 : -M_PI / 3.0]];
    }
*/   
    [self.spacecraft setPitchFromInput:[NSNumber numberWithDouble:self.deviceAttitude.pitch]];
/*
    if ( ( NSInteger )RadiansToDegrees( self.deviceAttitude.roll ) < ( NSInteger )( kMaxAngle - 5.0 )  && ( NSInteger )RadiansToDegrees( self.deviceAttitude.roll ) > ( NSInteger )( -kMaxAngle + 5.0 ) )
    {
        [self.spacecraft setRollFromInput:[NSNumber numberWithDouble:self.deviceAttitude.roll]];
    }
    else
    {
         [self.spacecraft setRollFromInput:[NSNumber numberWithDouble:( M_PI / 3.0 < self.deviceAttitude.roll ) ? M_PI / 3.0 : -M_PI / 3.0]];
    }
*/
    [self.spacecraft setRollFromInput:[NSNumber numberWithDouble:self.deviceAttitude.roll]];
    
/*  if ( ( NSInteger )nRadiansToDegrees( self.deviceAttitude.yaw ) < ( NSInteger )( kMaxAngle - 5.0 )  && ( NSInteger )nRadiansToDegrees( self.deviceAttitude.yaw ) > ( NSInteger )( -kMaxAngle + 5.0 ) )
    {
        [self.spacecraft setYawFromInput:[NSNumber numberWithDouble:self.deviceAttitude.yaw]];
    }
    else
    {
        [self.spacecraft setYawFromInput:[NSNumber numberWithDouble:( M_PI / 3.0 < self.deviceAttitude.yaw ) ? M_PI / 3.0 : -M_PI / 3.0]];
    }
*/
     [self.spacecraft setYawFromInput:[NSNumber numberWithDouble:self.deviceAttitude.yaw]];
}



- (void)craftTranslation
{
    CGRect mainViewFrame = self.view.frame;
    CGRect craftViewFrame = self.craftView.frame;
    
    
    //
    // X-Translation
    //
    craftViewFrame.origin.x += [self.spacecraft.rollTranslation floatValue];
    if ( !CGRectContainsRect(mainViewFrame, craftViewFrame ) )
    {
        craftViewFrame.origin.x = self.craftView.frame.origin.x;
    }
    
    //
    // Y-Translation
    //
    craftViewFrame.origin.y += [self.spacecraft.pitchTranslation floatValue];
    if ( !CGRectContainsRect(mainViewFrame, craftViewFrame ) )
    {
        craftViewFrame.origin.y = self.craftView.frame.origin.y;
    }    
    
    self.craftView.frame = craftViewFrame;
    self.spacecraft.x = [NSNumber numberWithFloat:self.craftView.center.x];
    self.spacecraft.y = [NSNumber numberWithFloat:self.craftView.center.y];
    self.spacecraft.z = [NSNumber numberWithFloat:self.craftView.layer.zPosition];
}



- (void)transformCraftAttitudeInView
{
    CATransform3D transformedView = CATransform3DIdentity;
    transformedView.m34 = 1.0 / ( 100.0 * 1.0 );
    transformedView     = CATransform3DRotate(transformedView, [self.spacecraft.pitch floatValue], 1.0, 0.0, 0.0);
    transformedView     = CATransform3DRotate(transformedView, [self.spacecraft.roll floatValue], 0.0, -1.0, 0.0);
    transformedView     = CATransform3DRotate(transformedView, [self.spacecraft.yaw floatValue], 0.0, 0.0, -1.0);
    transformedView     = CATransform3DScale(transformedView, 1.0, 1.0, 1.0);
    
    self.craftView.layer.sublayerTransform = transformedView;
    self.craftView.layer.zPosition = 100.0;
   
    
//    CGAffineTransform translationTransform          = CGAffineTransformIdentity;
//    translationTransform                            = CGAffineTransformMakeTranslation(translationX, translationY);
//    
//    if ( ( translationTransform.tx > -60 && translationTransform.tx < 60) && ( translationTransform.ty > -100 && translationTransform.ty < 100 ) )
//    {
//        self.craftView.transform                    = translationTransform;
//        
//        oldTranslationX                             = translationX;
//        oldTranslationY                             = translationY;
//    }
//    else
//    {
//        self.craftView.transform                    = CGAffineTransformMakeTranslation(oldTranslationX, oldTranslationY);
//    }
//
//    NSLog(@"craftView.transform (tx, ty) = (%f, %f)", self.craftView.transform.tx, self.craftView.transform.ty);
}



- (void)diplayCraftAttitudeData
{
    //
    // Don't forget to rework NSString for Localization
    //
    
    
    //
    // Display the updated data, the original data, and the bias data
    //
    NSNumber *origPitchNumber = [NSNumber numberWithDouble:[self.spacecraft.pitch doubleValue] * 180.0 / M_PI];
    NSNumber *pitchNumber = [NSNumber numberWithDouble:self.deviceAttitude.pitch * 180.0 / M_PI];
    NSString *pitchString = [NSString stringWithFormat:@"%2.0f", [pitchNumber floatValue]];
    pitchString = [pitchString stringByAppendingString:@"°"];
    self.pitchTextField.text = pitchString;
    
    pitchString = [NSString stringWithFormat:@"%2.0f", [origPitchNumber floatValue]];
    pitchString = [pitchString stringByAppendingFormat:@"°"];
    self.origPitchTextField.text = pitchString;
    
    
    NSNumber *origRollNumber = [NSNumber numberWithDouble:[self.spacecraft.roll doubleValue] * 180.0 / M_PI];
    NSNumber *rollNumber = [NSNumber numberWithDouble:self.deviceAttitude.roll * 180.0 / M_PI];
    NSString *rollString = [NSString stringWithFormat:@"%2.0f", [rollNumber floatValue]];
    rollString = [rollString stringByAppendingString:@"°"];
    self.rollTextField.text = rollString;
    
    rollString = [NSString stringWithFormat:@"%2.0f", [origRollNumber floatValue]];
    rollString = [rollString stringByAppendingString:@"°"];
    self.origRollTextField.text = rollString;
    
    
    NSNumber *origYawNumber = [NSNumber numberWithDouble:[self.spacecraft.yaw doubleValue] * 180.0 / M_PI];
    NSNumber *yawNumber = [NSNumber numberWithDouble:self.deviceAttitude.yaw * 180.0 / M_PI];
    NSString *yawString = [NSString stringWithFormat:@"%2.0f", [yawNumber floatValue]];
    yawString = [yawString stringByAppendingString:@"°"];
    self.yawTextField.text = yawString;
    
    yawString = [NSString stringWithFormat:@"%2.0f", [origYawNumber floatValue]];
    yawString = [yawString stringByAppendingString:@"°"];
    self.origYawTextField.text = yawString;
}



- (void)drawView
{
    [self craftAttitude];
            
    [self transformCraftAttitudeInView];   
    
    [self craftTranslation];
    
    [self diplayCraftAttitudeData];
}



- (void)setDefaultAttitude
{
    NSLog(@"just reset attitude");
    self.defaultAttitude = self.motionManager.deviceMotion.attitude;
    
    //
    // Since we're using the craft's view's frame, this will recenter the view.
    //
    self.craftView.center = CGPointMake(160.0, 260.0);

    //
    // For centering a view that has been transformed via an Affine Transform.
    //
//    translationX = 0.0;
//    translationY = 0.0;
//    self.craftView.transform = CGAffineTransformMakeTranslation(translationX, translationX);
    
    [UIView animateWithDuration:0.5 animations:^{
        self.hudView.alpha = 0.0;
        self.hudView.hudVisible = NO;
    }];
}



#pragma mark -
#pragma mark Error Handling Methods

- (void) gyroNotSupported
{
    UIAlertView *alertView  = [[UIAlertView alloc] initWithTitle:@"Gyro Not Supported On This Device"
                                                         message:@"Gyro is not supported on your device. This prevents your device from using Core Motion Manager."
                                                        delegate:nil
                                               cancelButtonTitle:@"Okay"
                                               otherButtonTitles:nil];
    [alertView show];
    [alertView release];        
}



#pragma mark - Action Methods

- (IBAction)showHUD
{
    if (!self.hudView.hudVisible) 
    {
        //
        // Make the HUD view visible for some period
        //
        [UIView animateWithDuration:0.5 animations:^{
            
            //
            // Bring up the HUD
            //
            self.hudView.alpha = 1.0;
            self.hudView.hudVisible = YES;
            self.hudView.layer.zPosition = 200.0;
        }
                         completion:^( BOOL finished ){
                             if (finished) 
                             {
                                 //
                                 // Let the HUD remain visible
                                 //
                                 self.hudView.alpha = 1.0;
                                 self.hudView.layer.zPosition = 200.0;
                             }
                         }];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            
            //
            // Let the HUD remain visible
            //
            self.hudView.alpha = 0.0;
            self.hudView.hudVisible = NO;
        }];
        
    }
}


@end
