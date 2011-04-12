//
//  RootViewController.h
//  Motions
//
//  Created by James Hillhouse on 3/30/11.
//  Copyright 2011 PortableFrontier. All rights reserved.
//

#import <UIKit/UIKit.h>




@class SimpleAcceleration;
@class SimpleDeviceMotion;



@interface MotionsRootViewController : UITableViewController 
{
    UITableViewCell                 *motionsTableViewCell;
    UILabel                         *motionName;
    UILabel                         *motionSummary;
}

@property (nonatomic, retain)                       NSArray                     *viewControllers;

@property (nonatomic, retain)       IBOutlet        SimpleAcceleration          *simpleAcceleration;
@property (nonatomic, retain)       IBOutlet        SimpleDeviceMotion          *simpleDeviceMotion;

@property (nonatomic, retain)       IBOutlet        UITableViewCell             *motionsTableViewCell;
@property (nonatomic, retain)       IBOutlet        UILabel                     *motionName;
@property (nonatomic, retain)       IBOutlet        UILabel                     *motionSummary;


@end
