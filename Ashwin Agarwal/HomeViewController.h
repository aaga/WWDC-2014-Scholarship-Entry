//
//  HomeViewController.h
//  Ashwin Agarwal
//
//  Created by Ashwin Agarwal on 04/04/2014.
//  Copyright (c) 2014 Ashwin Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicCircleView.h"

@interface HomeViewController : UIViewController

@property (nonatomic, strong)IBOutlet UIImageView *centerCircle;

@property (nonatomic, strong)IBOutletCollection(UIView) NSArray *topicCircleCollection;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UILabel *centerTopLabel;

@property (strong, nonatomic) IBOutlet UILabel *centerBottomLabel;

@end
