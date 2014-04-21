//
//  PushNoAnimationSegue.m
//  Ashwin Agarwal
//
//  Created by Ashwin Agarwal on 09/04/2014.
//  Copyright (c) 2014 Ashwin Agarwal. All rights reserved.
//

#import "PushNoAnimationSegue.h"

@implementation PushNoAnimationSegue

-(void) perform{
    [[[self sourceViewController] navigationController] pushViewController:[self   destinationViewController] animated:NO];
}

@end
