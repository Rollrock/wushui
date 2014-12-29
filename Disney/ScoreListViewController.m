//
//  SecondViewController.m
//  Disney
//
//  Created by zhuang chaoxiao on 13-10-24.
//  Copyright (c) 2013年 zhuang chaoxiao. All rights reserved.
//

#import "ScoreListViewController.h"
#import "dataStruct.h"
#import "ScoreCellView.h"
#import "ScoreDetailViewController.h"

@interface ScoreListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tabView;
    
    NSMutableArray * _mutArray;
    NSMutableArray * _storeArray;
}
@end

@implementation ScoreListViewController

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

    [self layoutView];
    
    [self loadLocalInfo];
    
    [self layoutTitleView];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
}


-(void)layoutTitleView
{
    CGRect rect = CGRectMake(0, 0, 100, 30);
    
    UILabel * lab = [[[UILabel alloc]initWithFrame:rect]autorelease];
    lab.text = @"我要评分";
    lab.textColor = [UIColor whiteColor];
    lab.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = lab;
}


-(void)layoutView
{
    CGRect rect = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height-CUSTOM_TAB_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-5);

    _tabView = [[UITableView alloc]initWithFrame:rect];
    
    _tabView.delegate = self;
    _tabView.dataSource = self;
    
    [self.view addSubview:_tabView];
}

/*
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScoreDetailViewController * vc = [[[ScoreDetailViewController alloc]init]autorelease];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
 */

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_mutArray count];
}


-(void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
    
    BOOL refresh = [def boolForKey:SCORE_LIST_REFRESH];
    
    NSLog(@"viewWillAppear:%d",refresh);
    
    if( refresh )
    {
        
        [self loadLocalInfo];
        
        //
        [def setBool:NO forKey:SCORE_LIST_REFRESH];
        [def synchronize];
    }
    else
    {
        
    }
    
    
    [super viewWillAppear:animated];
}


//加载本地数据
-(void)loadLocalInfo
{
    [_mutArray removeAllObjects];
    [_storeArray removeAllObjects];
    
    [_mutArray release];
    [_storeArray release];
    
    _mutArray = [[NSMutableArray alloc]initWithCapacity:1];
    _storeArray = [[NSMutableArray alloc]initWithCapacity:1];
    
    NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
    
    NSArray * array  = [[[NSArray alloc]initWithArray:[def objectForKey:REPORT_STORE_SCORE_KEY]]autorelease];
    
    NSLog(@"arrayCount:%d",[array count]);
    
    for( NSDictionary * dict in array )
    {
        if( [dict isKindOfClass:[NSDictionary class]] )
        {
            ScoreListInfo * info = [[[ScoreListInfo alloc]init]autorelease];
            [info fromDict:dict];
            
            [_mutArray addObject:info];
            
            [_storeArray addObject:dict];
        }
    }
    
    [_tabView reloadData];
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
    
    
    ScoreCellView * view = [[[ScoreCellView alloc]initWithFrame:CGRectMake(0, 0, 300, 200) withInfo:[_mutArray objectAtIndex:indexPath.row] withVC:self withRow:indexPath.row withType:SCORE_CELL_VIEW_SCORE] autorelease];

    
    [cell.contentView addSubview:view];
    
    return cell;
}


-(void)lookUpDetailInfo:(int)row
{
    NSLog(@"row:%d",row);
    
    ScoreListInfo * info = [_mutArray objectAtIndex:row];
    
    ScoreDetailViewController * vc = [[[ScoreDetailViewController alloc]init]autorelease];
    vc.info = info;
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
    NSDictionary * dict = [NSDictionary dictionaryWithObject:@"1" forKey:HIDE_TAB_BAR_KEY];
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_TAB_BAR_NAME object:nil userInfo:dict];

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200.0;
}

-(void)dealloc
{
    
    [_tabView release];
    
    [_mutArray removeAllObjects];
    [_mutArray release];
    
    [_storeArray removeAllObjects];
    [_storeArray release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
