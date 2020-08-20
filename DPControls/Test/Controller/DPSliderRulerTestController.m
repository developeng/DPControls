//
//  DPSliderRulerTestController.m
//  DPControls
//
//  Created by developeng on 2019/9/2.
//  Copyright © 2019 developeng. All rights reserved.
//

#import "DPSliderRulerTestController.h"
#import "JARulerView.h"
#import "JASliderAlertView.h"
@interface DPSliderRulerTestController ()

@property (nonatomic, strong) UIButton *buttonI;
@property (nonatomic, strong) UIButton *buttonII;
@property (nonatomic, strong) UILabel *titleLab;

@end

@implementation DPSliderRulerTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLab = ({
        UILabel *label = [UILabel new];
        label.frame = CGRectMake(0, 10, SCREEN_WIDTH, 30);
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    [self.view addSubview:self.titleLab];
    
    
    self.buttonI = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 100, SCREEN_WIDTH, 50);
        [button setTitle:@"按钮1" forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor redColor]];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 0;
        button;
    });
    [self.view addSubview:self.buttonI];
    
    self.buttonII = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 160, SCREEN_WIDTH, 50);
        [button setTitle:@"按钮2" forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor redColor]];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 1;
        button;
    });
    [self.view addSubview:self.buttonII];
}

- (void)buttonClick:(UIButton *)button{
    
    JASliderAlertView *alertView = [[JASliderAlertView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    switch (button.tag) {
        case 0:{
            alertView.unit = @"天";
            alertView.defaultValue = @"20";
            alertView.max = 75;
            alertView.min = 0;
            alertView.rowNum = 15;
            alertView.stepLength = 1;
            alertView.sliderType = DPSliderType_TYPE_II;
        }
            break;
        case 1:{
            alertView.unit = @"℃";
            alertView.defaultValue = @"40";
            alertView.max = 80;
            alertView.min = 35;
            alertView.rowNum = 15;
            alertView.stepLength = 0.1;
            alertView.isDecimal = YES;
            alertView.sliderType = DPSliderType_TYPE_I;
        }
            break;            
        default:
            break;
    }
    [alertView show];
    JAWeak(self);
    alertView.UpdateValueEvent = ^(NSString * _Nonnull value) {
        weakself.titleLab.text = value;
    };
}

@end
