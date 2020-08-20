//
//  JASliderAlertView.m
//  JAXuMu
//
//  Created by developeng on 2019/8/27.
//  Copyright © 2019 developeng. All rights reserved.
//

#import "JASliderAlertView.h"
#import "DPSliderView.h"
#define back_W 290*SCREEN_WIDTH/375.0
#define back_H 150*SCREEN_HEIGHT/667.0

@interface JASliderAlertView()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, strong) DPSliderView *sliderView;

@end

@implementation JASliderAlertView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        self.isDecimal = NO;
    }
    return self;
}

- (void)setupUI{
    
    self.backGroundView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = FIT_SCALE(10);
        view;
    });
    [self addSubview:self.backGroundView];
    
    self.sliderView = ({
        DPSliderView *view = [DPSliderView new];
        view.max = 75;
        view.min = 0;
        view.rowNum = 15;
        view.stepLength = 1;
        view.isDecimal = NO;
        view;
    });
    [self.backGroundView addSubview:self.sliderView];
    
    [self.backGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(back_W, back_H));
    }];
    
    [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.backGroundView);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    tap.delegate = self;
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
}

- (void)setSliderType:(DPSliderType)sliderType{
    _sliderType = sliderType;
    self.sliderView.sliderType = sliderType;
}

- (void)setUnit:(NSString *)unit{
    _unit = unit;
    self.sliderView.unit = unit;
}

- (void)setDefaultValue:(NSString *)defaultValue{
    _defaultValue = defaultValue;
    self.sliderView.defaultValue = defaultValue;
}

- (void)setMax:(CGFloat)max{
    _max = max;
    self.sliderView.max = max;
}

- (void)setMin:(CGFloat)min{
    _min = min;
    self.sliderView.min = min;
}

- (void)setRowNum:(NSInteger)rowNum{
    _rowNum = rowNum;
    self.sliderView.rowNum = rowNum;
}

- (void)setStepLength:(CGFloat)stepLength{
    _stepLength = stepLength;
    self.sliderView.stepLength = stepLength;
}

- (void)setIsDecimal:(BOOL)isDecimal{
    _isDecimal = isDecimal;
    self.sliderView.isDecimal = isDecimal;
}

// 展示弹窗
- (void)show{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    self.backGroundView.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
    self.backGroundView.alpha = 0;
    [UIView animateWithDuration:.7f delay:0.f usingSpringWithDamping:.7f initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        self.backGroundView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        self.backGroundView.alpha = 1.0;
    } completion:nil];
}
// 隐藏弹窗
- (void)dismiss {
    if (self.UpdateValueEvent) {
        NSString *value  = @"";
        if (!self.isDecimal) {
            value = NSStringFormat(@"%.0f",self.sliderView.selectValue);
        } else {
            value = [JANumber FloatKeepBitsAndRemoveAllZero:self.sliderView.selectValue];
        }
        self.UpdateValueEvent(value);
    }
    [UIView animateWithDuration:0.3f animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        self.backGroundView.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
        self.backGroundView.alpha = 0;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:self.backGroundView]) {
        return NO;
    }
    return YES;
}

@end
