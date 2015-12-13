//
//  SnakeActivityIndicatorView.h
//  SnakeActivityIndicatorView
//
//  Created by Kostas Aggelopoulos on 13/12/2015.
//  Copyright © 2015 Kostas Aggelopoulos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SnakeActivityIndicatorView : UIView

@property (nonatomic) UIColor *color;
@property (nonatomic) NSTimeInterval fullCircleDuration;

- (void)startAnimating;
- (void)stopAnimating;

@end
