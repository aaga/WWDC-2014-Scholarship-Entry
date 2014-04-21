//
//  EducationViewController.m
//  Ashwin Agarwal
//
//  Created by Ashwin Agarwal on 08/04/2014.
//  Copyright (c) 2014 Ashwin Agarwal. All rights reserved.
//

#import "EducationViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>

@interface EducationViewController ()<CLLocationManagerDelegate>

@end

@implementation EducationViewController {
    CLLocationCoordinate2D schoolCoordinates;
    CLLocationManager *locationManager;
}

@synthesize titleLabel = _titleLabel;
@synthesize timeLabel = _timeLabel;
@synthesize distanceLabel = _distanceLabel;
@synthesize schoolMap = _schoolMap;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    // Hide everthing initially
    for (UIView *subview in self.view.subviews) {
        subview.alpha = 0.0;
    }
    
    [super viewDidLoad];
    
    // Call updateTime initially
    [self updateTime];
    
    // Update distance label
    [self updateDistance];
    
    // Set map region
    schoolCoordinates =  CLLocationCoordinate2DMake(51.492066, -0.609452);
    MKCoordinateSpan mapSpan = MKCoordinateSpanMake(0.004, 0.004);
    MKCoordinateRegion mapRegion = MKCoordinateRegionMake(schoolCoordinates, mapSpan);
    
    _schoolMap.region = mapRegion;
    _schoolMap.mapType = MKMapTypeSatellite;
    
    // Now fade everything in
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _titleLabel.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                     }
     ];
    
    [UIView animateWithDuration:0.5
                          delay:0.5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         for (UIView *subview in self.view.subviews) {
                             subview.alpha = 1.0;
                         }
                     }
                     completion:^(BOOL finished){
                     }
     ];
}

- (void)updateTime
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"h:mm:ss a"];
    
    NSTimeZone *gmtZone = [NSTimeZone timeZoneWithName:@"Europe/London"];
    [dateFormat setTimeZone:gmtZone];
    
    _timeLabel.text = [dateFormat stringFromDate:[NSDate date]];
    
    // Call updateTime again after 1 second
    [self performSelector:@selector(updateTime) withObject:self afterDelay:1.0];
}

- (void)updateDistance
{
    if (nil == locationManager)
        locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    [locationManager startMonitoringSignificantLocationChanges];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *deviceLocation = [locations lastObject];
   
    CLLocation *schoolLocation = [[CLLocation alloc] initWithLatitude:schoolCoordinates.latitude longitude:schoolCoordinates.longitude];
    
    CLLocationDistance distanceToSchool = [schoolLocation distanceFromLocation:deviceLocation];
    
    _distanceLabel.text = [NSString stringWithFormat:@"%i miles", (int)(distanceToSchool/1609.344)];
}


- (IBAction)returnPressed:(UIButton *)sender {
    // Fade out subviews, fade to white
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         for (UIView *subview in self.view.subviews) {
                             subview.alpha = 0;
                         }
                         self.view.backgroundColor = [UIColor whiteColor];
                     }
                     completion:^(BOOL finished){
                         [locationManager stopMonitoringSignificantLocationChanges];
                         [self.navigationController popViewControllerAnimated:NO];
                     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
