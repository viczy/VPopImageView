//
//  ViewController.m
//  VPopImageView
//
//  Created by Vic Zhou on 1/16/15.
//  Copyright (c) 2015 everycode. All rights reserved.
//

#import "ViewController.h"
#import "VPopImageView.h"

@interface ViewController ()

@property (nonatomic, strong) VPopImageView *local;
@property (nonatomic, strong) VPopImageView *net;

@end

@implementation ViewController

#pragma mark - Getter

- (VPopImageView*)local {
    if (!_local) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"image_large_0" ofType:@"png"];
        _local = [[VPopImageView alloc] initWithSuperController:self withZoomFilePath:path andType:VImageTypeLocal];
        _local.frame = CGRectMake(80.f, 100.f, self.view.bounds.size.width-160.f, 160.f);
        _local.image = [UIImage imageNamed:@"image_0"];
    }
    return _local;
}

- (VPopImageView*)net {
    if (!_net) {
        _net = [[VPopImageView alloc] initWithSuperController:self withZoomFilePath:@"http://www.jiujiuba.com/xxpict2/picnews/62223245.jpg" andType:VImageTypeNet];
        _net.frame = CGRectMake(80.f, 360.f, self.view.bounds.size.width-160.f, 160.f);
        _net.image = [UIImage imageNamed:@"image_1"];
        
    }
    return _net;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.local];
    [self.view addSubview:self.net];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
