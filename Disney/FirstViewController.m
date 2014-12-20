//
//  FirstViewController.m
//  Disney
//
//  Created by zhuang chaoxiao on 13-10-24.
//  Copyright (c) 2013年 zhuang chaoxiao. All rights reserved.
//

#import "FirstViewController.h"
#import "JSONKit.h"
#import "SDWebImageManager.h"
#import "dataStruct.h"
#import "BMKMapView.h"
#import "AppDelegate.h"
#import "BMKPointAnnotation.h"
#import "SVProgressHUD.h"


@interface FirstViewController ()<BMKMapViewDelegate>
{
    UIImageView * _bigImgView;
   
    BMKMapView * _mapView;
}

@end

@implementation FirstViewController

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
    else
    {
        //self.view.frame =CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height-CUSTOM_TAB_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-5);
    }
#endif
    
    NSLog(@"!!!!-%f=%f--%f",self.view.frame.origin.y,self.view.frame.size.height,[[UIScreen mainScreen] bounds].size.height);
    
    CGRect rect =  CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height - CUSTOM_TAB_BAR_HEIGHT);

    
    _mapView = [[BMKMapView alloc]initWithFrame:rect];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];

    [_mapView setZoomLevel:13];
    
    CLLocationCoordinate2D location;
    location.latitude = 30.0468;
    location.longitude = 119.9601;
    
    [_mapView setCenterCoordinate:location animated:YES];
    
    //
    rect = CGRectMake(30, 300, 45, 45);
    UIButton * btnLocation = [[UIButton alloc]initWithFrame:rect];
    [btnLocation setBackgroundImage:[UIImage imageNamed:@"btn_location"] forState:UIControlStateNormal];
    [btnLocation addTarget:self action:@selector(locationClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnLocation];
    
    
    [self layoutTitleView];
}


-(void)layoutTitleView
{
    CGRect rect = CGRectMake(0, 0, 100, 30);
    
    UILabel * lab = [[[UILabel alloc]initWithFrame:rect]autorelease];
    lab.text = @"富阳五水共治";
    lab.textColor = [UIColor whiteColor];
    
    self.navigationItem.titleView = lab;
}


-(void)locationClicked
{
    NSLog(@"locationClicked");
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status)
    {
        NSLog(@"定位没有打开");
        
        [SVProgressHUD showWithStatus:@"定位失败，请从系统设置里面允许定位"];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^(void){
            
            sleep(4.5f);
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [SVProgressHUD dismiss];
            });
        });
        
        return;
    }
    
    //_mapView
    
    //_mapView set
    
    AppDelegate * appDel = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    CLLocationCoordinate2D location;
    location.latitude = appDel.latitude;
    location.longitude = appDel.longitude;
    
    [_mapView setCenterCoordinate:location animated:YES];
    
    
    BMKPointAnnotation *ann = [[[BMKPointAnnotation alloc]init]autorelease];
    ann.coordinate = location;
    ann.title = @"当前位置";
    //ann.subtitle = @"上海市浦东新区益江路516弄28幢";
    
    [_mapView addAnnotation:ann];
    [_mapView selectAnnotation:ann animated:YES];
    
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    
    return;
    
    /*
     //longitude
     //左边
     //右边
     
     //latitude
     //上边
     //下边

     左  118.0278   29.1786
     下  121.1110   27.9746
     右  122.8263   30.0527
     上  119.7447   31.0980
     */
    
    CLLocationCoordinate2D coord = [_mapView convertPoint:CGPointMake(0, [[UIScreen mainScreen] bounds].size.height/2) toCoordinateFromView:_mapView];
    
    //NSLog(@"-%f--%f",coord.latitude,coord.longitude);
    //NSLog(@"regionDidChangeAnimated:%f %f-%f",mapView.centerCoordinate.latitude,mapView.centerCoordinate.longitude,mapView.zoomLevel);
    
    if( coord.longitude <= 118.0278 || coord.longitude >= 122.8263 ||
       coord.latitude <= 27.9746 || coord.latitude >= 31.0980)
    {
        CLLocationCoordinate2D location;
        location.latitude = 30.0468;
        location.longitude = 119.9601;
        
        [_mapView setCenterCoordinate:location];
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    
    [super viewWillDisappear:animated];
}



-(void)dealloc
{
    [_scrView release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


























