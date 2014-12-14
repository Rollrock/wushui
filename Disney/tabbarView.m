//
//  tabbarView.m
//  Disney
//
//  Created by zhuang chaoxiao on 13-10-22.
//  Copyright (c) 2013年 zhuang chaoxiao. All rights reserved.
//

#import "tabbarView.h"

@implementation tabbarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        [self setFrame:frame];

        [self layoutView];
    }
    return self;
}


-(void)layoutView
{
    _tabbarView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tabbar_0"]];
    _tabbarView.frame = CGRectMake(0, 9, 320, 51);
    _tabbarView.userInteractionEnabled = YES;

    [self addSubview:_tabbarView];
    
    [self layoutButton];
}

-(void)layoutButton
{
    _btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 107, 60)];
    [_btn1 setTag:101];
    [_btn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _btn2 = [[UIButton alloc]initWithFrame:CGRectMake(107, 0, 107, 60)];
    [_btn2 setTag:102];
    [_btn2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _btn3 = [[UIButton alloc]initWithFrame:CGRectMake(107*2, 0, 107, 60)];
    [_btn3 setTag:103];
    [_btn3 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_tabbarView addSubview:_btn1];
    [_tabbarView addSubview:_btn2];
    [_tabbarView addSubview:_btn3];
}




-(void)btnClick:(id)sender
{
    
    UIButton * btn = (UIButton*)sender;
    
    NSLog(@"btnTag:%d",btn.tag);
    
    switch (btn.tag)
    {
        case 101:
            [_tabbarView setImage:[UIImage imageNamed:@"tabbar_0"]];
            [self.delegate tabClickIndex:1];
            break;
        
        case 102:
            [_tabbarView setImage:[UIImage imageNamed:@"tabbar_1"]];
            [self.delegate tabClickIndex:2];
            break;
            
        case 103:
            [_tabbarView setImage:[UIImage imageNamed:@"tabbar_3"]];
            [self.delegate tabClickIndex:3];
            break;
            
        case 104:
            [_tabbarView setImage:[UIImage imageNamed:@"tabbar_4"]];
            [self.delegate tabClickIndex:4];
            break;
            
        case 100:
            [self.delegate tabClickIndex:0];
            break;
    }
    
    
    
}


















/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
