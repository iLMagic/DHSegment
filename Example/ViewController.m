//
//  ViewController.m
//  Example
//
//  Created by DH on 2019/1/24.
//  Copyright © 2019年 DH. All rights reserved.
//

#import "ViewController.h"
#import "DHPageViewController.h"
#import "DHSegmentView.h"
#import <Masonry.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSMutableArray *vcs = @[].mutableCopy;
    
    {
        IndexController vc = ^{
            UIViewController *vc = [UIViewController new];
            vc.title = @"1";
            vc.view.backgroundColor = [UIColor redColor];
            return vc;
        };
        [vcs addObject:vc];
    }
    {
        IndexController vc = ^{
            UIViewController *vc = [UIViewController new];
            vc.title = @"2";
            vc.view.backgroundColor = [UIColor blueColor];
            return vc;
        };
        [vcs addObject:vc];
    }
    {
        IndexController vc = ^{
            UIViewController *vc = [UIViewController new];
            vc.title = @"3";
            vc.view.backgroundColor = [UIColor yellowColor];
            return vc;
        };
        [vcs addObject:vc];
    }

    {
        IndexController vc = ^{
            UIViewController *vc = [UIViewController new];
            vc.title = @"4";
            vc.view.backgroundColor = [UIColor orangeColor];
            return vc;
        };
        [vcs addObject:vc];
    }


    
    DHSegmentView *segmentView = [[DHSegmentView alloc] initWithTitles:@[@"全部", @"待付款", @"待收货", @"待评价"] config:^(DHSegmentConfig *config) {
        
    }];
    [self.view addSubview:segmentView];
    [segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.offset(44);
   }];
 
    DHPageViewController *vc = [DHPageViewController VCWithControllesBlocks:vcs originalIndex:0];
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(segmentView.mas_bottom);
    }];
}


@end
