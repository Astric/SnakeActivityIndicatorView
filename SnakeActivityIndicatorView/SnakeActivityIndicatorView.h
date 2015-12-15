//
//  SnakeActivityIndicatorView.h
//  SnakeActivityIndicatorView
//
//  Created by Kostas Aggelopoulos on 13/12/2015.
//  Copyright © 2015 Kostas Aggelopoulos. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SnakeAnimationType) {
    SnakeAnimationTypeScale,
    SnakeAnimationTypeRotate
};

@interface SnakeActivityIndicatorView : UIView

@property (nonatomic) UIColor *color;
@property (nonatomic) NSTimeInterval fullCircleDuration;
@property (nonatomic) SnakeAnimationType animationType;
@property (nonatomic, readonly) BOOL animating;

- (void)startAnimating;
- (void)stopAnimating;

@end
