//
//  DPControlsListController.m
//  DPControls
//
//  Created by developeng on 2019/9/2.
//  Copyright © 2019 developeng. All rights reserved.
//

#import "DPControlsListController.h"
#import "JAHomeModel.h"
#import "JAHomeObject.h"
#import "DPActionSheet.h"
@interface DPControlsListController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasArr;

@end

@implementation DPControlsListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"简单控件";
    [self setupUI];
    [self requestDatas];
}

- (void)setupUI{
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.estimatedRowHeight = 120;
        tableView;
    });
    [self.view addSubview:self.tableView];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    JAHomeModel *model = self.datasArr[indexPath.row];
    cell.textLabel.text = model.title;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [JAHomeObject goToNextVC:self indexPath:indexPath];
}
#pragma make-----------接口---------------------

- (void)requestDatas{
    NSURL  *fileURL = [[NSBundle mainBundle] URLForResource:@"homedata" withExtension:@"json"];
    NSData *data = [NSData dataWithContentsOfURL:fileURL];
    NSError *error;
    if (!data) return;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    NSDictionary *dic = dict[@"data"];
    NSArray *List = dic[@"List"];
    NSArray *modelArr = [JAHomeModel modelArrayWithDictArray:List];
    [self.datasArr addObjectsFromArray:modelArr];
    [self.tableView reloadData];

}

- (NSMutableArray *)datasArr{
    if (!_datasArr) {
        _datasArr = [NSMutableArray array];
    }
    return _datasArr;
}
@end
