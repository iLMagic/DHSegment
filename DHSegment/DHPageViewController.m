//
//  DHPageViewController.m
//  DHSegment
//
//  Created by DH on 2019/1/24.
//  Copyright © 2019年 DH. All rights reserved.
//

#import "DHPageViewController.h"

@interface DHPageViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray *pageControllers;

@property (nonatomic, assign) BOOL autoAnimating;
@end
@implementation DHPageViewController

+ (instancetype)VCWithControllesBlocks:(NSArray<IndexController> *)controllerBlocks originalIndex:(int)originalIndex {
    DHPageViewController *vc = [[DHPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    vc.currentIndex = originalIndex;
    vc.pageControllers = controllerBlocks.mutableCopy;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    self.dataSource = self;
    
    UIScrollView *pageScrollView = [self findScrollView];
    pageScrollView.delegate = self;
    [self selectedViewControllerWithIndex:_currentIndex];
    
//    UIStackView
}

- (void)selectedViewControllerWithIndex:(int)index {
    
    int tempIndex;
    if (self.viewControllers.count) {
        tempIndex = (int)[_pageControllers indexOfObject:self.viewControllers[0]];
    } else {
        tempIndex = -1;
    }
    
    UIPageViewControllerNavigationDirection direction;
    if (index == tempIndex) {
        return;
    } else if (index > tempIndex) {
        direction = UIPageViewControllerNavigationDirectionForward;
    } else {
        direction = UIPageViewControllerNavigationDirectionReverse;
    }
    
    UIViewController *vc = [self viewControllerAtIndex:index];
    
    _autoAnimating = YES;
    //    @weakify(self);
    [self setViewControllers:@[vc] direction:direction animated:YES completion:^(BOOL finished) {
        //        @strongify(self);
        if (finished) {
            self.autoAnimating = NO;
            self.currentIndex = index;
        }
    }];
}


#pragma mark - 根据index得到对应的UIViewController
- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    if (index < 0 || index >= self.pageControllers.count) {
        return nil;
    }
    id temp = self.pageControllers[index];
    
    if ([temp isKindOfClass:[UIViewController class]]) {
        return temp;
    } else {
        IndexController block = temp;
        UIViewController *vc = block();
        self.pageControllers[index] = vc;
        return vc;
    }
}

- (NSInteger)indexOfViewController:(UIViewController *)viewController {
    return [_pageControllers indexOfObject:viewController];
}

- (UIScrollView *)findScrollView {
    UIScrollView* scrollView;
    for (id subview in self.view.subviews) {
        if ([subview isKindOfClass:UIScrollView.class]) {
            scrollView = subview;
            break;
        }
    }
    return scrollView;
}

#pragma mark - UIPageViewControllerDelegate

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSInteger index = [self indexOfViewController:viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    
    if (index == self.pageControllers.count) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = [self indexOfViewController:viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

#pragma mark - UIPageViewControllerDataSource
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (finished && completed) {
        _currentIndex = (int)[_pageControllers indexOfObject:self.viewControllers[0]];
        if (_scrollStopEvent) {
            _scrollStopEvent(_currentIndex);
        }
        //        NSLog(@"滚动结束：当前页数：%d", _currentIndex);
    }
}

#pragma mark - socrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (_autoAnimating) {
        return;
    }
    // 偏移比例
    //   offsetScale < 0 向左偏移
    //   offsetScale > 0 向右偏移
    CGFloat offsetScale = (scrollView.contentOffset.x - self.view.bounds.size.width) / self.view.bounds.size.width;
    
    if (offsetScale == 0 || offsetScale == 1) {
        return;
    }
    
    //    NSLog(@"%f", offsetScale);
    
    // 滑动到最左边，继续往左滑，暂不处理
    if (_currentIndex == 0 && offsetScale <= 0) {
        return;
    }
    
    // 滑动到最右边，继续往右滑，暂不处理
    if (_currentIndex == _pageControllers.count - 1 && offsetScale >= 0) {
        return;
    }
    
    if (_scrollingEvent) {
        _scrollingEvent(_currentIndex, offsetScale);
    }
    
}



@end
