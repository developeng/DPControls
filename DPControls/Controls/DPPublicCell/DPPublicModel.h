//
//  DPPublicModel.h
//  DPControls
//
//  Created by developeng on 2019/9/30.
//  Copyright © 2019 developeng. All rights reserved.
//

#import "JABaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DPPublicModel : JABaseModel

@property (nonatomic, copy) NSString *titleName;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, assign) BOOL isHidden;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSInteger typeId;
@property (nonatomic, assign) NSInteger keyboardType;//0为默认，1位数字，2位小数键盘
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, assign) BOOL isTag;

@end

NS_ASSUME_NONNULL_END
