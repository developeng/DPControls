//
//  JARulerLayout.h
//  JAXuMu
//
//  Created by developeng on 2019/8/28.
//  Copyright © 2019 developeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JARulerLayout : UICollectionViewLayout

@property (nonatomic, assign) CGFloat spacing;                                      /**< cell间距  */
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;      /**< 滑动方向  */

@end

NS_ASSUME_NONNULL_END
