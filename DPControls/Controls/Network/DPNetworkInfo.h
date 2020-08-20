//
//  DPNetworkInfo.h
//  DPControls
//
//  Created by developeng on 2020/8/20.
//  Copyright © 2020 developeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DPNetworkInfo : NSObject

//获取当前网络类型
+ (NSString *)getNetworkType;
//获取当前网络类型
+ (NSString *)getNetworkTypeByReachability;
//获取Wifi信息
+ (id)fetchSSIDInfo;
//获取WIFI名字
+ (NSString *)getWifiSSID;
//获取WIFi的MAC地址
+ (NSString *)getWifiBSSID;
//获取信号强度等级（蜂窝数据+wifi）
+ (int)getSignalStrengthBar;
//获取网络信号强度（dBm）
+ (NSString * )getSignalStrength;
//获取设备IP地址
+ (NSString *)getIPAddress;


//统计的是上次开机至今的流量信息
+ (NSString *)getInternetface;
//获取3G或者GPRS的流量
+ (NSString *)getGprs3GFlowIOBytes;
//获取Wifi流量
+ (NSString *)getGprsWifiFlowIOBytes;
//检查当前是否连网
+ (BOOL)whetherConnectedNetwork;

@end

NS_ASSUME_NONNULL_END
