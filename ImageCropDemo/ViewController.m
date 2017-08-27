//
//  ViewController.m
//  ImageCropDemo
//
//  Created by Chen Yiliang on 16/08/2017.
//  Copyright © 2017 Chen Yiliang. All rights reserved.
//

#import "ViewController.h"
#import "CYImageCropPicker.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) CYImageCropPicker *imagePicker;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imagePicker = [[CYImageCropPicker alloc] init];
}

#pragma mark - Actions

- (IBAction)imageButtonPressed:(id)sender {
    self.imagePicker.cropSize = CGSizeZero;
    
    __weak typeof(self) w_self = self;
    [self.imagePicker showPickerFromController:self withSourceType:UIImagePickerControllerSourceTypePhotoLibrary completion:^(UIImagePickerController *pickerController, UIImage *croppedImage, BOOL canceled) {
        if (!canceled) {
            w_self.imageView.image = croppedImage;
        }
    }];
}

- (IBAction)imageCropButtonPressed:(id)sender {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGSize cropSize = CGSizeZero;
    cropSize.width = screenSize.width;
    cropSize.height = screenSize.width * (7.5 / 10);
    self.imagePicker.cropSize = cropSize;
    
    __weak typeof(self) w_self = self;
    [self.imagePicker showPickerFromController:self withSourceType:UIImagePickerControllerSourceTypePhotoLibrary completion:^(UIImagePickerController *pickerController, UIImage *croppedImage, BOOL canceled) {
        if (!canceled) {
            w_self.imageView.image = croppedImage;
        }
    }];
}

@end
