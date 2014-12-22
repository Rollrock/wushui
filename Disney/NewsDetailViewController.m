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
#import "AppDelegate.h"


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
    
    NSDictionary * dict = [NSDictionary dictionaryWithObject:@"0" forKey:HIDE_TAB_BAR_KEY];
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_TAB_BAR_NAME object:nil userInfo:dict];

}


-(void)requestData
{
    AppDelegate * appDel = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    _dataReq = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:STR_URL]];
    
    [_dataReq setPostValue:@"MB" forKey: @"channal"];
    [_dataReq setPostValue:@"BC0008" forKey:@"trancode"];
    [_dataReq setPostValue:_newsid forKey:@"newsid"];
    [_dataReq setPostValue:appDel.userId forKey:@"userId"];
    
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
            
            NSDictionary * subDict = [[dict objectForKey:@"content"] objectForKey:@"infor"];
            
            NSString * strTitle = [subDict objectForKey:@"title"];
            NSString * strTime = [subDict objectForKey:@"time"];
            NSString * strSource = [subDict objectForKey:@"source"];
            NSString * strBody = [subDict objectForKey:@"body"];
            
            
            NSLog(@"title:%@  time:%@ source:%@ body:%@",strTitle,strTime,strSource,strBody);
            
            [self laytouView:strTitle withTime:strTime withSource:strSource withBody:strBody];
            
        }
    }
    else
    {
    }
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
        //lab.text = @"这里是文章的测试标题";
        lab.text = strTitle;
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:21];
        
        [scrView addSubview:lab];
        
        yPos += 15 + 20 + 5;
    }
    
    {
        rect = CGRectMake(10, yPos, 300, 16);
        UILabel * lab = [[[UILabel alloc]initWithFrame:rect]autorelease];
        lab.text = [NSString stringWithFormat:@"%@  来源:%@",time,source];
        //lab.text = [NSString stringWithFormat:@"%@  来源:%@",@"2012-05-15 12:07:50",@"富阳五水共智平台"];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:14];
        
        [scrView addSubview:lab];
        
        yPos += 15 + 5;
    }
    
    {
        rect = CGRectMake(0, yPos, 320, 1);
        
        UIImageView * imgView = [[[UIImageView alloc]initWithFrame:rect]autorelease];
        imgView.image = [UIImage imageNamed:@"news_detail_line"];
        [scrView addSubview:imgView];
        
        yPos += 2;
    }
    
    //内容
    {
        rect = CGRectMake(0, yPos, 320, 480-yPos-110);
        UITextView * textView = [[[UITextView alloc]initWithFrame:rect]autorelease];
        textView.font = [UIFont systemFontOfSize:18];
        //textView.text = @"阿斯顿发绝色赌妃；拉大锯撒旦就发；楼上的减肥啊；桑德菲杰啊我二姐夫阿文附近；爱玩客积分阿文附近啊我额积分爱唯欧ijfapoweijfpaijewfaoweijfapwoe飞啊饿剑法哦危机分配安排我饿哦就发泡微积分怕我金额付凹位加法破位将诶反扒奥文件发泡文件发威哦家爱唯欧假发票我耳机发文件噢诶爱唯欧就发我诶减肥跑完iejaweojfaoweijfpawoijef熬阿胶发哦陪我ijepfawejfawejfaowejfpaojwef奥微积分抛丸机而非 啊我阿胶发破位将发票我安排我阿胶发哦微积分怕我金额付奥文件佛啊无金额非怕我饿哦iaowejfpaowjefpawoeij奥文件发哦微积分啊文件发哦陪我iejfpaweaweojfpoawijef啊发破位将佛啊我饥饿法啊我金额富婆啊我金额付啊啊我换个怕我金额帕维";//body;
        textView.text = body;
        [scrView addSubview:textView];
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
