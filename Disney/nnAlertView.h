//
//  nnAlertView.h
//  candy
//
//  Created by wanghao on 13-1-28.
//
//

#import <UIKit/UIKit.h>

@interface nnAlertView : UIView
@property(retain) NSString* title;
@property(retain) NSString* body;
@property(retain) NSString* buttonName1;
@property(retain) NSString* buttonName2;
@property(copy) void (^buttonClickedCode1)();
@property(copy) void (^buttonClickedCode2)();

-(void) show;
-(void) dismiss;

#pragma tools
//button is 'ok'
+(nnAlertView*) pop:(NSString*) title
		   withBody:(NSString*) body;

+(nnAlertView*) pop:(NSString*) title
		   withBody:(NSString*) body
		 withButton:(NSString*) button;

+(nnAlertView*) pop:(NSString*) title
		   withBody:(NSString*) body
		 withButton:(NSString*) button
		   withCode:(void (^)())code;

+(nnAlertView*) pop2:(NSString*) title
			withBody:(NSString*) body
		 withButton1:(NSString*) button1
		 withButton2:(NSString*) button2
		   withCode1:(void (^)())code1
		   withCode2:(void (^)())code2;

@end
