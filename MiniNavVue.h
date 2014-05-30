//
//  MiniNavVue.h
//  MiniNav
//
//  Created by Vincent Chatel on 27/05/2014.
//  Copyright (c) 2014 ProSysIng. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MiniNavVue : UIView <UIWebViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate> {
    
    UIToolbar *vue_bandeau;
    UIBarButtonItem *boutton_home,*boutton_back,*boutton_url,*boutton_forward,*boutton_flex,*boutton_fixed,*boutton_signet,*boutton_ajouter_signet;
    
    UILongPressGestureRecognizer *appui_long;
    
    UIWebView *vue_Web;
    
    BOOL isIpad, isIOS6;
    
    NSURL *url_home,*url_en_cours;
    
    int espaceX, espaceY, alert_number, progression;
    
    UIAlertView *alert_url, *alert_url_home;
    
    UIActionSheet *action_url_home;
    
    UIActivityIndicatorView *activite_en_cours;
    
    NSMutableArray *messignets;
    
    
    
}

-(void) GereLaRotation:(UIInterfaceOrientation) orientation;

@end
