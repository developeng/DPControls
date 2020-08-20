//
//  DPBaseTableViewCell.h
//  DPControls
//
//  Created by developeng on 2019/9/30.
//  Copyright © 2019 developeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DPBaseTableViewCell : UITableViewCell

//加载非Xib cell
+ (instancetype)loadNormalCellWithTableView:(UITableView *)tableView;

//加载xib cell
+ (instancetype)loadNibCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
