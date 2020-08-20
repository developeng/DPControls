//
//  DPActionSheet.h
//  DPActionSheetDemo
//
//  Created by developeng on 2018/1/11.
//  Copyright © 2018年 developeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , DPActionSheetType) {
    DPActionSheetType_Custom = 0,
    DPActionSheetType_System
};

@protocol DPActionSheetDelegate;
@interface DPActionSheet : UIView
@property(weak, nonatomic) id <DPActionSheetDelegate> delegate;
@property(strong, nonatomic) NSString *title;
@property(strong, nonatomic) NSString *cancelButtonTitle;
@property(strong, nonatomic) NSString *buttonName;
@property(nonatomic, assign) DPActionSheetType actionSheetType;

- (id)initWithTitle:(NSString *)title delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
- (id)initWithTitle:(NSString *)title delegate:(id)delegate type:(DPActionSheetType)type cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonArr:(NSArray *)otherButtonArr;


- (void)show;
- (void)hide;
- (void)setTitleColor:(UIColor *)color fontSize:(CGFloat)size;
- (void)setButtonTitleColor:(UIColor *)color bgColor:(UIColor *)bgcolor fontSize:(CGFloat)size atIndex:(int)index;
- (void)setCancelButtonTitleColor:(UIColor *)color bgColor:(UIColor *)bgcolor fontSize:(CGFloat)size;

@end

@protocol DPActionSheetDelegate <NSObject>
@optional
- (void)actionSheetCancel:(DPActionSheet *)actionSheet;
- (void)actionSheet:(DPActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex;
@end
