//
//  DPBaseTableViewCell.m
//  DPControls
//
//  Created by developeng on 2019/9/30.
//  Copyright © 2019 developeng. All rights reserved.
//

#import "DPBaseTableViewCell.h"

@implementation DPBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

+ (instancetype)loadNormalCellWithTableView:(UITableView *)tableView{
    NSString *className = NSStringFromClass([self class]);
    NSString *identifier = [className stringByAppendingString:@"cellID"];
    [tableView registerClass:[self class] forCellReuseIdentifier:identifier];
    return [tableView dequeueReusableCellWithIdentifier:identifier];
}

+ (instancetype)loadNibCellWithTableView:(UITableView *)tableView{
    NSString *classname = NSStringFromClass([self class]);
    NSString *identifier = [classname stringByAppendingString:@"nibCellID"];
    UINib *nib = [UINib nibWithNibName:classname bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:identifier];
    return [tableView dequeueReusableCellWithIdentifier:identifier];
}

@end
