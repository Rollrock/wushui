//
//  TourCellView.m
//  Disney
//
//  Created by zhuang chaoxiao on 13-10-26.
//  Copyright (c) 2013年 zhuang chaoxiao. All rights reserved.
//

#import "NewListCell.h"

#import "UIImageView+WebCache.h"

#define IMAGE_WIDTH 70
#define IMAGE_HEIGHT 50

#define VIEW_WIDHT 300
#define VIEW_HEIGHT 60

#define LABEL_WIDTH  300-75


@implementation NewListCell

-(id)initWithFrame:(CGRect)frame withInfo:(NewsListInfo*)info
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        CGRect rect;
        
        rect = CGRectMake(5, 5, IMAGE_WIDTH, IMAGE_HEIGHT);
        _imgView = [[[UIImageView alloc]initWithFrame:rect]autorelease];
        
        [_imgView setImageWithURL:[NSURL URLWithString:info.image] placeholderImage:[UIImage imageNamed:@"new_list_img_def"]];

        [self addSubview:_imgView];
        
        
        rect = CGRectMake(5+IMAGE_WIDTH+5, 5, LABEL_WIDTH, 15);
        _titleLabel = [[[UILabel alloc]initWithFrame:rect]autorelease];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        //_titleLabel.text = @"测试数据";
        _titleLabel.text = info.title;
        [self addSubview:_titleLabel];
        
        rect = CGRectMake(5+IMAGE_WIDTH+5, 20, LABEL_WIDTH, VIEW_HEIGHT-20);
        _detailLabel = [[[UILabel alloc]initWithFrame:rect]autorelease];
        _detailLabel.numberOfLines = 0;
        _detailLabel.font = [UIFont systemFontOfSize:13];
        _detailLabel.textColor = [UIColor grayColor];
        //_detailLabel.text = @"测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据";
        _detailLabel.text = info.desc;
        [self addSubview:_detailLabel];
        

    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        /*
        CGRect rect;
        
        rect = CGRectMake(5, 5, IMAGE_WIDTH, IMAGE_HEIGHT);
        _imgView = [[[UIImageView alloc]initWithFrame:rect]autorelease];
        _imgView.image = [UIImage imageNamed:@"tourPic1"];
        [self addSubview:_imgView];
        
        
        rect = CGRectMake(5+IMAGE_WIDTH+5, 5, LABEL_WIDTH, 15);
        _titleLabel = [[[UILabel alloc]initWithFrame:rect]autorelease];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.text = @"测试数据";
        //_titleLabel.text = info.title;
        [self addSubview:_titleLabel];
        
        rect = CGRectMake(5+IMAGE_WIDTH+5, 20, LABEL_WIDTH, VIEW_HEIGHT-20);
        _detailLabel = [[[UILabel alloc]initWithFrame:rect]autorelease];
        _detailLabel.numberOfLines = 0;
        _detailLabel.font = [UIFont systemFontOfSize:13];
        _detailLabel.textColor = [UIColor grayColor];
        _detailLabel.text = @"测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据";
        //_detailLabel.text = info.desc;
        [self addSubview:_detailLabel];
         
         */
        
    }
    return self;
}

-(void)dealloc
{
    
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
