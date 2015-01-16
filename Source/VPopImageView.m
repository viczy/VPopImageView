//
//  VPopImageView.m
//  VPopImageView
//
//  Created by Vic Zhou on 1/16/15.
//  Copyright (c) 2015 everycode. All rights reserved.
//

#import "VPopImageView.h"
#import "VZoomController.h"

@interface VPopImageView ()

@property (nonatomic, strong) UIViewController *superController;
@property (nonatomic, strong) NSString *zoomFilePath;
@property (nonatomic, assign) VImageType type;
@property (nonatomic, strong) VZoomController *zoomController;

@end

@implementation VPopImageView

#pragma mark - NSObject

- (id)initWithSuperController:(UIViewController *)controller withZoomFilePath:(NSString *)path andType:(VImageType)type {
    self = [self init];
    if (self) {
        _superController = controller;
        _zoomFilePath = path;
        _type = type;
        self.userInteractionEnabled = YES;
    }
    return self;
}


#pragma mark - Getter 

- (VZoomController*)zoomController {
    if (!_zoomController) {
        _zoomController = [[VZoomController alloc] initWithZoomFilePath:self.zoomFilePath andType:self.type];
    }
    return _zoomController;
}

#pragma mark - Super

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.zoomController];
    [self.superController presentViewController:nav animated:YES completion:^{
        //
    }];
}


@end
