//
//  AboutViewController.m
//  Disney
//
//  Created by zhuang chaoxiao on 14-12-5.
//  Copyright (c) 2014年 zhuang chaoxiao. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    {
        
        UIButton * leftBtn = [[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 25)]autorelease];
        [leftBtn addTarget:self action:@selector(backClicked) forControlEvents:UIControlEventTouchUpInside];
        [leftBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        
        UIBarButtonItem * leftItem = [[[UIBarButtonItem alloc]initWithCustomView:leftBtn]autorelease];
        
        self.navigationItem.leftBarButtonItem = leftItem;
        
    }
    
    
    [self layoutView];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
}


-(void)layoutView
{
    CGRect rect;
    
    {
        rect = CGRectMake(100, 20, 100,100);
        UIImageView * imageView = [[[UIImageView alloc]initWithFrame:rect]autorelease];
        imageView.image = [UIImage imageNamed:@"icon"];
        imageView.layer.cornerRadius = 8;
        imageView.layer.masksToBounds = YES;
        
        [self.view addSubview:imageView];
    }
    
    
    //
    
    {
        rect = CGRectMake(20, 140, 280 ,200);
        
        UIImageView * imageView = [[[UIImageView alloc]initWithFrame:rect]autorelease];
        imageView.image = [UIImage imageNamed:@"about_info_bg"];
        
        [self.view addSubview:imageView];
        
        {
            rect = CGRectMake(10, 20, 260, 30);
            UILabel * lab = [[[UILabel alloc]initWithFrame:rect]autorelease];
            lab.text = @"QQ:123456789";
            lab.layer.cornerRadius = 5;
            lab.layer.masksToBounds = YES;
            lab.textAlignment = NSTextAlignmentCenter;
            lab.backgroundColor = [UIColor lightGrayColor];
            [imageView addSubview:lab];
        }
        
        {
            rect = CGRectMake(10, 70, 260, 30);
            UILabel * lab = [[[UILabel alloc]initWithFrame:rect]autorelease];
            lab.text = @"邮箱:13800138000@163.com";
            lab.layer.cornerRadius = 5;
            lab.layer.masksToBounds = YES;
            lab.textAlignment = NSTextAlignmentCenter;
            lab.backgroundColor = [UIColor lightGrayColor];
            [imageView addSubview:lab];
        }
    }
    
}

-(void)backClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
