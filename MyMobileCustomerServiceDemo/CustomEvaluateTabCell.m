//
//  CustomEvaluateTabCell.m
//  MyMobileCustomerServiceDemo
//
//  Created by 马浩哲 on 16/11/22.
//  Copyright © 2016年 junanxin. All rights reserved.
//

#import "CustomEvaluateTabCell.h"

@interface CustomEvaluateTabCell()

@property (nonatomic, strong) UIButton *evaluateBtn;
@property (nonatomic, strong) UILabel *instructionLab;
@end

@implementation CustomEvaluateTabCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self loadCellContent];
       
    }
    return self;
}

#pragma mark - 加载cell 内容
-(void)loadCellContent
{
    self.backgroundColor = [UIColor clearColor];
    
    _instructionLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, kDeviceWidth -40, 15)];
    _instructionLab.text = @"请对我们的服务给出评价";
    _instructionLab.font = [UIFont systemFontOfSize:14];
    _instructionLab.textColor = [UIColor darkGrayColor];
    _instructionLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_instructionLab];
    
    _evaluateBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 25, 100, 35)];
    _evaluateBtn.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
    [_evaluateBtn setTitle:@"立即评价" forState:UIControlStateNormal];
    [_evaluateBtn setTitle:@"已经评价" forState:UIControlStateSelected];
    _evaluateBtn.layer.cornerRadius = 2;
    _evaluateBtn.layer.masksToBounds = YES;
    [_evaluateBtn addTarget:self action:@selector(gotoEvalutePage) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_evaluateBtn];
}


-(void)gotoEvalutePage
{
    if ([self.delegate respondsToSelector:@selector(ImmediateEvaluationAction)]) {
        [self.delegate ImmediateEvaluationAction];
    }
}
@end
