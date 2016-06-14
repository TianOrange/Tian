//
//  TJTagView.h
//  ImageLabel
//
//  Created by Tian on 16/6/14.
//  Copyright © 2016年 Tian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJWaterFlowImageView.h"
#import "Pch.h"

@interface TJTagView : UIView

/**
 *  判断是否是正向和反向 NO and YES
 */
@property (nonatomic ,assign) BOOL isPositiveAndNegative;
/**
 *  标签图片+文本
 */
@property (nonatomic ,strong) TJWaterFlowImageView *imageLabel;
/**
 *  最开始点击是不显示标签图片只显示一个点  默认NO : 不显示标签 NO And 显示 YES
 */
@property (nonatomic ,assign) BOOL isImageLabelShow;

@end
