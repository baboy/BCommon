//
//  UIImagePickerController+camera.m
//  iVideo
//
//  Created by baboy on 13-12-7.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "UIImagePickerController+camera.h"

@implementation UIImagePickerController(camera)
+ (UIImagePickerController *)imagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType mediaTypes:(NSArray *)mediaTypes{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    [picker setSourceType:sourceType];
    if(sourceType == UIImagePickerControllerSourceTypeCamera){
        picker.showsCameraControls = YES;
    }
    picker.navigationBar.barStyle = UIBarStyleBlack;
    picker.mediaTypes = mediaTypes;
    
    for (NSString *mediaType in mediaTypes) {
        if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]){
            [picker setVideoMaximumDuration:180];
        }
    }
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        picker.videoQuality = UIImagePickerControllerQualityTypeMedium;
    }
    return picker;
}
+ (UIImage*) thumbnailOfVideo:(NSString *)videoPath{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoPath] options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    CGImageRef thumbnailImageRef = NULL;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMakeWithSeconds(0.0, 60) actualTime:NULL error:&thumbnailImageGenerationError];
    
    if (!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
    
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;
    
    return thumbnailImage;
}
+ (float)durationOfVideo:(NSString *)videoPath{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:videoPath] options:opts];
    float second = 0;
    second = urlAsset.duration.value/urlAsset.duration.timescale;
    return second;
}

+ (NSString *) thumbnailPathOfVideo:(NSString*)videoPath{
    NSString *thumbnailPath = [[videoPath stringByDeletingPathExtension] stringByAppendingPathExtension:@"jpg"];
    UIImage *img = [self thumbnailOfVideo:videoPath];
    NSData *data = UIImageJPEGRepresentation(img,0.6);
    
    NSError *err = nil;
    thumbnailPath = [data writeToFile:thumbnailPath options:NSDataWritingAtomic error:&err]?thumbnailPath:nil;
    if (err) {
        DLOG(@"write file error:%@,%@,%@",err,[videoPath stringByDeletingPathExtension],[videoPath stringByDeletingLastPathComponent]);
        DLOG(@"write file error:%@",err);
    }
    return thumbnailPath;
}
+ (NSString *)saveVideoFromMediaInfo:(NSDictionary*)info{
    NSString *fp = nil;
    NSURL *videoURL = [info valueForKey:UIImagePickerControllerMediaURL];
    @try{
        NSString *fn = [Utils format:@"yyyyMMddhhmmss" time:[[NSDate date] timeIntervalSince1970]];
        NSString *ext = [videoURL pathExtension];
        NSString *path = [Utils getFilePath:fn ext:ext inDir:gImageCacheDir];
        NSString *string= [videoURL path];
        fp = [Utils moveFile:string toFile:path]?path:nil;
    }
    @catch (NSException *e){
        NSLog(@"create thumbnail exception.");
    }
    return fp;
}
+ (NSString *)savePhotoFromMediaInfo:(NSDictionary*)info{
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    if (!image)
        [info valueForKey:UIImagePickerControllerOriginalImage];
    
    if (![info valueForKey:UIImagePickerControllerReferenceURL]) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    NSData *data = UIImageJPEGRepresentation([image fixOrientation], 0);
    NSString *fp = nil;
    @try{
        NSString *fn = [Utils format:@"yyyyMMddhhmmss" time:[[NSDate date] timeIntervalSince1970]];
        NSString *path = [Utils getFilePath:fn ext:@"jpg" inDir:gImageCacheDir];
        fp = [data writeToFile:path atomically:YES]?path:nil;
    }
    @catch (NSException *e){
        NSLog(@"create thumbnail exception.");
    }
    
    return fp;
}
@end

@implementation VideoUtils

+ (void)convertVideoFromMov:(NSString *)movFile toMp4:(NSString *)mp4 withCallback:(void (^)(AVAssetExportSession *exportSession, NSError *error))callback{
    
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:movFile] options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:AVAssetExportPresetLowQuality]){
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset presetName:AVAssetExportPresetPassthrough];
        exportSession.outputURL = [NSURL fileURLWithPath:mp4];
        exportSession.outputFileType = AVFileTypeMPEG4;
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            DLOG(@"%d",[exportSession status]);
            NSError *error = nil;
            switch ([exportSession status]) {
                    
                case AVAssetExportSessionStatusFailed:
                    error = [exportSession error];
                    break;
                    
                case AVAssetExportSessionStatusCancelled:
                    error = [NSError errorWithDomain:@"AVAssetExportSession Error" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"压缩失败"}];
                    
                    break;
                    
                default:
                    
                    break;
            }
            if (callback) {
                [NSThread runOnMainQueue:^{
                    callback(exportSession,error);
                }];
            }
        }];
        
    }
}
@end
