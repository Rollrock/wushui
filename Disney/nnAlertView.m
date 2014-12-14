//
//  nnAlertView.m
//  candy
//
//  Created by wanghao on 13-1-28.
//
//

#import "nnAlertView.h"
#import <QuartzCore/QuartzCore.h>


@interface nnAlertView ()
{
	UIImageView* panel;
	UIButton* button1;
	UIButton* button2;
	UILabel* titleLabel;
	UILabel* bodyLabel;
}
-(void) clicked1;
-(void) clicked2;

-(void) haveButton:(int) count;
@end

@implementation nnAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		self.frame = CGRectMake(0, 20, 320, 460);
		
		{
            UIImageView * bgView = [[UIImageView alloc]initWithFrame:self.bounds];
            bgView.image = [UIImage imageNamed:@"bg_alert_view"];
            [self addSubview:bgView];
            [bgView release];
		}
		{
			panel = [[UIImageView alloc] initWithFrame:self.bounds];
			panel.image = [UIImage imageNamed:@"bg_alert_box"];
			panel.userInteractionEnabled = YES;
			[self addSubview:panel];
			[panel release];
			
			{
				titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 16.5, 252, 18)];
				titleLabel.backgroundColor = [UIColor clearColor];
				titleLabel.textAlignment = NSTextAlignmentCenter;
				titleLabel.font = [UIFont systemFontOfSize:17.0 + 1];
				titleLabel.textColor = colorWithRGB(0, 0, 0);
				[panel addSubview:titleLabel];
				[titleLabel release];
			}
			{
				bodyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 46, 252, 28)];
				bodyLabel.backgroundColor = [UIColor clearColor];
				bodyLabel.textAlignment = NSTextAlignmentCenter;
				bodyLabel.font = [UIFont systemFontOfSize:14.0 + 1];
				bodyLabel.textColor = colorWithRGB(0, 0, 0);
				bodyLabel.numberOfLines = 0;
                bodyLabel.lineBreakMode = UILineBreakModeWordWrap;
                
				[panel addSubview:bodyLabel];
				[bodyLabel release];
			}
			{
				button1 = [[UIButton alloc] initWithFrame:CGRectMake(75, 80.5, 100, 40)];
				[button1 setBackgroundImage:[UIImage imageNamed:@"btn_alert_view"] forState:UIControlStateNormal];
				button1.titleLabel.font = [UIFont systemFontOfSize:17.0 + 1];
				[button1 setTitleColor:colorWithRGB(255, 255, 255) forState:UIControlStateNormal];
				[button1 addTarget:self action:@selector(clicked1) forControlEvents:UIControlEventTouchUpInside];
				[panel addSubview:button1];
				[button1 release];
			}
			{
				button2 = [[UIButton alloc] initWithFrame:CGRectMake(75, 80.5, 100, 40)];
				[button2 setBackgroundImage:[UIImage imageNamed:@"btn_alert_view"] forState:UIControlStateNormal];
				button2.titleLabel.font = [UIFont systemFontOfSize:17.0 + 1];
				[button2 setTitleColor:colorWithRGB(255, 255, 255) forState:UIControlStateNormal];
				[button2 addTarget:self action:@selector(clicked2) forControlEvents:UIControlEventTouchUpInside];
				[panel addSubview:button2];
				[button2 release];
			}
		}
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

-(void) show
{
	titleLabel.text = _title;
	bodyLabel.text = _body;
    
    //ajust frame.
    CGSize size = CGSizeMake(panel.width - 40, MAXFLOAT) ;
    size = [bodyLabel.text sizeWithFont:bodyLabel.font constrainedToSize:size];
    bodyLabel.width = size.width ;
    bodyLabel.height = size.height;
    bodyLabel.x_origin = (panel.width - bodyLabel.width)/2 ;
    
    //30 pixel between.
    button1.y_origin = bodyLabel.y_origin + bodyLabel.height + 30 ;
    button2.y_origin = button1.y_origin;
    
    panel.height = button1.y_origin + button1.height + 40;
    
    
    panel.x_origin = ( self.width - panel.width ) /2 ;
    panel.y_origin = ( self.height- panel.height)/2;
    
    
	if([_buttonName1 length] == 0)
	{
		self.buttonName1 = @"确认";
	}
	[button1 setTitle:_buttonName1 forState:UIControlStateNormal];
	if([_buttonName2 length] == 0)
	{
		self.buttonName2 = @"取消";
	}
	[button2 setTitle:_buttonName2 forState:UIControlStateNormal];
	
   
    
	UIWindow* win = [[UIApplication sharedApplication].windows objectAtIndex:0];
	assert(win);
	self.alpha = 0.0;
	[win addSubview:self];
	
	[UIView animateWithDuration:0.3 animations:^() {
		self.alpha = 1.0;
	}];
}

-(void) dismiss
{
	[self removeFromSuperview];
}

-(void) haveButton:(int) count
{
	switch (count)
	{
		case 1:
		{
			button1.hidden = NO;
			button2.hidden = YES;
			button1.frame = CGRectMake(75, 80.5, 100, 40);
            button1.x_origin = (panel.width - button1.width)/2;
			break;
		}
		case 2:
		{
			button1.hidden = NO;
			button2.hidden = NO;
			button1.frame = CGRectMake(20, 80.5, 100, 40);
			button2.frame = CGRectMake(130, 80.5, 100, 40);
			break;
		}
		default:
		{
			break;
		}
	}
}

-(void) clicked1
{
	if(_buttonClickedCode1)
	{
		_buttonClickedCode1();
	}
	
	[self dismiss];
}

-(void) clicked2
{
	if(_buttonClickedCode2)
	{
		_buttonClickedCode2();
	}
	
	[self dismiss];
}

#pragma tools
//button is 'ok'
+(nnAlertView*) pop:(NSString*) title
		   withBody:(NSString*) body
{
	nnAlertView* a = [[nnAlertView alloc] initWithFrame:CGRectZero];
	a.title = title;
	a.body = body;
	a.buttonName1 = @"确认";
	[a haveButton:1];
	[a show];
	return [a autorelease];
}

+(nnAlertView*) pop:(NSString*) title
		   withBody:(NSString*) body
		 withButton:(NSString*) button
{
	nnAlertView* a = [[nnAlertView alloc] initWithFrame:CGRectZero];
	a.title = title;
	a.body = body;
	a.buttonName1 = button;
	[a haveButton:1];
	[a show];
	return [a autorelease];
}

+(nnAlertView*) pop:(NSString*) title
		   withBody:(NSString*) body
		 withButton:(NSString*) button
		   withCode:(void (^)())code
{
	nnAlertView* a = [[nnAlertView alloc] initWithFrame:CGRectZero];
	a.title = title;
	a.body = body;
	a.buttonName1 = button;
	a.buttonClickedCode1 = code;
	[a haveButton:1];
	[a show];
	return [a autorelease];
}

+(nnAlertView*) pop2:(NSString*) title
			withBody:(NSString*) body
		 withButton1:(NSString*) button1
		 withButton2:(NSString*) button2
		   withCode1:(void (^)())code1
		   withCode2:(void (^)())code2
{
	nnAlertView* a = [[nnAlertView alloc] initWithFrame:CGRectZero];
	a.title = title;
	a.body = body;
	a.buttonName1 = button1;
	a.buttonName2 = button2;
	a.buttonClickedCode1 = code1;
	a.buttonClickedCode2 = code2;
	[a haveButton:2];
	[a show];
	return [a autorelease];
}

@end
