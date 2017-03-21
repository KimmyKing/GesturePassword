//
//  LockView.m
//  手势解锁
//
//  Created by Cain on 16/5/22.
//  Copyright © 2016年 Cain. All rights reserved.
//

#define kViewWidth self.frame.size.width
#define kColumn 3
#define kButtonWidth 80
#define kCount 9
#define kRightColoc [[UIColor blackColor]set]
#define KWrongColor [[UIColor redColor]set];

#import "LockView.h"

@interface LockView ()

// 存放所有的button , 9个按钮
@property (nonatomic , strong)NSMutableArray *buttonArray;
@property (nonatomic , strong)NSMutableArray *selectedArray;
@property (nonatomic , assign)CGPoint currentPoint;
// 记录当前密码是否是正确状态
@property (nonatomic , assign)BOOL right;

@end

@implementation LockView

#pragma mark
#pragma mark 初始化数组
- (NSMutableArray *)buttonArray {
    if (nil == _buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

#pragma mark
#pragma mark - 初始化 被选中按钮的数组
- (NSMutableArray *)selectedArray{
    if (nil == _selectedArray) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        // 把right bool 默认设置为YES
        _right =YES;
        
        [self setUpUI];
    }
    return self;
}

#pragma mark
#pragma mark 添加按钮
- (void)setUpUI{
    
    //计算按钮之间的空隙
    CGFloat margin = (kViewWidth - kColumn * kButtonWidth)/(kColumn +1);
    
    for (int i = 0; i < kCount; i++) {
        //行索引和列索引
        NSInteger row = i / kColumn;
        NSInteger col = i % kColumn;
        
        //计算x和y
        CGFloat buttonX = (col+1) *margin + col *kButtonWidth;
        CGFloat buttonY = (row+1) *margin + row *kButtonWidth;
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(buttonX, buttonY, kButtonWidth, kButtonWidth)];
        
        // 禁用 button被点击后的高亮适应
        button.adjustsImageWhenDisabled = NO;
        
        [button setBackgroundImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        
//        设置选中状态下的图片
        [button setBackgroundImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
        
       
        
        /**
         enabled 禁用
         会改变按钮的颜色
         按钮要在不同的 状态下进行切换 普通状态 被选择状态 所以不能使用enable
         
         userInteractionEnabled 禁用
         */
        
#warning 为button 设置tag , 用来作为 密码
        button.tag = i;
        
        button.userInteractionEnabled = NO;
        // 把按钮添加到数组
        [self.buttonArray addObject:button];
        
        [self addSubview:button];
    }
    
    
}

#pragma mark
#pragma mark 点击
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self checkPointInsideWithWith:touches];
}

#pragma mark
#pragma mark 移动
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self checkPointInsideWithWith:touches];
}

#pragma mark
#pragma mark - 检测手指所在的位置是否在 button的半径之内
- (void)checkPointInsideWithWith:(NSSet *)touches{
     // 获取当前点击的位置
    UITouch *touch = touches.anyObject;
    CGPoint touchPoint = [touch locationInView:self];
    
     // 和button的中心点进行比对 , 如果 x和y 的差值 小于button宽度的一半, 就表示 触摸的这个点在button内部
    for (UIButton *button  in self.buttonArray) {
        // 取出button的中心点
        CGPoint buttonCenter = button.center;
        // 计算x和y 之间的差值
        CGFloat deltaX = ABS(buttonCenter.x - touchPoint.x);
        CGFloat deltaY = ABS(buttonCenter.y - touchPoint.y);
        
         // 对间距进行判断
        if (deltaX < kButtonWidth /2 && deltaY < kButtonWidth/2) {
#warning           当点击按钮的时候, 把button的状态变为选中状态
//            如果按钮已经被选中,就不需要再设置
            if (!button.isSelected) {
                button.selected = YES;
                
                // 把这个被选中按钮添加到 被选择数组中
                [self.selectedArray addObject:button];
            }
        }
    }
    // 为 当前点进行赋值
    _currentPoint = touchPoint;
#warning 因为DrawRect方法只调用1次，所以如果需要刷新图形，需要用setNeedsDisplay强制调用刷新。
    //重绘
    [self setNeedsDisplay];
}

#pragma mark
#pragma mark - 绘制线条
- (void)drawRect:(CGRect)rect{
    
    if (self.selectedArray.count != 0) {
        // 开始绘制
        // 获取图形上下文
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        // 设置线宽
        CGContextSetLineWidth(context, 10);
        
        // 设置颜色
        _right ? kRightColoc : KWrongColor;
        
        // 声明一个c语言数组 有9个元素,都是CGPoint类型的数据
        CGPoint point[9];
        
        //定义索引
        int index = 0;
        
        for (UIButton *button  in self.selectedArray) {
            //取出button的中心点
            CGPoint buttonCenter = button.center;
            // 把中心点放到 数组中
            point[index++] = buttonCenter;
        }
        
        /**
         第一个参数: 上下文
         第二个参数: 数组, 存放的是 CGPoint
         第三个参数: 数组的个数
         */
        CGContextAddLines(context, point, index);
        
        //渲染
        CGContextStrokePath(context);
        
    // 绘制跟随手指移动的线(按钮的中心点到触摸点的线)
        //取出在selectedArray中最后一个按钮
        UIButton *lastButton = self.selectedArray.lastObject;
        
        // 取出 最后一个按钮的 中心点
        CGPoint lastPoint = lastButton.center;
        
       // 拼接路径
        CGContextMoveToPoint(context, lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(context, _currentPoint.x, _currentPoint.y);
        
        // 设置 线头样式
        CGContextSetLineCap(context, kCGLineCapRound);
         // 渲染
        CGContextStrokePath(context);
    
    }
}

#pragma mark
#pragma mark - 手指离开屏幕
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //取出密码
    NSMutableString *password = [NSMutableString string];
    for (UIButton *button in self.selectedArray) {
        
        [password appendFormat:@"%ld",button.tag];
        
    }
    NSLog(@"%@",password);
    
     // 清空lockView
    [self clearLockView];
    
//    通知代理(传递密码)
    if ([self.delegate respondsToSelector:@selector(LockView:password:)]) {
        [self.delegate LockView:self password:password];
    }
}

#pragma mark
#pragma mark - 绘制 错误的密码
- (void)setErrorPassword:(NSString *)errorPassword{
    _errorPassword = errorPassword ;
    NSInteger length = errorPassword.length;
    for (int i = 0; i <length; i++) {
         // 截取errorPassword中的每一个字符串,并转化为NSInteger
        NSRange range = NSMakeRange(i, 1);
        NSInteger index = [[errorPassword substringWithRange:range]integerValue];
        
        UIButton *button = self.buttonArray[index];
        button.selected = YES;
        
        // 修改按钮的 选中的背景图片
        [button setBackgroundImage:[UIImage imageNamed:@"gesture_node_error"] forState:UIControlStateSelected];
         // 把按钮放入 selectedArray 中
        [self.selectedArray addObject:button];
    }
//    修改颜色标记
    _right = NO;
    
    [self setNeedsDisplay];
    
     // 延迟执行 清空 lockView 操作
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self clearLockView];
    });
    
}

#pragma mark
#pragma mark - 清空lockView 并把按钮图片和线条的显色恢复成初始状态
- (void)clearLockView{
    for (UIButton *button  in self.selectedArray) {
        button.selected = NO;
        
        // 把背景图片换成蓝色的 (如果绘制错误的时候, 会切换背景图片 为 红色的)
        [button setBackgroundImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
    }
    // 线条也要清除掉 (清空数组)
    [self.selectedArray removeAllObjects];

// 把线条的颜色恢复成蓝色
    _right = YES;
    
    //重绘
    [self setNeedsDisplay];
}

@end
