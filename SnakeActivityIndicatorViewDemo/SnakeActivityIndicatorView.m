//
//  SnakeActivityIndicatorView.m
//  SnakeActivityIndicatorView
//
//  Created by Kostas Aggelopoulos on 13/12/2015.
//  Copyright © 2015 Kostas Aggelopoulos. All rights reserved.
//

#import "SnakeActivityIndicatorView.h"

struct SnakeActivityIndicatorViewMetrics {
    CGFloat spinnerRadius;
    CGFloat circleRadius;
    CGPoint spinnerCenter;
};
typedef struct SnakeActivityIndicatorViewMetrics SnakeActivityIndicatorViewMetrics;

@interface SnakeActivityIndicatorView()

@property (nonatomic) SnakeActivityIndicatorViewMetrics metrics;

@end

@implementation SnakeActivityIndicatorView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configureView];
        self.fullCircleDuration = 1;
    }
    return self;
}

- (void)setColor:(UIColor *)color {
    _color = color;
    for (int i = 0; i < 8; i++) {
        self.layer.sublayers[i].backgroundColor = [color CGColor];
    }
}

- (void)configureView {
    for (int i = 0; i < 8; i++) {
        CAShapeLayer *circleLayer = [CAShapeLayer layer];
        circleLayer.backgroundColor = [[UIColor colorWithRed:0 green:0.81 blue:.035 alpha:1] CGColor];
        [self.layer addSublayer:circleLayer];
    }
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [self calculateMetrics];
    
    CGFloat cx = CGRectGetMidX(self.bounds);
    CGFloat cy = CGRectGetMidY(self.bounds);
    
    for (int i = 0; i < 8; i++) {
        CALayer *circleLayer = (CALayer *)self.layer.sublayers[i];

        CGFloat x = cx + self.metrics.spinnerRadius * cos(i * M_PI/4);
        CGFloat y = cy + self.metrics.spinnerRadius * sin(i * M_PI/4);
        
        circleLayer.frame = CGRectMake(0, 0, self.metrics.circleRadius, self.metrics.circleRadius);
        circleLayer.position = CGPointMake(x, y);
        circleLayer.cornerRadius = self.metrics.circleRadius / 2;
        circleLayer.affineTransform = CGAffineTransformMakeScale(0, 0);
    }
}

- (void)calculateMetrics {
    SnakeActivityIndicatorViewMetrics metrics;
    metrics.spinnerRadius = MIN(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) / 2;
    metrics.circleRadius = metrics.spinnerRadius * 0.4;
    metrics.spinnerRadius -= metrics.circleRadius / 2;
    metrics.spinnerCenter = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    self.metrics = metrics;
}

- (void)startAnimating {
    for (NSInteger i = 0; i < 8; i++) {
        CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scale.fromValue = @(1);
        scale.toValue = @(0);
        
        CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
        fade.fromValue = @(1);
        fade.toValue = @(0);
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.animations = @[scale, fade];
        group.repeatCount = HUGE_VALF;
        group.duration = self.fullCircleDuration;
        group.beginTime = CACurrentMediaTime() - i * self.fullCircleDuration / 8;
        
        CALayer *circleLayer = self.layer.sublayers[i];
        [circleLayer addAnimation:group forKey:nil];
    }
}

- (void)stopAnimating {
    for (NSInteger i = 0; i < 8; i++) {
        [self.layer.sublayers[i] removeAllAnimations];
    }
}

@end
