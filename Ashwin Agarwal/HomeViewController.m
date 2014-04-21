//
//  HomeViewController.m
//  Ashwin Agarwal
//
//  Created by Ashwin Agarwal on 04/04/2014.
//  Copyright (c) 2014 Ashwin Agarwal. All rights reserved.
//

#import "HomeViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface HomeViewController ()

@end

@implementation HomeViewController {
    float originX, originY, oldX, oldY;
    BOOL dragging;
    NSArray *segueIdentifiers;
}

@synthesize centerCircle = _centerCircle;
@synthesize topicCircleCollection = _topicCircleCollection;
@synthesize titleLabel = _titleLabel;
@synthesize centerTopLabel = _centerTopLabel;
@synthesize centerBottomLabel = _centerBottomLabel;

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
    
    // Save original coordinates for center circle
    originX = _centerCircle.frame.origin.x;
    originY = _centerCircle.frame.origin.y;
    
    // Make circles circular
    _centerCircle.layer.cornerRadius = _centerCircle.frame.size.height /2;
    _centerCircle.layer.masksToBounds = YES;
    _centerCircle.layer.borderWidth = 0;
    
    for (TopicCircleView *topicCircle in _topicCircleCollection) {
        topicCircle.layer.cornerRadius = topicCircle.frame.size.height /2;
        topicCircle.layer.masksToBounds = YES;
        topicCircle.layer.borderWidth = 0;
    }
    
    // Bring center circle to front and add border
    [self.view bringSubviewToFront:_centerCircle];
    
    UIView *borderView = [self.view viewWithTag:10];
    borderView.layer.borderWidth = 5;
    borderView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    borderView.layer.cornerRadius = borderView.frame.size.height /2;
    borderView.layer.masksToBounds = YES;
    
    
    // Initialize segueIdentifiers array
    segueIdentifiers = [NSArray arrayWithObjects:@"zero", @"iOS Development", @"Web Development", @"Skills", @"Education", @"Other Stuff", nil];
    
    // Just in case selector gets left over
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(pulseImage) object:nil];
    
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    // Hide everthing initially
    for (UIView *subview in self.view.subviews) {
        subview.alpha = 0.0;
    }
    
    // Now fade everything in
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _titleLabel.alpha = 1.0;
                     }
                     completion:^(BOOL finished){}
     ];
    
    [UIView animateWithDuration:0.5
                          delay:1.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         for (UIView *subview in self.view.subviews) {
                             subview.alpha = 1.0;
                         }
                     }
                     completion:^(BOOL finished){
                         // Flash instructions initially
                         [self performSelector:@selector(pulseImage) withObject:nil afterDelay:3.0];
                     }
     ];
}

#pragma mark - Touch Handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    UITouch *touch = [event.allTouches anyObject];
    
    // Cancel flashing
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(pulseImage) object:nil];
    
    // Only want touches inside the circle to count. Using equation for a circle...
    CGPoint touchLocation = [touch locationInView:touch.view];
    double touchX = touchLocation.x - _centerCircle.frame.origin.x - _centerCircle.frame.size.width /2 ;
    double touchY = touchLocation.y - _centerCircle.frame.origin.y - _centerCircle.frame.size.height /2 ;
    double squaredDistance = pow((touchX),2) + pow((touchY),2) ;
    double radiusSquared = pow((_centerCircle.frame.size.height /2),2) ;

    if (squaredDistance < radiusSquared) {
        dragging = YES;
        [self resizeLayer:_centerCircle.layer to:CGSizeMake(200, 200) withDuration:0.2 performSegue:nil];
        
        // Update labels
        [self changeLabelText:_centerTopLabel toText:@"Release to" withDuration:0.2];
        [self changeLabelText:_centerBottomLabel toText:@"cancel" withDuration:0.2];
        
        // Hide border
        [self toggleAlpha:[self.view viewWithTag:10] withDuration:0.2];
        
        // Follow finger exactly
        oldX = touchLocation.x - _centerCircle.frame.origin.x;
        oldY = touchLocation.y - _centerCircle.frame.origin.y;
    }
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *movingTouch = [event.allTouches anyObject];
    CGPoint movingTouchLocation = [movingTouch locationInView:self.view];
    
    if (dragging) {
        
        // Move center circle to follow finger
        CGRect frame = _centerCircle.frame;
        frame.origin.x = movingTouchLocation.x - oldX;
        frame.origin.y =  movingTouchLocation.y - oldY;
        _centerCircle.frame = frame;
        
        // Expand or collapse activity circle if finger is inside or outside respectively
        for (TopicCircleView *topicCircle in _topicCircleCollection) {
            
            if (CGRectContainsPoint(topicCircle.frame, movingTouchLocation) && !topicCircle.expanded) {
                [self resizeLayer:topicCircle.layer to:CGSizeMake(240, 240) withDuration:0.2 performSegue:nil];
                
                [self toggleAlpha:topicCircle.description withDuration:0.2];
                [self toggleAlpha:topicCircle.icon withDuration:0.2];
                
                // Update labels
                [self changeLabelText:_centerTopLabel toText:@"Release to learn about" withDuration:0.2];
                [self changeLabelText:_centerBottomLabel toText:[NSString stringWithFormat:@"my %@", segueIdentifiers[topicCircle.tag]] withDuration:0.2];
                                
                topicCircle.expanded = YES;
            }
            else if (!CGRectContainsPoint(topicCircle.frame, movingTouchLocation) && topicCircle.expanded){
                [self resizeLayer:topicCircle.layer to:CGSizeMake(150,150) withDuration:0.2 performSegue:nil];
                
                [self toggleAlpha:topicCircle.description withDuration:0.2];
                [self toggleAlpha:topicCircle.icon withDuration:0.2];
                
                // Update labels
                [self changeLabelText:_centerTopLabel toText:@"Release to" withDuration:0.2];
                [self changeLabelText:_centerBottomLabel toText:@"cancel" withDuration:0.2];
                
                topicCircle.expanded = NO;
            }
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    BOOL anyExpanded = NO;
    
    for (TopicCircleView *topicCircle in _topicCircleCollection) {
        
        // Prepare to transition view if user selected a topic
        if (topicCircle.expanded) {
            
            anyExpanded = YES;
            
            // Fade other subviews
            for (UIView *subview in self.view.subviews) {
                if (subview != topicCircle) {
                    [UIView animateWithDuration:0.3 animations:^{subview.alpha = 0.0;}];
                }
            }
            
            // Expand circle to whole screen
            [self resizeLayer:topicCircle.layer to:CGSizeMake(self.view.frame.size.height*2.5, self.view.frame.size.height*2.5) withDuration:1.0 performSegue:segueIdentifiers[topicCircle.tag]];

        }
    }
    
    // Cancel dragging if user is not selecting a topic (i.e. user is cancelling)
    if (dragging && !anyExpanded) {
        
        [self resizeLayer:_centerCircle.layer to:CGSizeMake(170, 170) withDuration:0.3 performSegue:nil];
        
        // Update labels
        [self changeLabelText:_centerTopLabel toText:@"Drag mini-me to a topic to" withDuration:0.3];
        [self changeLabelText:_centerBottomLabel toText:@"learn more about it" withDuration:0.3];
        
        // Restore center circle
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             CGRect frame = _centerCircle.frame;
                             frame.origin.x = originX;
                             frame.origin.y =  originY;
                             _centerCircle.frame = frame;
                         }
                         completion:^(BOOL finished){
                             // Start flashing again
                             [self performSelector:@selector(pulseImage) withObject:nil afterDelay:5.0];
                         }
         ];
        
        // Show border
        [self toggleAlpha:[self.view viewWithTag:10] withDuration:0.3];
        
    }
    dragging = NO;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
}


#pragma mark - Auxiliary Methods

- (void)resizeLayer:(CALayer *)layer to:(CGSize)size withDuration:(double)duration performSegue:(NSString *)segueIdentifier
{
    // Simple UIView animation
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         layer.transform = CATransform3DMakeScale(size.width/layer.bounds.size.width, size.height/layer.bounds.size.height, 1);
                     }
                     completion:^(BOOL finished){
                         // Perform segue if user has selected a topic
                         if (segueIdentifier) {
                             [self performSegueWithIdentifier:segueIdentifier sender:self];
                             
                             // Restore view
                             [self restoreView];
                             
                         }
                     }
     ];
}

- (void)toggleAlpha:(UIView *)view withDuration:(double)duration
{
    // Simple UIView animation
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         if (view.alpha == 0.0) {
                             view.alpha = 1.0;
                         }
                         else {
                             view.alpha = 0.0;
                         }
                     }
                     completion:^(BOOL finished){
                     }
     ];
}

- (void)changeLabelText:(UILabel *)label toText:(NSString *)text withDuration:(double)duration
{
    // Nested UIView animation - fade out text, change, fade in
    [UIView animateWithDuration:duration/2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         label.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         label.text = text;
                         [UIView animateWithDuration:duration/2
                                               delay:0.0
                                             options:UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              label.alpha = 1.0;
                                          }
                                          completion:^(BOOL finished){
                                              // In case the user was too fast
                                              label.text = text;
                                          }
                          ];
                     }
     ];
}

- (void)pulseImage {
    // Nested animations to pulse image
    if (!dragging) {
        [UIView animateWithDuration:0.2
                         animations:^{
                             _centerCircle.layer.transform = CATransform3DMakeScale(200/_centerCircle.layer.bounds.size.width, 200/_centerCircle.layer.bounds.size.height, 1);
                         }
                         completion:^(BOOL finished){
                             [UIView animateWithDuration:0.2
                                              animations:^{
                                                  _centerCircle.layer.transform = CATransform3DMakeScale(170/_centerCircle.layer.bounds.size.width, 170/_centerCircle.layer.bounds.size.height, 1);
                                              }
                                              completion:^(BOOL finished){
                                                  
                                              }
                              ];
                         }
         ];
    }
    
    // Flash again after 5 seconds
    [self performSelector:@selector(pulseImage) withObject:nil afterDelay:5.0];
}

- (void)restoreView
{
    // Restore view
    CGRect frame = _centerCircle.frame;
    frame.origin.x = originX;
    frame.origin.y =  originY;
    _centerCircle.frame = frame;
    
    _centerCircle.layer.transform = CATransform3DMakeScale(170/_centerCircle.layer.bounds.size.width, 170/_centerCircle.layer.bounds.size.height, 1);
    
    for (TopicCircleView *topicCircle in _topicCircleCollection) {
        topicCircle.layer.transform = CATransform3DMakeScale(150/topicCircle.layer.bounds.size.width, 150/topicCircle.layer.bounds.size.height, 1);
        topicCircle.alpha = 0.0;
        topicCircle.icon.alpha = 1.0;
        topicCircle.expanded = NO;
    }
    
    _centerTopLabel.text = @"Drag mini-me to a topic to";
    _centerBottomLabel.text = @"learn more about it";
}

#pragma mark - Button handling

- (IBAction)replayPressed:(UIButton *)sender {
    
    // Fade subviews
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         for (UIView *subview in self.view.subviews) {
                             subview.alpha = 0;
                         }
                     }
                     completion:^(BOOL finished){
                         [self.navigationController popToRootViewControllerAnimated:NO];
                     }];
}


#pragma mark - Memory Handling

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
