//
//  CYImageCropViewController.m
//  ImageCropDemo
//
//  Created by Chen Yiliang on 16/08/2017.
//  Copyright © 2017 Chen Yiliang. All rights reserved.
//

#import "CYImageCropViewController.h"
#import "CYImageCropView.h"

@interface CYImageCropViewController ()

@property (nonatomic, strong) UIImage *croppedImage;

@property (nonatomic, strong) CYImageCropView *imageCropView;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *useButton;

@end

@implementation CYImageCropViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupCropView];
    [self setupToolbar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].statusBarHidden = NO ;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    self.imageCropView.frame = self.view.bounds;
    self.toolbar.frame = CGRectMake(0.0, CGRectGetHeight(self.view.frame) - 54.0, self.view.frame.size.width, 54.0);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - View Configure

- (void)setupCropView {
    self.imageCropView = [[CYImageCropView alloc] initWithFrame:self.view.bounds];
    [self.imageCropView setSourceImage:self.sourceImage];
    [self.imageCropView setCropSize:self.cropSize];
    [self.view addSubview:self.imageCropView];
}

- (void)setupCancelButton {
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [[self.cancelButton titleLabel] setFont:[UIFont boldSystemFontOfSize:16]];
    [[self.cancelButton titleLabel] setShadowOffset:CGSizeMake(0, -1)];
    [self.cancelButton setFrame:CGRectMake(0, 0, 58, 30)];
    [self.cancelButton setTitle:NSLocalizedString(@"Cancel",@"") forState:UIControlStateNormal];
    [self.cancelButton setTitleShadowColor:[UIColor colorWithRed:0.118 green:0.247 blue:0.455 alpha:1] forState:UIControlStateNormal];
    [self.cancelButton  addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupUseButton {
    self.useButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [[self.useButton titleLabel] setFont:[UIFont boldSystemFontOfSize:16]];
    [[self.useButton titleLabel] setShadowOffset:CGSizeMake(0, -1)];
    [self.useButton setFrame:CGRectMake(0, 0, 58, 30)];
    [self.useButton setTitle:NSLocalizedString(@"Use",@"") forState:UIControlStateNormal];
    [self.useButton setTitleShadowColor:[UIColor colorWithRed:0.118 green:0.247 blue:0.455 alpha:1] forState:UIControlStateNormal];
    [self.useButton  addTarget:self action:@selector(useButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupToolbar {
    self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
    
    self.toolbar.translucent = YES;
    self.toolbar.barStyle = UIBarStyleBlackOpaque;
    [self.view addSubview:self.toolbar];
    
    [self setupCancelButton];
    [self setupUseButton];
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithCustomView:self.cancelButton];
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *use = [[UIBarButtonItem alloc] initWithCustomView:self.useButton];
    
    [self.toolbar setItems:[NSArray arrayWithObjects:cancel, flex, flex, use, nil]];
}

#pragma mark - Actions

- (void)cancelButtonPressed:(id)sender {
    if (self.completion != nil) {
        self.completion(nil, YES);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)useButtonPressed:(id)sender {
    self.croppedImage = [self.imageCropView croppedImage];
    if (self.completion != nil) {
        self.completion(self.croppedImage, NO);
    }
}

@end
