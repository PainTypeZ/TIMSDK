//
//  TUIDarkModel.h
//  TUICore
//
//  Created by xiangzhang on 2021/9/9.
//  Copyright © 2023 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@import UIKit;

@interface UIColor (TUIDarkModel)

+ (UIColor *)d_colorWithColorLight:(UIColor *)light dark:(UIColor *)dark __attribute__((deprecated("use TUICoreDynamicColor()")));
+ (UIColor *)d_systemGrayColor __attribute__((deprecated("use TUICoreDynamicColor()")));
+ (UIColor *)d_systemRedColor __attribute__((deprecated("use TUICoreDynamicColor()")));
+ (UIColor *)d_systemBlueColor __attribute__((deprecated("use TUICoreDynamicColor()")));

@end

/////////////////////////////////////////////////////////////////////////////////
//
//                           Dark Mode
//
/////////////////////////////////////////////////////////////////////////////////

@interface UIImage (TUIDarkModel)
/**
 * path: normal image path (without @x.png suffix), dark image path must be "normal image path_dark"
 */
+ (UIImage *)d_imagePath:(NSString *)path __attribute__((deprecated("use TUIDemoBundleThemeImage(imageKey,defaultImageName)")));

/**
 *
 *  imageName: common image name, dark image name must be "ordinary image name_dark"
 *  bundleName: bundleName where the image is stored
 */
+ (UIImage *)d_imageNamed:(NSString *)imageName
                   bundle:(NSString *)bundleName __attribute__((deprecated("use TUIDemoBundleThemeImage(imageKey,defaultImageName)")));

+ (UIImage *)d_imageWithImageLight:(NSString *)lightImagePath
                              dark:(NSString *)darkImagePath __attribute__((deprecated("use TUIDemoBundleThemeImage(imageKey,defaultImageName)")));

+ (void)d_fixResizableImage;

+ (UIImage *)d_imageWithImageLightImg:(UIImage *)lightImage
                                 dark:(UIImage *)darkImage __attribute__((deprecated("use TUIDemoBundleThemeImage(imageKey,defaultImageName)")));
@end
