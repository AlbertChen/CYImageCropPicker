//
//  CYImageCropOverlayView.m
//  ImageCropDemo
//
//  Created by Chen Yiliang on 16/08/2017.
//  Copyright © 2017 Chen Yiliang. All rights reserved.
//

#import "CYImageCropOverlayView.h"

@implementation CYImageCropOverlayView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGFloat heightSpan = floor(height / 2 - self.cropSize.height / 2);
    CGFloat widthSpan = floor(width / 2 - self.cropSize.width  / 2);
    
    //fill outer rect
    [[UIColor colorWithRed:0. green:0. blue:0. alpha:0.5] set];
    UIRectFill(self.bounds);
    
    //fill inner border
    [[UIColor colorWithRed:1. green:1. blue:1. alpha:0.5] set];
    UIRectFrame(CGRectMake(widthSpan, heightSpan, self.cropSize.width, self.cropSize.height));
    
    //fill inner rect
    [[UIColor clearColor] set];
    UIRectFill(CGRectMake(widthSpan + 1, heightSpan + 1, self.cropSize.width - 2, self.cropSize.height - 2));
}

@end
