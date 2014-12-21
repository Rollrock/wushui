//
//  ScoreDetailViewController.m
//  Disney
//
//  Created by zhuang chaoxiao on 14-12-5.
//  Copyright (c) 2014年 zhuang chaoxiao. All rights reserved.
//

#import "ScoreDetailViewController.h"
#import "ASIFormDataRequest.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"

@interface ScoreDetailViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    CGFloat downYPos;
    
    ASIFormDataRequest * _dataReq;
    ASIFormDataRequest * _scoreReq;
    
    NSArray * _scoreArray;
    
    NSString * _score;
    
    UIScrollView * _scrView;
}
@end

@implementation ScoreDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    CGRect rect = CGRectMake(0, 0, 320, 480-65);
    _scrView = [[UIScrollView alloc]initWithFrame:rect];
    [self.view addSubview:_scrView];
    
    _scoreArray = [[NSArray alloc]initWithObjects:@"0分", @"1分",@"2分",@"3分",@"4分",@"5分",@"6分",@"7分",@"8分",@"9分",@"10分",nil];
    
    _score = @"0分";
    
    [self layoutView:_info];
    
    [self startRequest];
    
    [self layoutBackView];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
}


-(void)layoutBackView
{
    
    UIButton * leftBtn = [[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 25)]autorelease];
    [leftBtn addTarget:self action:@selector(backClicked) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    UIBarButtonItem * leftItem = [[[UIBarButtonItem alloc]initWithCustomView:leftBtn]autorelease];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    
}
-(void)startRequest
{
    AppDelegate * _appDel = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    _dataReq = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:@"http://115.159.30.191/water/json?"]];
    [_dataReq setPostValue:_appDel.userId forKey:@"userId"];
    [_dataReq setPostValue:@"BC0004" forKey:@"trancode"];
    [_dataReq setPostValue:@"MB" forKey: @"channal"];
    [_dataReq setPostValue:_info.flowNo forKey:@"flowNo"];
    
    _dataReq.delegate = self;
    
    
    [_dataReq startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if( request == _dataReq )
    {
        NSString * str = request.responseString;
        
        NSDictionary * dict = [str objectFromJSONString];
        NSLog(@"dict:%@",dict);
        NSLog(@"dict:%@", [[dict objectForKey:@"common"] objectForKey:@"respMsg"]);
        
        NSString * strCode = [[dict objectForKey:@"common"] objectForKey:@"respCode"];
        
        NSLog(@"strCode:%@ ",strCode);
        
        
        if( [strCode isEqualToString:@"00000"] )
        {
            NSDictionary * subDict = [dict objectForKey:@"content"];
            
            NSString * status = [[subDict objectForKey:@"infor"] objectForKey:@"status"];
            NSString * backward = [[subDict objectForKey:@"infor"] objectForKey:@"backward"];
            
            NSArray * imgUrlArray = [subDict objectForKey:@"images"];
            
            if( [status isEqualToString:@"0"] )
            {
                backward = @"未处理";
            }
            
            //test
            //NSMutableArray * array = [[[ NSMutableArray alloc]initWithObjects:@"http://img1.cache.netease.com/ent/2014/12/4/20141204200009bdbd3.jpg",@"http://img1.cache.netease.com/ent/2014/12/4/20141204200009bdbd3.jpg", nil]autorelease];
            //
            [self layoutRespView:status withBackward:backward withImgUrlArray:imgUrlArray];
            
        }
    }
    else if( request == _scoreReq )
    {
        NSString * str = request.responseString;
        
        NSDictionary * dict = [str objectFromJSONString];
        NSLog(@"dict:%@",dict);
        NSLog(@"dict:%@", [[dict objectForKey:@"common"] objectForKey:@"respMsg"]);
        
        NSString * strCode = [[dict objectForKey:@"common"] objectForKey:@"respCode"];
        
        NSLog(@"strCode:%@ ",strCode);

    }
}


-(void)layoutRespView:(NSString*)status withBackward:(NSString*)backward withImgUrlArray:(NSArray*)array
{
    CGRect rect;
    //
    
    downYPos += 20;
    {
        rect = CGRectMake(10, downYPos, 300, 20);
        UILabel * lab = [[[UILabel alloc]initWithFrame:rect]autorelease];
        lab.text = [NSString stringWithFormat:@"反馈内容 :%@",backward];
        
        [_scrView addSubview:lab];
        
        downYPos += 8 + 28;
    }
    
    
    {
        downYPos += 40;
        
        rect = CGRectMake(10, downYPos-10, 100, 20);
        UILabel * lab = [[[UILabel alloc]initWithFrame:rect]autorelease];
        lab.text = @"反馈图片";
        
        [_scrView addSubview:lab];
        //
        
        for( int i = 0; i < 2; ++ i )
        {
            rect = CGRectMake(10+100+10 + (80+10)*i, downYPos - 40, 80, 80);
            UIImageView * imgView = [[[UIImageView alloc]initWithFrame:rect]autorelease];
            imgView.layer.cornerRadius = 5;
            imgView.layer.masksToBounds = YES;
            imgView.image = [UIImage imageNamed:@"noPhoto"];
            [_scrView addSubview:imgView];
        }

        
        for( int i = 0; i < ([array count] >= 2 ? 2: [array count]); ++ i )
        {
            rect = CGRectMake(10+100+10 + (80+10)*i, downYPos - 40, 80, 80);
            UIImageView * imgView = [[[UIImageView alloc]initWithFrame:rect]autorelease];
            imgView.layer.cornerRadius = 5;
            imgView.layer.masksToBounds = YES;
            [imgView setImageWithURL:[NSURL URLWithString:[array objectAtIndex:i]]];
            [_scrView addSubview:imgView];
        }
        
        downYPos += 10 + 40;
    }
    
    
    {
        rect = CGRectMake(10, downYPos, 300, 20);
        UILabel * lab = [[[UILabel alloc]initWithFrame:rect]autorelease];
        lab.text = @"满意度评分";
        
        [_scrView addSubview:lab];
        
        {
            rect = CGRectMake(10, downYPos+20+10, 300, 200);
            UIPickerView * pickView = [[[UIPickerView alloc]initWithFrame:rect]autorelease];
            pickView.layer.cornerRadius = 5;
            pickView.layer.masksToBounds = YES;
            pickView.delegate = self;
            pickView.dataSource = self;
            pickView.backgroundColor = [UIColor lightGrayColor];
            
            [_scrView addSubview:pickView];

        }
        
        downYPos += 200+ 30;
    }
    
    {
        rect = CGRectMake(80, downYPos, 180, 40);
        UIButton * btnScore = [[[UIButton alloc]initWithFrame:rect]autorelease];
        [btnScore setBackgroundImage:[UIImage imageNamed:@"submit_score"] forState:UIControlStateNormal];
        
        [btnScore addTarget:self action:@selector(scoreClick) forControlEvents:UIControlEventTouchUpInside];
        [_scrView addSubview:btnScore];
        
        
        if( [status isEqualToString:@"0"] )
        {
            btnScore.enabled = NO;
        }
        
    }
    _scrView.contentSize = CGSizeMake(320, downYPos+200);
}


-(void)scoreClick
{
    AppDelegate * appDel = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    _scoreReq = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:@"http://115.159.30.191/water/json?"]];
    [_scoreReq setPostValue:appDel.userId forKey:@"userId"];
    [_scoreReq setPostValue:@"BC0005" forKey:@"trancode"];
    [_scoreReq setPostValue:@"MB" forKey: @"channal"];
    [_scoreReq setPostValue:_info.flowNo forKey:@"flowNo"];
    [_scoreReq setPostValue:_info.messageNo forKey:@"messagNo"];
    [_scoreReq setPostValue:_score forKey:@"score"];
    
    _scoreReq.delegate = self;
    
    [_scoreReq startAsynchronous];

}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_scoreArray count];
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_scoreArray objectAtIndex:row];
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"selected:%@",[_scoreArray objectAtIndex:row]);
    
    _score = [_scoreArray objectAtIndex:row];
}



- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"requestFailed:%@",request.error);
}


-(void)backClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)layoutView:(ScoreListInfo*)info
{
    CGFloat yPos = 0;
    CGRect rect;
    
    //
    rect = CGRectMake(5, 0, 310, 160);
    UIImageView * bgView = [[[UIImageView alloc]initWithFrame:rect]autorelease];
    bgView.image = [UIImage imageNamed:@"score_cell_bg"];
    bgView.userInteractionEnabled = YES;
    [_scrView addSubview:bgView];
    
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
        
        yPos += 20+10;
    }
    
    
    downYPos = yPos;
    
    //
    
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
