//
//  GooBadgeButton.h
//  GooBadgeButtonDemo
//
//  Created by sungrow on 2017/8/2.
//  Copyright © 2017年 sungrow. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GooBadgeButton;

@protocol GooBadgeButtonDelegate <NSObject>

@optional

/**
 将要消失

 @param gooBadgeButton gooBadgeButton
 */
- (void)gooBadgeButtonWillDisappear:(GooBadgeButton *)gooBadgeButton;

/**
 已经消失

 @param gooBadgeButton gooBadgeButton
 */
- (void)gooBadgeButtonDidDisappear:(GooBadgeButton *)gooBadgeButton;

/**
 将要恢复位置

 @param gooBadgeButton gooBadgeButton
 */
- (void)gooBadgeButtonWillResumePosition:(GooBadgeButton *)gooBadgeButton;

/**
 已经恢复位置

 @param gooBadgeButton gooBadgeButton
 */
- (void)gooBadgeButtonDidResumePosition:(GooBadgeButton *)gooBadgeButton;

/**
 移动 会持续调用

 @param gooBadgeButton gooBadgeButton
 @param point 移动到的点
 @param isInDragDistance 是否在拖拽范围
 */
- (void)gooBadgeButton:(GooBadgeButton *)gooBadgeButton movingWithPoint:(CGPoint)point  inDragDistance:(bool)isInDragDistance;

@end

@interface GooBadgeButton : UIButton

@property (nonatomic, weak) id<GooBadgeButtonDelegate> delegate;

@end
