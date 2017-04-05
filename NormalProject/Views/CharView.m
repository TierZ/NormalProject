//
//  CharView.m
//  NormalProject
//
//  Created by lf on 2016/12/22.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import "CharView.h"
#define _YLabelWidth   30
#define _YLabelHeight  12

#define _XLabelHeight  12

@interface CharView ()
@property (nonatomic, assign) CGFloat max_x;
@property (nonatomic, assign) CGFloat min_x;
@property (nonatomic, assign) CGFloat max_y;
@property (nonatomic, assign) CGFloat min_y;

@property (nonatomic, strong) NSMutableArray *yBaseValues;
@property (nonatomic, strong) NSMutableArray *xValues;
@property (nonatomic, strong) NSMutableArray *yValues;
@end

@implementation CharView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)drawRect:(CGRect)rect {
    return;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineWidth(context, 3);  //线宽
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
//    CGContextSetRGBStrokeColor(context, 70.0 / 255.0, 241.0 / 255.0, 241.0 / 255.0, 1.0);  //线的颜色
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context, 5, rect.size.height-5-_XLabelHeight-5);  //起点坐标
    CGContextAddLineToPoint(context, rect.size.width-5-_YLabelWidth-5, rect.size.height-5-_XLabelHeight-5);   //终点坐标
    CGContextAddLineToPoint(context, rect.size.width-5-_YLabelWidth-5, 5);   //终点坐标

    CGContextStrokePath(context);
}
- (void)reloadData {
    [self.layer removeAllSublayers];
    [self removeAllSubviews];
    [self drawBaseLineAndYLabel];
    [self drawChartLine];
}
- (void)drawBaseLineAndYLabel {
    // 画6根线
    // 总的画图区域的 宽和高
    if (self.yBaseValues.count < 1) {
        return;
    }
    CGFloat maxW = self.width - 5 - 5 - _YLabelWidth - 5;
    CGFloat maxH = self.height - 10 - 5 - _XLabelHeight - 10;
    CGFloat spaceV = maxH / (self.yBaseValues.count-1); // 纵向间距
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = CGRectMake(0, 0, maxW, maxH);
    layer.lineCap = kCALineCapRound;
    layer.lineJoin = kCALineJoinRound;
    layer.lineWidth = 2;
    layer.strokeColor = [UIColor whiteColor].CGColor;
    UIBezierPath *linePath = [[UIBezierPath alloc] init];
    for (int i = 0; i < self.yBaseValues.count; i++) {
        CGFloat xBegin = 5;
        CGFloat yBegin = 5+5+i*spaceV;
        CGFloat xEnd = xBegin + maxW;
        CGFloat yEnd = yBegin;
        [linePath moveToPoint:CGPointMake(xBegin, yBegin)];
        [linePath addLineToPoint:CGPointMake(xEnd, yEnd)];
    }
    layer.path = linePath.CGPath;
    [self.layer addSublayer:layer];

    for (int i = 0; i < self.yBaseValues.count; i++) {
        id val = self.yBaseValues[i];
        CGFloat x = 5+maxW+5;
        CGFloat y = 5+i*spaceV;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, _YLabelWidth, _YLabelHeight)];
        label.font = [UIFont systemFontOfSize:_YLabelHeight];
        label.textColor = [UIColor whiteColor];
        label.text = [NSString stringWithFormat:@"%@", val];
        [self addSubview:label];
    }
}
- (void)drawChartLine {
    CGFloat maxW = self.width - 5 - 5 - _YLabelWidth - 5;
    CGFloat maxH = self.height - 10 - 5 - _XLabelHeight - 10;
    CGFloat spaceH = (maxW - 5 - 5)/(self.yValues.count-1);
    if (self.yValues.count < 1) {
        return;
    } else {
        NSString *yVal = [NSString stringWithFormat:@"%@", self.yValues[0]];
        NSDecimalNumber *yNum = [NSDecimalNumber decimalNumberWithString:yVal];
        double _y = yNum.doubleValue;
        double __y = MIN(maxH, self.max_y - _y); // 相对距顶y值
        double y = __y/(self.max_y - self.min_y)*maxH; // 绝对y值
        UILabel *beginLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10+maxH+5, 80, _XLabelHeight)];
        beginLabel.backgroundColor = [UIColor grayColor];
        beginLabel.font = [UIFont systemFontOfSize:_XLabelHeight];
        beginLabel.textColor = [UIColor orangeColor];
        beginLabel.text = self.xValues.firstObject;
        [self addSubview:beginLabel];
        
        if (self.yValues.count == 1) {
            CAShapeLayer *layer = [CAShapeLayer layer];
            layer.frame = CGRectMake(0, 0, 4, 4);
            layer.centerX = 5+maxW/2;
            layer.centerY = 10+y;
            layer.cornerRadius = 2;
            layer.backgroundColor = [UIColor blueColor].CGColor;
            [self.layer addSublayer:layer];
            
            beginLabel.centerX = 5+maxW/2;
        } else {
            CAShapeLayer *lineLayer = [CAShapeLayer layer];
            lineLayer.frame = CGRectMake(0, 0, maxW, maxH);
            lineLayer.lineCap = kCALineCapRound;
            lineLayer.lineJoin = kCALineJoinRound;
            lineLayer.lineWidth = 2;
            lineLayer.strokeColor = [UIColor redColor].CGColor;
            lineLayer.fillColor = [UIColor clearColor].CGColor;
            UIBezierPath *linePath = [[UIBezierPath alloc] init];
            
            NSString *yVal = [NSString stringWithFormat:@"%@", self.yValues[0]];
            NSDecimalNumber *yNum = [NSDecimalNumber decimalNumberWithString:yVal];
            double _y = yNum.doubleValue;
            double __y = MIN(maxH, self.max_y - _y); // 相对距顶长度
            double y = __y/(self.max_y - self.min_y)*maxH; // 绝对y值
            [linePath moveToPoint:CGPointMake(10, y+10)];
            
            for (int i = 1; i < self.yValues.count; i++) {
                NSString *yVal = [NSString stringWithFormat:@"%@", self.yValues[i]];
                NSDecimalNumber *yNum = [NSDecimalNumber decimalNumberWithString:yVal];
                double _y = yNum.doubleValue;
                double __y = MIN(maxH, self.max_y - _y);
                double y = __y/(self.max_y - self.min_y)*maxH;
                CGFloat x = 5 + i*spaceH;
                // 画线
                [linePath addLineToPoint:CGPointMake(x, 10+y)];
                if (i == self.yValues.count) {
                    [linePath closePath]; // close的不完整
                }
            }
            lineLayer.fillColor = [UIColor yellowColor].CGColor;
            lineLayer.path = linePath.CGPath;
            lineLayer.backgroundColor = [UIColor greenColor].CGColor;
            [self.layer addSublayer:lineLayer];
            
            UILabel *endLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10+maxH+5, 80, _XLabelHeight)];
            endLabel.backgroundColor = [UIColor grayColor];
            endLabel.right = 5+maxW;
            endLabel.textAlignment = NSTextAlignmentRight;
            endLabel.font = [UIFont systemFontOfSize:_XLabelHeight];
            endLabel.textColor = [UIColor orangeColor];
            endLabel.text = self.xValues.lastObject;
            [self addSubview:endLabel];
        }
    }
}
- (void)resetYBaseValues:(NSArray *)newData {
    [self.yBaseValues removeAllObjects];
    [self.yBaseValues addObjectsFromArray:newData];
    self.max_y = [newData.firstObject floatValue];
    self.min_y = [newData.lastObject floatValue];
}
- (void)resetXValues:(NSArray *)newData {
    [self.xValues removeAllObjects];
    [self.xValues addObjectsFromArray:newData];
}
- (void)resetYValues:(NSArray *)newData {
    [self.yValues removeAllObjects];
    [self.yValues addObjectsFromArray:newData];
}
- (NSMutableArray *)yBaseValues {
    if (!_yBaseValues) {
        _yBaseValues = [NSMutableArray arrayWithCapacity:0];
    }
    return _yBaseValues;
}
- (NSMutableArray *)xValues {
    if (!_xValues) {
        _xValues = [NSMutableArray arrayWithCapacity:0];
    }
    return _xValues;
}
- (NSMutableArray *)yValues {
    if (!_yValues) {
        _yValues = [NSMutableArray arrayWithCapacity:0];
    }
    return _yValues;
}
@end
