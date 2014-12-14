//
//  TourCellView.h
//  Disney
//
//  Created by zhuang chaoxiao on 13-10-26.
//  Copyright (c) 2013年 zhuang chaoxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dataStruct.h"
#import "UIImageView+WebCache.h"

@interface NewListCell : UIView

@property(nonatomic,retain) UIImageView * imgView;
@property(nonatomic,retain) UILabel * titleLabel;
@property(nonatomic,retain) UILabel * detailLabel;

-(id)initWithFrame:(CGRect)frame withInfo:(NewsListInfo*)info;

@end
