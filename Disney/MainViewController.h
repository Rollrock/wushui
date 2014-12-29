//
//  MainViewController.h
//  Disney
//
//  Created by zhuang chaoxiao on 13-10-21.
//  Copyright (c) 2013年 zhuang chaoxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tabbarView.h"
#import "RptViewController.h"
#import "ScoreListViewController.h"
#import "NewsViewController.h"


@interface MainViewController : UIViewController
{
    tabbarView * _tabbarView;
    
    RptViewController * _firstViewC;
    ScoreListViewController * _secondViewC;
    NewsViewController * _thirdViewC;
    
    UINavigationController * _firstNav;
    UINavigationController * _secondNav;
    UINavigationController * _thirdNav;
}


@property(nonatomic,retain) NSString * updateDate;
@property(nonatomic,retain) NSMutableArray * imgUrlArray;


-(void)updateWelcomeView;

@end
