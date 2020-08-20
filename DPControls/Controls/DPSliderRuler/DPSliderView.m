//
//  DPSliderView.m
//  DPControls
//
//  Created by developeng on 2019/9/2.
//  Copyright © 2019 developeng. All rights reserved.
//

#import "DPSliderView.h"
#define back_W 290*SCREEN_WIDTH/375.0
#define back_H 150*SCREEN_HEIGHT/667.0

@interface DPSliderView()

@property (nonatomic, strong) UILabel *selectLab;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) JASlider *slider;
@property (nonatomic, strong) JARulerView *numberRulerView;

@property (nonatomic, assign) CGFloat selectSliderValue;
@property (nonatomic, assign) CGFloat totalLength;//总长；
@end

@implementation DPSliderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self defaultSettings];
    }
    return self;
}

#pragma mark - 默认设置
- (void)defaultSettings {
    self.max = 100;
    self.min = 0;
    self.unit = @"";
    self.defaultValue = [JANumber FloatKeepBitsAndRemoveAllZero:self.min];
    self.rowNum = 20;
    self.stepLength = 1;
    self.isDecimal = NO;
    self.sliderType = DPSliderType_TYPE_I;
}

- (void)updateDefaultSettings{
    self.slider.minimumTrackTintColor = [UIColor clearColor];
    self.slider.maximumTrackTintColor = [UIColor clearColor];
    _numberRulerView.type = _sliderType;
    _numberRulerView.backgroundColor = [UIColor whiteColor];
}

- (void)setupUI{
    
    self.leftBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:@"setup_subtract"] forState:UIControlStateNormal];
        button;
    });
    [self addSubview:self.leftBtn];
    
    self.rightBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"setup_add"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self addSubview:self.rightBtn];
    [self addSubview:self.numberRulerView];
    self.slider = ({
        JASlider *slider = [JASlider new];
        slider.minimumValue = 0.0;
        slider.maximumValue = 1.0;
        slider.value = 0;
        slider.minimumTrackTintColor = [UIColor colorWithHexString:@"#33AD37"];
        slider.maximumTrackTintColor = [UIColor colorWithHexString:@"#f6f6f6"];
        [slider setThumbImage:[UIImage imageNamed:@"setup_slider"] forState:UIControlStateNormal];
        [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        slider;
    });
    [self addSubview:self.slider];
    self.selectLab = ({
        UILabel *label = [UILabel new];
        label.frame = CGRectMake(FIT_SCALE(45)+(back_W-FIT_SCALE(100)-20)*0,  FIT_SCALE(35), FIT_SCALE(30), FIT_SCALE(15));
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:10];
        label.backgroundColor = [UIColor colorWithHexString:@"#33AD37"];
        label.layer.cornerRadius = FIT_SCALE(7.5);
        label.layer.masksToBounds = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    [self addSubview:self.selectLab];
    
    
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.slider.mas_left).offset(-FIT_SCALE(5));
        make.centerY.mas_equalTo(self.slider.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(FIT_SCALE(40), FIT_SCALE(40)));
    }];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.slider.mas_right).offset(FIT_SCALE(5));
        make.centerY.mas_equalTo(self.slider.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(FIT_SCALE(40), FIT_SCALE(40)));
    }];
    
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(FIT_SCALE(50)+ (self.slider.currentThumbImage.size.width/2));
        make.right.mas_equalTo(-FIT_SCALE(50)-(self.slider.currentThumbImage.size.width/2));
        make.height.mas_equalTo(FIT_SCALE(20));
    }];
    
    [self.numberRulerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.slider.mas_bottom);
        make.left.mas_equalTo(FIT_SCALE(50)-10);
        make.bottom.mas_equalTo(-FIT_SCALE(30));
        make.width.mas_equalTo(back_W-FIT_SCALE(100)+20);
    }];
}

- (JARulerView *)numberRulerView{
    if (!_numberRulerView) {
        _numberRulerView = [JARulerView new];
//        _numberRulerView.backgroundColor = [UIColorFromHex(0xE4E6EB) colorWithAlphaComponent:0.3f];
    }
    return _numberRulerView;
}

- (void)setSliderType:(DPSliderType)sliderType{
    _sliderType = sliderType;
    if (sliderType == DPSliderType_TYPE_II) {
        [self updateDefaultSettings];
        [self.numberRulerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.slider.mas_top);
            make.left.mas_equalTo(FIT_SCALE(50)-10);
            make.bottom.mas_equalTo(-FIT_SCALE(30));
            make.width.mas_equalTo(back_W-FIT_SCALE(100)+20);
        }];
    }
}

- (void)setUnit:(NSString *)unit{
    _unit = unit;
    _numberRulerView.unit = unit;
}

-(void)sliderValueChanged:(UISlider *)slider{
    self.selectSliderValue = slider.value;
    self.selectValue = _numberRulerView.min +(self.totalLength*self.selectSliderValue);
}

- (void)leftBtnClick:(UIButton *)button{
    if (self.selectValue-self.stepLength < _numberRulerView.min) {
        return;
    }
    self.selectValue = self.selectValue - self.stepLength;
    [self scrollViewSlider];
}

- (void)rightBtnClick:(UIButton *)button{
    if (self.selectValue+self.stepLength > _numberRulerView.max) {
        return;
    }
    self.selectValue = self.selectValue +self.stepLength;
    [self scrollViewSlider];
}

- (void)scrollViewSlider{
    self.selectSliderValue = (_selectValue - _numberRulerView.min)*1.0/self.totalLength;
    self.slider.value = self.selectSliderValue;
}

- (void)setSelectValue:(CGFloat)selectValue{
    _selectValue = selectValue;
    [self scrollViewSlider];
    objAssert(self.unit);
    self.selectLab.frame = CGRectMake(FIT_SCALE(45)+(back_W-FIT_SCALE(100)-20)*self.selectSliderValue, FIT_SCALE(35), FIT_SCALE(35), FIT_SCALE(15));
    if (!self.isDecimal) {
        self.selectLab.text = NSStringFormat(@"%.0f%@",self.selectValue,self.unit);
    } else {
        self.selectLab.text = NSStringFormat(@"%@%@",[JANumber FloatKeepBitsAndRemoveAllZero:self.selectValue],self.unit);
    }
    if (self.sliderType == DPSliderType_TYPE_II) {
         self.numberRulerView.selectValue = selectValue;
    }
}

- (void)setDefaultValue:(NSString *)defaultValue{
    _defaultValue = defaultValue;
}

- (void)setStepLength:(CGFloat)stepLength{
    _stepLength = stepLength;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _numberRulerView.max = self.max;
    _numberRulerView.min = self.min;
    _numberRulerView.rowNum = self.rowNum;
    _numberRulerView.unit = self.unit;
    self.totalLength = _numberRulerView.max-_numberRulerView.min;
    if ([self.defaultValue floatValue] <= _numberRulerView.min) {
        self.selectValue = _numberRulerView.min;
    } else {
        self.selectValue = [self.defaultValue floatValue];
    }
}

@end
