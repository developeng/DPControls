//
//  JASliderAlertView.h
//  JAXuMu
//
//  Created by developeng on 2019/8/27.
//  Copyright © 2019 developeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JASlider.h"
#import "JARulerView.h"

NS_ASSUME_NONNULL_BEGIN


@interface JASliderAlertView : UIView

@property (nonatomic, assign) DPSliderType sliderType;
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, copy) NSString *defaultValue;
@property (nonatomic, assign) BOOL isDecimal;

@property (nonatomic, assign) CGFloat max;
@property (nonatomic, assign) CGFloat min;
@property (nonatomic, assign) NSInteger rowNum;
@property (nonatomic, assign) CGFloat stepLength;


@property (nonatomic, copy) void(^UpdateValueEvent)(NSString *value);

- (void)show;

@end

NS_ASSUME_NONNULL_END
