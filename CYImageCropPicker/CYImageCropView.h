//
//  CYImageCropView.h
//  ImageCropDemo
//
//  Created by Chen Yiliang on 16/08/2017.
//  Copyright © 2017 Chen Yiliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYImageCropView : UIView

@property (nonatomic, assign) CGSize cropSize;
@property (nonatomic, strong) UIImage *sourceImage;

- (UIImage *)croppedImage;

@end
