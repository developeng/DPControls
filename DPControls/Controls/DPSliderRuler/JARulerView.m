//
//  JARulerView.m
//  JAXuMu
//
//  Created by developeng on 2019/8/28.
//  Copyright © 2019 developeng. All rights reserved.
//

#import "JARulerView.h"
#import "JARulerLayout.h"

#define kDirectionHorizontal (self.rulerLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal)
#define edgeInset  20

static NSString *const rulerCollectionViewCellIdentifier = @"rulerCollectionViewCellIdentifier";

@interface JARulerView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) JARulerLayout *rulerLayout;
@property (nonatomic, strong) UICollectionView *rulerCollectionView;                        /**< 刻度尺实际实现视图  */
@property (nonatomic, strong) UICollectionView *backCollectionView;                        /**< 标注值视图  */
@end

@implementation JARulerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self defaultSettings];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
}

#pragma mark - 默认设置
- (void)defaultSettings {
    //刻度高度
    self.shortScaleLength = 10;
    self.longScaleLength = 20;
    //刻度宽度
    self.scaleWidth = 2;
    //刻度起始位置
    self.shortScaleStart = 0;
    self.longScaleStart = 0;
    //刻度颜色
    self.scaleColor = UIColorFromHex(0x666666);
    //刻度距离数字的距离
    self.distanceFromScaleToNumber = 10;
    //文字属性
    self.numberFont = [UIFont systemFontOfSize:10];
    self.numberColor = UIColorFromHex(0x666666);
    self.numberDirection = numberBottom;
    self.min = 0;
}

- (void)updateDefaultSettings {
    //刻度高度
    self.shortScaleLength = 10;
    self.longScaleLength = 20;
    //刻度宽度
    self.scaleWidth = 2;
    //刻度起始位置
    self.shortScaleStart = 5;
    self.longScaleStart = 0;
    //刻度颜色
    self.scaleColor = UIColorFromHex(0x666666);
    //刻度距离数字的距离
    self.distanceFromScaleToNumber = 10;
    //文字属性
    self.numberFont = [UIFont systemFontOfSize:10];
    self.numberColor = UIColorFromHex(0x666666);
    self.numberDirection = numberBottom;
    self.min = 0;
}


- (void)setType:(DPSliderType)type{
    _type = type;
    [self updateDefaultSettings];
}


- (void)setDistanceBetweenScale:(CGFloat)distanceBetweenScale{
    _distanceBetweenScale = distanceBetweenScale;
    [self layoutViews];
}

- (void)setRowNum:(NSInteger)rowNum{
    _rowNum = rowNum;
    self.distanceBetweenScale = (self.bounds.size.width-((rowNum+1)* self.scaleWidth)-edgeInset*2)/(rowNum);
    [self.rulerCollectionView reloadData];
}

- (void)setUnit:(NSString *)unit{
    _unit = unit;
    [self.rulerCollectionView reloadData];
}

#pragma mark - 视图布局
- (void)layoutViews {
    if (!_rulerCollectionView) {
        //计算cell的size
        self.rulerLayout = [[JARulerLayout alloc] init];
        self.rulerLayout.spacing = self.distanceBetweenScale;
        if (self.numberDirection == numberTop || self.numberDirection == numberBottom) {
            //水平方向
            self.rulerLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            self.rulerLayout.itemSize = CGSizeMake(self.scaleWidth, CGRectGetHeight(self.frame));
        } else {
            //垂直方向
            self.rulerLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
            self.rulerLayout.itemSize = CGSizeMake(CGRectGetWidth(self.frame), self.scaleWidth);
        }
        
        self.rulerCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.rulerLayout];
        self.rulerCollectionView.delegate = self;
        self.rulerCollectionView.dataSource = self;
        self.rulerCollectionView.showsVerticalScrollIndicator = NO;
        self.rulerCollectionView.showsHorizontalScrollIndicator = NO;
        self.rulerCollectionView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        
        //前后偏移
        self.rulerCollectionView.contentInset = (kDirectionHorizontal ? UIEdgeInsetsMake(0, edgeInset, 0, edgeInset) : UIEdgeInsetsMake(edgeInset, 0, edgeInset, 0));
        self.rulerCollectionView.bounces = NO;
        [self.rulerCollectionView registerClass:[JARulerCollectionCell class] forCellWithReuseIdentifier:rulerCollectionViewCellIdentifier];
        self.rulerCollectionView.tag = 1;
        [self addSubview:self.rulerCollectionView];
    }
    
    if (self.type == DPSliderType_TYPE_II) {
        if (!_backCollectionView) {
            self.backCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.rulerLayout];
            self.backCollectionView.delegate = self;
            self.backCollectionView.dataSource = self;
            self.backCollectionView.showsVerticalScrollIndicator = NO;
            self.backCollectionView.showsHorizontalScrollIndicator = NO;
            self.backCollectionView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
            
            //前后偏移
            self.backCollectionView.contentInset = (kDirectionHorizontal ? UIEdgeInsetsMake(0, edgeInset, 0, edgeInset) : UIEdgeInsetsMake(edgeInset, 0, edgeInset, 0));
            self.backCollectionView.bounces = NO;
            [self.backCollectionView registerClass:[JARulerCollectionCell class] forCellWithReuseIdentifier:rulerCollectionViewCellIdentifier];
            self.backCollectionView.tag = 2;
            [self addSubview:self.backCollectionView];
        }
    }
}

#pragma mark - UICollectionView代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //校验数据
    if (self.max == 0 || self.min >= self.max) {
        return 0;
    }
    return self.rowNum + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JARulerCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:rulerCollectionViewCellIdentifier forIndexPath:indexPath];
    cell.index = indexPath.item;
    //刻度属性设置
    cell.shortScaleLength = self.shortScaleLength;
    cell.longScaleLength = self.longScaleLength;
    cell.scaleWidth = self.scaleWidth;
    cell.scaleColor = self.scaleColor;
    cell.shortScaleStart = self.shortScaleStart;
    cell.longScaleStart = self.longScaleStart;
    cell.numberFont = self.numberFont;
    cell.numberColor = self.numberColor;
    cell.numberDirection = self.numberDirection;
    cell.distanceFromScaleToNumber = self.distanceFromScaleToNumber;
    cell.isDecimal = self.isDecimal;
    cell.min = self.min;
    cell.max = self.max;
    cell.stepLength = (self.max - self.min)/self.rowNum;
    cell.reverse = self.reverse;
    cell.unit = self.unit;
    cell.sliderType = self.type;
    cell.selectValue = self.selectValue;
    if (self.type == DPSliderType_TYPE_II) {
        if (collectionView.tag == 1) {
            cell.textLayer.hidden = YES;
            cell.ruleImageView.hidden = NO;
        } else {
            cell.textLayer.hidden = NO;
            cell.ruleImageView.hidden = YES;
        }
    }
    [cell setNeedsLayout];
    [cell makeCellHiddenText];
    
    return cell;
}

- (void)setSelectValue:(CGFloat)selectValue{
    _selectValue = selectValue;
    [self.rulerCollectionView reloadData];
}
@end
