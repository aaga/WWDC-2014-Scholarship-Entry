//
//  EducationViewController.h
//  Ashwin Agarwal
//
//  Created by Ashwin Agarwal on 08/04/2014.
//  Copyright (c) 2014 Ashwin Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface EducationViewController : UIViewController

@property (nonatomic, strong)IBOutlet UILabel *timeLabel;

@property (nonatomic, strong)IBOutlet UILabel *distanceLabel;

@property (nonatomic, strong)IBOutlet MKMapView *schoolMap;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@end
