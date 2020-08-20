//
//  JARulerView.h
//  JAXuMu
//
//  Created by developeng on 2019/8/28.
//  Copyright © 2019 developeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPEnum.h"
#import "JARulerCollectionCell.h"

NS_ASSUME_NONNULL_BEGIN
@class DPSliderView;
@protocol RulerViewDelegate <NSObject>

- (void)rulerSelectValue:(double)value tag:(NSInteger)tag;

@end

@interface JARulerView : UIView

//视图属性
@property (nonatomic, assign) CGFloat shortScaleLength;                         /**< 短刻度长度  */
@property (nonatomic, assign) CGFloat longScaleLength;                          /**< 长刻度长度  */
@property (nonatomic, assign) CGFloat scaleWidth;                               /**< 刻度尺宽度  */
@property (nonatomic, strong) UIColor *scaleColor;                              /**< 刻度颜色  */
@property (nonatomic, assign) CGFloat shortScaleStart;                          /**< 短刻度起始位置  */
@property (nonatomic, assign) CGFloat longScaleStart;                           /**< 长刻度起始位置  */
@property (nonatomic, assign) CGFloat distanceBetweenScale;                     /**< 刻度之间的距离  */
@property (nonatomic, assign) RulerNumberDirection numberDirection;             /**< 数字方向  */
@property (nonatomic, assign) CGFloat distanceFromScaleToNumber;                /**< 刻度和数字之间的距离  */
//数字属性
@property (nonatomic, strong) UIFont *numberFont;                               /**< 数字字体  */
@property (nonatomic, strong) UIColor *numberColor;                             /**< 数字颜色  */
//刻度相关
@property (nonatomic, assign) NSInteger max;                                    /**< 最大值  */
@property (nonatomic, assign) NSInteger min;                                    /**< 最小值  */
@property (nonatomic, assign) double defaultNumber;                             /**< 默认值  */
//选项
@property (nonatomic, assign) BOOL isDecimal;                                   /**< 保留一位小数类型  */
@property (nonatomic, assign) BOOL selectionEnable;                             /**< 是否允许选中  */
@property (nonatomic, assign) BOOL useGradient;                                 /**< 是否使用渐变色  */
@property (nonatomic, assign) BOOL reverse;

@property (nonatomic, assign) NSInteger rowNum;
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, assign) DPSliderType type;
@property (nonatomic, assign) CGFloat selectValue;//

@property (nonatomic, weak) id<RulerViewDelegate> delegate;                     /**< 代理  */

@end

NS_ASSUME_NONNULL_END
