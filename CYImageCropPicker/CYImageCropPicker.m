//
//  CYImageCropPicker.m
//  ImageCropDemo
//
//  Created by Chen Yiliang on 16/08/2017.
//  Copyright © 2017 Chen Yiliang. All rights reserved.
//

#import "CYImageCropPicker.h"
#import "CYImageCropViewController.h"

@interface CYImageCropPicker () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation CYImageCropPicker

- (instancetype)init {
    if (self = [super init]) {
        self.cropSize = CGSizeZero;
    }
    return self;
}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self completionWithPicker:picker image:nil canceled:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (CGSizeEqualToSize(self.cropSize, CGSizeZero)) {
        [self completionWithPicker:picker image:image canceled:NO];
    } else {
        [self showCropViewWithPicker:picker sourceImage:image];
    }
}

#pragma mark - Public Methods

- (void)showPickerFromController:(UIViewController *)controller withSourceType:(UIImagePickerControllerSourceType)sourceType completion:(void (^)(UIImagePickerController *pickerController, UIImage *image, BOOL canceled))completion {
    self.completion = completion;
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = sourceType;
    [controller presentViewController:imagePickerController animated:YES completion:NULL];
}

#pragma mark - Private Methods

- (void)showCropViewWithPicker:(UIImagePickerController *)picker sourceImage:(UIImage *)sourceImage {
    CYImageCropViewController *cropController = [[CYImageCropViewController alloc] init];
    cropController.sourceImage = sourceImage;
    
    cropController.cropSize = self.cropSize;
    
    __weak typeof(self) w_self = self;
    cropController.completion = ^(UIImage *croppedImage, BOOL canceled) {
        if (canceled) {
            if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
                [w_self completionWithPicker:picker image:nil canceled:YES];
            }
        } else {
            [w_self completionWithPicker:picker image:croppedImage canceled:NO];
        }
    };
    
    [picker pushViewController:cropController animated:YES];
}

- (void)completionWithPicker:(UIImagePickerController *)picker image:(UIImage *)image canceled:(BOOL)canceled {
    if (self.completion != nil) {
        self.completion(picker, image, canceled);
    }
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
