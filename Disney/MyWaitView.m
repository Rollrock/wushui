//
//  MyWaitView.m
//  Disney
//
//  Created by zhuang chaoxiao on 13-11-17.
//  Copyright (c) 2013年 zhuang chaoxiao. All rights reserved.
//

#import "MyWaitView.h"
#import "dataStruct.h"

@implementation MyWaitView




-(id)initWithParent:(UIView*)parentView
{
    CGRect rect;
    rect = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height - CUSTOM_TAB_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT + CUSTOM_TAB_BAR_OFFSET-STATUS_BAR_HEIGHT);
    
    self = [super initWithFrame:rect];
    if (self) {
        // Initialization code
           
        [self layoutView];
        
        [parentView addSubview:self];

        
    }
    return self;

}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self layoutView];
        
    }
    return self;
}



-(void)layoutView
{
    CGRect rect;
    
    _imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_wait"]];
    _imgView.center = CGPointMake(160, 240);
    
    [self addSubview:_imgView];
    
    rect = CGRectMake(0, 10, 120, 25);
    UILabel * lab = [[[UILabel alloc]initWithFrame:rect]autorelease];
    lab.text = @"数据加载中...";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.backgroundColor = [UIColor clearColor];
    [_imgView addSubview:lab];

    
    self.backgroundColor = [UIColor grayColor];

}

-(void)dismisssaa
{
    [self removeFromSuperview];
}



-(void)dealloc
{
    
    [_imgView release];
    
    [super dealloc];
    
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
