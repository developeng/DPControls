//
//  DPSliderView.h
//  DPControls
//
//  Created by developeng on 2019/9/2.
//  Copyright © 2019 developeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JASlider.h"
#import "JARulerView.h"
#import "DPEnum.h"
NS_ASSUME_NONNULL_BEGIN


@interface DPSliderView : UIView

@property (nonatomic, assign) DPSliderType sliderType;
@property (nonatomic, assign) CGFloat max;
@property (nonatomic, assign) CGFloat min;
@property (nonatomic, assign) NSInteger rowNum;
@property (nonatomic, assign) CGFloat stepLength;
@property (nonatomic, assign) BOOL isDecimal;

@property (nonatomic, copy) NSString *unit;
@property (nonatomic, copy) NSString *defaultValue;

@property (nonatomic, assign) CGFloat selectValue;//

@end

NS_ASSUME_NONNULL_END
