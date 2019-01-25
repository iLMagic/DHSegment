//
//  DHSegmentConfig.h
//  Example
//
//  Created by DH on 2019/1/25.
//  Copyright © 2019年 DH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DHSegmentConfig : NSObject

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIFont *selectedFont;
@property (nonatomic, strong) UIColor *scrollBarColor;
//@property (nonatomic, strong) UIColor *backgroundColor;
+ (instancetype)defalutConfig;
@end

