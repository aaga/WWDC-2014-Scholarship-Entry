//
//  DotzViewController.h
//  Ashwin Agarwal
//
//  Created by Ashwin Agarwal on 04/04/2014.
//  Copyright (c) 2014 Ashwin Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DotzViewController : UIViewController

@property (nonatomic, strong)IBOutlet UIWebView *dotzWebView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *dismissDotzView;

@end
