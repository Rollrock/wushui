//
//  AppDelegate.h
//  Disney
//
//  Created by zhuang chaoxiao on 13-10-21.
//  Copyright (c) 2013年 zhuang chaoxiao. All rights reserved.
//

////http://115.159.30.191/water/welcome.jsp


#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "BMKMapManager.h"
#import "ASIFormDataRequest.h"
#import "SVProgressHUD.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate,BMKGeneralDelegate,ASIHTTPRequestDelegate>
{
    CLLocationManager * _locMag;
    
    BMKMapManager * _mapManager;
    
    ASIFormDataRequest * _dataReq;
}

@property(nonatomic,assign) double longitude;
@property(nonatomic,assign) double latitude;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MainViewController * mainViewController;


@property(nonatomic,copy) NSString * userId;


-(NSString*)getDeviceid;


@end
