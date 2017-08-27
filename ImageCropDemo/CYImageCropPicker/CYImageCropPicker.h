//
//  CYImageCropPicker.h
//  ImageCropDemo
//
//  Created by Chen Yiliang on 16/08/2017.
//  Copyright © 2017 Chen Yiliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface CYImageCropPicker : NSObject

@property (nonatomic, assign) CGSize cropSize;

@property (nonatomic, copy) void (^completion)(UIImagePickerController *pickerController, UIImage *image, BOOL canceled);

- (void)showPickerFromController:(UIViewController *)controller withSourceType:(UIImagePickerControllerSourceType)sourceType completion:(void (^)(UIImagePickerController *pickerController, UIImage *image, BOOL canceled))completion;

@end
