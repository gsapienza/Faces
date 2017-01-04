//
//  SavedImagesModel.m
//  Faces
//
//  Created by Gregory Sapienza on 12/16/16.
//  Copyright © 2016 The Oven. All rights reserved.
//

#import "SavedImagesModel.h"
#import "FaceDetectionModel.h"
#include <opencv2/highgui/ios.h>

@interface SavedImagesModel ()

@property (nonatomic) FaceDetectionModel *faceDetectionModel;

@end

@implementation SavedImagesModel
@synthesize faceDetectionModel = _faceDetectionModel;

#pragma mark Properties

- (FaceDetectionModel *)faceDetectionModel {
    if ( _faceDetectionModel == nil ) {
        _faceDetectionModel = [[FaceDetectionModel alloc] init];
    }
    
    return _faceDetectionModel;
}

#pragma mark Public

- (void)saveLastImage {
    int fileIndex = int([NSUserDefaults.standardUserDefaults integerForKey:@"LastImageIndexSaved"]) + 1;
    
    cv::vector<cv::Rect> faceRects = [self.faceDetectionModel getFaceFramesForImage:self.lastImage.clone()];
    
    cv::Mat rgb_image;
    cv::Mat bgr_image = self.lastImage.clone();
    cv::cvtColor(bgr_image, rgb_image, CV_RGB2BGR);
    
    UIImage *image = MatToUIImage(rgb_image);
    
    UIImage *imageWithFaceRects = [self imageWithFaceDetection:image faceRects:faceRects];
    
    NSData *imageData = UIImagePNGRepresentation(imageWithFaceRects);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    NSString *fileName = [NSString stringWithFormat:@"%i.png", fileIndex];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    [imageData writeToFile:filePath atomically:YES];
    
    
    [NSUserDefaults.standardUserDefaults setInteger:fileIndex forKey:@"LastImageIndexSaved"];
}

- (UIImage *)getImageForIndex:(int)index {
    NSString *fileName = [NSString stringWithFormat:@"%i.png", index];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    
    return image;
}

#pragma mark Private

/**
 Gets an image with faces outlined from rects.

 @param image Image to use to outline faces.
 @param faceRects Rects of faces.
 @return Image with outlines of faces.
 */
- (UIImage *)imageWithFaceDetection:(UIImage *)image faceRects:(cv::vector<cv::Rect>)faceRects {
    UIGraphicsBeginImageContext(image.size);
    
    [image drawAtPoint:CGPointMake(0, 0)];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for ( int i = 0; i < faceRects.size(); i++ ) {
        cv::Rect faceRect = faceRects.at(i);
        
        CGRect rect = [self cgRectFromRect:faceRect];
        
        UIBezierPath *rectPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:10];
        CGContextAddPath(context, rectPath.CGPath);
    }
    
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:252/255.0f green:205/255.0f blue:2/255.0f alpha:1].CGColor);
    CGContextStrokePath(context);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}


/**
 Converts a Rect into a CGRect.

 @return CGRect containing points from a Rect type.
 */
- (CGRect)cgRectFromRect:(cv::Rect)rect {
    return CGRectMake(rect.x, rect.y, rect.width, rect.height);
}

@end
