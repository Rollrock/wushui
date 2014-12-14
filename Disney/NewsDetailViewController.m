//
//  TourDetailViewController.m
//  Disney
//
//  Created by zhuang chaoxiao on 13-10-25.
//  Copyright (c) 2013年 zhuang chaoxiao. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "dataStruct.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"


#define STR_URL  @"http://115.159.30.191/water/json?"

@interface NewsDetailViewController ()<ASIHTTPRequestDelegate>
{
    ASIFormDataRequest * _dataReq;
}
@end

@implementation NewsDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
#endif
    
    
    [self requestData];
   
    {
        
        UIButton * leftBtn = [[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 25)]autorelease];
        [leftBtn addTarget:self action:@selector(backClicked) forControlEvents:UIControlEventTouchUpInside];
        [leftBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        
        UIBarButtonItem * leftItem = [[[UIBarButtonItem alloc]initWithCustomView:leftBtn]autorelease];
        
        self.navigationItem.leftBarButtonItem = leftItem;

    }
    
    self.view.backgroundColor = [UIColor whiteColor];
}


-(void)backClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)requestData
{
    _dataReq = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:STR_URL]];
    
    [_dataReq setPostValue:@"BC0008" forKey:@"trancode"];
    [_dataReq setPostValue:_newsid forKey:@"newsid"];
    [_dataReq setPostValue:@"aaaa" forKey:@"userId"];
    
    _dataReq.delegate = self;
    [_dataReq startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"requestFinished");
    
    if(request == _dataReq)
    {
        NSString * str = request.responseString;
        
        NSLog(@"str:%@",str);
        
        NSDictionary * dict =  [str objectFromJSONString];
        
        if( [dict isKindOfClass:[NSDictionary class]] )
        {
            NSString * strTitle = [dict objectForKey:@"title"];
            NSString * strTime = [dict objectForKey:@"time"];
            NSString * strSource = [dict objectForKey:@"source"];
            NSString * strBody = [dict objectForKey:@"body"];
            
            
            [self laytouView:strTitle withTime:strTime withSource:strSource withBody:strBody];
            
        }
    }
    else
    {
    }
    
    /// test
    [self laytouView:nil withTime:nil withSource:nil withBody:nil];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"err =%@", [[request error ] description]);
    
    if(request == _dataReq)
    {
        
    }
}


-(void)laytouView:(NSString*)strTitle withTime:(NSString*)time withSource:(NSString*)source withBody:(NSString*)body
{
    CGFloat yPos = 0;
    CGRect rect;
    
    rect = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height-CUSTOM_TAB_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-5);
    UIScrollView * scrView = [[[UIScrollView alloc]initWithFrame:rect]autorelease];
    [self.view addSubview:scrView];
    
    {
        rect = CGRectMake(10, 15, 300, 20);
        UILabel * lab = [[[UILabel alloc]initWithFrame:rect]autorelease];
        lab.text = strTitle;
        lab.text = @"这里是文章的测试标题";
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:21];
        
        [scrView addSubview:lab];
        
        yPos += 15 + 20 + 5;
    }
    
    {
        rect = CGRectMake(10, yPos, 300, 15);
        UILabel * lab = [[[UILabel alloc]initWithFrame:rect]autorelease];
        lab.text = [NSString stringWithFormat:@"%@  来源:%@",time,source];
        lab.text = [NSString stringWithFormat:@"%@  来源:%@",@"2012-05-15 12:07:50",@"富阳五水共智平台"];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:12];
        
        [scrView addSubview:lab];
        
        yPos += 15 + 5;
    }
    
    {
        rect = CGRectMake(0, yPos, 320, 1);
        
        UIImageView * imgView = [[[UIImageView alloc]initWithFrame:rect]autorelease];
        imgView.image = [UIImage imageNamed:@"news_detail_line"];
        [scrView addSubview:imgView];
    }
    
    //内容
    {
        
    }
    
}



-(void)dealloc
{
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
