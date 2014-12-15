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
#import "EGORefreshTableHeaderView.h"
#import "ASIFormDataRequest.h"

#import "AppDelegate.h"

#import "MyWaitView.h"

#define CELL_HEIGHT 60.0f

#define STR_URL  @"http://115.159.30.191/water/json?"


@interface ThirdViewController ()<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,ASIHTTPRequestDelegate>
{
    NSMutableArray * _newsArray;
    
    EGORefreshTableHeaderView * _headView;
    MyWaitView * _waitView;
    
    BOOL  _isLoading;
    
    ASIFormDataRequest * _dataReq;
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


-(void)initTestData
{
    
    _newsArray = [[NSMutableArray alloc]initWithCapacity:1];
    
    NSString * filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"news.txt"];
    NSString * strText = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    NSLog(@"strText:%@",strText);
    
    NSDictionary * dict = [strText objectFromJSONString];
    
    if( [dict isKindOfClass:[NSDictionary class]] )
    {
        NSArray * array = [dict objectForKey:@"news"];
        
        for( NSDictionary * subDict in array )
        {
            NewsListInfo * info = [[[NewsListInfo alloc]init]autorelease];
            [info fromDict:subDict];
            
            [_newsArray addObject:info];
        }
    }
    
    
    
    [_tabView reloadData];

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
    
    _isLoading = NO;
    

    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self initTestData];
    
    
    [self requestData];
    
}

-(void)requestData
{
    AppDelegate * appDel = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    
    _dataReq = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:STR_URL]];
    
    [_dataReq setPostValue:@"MB" forKey: @"channal"];
    [_dataReq setPostValue:[appDel getDeviceid] forKey: @"deviceid"];
    [_dataReq setPostValue:@"BC0007" forKey:@"trancode"];
    [_dataReq setPostValue:appDel.userId forKey:@"userId"];
    [_dataReq setPostValue:@"1" forKey:@"page"];
    [_dataReq setPostValue:@"10" forKey:@"pageNum"];
    
    
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
        
        NSLog(@"str:%@",str);
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
    NSLog(@"count:%d",[_newsArray count]);
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


-(void)reloadDataSourceDone
{
    _isLoading = NO;
    
    [_headView egoRefreshScrollViewDataSourceDidFinishedLoading:_tabView];
}

-(void)reloadDataSource
{
    _isLoading = YES;
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_headView egoRefreshScrollViewDidScroll:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_headView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    [self reloadDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    return _isLoading;
}


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


























