//
//  JASlider.m
//  JAXuMu
//
//  Created by developeng on 2019/8/27.
//  Copyright © 2019 developeng. All rights reserved.
//

#import "JASlider.h"

@implementation JASlider

-(CGRect)trackRectForBounds:(CGRect)bounds{
    if (_sliderHight == 0.00) {
        _sliderHight = 6;
    }
    return CGRectMake(0, (self.frame.size.height-_sliderHight)/2, self.frame.size.width, _sliderHight);
}

@end
