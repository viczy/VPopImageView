//
//  VZoomController.m
//  VPopImageView
//
//  Created by Vic Zhou on 1/16/15.
//  Copyright (c) 2015 everycode. All rights reserved.
//

#import "VZoomController.h"
#import <UIImageView+AFNetworking.h>

@interface VZoomController () <
    UIScrollViewDelegate,
    UIActionSheetDelegate>

@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, assign) VImageType type;

@property (nonatomic, strong) UIBarButtonItem *closeButtonItem;
@property (nonatomic, strong) UIBarButtonItem *saveButtonItem;
@property (nonatomic, strong) UIScrollView *zoomView;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;

@end

@implementation VZoomController

#pragma mark - NSObject

- (id)initWithZoomFilePath:(NSString *)path andType:(VImageType)type {
    self = [super init];
    if (self) {
        _filePath = path;
        _type = type;
    }
    return self;
}


#pragma mark - Getter

- (UIBarButtonItem*)closeButtonItem {
    if (!_closeButtonItem) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0.f, 0.f, 44.f, 44.f);
        [button setTitle:@"返回" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
        _closeButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return _closeButtonItem;
}

- (UIBarButtonItem*)saveButtonItem {
    if (!_saveButtonItem) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0.f, 0.f, 44.f, 44.f);
        [button setTitle:@"保存" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
        _saveButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return _saveButtonItem;
}

- (UIScrollView*)zoomView {
    if (!_zoomView) {
        _zoomView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _zoomView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
        _zoomView.delegate = self;
        _zoomView.backgroundColor = [UIColor blackColor];
    }
    return _zoomView;
}

- (UIActivityIndicatorView*)activityView {
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityView.center = self.zoomView.center;
        _activityView.color = [UIColor lightGrayColor];
        _activityView.hidesWhenStopped = YES;
    }
    return _activityView;
}

- (UIImageView*)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _imageView;
}

#pragma mark - Setter

- (void)setImage:(UIImage *)image {
    _image = image;
    [self insetImage];
}

#pragma mark - UIViewController

- (void)loadView {
    [super loadView];
    self.navigationItem.leftBarButtonItem = self.closeButtonItem;
    self.navigationItem.rightBarButtonItem = self.saveButtonItem;
    [self.zoomView addSubview:self.imageView];
    [self.view addSubview:self.zoomView];
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadImage];
}

#pragma mark - Actions Private

- (void)closeAction {
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}

- (void)saveAction {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"保存"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"保存到相册", nil];
    [sheet showInView:self.view];
}

- (void)loadImage {
    if (self.type == VImageTypeLocal) {
        self.image = [UIImage imageWithContentsOfFile:self.filePath];
    }else if (self.type == VImageTypeNet) {
        //add activityindiactorview
        [self.view addSubview:self.activityView];
        [self.activityView startAnimating];
        UIImage *defaultImage = [UIImage imageNamed:@"v_pop_zoom_default"];
        __weak typeof(self) weakSelf = self;
        [self.imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[[NSURL alloc] initWithString:self.filePath]]
                              placeholderImage:defaultImage
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           [weakSelf.activityView stopAnimating];
                                           if (image) {
                                               weakSelf.image = image;
                                               weakSelf.navigationItem.rightBarButtonItem.enabled = YES;
                                           }
                                           else {
                                               weakSelf.image = defaultImage;
                                           }
                                       } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                           weakSelf.image = defaultImage;
                                       }];
    }
}

- (void)insetImage {
    CGSize zoomSize = self.zoomView.frame.size;
    CGSize imageSize = self.image.size;
    CGRect imageViewRect;
    if (imageSize.height/imageSize.width > zoomSize.height/zoomSize.width) {
        if (imageSize.height > zoomSize.height) {
            CGFloat widthFit = imageSize.width*zoomSize.height/imageSize.height;
            imageViewRect = CGRectMake((zoomSize.width-widthFit)/2, 0.f, widthFit, zoomSize.height);
        }
        else {
            imageViewRect = CGRectMake((zoomSize.width-imageSize.width)/2, (zoomSize.height-imageSize.height)/2, imageSize.width, imageSize.height);
        }
    }
    else {
        if (imageSize.width > zoomSize.width) {
            CGFloat heightFit = imageSize.height*zoomSize.width/imageSize.width;
            imageViewRect = CGRectMake(0.f, (zoomSize.height-heightFit)/2, zoomSize.width, heightFit);
        }
        else {
            imageViewRect = CGRectMake((zoomSize.width-imageSize.width)/2, (zoomSize.height-imageSize.height)/2, imageSize.width, imageSize.height);
        }
    }
    //set imageview frame
    self.imageView.frame = imageViewRect;

    //set maximunzoomscale
    CGFloat widthPercent = imageSize.width/zoomSize.width;
    CGFloat heightPercent = imageSize.height/zoomSize.height;
    CGFloat percent = widthPercent>heightPercent ? widthPercent:heightPercent;
    percent = percent>1 ? percent : 1;
    self.zoomView.maximumZoomScale = percent+1;

    //set image
    self.imageView.image = self.image;
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已存入手机相册" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }else{

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

#pragma mark - UIScrollViewDelegate

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect zoomRect = self.zoomView.frame;
    CGRect imageRect = self.imageView.frame;
    CGFloat x = zoomRect.size.width > imageRect.size.width ? (zoomRect.size.width - imageRect.size.width)/2 : 0.f;
    CGFloat y = zoomRect.size.height > imageRect.size.height ? (zoomRect.size.height - imageRect.size.height)/2 : 0.f;
    imageRect.origin.x = x;
    imageRect.origin.y = y;
    self.imageView.frame = imageRect;
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: {
            UIImageWriteToSavedPhotosAlbum(self.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            break;
        }

        case 1: {
            break;
        }

        default:
            break;
    }
}


@end
