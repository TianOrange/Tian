//
//  Pch.h
//  ImageLabel
//
//  Created by Tian on 16/6/14.
//  Copyright © 2016年 Tian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Masonry.h"

@interface Pch : NSObject

#define UIColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]


// 细字体
#define Font(F)                 [UIFont systemFontOfSize:(F)]
// 粗字体
#define boldFont(F)             [UIFont boldSystemFontOfSize:(F)]


#ifndef CGWidth
#define CGWidth(rect)                   rect.size.width
#endif

#ifndef CGHeight
#define CGHeight(rect)                  rect.size.height
#endif

#ifndef CGOriginX
#define CGOriginX(rect)                 rect.origin.x
#endif

#ifndef CGOriginY
#define CGOriginY(rect)                 rect.origin.y
#endif

//获得屏幕大小
#define kWindowBounds [[UIScreen mainScreen] bounds]
#define kWindowWidth [[UIScreen mainScreen] bounds].size.width
#define kWindowHeight [[UIScreen mainScreen] bounds].size.height



@end
