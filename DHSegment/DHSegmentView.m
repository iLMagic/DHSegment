//
//  DHSegmentView.m
//  Example
//
//  Created by DH on 2019/1/25.
//  Copyright © 2019年 DH. All rights reserved.
//

#import "DHSegmentView.h"
#import "DHSegmentConfig.h"
#import <Masonry.h>

@interface DHSegmentView ()
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) DHSegmentConfig *config;
@property (nonatomic, strong) NSMutableArray *btns;
@end

@implementation DHSegmentView

- (instancetype)initWithTitles:(NSArray *)titles config:(DHSegmentConfigBlock)config {
    if (self = [super initWithFrame:CGRectZero]) {
        _titles = titles;
        
        DHSegmentConfig *defaultConfig = [DHSegmentConfig defalutConfig];
        if (config) {
            config(defaultConfig);
        }
        _config = defaultConfig;
  
        _btns = @[].mutableCopy;
        
        [self setupUI];
    }
    return self;

}

- (void)setupUI {
    
    // 根据title创建buttom
    for (int i = 0; i < _titles.count; i ++) {
        UIButton *btn = [UIButton new];
        [_btns addObject:btn];
        [self addSubview:btn];
//        btn.tag = i;
        [btn setTitle:_titles[i] forState:UIControlStateNormal];
        // 设置属性
        btn.titleLabel.font = _config.font;
        [btn setTitleColor:_config.color forState:UIControlStateNormal];
        [btn setTitleColor:_config.selectedColor forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        // 设置约束
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self);
            make.width.equalTo(self).multipliedBy(1 / self.titles.count);
        }];
        if (i == 0) {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self);
            }];
        }
        if (i == _titles.count - 1) {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self);
            }];
        }
        if (i > 0 && i < _titles.count - 1) {
            UIButton *lastBtn = _btns[i - 1];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastBtn.mas_right);
            }];
        }

    }
    
    
}

- (void)btnDidClick:(UIButton *)sender {
    
}
@end
