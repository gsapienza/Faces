//
//  FaceDetectionModelBridge.m
//  Faces
//
//  Created by Gregory Sapienza on 12/15/16.
//  Copyright © 2016 The Oven. All rights reserved.
//

#import <CoreFoundation/CoreFoundation.h>
#import "FaceDetectionModel.h"
#include <opencv2/highgui/ios.h>

@interface FaceDetectionModel () {
    cv::CascadeClassifier faceDetection;
}

@end

@implementation FaceDetectionModel

#pragma mark Public

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *faceTraining = [[NSBundle mainBundle] pathForResource:@"haarcascade_frontalface_alt2" ofType:@"xml"];
        
        char *buffer = (char *) malloc(2048);
        CFStringGetFileSystemRepresentation((CFStringRef)faceTraining, buffer, 2048);

        faceDetection.load(buffer); //Set face training data to use for face detection.
    }
    
    return self;
}

- (cv::vector<cv::Rect>)getFaceFramesForImage:(cv::Mat)image {
    cv::vector<cv::Rect> faceRects;
    double scalingFactor = 1.1;
    int minNeighbors = 2;
    cv::Size min(200, 200); //A good balance between speed and accuracy on iPhone 7 Plus at least.
    
    faceDetection.detectMultiScale(image, faceRects, scalingFactor, minNeighbors, 0, min); //Detect faces for image.
    
    return faceRects;
}

@end
