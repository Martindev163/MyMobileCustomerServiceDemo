//
//  CustomEvaluateTabCell.h
//  MyMobileCustomerServiceDemo
//
//  Created by 马浩哲 on 16/11/22.
//  Copyright © 2016年 junanxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomEvaluateTabCellDelegate <NSObject>

-(void)ImmediateEvaluationAction;

@end

@interface CustomEvaluateTabCell : UITableViewCell

@property (nonatomic, weak) id<CustomEvaluateTabCellDelegate> delegate;

@end
