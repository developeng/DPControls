//
//  DPPublicCell.m
//  DPControls
//
//  Created by developeng on 2019/9/30.
//  Copyright © 2019 developeng. All rights reserved.
//

#import "DPPublicCell.h"

@implementation DPPublicCell

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
        label.textAlignment = NSTextAlignmentRight;
        label.numberOfLines = 0;
        label.backgroundColor = [UIColor redColor];
        label;
    });
    [self.contentView addSubview:self.conLab];
    
    self.conTextView = ({
        DPTextView *textView = [DPTextView new];
        textView.font = [UIFont systemFontOfSize:15];
        textView.textColor = [UIColor colorWithHexString:@"#333333"];
        textView.textAlignment = NSTextAlignmentRight;
        textView.keyboardType = UIKeyboardTypeNumberPad;
        textView.delegate = self;
        textView.scrollEnabled = NO;
        textView;
    });
    [self.contentView addSubview:self.conTextView];
    
    self.arrawImgV = ({
        UIImageView *imageView = [UIImageView new];
        imageView.image = [UIImage imageNamed:@"right_arrow"];
        imageView;
    });
    [self.contentView addSubview:self.arrawImgV];
    
    self.line = ({
        UILabel *label = [UILabel new];
        label.backgroundColor = [UIColor lightGrayColor];
        label;
    });
    [self.contentView addSubview:self.line];
    
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(FIT_SCALE(15));
        make.top.mas_equalTo(FIT_SCALE(15));
    }];
    
    [self.conTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.arrawImgV.mas_left).offset(-FIT_SCALE(5));
        make.centerY.mas_equalTo(self.conLab.mas_centerY);
        make.height.mas_greaterThanOrEqualTo(FIT_SCALE(20));
        make.width.mas_equalTo(FIT_SCALE(250));
    }];
    
    [self.conLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.arrawImgV.mas_left).offset(-FIT_SCALE(5));
        make.top.mas_equalTo(FIT_SCALE(15));
        make.bottom.mas_equalTo(-FIT_SCALE(15));
        make.height.mas_greaterThanOrEqualTo(FIT_SCALE(20));
        make.width.mas_equalTo(FIT_SCALE(240));
    }];
    
    [self.arrawImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(-FIT_SCALE(15));
        make.size.mas_equalTo(CGSizeMake(FIT_SCALE(5.5), FIT_SCALE(12.5)));
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(FIT_SCALE(15));
        make.right.mas_equalTo(-FIT_SCALE(15));
        make.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
    
    [self.titleLab setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.titleLab setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.conLab setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.conLab setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.conLab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.conLab sizeToFit];
}

- (void)hiddenImg{
    self.arrawImgV.hidden = YES;
    [self.arrawImgV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(FIT_SCALE(0), FIT_SCALE(12.5)));
    }];
    [self.conLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.arrawImgV.mas_left).offset(-FIT_SCALE(5));
    }];
}

- (void)showImg{
    self.arrawImgV.hidden = NO;
    [self.arrawImgV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(FIT_SCALE(5.5), FIT_SCALE(12.5)));
    }];
    [self.conLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.arrawImgV.mas_left).offset(-FIT_SCALE(5));
    }];
}

- (void)setIsImgHidden:(BOOL)isImgHidden{
    _isImgHidden = isImgHidden;
    self.arrawImgV.hidden = isImgHidden;
    if (isImgHidden) {
        [self hiddenImg];
    } else {
        [self showImg];
    }
}

- (void)setIsEdit:(BOOL)isEdit{
    _isEdit = isEdit;
    self.conTextView.editable = isEdit;
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
