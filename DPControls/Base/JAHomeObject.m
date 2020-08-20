//
//  JAHomeObject.m
//  JAXuMu
//
//  Created by developeng on 2019/7/16.
//  Copyright © 2019 developeng. All rights reserved.
//

#import "JAHomeObject.h"
#import "DPSliderRulerTestController.h"
#import "DPAlertTestViewController.h"
#import "DPPublicCellTextController.h"
#import "DPDarkModeTestController.h"
#import "DPNetConnectivityVCViewController.h"
@implementation JAHomeObject

+ (void)goToNextVC:(UIViewController *)selfVC indexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            DPSliderRulerTestController *VC = [DPSliderRulerTestController new];
            [selfVC.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 1:{
            DPAlertTestViewController *VC = [DPAlertTestViewController new];
            [selfVC.navigationController pushViewController:VC animated:YES];
            
        }
            break;
        case 2:{
            DPPublicCellTextController *VC = [DPPublicCellTextController new];
            [selfVC.navigationController pushViewController:VC animated:YES];
            
            
        }
            break;
        case 3:{
            DPDarkModeTestController *VC = [DPDarkModeTestController new];
            [selfVC.navigationController pushViewController:VC animated:YES];
            
            
        }
            break;
            case 4:{
                DPNetConnectivityVCViewController *VC = [DPNetConnectivityVCViewController new];
                [selfVC.navigationController pushViewController:VC animated:YES];
                
                
            }
                break;
        default:
            break;
    }
}

@end
