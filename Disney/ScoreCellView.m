//
//  ScoreCellView.m
//  Disney
//
//  Created by zhuang chaoxiao on 14-12-5.
//  Copyright (c) 2014年 zhuang chaoxiao. All rights reserved.
//


/*
 这个viewCell为多个界面公用
 
////
////
////
////
*/
#import "ScoreCellView.h"
#import "dataStruct.h"

@interface ScoreCellView()
{
    UIViewController * _parentVC;
    
    int rowIndex;
    SCORE_CELL_VIEW veiwType;
}

@end

@implementation ScoreCellView


-(id)initWithFrame:(CGRect)frame withInfo:(ScoreListInfo*)info withVC:(UIViewController*)vc withRow:(int)index withType:(SCORE_CELL_VIEW)type
{
    self = [super initWithFrame:frame];
    
    if( self )
    {
        //test
        
        /*
        ScoreListInfo * scoreInfo = [[ScoreListInfo alloc]init];
        
        scoreInfo.messageNo = @"20048473773736";
        scoreInfo.time = @"2014-11-30  13:45:20";
        scoreInfo.town = @"春江街道";
        scoreInfo.address = @"浦东新区张东路2281弄28号";
        scoreInfo.desc = @"阿的说法是京东方垃圾的说法大家说法";
        */
        
        rowIndex = index;
        _parentVC = vc;
        veiwType = type;
        
        [self layoutView:info];
    }
    
    return self;
}


-(void)layoutView:(ScoreListInfo*)info
{
    CGFloat yPos = 0;
    CGRect rect;
    
    //
    rect = CGRectMake(5, 0, 310, 200);
    UIImageView * bgView = [[[UIImageView alloc]initWithFrame:rect]autorelease];
    bgView.image = [UIImage imageNamed:@"score_cell_bg"];
    bgView.userInteractionEnabled = YES;
    [self addSubview:bgView];
    
    //
    {
        
        rect = CGRectMake(10, 8, 300, 20);
        UILabel * lab = [[[UILabel alloc]initWithFrame:rect]autorelease];
        lab.text = [NSString stringWithFormat:@"信息编号 :%@",info.messageNo];
        
        [bgView addSubview:lab];
        
        yPos += 8 + 28;
    }
    
    {
        rect = CGRectMake(10, yPos, 300, 20);
        UILabel * lab = [[[UILabel alloc]initWithFrame:rect]autorelease];
        lab.text = [NSString stringWithFormat:@"具体地址 :%@",info.address];
        
        [bgView addSubview:lab];
        
        yPos += 28;
    }
    
    {
        rect = CGRectMake(10, yPos, 300, 20);
        UILabel * lab = [[[UILabel alloc]initWithFrame:rect]autorelease];
        lab.text = [NSString stringWithFormat:@"上传时间 :%@",info.time];
        
        [bgView addSubview:lab];
        
        yPos += 28;
    }
    
    
    {
        rect = CGRectMake(10, yPos, 300, 20);
        UILabel * lab = [[[UILabel alloc]initWithFrame:rect]autorelease];
        lab.text = [NSString stringWithFormat:@"所属街道/乡镇 :%@",info.town];
        
        [bgView addSubview:lab];
        
        yPos += 28;
    }
    
    {
        rect = CGRectMake(10, yPos, 300, 20);
        UILabel * lab = [[[UILabel alloc]initWithFrame:rect]autorelease];
        lab.text = [NSString stringWithFormat:@"问题描述 :%@",info.desc];
        
        [bgView addSubview:lab];
        
        yPos += 35;
    }
    
    
    if( SCORE_CELL_VIEW_SCORE == veiwType )
    {
        rect = CGRectMake(70, yPos, 180, 35);
        UIButton * btn = [[[UIButton alloc]initWithFrame:rect]autorelease];
        btn.layer.cornerRadius = 7;
        btn.layer.masksToBounds = YES;
        [btn setBackgroundImage:[UIImage imageNamed:@"score_cell_look"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(lookClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [bgView addSubview:btn];
    }
    else if( SCORE_CELL_VIEW_LOCAL_SAVE == veiwType )
    {
        {
            rect = CGRectMake(20, yPos, 120, 35);
            UIButton * btn = [[[UIButton alloc]initWithFrame:rect]autorelease];
            btn.layer.cornerRadius = 7;
            btn.layer.masksToBounds = YES;
            [btn setBackgroundImage:[UIImage imageNamed:@"report_now"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(reportClicked) forControlEvents:UIControlEventTouchUpInside];
            
            [bgView addSubview:btn];
        }
        
        {
            rect = CGRectMake(160, yPos, 120, 35);
            UIButton * btn = [[[UIButton alloc]initWithFrame:rect]autorelease];
            btn.layer.cornerRadius = 7;
            btn.layer.masksToBounds = YES;
            [btn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(deleteClicked) forControlEvents:UIControlEventTouchUpInside];
            
            [bgView addSubview:btn];
        }
    }
}

-(void)reportClicked
{
    NSLog(@"reportClicked");
    
    if( [_parentVC respondsToSelector:@selector(reportNow:)] )
    {
        [_parentVC reportNow:rowIndex];
    }
}


-(void)deleteClicked
{
    NSLog(@"deleteClicked");
    
    if( [_parentVC respondsToSelector:@selector(deleteNow:)] )
    {
        [_parentVC deleteNow:rowIndex];
    }
}

-(void)lookClicked
{
    NSLog(@"lookClicked");
    
    if( [_parentVC respondsToSelector:@selector(lookUpDetailInfo:)] )
    {
        [_parentVC lookUpDetailInfo:rowIndex];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
