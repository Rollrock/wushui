#import <Foundation/Foundation.h>




typedef enum
{
  SCORE_CELL_VIEW_LOCAL_SAVE,
  SCORE_CELL_VIEW_SCORE
}SCORE_CELL_VIEW;

//#define DEVICE_VER_7  ([[[UIDevice currentDevice] systemVersion] floatValue] >=7.0 ? YES:NO)


#define DEVICE_VER    ([[[UIDevice currentDevice] systemVersion] floatValue])

#define DEVICE_VER_7  (((DEVICE_VER >=7.0) && (DEVICE_VER <8.0)) ?YES:NO)
#define DEVICE_VER_8  (((DEVICE_VER >=8.0) && (DEVICE_VER <9.0)) ?YES:NO)
#define DEVICE_VER_OVER_7 ((DEVICE_VER >=7.0)?YES:NO)

#define NAVIGATION_BAR_HEIGHT 44.0f
#define CUSTOM_TAB_BAR_HEIGHT 60.0f
#define CUSTOM_TAB_BAR_OFFSET 11.0f //这里的11是因为中间center与其他四个tabitem的偏移

#define STATUS_BAR_HEIGHT 0.0f


#if TARGET_IPHONE_SIMULATOR
    #define TARGET_IPHONE 0
#elif TARGET_OS_IPHONE
    #define TARGET_IPHONE 1
#endif


#define REPORT_STORE_REPORT_KEY  @"ReportInfo"
#define REPORT_STORE_SCORE_KEY  @"ScoreInfo"



#define INFO_TYPE  @"infoType"
#define INFO_TYPE_SAVE @"save"
#define INFO_TYPE_SCORE @"score"


#define SCORE_LIST_REFRESH  @"score_list_refresh"

//////////////////////////////////////////////////////////////////
@interface NewsListInfo : NSObject

@property(retain) NSString * title;
@property(retain) NSString * desc;
@property(retain) NSString * image;
@property(retain) NSString * newsid;
-(void)fromDict:(NSDictionary*)dict;

@end

//////////////////////////////////////////////////////////////////


@interface ScoreListInfo:NSObject
@property(retain) NSString * messageNo;
@property(retain) NSString * address;
@property(retain) NSString * time;
@property(retain) NSString * town;
@property(retain) NSString * desc;
@property(retain) NSString * name;
@property(retain) NSString * phone;
@property(retain) NSString * flowNo;
@property(retain) NSMutableArray * imgArray;//
-(void)fromDict:(NSDictionary *)dict;
@end



//////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////

