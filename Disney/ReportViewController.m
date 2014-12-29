//
//  ReportViewController.m
//  Disney
//
//  Created by zhuang chaoxiao on 14-12-3.
//  Copyright (c) 2014年 zhuang chaoxiao. All rights reserved.
//

#import "ReportViewController.h"
#import "dataStruct.h"
#import "ASIFormDataRequest.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "BigImageViewController.h"


#define SMALL_PIC_WIDTH  85.0f

@interface ReportViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>
{
    UIScrollView * _scrView;
    
    NSMutableArray * _addrArray;
    NSString * _townStr;
    
    UITextView * _addTextView;
    UITextView * _descTextView;
    UITextView * _nameTextView;
    UITextView * _phoneTextView;
    
    UIImagePickerController * _imgPicker;
    
    NSMutableArray * _photoViewArray;
    NSMutableArray * _photoSmallDelArray;
    NSMutableArray * _photoViewFlagArray;
    
    ASIFormDataRequest * _dataReq;
    ASIFormDataRequest * _townReq;
    
    AppDelegate * _appDel;
    
    CGFloat photoBegY;
    
    
    NSMutableArray * _scoreArray;
    NSUserDefaults * _scoreDef;
    
    UIPickerView * _pickView;
    
}
@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _appDel = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [self initAddrArray];
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height - CUSTOM_TAB_BAR_HEIGHT);
    
    _scrView = [[UIScrollView alloc]initWithFrame:frame];
    _scrView.backgroundColor = [UIColor whiteColor];
    _scrView.delegate = self;
    
    
    [self addTapGesture];
    
    [self.view addSubview:_scrView];
    
    [self layoutSubView];
    
    [self sendTownReq];
    
    //
    _photoViewArray = [[NSMutableArray alloc]initWithCapacity:3];
    _photoSmallDelArray = [[NSMutableArray alloc]initWithCapacity:3];
    
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
        lab.text = @"我要举报";
        lab.textColor = [UIColor whiteColor];
        lab.textAlignment = NSTextAlignmentCenter;
        self.navigationItem.titleView = lab;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
}


-(void)sendTownReq
{
    _townReq = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:@"http://115.159.30.191/water/json?"]];
    [_townReq setPostValue:_appDel.userId forKey:@"userId"];
    [_townReq setPostValue:@"BC0010" forKey:@"trancode"];
    [_townReq setPostValue:@"MB" forKey: @"channal"];
    
    _townReq.delegate = self;
    
    [_townReq startAsynchronous];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //[self hideKeybrd];
}


-(void)backClicked
{
    [self.navigationController popViewControllerAnimated:YES];
    
    
    NSDictionary * dict = [NSDictionary dictionaryWithObject:@"0" forKey:HIDE_TAB_BAR_KEY];
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_TAB_BAR_NAME object:nil userInfo:dict];

}


-(void)addTapGesture
{
    UITapGestureRecognizer * g = [[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeybrd)]autorelease];
    
    [_scrView addGestureRecognizer:g];
}

-(void)hideKeybrd
{
    for(UIView * subView in [_scrView subviews] )
    {
        if( [subView isKindOfClass:[UITextView class]] )
        {
            [subView resignFirstResponder];
        }
    }
}

-(void)initAddrArray
{
    //_addrArray = [[NSMutableArray alloc]initWithArray:@[@"下沙街道",@"张江高科玉兰香苑",@"孙桥智金元",@"金大元唐人社区"]];
    
    _addrArray = [[NSMutableArray alloc]initWithCapacity:1];
    
    //_townStr = [_addrArray objectAtIndex:0];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_addrArray count];
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_addrArray objectAtIndex:row];
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"selected:%@",[_addrArray objectAtIndex:row]);
    
    _townStr = [_addrArray objectAtIndex:row];
}

-(UIColor*)commonBackColor
{
    return [UIColor colorWithRed:239/255.0f green:239/255.0f blue:239/255.0f alpha:1];
}

-(void)layoutSubView
{
    CGFloat yPos = 0;
    CGRect rect;
    
    {
        rect = CGRectMake(20, 0, 280, 30);
        
        UILabel * lab = [[UILabel alloc]initWithFrame:rect];
        lab.text = @"所属街道/乡镇";
        lab.font = [UIFont systemFontOfSize:20];
        [_scrView addSubview:lab];
        [lab release];
        
        yPos += 30+10;
    }
    
    {
        rect = CGRectMake(20, yPos, 280, 10);
        _pickView = [[UIPickerView alloc]initWithFrame:rect];
        _pickView.delegate = self;
        _pickView.dataSource = self;
        _pickView.layer.cornerRadius = 10;
        _pickView.layer.masksToBounds = YES;
        _pickView.backgroundColor = [self commonBackColor];//[UIColor lightGrayColor];
        
        [_scrView addSubview:_pickView];
        [_pickView release];
        
        yPos += _pickView.frame.size.height + 15;
    }
    
    ////////////////////////////////////////////////////////////////////////////////
    {
        rect = CGRectMake(20, yPos, 280, 30);
        
        UILabel * lab = [[UILabel alloc]initWithFrame:rect];
        lab.text = @"具体地址";
        lab.font = [UIFont systemFontOfSize:20];
        [_scrView addSubview:lab];
        [lab release];
        
        yPos += 30 + 3;
    }
    
    {
        rect = CGRectMake(20, yPos, 280, 40);
        
        _addTextView = [[UITextView alloc]initWithFrame:rect];
        _addTextView.backgroundColor = [self commonBackColor];//[UIColor lightGrayColor];
        _addTextView.font = [UIFont systemFontOfSize:20];
        _addTextView.layer.cornerRadius = 8;
        _addTextView.delegate = self;
        
        [_scrView addSubview:_addTextView];
        
        yPos += 40 + 10;
    }
    
    //////////////////////////////////////////////////////////////////
    {
        rect = CGRectMake(20, yPos, 280, 30);
        
        UILabel * lab = [[UILabel alloc]initWithFrame:rect];
        lab.text = @"问题描述";
        lab.font = [UIFont systemFontOfSize:20];
        [_scrView addSubview:lab];
        [lab release];
        
        yPos += 30 + 3;
    }
    
    {
        rect = CGRectMake(20, yPos, 280, 120);
        
        _descTextView = [[UITextView alloc]initWithFrame:rect];
        _descTextView.backgroundColor = [self commonBackColor];//[UIColor lightGrayColor];
        _descTextView.layer.cornerRadius = 8;
        _descTextView.font = [UIFont systemFontOfSize:20];
        _descTextView.delegate = self;
        [_scrView addSubview:_descTextView];
        
        yPos += 120 + 10;
    }
    
    //////////////////////////////////////////////////////////////////
    {
        rect = CGRectMake(20, yPos, 280, 30);
        
        UILabel * lab = [[UILabel alloc]initWithFrame:rect];
        lab.text = @"举报人姓名";
        lab.font = [UIFont systemFontOfSize:20];
        [_scrView addSubview:lab];
        [lab release];
        
        yPos += 30 + 3;
    }
    
    {
        rect = CGRectMake(20, yPos, 280, 40);
        
        _nameTextView = [[UITextView alloc]initWithFrame:rect];
        _nameTextView.backgroundColor = [self commonBackColor];//[UIColor lightGrayColor];
        _nameTextView.layer.cornerRadius = 8;
        _nameTextView.delegate = self;
        _nameTextView.font = [UIFont systemFontOfSize:20];
        
        [_scrView addSubview:_nameTextView];
        
        yPos += 40 + 10;
    }

    //////////////////////////////////////////////////////////////////
    {
        rect = CGRectMake(20, yPos, 280, 30);
        
        UILabel * lab = [[UILabel alloc]initWithFrame:rect];
        lab.text = @"举报人电话";
        lab.font = [UIFont systemFontOfSize:20];
        [_scrView addSubview:lab];
        [lab release];
        
        yPos += 30 + 5;
    }
    
    {
        rect = CGRectMake(20, yPos, 280, 40);
        
        _phoneTextView = [[UITextView alloc]initWithFrame:rect];
        _phoneTextView.backgroundColor = [self commonBackColor];//[UIColor lightGrayColor];
        _phoneTextView.layer.cornerRadius = 8;
        _phoneTextView.delegate = self;
        _phoneTextView.font = [UIFont systemFontOfSize:20];
        _phoneTextView.keyboardType = UIKeyboardTypePhonePad;
        
        [_scrView addSubview:_phoneTextView];
        
        yPos += 40 + 10;
    }
    
    
    //////////////////////////////////////////////////////////////////
    {
        
        rect = CGRectMake(20, yPos+10, 280, 30);
        
        UILabel * lab = [[UILabel alloc]initWithFrame:rect];
        lab.text = @"拍摄现场照片";
        lab.font = [UIFont systemFontOfSize:20];
        [_scrView addSubview:lab];
        [lab release];
    
    }

    
    {
        rect = CGRectMake(150, yPos+2, 45, 45);
        UIButton * btn = [[UIButton alloc]initWithFrame:rect];
        [btn setBackgroundImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
        [_scrView addSubview:btn];
        
        
        yPos += 40 + 10;
    }
    
    
    photoBegY = yPos + 20;
    /*
    {
        #define IMAGE_VIEW_WIDTH  80
        
        _photoViewArray = [[NSMutableArray alloc]initWithCapacity:3];
        _photoViewFlagArray = [[NSMutableArray alloc]initWithCapacity:3];
        
        for( int i = 0; i < 3; ++ i )
        {
            rect = CGRectMake(20 + (IMAGE_VIEW_WIDTH+20)*i, yPos, IMAGE_VIEW_WIDTH, IMAGE_VIEW_WIDTH);
            
            UIImageView * imgView = [[UIImageView alloc]initWithFrame:rect];
            imgView.image = [UIImage imageNamed:@"noPhoto"];
            imgView.layer.cornerRadius = 5;
            imgView.layer.masksToBounds = YES;
            [_scrView addSubview:imgView];
            
            [_photoViewArray addObject:imgView];
            [_photoViewFlagArray addObject:@"0"];//0表示不是拍摄的照片
            
            //
            imgView.tag = i;
            UITapGestureRecognizer * g = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageClicked:)];
            imgView.userInteractionEnabled = YES;
            [imgView addGestureRecognizer:g];
        }
        
        yPos += 80 + 10;
    }
     */
    for( int count = 0; count < 3; ++ count )
    {
        CGRect rect = CGRectMake(25+count*(SMALL_PIC_WIDTH+10), photoBegY, SMALL_PIC_WIDTH,SMALL_PIC_WIDTH);
        UIImageView * imgView = [[[UIImageView alloc]initWithFrame:rect]autorelease];
        imgView.image = [UIImage imageNamed:@"noPhoto"];
        [_scrView addSubview:imgView];
    }
    
    
    yPos += SMALL_PIC_WIDTH + 35;
    
    
    {
        {
            rect = CGRectMake(10, yPos, 140, 40);
            UIButton * btn = [[UIButton alloc]initWithFrame:rect];
            [btn setBackgroundImage:[UIImage imageNamed:@"report_save_local"] forState:UIControlStateNormal];
           /* btn.backgroundColor = [UIColor colorWithRed:132/255.0f green:209/255.0f blue:193/255.0f alpha:1.0];
            btn.layer.cornerRadius = 5;
            btn.layer.masksToBounds = YES;
            btn.layer.borderColor = [UIColor colorWithRed:132/255.0f green:209/255.0f blue:193/255.0f alpha:1.0].CGColor;//[UIColor grayColor].CGColor;
            btn.layer.borderWidth = 1;
            */
            [btn addTarget:self action:@selector(ReportSaveLocal) forControlEvents:UIControlEventTouchUpInside];
            [_scrView addSubview:btn];

        }
        
        {
            rect = CGRectMake(160, yPos, 150, 40);
            UIButton * btn = [[UIButton alloc]initWithFrame:rect];
            [btn setBackgroundImage:[UIImage imageNamed:@"report_now"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(ReportNow) forControlEvents:UIControlEventTouchUpInside];
            /*
             btn.backgroundColor = [UIColor colorWithRed:132/255.0f green:209/255.0f blue:193/255.0f alpha:1.0];
            btn.layer.cornerRadius = 5;
            btn.layer.masksToBounds = YES;
            btn.layer.borderColor = [UIColor colorWithRed:132/255.0f green:209/255.0f blue:193/255.0f alpha:1.0].CGColor;//[UIColor grayColor].CGColor;
            btn.layer.borderWidth = 1;
             */
            [_scrView addSubview:btn];
            
        }
        
    }
    
    //////////////////////////////////////////////////////////////////
    yPos += 100;
    
    _scrView.contentSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width, yPos);
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    CGPoint pt ;//= _scrView.contentOffset;
    
    pt = CGPointMake(_scrView.contentOffset.x, textView.frame.origin.y-CUSTOM_TAB_BAR_HEIGHT);
    
    [UIView animateWithDuration:0.35 animations:^(void){
        _scrView.contentOffset = pt;
    }];
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if( [text isEqualToString:@"\n"] )
    {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}


-(BOOL)checkDataValid
{
    if( _addTextView.text.length <= 0  ||
       _descTextView.text.length <= 0 ||
       _phoneTextView.text.length <= 0 ||
       _nameTextView.text.length <= 0 )
    {
        [SVProgressHUD showWithStatus:@"请将信息填写完整~~"];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^(void){
            
            sleep(1.5f);
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                
                [SVProgressHUD dismiss];
            });
        });

        
        return NO;
    }
    
    return YES;
}



//保存本地
-(void)ReportSaveLocal
{
    if( ![self checkDataValid ] )
    {
        return;
    }
    
    //
    //
    NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray * array = [[[NSMutableArray alloc]initWithArray:[def objectForKey:REPORT_STORE_REPORT_KEY]]autorelease];
    
    //
    NSMutableDictionary * dict = [[[NSMutableDictionary alloc]init]autorelease];
    
    [dict setObject:_townStr forKey:@"town"];
    [dict setObject:_addTextView.text forKey:@"address"];
    [dict setObject:_descTextView.text forKey:@"desc"];
    [dict setObject:_nameTextView.text forKey:@"name"];
    [dict setObject:_phoneTextView.text forKey:@"phone"];
    [dict setObject:[self getCurrentMeesageNo] forKey:@"messageNo"];
    [dict setObject:[self getCurrentTime] forKey:@"time"];
    
    //  image
    for( int index = 0; index < [_photoViewArray count]; ++ index )
    {
        NSString * strPath = [NSString stringWithFormat:@"%@/report_%d.jpg",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"],index];
        
        NSLog(@"strPath:%@",strPath);
        
        UIImageView * imgView = (UIImageView*)[_photoViewArray objectAtIndex:index];
        //
        UIImage * targetImage = [self imageByScalingToSize:CGSizeMake(320*0.5, 480*0.5) withSource:imgView.image];
        
        NSData * imageData = UIImageJPEGRepresentation(targetImage, 1);
        [dict setObject:imageData forKey:[NSString stringWithFormat:@"image%d",index]];
    }
    
    
    [array addObject:dict];
    
    
    [def setObject:array forKey:REPORT_STORE_REPORT_KEY];
    
    [def synchronize];

   
    //
    
    [SVProgressHUD showWithStatus:@"保存成功~"];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^(void){

        sleep(1.5f);
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            [self showViewCallback];
        });
        
    });
}

-(void)showViewCallback
{
    [SVProgressHUD dismiss];
    
    [self backClicked];
    
}

//立即上报
-(void)ReportNow
{
    if( ![self checkDataValid ] )
    {
        return;
    }
    
    _dataReq = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:@"http://115.159.30.191/water/upload?"]];
    [_dataReq setPostValue:_appDel.userId forKey:@"userId"];
    [_dataReq setPostValue:@"BC0002" forKey:@"trancode"];
    [_dataReq setPostValue:@"MB" forKey: @"channal"];
    
    [_dataReq setPostValue:_addTextView.text forKey: @"address"];
    [_dataReq setPostValue:_townStr forKey: @"town"];
    [_dataReq setPostValue:_descTextView.text forKey: @"description"];
    [_dataReq setPostValue:[self getCurrentMeesageNo] forKey:@"messagNo"];
    
    
    [_dataReq setPostValue:_nameTextView.text forKey: @"user"];
    [_dataReq setPostValue:_phoneTextView.text forKey: @"phone"];
    
    
    for( int index = 0; index < [_photoViewArray count]; ++ index )
    {
        NSString * strPath = [NSString stringWithFormat:@"%@/report_%d.jpg",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"],index];
        
        NSLog(@"strPath:%@",strPath);
        
        UIImageView * imgView = (UIImageView*)[_photoViewArray objectAtIndex:index];
        //
        UIImage * targetImage = [self imageByScalingToSize:CGSizeMake(320*0.5, 480*0.5) withSource:imgView.image];
        [self writeImage:targetImage toFileAtPath:strPath];
        
        [_dataReq setFile:strPath forKey:[NSString stringWithFormat:@"images%d",index]];
    }
    
    _dataReq.delegate = self;
    [_dataReq startAsynchronous];
    
    //
    [SVProgressHUD showWithStatus:@"举报中,请稍等..."];
    
    //
    _scoreDef = nil;
    [_scoreArray removeAllObjects];
    _scoreArray = nil;
    
    
    _scoreDef = [NSUserDefaults standardUserDefaults];
    
    _scoreArray = [[NSMutableArray alloc]initWithArray:[_scoreDef objectForKey:REPORT_STORE_SCORE_KEY]];
    
    //
    NSMutableDictionary * dict = [[[NSMutableDictionary alloc]init]autorelease];
    
    [dict setObject:_townStr forKey:@"town"];
    [dict setObject:_addTextView.text forKey:@"address"];
    [dict setObject:_descTextView.text forKey:@"desc"];
    [dict setObject:_nameTextView.text forKey:@"name"];
    [dict setObject:_phoneTextView.text forKey:@"phone"];
    [dict setObject:[self getCurrentMeesageNo] forKey:@"messageNo"];
    [dict setObject:[self getCurrentTime] forKey:@"time"];
    
    //  image
    
    for( int index = 0; index < [_photoViewArray count]; ++ index )
    {
        NSString * strPath = [NSString stringWithFormat:@"%@/report_%d.jpg",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"],index];
        
        NSLog(@"strPath:%@",strPath);
        
        UIImageView * imgView = (UIImageView*)[_photoViewArray objectAtIndex:index];
        //
        UIImage * targetImage = [self imageByScalingToSize:CGSizeMake(320*0.5, 480*0.5) withSource:imgView.image];
        
        NSData * imageData = UIImageJPEGRepresentation(targetImage, 1);
        [dict setObject:imageData forKey:[NSString stringWithFormat:@"image%d",index]];
    }
    
    [_scoreArray addObject:dict];
    
}


- (UIImage *)imageByScalingToSize:(CGSize)targetSize  withSource:(UIImage*)sourceImage
{
    //UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor < heightFactor)
        {
            scaleFactor = widthFactor;
        }
        else
        {
            scaleFactor = heightFactor;
        }
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor < heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor > heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil)
    {
        NSLog(@"could not scale image");
    }
    
    return newImage ;
}


-(NSString*)getCurrentTime
{
    NSDate *now = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    int year = [dateComponent year];
    int month = [dateComponent month];
    int day = [dateComponent day];
    int hour = [dateComponent hour];
    int minute = [dateComponent minute];
    int second = [dateComponent second];
    
    NSString * str = [NSString stringWithFormat:@"%d-%d-%d %d:%d:%d",year,month,day,hour,minute,second];
    
    return str;
}


-(NSString*)getCurrentMeesageNo
{
    NSDate *now = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    int year = [dateComponent year];
    int month = [dateComponent month];
    int day = [dateComponent day];
    int hour = [dateComponent hour];
    int minute = [dateComponent minute];
    int second = [dateComponent second];
    
    NSString * str = [NSString stringWithFormat:@"%04d%02d%02d%02d%02d%02d",year,month,day,hour,minute,second];
    
    return str;
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
            
            NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
            [def setBool:YES forKey:SCORE_LIST_REFRESH];
            [def synchronize];
            
            //
            NSMutableDictionary * dict = [_scoreArray lastObject];
            [dict setObject:flowNo forKey:@"flowNo"];
            [_scoreDef setObject:_scoreArray forKey:REPORT_STORE_SCORE_KEY];
            [_scoreDef synchronize];
            
            //
            [SVProgressHUD showWithStatus:@"举报成功"];
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^(void){
                
                sleep(1.5f);
                
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    
                    [self showViewCallback];
                });
            });
        }
    }
    else if(request == _townReq )
    {
        NSString * str = request.responseString;
        
        NSDictionary * dict = [str objectFromJSONString];
        NSLog(@"dict:%@",dict);
        //NSLog(@"dict:%@", [[dict objectForKey:@"common"] objectForKey:@"respMsg"]);
        
        NSString * strCode = [[dict objectForKey:@"common"] objectForKey:@"respCode"];
        
        NSLog(@"strCode:%@ ",strCode);
        
        if( [strCode isEqualToString:@"00000"] )
        {
            NSArray * array = [[dict objectForKey:@"content"] objectForKey:@"towns"];
            
            for( NSDictionary * subDict in array )
            {
                if( [subDict isKindOfClass:[NSDictionary class]])
                {
                    NSString * str = [subDict objectForKey:@"name"];
                    
                    [_addrArray addObject: str];
                }
            }
            
            _townStr = [_addrArray objectAtIndex:0];
            
            [_pickView reloadAllComponents];
        }

    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"requestFailed:%@",request.error);
    
    //
    [SVProgressHUD showWithStatus:@"举报失败，请重新举报一次，谢谢~"];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^(void){
        
        sleep(1.5f);
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [SVProgressHUD dismiss];
        });
    });

}


-(void)imageClicked:(UITapGestureRecognizer*)g
{
    NSLog(@"g.tag:%d---%@",g.view.tag,[self.parentViewController class]);
    
    UIImageView * imageView = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)]autorelease];
    
    imageView.image = ((UIImageView*)g.view).image;
    
    [self.parentViewController.view.superview addSubview:imageView];
    
    UITapGestureRecognizer * gg = [[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeBigImage:)]autorelease];
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:gg];
}


-(void)closeBigImage:(UITapGestureRecognizer*)g
{
    [g.view removeFromSuperview];
}

-(void)takePhoto
{
    _imgPicker = nil;
    
    _imgPicker = [[[UIImagePickerController alloc]init]autorelease];
    _imgPicker.delegate = self;
    _imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    
    //[self presentViewController:_imgPicker animated:YES completion:nil];
     [self.view.window.rootViewController presentViewController:_imgPicker animated:YES completion:nil];
    
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (picker == _imgPicker)
    {
         UIImage* original_image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        int count = [_photoViewArray count];
        
        if( count < 3 )
        {
            CGRect rect = CGRectMake(25+count*(SMALL_PIC_WIDTH+10), photoBegY, SMALL_PIC_WIDTH,SMALL_PIC_WIDTH);
            
            UIImageView * imgView = [[[UIImageView alloc]initWithFrame:rect]autorelease];
            imgView.image = original_image;
            imgView.tag = count;
            imgView.layer.cornerRadius = 5;
            imgView.layer.masksToBounds = YES;
            
            imgView.userInteractionEnabled = YES;
            
            UITapGestureRecognizer * g = [[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageClicked:)]autorelease];
            [imgView addGestureRecognizer:g];
            
            [_scrView addSubview:imgView];
            
            [_photoViewArray addObject:imgView];
            
            //
            rect = imgView.frame;
            
            rect = CGRectMake(rect.origin.x + rect.size.width-15, rect.origin.y-15, 25, 25);
            UIButton * btn = [[UIButton alloc]initWithFrame:rect];
            btn.tag = imgView.tag;
            [btn setBackgroundImage:[UIImage imageNamed:@"delImage"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(delImageClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_scrView addSubview:btn];
            
            [_photoSmallDelArray addObject:btn];
        }
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
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
            imageData = UIImageJPEGRepresentation(image, 1);
        }

        if ((imageData == nil) || ([imageData length] <= 0))
        {
            return NO;
        }
        
        [imageData writeToFile:aPath atomically:YES];
        
        return YES;
    }
    
    @catch (NSException *e)
    {
        NSLog(@"create thumbnail exception.");
    }

    return NO;
}


//删除小图片
-(void)delImageClicked:(UIButton*)btn
{
    NSLog(@"btn Tag:%d",btn.tag);
    
    UIImageView * imgView = (UIImageView*)[_photoViewArray objectAtIndex:btn.tag];
    [imgView removeFromSuperview];
    [_photoViewArray removeObjectAtIndex:btn.tag];
    
    UIButton * btnSmall = (UIButton*)[_photoSmallDelArray objectAtIndex:btn.tag];
    [btnSmall removeFromSuperview];
    [_photoSmallDelArray removeObjectAtIndex:btn.tag];
    
    for( int index = 0; index < [_photoViewArray count]; ++ index )
    {
        CGRect rect = CGRectMake(25+index*(SMALL_PIC_WIDTH+10), photoBegY, SMALL_PIC_WIDTH,SMALL_PIC_WIDTH);
        
        UIImageView * imgView = (UIImageView *)[_photoViewArray objectAtIndex:index];
        imgView.frame = rect;
        imgView.tag = index;
        
        rect = imgView.frame;
        rect = CGRectMake(rect.origin.x + rect.size.width-15, rect.origin.y-15, 25, 25);
        UIButton * btn = (UIButton*)[_photoSmallDelArray objectAtIndex:index];
        btn.frame = rect;
        btn.tag = imgView.tag;
        
    }
}


-(void)dealloc
{
    [_scrView release];
    
    [_addrArray removeAllObjects];
    [_addrArray release];
    
    [_addTextView release];
    [_descTextView release];
    [_nameTextView release];
    [_phoneTextView release];
   
    
    [_photoViewArray removeAllObjects];
    [_photoViewArray release];
    
    [_photoSmallDelArray removeAllObjects];
    [_photoSmallDelArray release];
    
    [_photoViewFlagArray removeAllObjects];
    [_photoViewFlagArray release];
    
    
    [_scoreArray removeAllObjects];
    [_scoreArray release];
    
    
    [_pickView release];

    
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
