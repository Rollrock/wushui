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

@interface MainViewController ()<tabbarViewDelegate>
{
    BMKMapView * _mapView;
}
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.view.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //NSLog(@"%f-%f",[[UIScreen mainScreen] bounds].origin.x,[[UIScreen mainScreen] bounds].origin.y);
    
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
    _secondViewC.title = @"我要评分";
    
    [_secondNav pushViewController:_secondViewC animated:NO];
    ////////////////////////////////////////////////////////////////////////////////////////////////
    

    _thirdViewC = [[ThirdViewController alloc]initWithNibName:nil bundle:nil];
    _thirdNav = [[UINavigationController alloc]init];
    [_thirdNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];

    if( DEVICE_VER_OVER_7 == NO )
    {
        _thirdNav.view.frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height - CUSTOM_TAB_BAR_HEIGHT - STATUS_BAR_HEIGHT + CUSTOM_TAB_BAR_OFFSET+20);
    }
    _thirdViewC.title = @"富阳视点";
    
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
