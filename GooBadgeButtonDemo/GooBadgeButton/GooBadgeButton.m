//
//  GooBadgeButton.m
//  GooBadgeButtonDemo
//
//  Created by sungrow on 2017/8/2.
//  Copyright © 2017年 sungrow. All rights reserved.
//

#import "GooBadgeButton.h"

@interface GooBadgeButton ()

@property(nonatomic,strong)UIView *smallView;

@property(nonatomic,assign)CGFloat radius;

@property(nonatomic,strong)CAShapeLayer *shapeLayer;

@end

@implementation GooBadgeButton

#pragma mark - lazy
-(CAShapeLayer *)shapeLayer {
    if (!_shapeLayer) {
        //    绘制不规则的矩形，不能通过绘图，因为绘图只能在当前控价上画，超出部分不能显示
        //    通过不规则矩形路径生成一个图层
        CAShapeLayer *layer = [CAShapeLayer layer];
        _shapeLayer = layer;
        layer.fillColor = self.backgroundColor.CGColor;
        [self.superview.layer insertSublayer:layer below:self.layer];
    }
    return _shapeLayer;
}

-(UIView *)smallView {
    if (_smallView == nil) {
        _smallView = [[UIView alloc]init];
    }
    return _smallView;
}

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUp];
}

//重写初始化方法
- (void)setUp {
    CGFloat w = CGRectGetWidth(self.frame);
    CGFloat h = CGRectGetHeight(self.frame);
    CGRect selfRect = self.frame;
    selfRect.size = CGSizeMake(MAX(w, h), MAX(w, h));
    self.frame = selfRect;
    
    _radius = MAX(w, h) * 0.5;
    
    self.layer.cornerRadius = _radius;
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    [self addGestureRecognizer:pan];
    
    //    设置小圆的位置和尺寸
    self.smallView.center = self.center;
    self.smallView.bounds = self.bounds;
    self.smallView.layer.cornerRadius = _radius;
}

#pragma mark - overwrite
- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self.superview insertSubview:self.smallView belowSubview:self];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    self.smallView.backgroundColor = self.backgroundColor;
}

#pragma mark - private Action
- (void)panAction:(UIPanGestureRecognizer *)pan {
    CGPoint transP = [pan translationInView:self];
    //    让控件跟着手指移动
    CGPoint point = self.center;
    point.x += transP.x;
    point.y += transP.y;
    self.center = point;
    [pan setTranslation:CGPointZero inView:self];
    
    //    设置小圆的半径，随着两个圆心的距离增大，半径逐渐减小
    CGFloat dictace = [self circlyDictanceBigCircle:self.center withSmallCircle:self.smallView.center];
    CGFloat tempRadius = _radius - dictace / 10;
    
    //    设置小圆的尺寸
    self.smallView.bounds = CGRectMake(0, 0, tempRadius * 2, tempRadius * 2);
    self.smallView.layer.cornerRadius = tempRadius;
    
    if (tempRadius < 5) {
        self.smallView.hidden = YES;
        [self.shapeLayer removeFromSuperlayer];
        self.shapeLayer = nil;
    } else {
        //        当有圆心距离，且圆心距离不大，才需要展示
        self.smallView.hidden = NO;
        self.shapeLayer.path = [self circleWithBigCircleView:self withSmallCircleView:self.smallView].CGPath;
    }
    if ([self.delegate respondsToSelector:@selector(gooBadgeButton:movingWithPoint:inDragDistance:)]) {
        [self.delegate gooBadgeButton:self movingWithPoint:point inDragDistance:!(tempRadius < 5)];
    }
    
    //    手指抬起时，还原
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (tempRadius < 5) {
            if ([self.delegate respondsToSelector:@selector(gooBadgeButtonWillDisappear:)]) {
                [self.delegate gooBadgeButtonWillDisappear:self];
            }
            //            展示动画
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.bounds];
            NSMutableArray *arrM = [NSMutableArray array];
            for (int i = 1; i < 9; i ++) {
                UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"GooBadgeButton%d.jpg",i]];
                [arrM addObject:image];
            }
            
            imageView.animationImages = arrM;
            imageView.animationDuration = 0.5;
            imageView.animationRepeatCount = 1;
            [imageView startAnimating];
            
            //           需要把系统自带的约束设置为no，否则是回到开始的位置才消失
            [self addSubview:imageView];
            //            延时0.4秒，把视图删除
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self removeFromSuperview];
                if ([self.delegate respondsToSelector:@selector(gooBadgeButtonDidDisappear:)]) {
                    [self.delegate gooBadgeButtonDidDisappear:self];
                }
            });
        }else {
            [self.shapeLayer removeFromSuperlayer];
            self.shapeLayer = nil;
            if ([self.delegate respondsToSelector:@selector(gooBadgeButtonWillResumePosition:)]) {
                [self.delegate gooBadgeButtonWillResumePosition:self];
            }
            [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.center = self.smallView.center;
            } completion:^(BOOL finished) {
                if ([self.delegate respondsToSelector:@selector(gooBadgeButtonDidResumePosition:)]) {
                    [self.delegate gooBadgeButtonDidResumePosition:self];
                }
            }];
            self.smallView.hidden = NO;
        }
    }
}

//计算两个圆圆心之间的大小
- (CGFloat)circlyDictanceBigCircle:(CGPoint)bigCircle withSmallCircle:(CGPoint)smallCircle {
    CGFloat x = pow((bigCircle.x - smallCircle.x), 2);
    CGFloat y = pow((bigCircle.y - smallCircle.y), 2);
    return sqrt(x + y);
}


//计算不规则矩形
- (UIBezierPath *)circleWithBigCircleView:(UIView *)bigCircleView withSmallCircleView:(UIView *)smallCircleView {
    //    坐标系都是基于父控件
    CGPoint bigCenter = bigCircleView.center;
    CGFloat x2 = bigCenter.x;
    CGFloat y2 = bigCenter.y;
    CGFloat r2 = bigCircleView.bounds.size.width / 2;
    
    CGPoint smallCenter = smallCircleView.center;
    CGFloat x1 = smallCenter.x;
    CGFloat y1 = smallCenter.y;
    CGFloat r1 = smallCircleView.bounds.size.width / 2;
    
    //    获取圆心距离
    CGFloat d = [self circlyDictanceBigCircle:bigCenter withSmallCircle:smallCenter];
    CGFloat sinΘ = (x2 - x1) / d;
    CGFloat cosΘ = (y2 - y1) / d;
    
    CGPoint pointA = CGPointMake(x1 - r1 * cosΘ, y1 + r1 * sinΘ);
    CGPoint pointB = CGPointMake(x1 + r1 * cosΘ, y1 - r1 * sinΘ);
    CGPoint pointC = CGPointMake(x2 + r2 * cosΘ, y2 - r2 * sinΘ);
    CGPoint pointD = CGPointMake(x2 - r2 * cosΘ, y2 + r2 * sinΘ);
    CGPoint pointO = CGPointMake(pointA.x + d / 2 * sinΘ, pointA.y + d / 2 * cosΘ);
    CGPoint pointP = CGPointMake(pointB.x + d / 2 * sinΘ, pointB.y + d / 2 * cosΘ);
    
    //    设置起点
    UIBezierPath *path = [UIBezierPath bezierPath];
    //    A点
    [path moveToPoint:pointA];
    //    AB
    [path addLineToPoint:pointB];
    //    绘制BC曲线
    [path addQuadCurveToPoint:pointC controlPoint:pointP];
    //    CD
    [path addLineToPoint:pointD];
    //    绘制DA曲线
    [path addQuadCurveToPoint:pointA controlPoint:pointO];
    
    return path;
}

@end
