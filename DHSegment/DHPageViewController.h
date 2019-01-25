//
//  DHPageViewController.h
//  DHSegment
//
//  Created by DH on 2019/1/24.
//  Copyright © 2019年 DH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef UIViewController *(^IndexController)(void);

@interface DHPageViewController : UIPageViewController
@property (nonatomic, assign) int currentIndex;

/**
 初始化
 
 @param controllerBlocks 控制器
 @return 实例
 */
+ (instancetype)VCWithControllesBlocks:(NSArray <IndexController>*)controllerBlocks originalIndex:(int)originalIndex;

/**
 选中了某个控制器
 
 @param index index
 */
- (void)selectedViewControllerWithIndex:(int)index;

/**
 滑动事件回调
 */
@property (nonatomic, copy) void(^scrollingEvent)(int fromIndex, CGFloat scale);

/**
 滑动结束事件回调
 */
@property (nonatomic, copy) void(^scrollStopEvent)(int currentIndex);

@end

