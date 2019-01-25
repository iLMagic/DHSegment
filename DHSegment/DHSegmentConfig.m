
//
//  DHSegmentConfig.m
//  Example
//
//  Created by DH on 2019/1/25.
//  Copyright © 2019年 DH. All rights reserved.
//

#import "DHSegmentConfig.h"

@implementation DHSegmentConfig
+ (instancetype)defalutConfig {
    DHSegmentConfig *config = [DHSegmentConfig new];
    config.color = [UIColor grayColor];
    config.selectedColor = [UIColor orangeColor];
    config.font = [UIFont systemFontOfSize:14];
    config.font = [UIFont boldSystemFontOfSize:18];
    config.scrollBarColor = [UIColor orangeColor];
    return config;
}
@end
