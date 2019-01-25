//
//  DHSegmentView.h
//  Tea
//
//  Created by DH on 2017/5/10.
//  Copyright © 2017年 Ticsmatic. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface DHSegmentView1 : UIView
@property (nonatomic, strong) NSArray *titles;

- (instancetype)initWithTitles:(NSArray *)titles originalIndex:(int)originalIndex;

- (void)scrollWithScale:(CGFloat)scale fromIndex:(NSInteger)index;

- (void)setSelectedWithIndex:(NSInteger)index;

@property (nonatomic, copy) void(^btnDidClickEvent)(int index);

@end



