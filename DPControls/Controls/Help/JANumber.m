//
//  JANumber.m
//  JAFarmers
//
//  Created by developeng on 2019/4/1.
//  Copyright © 2019 developeng. All rights reserved.
//

#import "JANumber.h"

/** 直接传入精度丢失有问题的Double类型*/
NSString *decimalNumberWithDouble(double conversionValue){
    NSString *doubleString        = [NSString stringWithFormat:@"%lf", conversionValue];
    NSDecimalNumber *decNumber    = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}

@implementation JANumber

+ (NSString *)decimalWithValue:(double)conversionValue{
    return decimalNumberWithDouble(conversionValue);
}

//处理价格显示问题
+ (NSMutableAttributedString *)attrPriceWithPrice:(CGFloat)price
                                            fonts:(NSArray<UIFont *> *_Nullable)fonts
                                            color:(UIColor *)color{
    NSString *Price = [NSString stringWithFormat:@"%.2f",price];
    NSRange range = [Price rangeOfString:@"."];
    NSString *strI = [Price substringToIndex:range.location];
    NSString *strII = [Price substringFromIndex:range.location];
    NSMutableArray *arr = [NSMutableArray array];
    [arr addObject:@"￥"];
    
    NSNumber *remainNum = [NSNumber numberWithInteger:[strI integerValue]];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterRoundFloor;
    [numberFormatter setPositiveFormat:@"###,###"];
    
    [arr addObject:[numberFormatter stringFromNumber:remainNum]];
    [arr addObject:strII];
    
    NSMutableAttributedString *muAttStr = [[NSMutableAttributedString alloc] init];
    for (int ii=0; ii < arr.count; ii++) {
        NSMutableDictionary *attDict = [NSMutableDictionary dictionary];
        if (fonts.count > ii) {
            [attDict setObject:fonts[ii] forKey:NSFontAttributeName];
        } else {
            [attDict setObject:fonts[0] forKey:NSFontAttributeName];
        }
        [attDict setObject:color forKey:NSForegroundColorAttributeName];
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:arr[ii] attributes:[attDict copy]];
        [muAttStr appendAttributedString:attStr];
    }
    return [muAttStr copy];
}
// 末尾清零
+ (NSString *)FloatKeepBitsAndRemoveAllZero:(float)floatnum {
    NSString * tempfloat = [NSString stringWithFormat:@"%0.1f",roundf(floatnum * 10)/10];
    
    return [NSString stringWithFormat:@"%@",@(tempfloat.floatValue)];
}

@end
