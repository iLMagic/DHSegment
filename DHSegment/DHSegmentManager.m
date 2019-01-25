//
//  DHSegmentView.m
//  Tea
//
//  Created by DH on 2017/5/10.
//  Changed by DH on 2018/10/17
//  Copyright © 2017年 Ticsmatic. All rights reserved.
//  备注：功能已完善，待封装


#define kButtonFont [UIFont systemFontOfSize:16]
#define kViewHeight 44
#define kLineHeight 1

#import "DHSegmentManager.h"

@interface DHSegmentView1 ()

@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) UIView *bottomLine;

@property (nonatomic, weak) UIButton *lastSelectedBtn;

@property (nonatomic, assign) BOOL autoAnimating;
/// 线条的frame集合
@property (nonatomic, strong) NSMutableArray *lineFrameArray;

@end

@implementation DHSegmentView1

- (instancetype)initWithTitles:(NSArray *)titles originalIndex:(int)originalIndex {
    if (self = [super initWithFrame:CGRectZero]) {
        self.backgroundColor = [UIColor whiteColor];
        _titles = titles;
        _lineFrameArray = @[].mutableCopy;
        [self creatUI];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.lineFrameArray.count) {
                self.line.frame = [self.lineFrameArray[originalIndex] CGRectValue];
                [self setSelectedWithIndex:originalIndex];
            }
        });
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat btnWidth = self.bounds.size.width / _titles.count;
    CGFloat btnHeight = self.bounds.size.height;
    for (int i = 0; i < _titles.count; i ++) {
        UIButton *btn = self.subviews[i];
        CGFloat x = btnWidth * i;
        CGFloat y = 0;
        btn.frame = CGRectMake(x, y, btnWidth, btnHeight);
    }
    if (!_lineFrameArray.count) {
        for (int i = 0; i < _titles.count; i ++) {
            UIButton *btn = self.subviews[i];
            CGFloat strWidth = [btn.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:btn.titleLabel.font} context:nil].size.width;
            CGFloat lineH = kLineHeight;
            CGFloat lineY = self.bounds.size.height - kLineHeight;
            CGFloat lineW = strWidth; // + 10; // 滚动线条的宽度为文字的宽度 + 10
            CGFloat lineX = (btn.bounds.size.width - lineW) * 0.5 + btn.frame.origin.x;
            [_lineFrameArray addObject:[NSValue valueWithCGRect:CGRectMake(lineX, lineY, lineW, lineH)]];
        }
    }
}

- (void)creatUI {
    
    for (int i = 0; i < _titles.count; i ++) {
        UIButton *btn = [UIButton new];
        btn.tag = i;
        [btn setTitle:_titles[i] forState:UIControlStateNormal];
        btn.titleLabel.font = kButtonFont;
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    
    _bottomLine = ({
        UIView *v = [UIView new];
        v.backgroundColor = [UIColor yellowColor];
        [self addSubview:v];
//        [v mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.bottom.equalTo(self);
//            make.height.offset(0.5);
//        }];
        v;
    });
    
    _line = ({
        UIView *v = [UIView new];
        v.backgroundColor = [UIColor blueColor];
        [self addSubview:v];
        v;
    });
    
}

- (void)setSelectedWithIndex:(NSInteger)index {
    if (index > self.subviews.count - 2 || index < 0) {
        NSAssert(NO, @"The index beyond scope.");
    }
    _line.frame = [_lineFrameArray[index] CGRectValue];
    UIButton *btn = self.subviews[index];
    if (btn.selected) return;
    btn.selected = YES;
    _lastSelectedBtn.selected = NO;
    _lastSelectedBtn = btn;
}

- (void)btnDidClick:(UIButton *)sender {
    
    if (sender.selected) {
        return;
    }
    _autoAnimating = YES;
    [UIView animateWithDuration:0.25 animations:^{
        _line.frame = [_lineFrameArray[sender.tag] CGRectValue];
    } completion:^(BOOL finished) {
        [self setSelectedWithIndex:sender.tag];
        _autoAnimating = NO;
    }];
    
    if (_btnDidClickEvent) {
        _btnDidClickEvent((int)sender.tag);
    }
}

- (void)scrollWithScale:(CGFloat)scale fromIndex:(NSInteger)index {
    
    // 获取当前选中的index
    CGRect originFrame;
    CGRect endFrame;
    if (index == _lineFrameArray.count - 1 && scale > 0) {
        // 滑到顶部再向左滑
    } else if (index == 0 && scale < 0) {
        // 滑到底部再向右滑
    } else {
        originFrame = [_lineFrameArray[index] CGRectValue];
        CGFloat x;
        CGFloat y = originFrame.origin.y;
        if (scale > 0) { // 往右划
            endFrame = [_lineFrameArray[index + 1] CGRectValue];
            x = originFrame.origin.x + (endFrame.origin.x - originFrame.origin.x) * scale;
        } else { // 往左滑
            endFrame = [_lineFrameArray[index - 1] CGRectValue];
            x = originFrame.origin.x + (endFrame.origin.x - originFrame.origin.x) * -scale;
        }
        CGFloat w = originFrame.size.width + (endFrame.size.width - originFrame.size.width) * scale;
        CGFloat h = originFrame.size.height;
        _line.frame = CGRectMake(x, y, w, h);
    }
}

@end

