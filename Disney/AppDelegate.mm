//
//  AppDelegate.m
//  Disney
//
//  Created by zhuang chaoxiao on 13-10-21.
//  Copyright (c) 2013年 zhuang chaoxiao. All rights reserved.
//

#import "AppDelegate.h"
#import "ReportViewController.h"



@implementation AppDelegate

- (void)dealloc
{
    [_locMag release];
    
    [_window release];
    [super dealloc];
}


-(void)initLoacation
{
    if( DEVICE_VER_8  )
    {
        _locMag = [[CLLocationManager alloc]init];
        _locMag.delegate = self;
        [_locMag requestAlwaysAuthorization];
        _locMag.desiredAccuracy = kCLLocationAccuracyBest;
        _locMag.distanceFilter = 500.0f;
        [_locMag startUpdatingLocation];

    }
    else if( DEVICE_VER_7 )
    {
         _locMag = [[CLLocationManager alloc]init];
        
        if( [_locMag locationServicesEnabled] )
        {
            _locMag.delegate = self;
            _locMag.desiredAccuracy = kCLLocationAccuracyBest;
            _locMag.distanceFilter = 200.0f;
            [_locMag startUpdatingLocation];
        }
    }
}



-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"change");
    
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if( [_locMag respondsToSelector:@selector(requestAlwaysAuthorization)])
            {
                [_locMag requestWhenInUseAuthorization];
            }
            break;
            
        default:
            break;
    }
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"didUpdateLocations");
    
    CLLocation * location = [locations lastObject];
    
    double dLon = location.coordinate.longitude;
    double dLat = location.coordinate.latitude;
    
    _longitude = dLon;
    _latitude = dLat;
    
    NSLog(@"_longitude:%f _latitude:%f",_longitude,_latitude);
    
}

-(NSString*)getDeviceid
{
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFStringCreateCopy( NULL, uuidString);
    CFRelease(puuid);
    CFRelease(uuidString);
    
    NSLog(@"result:%@",result);
    
    return [result autorelease];
}

-(void)requestData
{
    _dataReq = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:@"http://115.159.30.191/water/json?"]];
    [_dataReq setPostValue:[self getDeviceid] forKey:@"deviceid"];
    [_dataReq setPostValue:@"BC0001" forKey:@"trancode"];
    [_dataReq setPostValue:@"MB" forKey: @"channal"];
    
    _dataReq.delegate = self;
    
    
    [_dataReq startAsynchronous];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    //self.window.backgroundColor = [UIColor whiteColor];
    
    
    [self requestData];
    
    //
    _mapManager = [[BMKMapManager alloc]init];
    
    BOOL ret = [_mapManager start:@"QizVEFjwgndlYN74q2yPdmnY" generalDelegate:self];
    NSLog(@"ret:%d",ret);
    
    self.mainViewController = [[[MainViewController alloc]initWithNibName:nil bundle:nil]autorelease];
    self.window.rootViewController = self.mainViewController;
    
    
    [self initLoacation];
    
    [self.window makeKeyAndVisible];
    
    
    return YES;
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if( request == _dataReq )
    {
        NSString * str = request.responseString;
        
        NSDictionary * dict = [str objectFromJSONString];
        
        
        NSLog(@"----dict:%@",dict);
        
        self.userId = [[[dict objectForKey:@"content"] objectForKey:@"infor"]objectForKey:@"userId"];
        
        self.mainViewController.updateDate = [[[[dict objectForKey:@"content"] objectForKey:@"infor"]objectForKey:@"update"]retain];
        
        NSLog(@"msg:%@",[[dict objectForKey:@"common"] objectForKey:@"respMsg"]);
        
        
        NSArray * array = [[dict objectForKey:@"content"] objectForKey:@"images"];
        
        
        for(NSDictionary * subDict in array )
        {
            if( [subDict isKindOfClass:[NSDictionary class]] )
            {
                NSString * strurl = [subDict objectForKey:@"src"];
                
                [self.mainViewController.imgUrlArray addObject:strurl];
                
                NSLog(@"strUrl:%@",strurl);
            }
        }
        
        [self.mainViewController updateWelcomeView];
        
        
        ///
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    
}

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
