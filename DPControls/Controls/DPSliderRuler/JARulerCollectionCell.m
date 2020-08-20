//
//  JARulerCollectionCell.m
//  JAXuMu
//
//  Created by developeng on 2019/8/28.
//  Copyright © 2019 developeng. All rights reserved.
//

#import "JARulerCollectionCell.h"


#define kHorizontalCell (self.numberDirection == numberTop || self.numberDirection == numberBottom)

@interface JARulerCollectionCell ()

@end

@implementation JARulerCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.ruleImageView];
    }
    return self;
}

- (void)setUnit:(NSString *)unit{
    _unit = unit;
    
}

- (void)setSliderType:(DPSliderType)sliderType{
    _sliderType = sliderType;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    objAssert(self.unit);
    
    if (self.index % 5 == 0) {
        NSString *text = @"";
        if (self.isDecimal) {
            NSInteger showIndex = self.index/10 + self.min;
            if (self.reverse) {
                showIndex = self.max - showIndex + self.min;
                text = [NSString stringWithFormat:@"%ld", showIndex];
            } else {
                text = [NSString stringWithFormat:@"%ld", self.index/10 + self.min];
            }
        } else {
            NSInteger showIndex = self.index*self.stepLength + self.min;
            if (self.reverse) {
                text = [NSString stringWithFormat:@"%ld%@", (long)(self.max - showIndex + self.min),self.unit];
            } else {
                text = [NSString stringWithFormat:@"%ld%@", (long)showIndex,self.unit];
            }
        }
        //字体
        CGSize size = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH_RULER, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.numberFont} context:nil].size;
        //水平方向
        CGFloat startY = 0;
        if (self.numberDirection == numberTop) {
            //数字在上面，刻度尺在下方
            startY = self.shortScaleStart - self.distanceFromScaleToNumber - size.height;
        } else if (self.numberDirection == numberBottom) {
            //数字在下面，刻度尺在上方
            startY = self.shortScaleStart + self.shortScaleLength + self.distanceFromScaleToNumber;
        }
        self.textLayer.frame = CGRectMake((CGRectGetWidth(self.contentView.frame) - size.width)/2.0, startY, size.width, size.height);
        self.textLayer.string = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: self.numberFont, NSForegroundColorAttributeName: self.numberColor}];
        [self.contentView.layer addSublayer:self.textLayer];
    } else {
        self.textLayer.string = nil;
        [self.textLayer removeFromSuperlayer];
    }
    
    //刻度尺
    CGFloat length = ((self.index % 5 == 0) ? self.longScaleLength : self.shortScaleLength);
    CGFloat start = ((self.index % 5 == 0) ? self.longScaleStart : self.shortScaleStart);
    self.ruleImageView.frame = kHorizontalCell ? CGRectMake(0, start, self.scaleWidth, length) : CGRectMake(start, 0, length, self.scaleWidth);
    self.ruleImageView.layer.cornerRadius = self.scaleWidth/2.0;
    self.ruleImageView.backgroundColor = self.scaleColor;
    
    if (self.sliderType == DPSliderType_TYPE_II) {
        NSInteger showIndex = self.index*self.stepLength + self.min;
        if (showIndex > self.selectValue) {
            self.ruleImageView.backgroundColor = self.scaleColor;
        } else {
            self.ruleImageView.backgroundColor = [UIColor colorWithHexString:@"#33AD37"];
        }
    }
}

#pragma mark - 隐藏当前cell的文字
- (void)makeCellHiddenText {
    self.textLayer.string = nil;
    [self.textLayer removeFromSuperlayer];
}

#pragma mark - getter
- (UIImageView *)ruleImageView {
    if (!_ruleImageView) {
        _ruleImageView = [[UIImageView alloc] init];
    }
    return _ruleImageView;
}

- (CATextLayer *)textLayer {
    if (!_textLayer) {
        _textLayer = [CATextLayer layer];
        _textLayer.contentsScale = [UIScreen mainScreen].scale;
        _textLayer.alignmentMode = @"center";
    }
    return _textLayer;
}

@end
