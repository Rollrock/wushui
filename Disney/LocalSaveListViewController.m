//
//  LocalSaveViewController.m
//  Disney
//
//  Created by zhuang chaoxiao on 14-12-2.
//  Copyright (c) 2014年 zhuang chaoxiao. All rights reserved.
//

#import "LocalSaveListViewController.h"
#import "dataStruct.h"
#import "ScoreCellView.h"
#import "ASIFormDataRequest.h"
#import "AppDelegate.h"

@interface LocalSaveListViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView * _tabView;
    
    NSMutableArray * _mutArray;
    NSMutableArray * _storeArray;
    
    
    ASIFormDataRequest * _dataReq;
}
@end

@implementation LocalSaveListViewController


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
        lab.text = @"本地保存列表";
        lab.textColor = [UIColor whiteColor];
        self.navigationItem.titleView = lab;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
}


-(void)backClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)layoutView
{
    CGRect rect = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height-CUSTOM_TAB_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-5);
    
    _tabView = [[UITableView alloc]initWithFrame:rect];
    
    _tabView.delegate = self;
    _tabView.dataSource = self;
    
    [self.view addSubview:_tabView];

}

//加载本地数据
-(void)loadLocalInfo
{
    _mutArray = [[NSMutableArray alloc]initWithCapacity:1];
    _storeArray = [[NSMutableArray alloc]initWithCapacity:1];
    
    NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
    
    NSArray * array  = [[[NSArray alloc]initWithArray:[def objectForKey:REPORT_STORE_REPORT_KEY]]autorelease];
    
    for( NSDictionary * dict in array )
    {
        if( [dict isKindOfClass:[NSDictionary class]] )
        {
            ScoreListInfo * info = [[[ScoreListInfo alloc]init]autorelease];
            [info fromDict:dict];
            
            //if( [info.infoType isEqualToString:INFO_TYPE_SAVE] )
            {
                [_mutArray addObject:info];
                
                [_storeArray addObject:dict];
            }
        }
    }
    
    [_tabView reloadData];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_mutArray count];
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
    
    ScoreCellView * view = [[[ScoreCellView alloc]initWithFrame:CGRectMake(0, 0, 300, 200) withInfo:[_mutArray objectAtIndex:indexPath.row] withVC:self withRow:indexPath.row withType:SCORE_CELL_VIEW_LOCAL_SAVE] autorelease];
    
    [cell.contentView addSubview:view];
    
    return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200.0;
}


-(void)reportNow:(int)index
{
    NSLog(@"reportNow:%d",index);
    
    AppDelegate * appDel = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    
    ScoreListInfo * info = [_mutArray objectAtIndex:index];
    
    _dataReq = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:@"http://115.159.30.191/water/upload?"]];
    [_dataReq setPostValue:appDel.userId forKey:@"userId"];
    [_dataReq setPostValue:@"BC0002" forKey:@"trancode"];
    [_dataReq setPostValue:@"MB" forKey: @"channal"];
    
    [_dataReq setPostValue:info.address forKey: @"address"];
    [_dataReq setPostValue:info.town forKey: @"town"];
    [_dataReq setPostValue:info.desc forKey: @"description"];
    [_dataReq setPostValue:info.messageNo forKey:@"messagNo"];
    
    [_dataReq setPostValue:info.name forKey: @"user"];
    [_dataReq setPostValue:info.phone forKey: @"phone"];
    _dataReq.tag = index;
    
    for( int index = 0; index < [info.imgArray count]; ++ index )
    {
        UIImage * img = (UIImage * )[info.imgArray objectAtIndex:index];
        
        NSString * strPath = [NSString stringWithFormat:@"%@/report_%d.jpg",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"],index];
        
        NSLog(@"img:%@",img);
        NSLog(@"strPath:%@",strPath);
        
        [self writeImage:img toFileAtPath:strPath];
        
        [_dataReq setFile:strPath forKey:[NSString stringWithFormat:@"images%d",index]];
    }
    
    
    _dataReq.delegate = self;
    
    
    [_dataReq startAsynchronous];
    
    //
    [SVProgressHUD showWithStatus:@"举报中，请稍等....."];
}


-(BOOL)writeImage:(UIImage*)image toFileAtPath:(NSString*)aPath
{
    @try
    {
        NSData *imageData = nil;
        
        NSString *ext = [aPath pathExtension];
        
        if ([ext isEqualToString:@"png"])
        {
            imageData = UIImagePNGRepresentation(image);
        }
        else
        {
            // 0. best, 1. lost. about compress.
            
            imageData = UIImageJPEGRepresentation(image, 1);
        }
        
        if ((imageData == nil) || ([imageData length] <= 0))
            
            return NO;
        
        [imageData writeToFile:aPath atomically:YES];
        
        return YES;
    }
    
    @catch (NSException *e)
    {
        NSLog(@"create thumbnail exception.");
    }
    
    
    return NO;
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
        NSString * flowNo = [[[dict objectForKey:@"content"] objectForKey:@"infor"]objectForKey:@"flowNo"];
        
        NSLog(@"strCode:%@ flowNo:%@",strCode,flowNo);
        
        if( [strCode isEqualToString:@"00000"] )
        {
            //如果举报成功，就从这里删除
            [_mutArray removeObjectAtIndex:_dataReq.tag];
            [_tabView reloadData];
            
            
            {   NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
                NSMutableArray * array  = [[[NSMutableArray alloc]initWithArray:[def objectForKey:REPORT_STORE_SCORE_KEY]]autorelease];
                
                NSMutableDictionary * subDict = [NSMutableDictionary dictionaryWithDictionary:[_storeArray objectAtIndex:_dataReq.tag]];
                [subDict setObject:flowNo forKey:@"flowNo"];
                [array addObject:subDict];
                //[array addObject:[_storeArray objectAtIndex:_dataReq.tag]];
                
                [def setObject:array forKey:REPORT_STORE_SCORE_KEY];
                [def synchronize];
            }
            
            //
            {
                [_storeArray removeObjectAtIndex:_dataReq.tag];
                NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
                [def setObject:_storeArray forKey:REPORT_STORE_REPORT_KEY];
                [def synchronize];
                //
            }
            
            
            [SVProgressHUD showWithStatus:@"举报中成功~"];
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^(void){
                
                sleep(1.0f);
                
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    
                    [self showViewCallback];
                });
            });
        }
        else
        {
            [SVProgressHUD showWithStatus:@"举报失败~"];
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^(void){
                
                sleep(1.0f);
                
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    
                    [SVProgressHUD dismiss];
                });
            });
        }
    }
}


-(void)showViewCallback
{
    [SVProgressHUD dismiss];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"requestFailed:%@",request.error);
    
    
    [SVProgressHUD showWithStatus:@"举报失败，请重新尝试"];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^(void){
        
        sleep(0.5f);
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            [SVProgressHUD dismiss];
        });
    });
}



-(void)deleteNow:(int)index
{
    NSLog(@"deleteNow:%d",index);
    
    UIAlertView * alter = [[[UIAlertView alloc]initWithTitle:@"提示信息" message:@"确定要删除此条信息?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil]autorelease];
    
    alter.tag = index;
    
    [alter show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"alertViewClicked:%d---tagIndex:%d",buttonIndex,alertView.tag);
    
    //确定删除
    if( 1 == buttonIndex )
    {
        [_mutArray removeObjectAtIndex:alertView.tag];
        [_tabView reloadData];
        
        //
        [_storeArray removeObjectAtIndex:alertView.tag];
        NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
        [def setObject:_storeArray forKey:REPORT_STORE_REPORT_KEY];
        [def synchronize];
    }
    //取消
    else if( 0 == buttonIndex )
    {
        
    }
}


-(void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
    
    [super viewWillDisappear:animated];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


