//
//  FirstViewController.m
//  Disney
//
//  Created by zhuang chaoxiao on 13-10-24.
//  Copyright (c) 2013年 zhuang chaoxiao. All rights reserved.
//

#import "ThirdViewController.h"
#import "NewListCell.h"
#import "JSONKit.h"
#import "ASIFormDataRequest.h"
#import "AppDelegate.h"
#import "MyWaitView.h"
#import "SVProgressHUD.h"

#define CELL_HEIGHT 60.0f
#define PER_PANG_NUM  @"10"

#define STR_URL  @"http://115.159.30.191/water/json?"


@interface ThirdViewController ()<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate>
{
    NSMutableArray * _newsArray;
    
    MyWaitView * _waitView;
    
    BOOL  _isLoading;
    
    ASIFormDataRequest * _dataReq;
    
    int _curPage;
}

@end

@implementation ThirdViewController

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
    
    //
    CGRect rect;
    rect = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height-CUSTOM_TAB_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-5);
    
    _tabView = [[UITableView alloc]initWithFrame:rect];
    _tabView.delegate = self;
    _tabView.dataSource = self;
    
    [self.view addSubview:_tabView];
    //
    
    _isLoading = NO;
    
    //
    [self layoutTitleView];
    
    //
    _newsArray = [[NSMutableArray alloc]initWithCapacity:1];
    _curPage = 1;
    [self requestData:[NSString stringWithFormat:@"%d",_curPage]];

    //
    self.view.backgroundColor = [UIColor whiteColor];
}


-(void)layoutTitleView
{
    CGRect rect = CGRectMake(0, 0, 100, 30);
    
    UILabel * lab = [[[UILabel alloc]initWithFrame:rect]autorelease];
    lab.text = @"富阳视点";
    lab.textColor = [UIColor whiteColor];
    
    self.navigationItem.titleView = lab;
}

-(void)requestData:(NSString *)curPage
{
    [SVProgressHUD showWithStatus:@"加载中，请稍等..."];
    
    AppDelegate * appDel = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    _dataReq = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:STR_URL]];
    
    [_dataReq setPostValue:@"MB" forKey: @"channal"];
    [_dataReq setPostValue:[appDel getDeviceid] forKey: @"deviceid"];
    [_dataReq setPostValue:@"BC0007" forKey:@"trancode"];
    [_dataReq setPostValue:appDel.userId forKey:@"userId"];
    [_dataReq setPostValue:curPage forKey:@"page"];
    [_dataReq setPostValue:PER_PANG_NUM forKey:@"pageNum"];
    
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
            NSArray * newsArray = [[dict objectForKey:@"content"] objectForKey:@"news"];
            
            if( [newsArray isKindOfClass:[NSArray class]] )
            {
                for( NSDictionary * subDict in newsArray )
                {
                    NewsListInfo * info = [[[NewsListInfo alloc]init]autorelease];
                    [info fromDict:subDict];
                    
                    [_newsArray addObject:info];
                }
                
                [_tabView reloadData];
                
                //
                [self dismissTipView:@"加载成功~"];
                //
                ++ _curPage;
                
                [_dataReq release];
                _dataReq = nil;
                
                return;
            }
        }
    }
    
    [self dismissTipView:@"加载失败"];
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

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50;
}


-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    CGRect rect = CGRectMake(0, 0, 320, 50);
    UIButton * btn = [[[UIButton alloc]initWithFrame:rect]autorelease];
    btn.backgroundColor = [UIColor lightGrayColor];
    btn.alpha = 0.5;
    [btn setTitle:@"加载更多" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(loadMore) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

-(void)loadMore
{
    NSLog(@"loadMore");
    
    [self requestData:[NSString stringWithFormat:@"%d",_curPage]];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"row:%d",indexPath.row);
    
    NewsDetailViewController * vc = [[NewsDetailViewController alloc]initWithNibName:nil bundle:nil];
    vc.newsid = ((NewsListInfo*)[_newsArray objectAtIndex:indexPath.row]).newsid;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"tableview count:%d",[_newsArray count]);
    return [_newsArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId = @"cellId";
    
    UITableViewCell * cell = (UITableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    if( !cell )
    {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId]autorelease];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
     NewListCell * view = [[[NewListCell alloc]initWithFrame:CGRectMake(0, 0, 300, CELL_HEIGHT) withInfo:[_newsArray objectAtIndex:indexPath.row]]autorelease];

    [cell.contentView addSubview:view];
        
    return cell;
}

/*
-(void)parseData
{
    [_newsArray removeAllObjects];
    
    NSString * filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"tourlist.txt"];
    
    NSString * str = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary * dict = [data objectFromJSONData];
    
    NSArray * array  = [dict objectForKey:@"info"];
    
    for(NSDictionary * subDict in array )
    {
        if( [subDict isKindOfClass:[NSDictionary class]])
        {
            NewsListInfo * info = [[[NewsListInfo alloc]init]autorelease];
            [info fromDict:subDict];
            [_newsArray addObject:info];
        }
    }
    
    [_tabView reloadData];
}
*/


-(void)dealloc
{
    [_tabView release];
    
    [_newsArray removeAllObjects];
    [_newsArray release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


























