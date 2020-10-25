//
//  CYImageCropView.m
//  ImageCropDemo
//
//  Created by Chen Yiliang on 16/08/2017.
//  Copyright © 2017 Chen Yiliang. All rights reserved.
//

#import "CYImageCropView.h"
#import "CYImageCropOverlayView.h"

#import <QuartzCore/QuartzCore.h>

#define rad(angle) ((angle) / 180.0 * M_PI)

@interface CYImageCropView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) CYImageCropOverlayView *cropOverlayView;
@property (nonatomic, assign) CGFloat offsetX;
@property (nonatomic, assign) CGFloat offsetY;

@end

@implementation CYImageCropView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor blackColor];
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.delegate = self;
        self.scrollView.clipsToBounds = NO;
        self.scrollView.decelerationRate = 0.0;
        self.scrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.scrollView];
        
        self.imageView = [[UIImageView alloc] initWithFrame:self.scrollView.frame];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.backgroundColor = [UIColor blackColor];
        [self.scrollView addSubview:self.imageView];
        
        
        self.scrollView.minimumZoomScale = CGRectGetWidth(self.scrollView.frame) / CGRectGetWidth(self.imageView.frame);
        self.scrollView.maximumZoomScale = MAX(6.0, self.scrollView.minimumZoomScale);
        [self.scrollView setZoomScale:1.0];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize size = self.cropSize;
    self.offsetX = floor((CGRectGetWidth(self.bounds) - size.width) * 0.5);
    self.offsetY = floor((CGRectGetHeight(self.bounds) - size.height) * 0.5);
    
    CGFloat height = self.sourceImage.size.height;
    CGFloat width = self.sourceImage.size.width;
    
    CGFloat faktor = width / size.width;
    CGFloat faktoredOffsetY = 0.0;
    CGFloat faktoredWidth = size.width;
    CGFloat faktoredHeight = height / faktor;
    if (faktoredHeight < size.height) {
        faktoredOffsetY = (size.height - faktoredHeight) / 2;
    }
    
    self.cropOverlayView.frame = self.bounds;
    self.imageView.frame = CGRectMake(0.0, faktoredOffsetY, faktoredWidth, faktoredHeight);
    self.scrollView.frame = CGRectMake(self.offsetX, self.offsetY, size.width, size.height);
    if (faktoredHeight < size.height) {
        self.scrollView.contentSize = size;
        self.scrollView.contentOffset = CGPointZero;
    } else {
        self.scrollView.contentSize = CGSizeMake(faktoredWidth, faktoredHeight);
        self.scrollView.contentOffset = CGPointMake(0.0, (faktoredHeight - size.height) / 2);
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    return self.scrollView;
}

#pragma mark - Getters & Setters

- (void)setSourceImage:(UIImage *)sourceImage {
    self.imageView.image = sourceImage;
}

- (UIImage *)sourceImage {
    return self.imageView.image;
}

- (void)setCropSize:(CGSize)cropSize {
    if (self.cropOverlayView == nil) {
        self.cropOverlayView = [[CYImageCropOverlayView alloc] initWithFrame:self.bounds];
        [self addSubview:self.cropOverlayView];
    }
    
    self.cropOverlayView.cropSize = cropSize;
}

- (CGSize)cropSize {
    return self.cropOverlayView.cropSize;
}

#pragma mark - Public Methods

- (UIImage *)croppedImage {
    //Calculate rect that needs to be cropped
    CGRect visibleRect = [self calcVisibleRectForCropArea];
    
    //transform visible rect to image orientation
    CGAffineTransform rectTransform = [self orientationTransformedRectOfImage:self.sourceImage];
    visibleRect = CGRectApplyAffineTransform(visibleRect, rectTransform);
    
    //finally crop image
    CGImageRef imageRef = CGImageCreateWithImageInRect([self.sourceImage CGImage], visibleRect);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:self.sourceImage.scale orientation:self.sourceImage.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}

#pragma mark - Private Methods

- (CGRect)calcVisibleRectForCropArea {
    CGFloat scale = self.sourceImage.size.width / self.imageView.frame.size.width;
    CGRect visibleRect = self.scrollView.bounds;
    visibleRect = CGRectMake(visibleRect.origin.x * scale, visibleRect.origin.y * scale, visibleRect.size.width * scale, visibleRect.size.height * scale);
    return visibleRect;
}

- (CGAffineTransform)orientationTransformedRectOfImage:(UIImage *)img {
    CGAffineTransform rectTransform;
    switch (img.imageOrientation) {
        case UIImageOrientationLeft:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(90)), 0, -img.size.height);
            break;
        case UIImageOrientationRight:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-90)), -img.size.width, 0);
            break;
        case UIImageOrientationDown:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-180)), -img.size.width, -img.size.height);
            break;
        default:
            rectTransform = CGAffineTransformIdentity;
    };
    
    return CGAffineTransformScale(rectTransform, img.scale, img.scale);
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale {
    CGRect frame = view.frame;
    CGSize size = scrollView.frame.size;
    if (frame.size.height < size.height) {
        self.scrollView.contentSize = CGSizeMake(frame.size.width, size.height);
        frame.origin.y = (size.height - frame.size.height) / 2;
        view.frame = frame;
    } else {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y - frame.origin.y);
        frame.origin.y = 0.0;
        view.frame = frame;
    }
}

@end
