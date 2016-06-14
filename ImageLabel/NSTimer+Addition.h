//
//  NSTimer+Addition.h
//  ImageLabel
//
//  Created by Tian on 16/6/14.
//  Copyright © 2016年 Tian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Addition)

//关闭定时器
- (void)pauseTimer;
//启动定时器
- (void)resumeTimer;
//添加一个定时器
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;

@end
