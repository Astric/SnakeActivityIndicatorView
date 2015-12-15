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
@property (nonatomic, readonly) NSInteger numberOfCircles;

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
    for (NSInteger i = 0; i < self.numberOfCircles; i++) {
        self.layer.sublayers[i].backgroundColor = [color CGColor];
    }
}

- (void)setAnimationType:(SnakeAnimationType)animationType {
    _animationType = animationType;
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self configureView];
    [self setNeedsLayout];
    if (self.animating) {
        [self startAnimating];
    }
    
}

- (NSInteger)numberOfCircles {
    return self.animationType == SnakeAnimationTypeScale?8:6;
}

- (void)configureView {
    for (NSInteger i = 0; i < self.numberOfCircles; i++) {
        CAShapeLayer *circleLayer = [CAShapeLayer layer];
        circleLayer.backgroundColor = [[UIColor colorWithRed:0 green:0.81 blue:.035 alpha:1] CGColor];
        circleLayer.hidden = YES;
        [self.layer addSublayer:circleLayer];
    }
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [self calculateMetrics];
    
    CGFloat cx = CGRectGetMidX(self.bounds);
    CGFloat cy = CGRectGetMidY(self.bounds);
    
    for (NSInteger i = 0; i < self.numberOfCircles; i++) {
        CALayer *circleLayer = (CALayer *)self.layer.sublayers[i];
        CGFloat x,y;
        if (self.animationType == SnakeAnimationTypeScale) {
            x = cx + self.metrics.spinnerRadius * cos(i * M_PI_4);
            y = cy + self.metrics.spinnerRadius * sin(i * M_PI_4);
        } else {
            
            x = cx + self.metrics.spinnerRadius * cos([self radiansForCircleAtIndex:i]);
            y = cy + self.metrics.spinnerRadius * sin([self radiansForCircleAtIndex:i]);
        }
        circleLayer.frame = CGRectMake(0, 0, self.metrics.circleRadius * 2, self.metrics.circleRadius * 2);
        circleLayer.position = CGPointMake(x, y);
        circleLayer.cornerRadius = self.metrics.circleRadius;
    }
}

- (CGFloat)radiansForCircleAtIndex:(NSInteger)idx {
    return tan(self.metrics.circleRadius / self.metrics.spinnerRadius) * 2 * idx;
}

- (void)calculateMetrics {
    SnakeActivityIndicatorViewMetrics metrics;
    metrics.spinnerRadius = MIN(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) / 2;
    metrics.circleRadius = metrics.spinnerRadius * 0.4 / 2;
    metrics.spinnerRadius -= metrics.circleRadius / 2;
    metrics.spinnerCenter = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    self.metrics = metrics;
}

- (void)startAnimating {
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
    for (NSInteger i = 0; i < self.numberOfCircles; i++) {
        CALayer *circleLayer = self.layer.sublayers[i];
        [circleLayer removeAllAnimations];
        circleLayer.hidden = YES;
    }
    _animating = NO;
}

- (void)animateWithScale {
    for (NSInteger i = 0; i < self.numberOfCircles; i++) {
        CALayer *circleLayer = self.layer.sublayers[i];
        circleLayer.hidden = NO;
        //circleLayer.affineTransform = CGAffineTransformMakeScale(0, 0);
        
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
        
        [circleLayer addAnimation:group forKey:nil];
    }
}

- (void)animateWithRotation {
    for (NSInteger i = 0; i < self.numberOfCircles; i++) {
        CALayer *circleLayer = self.layer.sublayers[i];
        circleLayer.hidden = NO;
        
        CGFloat startAngle = [self radiansForCircleAtIndex:i];
        CGFloat endAngle = startAngle - 2 * M_PI;
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.metrics.spinnerCenter
                                                            radius:self.metrics.spinnerRadius
                                                        startAngle:startAngle
                                                          endAngle:endAngle
                                                         clockwise:NO];
        
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        animation.path = [path CGPath];
        
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

        // Play with the media function at http://cubic-bezier.com/
        //CAMediaTimingFunction *function = [CAMediaTimingFunction functionWithControlPoints:0.42:0:.58:1];
        CAMediaTimingFunction *function = [CAMediaTimingFunction functionWithControlPoints:0.13:0.65:.3:.83];
        //CAMediaTimingFunction *function = [CAMediaTimingFunction functionWithControlPoints:.77:.25:.93:.37];
        
        animation.timingFunction = function;
        animation.repeatCount = HUGE_VALF;
        animation.duration = 1.6;
        animation.beginTime = CACurrentMediaTime() + i * 0.065;

        [circleLayer addAnimation:animation forKey:nil];
    }
}

@end
