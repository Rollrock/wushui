//
//  ScoreCellView.h
//  Disney
//
//  Created by zhuang chaoxiao on 14-12-5.
//  Copyright (c) 2014年 zhuang chaoxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dataStruct.h"

@interface ScoreCellView : UIView

-(id)initWithFrame:(CGRect)frame withInfo:(ScoreListInfo*)info withVC:(UIViewController*)vc withRow:(int)index withType:(SCORE_CELL_VIEW)type;

@end
