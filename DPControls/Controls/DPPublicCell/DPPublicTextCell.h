//
//  DPPublicTextCell.h
//  DPControls
//
//  Created by developeng on 2019/9/30.
//  Copyright © 2019 developeng. All rights reserved.
//

#import "DPBaseTableViewCell.h"
#import "DPTextView.h"
NS_ASSUME_NONNULL_BEGIN

@interface DPPublicTextCell : DPBaseTableViewCell<UITextViewDelegate>

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) DPTextView *conTextView;
@property (nonatomic, strong) UILabel *conLab;
@property (nonatomic, copy) NSString *conText;

@property (nonatomic, weak) UITableView *expandableTableView;

@end

NS_ASSUME_NONNULL_END
