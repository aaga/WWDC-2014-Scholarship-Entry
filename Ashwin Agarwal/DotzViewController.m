//
//  DotzViewController.m
//  Ashwin Agarwal
//
//  Created by Ashwin Agarwal on 04/04/2014.
//  Copyright (c) 2014 Ashwin Agarwal. All rights reserved.
//

#import "DotzViewController.h"

@interface DotzViewController ()

@end

@implementation DotzViewController

@synthesize dotzWebView = _dotzWebView;
@synthesize dismissDotzView = _dismissDotzView;

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
    // Load up Dotz on the web view
    NSURL *dotzURL = [[NSBundle mainBundle] URLForResource:@"index" withExtension:@"html"];
    // NSURL *dotzURL = [NSURL URLWithString:@"http://www.mylazyfrog.com/dotztouch/"]; // online URL
    NSURLRequest *requestDotzURL = [NSURLRequest requestWithURL:dotzURL];
    [_dotzWebView loadRequest:requestDotzURL];
    
    // Disable pesky scrolling
    _dotzWebView.scrollView.scrollEnabled = NO;
    _dotzWebView.scrollView.bounces = NO;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)donePressed:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
