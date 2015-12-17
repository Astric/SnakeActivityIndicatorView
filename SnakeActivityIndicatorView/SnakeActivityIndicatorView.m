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
    CGFloat dotRadius;
    CGPoint spinnerCenter;
};

typedef struct SnakeActivityIndicatorViewMetrics SnakeActivityIndicatorViewMetrics;

@interface SnakeActivityIndicatorView()

@property (nonatomic) SnakeActivityIndicatorViewMetrics metrics;
@property (nonatomic, readonly) NSInteger numberOfDots;
@property (nonatomic, readonly) CAReplicatorLayer *rLayer;
@property (nonatomic) CAShapeLayer *dotLayer;

@end

@implementation SnakeActivityIndicatorView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configureView];
        self.fullRotationDuration = 1;
    }
    return self;
}

+ (Class)layerClass {
    return [CAReplicatorLayer class];
}

- (CAReplicatorLayer *)rLayer {
    return (CAReplicatorLayer *)self.layer;
}

- (void)setColor:(UIColor *)color {
    _color = color;
    self.dotLayer.backgroundColor = [color CGColor];
}

- (void)setAnimationType:(SnakeAnimationType)animationType {
    _animationType = animationType;
    [self configureView];
    [self setNeedsLayout];
    if (self.animating) {
        [self startAnimating];
    }
}

- (NSInteger)numberOfDots {
    return self.animationType == SnakeAnimationTypeScale?8:6;
}

- (void)configureView {
    [self.dotLayer removeFromSuperlayer];
    self.dotLayer = [CAShapeLayer layer];
    //self.dotLayer.backgroundColor = [[UIColor colorWithRed:(arc4random() % 255) / 255.0 green:(arc4random() % 255) / 255.0 blue:(arc4random() % 255) / 255.0 alpha:1] CGColor];
    self.dotLayer.backgroundColor = [[UIColor colorWithRed:0 green:0.81 blue:.035 alpha:1] CGColor];
    [self.layer addSublayer:self.dotLayer];
    self.dotLayer.hidden = YES;
    self.rLayer.instanceCount = self.numberOfDots;
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [self calculateMetrics];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    CGFloat dotDiameter = self.metrics.dotRadius * 2;
    self.dotLayer.cornerRadius = self.metrics.dotRadius;
    self.dotLayer.frame = CGRectMake(self.metrics.spinnerRadius * 2 - self.metrics.dotRadius,
                                     self.metrics.spinnerRadius - self.metrics.dotRadius/2,
                                     dotDiameter,
                                     dotDiameter);
    
    CGFloat angle;
    if (self.animationType == SnakeAnimationTypeScale) {
        angle = -M_PI_4;
    } else {
        angle = tanf(self.metrics.dotRadius / self.metrics.spinnerRadius) *2;
    }

    self.rLayer.instanceTransform = CATransform3DMakeRotation(angle, 0, 0, 1);
    [CATransaction commit];
}

- (void)calculateMetrics {
    SnakeActivityIndicatorViewMetrics metrics;
    metrics.spinnerRadius = MIN(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) / 2;
    metrics.dotRadius = metrics.spinnerRadius * 0.4 / 2.0;
    metrics.spinnerRadius -= metrics.dotRadius / 2.0;
    metrics.spinnerCenter = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    self.metrics = metrics;
}

- (void)startAnimating {
    //self.dotLayer.transform = CATransform3DMakeScale(1, 1, 1);
    self.dotLayer.hidden = NO;
    switch (self.animationType) {
        case SnakeAnimationTypeRotate:
            [self animateWithRotation];
            break;
        case SnakeAnimationTypeScale:
            [self animateWithScale];
            break;
        default:
            break;
    }
    _animating = YES;
}

- (void)stopAnimating {
    self.dotLayer.hidden = YES;
    [self.dotLayer removeAllAnimations];
    _animating = NO;
}

- (void)animateWithScale {
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale.fromValue = @(1);
    scale.toValue = @(0);

    CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fade.fromValue = @(1);
    fade.toValue = @(0);

    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[scale, fade];
    group.repeatCount = HUGE_VALF;
    group.duration = self.fullRotationDuration;
    self.dotLayer.transform = CATransform3DMakeScale(0, 0, 0);
    self.rLayer.instanceDelay = self.fullRotationDuration / 8;
    [self.dotLayer addAnimation:group forKey:nil];

}

- (void)animateWithRotation {
    CGFloat startAngle = 0;
    CGFloat endAngle = -2 * M_PI;

    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.metrics.spinnerCenter
                                                        radius:self.metrics.spinnerRadius - self.metrics.dotRadius/2
                                                    startAngle:startAngle
                                                      endAngle:endAngle
                                                     clockwise:NO];

    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = [path CGPath];

    // Play with the media function at http://cubic-bezier.com/
    CAMediaTimingFunction *function = [CAMediaTimingFunction functionWithControlPoints:0.6:0.6:1:0];
    animation.timingFunction = function;
    animation.repeatCount = HUGE_VALF;
    animation.duration = 1.6;

    self.rLayer.instanceDelay = 0.065;
    [self.dotLayer addAnimation:animation forKey:nil];
}

@end
