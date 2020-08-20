//
//  DPPublicTextCell.m
//  DPControls
//
//  Created by developeng on 2019/9/30.
//  Copyright © 2019 developeng. All rights reserved.
//

#import "DPPublicTextCell.h"

@implementation DPPublicTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.titleLab = ({
        UILabel *label = [UILabel new];
        label.textColor = [UIColor colorWithHexString:@"#333333"];
        label.font = [UIFont systemFontOfSize:15];
        label;
    });
    [self.contentView addSubview:self.titleLab];
    
    self.conLab = ({
        UILabel *label = [UILabel new];
        label.textColor = [UIColor colorWithHexString:@"#333333"];
        label.font = [UIFont systemFontOfSize:15];
        label.numberOfLines = 0;
        label.backgroundColor = [UIColor redColor];
        label;
    });
    [self.contentView addSubview:self.conLab];
    
    self.conTextView = ({
        DPTextView *textView = [DPTextView new];
        textView.font = [UIFont systemFontOfSize:15];
        textView.textColor = [UIColor colorWithHexString:@"#333333"];
        textView.keyboardType = UIKeyboardTypeDefault;
        textView.delegate = self;
        textView.scrollEnabled = NO;
        textView;
    });
    [self.contentView addSubview:self.conTextView];
    
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(FIT_SCALE(15));
        make.top.mas_equalTo(FIT_SCALE(15));
    }];
    
    [self.conTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_greaterThanOrEqualTo(FIT_SCALE(70));
        make.width.mas_equalTo(SCREEN_WIDTH-FIT_SCALE(30));
        make.left.mas_equalTo(FIT_SCALE(15));
        make.centerY.mas_equalTo(self.conLab.mas_centerY);
    }];
    
    [self.conLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(FIT_SCALE(15));
        make.bottom.mas_equalTo(-FIT_SCALE(15));
        make.height.mas_greaterThanOrEqualTo(FIT_SCALE(60));
        make.width.mas_equalTo(SCREEN_WIDTH-FIT_SCALE(40));
        make.left.mas_equalTo(FIT_SCALE(20));
    }];
    
    
    [self.titleLab setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.titleLab setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.conLab setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.conLab setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.conLab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.conLab sizeToFit];
}

- (void)textViewDidChange:(UITextView *)textView{
    self.conLab.text = textView.text;
    [self.expandableTableView beginUpdates];
    [self.expandableTableView endUpdates];
}

- (void)setConText:(NSString *)conText{
    _conText = conText;
    self.conTextView.text = conText;
    self.conLab.text = conText;
}

@end
