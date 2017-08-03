# GooBadgeButton
Goo Badge Button view iOS

<img src="https://github.com/YQqiang/GooBadgeButton/blob/master/GooBadgeButton.gif" alt="GooBadgeButton.gif" width="320"> 

### 代理方法
```Objective-C
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
```
