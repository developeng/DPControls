//
//  JANumber.h
//  JAFarmers
//
//  Created by developeng on 2019/4/1.
//  Copyright © 2019 developeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JANumber : NSObject

+ (NSString *)decimalWithValue:(double)conversionValue;

//处理价格显示问题
//处理价格显示问题
+ (NSMutableAttributedString *)attrPriceWithPrice:(CGFloat)price
                                            fonts:(NSArray<UIFont *> *_Nullable)fonts
                                            color:(UIColor *)color;


// 末尾清零
+ (NSString *)FloatKeepBitsAndRemoveAllZero:(float)floatnum;

@end

NS_ASSUME_NONNULL_END
