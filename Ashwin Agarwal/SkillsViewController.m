//
//  SkillsViewController.m
//  Ashwin Agarwal
//
//  Created by Ashwin Agarwal on 08/04/2014.
//  Copyright (c) 2014 Ashwin Agarwal. All rights reserved.
//

#import "SkillsViewController.h"

@interface SkillsViewController ()

@end

@implementation SkillsViewController
@synthesize titleLabel = _titleLabel;

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
    
    // Now fade everything in
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _titleLabel.alpha = 1.0;
                     }
                     completion:^(BOOL finished){}
     ];
    
    [UIView animateWithDuration:0.5
                          delay:0.5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         for (UIView *subview in self.view.subviews) {
                             subview.alpha = 1.0;
                         }
                     }
                     completion:^(BOOL finished){}
     ];
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
