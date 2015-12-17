//
//  ViewController.m
//  SnakeActivityIndicatorViewDemo
//
//  Created by Kostantinos Aggelopoulos on 13/12/2015.
//  Copyright © 2015 Kostas Aggelopoulos. All rights reserved.
//

#import "ViewController.h"

#import "SnakeActivityIndicatorView.h"

@interface ViewController ()

@property (nonatomic) SnakeActivityIndicatorView *sView;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sView = [[SnakeActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.sView.center = self.view.center;
    self.sView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
    [self.view addSubview:self.sView];
    
}

- (IBAction)switchChanged:(UISwitch *)sender {
    if (sender.isOn) {
        [self.sView startAnimating];
    } else {
        [self.sView stopAnimating];
    }
    self.slider.enabled = !sender.isOn;
}

- (IBAction)segmentChanged:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex) {
        self.sView.animationType = SnakeAnimationTypeRotate;
    } else {
        self.sView.animationType = SnakeAnimationTypeScale;
    }
}

- (IBAction)sliderChanged:(UISlider *)sender {
    BOOL animating = self.sView.animating;
    if (animating) {
        [self.sView stopAnimating];
    }
    self.sView.frame = CGRectMake(0, 0, sender.value * 200, sender.value * 200);
    self.sView.center = self.view.center;
    if (animating) {
        [self.sView startAnimating];
    }
}

@end
