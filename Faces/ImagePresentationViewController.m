//
//  ImagePresentationViewController.m
//  Faces
//
//  Created by Gregory Sapienza on 12/16/16.
//  Copyright © 2016 The Oven. All rights reserved.
//

#import "ImagePresentationViewController.h"

@interface ImagePresentationViewController ()

@end

@implementation ImagePresentationViewController
@synthesize imageView = _imageView;

#pragma mark Properties

- (UIImageView *)imageView {
    if ( _imageView == nil ) {
        _imageView = [[UIImageView alloc] init];
    }
    
    return _imageView;
}

#pragma mark Public

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self layout];
}

#pragma mark Private

/**
 Layout for subviews.
 */
- (void)layout {
    [self.view addSubview:self.imageView];
    
    self.imageView.translatesAutoresizingMaskIntoConstraints = false;
    
    float photoAspectRatio = 4.0 / 3.0;
    CGFloat photoHeight = self.view.bounds.size.width * photoAspectRatio;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:photoHeight]];
}


@end
