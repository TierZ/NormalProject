//
//  GuideView.m
//  NormalProject
//
//  Created by lf on 16/10/24.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import "GuideView.h"

@interface GuideView()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView     *scrollView;
@property (nonatomic, strong) UIPageControl    *pageView;
@property (nonatomic, strong) NSMutableArray   *dataArr;    // 图片资源
@end
@implementation GuideView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self batCreateSubViews];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self batCreateSubViews];
    }
    return self;
}
- (void)batCreateSubViews {
    CGFloat bottomH = 80;
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = self.bounds;
    _scrollView.bottom = self.height-bottomH;
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    [self addSubview:_scrollView];

//    __weak __typeof__(self) weak_self = self;
//    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 80, 0));
//    }];
    
    CGFloat w = self.scrollView.width;
    CGFloat h = self.scrollView.height;
    NSInteger count = 4;
    for (int i = 0; i < count; i++) {
        CGFloat x = i*w;
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, w, h)];
        
        imgView.backgroundColor = [UIColor randomColor];
        [_scrollView addSubview:imgView];
        
        if (i == count-1) {
            UIButton *intoAppBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [intoAppBtn setTitle:@"Let's go!" forState:UIControlStateNormal];
            intoAppBtn.frame = CGRectMake(0, 0, 80, 60);
            intoAppBtn.right = imgView.width - 20;
            intoAppBtn.bottom = imgView.height - 20;
            [intoAppBtn addTarget:self action:@selector(intoAppBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
            imgView.userInteractionEnabled = YES;
            [imgView addSubview:intoAppBtn];
        }
    }
    _scrollView.contentSize = CGSizeMake(count*_scrollView.width, _scrollView.height);
    _pageView = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, w, 20)];
    _pageView.bottom = _scrollView.bottom - 10;
    _pageView.numberOfPages = count;
    _pageView.userInteractionEnabled = NO;
    _pageView.currentPageIndicatorTintColor = [UIColor blackColor];
    _pageView.pageIndicatorTintColor = [UIColor lightGrayColor];
    [self addSubview:_pageView];

    UIView *copyRightView = [[UIView alloc] init];
    copyRightView.frame = CGRectMake(0, 0, _scrollView.width, bottomH);
    copyRightView.top = _scrollView.bottom;
    copyRightView.backgroundColor = [UIColor orangeColor];
    [self addSubview:copyRightView];
//    [copyRightView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_scrollView.mas_bottom);
//        make.left.and.right.and.bottom.equalTo(weak_self);
//    }];
}
- (void)intoAppBtnDidClick:(UIButton *)sender {
    if (self.actionBlock) {
        self.actionBlock();
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.x;
    NSInteger page = offset / scrollView.width;
    self.pageView.currentPage = page;
}
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArr;
}
@end
