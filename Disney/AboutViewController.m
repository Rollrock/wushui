//
//  AboutViewController.m
//  Disney
//
//  Created by zhuang chaoxiao on 14-12-5.
//  Copyright (c) 2014年 zhuang chaoxiao. All rights reserved.
//

#import "AboutViewController.h"
#import "dataStruct.h"
#import "ASIFormDataRequest.h"
#import "AppDelegate.h"

@interface AboutViewController ()
{
    ASIFormDataRequest * _dataReq;
    
    UIScrollView * _scrView;
}
@end

@implementation AboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    NSLog(@"AboutViewController:%f--%f---%f---%f",rect.origin.x,rect.origin.y,  rect.size.width,rect.size.height);
    
    {
        
        UIButton * leftBtn = [[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 25)]autorelease];
        [leftBtn addTarget:self action:@selector(backClicked) forControlEvents:UIControlEventTouchUpInside];
        [leftBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        
        UIBarButtonItem * leftItem = [[[UIBarButtonItem alloc]initWithCustomView:leftBtn]autorelease];
        
        self.navigationItem.leftBarButtonItem = leftItem;
        
    }
    
    {
        CGRect rect = CGRectMake(0, 0, 50, 30);
        UILabel * lab = [[[UILabel alloc]initWithFrame:rect]autorelease];
        lab.text = @"关于软件";
        lab.textColor = [UIColor whiteColor];
        lab.textAlignment = NSTextAlignmentCenter;
        self.navigationItem.titleView = lab;
    }
    
    [self layoutBaseView];
    
    [self startRequest];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
}


-(void)startRequest
{
    _dataReq = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:@"http://115.159.30.191/water/json?"]];
    
    [_dataReq setPostValue:@"MB" forKey: @"channal"];
    [_dataReq setPostValue:@"BC0009" forKey:@"trancode"];
    
    [_dataReq setDefaultResponseEncoding:NSUTF8StringEncoding];
    _dataReq.delegate = self;
    
    [_dataReq startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"requestFinished");
    
    if(request == _dataReq)
    {
        NSString * str = request.responseString;
        
        NSDictionary * dict = [str objectFromJSONString];
        
        NSLog(@"dict:%@",dict);
        NSLog(@"dict:%@", [[dict objectForKey:@"common"] objectForKey:@"respMsg"]);
        
        NSString * strCode = [[dict objectForKey:@"common"] objectForKey:@"respCode"];
        
        NSLog(@"strCode:%@ ",strCode);
        
        
        if( [strCode isEqualToString:@"00000"] )
        {
            NSDictionary * subDict  = [[dict objectForKey:@"content"] objectForKey:@"infor"];
            
            if( [subDict isKindOfClass:[NSDictionary class]] )
            {
                NSString * body = [subDict objectForKey:@"body"];
                NSString * copyRight = [subDict objectForKey:@"copyright"];
                NSString * support = [subDict objectForKey:@"support"];
                
                [self layoutView:body withCopyRight:copyRight withSupport:support];
            }
            
        }
        
        [_dataReq release];
        _dataReq = nil;
    }
    
}


- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"err =%@", [[request error ] description]);
    
    if(request == _dataReq)
    {
        [self dismissTipView:@"加载失败"];
        
        [_dataReq release];
        _dataReq = nil;
        
    }
}


-(void)dismissTipView:(NSString*)title
{
    [SVProgressHUD showWithStatus:title];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^(void){
        
        sleep(1.0f);
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            [SVProgressHUD dismiss];
        });
    });
}


-(void)layoutBaseView
{

    //
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGRect frame = rect;
    
    
    rect=CGRectMake(0, 0, rect.size.width, rect.size.height - CUSTOM_TAB_BAR_HEIGHT);
    
    UIScrollView * scrView = [[[UIScrollView alloc]initWithFrame:rect]autorelease];
    [self.view addSubview:scrView];
    _scrView = scrView;
    
    //
    rect = CGRectMake(0, 20, 156, 120);
    UIImageView * imgIcon = [[[UIImageView alloc]initWithFrame:rect]autorelease];
    imgIcon.image = [UIImage imageNamed: @"logoo"];
    [scrView addSubview:imgIcon];
    imgIcon.center = CGPointMake(frame.size.width/2.0, imgIcon.center.y);
}


-(void)layoutView:(NSString * )strBody withCopyRight:(NSString*)copyRight withSupport:(NSString*)support
{
 
    CGFloat yPos = 0;
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGRect frame = rect;
    
    //
    yPos += 20+120+ 20;
    rect = CGRectMake(10, yPos, frame.size.width-10*2, 0);
    
    UITextView * textView = [[[UITextView alloc]initWithFrame:rect]autorelease];
    textView.text = strBody;// @"阿斯顿激发健身房 阿里山的减肥；啊解释地方 爱上了对方就阿里山的减肥； 啊；速度了激发；楼上的减肥；啊阿萨德来激发了设计费；阿斯顿减肥";//strBody;
    textView.font = [UIFont systemFontOfSize:15];
    textView.editable = NO;
    
    CGSize textViewSize = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, FLT_MAX)];

    textView.frame = CGRectMake(10, yPos, frame.size.width - 10*2, textViewSize.height);
    textView.backgroundColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:239/255.0f alpha:1];
    textView.layer.cornerRadius = 5;
    textView.textAlignment = NSTextAlignmentCenter;
    textView.layer.masksToBounds = YES;
    
    [_scrView addSubview:textView];
    
    //
    
    yPos += textViewSize.height + 30;
    
    rect =CGRectMake(0, yPos, frame.size.width, 20);
    UILabel * labVer = [[[UILabel alloc]initWithFrame:rect]autorelease];
    labVer.backgroundColor = [UIColor clearColor];
    labVer.text = @"运行版本 V1.0.0";
    labVer.textAlignment = NSTextAlignmentCenter;
    [_scrView addSubview:labVer];
    
    //
    yPos += 20 + 10;
    rect = CGRectMake(0, yPos, 140, 40);
    UIButton * btnCheckVer = [[[UIButton alloc]initWithFrame:rect]autorelease];
    [btnCheckVer setTitle:@"版本检测" forState:UIControlStateNormal];
    [btnCheckVer setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btnCheckVer addTarget:self action:@selector(checkVersion) forControlEvents:UIControlEventTouchUpInside];
    [_scrView addSubview:btnCheckVer];
    
    btnCheckVer.center = CGPointMake(frame.size.width/2.0, btnCheckVer.center.y);
    
    //
    
    yPos += 40 + 20;
    
    rect =CGRectMake(0, yPos, frame.size.width, 20);
    UILabel * cpyRightLab = [[[UILabel alloc]initWithFrame:rect]autorelease];
    cpyRightLab.backgroundColor = [UIColor clearColor];
    cpyRightLab.text = copyRight;
    cpyRightLab.textAlignment = NSTextAlignmentCenter;
    [_scrView addSubview:cpyRightLab];
    
    //
    
    yPos += 20 + 10;
    
    rect =CGRectMake(0, yPos, frame.size.width, 20);
    UILabel * suppLab = [[[UILabel alloc]initWithFrame:rect]autorelease];
    suppLab.backgroundColor = [UIColor clearColor];
    suppLab.text = support;
    suppLab.textAlignment = NSTextAlignmentCenter;
    [_scrView addSubview:suppLab];

    
    //
    yPos += 20+60;
    _scrView.contentSize = CGSizeMake(frame.size.width, yPos);
}


-(void)checkVersion
{
    NSLog(@"checkVersion");
}

-(void)backClicked
{
    [self.navigationController popViewControllerAnimated:YES];
    
    NSDictionary * dict = [NSDictionary dictionaryWithObject:@"0" forKey:HIDE_TAB_BAR_KEY];
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_TAB_BAR_NAME object:nil userInfo:dict];
}


-(void)dealloc
{
    
    [_scrView release];
    
    
    [super dealloc];
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
