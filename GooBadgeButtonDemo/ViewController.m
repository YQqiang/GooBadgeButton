//
//  ViewController.m
//  GooBadgeButtonDemo
//
//  Created by sungrow on 2017/8/2.
//  Copyright © 2017年 sungrow. All rights reserved.
//

#import "ViewController.h"
#import "GooBadgeButton.h"

@interface ViewController ()<GooBadgeButtonDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GooBadgeButton *gooBadgeBtn = [[GooBadgeButton alloc] initWithFrame:CGRectMake(180, 100, 20, 20)];
    gooBadgeBtn.delegate = self;
    gooBadgeBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:gooBadgeBtn];
    
}

#pragma mark - GooBadgeButtonDelegate
- (void)gooBadgeButtonWillResumePosition:(GooBadgeButton *)gooBadgeButton {
    NSLog(@"--------- 将要恢复位置");
}

- (void)gooBadgeButtonDidResumePosition:(GooBadgeButton *)gooBadgeButton {
    NSLog(@"--------- 已经恢复位置");
}

- (void)gooBadgeButtonWillDisappear:(GooBadgeButton *)gooBadgeButton {
    NSLog(@"--------- 将要消失");
}

- (void)gooBadgeButtonDidDisappear:(GooBadgeButton *)gooBadgeButton {
    NSLog(@"--------- 已经消失");
}

- (void)gooBadgeButton:(GooBadgeButton *)gooBadgeButton movingWithPoint:(CGPoint)point inDragDistance:(bool)isInDragDistance {
    NSLog(@"--------- 移动 point = %@", NSStringFromCGPoint(point));
    NSLog(@"--------- 是否在拖拽范围 isInDragDistance = %zd", isInDragDistance);
}

@end
