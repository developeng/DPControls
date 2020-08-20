//
//  JABaseModel.m
//  JAFarmers
//
//  Created by developeng on 2019/3/17.
//  Copyright © 2019 developeng. All rights reserved.
//

#import "JABaseModel.h"

@implementation JABaseModel

- (instancetype)initWithDict:(NSDictionary *)dict{
    
    return [JABaseModel mj_objectWithKeyValues:dict];
}

- (NSDictionary *)dict {
    return self.mj_keyValues;
}

+ (NSArray *)dictArrayWithModelArray:(NSArray *)modelArr {
    return [self mj_keyValuesArrayWithObjectArray:modelArr];
}

+ (NSArray *)modelArrayWithDictArray:(NSArray *)dictArr {
    return [self mj_objectArrayWithKeyValuesArray:dictArr];
}

// 重写此方法，避免model中的属性与key对应不上出现崩溃
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    /**
     通过-initWithDictionary：方法初始化模型类肯定不会执行此方法（运行时原理）
     这里主要为了防止外面通过直接调用：-setValue:(id)value forKey:(NSString *)key
     或：-setValue:(id)value forKeyPath:(NSString *)keyPath
     以及：-setValuesForKeysWithDictionary:(NSDictionary *)keyedValues
     时候出现崩溃情况
     */
}
@end
