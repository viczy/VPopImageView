//
//  VPopImageView.h
//  VPopImageView
//
//  Created by Vic Zhou on 1/16/15.
//  Copyright (c) 2015 everycode. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    VImageTypeLocal,
    VImageTypeNet,
}VImageType;

@interface VPopImageView : UIImageView

- (id)initWithSuperController:(UIViewController*)controller withZoomFilePath:(NSString*)path andType:(VImageType)type;

@end
