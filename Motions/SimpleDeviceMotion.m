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



@interface SimpleDeviceMotion() 

@property (nonatomic, assign) CADisplayLink *displayLink;

- (void)transformCraftAttitudeInView;
- (void)craftAttitude;
- (void)diplayCraftAttitudeData;
- (void)craftTranslation;

@end



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
    // Do any additional setup after loading the view from its nib.
    self.spacecraft                                 = [[Spacecraft alloc] init];

    self.motionManager.deviceMotionUpdateInterval   = 1.0 / 40.0; // 50 Hz

    animating                                       = FALSE;
    animationFrameInterval                          = 1;
    self.displayLink                                = nil;
    
    self.craftImageView.image                       = self.spacecraft.spacecraftImage;
    
//    translationX                                    = 0.0;
//    translationY                                    = 0.0;
    
    NSLog(@"main view frame = (%f, %f, %f, %f)\n\n", self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
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
    self.craftView                                  = nil;
    self.craftImageView                             = nil;

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
     }
    else 
    {
        // Deal with this issue...
    }
}



- (void)transformCraftAttitudeInView
{
    CATransform3D transformedView                   = CATransform3DIdentity;
//    transformedView.m34                           = -1.0 / ( 100.0 * self.perspective );
    transformedView.m34                             = -1.0 / ( 100.0 * 10.0 );
    transformedView                                 = CATransform3DRotate(transformedView, self.spacecraft.roll, 0.0, -1.0, 0.0);
    transformedView                                 = CATransform3DRotate(transformedView, self.spacecraft.pitch, -1.0, 0.0, 0.0);
    transformedView                                 = CATransform3DRotate(transformedView, self.spacecraft.yaw, 0.0, 0.0, -1.0);
    transformedView                                 = CATransform3DScale(transformedView, 1.0, 1.0, 1.0);
    self.craftView.layer.sublayerTransform          = transformedView;
    self.craftView.layer.zPosition                  = 100.0;
   
    
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
        self.spacecraft.pitch                       = (CGFloat)self.deviceAttitude.pitch; 
    }
    
    if ( ( self.deviceAttitude.roll ) < M_PI / 3.0  && ( self.deviceAttitude.roll ) > -M_PI / 3.0 )
    {
        self.spacecraft.roll                        = (CGFloat)self.deviceAttitude.roll;
    }
    
    if ( ( self.deviceAttitude.yaw ) < M_PI / 3.0  && ( self.deviceAttitude.yaw ) > -M_PI / 3.0 )
    {
        self.spacecraft.yaw                         = (CGFloat)self.deviceAttitude.yaw;
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



#define MOTION_SCALE  4.0;

- (void)craftTranslation
{
//    translationX                                    += self.spacecraft.roll * MOTION_SCALE;
//    translationY                                    += self.spacecraft.pitch * MOTION_SCALE;
    
    CGRect mainViewFrame                            = self.view.frame;
    CGRect craftViewFrame                           = self.craftView.frame;
    
    //
    // X-Translation
    //
    craftViewFrame.origin.x                         += self.spacecraft.roll * MOTION_SCALE;
    if ( !CGRectContainsRect(mainViewFrame, craftViewFrame ) )
    {
        craftViewFrame.origin.x                     = self.craftView.frame.origin.x;
    }
    
    //
    // Y-Translation
    //
    craftViewFrame.origin.y                         += self.spacecraft.pitch * MOTION_SCALE;
    if ( !CGRectContainsRect(mainViewFrame, craftViewFrame ) )
    {
        craftViewFrame.origin.y                     = self.craftView.frame.origin.y;
    }    
    
    self.craftView.frame                            = craftViewFrame;
}



- (void)drawView
{
    [self craftAttitude];
            
    [self transformCraftAttitudeInView];   
    
    [self diplayCraftAttitudeData];
    
    [self craftTranslation];
}



- (IBAction)setDefaultAttitude
{
    self.defaultAttitude                            = self.motionManager.deviceMotion.attitude;
    self.craftView.center                           = CGPointMake(160.0, 230.0);

    //
    // For centering a view that has been transformed via an Affine Transform.
    //
//    translationX                                    = 0.0;
//    translationY                                    = 0.0;
//    self.craftView.transform                        = CGAffineTransformMakeTranslation(translationX, translationX);
}


@end
