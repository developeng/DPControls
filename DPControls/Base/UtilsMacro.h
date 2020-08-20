//
//  UtilsMacro.h
//  DPNoteBook
//
//  Created by developeng on 2019/1/10.
//  Copyright © 2019 developeng. All rights reserved.
//

#ifndef UtilsMacro_h
#define UtilsMacro_h

// 获取APP版本
#define APP_SHORTVERSION [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
#define APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

//屏幕宽、高、尺寸
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
//适配宽高使用
#define FIT_SCALE(s) ((s) / 375.0 * SCREEN_WIDTH)


#define IPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

#define Height_NavBar (IPHONE_X ? 88 : 64)

#define Height_state (IPHONE_X ? 44 : 20)

#define Height_TabBar (IPHONE_X ? (49 + 34) : 49)

#define Height_SEC (IPHONE_X ? 34 : 0)

#endif /* UtilsMacro_h */
