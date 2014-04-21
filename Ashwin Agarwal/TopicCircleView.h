//
//  TopicCircleView.h
//  Ashwin Agarwal
//
//  Created by Ashwin Agarwal on 08/04/2014.
//  Copyright (c) 2014 Ashwin Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicCircleView : UIView

@property (nonatomic)BOOL expanded;

@property (nonatomic, strong)IBOutlet UILabel *description;

@property (nonatomic, strong)IBOutlet UIImageView *icon;

@end
