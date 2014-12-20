//
//  MainViewController.m
//  Disney
//
//  Created by zhuang chaoxiao on 13-10-21.
//  Copyright (c) 2013年 zhuang chaoxiao. All rights reserved.
//

#import "MainViewController.h"
#import "LocalSaveListViewController.h"
#import "BMKMapView.h"
#import "KxMenu.h"
#import "AboutViewController.h"
#import "ReportViewController.h"
#import "UIImageView+WebCache.h"
#import "ASIFormDataRequest.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"
#import "SDWebImageManager.h"
#import "EGOImageView.h"

@interface MainViewController ()<tabbarViewDelegate,UIScrollViewDelegate,SDWebImageManagerDelegate,EGOImageViewDelegate,NSURLConnectionDelegate>
{
    BMKMapView * _mapView;
    
    UIPageControl *_control;
    UIScrollView *scrollView;
    
    UIImageView * _advImgView;
    
    ASIFormDataRequest * _advReq;
    
    NSString * _webUrl;
    
    UIImageView * _tempImgView;
    
    int _imageCount;
    
    //
    NSMutableArray * _connArray;
    NSMutableArray * _dataArray;
    NSMutableArray * _imgViewArray;
    
}
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.view.backgroundColor = [UIColor whiteColor];
        
        self.imgUrlArray = [[NSMutableArray alloc]initWithCapacity:3];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    CGRect rect;
    
    if( DEVICE_VER_OVER_7 == YES )
    {
        rect = CGRectMake(0,  [[UIScreen mainScreen] bounds].size.height -STATUS_BAR_HEIGHT-CUSTOM_TAB_BAR_HEIGHT, 320, CUSTOM_TAB_BAR_HEIGHT);
    }
    else
    {
        rect = CGRectMake(0,  [[UIScreen mainScreen] bounds].size.height -STATUS_BAR_HEIGHT-CUSTOM_TAB_BAR_HEIGHT-20, 320, CUSTOM_TAB_BAR_HEIGHT);
    }


    //
    _tabbarView = [[tabbarView alloc]initWithFrame:rect];
    
    _tabbarView.delegate = self;
    
    [self.view addSubview:_tabbarView];
    
    [self initSubViewController];
    
    [self.view insertSubview:_firstNav.view belowSubview:_tabbarView];
    
    //
    rect = CGRectMake(0, 0, 320, 480);
    _tempImgView = [[[UIImageView alloc]initWithFrame:rect]autorelease];
    _tempImgView.image = [UIImage imageNamed:@"Default"];
    
    [self.view addSubview:_tempImgView];
}


-(void)updateWelcomeView
{
    NSLog(@"updateWelcomeView");
    
    //
    static BOOL bFlag = NO;
    
    [self initWelcomeView];
    
    //兼容机制   如果下载没有成功  过30秒之后就直接进入界面
    [NSTimer scheduledTimerWithTimeInterval:30.0f target:self selector:@selector(removeWelComeView) userInfo:nil repeats:NO];
    
   // bFlag = YES;
}

-(void)requestAdvData
{
    //[SVProgressHUD showWithStatus:@"加载中，请稍等..."];
    
    NSLog(@"requestAdvData");
    
    AppDelegate * appDel = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    _advReq = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:@"http://115.159.30.191/water/json?"]];
    
    [_advReq setPostValue:@"MB" forKey: @"channal"];
    [_advReq setPostValue:@"BC0006" forKey:@"trancode"];
    [_advReq setPostValue:appDel.userId forKey:@"userId"];
    
    [_advReq setDefaultResponseEncoding:NSUTF8StringEncoding];
    _advReq.delegate = self;
    
    [_advReq startAsynchronous];
}


- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"requestFinished");
    
    if(request == _advReq)
    {
        NSString * str = request.responseString;
        
        NSDictionary * dict = [str objectFromJSONString];
        
        NSLog(@"dict:%@",dict);
        NSLog(@"dict:%@", [[dict objectForKey:@"common"] objectForKey:@"respMsg"]);
        
        NSString * strCode = [[dict objectForKey:@"common"] objectForKey:@"respCode"];
        
        NSLog(@"strCode:%@ ",strCode);
        
        
        if( [strCode isEqualToString:@"00000"] )
        {
            NSArray * array  = [[dict objectForKey:@"content"] objectForKey:@"ads"];
            
            if( [array isKindOfClass:[NSArray class]] )
            {
                NSDictionary * subDict = [array lastObject];
                
                NSString * imgUrl = [subDict objectForKey:@"image"];
                _webUrl = [[subDict objectForKey:@"link"] retain];
                
                [self showAdvView:imgUrl];
                
                NSLog(@"imgUrl:%@--openUrl:%@",imgUrl,_webUrl);
                
                [SVProgressHUD dismiss];
                
                return;
            }
        }
    }
    
}


- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"err =%@", [[request error ] description]);
    
    if(request == _advReq)
    {
        [self dismissTipView:@"加载失败"];
        
        [_advReq release];
        _advReq = nil;
        
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


-(void)showAdvView:(NSString*)imgUrl
{
    #define ADV_HEIGHT   50
    
    CGRect rect = CGRectMake(0, 480-ADV_HEIGHT, 320, ADV_HEIGHT);
    
    if( _advImgView == nil )
    {
        _advImgView = [[UIImageView alloc]initWithFrame:rect];
        _advImgView.backgroundColor = [UIColor blackColor];

        [self.view addSubview:_advImgView];
        
        [_advImgView setImageWithURL:[NSURL URLWithString:imgUrl]];
        
        //
        
        _advImgView.userInteractionEnabled = YES;
        rect = CGRectMake(270, 5, 40, 40);
        UIButton * btn = [[[UIButton alloc]initWithFrame:rect]autorelease];
        btn.backgroundColor = [UIColor whiteColor];
        btn.layer.cornerRadius = 20;
        btn.layer.masksToBounds = YES;
        [_advImgView addSubview:btn];
        [btn addTarget:self action:@selector(hideAdv) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage imageNamed:@"closeAdv"] forState:UIControlStateNormal];
        UITapGestureRecognizer * g = [[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openWeb)]autorelease];
        [_advImgView addGestureRecognizer:g];
    }
}


-(void)openWeb
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_webUrl]];
    
    [self hideAdv];
}


-(void)hideAdv
{
    NSLog(@"hideAdv");
    
    [UIView animateWithDuration:1.5f animations:^(void){
      
        _advImgView.center = CGPointMake(160, 600);
    }];

}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //把每次得到的数据依次放到数组中，这里还可以自己做一些进度条相关的效果
    
    NSLog(@"didReceiveData");
    
    for( int i = 0; i < [_connArray count]; ++ i )
    {
        if( connection == [_connArray objectAtIndex:i] )
        {
            NSMutableData * d = [_dataArray objectAtIndex:i];
            [d appendData:data];
            break;
        }
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError");
    
    [self removeWelComeView];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    for( int i = 0; i < [_connArray count]; ++ i )
    {
        if( connection == [_connArray objectAtIndex:i] )
        {
            UIImage *image = [[UIImage alloc] initWithData:[_dataArray objectAtIndex:i]];
            
            UIImageView * imgView = [_imgViewArray objectAtIndex:i];
            imgView.image = image;
            break;
        }
    }
    
    _imageCount++;
    
    if([self.imgUrlArray count] == _imageCount )
    {
        [_tempImgView removeFromSuperview];
        _tempImgView = nil;
    }
}

-(void)removeWelComeView
{
   static BOOL bFlag = NO;

    
    if( !bFlag )
    {
        NSLog(@"removeWelComeView");
        
        if( scrollView )
        {
            [scrollView removeFromSuperview];
            scrollView = nil;
        }
        
        if( _tempImgView )
        {
            [_tempImgView removeFromSuperview];
            _tempImgView = nil;
        }

        
        
        [self requestAdvData];
        
        bFlag = YES;
    }

}


-(void)initWelcomeView
{
    if( [self.imgUrlArray count] == 0 )
    {
        [self removeWelComeView];
        return;
    }
    
    //
    UIScrollView *uiScrollview = [[[UIScrollView alloc] init]autorelease];
    uiScrollview.frame = self.view.bounds;
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    
    //
    _imgViewArray = [[NSMutableArray alloc]initWithCapacity:1];
    _dataArray = [[NSMutableArray alloc]initWithCapacity:1];
    _connArray = [[NSMutableArray alloc]initWithCapacity:1];
    
    
    for( int i = 0; i < [self.imgUrlArray count]; ++ i )
    {
        NSMutableData * data = [[[NSMutableData alloc]init]autorelease];
        
        [_dataArray addObject:data];
    }
    
    //
    
    [self.view insertSubview:uiScrollview belowSubview:_tempImgView];
    
    for (int i = 0; i < [self.imgUrlArray count]; i++)
    {
        CGRect rect = CGRectMake(i*width, 0, width, height);
        
        UIImageView * imageView = [[[UIImageView alloc] initWithFrame:rect]autorelease];
        [uiScrollview addSubview:imageView];
        [_imgViewArray addObject:imageView];
        
        
        NSURLRequest * req = [NSURLRequest requestWithURL:[NSURL URLWithString:[self.imgUrlArray objectAtIndex:i]]];
        
        NSURLConnection * conn = [[[NSURLConnection alloc] initWithRequest:req delegate:self]autorelease];
        
        [_connArray addObject:conn];
        //
        
        if( i == [self.imgUrlArray count]-1 )
        {
            CGRect rect = CGRectMake(120, 300, 100, 40);
            UIButton * btn = [[[UIButton alloc]initWithFrame:rect]autorelease];
            
            btn.backgroundColor = [UIColor grayColor];
            [btn setTitle:@"点击进入" forState:UIControlStateNormal];
            btn.layer.cornerRadius = 5;
            btn.layer.masksToBounds = YES;
            btn.backgroundColor = [UIColor orangeColor];
            [btn addTarget: self action:@selector(skip) forControlEvents:UIControlEventTouchUpInside];
            imageView.userInteractionEnabled = YES;
            [imageView addSubview:btn];
        }
    }
    
    scrollView = uiScrollview;
    uiScrollview.showsHorizontalScrollIndicator = NO;
    uiScrollview.contentSize = CGSizeMake([self.imgUrlArray count]*width, height);
    uiScrollview.pagingEnabled = YES;
    uiScrollview.backgroundColor = [UIColor redColor];
    uiScrollview.delegate = self;
    
    UIPageControl *control = [[UIPageControl alloc] init];
    control.numberOfPages = [self.imgUrlArray count];
    control.bounds = CGRectMake(0, 0, 200, 50);
    control.center = CGPointMake(width*0.5, height-50);
    control.currentPage = 0;
    _control = control;
    [_control addTarget:self action:@selector(onPointClick) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:control];
}


-(void)skip
{
    
    NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
    [def setObject:_updateDate forKey:@"update"];
    [def synchronize];
    
    //
    [self removeWelComeView];
    
    //
    CGRect rect;
    
    if( DEVICE_VER_OVER_7 == YES )
    {
        rect = CGRectMake(0,  [[UIScreen mainScreen] bounds].size.height -STATUS_BAR_HEIGHT-CUSTOM_TAB_BAR_HEIGHT, 320, CUSTOM_TAB_BAR_HEIGHT);
    }
    else
    {
        rect = CGRectMake(0,  [[UIScreen mainScreen] bounds].size.height -STATUS_BAR_HEIGHT-CUSTOM_TAB_BAR_HEIGHT-20, 320, CUSTOM_TAB_BAR_HEIGHT);
    }
    
    _tabbarView = [[tabbarView alloc]initWithFrame:rect];
    
    _tabbarView.delegate = self;
    
    [self.view addSubview:_tabbarView];
    
    [self initSubViewController];
    
    [self.view insertSubview:_firstNav.view belowSubview:_tabbarView];
    
}

- (void) onPointClick
{
    NSLog(@"onPointClick");
    CGFloat offsetX = _control.currentPage * scrollView.frame.size.width;
    [UIView animateWithDuration:0.3 animations:^{
        scrollView.contentOffset = CGPointMake(offsetX, 0);
    }];
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int pageNum = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    _control.currentPage = pageNum;
}



//我要举报
-(void)gotoReport
{
    ReportViewController * vc = [[[ReportViewController alloc]init]autorelease];
    [_firstNav pushViewController:vc animated:YES];
}

//本地举报列表
-(void)localReportList
{
    LocalSaveListViewController * vc = [[[LocalSaveListViewController alloc]initWithNibName:nil bundle:nil]autorelease];
    [_firstNav pushViewController:vc animated:YES];
}

-(void)showReportMenu
{
    NSArray *menuItems =
    @[
      [KxMenuItem menuItem:@"举报"
                     image:nil
                    target:nil
                    action:NULL],
      
      [KxMenuItem menuItem:@"我要举报"
                     image:[UIImage imageNamed:@"action_icon"]
                    target:self
                    action:@selector(gotoReport)],
      
      [KxMenuItem menuItem:@"本地列表"
                     image:[UIImage imageNamed:@"check_icon"]
                    target:self
                    action:@selector(localReportList)]
      ];
    
    
    KxMenuItem *first = menuItems[0];
    first.foreColor = [UIColor colorWithRed:47/255.0f green:112/255.0f blue:225/255.0f alpha:1.0];
    first.alignment = NSTextAlignmentCenter;
    
    CGRect frame = CGRectMake(280, 20, 20, 20);
    
    [KxMenu showMenuInView:self.view
                  fromRect:frame
                 menuItems:menuItems];
}


-(void)showAboutMenu
{
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:@"菜单"
                     image:nil
                    target:nil
                    action:NULL],
      
      
      [KxMenuItem menuItem:@"关于我们"
                     image:[UIImage imageNamed:@"action_icon"]
                    target:self
                    action:@selector(AboutClicked)],
      
      /*
      [KxMenuItem menuItem:@"备选项目"
                     image:[UIImage imageNamed:@"check_icon"]
                    target:self
                    action:@selector(pushMenuItem:)]
       */
      ];
    
    
    KxMenuItem *first = menuItems[0];
    first.foreColor = [UIColor colorWithRed:47/255.0f green:112/255.0f blue:225/255.0f alpha:1.0];
    first.alignment = NSTextAlignmentCenter;
    
    CGRect frame = CGRectMake(10, 20, 20, 20);
    
    [KxMenu showMenuInView:self.view
                  fromRect:frame
                 menuItems:menuItems];
}

- (void) pushMenuItem:(id)sender
{
    NSLog(@"%@", sender);
}


-(void)AboutClicked
{
    AboutViewController * vc = [[[AboutViewController alloc]init]autorelease];
    //vc.title = @"关于我们";
    [_firstNav pushViewController:vc animated:YES];
}

-(void)layoutFirstNavEx
{
    
    [_firstNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    
    UIButton * leftBtn = [[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 25)]autorelease];
    //[leftBtn addTarget:self action:@selector(AboutClicked) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn addTarget:self action:@selector(showAboutMenu) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"about"] forState:UIControlStateNormal];
    
    UIBarButtonItem * leftItem = [[[UIBarButtonItem alloc]initWithCustomView:leftBtn]autorelease];
    
    _firstViewC.navigationItem.leftBarButtonItem = leftItem;
    
    
    UIButton * rightBtn = [[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 25)]autorelease];
    [rightBtn addTarget:self action:@selector(showReportMenu) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"localsave"] forState:UIControlStateNormal];
    
    UIBarButtonItem * rightItem = [[[UIBarButtonItem alloc]initWithCustomView:rightBtn]autorelease];
    
    _firstViewC.navigationItem.rightBarButtonItem = rightItem;

}

-(void)initSubViewController
{
    _firstViewC = [[FirstViewController alloc]initWithNibName:nil bundle:nil];
    _firstNav = [[UINavigationController alloc]init];
    
    if( DEVICE_VER_OVER_7 == NO )
    {
    _firstNav.view.frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height - CUSTOM_TAB_BAR_HEIGHT - STATUS_BAR_HEIGHT + CUSTOM_TAB_BAR_OFFSET+20);
    }
    
    
    [self layoutFirstNavEx];
   
    [_firstNav pushViewController:_firstViewC animated:NO];
    //
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////
    
    _secondViewC = [[ScoreListViewController alloc]initWithNibName:nil bundle:nil];
    _secondNav = [[UINavigationController alloc]init];
    [_secondNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];

    if( DEVICE_VER_OVER_7 == NO )
    {
        _secondNav.view.frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height - CUSTOM_TAB_BAR_HEIGHT - STATUS_BAR_HEIGHT + CUSTOM_TAB_BAR_OFFSET+20);
    }
    //
    //_secondViewC.title = @"我要评分";
    
    [_secondNav pushViewController:_secondViewC animated:NO];
    ////////////////////////////////////////////////////////////////////////////////////////////////
    

    _thirdViewC = [[ThirdViewController alloc]initWithNibName:nil bundle:nil];
    _thirdNav = [[UINavigationController alloc]init];
    [_thirdNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];

    if( DEVICE_VER_OVER_7 == NO )
    {
        _thirdNav.view.frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height - CUSTOM_TAB_BAR_HEIGHT - STATUS_BAR_HEIGHT + CUSTOM_TAB_BAR_OFFSET+20);
    }
    //_thirdViewC.title = @"富阳视点";
    
    [_thirdNav pushViewController:_thirdViewC animated:NO];
    
    ////////////////////////////////////////////////////////////////////////////////////////////////
    
}



-(void)tabClickIndex:(NSInteger)index
{
    NSLog(@"tabClickIndex:%d",index);
    
    UIView * currView = [[self.view subviews]objectAtIndex:0];
    
    [currView removeFromSuperview];
    
    if( 1 == index )
    {
        [self.view insertSubview:_firstNav.view belowSubview:_tabbarView];
    }
    else if( 2 == index )
    {
        [self.view insertSubview:_secondNav.view belowSubview:_tabbarView];
    }
    else if( 3 == index )
    {
        [self.view insertSubview:_thirdNav.view belowSubview:_tabbarView];
    }
}


-(void)dealloc{
    
    [_tabbarView release];
    
    [_firstViewC release];
    [_secondViewC release];
    [_thirdViewC release];
   
    [_firstNav release];
    [_secondNav release];
    [_thirdNav release];

    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
