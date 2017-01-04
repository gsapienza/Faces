//
//  FaceDetectionCameraImagePickerControllerViewController.m
//  Faces
//
//  Created by Gregory Sapienza on 12/15/16.
//  Copyright © 2016 The Oven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FaceDetectionCameraImagePickerControllerViewController.h"
#import "FaceDetectionModel.h"
#import "SavedImagesModel.h"
#import "CameraButton.h"
#import "SavedImagesButton.h"
#import "SavedImagesCollectionViewController.h"

#include <opencv2/opencv.hpp>
#include <opencv2/highgui/cap_ios.h>


@interface FaceDetectionCameraImagePickerControllerViewController () <CvVideoCameraDelegate>

/**
 Model to process face detection.
 */
@property (nonatomic) FaceDetectionModel *faceDetectionModel;

/**
 Model to manage images being saved to the file system.
 */
@property (nonatomic) SavedImagesModel *savedImagesModel;

/**
 Top Navigation bar
 */
@property (nonatomic) UINavigationBar *navigationBar;

/**
 Front facing camera input.
 */
@property (nonatomic, strong) CvVideoCamera *videoCamera;

/**
 Image view to display the output from CvVideoCamera.
 */
@property (nonatomic) UIImageView *videoImageView;

/**
 Layer overlaying the camera display to show the detected face rectangles.
 */
@property (nonatomic) CALayer *overlayLayer;

/**
 Bottom camera button to take an image.
 */
@property (nonatomic) CameraButton *cameraButton;

/**
 Button to access saved images.
 */
@property (nonatomic) SavedImagesButton *savedImagesButton;

/**
 Array or detected face rectangle layers contained in the overlayLayer.
 */
@property (nonatomic) NSMutableArray *faceLayers;

@end

@implementation FaceDetectionCameraImagePickerControllerViewController
@synthesize faceDetectionModel = _faceDetectionModel;
@synthesize savedImagesModel = _savedImagesModel;
@synthesize navigationBar = _navigationBar;
@synthesize videoCamera = _videoCamera;
@synthesize videoImageView = _videoImageView;
@synthesize overlayLayer = _overlayLayer;
@synthesize cameraButton = _cameraButton;
@synthesize faceLayers = _faceLayers;

#pragma mark Properties

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (FaceDetectionModel *)faceDetectionModel {
    if ( _faceDetectionModel == nil ) {
        _faceDetectionModel = [[FaceDetectionModel alloc] init];
    }
    
    return _faceDetectionModel;
}

- (SavedImagesModel *)savedImagesModel {
    if ( _savedImagesModel == nil ) {
        _savedImagesModel = [[SavedImagesModel alloc] init];
    }
    
    return _savedImagesModel;
}

- (UINavigationBar *)navigationBar {
    if ( _navigationBar == nil ) {
        _navigationBar = [[UINavigationBar alloc] init];
        _navigationBar.translucent = false;
        _navigationBar.barTintColor = [UIColor colorWithRed:43/255.0f green:61/255.0f blue:79/255.0f alpha:1];
        
        UINavigationItem *item = [[UINavigationItem alloc] init];
        UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"face"]];
        
        titleImageView.frame = CGRectMake(0, 0, 25, 25);
        titleImageView.contentMode = UIViewContentModeScaleAspectFit;
        item.titleView = titleImageView;
        
        _navigationBar.items = @[item];
    }
    
    return _navigationBar;
}

- (CvVideoCamera *)videoCamera {
    if ( _videoCamera == nil ) {
        _videoCamera = [[CvVideoCamera alloc] init];
        _videoCamera = [[CvVideoCamera alloc] initWithParentView:self.videoImageView];
        _videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
        _videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset640x480;
        _videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
        _videoCamera.defaultFPS = 30;
        _videoCamera.grayscaleMode = NO;
        _videoCamera.delegate = self;
        _videoCamera.rotateVideo = YES;
    }
    
    return _videoCamera;
}

- (UIImageView *)videoImageView {
    if ( _videoImageView == nil ) {
        _videoImageView = [[UIImageView alloc] init];
    }
    
    return _videoImageView;
}

- (CALayer *)overlayLayer {
    if ( _overlayLayer == nil ) {
        _overlayLayer = [[CALayer alloc] init];
        _overlayLayer.backgroundColor = [UIColor colorWithWhite:1 alpha:0].CGColor;
    }
    
    return _overlayLayer;
}

- (CameraButton *)cameraButton {
    if ( _cameraButton == nil ) {
        _cameraButton = [[CameraButton alloc] init];
        [_cameraButton addTarget:self action:@selector(onCameraButton) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _cameraButton;
}

- (SavedImagesButton *)savedImagesButton {
    if ( _savedImagesButton == nil ) {
        _savedImagesButton = [[SavedImagesButton alloc] init];
        _savedImagesButton.backgroundColor = [UIColor colorWithRed:21/255.0f green:21/255.0f blue:21/255.0f alpha:1];
        [_savedImagesButton addTarget:self action:@selector(onSavedImagesButton) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _savedImagesButton;
}

- (NSMutableArray *)faceLayers {
    if ( _faceLayers == nil ) {
        _faceLayers = [[NSMutableArray alloc] init];
    }
    
    return _faceLayers;
}

#pragma mark Public

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.videoCamera start];
    
    [self layout];
    
    [self setImagesButton];
}

#pragma mark Private

/**
 Set the latest image to represent the saved images button.
 */
- (void)setImagesButton {
    int fileIndex = int([NSUserDefaults.standardUserDefaults integerForKey:@"LastImageIndexSaved"]);
    
    UIImage *lastImage = [self.savedImagesModel getImageForIndex:fileIndex];
    self.savedImagesButton.previewImageView.image = lastImage;
}

/**
 Layout for all subviews in view controller.
 */
- (void)layout {
    [self.view addSubview:self.navigationBar];
    
    self.navigationBar.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.navigationBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.navigationBar attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.navigationBar attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.navigationBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:64]];
    
    [self.view addSubview:self.videoImageView];
    
    self.videoImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    float cameraAspectRatio = 4.0 / 3.0;
    CGFloat cameraHeight = self.view.bounds.size.width * cameraAspectRatio;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.videoImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.navigationBar attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.videoImageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.videoImageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.videoImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:cameraHeight]];
    
    [self.view.layer addSublayer:self.overlayLayer];
    
    self.overlayLayer.frame = CGRectMake(0, 64, self.view.bounds.size.width, cameraHeight);
    
    [self.view addSubview:self.cameraButton];
    
    self.cameraButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.cameraButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.videoImageView attribute:NSLayoutAttributeBottom multiplier:1 constant:20]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.cameraButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-20]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.cameraButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.cameraButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.cameraButton attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    
    [self.view addSubview:self.savedImagesButton];
    
    self.savedImagesButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.savedImagesButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.videoImageView attribute:NSLayoutAttributeBottom multiplier:1 constant:20]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.savedImagesButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-20]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.savedImagesButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:-20]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.savedImagesButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.savedImagesButton attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
}

#pragma mark CvVideoCamera Delegate

/**
 Delegate method when a new image is displayed.
 */
- (void)processImage:(cv::Mat &)image {
    cv::vector<cv::Rect> faceRects = [self.faceDetectionModel getFaceFramesForImage:image]; //Get rects of faces from model.
    self.savedImagesModel.lastImage = image.clone(); //Save the last image in memory in case the user wants to save it to the file system.
    
    dispatch_async(dispatch_get_main_queue(), ^{
        for ( int j = int(faceRects.size()); j < self.faceLayers.count; j++ ) { //For each face rect that already exists.
            CALayer *layer = [self.faceLayers objectAtIndex:j]; //Face rect layer.
            
            [UIView animateWithDuration:0.5 animations:^{
                layer.opacity = 0;
            }];
        }
        
        for ( int i = 0; i < faceRects.size(); i++ ) { //For each face detected.
            cv::Rect faceRect = faceRects.at(i);
            
            //Rounding values made the frame not move around as much.
            
            CGFloat roundedWidth = 5.0 * floor( ( faceRect.width / 5.0 ) + 0.05 );
            CGFloat roundedHeight = 5.0 * floor( ( faceRect.height / 5.0 ) + 0.05 );

            CGRect faceFrame = CGRectMake(faceRect.x - roundedWidth / 6, faceRect.y - roundedHeight / 6, roundedWidth, roundedHeight); //Divided by 6 because in limited testing, seemed to center around faces better.
            
            CALayer *layer; //Reusable layer.
            
            if ( self.faceLayers.count <= i ) {
                layer = [[CALayer alloc] init]; //If the layer doesnt exist in the face layers array create a new one.
                [self.faceLayers insertObject:layer atIndex:i];
                layer.borderWidth = 2;
                layer.borderColor = [UIColor colorWithRed:252/255.0f green:205/255.0f blue:2/255.0f alpha:1].CGColor;
                layer.backgroundColor = [UIColor clearColor].CGColor;
                layer.cornerRadius = 10;
            } else {
                layer = [self.faceLayers objectAtIndex:i]; //Use on that alrady exists.
            }
            
            [UIView animateWithDuration:0.5 animations:^{
                layer.frame = faceFrame;
                layer.opacity = 1;
            }];
            
            [self.overlayLayer addSublayer:layer];
        }
    });
}

#pragma mark Actions

/**
 When camera button is tapped.
 */
- (void)onCameraButton {
    [self.savedImagesModel saveLastImage];
    
    [self setImagesButton];
}


/**
 When saved button is tapped. Sets up modal navigation view controller to be displayed.
 */
- (void)onSavedImagesButton {
    UINavigationController *navigationController = [[UINavigationController alloc] init];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    int size = self.view.bounds.size.width / 4;
    flowLayout.itemSize = CGSizeMake(size, size);
    
    SavedImagesCollectionViewController *imageCollectionViewController = [[SavedImagesCollectionViewController alloc] initWithCollectionViewLayout:flowLayout];
    
    navigationController.viewControllers = @[imageCollectionViewController];
    
    [self presentViewController:navigationController animated:YES completion:^{
    }];
}

@end
