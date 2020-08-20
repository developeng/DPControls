//
//  DPNetConnectivityVCViewController.m
//  DPControls
//
//  Created by developeng on 2020/8/14.
//  Copyright © 2020 developeng. All rights reserved.
//

#import "DPNetConnectivityVCViewController.h"
#import "DPNetworkInfo.h"
#import <CoreLocation/CoreLocation.h>

@interface DPNetConnectivityVCViewController ()
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation DPNetConnectivityVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"获取网络状态和信号强度";
    
        if (@available(iOS 13.0, *)) {
    //        如果是iOS13 未开启地理位置权限 需要提示一下
               if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
                   self.locationManager = [[CLLocationManager alloc] init];
                   [self.locationManager requestWhenInUseAuthorization];
               }
           }

    NSMutableArray *arr = [NSMutableArray array];
    [arr addObject:[NSString stringWithFormat:@"获取当前网络类型:%@",[DPNetworkInfo getNetworkType]]];
    [arr addObject:[NSString stringWithFormat:@"获取当前网络类型:%@",[DPNetworkInfo getNetworkTypeByReachability]]];
    [arr addObject:[NSString stringWithFormat:@"获取Wifi信息:%@",[DPNetworkInfo fetchSSIDInfo]]];
    [arr addObject:[NSString stringWithFormat:@"获取WIFI名字:%@",[DPNetworkInfo getWifiSSID]]];
    [arr addObject:[NSString stringWithFormat:@"获取WIFi的MAC地址:%@",[DPNetworkInfo getWifiBSSID]]];
    [arr addObject:[NSString stringWithFormat:@"获取信号强度等级:%d",[DPNetworkInfo getSignalStrengthBar]]];
    [arr addObject:[NSString stringWithFormat:@"获取网络信号强度:%@",[DPNetworkInfo getSignalStrength]]];
    [arr addObject:[NSString stringWithFormat:@"获取设备IP地址:%@",[DPNetworkInfo getIPAddress]]];
    [arr addObject:[NSString stringWithFormat:@"统计的是上次开机至今的流量信息:%@",[DPNetworkInfo getInternetface]]];
    [arr addObject:[NSString stringWithFormat:@"获取3G或者GPRS的流量:%@",[DPNetworkInfo getGprs3GFlowIOBytes]]];
    [arr addObject:[NSString stringWithFormat:@"获取Wifi流量:%@",[DPNetworkInfo getGprsWifiFlowIOBytes]]];
    [arr addObject:[NSString stringWithFormat:@"检查当前是否连网:%d",[DPNetworkInfo whetherConnectedNetwork]]];
    
    CGRect lastRect = CGRectMake(0, 0, 320, 0);
    for (int i = 0; i < arr.count; i++) {
        UILabel *label = [UILabel new];
        label.text = [arr objectAtIndex:i];
        label.textColor = [UIColor redColor];
        if (i == 2) {
            label.numberOfLines = 0;
             label.frame = CGRectMake(0, lastRect.origin.y+lastRect.size.height, 320, 100);
        } else {
            label.numberOfLines = 1;
            label.frame = CGRectMake(0, lastRect.origin.y+lastRect.size.height, 320, 30);
        }
        label.font = [UIFont systemFontOfSize:16];
        [self.view addSubview:label];
        lastRect = label.frame;
    }

}
@end
