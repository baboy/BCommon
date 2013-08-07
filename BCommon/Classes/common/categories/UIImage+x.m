//
//  XUIImage.m
//  ITvie
//
//  Created by yinghui zhang on 2/15/11.
//  Copyright 2011 tvie. All rights reserved.
//

#import "UIImage+x.h"

CGFloat RadiansOfDegrees(CGFloat degrees) {return degrees * M_PI / 180;};


CGMutablePathRef createRoundCornerPath(CGRect rect,float rad){
	CGMutablePathRef path = CGPathCreateMutable();
	float minx = CGRectGetMinX(rect), midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect);
	float miny = CGRectGetMinY(rect), midy = CGRectGetMidY(rect), maxy = CGRectGetMaxY(rect);
 	CGPathMoveToPoint(path,NULL, minx, midy);
	CGPathAddArcToPoint(path,NULL, minx, miny, midx, miny, rad);
	CGPathAddArcToPoint(path,NULL, maxx, miny, maxx, midy, rad);
	CGPathAddArcToPoint(path,NULL, maxx, maxy, midx, maxy, rad);
	CGPathAddArcToPoint(path,NULL, minx, maxy, minx, midy, rad);	
	return path;
}
void createPath(CGContextRef ctx,CGRect rect,float rad){
	float minx = CGRectGetMinX(rect), midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect);
	float miny = CGRectGetMinY(rect), midy = CGRectGetMidY(rect), maxy = CGRectGetMaxY(rect);
 	CGContextMoveToPoint(ctx, minx, midy);
	CGContextAddArcToPoint(ctx, minx, miny, midx, miny, rad);
	CGContextAddArcToPoint(ctx, maxx, miny, maxx, midy, rad);
	CGContextAddArcToPoint(ctx, maxx, maxy, midx, maxy, rad);
	CGContextAddArcToPoint(ctx, minx, maxy, minx, midy, rad);
}
UIImage * createImageWithImage(UIImage *originImage, CGSize imageSize, UIColor *shadowColor, CGSize shadowOffset,UIColor *borderColor, int borderWidth, int radius){
    CGFloat scale = [[UIScreen mainScreen] scale];
	float blur = 2.0;
    imageSize = CGSizeMake(imageSize.width+2*blur, imageSize.height+2*blur);
    int w = imageSize.width;
    int h = imageSize.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor clearColor] set];
    CGRect rect = CGRectInset(CGRectMake(0, 0, w, h), blur, blur);
	CGContextSaveGState(ctx);
	CGMutablePathRef path = NULL;
    if (shadowColor) {
        CGContextSetShadowWithColor(ctx, shadowOffset, blur, [shadowColor CGColor]);
    }
    path = createRoundCornerPath(rect, radius);
    CGContextBeginPath(ctx);
    CGContextAddPath(ctx, path);
    CGContextClosePath(ctx);
    CGContextSetFillColorWithColor(ctx,borderColor.CGColor);
    CGContextFillPath(ctx);
    CGPathRelease(path);
    CGContextSetShadowWithColor(ctx, CGSizeZero, 0, NULL);
	if (borderColor) {
		rect = CGRectInset(rect, borderWidth, borderWidth);
	}
	path = createRoundCornerPath(rect, radius);
	CGContextBeginPath(ctx);
    CGContextAddPath(ctx, path);
	CGContextClosePath(ctx);
    CGContextClip(ctx);
	CGPathRelease(path);
	
	CGContextDrawImage(ctx, rect, originImage.CGImage);
    CGImageRef mask = CGBitmapContextCreateImage(ctx);
	CGContextRestoreGState(ctx);
    //CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
	UIImage *newImage = [UIImage imageWithCGImage:mask scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
	CGImageRelease(mask);
    return newImage;
}

@implementation UIImage (x)  
- (UIImage *)resizableWithCapInsets:(UIEdgeInsets)capInsets{
    if ([self respondsToSelector:@selector(resizableImageWithCapInsets:resizingMode:) ]) {
        return [self resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch];
    }
    if ([self respondsToSelector:@selector(resizableImageWithCapInsets:)]) {
        return [self resizableImageWithCapInsets:capInsets];
    }
    return [self stretchableImageWithLeftCapWidth:capInsets.left topCapHeight:capInsets.top];
}
- (UIImage *)resizableWithCenter{
    UIEdgeInsets capInsets = UIEdgeInsetsMake((int)(self.size.height/2), (int)(self.size.width/2), (int)(self.size.height/2)-1, (int)(self.size.width/2)-1);
    return [self resizableWithCapInsets:capInsets];
}
- (UIImage *)scaleToSize:(CGSize)size{  
	// 创建一个bitmap的context  
    // 并把它设置成为当前正在使用的context  
    UIGraphicsBeginImageContext(size);  
    // 绘制改变大小的图片  
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];  
    // 从当前context中创建一个改变大小后的图片  
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();  
    // 使当前的context出堆栈  
    UIGraphicsEndImageContext();  
    // 返回新的改变大小后的图片  
    return scaledImage;  
}  
- (UIImage *)cropToRect:(CGRect) rect{
    //定义裁剪的区域相对于原图片的位置
    CGImageRef imageRef = self.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, rect);
	
   // UIGraphicsBeginImageContext(rect.size);
    //CGContextRef context = UIGraphicsGetCurrentContext();
   // CGContextDrawImage(context, rect, subImageRef);
    UIImage* subImage = [UIImage imageWithCGImage:subImageRef];
   // UIGraphicsEndImageContext();
    //返回裁剪的部分图像
	CGImageRelease(subImageRef);
    return subImage;
}
- (UIImage *)cropToScale:(float) scale{
    float w = self.size.width, h = self.size.height;
    float scale2 = w/h;
    if ( scale2 > scale ) {
        w = h*scale;
    }else{
        h = w/scale;
    }
    CGRect rect = CGRectMake((self.size.width-w)/2, (self.size.height-h)/2, w, h);
    return [self cropToRect:rect];
}

- (UIImage *)imageWithAlpha:(float) alpha{
	UIGraphicsBeginImageContext(self.size);  
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height) blendMode:kCGBlendModeNormal alpha:alpha]; 
    UIImage* img = UIGraphicsGetImageFromCurrentImageContext();  
    UIGraphicsEndImageContext(); 
	return img;
}
- (UIImage *)imageWithColor:(UIColor *)color {
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGSize scaleSize = CGSizeMake(self.size.width*scale, self.size.height*scale);
    UIGraphicsBeginImageContext(scaleSize);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, scaleSize.width, scaleSize.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -scaleSize.height);
    
    CGContextSaveGState(ctx);
    CGContextClipToMask(ctx, area, self.CGImage);    
    [color set];
    CGContextFillRect(ctx, area);	
    CGContextRestoreGState(ctx);    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextDrawImage(ctx, area, self.CGImage);	
    UIImage *_newImg = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();    
    return _newImg;
}
- (UIImage *)grayImage{
    int width = self.size.width;
    int height = self.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,width,height,8,0,colorSpace,kCGImageAlphaNone);
    CGColorSpaceRelease(colorSpace);
    
    if (context == NULL) {
        return nil;
    }
    
    CGContextDrawImage(context,CGRectMake(0, 0, width, height), self.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    
    return grayImage;
}
- (UIImage *)maskWithImage:(UIImage *)mask
{
	UIGraphicsBeginImageContext(self.size);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
	CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
	
	CGImageRef maskRef = mask.CGImage;
	
	CGImageRef maskImage = CGImageMaskCreate(CGImageGetWidth(maskRef),
											 CGImageGetHeight(maskRef),
											 CGImageGetBitsPerComponent(maskRef),
											 CGImageGetBitsPerPixel(maskRef),
											 CGImageGetBytesPerRow(maskRef),
											 CGImageGetDataProvider(maskRef), NULL, false);
	
	CGImageRef masked = CGImageCreateWithMask([self CGImage], maskImage);
	CGImageRelease(maskImage);
	
	CGContextDrawImage(ctx, area, masked);
	CGImageRelease(masked);
	UIImage *_newImg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
	
	return _newImg;
}
+(UIImage *) imageWithColor:(UIColor *)color size:(CGSize)imgSize{
	CGRect rect = CGRectMake(0, 0, imgSize.width, imgSize.height);
	UIGraphicsBeginImageContext(imgSize);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(ctx, [color CGColor]);
	CGContextFillRect(ctx, rect);
	UIImage *_img = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return _img;
}
+(UIImage *) playButtonWithColor:(UIColor *)color rect:(CGRect)rect{
	CGRect r = CGRectInset(rect, 2, 2);
	float minx = CGRectGetMinX(r), maxx = CGRectGetMaxX(r);
	float miny = CGRectGetMinY(r), midy = CGRectGetMidY(r), maxy = CGRectGetMaxY(r);
	rect.size.width += rect.origin.x;
	rect.size.height += rect.origin.y;
	UIGraphicsBeginImageContext(rect.size);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	CGContextMoveToPoint(ctx, minx, miny);
	CGContextAddLineToPoint(ctx, maxx, midy);
	CGContextAddLineToPoint(ctx, minx, maxy);
	CGContextAddLineToPoint(ctx, minx, miny);
	CGContextClosePath(ctx);	
	CGContextSetShadowWithColor(ctx, CGSizeMake(-1, -1), 1, [UIColor colorWithWhite:0 alpha:1].CGColor);
	CGContextSetFillColorWithColor(ctx, [color CGColor]);
	CGContextDrawPath(ctx, kCGPathFill);  
	
	UIImage *_img = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return _img;
}
- (UIImage *)imageWithShadowColor:(UIColor *)color size:(CGSize)imgSize offset:(CGSize)offset{
	float w = imgSize.width+offset.width*(offset.width>0?2:-2),h = imgSize.height+offset.height*(offset.height>0?2:-2);
	
	UIGraphicsBeginImageContext(CGSizeMake(w, h));
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextSetShadowWithColor(ctx, offset, 5, color.CGColor);	
	[self drawInRect:CGRectMake(offset.width>0?0:-offset.width, offset.height>0?0:-offset.height, imgSize.width, imgSize.height)];
	UIImage *_img = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return _img;
}
- (UIImage *)imageWithShadowColor:(UIColor *)color offset:(CGSize)offset{
	return [self imageWithShadowColor:color size:self.size offset:offset];
}

- (UIImage *)imageWithCornerRadius:(int)rad borderColor:(UIColor *)borderColor size:(CGSize)imgSize{
	int w = imgSize.width;
    int h = imgSize.height;
    CGRect rect = CGRectMake(0, 0, w, h);
	
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef ctx = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    
	CGContextSaveGState(ctx);
    //CGContextBeginPath(ctx);	
	
	CGMutablePathRef path = NULL;
	if (borderColor) {		
		path = createRoundCornerPath(rect, rad);	
		CGContextBeginPath(ctx);
		CGContextAddPath(ctx, path);
		CGContextClosePath(ctx);
		CGContextClip(ctx);
		CGContextSetFillColorWithColor(ctx,borderColor.CGColor);
		CGContextFillRect(ctx, rect);  
		CGPathRelease(path);	
		rect = CGRectInset(rect, 1, 1);
		
	}
	path = createRoundCornerPath(rect, rad);
	CGContextBeginPath(ctx);
    CGContextAddPath(ctx, path);
	CGContextClosePath(ctx);
    CGContextClip(ctx);
	CGPathRelease(path);
	
	CGContextDrawImage(ctx, rect, self.CGImage);
    CGImageRef mask = CGBitmapContextCreateImage(ctx);
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
	UIImage *_img = [UIImage imageWithCGImage:mask];
	CGImageRelease(mask);
    
    return _img;
}
- (UIImage *)imageRotatedByDegrees:(float)degrees
{
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(RadiansOfDegrees(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    CGContextRotateCTM(bitmap, RadiansOfDegrees(degrees));
    
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}
@end  

CGGradientRef createGradient(CGContextRef ctx,NSArray *colors,CGFloat locations[]){
	int count = [colors count];
	CGFloat* components = malloc(sizeof(CGFloat)*4*count);
	for (int i = 0; i < count; ++i) {
		CGColorRef color = [[colors objectAtIndex:i] CGColor];
		size_t n = CGColorGetNumberOfComponents(color);
		const CGFloat* rgba = CGColorGetComponents(color);
		if (n == 2) {
			components[i*4] = rgba[0];
			components[i*4+1] = rgba[0];
			components[i*4+2] = rgba[0];
			components[i*4+3] = rgba[1];
		} else if (n == 4) {
			components[i*4] = rgba[0];
			components[i*4+1] = rgba[1];
			components[i*4+2] = rgba[2];
			components[i*4+3] = rgba[3];
		}
	}
	CGColorSpaceRef space = CGBitmapContextGetColorSpace(ctx);
	CGGradientRef _gradient = CGGradientCreateWithColorComponents(space, components, locations, count);
	free(components);
	return _gradient;
}
UIImage * createButtonBg(UIColor *bgColor,UIColor* borderColor,CGSize imgSize){
	float rad = 5.0;
    CGRect rect = CGRectMake(0, 0, imgSize.width, imgSize.height);
	
	UIGraphicsBeginImageContext(imgSize);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	CGContextSaveGState(ctx);
    //CGContextBeginPath(ctx);
	CGRect r = CGRectInset(rect, 2, 2);
	r.size.height -= 1;
	createPath(ctx, r,rad);
	CGContextClosePath(ctx);
	CGContextSetShadowWithColor(ctx, CGSizeMake(0, 1), 2, [UIColor blackColor].CGColor);	
	CGContextSetFillColorWithColor(ctx,borderColor.CGColor);
	CGContextDrawPath(ctx, kCGPathFill);
	
	
	r = CGRectInset(r, 1, 1);
	createPath(ctx, r,rad);
	CGContextClosePath(ctx);
	CGContextSetShadowWithColor(ctx, CGSizeZero, 0, NULL);	
	CGContextSetFillColorWithColor(ctx,bgColor.CGColor);
	CGContextDrawPath(ctx, kCGPathFill);
	
	UIImage *_img = UIGraphicsGetImageFromCurrentImageContext();
    CGContextRestoreGState(ctx);
	UIGraphicsEndImageContext();
	return _img;	
}
UIImage * createGradientButtonBg(NSArray *bgColors,CGFloat locations[],UIColor* borderColor,CGSize imgSize,float rad){
    CGRect rect = CGRectMake(0, 0, imgSize.width, imgSize.height);
	
	UIGraphicsBeginImageContext(imgSize);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	CGContextSaveGState(ctx);
    //CGContextBeginPath(ctx);
	CGRect r = CGRectInset(rect, 2, 2);
	createPath(ctx, r,rad);
    
	CGContextClosePath(ctx);
	CGContextSetShadowWithColor(ctx, CGSizeMake(0, 1), 2, [UIColor blackColor].CGColor);	
	CGContextSetFillColorWithColor(ctx,borderColor.CGColor);
	CGContextDrawPath(ctx, kCGPathFill);
	
	r = CGRectInset(r, 1, 1);
	createPath(ctx, r,rad);
    
	CGContextClosePath(ctx);	
	CGContextClip(ctx);
	
	CGGradientRef gradient = createGradient(ctx,bgColors,locations);
	CGPoint s = r.origin;
	CGPoint e = CGPointMake(s.x, s.y+r.size.height);
	CGContextDrawLinearGradient(ctx, gradient,s,e, kCGGradientDrawsAfterEndLocation);
	CGGradientRelease(gradient);

	
	UIImage *_img = UIGraphicsGetImageFromCurrentImageContext();
    CGContextRestoreGState(ctx);
	UIGraphicsEndImageContext();
	return _img;	
}


@implementation UIImage (fixOrientation)

- (UIImage *)fixOrientation {
    
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end