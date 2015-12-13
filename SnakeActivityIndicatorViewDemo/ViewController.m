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
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sView = [[SnakeActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.sView.center = self.view.center;
    [self.view addSubview:self.sView];
}

- (IBAction)switchChanged:(UISwitch *)sender {
    if (sender.isOn) {
        [self.sView startAnimating];
    } else {
        [self.sView stopAnimating];
    }
}

@end
