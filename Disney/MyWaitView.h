//
//  MyWaitView.h
//  Disney
//
//  Created by zhuang chaoxiao on 13-11-17.
//  Copyright (c) 2013年 zhuang chaoxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyWaitView : UIView
{
    UIImageView * _imgView;
    UIView * _parentView;
}

-(id)initWithParent:(UIView*)parentView;
-(void)dismisssaa;
@end
