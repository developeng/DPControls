//
//  DPDarkModeTestController.m
//  DPControls
//
//  Created by developeng on 2020/3/19.
//  Copyright © 2020 developeng. All rights reserved.
//

#import "DPDarkModeTestController.h"

@interface DPDarkModeTestController ()

@end

@implementation DPDarkModeTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithLightColorStr:@"#ffffff" DarkColor:@"#333333"];
    
    UILabel *label = [UILabel new];
    label.text = @"暗黑模式测试Label";
    label.frame = CGRectMake(0, 100, SCREEN_WIDTH, 40);
    label.font = [UIFont systemFontOfSize:20];
    label.textColor = [UIColor colorWithLightColorStr:@"#333333" DarkColor:@"#ffffff"];
    label.backgroundColor = [UIColor colorWithLightColorStr:@"#ffffff" DarkColor:@"#333333"];
    [self.view addSubview:label];
    
}




@end
