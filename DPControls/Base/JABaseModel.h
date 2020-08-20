//
//  JABaseModel.h
//  JAFarmers
//
//  Created by developeng on 2019/3/17.
//  Copyright © 2019 developeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>
NS_ASSUME_NONNULL_BEGIN

@interface JABaseModel : NSObject

/**
 *  通过字典进行初始化
 *
 *  @param dict 字典
 *
 *  @return 模型
 */
- (instancetype)initWithDict:(NSDictionary *)dict;

/**
 *  获取模型对应的字典
 *
 *  @return 字典对象
 */
- (NSDictionary *)dict;

/**
 *  获取模型数组对应的字典数组
 *
 *  @param modelArr 模型数组
 *
 *  @return 字典数组
 */
+ (NSArray *)dictArrayWithModelArray:(NSArray *)modelArr;

/**
 *  获取字典数组对应的模型数组
 *
 *  @param dictArr 字典数组
 *
 *  @return 模型数组
 */
+ (NSArray *)modelArrayWithDictArray:(NSArray *)dictArr;

@end

NS_ASSUME_NONNULL_END
