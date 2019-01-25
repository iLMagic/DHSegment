//
//  DHSegmentView.h
//  Example
//
//  Created by DH on 2019/1/25.
//  Copyright © 2019年 DH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DHSegmentConfig;
typedef void(^DHSegmentConfigBlock)(DHSegmentConfig *config);

@interface DHSegmentView : UIView


- (instancetype)initWithTitles:(NSArray *)titles config:(DHSegmentConfigBlock)config;

@end


