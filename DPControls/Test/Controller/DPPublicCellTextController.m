//
//  DPPublicCellTextController.m
//  DPControls
//
//  Created by developeng on 2019/9/30.
//  Copyright © 2019 developeng. All rights reserved.
//

#import "DPPublicCellTextController.h"
#import "DPPublicCell.h"
#import "DPPublicModel.h"
#import "DPPublicTextCell.h"

@interface DPPublicCellTextController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasArr;

@end

@implementation DPPublicCellTextController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"高度可变cell";
    [self setupUI];
}

- (void)setupUI{
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.estimatedRowHeight = FIT_SCALE(135);
        tableView.estimatedSectionFooterHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView;
    });
    [self.view addSubview:self.tableView];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) return 1;
    return self.datasArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        DPPublicTextCell *cell = [DPPublicTextCell loadNormalCellWithTableView:tableView];
        cell.expandableTableView = tableView;
        cell.titleLab.text = @"备注";
        cell.conTextView.placeholder = @"请输入备注";
        return cell;
    }
    DPPublicCell *cell = [DPPublicCell loadNormalCellWithTableView:tableView];
    DPPublicModel *model = self.datasArr[indexPath.row];
    cell.titleLab.text = model.titleName;
    cell.conText = model.content;
    cell.conTextView.placeholder = model.placeholder;
    cell.conTextView.tag = indexPath.row;
    cell.isImgHidden = model.isHidden;
    cell.isEdit = model.isEdit;
    if (model.keyboardType == 0) {
        cell.conTextView.keyboardType = UIKeyboardTypeDefault;
    } else if (model.keyboardType == 1){
        cell.conTextView.keyboardType = UIKeyboardTypeNumberPad;
    } else {
        cell.conTextView.keyboardType = UIKeyboardTypeDecimalPad;
    }
    cell.expandableTableView = tableView;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
 
}
#pragma make-----------接口---------------------
- (NSMutableArray *)datasArr{
    if (!_datasArr) {
        _datasArr = [NSMutableArray array];
        NSArray *dicArr = @[
                            @{@"titleName":@"我的账户",@"placeholder":@"",@"isHidden":@"1",@"isEdit":@"1",@"content":@"驱蚊器翁群翁群翁群翁群翁群翁群翁群翁群翁群无围棋翁群翁群翁群翁群翁群翁群翁群翁群翁群翁群翁群无实打实大大所驱蚊器翁群翁群翁群翁群翁群翁群翁群翁群翁群无围棋翁群翁群翁群翁群翁群翁群翁群翁群翁群翁群翁群无实打实大大所",@"keyboardType":@"0"},
                            @{@"titleName":@"我的驾照",@"placeholder":@"",@"isHidden":@"0",@"isEdit":@"1",@"content":@"",@"keyboardType":@"0"},
                            @{@"titleName":@"我的车辆",@"placeholder":@"",@"isHidden":@"0",@"isEdit":@"1",@"content":@"456",@"keyboardType":@"1"},
                            @{@"titleName":@"我的运单",@"placeholder":@"请输入",@"isHidden":@"0",@"isEdit":@"1",@"content":@"",@"keyboardType":@"1"},
                            @{@"titleName":@"智库",@"placeholder":@"",@"isHidden":@"0",@"isEdit":@"1",@"content":@"",@"keyboardType":@"0"},
                            @{@"titleName":@"直通车",@"placeholder":@"",@"isHidden":@"0",@"isEdit":@"1",@"content":@"",@"keyboardType":@"0"},
                            @{@"titleName":@"客服电话",@"placeholder":@"",@"isHidden":@"0",@"isEdit":@"1",@"content":@"",@"keyboardType":@"0"}];
        
        NSArray *arr = [DPPublicModel modelArrayWithDictArray:dicArr];
        [_datasArr addObjectsFromArray:arr];
    }
    return _datasArr;
}
@end
