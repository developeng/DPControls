//
//  DPPublicCell.h
//  DPControls
//
//  Created by developeng on 2019/9/30.
//  Copyright © 2019 developeng. All rights reserved.
//

#import "DPBaseTableViewCell.h"
#import "DPTextView.h"
NS_ASSUME_NONNULL_BEGIN

@interface DPPublicCell : DPBaseTableViewCell<UITextViewDelegate>

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) DPTextView *conTextView;
@property (nonatomic, strong) UILabel *conLab;
@property (nonatomic, strong) UIImageView *arrawImgV;
@property (nonatomic, strong) UILabel *line;
@property (nonatomic, assign) BOOL isImgHidden;
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, copy) NSString *conText;

@property (nonatomic, weak) UITableView *expandableTableView;

@end

NS_ASSUME_NONNULL_END
