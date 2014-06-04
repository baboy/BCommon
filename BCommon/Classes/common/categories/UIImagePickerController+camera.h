//
//  UIImagePickerController+camera.h
//  iVideo
//
//  Created by baboy on 13-12-7.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <AudioToolbox/AudioServices.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface UIImagePickerController(camera)

+ (UIImagePickerController *)imagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType mediaTypes:(NSArray *)mediaTypes;

+ (UIImage*) thumbnailOfVideo:(NSString *)videoPath;
+ (float) durationOfVideo:(NSString *)videoPath;

+ (NSString *) thumbnailPathOfVideo:(NSString*)videoPath;
+ (NSString *) saveVideoFromMediaInfo:(NSDictionary*)info;
+ (NSString *) savePhotoFromMediaInfo:(NSDictionary*)info;

@end

@interface VideoUtils : NSObject
+ (void)convertVideoFromMov:(NSString *)movFile toMp4:(NSString *)mp4 withCallback:(void (^)(AVAssetExportSession *exportSession, NSError *error))callback;

@end