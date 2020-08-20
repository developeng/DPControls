//
//  DPNetworkInfo.m
//  DPControls
//
//  Created by developeng on 2020/8/20.
//  Copyright © 2020 developeng. All rights reserved.
//

#import "DPNetworkInfo.h"
#import "AppDelegate.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "Reachability.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#include <net/if.h>

/*
*获取当前的Wifi信息需要借助系统的SystemConfiguration这个库。#import <SystemConfiguration/CaptiveNetwork.h>
 获取wifii信息（名称等）需要打开权限，Capabilities--> 添加 Access WiFi Information
 iOS13下要获取SSID和BSSID，需要添加定位权限
 <key>NSLocationWhenInUseUsageDescription</key>
 <string>获取定位权限</string>
*/

@implementation DPNetworkInfo

//刘海屏safeAreaInset的高度(所有的刘海屏都一致)
static const CGFloat liuHaiHeight = 44;

#pragma mark 获取当前网络类型
+ (NSString *)getNetworkType
{
    UIApplication *app = [UIApplication sharedApplication];
    id statusBar = nil;
//    判断是否是iOS 13
    NSString *network = @"";
    if (@available(iOS 13.0, *)) {
        UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].keyWindow.windowScene.statusBarManager;
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        if ([statusBarManager respondsToSelector:@selector(createLocalStatusBar)]) {
            UIView *localStatusBar = [statusBarManager performSelector:@selector(createLocalStatusBar)];
            if ([localStatusBar respondsToSelector:@selector(statusBar)]) {
                statusBar = [localStatusBar performSelector:@selector(statusBar)];
            }
        }
#pragma clang diagnostic pop
        
        if (statusBar) {
//            UIStatusBarDataCellularEntry
            id currentData = [[statusBar valueForKeyPath:@"_statusBar"] valueForKeyPath:@"currentData"];
            id _wifiEntry = [currentData valueForKeyPath:@"wifiEntry"];
            id _cellularEntry = [currentData valueForKeyPath:@"cellularEntry"];
            if (_wifiEntry && [[_wifiEntry valueForKeyPath:@"isEnabled"] boolValue]) {
//                If wifiEntry is enabled, is WiFi.
                network = @"WIFI";
            } else if (_cellularEntry && [[_cellularEntry valueForKeyPath:@"isEnabled"] boolValue]) {
                NSNumber *type = [_cellularEntry valueForKeyPath:@"type"];
                if (type) {
                    switch (type.integerValue) {
                        case 0:
//                            无sim卡
                            network = @"NONE";
                            break;
                        case 1:
                            network = @"1G";
                            break;
                        case 3:
                            network = @"2G";
                            break;
                        case 4:
                            network = @"3G";
                            break;
                        case 5:
                            network = @"4G";
                            break;
                        default:
//                            默认WWAN类型
                            network = @"WWAN";
                            break;
                            }
                        }
                    }
                }
    }else {
        statusBar = [app valueForKeyPath:@"statusBar"];
        
        if ([[[self alloc]init]isLiuHaiScreen]) {
//            刘海屏
                id statusBarView = [statusBar valueForKeyPath:@"statusBar"];
                UIView *foregroundView = [statusBarView valueForKeyPath:@"foregroundView"];
                NSArray *subviews = [[foregroundView subviews][2] subviews];
                
                if (subviews.count == 0) {
//                    iOS 12
                    id currentData = [statusBarView valueForKeyPath:@"currentData"];
                    id wifiEntry = [currentData valueForKey:@"wifiEntry"];
                    if ([[wifiEntry valueForKey:@"_enabled"] boolValue]) {
                        network = @"WIFI";
                    }else {
//                    卡1:
                        id cellularEntry = [currentData valueForKey:@"cellularEntry"];
//                    卡2:
                        id secondaryCellularEntry = [currentData valueForKey:@"secondaryCellularEntry"];

                        if (([[cellularEntry valueForKey:@"_enabled"] boolValue]|[[secondaryCellularEntry valueForKey:@"_enabled"] boolValue]) == NO) {
//                            无卡情况
                            network = @"NONE";
                        }else {
//                            判断卡1还是卡2
                            BOOL isCardOne = [[cellularEntry valueForKey:@"_enabled"] boolValue];
                            int networkType = isCardOne ? [[cellularEntry valueForKey:@"type"] intValue] : [[secondaryCellularEntry valueForKey:@"type"] intValue];
                            switch (networkType) {
                                    case 0://无服务
                                    network = [NSString stringWithFormat:@"%@-%@", isCardOne ? @"Card 1" : @"Card 2", @"NONE"];
                                    break;
                                    case 3:
                                    network = [NSString stringWithFormat:@"%@-%@", isCardOne ? @"Card 1" : @"Card 2", @"2G/E"];
                                    break;
                                    case 4:
                                    network = [NSString stringWithFormat:@"%@-%@", isCardOne ? @"Card 1" : @"Card 2", @"3G"];
                                    break;
                                    case 5:
                                    network = [NSString stringWithFormat:@"%@-%@", isCardOne ? @"Card 1" : @"Card 2", @"4G"];
                                    break;
                                default:
                                    break;
                            }
                            
                        }
                    }
                
                }else {
                    
                    for (id subview in subviews) {
                        if ([subview isKindOfClass:NSClassFromString(@"_UIStatusBarWifiSignalView")]) {
                            network = @"WIFI";
                        }else if ([subview isKindOfClass:NSClassFromString(@"_UIStatusBarStringView")]) {
                            network = [subview valueForKeyPath:@"originalText"];
                        }
                    }
                }
                
            }else {
//                非刘海屏
                UIView *foregroundView = [statusBar valueForKeyPath:@"foregroundView"];
                NSArray *subviews = [foregroundView subviews];
                
                for (id subview in subviews) {
                    if ([subview isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
                        int networkType = [[subview valueForKeyPath:@"dataNetworkType"] intValue];
                        switch (networkType) {
                            case 0:
                                network = @"NONE";
                                break;
                            case 1:
                                network = @"2G";
                                break;
                            case 2:
                                network = @"3G";
                                break;
                            case 3:
                                network = @"4G";
                                break;
                            case 5:
                                network = @"WIFI";
                                break;
                            default:
                                break;
                        }
                    }
                }
            }
    }

    if ([network isEqualToString:@""]) {
        network = @"NONE";
    }
    return network;
}

#pragma mark 获取当前网络类型(通过Reachability)
+ (NSString *)getNetworkTypeByReachability
{
    NSString *network = @"";
    switch ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]) {
        case NotReachable:
            network = @"NONE";
            break;
        case ReachableViaWiFi:
            network = @"WIFI";
            break;
        case ReachableViaWWAN:
            network = @"WWAN";
            break;
        default:
            break;
    }
    if ([network isEqualToString:@""]) {
        network = @"NO DISPLAY";
    }
    return network;
}

#pragma mark 获取Wifi信息
+ (id)fetchSSIDInfo
{
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        
        if (info && [info count]) {
            break;
        }
    }
    return info;
}

#pragma mark 获取WIFI名字
+ (NSString *)getWifiSSID
{
    return (NSString *)[self fetchSSIDInfo][@"SSID"];
}

#pragma mark 获取WIFI的MAC地址
+ (NSString *)getWifiBSSID
{
    return (NSString *)[self fetchSSIDInfo][@"BSSID"];
}

#pragma mark 获取信号强度等级
+ (int)getSignalStrengthBar
{
    int signalStrength = 0;
//    判断类型是否为WIFI
    if ([[self getNetworkType] isEqualToString:@"WIFI"]) {
//        判断是否为iOS 13
        if (@available(iOS 13.0, *)) {
            UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].keyWindow.windowScene.statusBarManager;
             
            id statusBar = nil;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
            if ([statusBarManager respondsToSelector:@selector(createLocalStatusBar)]) {
                UIView *localStatusBar = [statusBarManager performSelector:@selector(createLocalStatusBar)];
                if ([localStatusBar respondsToSelector:@selector(statusBar)]) {
                    statusBar = [localStatusBar performSelector:@selector(statusBar)];
                }
            }
#pragma clang diagnostic pop
            if (statusBar) {
                id currentData = [[statusBar valueForKeyPath:@"_statusBar"] valueForKeyPath:@"currentData"];
                id wifiEntry = [currentData valueForKeyPath:@"wifiEntry"];
                if ([wifiEntry isKindOfClass:NSClassFromString(@"_UIStatusBarDataIntegerEntry")]) {
//                    层级：_UIStatusBarDataNetworkEntry、_UIStatusBarDataIntegerEntry、_UIStatusBarDataEntry
                    signalStrength = [[wifiEntry valueForKey:@"displayValue"] intValue];
                }
            }
        }else {
            UIApplication *app = [UIApplication sharedApplication];
            id statusBar = [app valueForKey:@"statusBar"];
            if ([[[self alloc]init] isLiuHaiScreen]) {
//                刘海屏
                id statusBarView = [statusBar valueForKeyPath:@"statusBar"];
                UIView *foregroundView = [statusBarView valueForKeyPath:@"foregroundView"];
                NSArray *subviews = [[foregroundView subviews][2] subviews];
                       
                if (subviews.count == 0) {
//                    iOS 12
                    id currentData = [statusBarView valueForKeyPath:@"currentData"];
                    id wifiEntry = [currentData valueForKey:@"wifiEntry"];
                    signalStrength = [[wifiEntry valueForKey:@"displayValue"] intValue];
//                    dBm
//                    int rawValue = [[wifiEntry valueForKey:@"rawValue"] intValue];
                }else {
                    for (id subview in subviews) {
                        if ([subview isKindOfClass:NSClassFromString(@"_UIStatusBarWifiSignalView")]) {
                            signalStrength = [[subview valueForKey:@"_numberOfActiveBars"] intValue];
                        }
                    }
                }
            }else {
//                非刘海屏
                UIView *foregroundView = [statusBar valueForKey:@"foregroundView"];
                     
                NSArray *subviews = [foregroundView subviews];
                NSString *dataNetworkItemView = nil;
                       
                for (id subview in subviews) {
                    if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
                        dataNetworkItemView = subview;
                        break;
                    }
                }
                signalStrength = [[dataNetworkItemView valueForKey:@"_wifiStrengthBars"] intValue];
                return signalStrength;
            }
        }
    } else {
        //        判断是否为iOS 13
                if (@available(iOS 13.0, *)) {
                    UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].keyWindow.windowScene.statusBarManager;
                     
                    id statusBar = nil;
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wundeclared-selector"
                    if ([statusBarManager respondsToSelector:@selector(createLocalStatusBar)]) {
                        UIView *localStatusBar = [statusBarManager performSelector:@selector(createLocalStatusBar)];
                        if ([localStatusBar respondsToSelector:@selector(statusBar)]) {
                            statusBar = [localStatusBar performSelector:@selector(statusBar)];
                        }
                    }
        #pragma clang diagnostic pop
                    if (statusBar) {
                        id currentData = [[statusBar valueForKeyPath:@"_statusBar"] valueForKeyPath:@"currentData"];
                        id cellularEntry = [currentData valueForKeyPath:@"cellularEntry"];
                        if ([cellularEntry isKindOfClass:NSClassFromString(@"_UIStatusBarDataIntegerEntry")]) {
        //                    层级：_UIStatusBarDataNetworkEntry、_UIStatusBarDataIntegerEntry、_UIStatusBarDataEntry
                            
                            signalStrength = [[cellularEntry valueForKey:@"displayValue"] intValue];
                        }
                    }
                }else {
                    UIApplication *app = [UIApplication sharedApplication];
                    id statusBar = [app valueForKey:@"statusBar"];
                    if ([[[self alloc]init] isLiuHaiScreen]) {
        //                刘海屏
                        id statusBarView = [statusBar valueForKeyPath:@"statusBar"];
                        UIView *foregroundView = [statusBarView valueForKeyPath:@"foregroundView"];
                        NSArray *subviews = [[foregroundView subviews][2] subviews];
                               
                        if (subviews.count == 0) {
        //                    iOS 12
                            id currentData = [statusBarView valueForKeyPath:@"currentData"];
                            id wifiEntry = [currentData valueForKey:@"cellularEntry"];
                            signalStrength = [[wifiEntry valueForKey:@"displayValue"] intValue];
        //                    dBm
        //                    int rawValue = [[wifiEntry valueForKey:@"rawValue"] intValue];
                        }else {
                            for (id subview in subviews) {
                                if ([subview isKindOfClass:NSClassFromString(@"_UIStatusBarWifiSignalView")]) {
                                    signalStrength = [[subview valueForKey:@"_numberOfActiveBars"] intValue];
                                }
                            }
                        }
                    }else {
        //                非刘海屏
                        UIView *foregroundView = [statusBar valueForKey:@"foregroundView"];
                        NSArray *subviews = [foregroundView subviews];
                        NSString *dataNetworkItemView = nil;
                               
                        for (id subview in subviews) {
                            if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarSignalStrengthItemView") class]]) {
                                dataNetworkItemView = subview;
                                break;
                            }
                        }
                        signalStrength = [[dataNetworkItemView valueForKey:@"_signalStrengthBars"] intValue];
                        return signalStrength;
                    }
                }
    }
    return signalStrength;
}

//获取网络信号强度（dBm）
+ (NSString * )getSignalStrength{
       NSString *signalStrength = @"";
    //    判断类型是否为WIFI
        if ([[self getNetworkType] isEqualToString:@"WIFI"]) {
    //        判断是否为iOS 13
            if (@available(iOS 13.0, *)) {
                UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].keyWindow.windowScene.statusBarManager;
                 
                id statusBar = nil;
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wundeclared-selector"
                if ([statusBarManager respondsToSelector:@selector(createLocalStatusBar)]) {
                    UIView *localStatusBar = [statusBarManager performSelector:@selector(createLocalStatusBar)];
                    if ([localStatusBar respondsToSelector:@selector(statusBar)]) {
                        statusBar = [localStatusBar performSelector:@selector(statusBar)];
                    }
                }
    #pragma clang diagnostic pop
                if (statusBar) {
                    id currentData = [[statusBar valueForKeyPath:@"_statusBar"] valueForKeyPath:@"currentData"];
                    id wifiEntry = [currentData valueForKeyPath:@"wifiEntry"];
                    if ([wifiEntry isKindOfClass:NSClassFromString(@"_UIStatusBarDataIntegerEntry")]) {
    //                    层级：_UIStatusBarDataNetworkEntry、_UIStatusBarDataIntegerEntry、_UIStatusBarDataEntry
                        signalStrength = [NSString stringWithFormat:@"%@dBm",[wifiEntry valueForKey:@"rawValue"]];
                        
                    
                    }
                }
            }else {
                UIApplication *app = [UIApplication sharedApplication];
                id statusBar = [app valueForKey:@"statusBar"];
                if ([[[self alloc]init] isLiuHaiScreen]) {
    //                刘海屏
                    id statusBarView = [statusBar valueForKeyPath:@"statusBar"];
                    UIView *foregroundView = [statusBarView valueForKeyPath:@"foregroundView"];
                    NSArray *subviews = [[foregroundView subviews][2] subviews];
                           
                    if (subviews.count == 0) {
    //                    iOS 12
                        id currentData = [statusBarView valueForKeyPath:@"currentData"];
                        id wifiEntry = [currentData valueForKey:@"wifiEntry"];
                        //dBm
                        signalStrength = [NSString stringWithFormat:@"%@dBm",[wifiEntry valueForKey:@"rawValue"]];
                       
                    }else {
                        for (id subview in subviews) {
                            if ([subview isKindOfClass:NSClassFromString(@"_UIStatusBarWifiSignalView")]) {
                                signalStrength = [NSString stringWithFormat:@"%@dBm",[subview valueForKey:@"_numberOfActiveBars"]];
                                
                            }
                        }
                    }
                }else {
    //                非刘海屏
                    UIView *foregroundView = [statusBar valueForKey:@"foregroundView"];
                         
                    NSArray *subviews = [foregroundView subviews];
                    NSString *dataNetworkItemView = nil;
                           
                    for (id subview in subviews) {
                        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
                            dataNetworkItemView = subview;
                            break;
                        }
                    }
                    signalStrength = [NSString stringWithFormat:@"%@dBm",[dataNetworkItemView valueForKey:@"_wifiStrengthRaw"]];
                   
                    return signalStrength;
                }
            }
        } else {
            //        判断是否为iOS 13
                    if (@available(iOS 13.0, *)) {
                        UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].keyWindow.windowScene.statusBarManager;
                         
                        id statusBar = nil;
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wundeclared-selector"
                        if ([statusBarManager respondsToSelector:@selector(createLocalStatusBar)]) {
                            UIView *localStatusBar = [statusBarManager performSelector:@selector(createLocalStatusBar)];
                            if ([localStatusBar respondsToSelector:@selector(statusBar)]) {
                                statusBar = [localStatusBar performSelector:@selector(statusBar)];
                            }
                        }
            #pragma clang diagnostic pop
                        if (statusBar) {
                            id currentData = [[statusBar valueForKeyPath:@"_statusBar"] valueForKeyPath:@"currentData"];
                            id cellularEntry = [currentData valueForKeyPath:@"cellularEntry"];
                            if ([cellularEntry isKindOfClass:NSClassFromString(@"_UIStatusBarDataIntegerEntry")]) {
            //                    层级：_UIStatusBarDataNetworkEntry、_UIStatusBarDataIntegerEntry、_UIStatusBarDataEntry
                                signalStrength = [NSString stringWithFormat:@"%@dBm",[cellularEntry valueForKey:@"rawValue"]];
                               
                            }
                        }
                    }else {
                        UIApplication *app = [UIApplication sharedApplication];
                        id statusBar = [app valueForKey:@"statusBar"];
                        if ([[[self alloc]init] isLiuHaiScreen]) {
            //                刘海屏
                            id statusBarView = [statusBar valueForKeyPath:@"statusBar"];
                            UIView *foregroundView = [statusBarView valueForKeyPath:@"foregroundView"];
                            NSArray *subviews = [[foregroundView subviews][2] subviews];
                                   
                            if (subviews.count == 0) {
            //                    iOS 12
                                id currentData = [statusBarView valueForKeyPath:@"currentData"];
                                id wifiEntry = [currentData valueForKey:@"cellularEntry"];
                                signalStrength = [NSString stringWithFormat:@"%@dBm",[wifiEntry valueForKey:@"rawValue"]];
                                
                            }else {
                                for (id subview in subviews) {
                                    if ([subview isKindOfClass:NSClassFromString(@"_UIStatusBarWifiSignalView")]) {
                                        signalStrength = [NSString stringWithFormat:@"%@dBm",[subview valueForKey:@"_numberOfActiveBars"]];
                                    }
                                }
                            }
                        }else {
            //                非刘海屏
                            UIView *foregroundView = [statusBar valueForKey:@"foregroundView"];
                            NSArray *subviews = [foregroundView subviews];
                            NSString *dataNetworkItemView = nil;
                                   
                            for (id subview in subviews) {
                                if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarSignalStrengthItemView") class]]) {
                                    dataNetworkItemView = subview;
                                    break;
                                }
                            }
                            signalStrength = [NSString stringWithFormat:@"%@dBm",[dataNetworkItemView valueForKey:@"_signalStrengthRaw"]];
                            return signalStrength;
                        }
                    }
        }
        return signalStrength;
}


#pragma mark 获取设备IP地址
+ (NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // 检索当前接口,在成功时,返回0
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // 循环链表的接口
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
//                开热点时本机的IP地址
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"bridge100"]
                    ) {
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
                // 检查接口是否en0 wifi连接在iPhone上
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // 得到NSString从C字符串
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // 释放内存
    freeifaddrs(interfaces);
    return address;
}

//统计的是上次开机至今的流量信息
+ (NSString *)getInternetface {
    long long bytes = [self getInterfaceBytes];
    NSString *allBytes;
    if(bytes < 1024)        // B
    {
        allBytes = [NSString stringWithFormat:@"%lldB", bytes];
    }
    else if(bytes >= 1024 && bytes < 1024 * 1024)    // KB
    {
        allBytes = [NSString stringWithFormat:@"%.1fKB", (double)bytes / 1024];
    }
    else if(bytes >= 1024 * 1024 && bytes < 1024 * 1024 * 1024)    // MB
    {
        allBytes = [NSString stringWithFormat:@"%.2fMB", (double)bytes / (1024 * 1024)];
    }
    else    // GB
    {
        allBytes = [NSString stringWithFormat:@"%.3fGB", (double)bytes / (1024 * 1024 * 1024)];
    }
    return allBytes;
}

/*获取网络流量信息*/
+ (long long) getInterfaceBytes{
    struct ifaddrs *ifa_list = 0, *ifa;
    if (getifaddrs(&ifa_list) == -1)
    {
        return 0;
    }
    uint32_t iBytes = 0;
    uint32_t oBytes = 0;
    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next)
    {
        if (AF_LINK != ifa->ifa_addr->sa_family)
           continue;
        if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING))
            continue;
        if (ifa->ifa_data == 0)
            continue;
  /* Not a loopback device. */
       if (strncmp(ifa->ifa_name, "lo", 2))
        {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            iBytes += if_data->ifi_ibytes;
            oBytes += if_data->ifi_obytes;
        }
    }
    freeifaddrs(ifa_list);
//    NSLog(@"\n[getInterfaceBytes-Total]%d,%d",iBytes,oBytes);
    return iBytes + oBytes;
}

//获取3G或者GPRS的流量
+ (NSString *)getGprs3GFlowIOBytes
{
    struct ifaddrs *ifa_list = 0, *ifa;
    if (getifaddrs(&ifa_list) == -1)
    {
        return 0;
    }
    
    uint32_t iBytes = 0;
    uint32_t oBytes = 0;
    
    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next)
    {
        if (AF_LINK != ifa->ifa_addr->sa_family)
            continue;
        
        if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING))
            continue;
        
        if (ifa->ifa_data == 0)
            continue;
        
        //3G或者GPRS
        if (!strcmp(ifa->ifa_name, "pdp_ip0"))
        {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            
            iBytes += if_data->ifi_ibytes;
            oBytes += if_data->ifi_obytes;
//            NSLog(@"%s :iBytes is %d, oBytes is %d",
//                  ifa->ifa_name, iBytes, oBytes);
        }
    }
    freeifaddrs(ifa_list);
    uint32_t bytes = 0;
    bytes = iBytes + oBytes;
    //将bytes单位转换
    if(bytes < 1024)        // B
    {
        return [NSString stringWithFormat:@"%dB", bytes];
    }
    else if(bytes >= 1024 && bytes < 1024 * 1024)    // KB
    {
        return [NSString stringWithFormat:@"%.1fKB", (double)bytes / 1024];
    }
    else if(bytes >= 1024 * 1024 && bytes < 1024 * 1024 * 1024)    // MB
    {
        return [NSString stringWithFormat:@"%.2fMB", (double)bytes / (1024 * 1024)];
    }
    else    // GB
    {
        return [NSString stringWithFormat:@"%.3fGB", (double)bytes / (1024 * 1024 * 1024)];
    }
}
 
//获取Wifi流量
+ (NSString *)getGprsWifiFlowIOBytes
{
    struct ifaddrs *ifa_list = 0, *ifa;
    if (getifaddrs(&ifa_list) == -1) {
        return 0;
    }
    uint32_t iBytes = 0;
    uint32_t oBytes = 0;
    for (ifa = ifa_list; ifa; ifa = ifa->ifa_next) {
        if (AF_LINK != ifa->ifa_addr->sa_family)
            continue;
        if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING))
            continue;
        if (ifa->ifa_data == 0)
            continue;
        
        //Wifi
        if (strncmp(ifa->ifa_name, "lo", 2)) {
            struct if_data *if_data = (struct if_data *)ifa->ifa_data;
            iBytes += if_data->ifi_ibytes;
            oBytes += if_data->ifi_obytes;
//            NSLog(@"%s :iBytes is %d, oBytes is %d", ifa->ifa_name, iBytes, oBytes);
        }
    }
    
    freeifaddrs(ifa_list);
    
    uint32_t bytes = 0;
    
    bytes = iBytes+oBytes;
    
//    NSLog(@"%d",bytes);
    
    //将bytes单位转换
    if(bytes < 1024)        // B
    {
        return [NSString stringWithFormat:@"%dB", bytes];
    }
    else if(bytes >= 1024 && bytes < 1024 * 1024)    // KB
    {
        return [NSString stringWithFormat:@"%.1fKB", (double)bytes / 1024];
    }
    else if(bytes >= 1024 * 1024 && bytes < 1024 * 1024 * 1024)    // MB
    {
        return [NSString stringWithFormat:@"%.2fMB", (double)bytes / (1024 * 1024)];
    }
    else    // GB
    {
        return [NSString stringWithFormat:@"%.3fGB", (double)bytes / (1024 * 1024 * 1024)];
    }
}

//检查当前是否连网
+ (BOOL)whetherConnectedNetwork{
    //创建零地址，0.0.0.0的地址表示查询本机的网络连接状态
    struct sockaddr_storage zeroAddress;//IP地址
    bzero(&zeroAddress, sizeof(zeroAddress));//将地址转换为0.0.0.0
    zeroAddress.ss_len = sizeof(zeroAddress);//地址长度
    zeroAddress.ss_family = AF_INET;//地址类型为UDP, TCP, etc.
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    //获得连接的标志
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    //如果不能获取连接标志，则不能连接网络，直接返回
    if (!didRetrieveFlags)
    {
    return NO;
    }
    //根据获得的连接标志进行判断
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable&&!needsConnection) ? YES : NO;
}








#pragma mark 判断是否是刘海屏
- (BOOL)isLiuHaiScreen
{
    if (@available(iOS 11.0, *)) {
    
        UIEdgeInsets safeAreaInsets = [UIApplication sharedApplication].windows[0].safeAreaInsets;
        
        return safeAreaInsets.top == liuHaiHeight || safeAreaInsets.bottom == liuHaiHeight || safeAreaInsets.left == liuHaiHeight || safeAreaInsets.right == liuHaiHeight;
    }else {
        return NO;
    }
}
@end
