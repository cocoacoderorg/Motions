//
//  RootViewController.m
//  Motions
//
//  Created by James Hillhouse on 3/30/11.
//  Copyright 2011 PortableFrontier. All rights reserved.
//

#import "MotionsRootViewController.h"

#import "SimpleAcceleration.h"
#import "SimpleDeviceMotion.h"


@implementation MotionsRootViewController



@synthesize viewControllers;

@synthesize simpleAcceleration;
@synthesize simpleDeviceMotion;

@synthesize motionsTableViewCell;
@synthesize motionName;
@synthesize motionSummary;




#pragma mark - init & dealloc Methods

- (void)dealloc
{
    [viewControllers release];
    
    [simpleDeviceMotion release];
    
    [motionsTableViewCell release];
    [motionName release];
    [motionSummary release];
    
    [super dealloc];
}




#pragma mark - View Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDictionary    *screenshotDictionary1      = [[NSDictionary alloc] initWithObjectsAndKeys:@"Accelerometers", @"Name",
                                                   @"Accelerometers are nice...", @"Summary", nil];
    
    NSDictionary    *screenshotDictionary2      = [[NSDictionary alloc] initWithObjectsAndKeys:@"User Acceleration", @"Name",
                                                   @"Accelerometers are nice...", @"Summary", nil];
    
    NSDictionary    *screenshotDictionary3      = [[NSDictionary alloc] initWithObjectsAndKeys:@"Gyros", @"Name",
                                                   @"And gyros are pretty sweet...", @"Summary", nil];
    
    NSDictionary    *screenshotDictionary4      = [[NSDictionary alloc] initWithObjectsAndKeys:@"Device Motion", @"Name",
                                                   @"But device motion is the best.", @"Summary", nil];
    
    NSDictionary    *screenshotDictionary5      = [[NSDictionary alloc] initWithObjectsAndKeys:@"More Motion", @"Name",
                                                   @"We're not done just yet.", @"Summary", nil];
    
    NSArray         *anArray                    = [[NSArray alloc] initWithObjects:
                                                   screenshotDictionary1, 
                                                   screenshotDictionary2, 
                                                   screenshotDictionary3, 
                                                   screenshotDictionary4,
                                                   screenshotDictionary5, nil];
    
    self.viewControllers                        = anArray;
    
    [screenshotDictionary1 release];
    [screenshotDictionary2 release];
    [screenshotDictionary3 release];
    [screenshotDictionary4 release];
    [screenshotDictionary5 release];
    [anArray release];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}



- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}



- (void)viewDidUnload
{
    [super viewDidUnload];

    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    self.simpleDeviceMotion                     = nil;
    self.motionsTableViewCell                   = nil;
    self.motionName                             = nil;
    self.motionSummary                          = nil;
}




#pragma mark - Table View Delegate Methods

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */


// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.viewControllers count];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 100;
}



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MotionsCellIdentifier  = @"Cell";
    
    UITableViewCell *cell                   = [tableView dequeueReusableCellWithIdentifier:MotionsCellIdentifier];
    if (cell == nil) 
    {
        NSArray    *nibArray                = [[NSBundle mainBundle] loadNibNamed:@"MotionsTableViewCell" owner:self options:nil];
        
        if ( [nibArray count] > 0 ) 
        {
            cell                            = self.motionsTableViewCell;
        }
        else
        {
            NSLog(@"Uh oh, MotionsTableViewCell nib file didn't load.");
        }
    }
    
    // Configure the cell.
    NSUInteger row                          = [indexPath row];
    NSDictionary *rowData                   = [self.viewControllers objectAtIndex:row];
    
    self.motionName.text                    = [rowData objectForKey:@"Name"];
    self.motionSummary.text                 = [rowData objectForKey:@"Summary"];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/





- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row                          = [indexPath row];
    /*
    if ( row == 0 ) 
    {
        [self.navigationController pushViewController:self.uikitScreenshotViewController animated:YES];
    }
    */
    if ( row == 1 ) 
    {
        [self.navigationController pushViewController:self.simpleAcceleration animated:YES];
    }
    /*
    if ( row == 2 ) 
    {
        [self.navigationController pushViewController:self.uikitScreenshotViewController animated:YES];
    }
    */
    if ( row == 3 ) 
    {
        [self.navigationController pushViewController:self.simpleDeviceMotion animated:YES];
    }
    /*
    if ( row == 4 ) 
    {
        [self.navigationController pushViewController:self.combinedScreenshotViewController animated:YES];
    }
    */
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}




#pragma mark - Memory Management Methods

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

@end
