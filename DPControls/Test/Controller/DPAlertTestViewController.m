//
//  DPAlertTestViewController.m
//  DPControls
//
//  Created by developeng on 2019/9/3.
//  Copyright © 2019 developeng. All rights reserved.
//

#import "DPAlertTestViewController.h"
#import "DPActionSheet.h"
@interface DPAlertTestViewController ()<DPActionSheetDelegate>

@property (nonatomic, strong) UIButton *buttonI;
@property (nonatomic, strong) UIButton *buttonII;
@property (nonatomic, strong) UIButton *buttonIII;
@property (nonatomic, strong) UILabel *titleLab;

@end

@implementation DPAlertTestViewController

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
        [button setTitle:@"仿系统ActionSheet" forState:UIControlStateNormal];
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
        [button setTitle:@"仿系统ActionSheet2" forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor redColor]];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 1;
        button;
    });
    [self.view addSubview:self.buttonII];
    
    self.buttonIII = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 220, SCREEN_WIDTH, 50);
        [button setTitle:@"系统ActionSheet" forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor redColor]];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 2;
        button;
    });
    [self.view addSubview:self.buttonIII];
}

- (void)buttonClick:(UIButton *)button{
    NSArray *arr = @[@"红酒",@"白酒",@"葡萄酒",@"马奶就",@"🍺"];
    switch (button.tag) {
        case 0:{
            DPActionSheet *sheet = [[DPActionSheet alloc] initWithTitle:@"选择酒" delegate:self type:DPActionSheetType_System cancelButtonTitle:@"取消" otherButtonArr:arr];
            [sheet show];
        }
            break;
        case 1:{
            DPActionSheet *sheet = [[DPActionSheet alloc] initWithTitle:@"选择酒" delegate:self type:DPActionSheetType_Custom cancelButtonTitle:@"取消" otherButtonArr:arr];
            [sheet show];
           
        }
            break;
        case 2:{
            UIAlertController *shipAlertController = [UIAlertController alertControllerWithTitle:@"选择酒" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *str = obj;
                UIAlertAction *alertAction = [UIAlertAction actionWithTitle:str style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alertAction setValue:[UIColor colorWithHexString:@"#333333"] forKey:@"_titleTextColor"];
                [shipAlertController addAction:alertAction];
            }];
            [shipAlertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            
            [self presentViewController:shipAlertController animated:YES completion:nil];
            
        }
            break;
        default:
            break;
    }
}

- (void)actionSheet:(DPActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex{
    
}

@end
