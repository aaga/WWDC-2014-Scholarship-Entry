//
//  InitialViewController.m
//  Ashwin Agarwal
//
//  Created by Ashwin Agarwal on 05/04/2014.
//  Copyright (c) 2014 Ashwin Agarwal. All rights reserved.
//

#import "InitialViewController.h"

@interface InitialViewController ()

@end

@implementation InitialViewController

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
    // Hide everything initially
    for (UIView *subview in self.view.subviews) {
        subview.alpha = 0.0;
    }
    
    [super viewDidLoad];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    // Move labels down
    for (UIView *subview in self.view.subviews) {
        if (subview.tag != 3) {
            CGRect frame = subview.frame;
            frame.origin.y =  subview.frame.origin.y + 0.5*subview.frame.size.height;
            subview.frame = frame;
        }
    }
    
    // Animate intro
    for (UIView *subview in self.view.subviews) {
        [UIView animateWithDuration:1.0
                              delay:1.0 + subview.tag*1.5
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             subview.alpha = 1.0;
                             if (subview.tag != 3) {
                                 CGRect frame = subview.frame;
                                 frame.origin.y =  subview.frame.origin.y - 0.5*subview.frame.size.height;
                                 subview.frame = frame;
                             }
                         }
                         completion:^(BOOL finished){
                         }
         ];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextPressed:(UIButton *)sender {
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         // Fade subviews
                         for (UIView *subview in self.view.subviews) {
                             subview.alpha = 0;
                         }
                     }
                     completion:^(BOOL finished){
                         [self performSegueWithIdentifier:@"toIntro" sender:self];
                     }
     ];
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
