//
//  AppMacro.h
//  JAFarmers
//
//  Created by developeng on 2019/3/17.
//  Copyright © 2019 developeng. All rights reserved.
//

#ifndef AppMacro_h
#define AppMacro_h

//弱引用
#define JAWeak(type)  __weak typeof(type) weak##type = type

//是否是空对象
#define JAIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))

//转为@”“
#define objAssert(obj)  if ([obj isKindOfClass:[NSNull class]] || !obj)\
obj = @"";

//NSUserDefault缓存
#define DEFAULTSSAVE(value,key) [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];\
[[NSUserDefaults standardUserDefaults] synchronize];
#define DEFAULTSGET(key) [[NSUserDefaults standardUserDefaults] objectForKey:key];

//获取数据
#define GET_CUSTOMER_ID [JAUser shareUserManager].userModel.details.customerId
//拼接字符串
#define NSStringFormat(format,...)[NSString stringWithFormat:format,##__VA_ARGS__]





//客服电话
#define keFuPhone  @"4000707976"
//审核登录账号
#define testPhone @"15000000000"

#define COLOR(hexString) [UIColor colorWithHexString:hexString];

//三方业务注册key值
//科大讯飞
#define APPID_IFLY          @"5cdba4dc"
//极光推送
#define APPKey_JG           @"42d21a6039def8b08d352626"
//高德
#define APPKey_GD           @"5eb336d71dfc581fa5a8b927341a32fe"
//荧石
#define APPKey_EZ          @"104f94dba6084c19a9ffa169443f798d"
//bugly
#define APPID_Bugly         @"9918673ffd"


#endif /* AppMacro_h */
