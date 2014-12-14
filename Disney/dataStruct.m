#import "dataStruct.h"

#define SetSTR(dict,keypath,property) do \
{ \
	NSString* src = [dict valueForKeyPath:keypath]; \
    if([src isKindOfClass:NSString.class]) { \
	self.property = (src)?src:@""; \
	} else { \
	self.property = @""; \
    }\
} while (0);

#define SETSTRFORDICT(dict, key, property) do \
{ \
	NSString* temp = self.property;\
	if(temp)\
	{\
		[dict setObject:temp forKey:key];\
	}\
	else\
	{\
		[dict setObject:@"" forKey:key];\
	}\
} while (0);


//////////////////////////////////////////////////////////////////////////////
@implementation NewsListInfo

-(void)dealloc
{
    self.image = nil;
    self.title = nil;
    self.desc = nil;
    self.newsid = nil;
    
    [super dealloc];
}

-(void)fromDict:(NSDictionary *)dict
{
    SetSTR(dict, @"image", image);
    SetSTR(dict, @"title", title);
    SetSTR(dict, @"description", desc);
    SetSTR(dict, @"newsid", newsid);
    
    NSLog(@"%@-%@-%@-%@",_newsid,_image,_title,_desc);
}

@end


//////////////////////////////////////////////////////////////////////////////
@implementation ScoreListInfo

-(void)dealloc
{
    self.messageNo = nil;
    self.address = nil;
    self.time = nil;
    self.town = nil;
    self.desc = nil;
    self.name = nil;
    self.phone = nil;
    self.flowNo = nil;
    
    self.imgArray = nil;
    
    [super dealloc];
}


-(void)fromDict:(NSDictionary *)dict
{
    SetSTR(dict, @"messageNo", messageNo);
    SetSTR(dict, @"address", address);
    SetSTR(dict, @"time", time);
    SetSTR(dict, @"town", town);
    
    SetSTR(dict, @"desc", desc);
    SetSTR(dict, @"name", name);
    SetSTR(dict, @"phone", phone);
    SetSTR(dict, @"flowNo", flowNo);
   
    
    self.imgArray = [[[NSMutableArray alloc]init]autorelease];
    
    for( int index = 0; index < 3; ++ index )
    {
        NSData * data = [dict objectForKey:[NSString stringWithFormat:@"image%d",index]];
        
        if( data )
        {
            UIImage * image = [UIImage imageWithData:data];
            [self.imgArray addObject:image];
        }
    }
    
}

@end
//////////////////////////////////////////////////////////////////////////////





//////////////////////////////////////////////////////////////////////////////

