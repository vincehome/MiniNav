//
//  MiniNavVue.m
//  MiniNav
//
//  Created by Vincent Chatel on 27/05/2014.
//  Copyright (c) 2014 ProSysIng. All rights reserved.
//

#import "MiniNavVue.h"

@implementation MiniNavVue

-(void) dealloc {
    [alert_url release];
    alert_url=nil;
    
    [alert_url_home release];
    alert_url_home=nil;
    
    [action_url_home release];
    action_url_home=nil;
    
    [url_home release];
    [url_en_cours release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
        
        url_home=[[NSURL alloc] initWithString:@"http://www.apple.fr"];
        url_en_cours=[[NSURL alloc] init];
        url_en_cours=url_home;
        messignets=[[NSMutableArray alloc] init];


        
        // détection du device
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            isIpad = YES;
        }
        else {
            isIpad = NO;
        }
        
        // detection de l'os
        if ([[[UIDevice currentDevice] systemVersion] characterAtIndex:0]=='6') {
            isIOS6 = YES;
        }
        else {
            isIOS6 = NO;
        }

        
        
        // installation du fond ici
//        UIImageView *background;
//        if (isIpad) {
//            background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fond-2048x2048.jpg"]];
//        }
//        else{
//            background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fond-1024x1024.jpg"]];
//        }
//        [self addSubview:background];
//        [background release];
        
        
        //creation du bandeau toolbar
        vue_bandeau = [[UIToolbar alloc] init];
        [vue_bandeau sizeToFit];
        
        boutton_home = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(goHome)];
        boutton_back = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(naviguer:)];
        [boutton_back setEnabled:NO];
        boutton_url = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(nouvelle_url)];
        boutton_forward = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(naviguer:)];
        [boutton_forward setEnabled:NO];

        boutton_flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        boutton_signet =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(choisir_signet)];
        boutton_ajouter_signet=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(ajouter_signet)];
        
        
        
        //Creation de l'appui long
        appui_long =[[UILongPressGestureRecognizer alloc] init];
        [appui_long addTarget:self action:@selector(gerer_appui_long)];

        
                
        [vue_bandeau setItems:[[NSMutableArray alloc] initWithObjects:boutton_home,boutton_flex,boutton_back,boutton_url,boutton_forward,boutton_flex,boutton_ajouter_signet,boutton_signet,nil] animated:YES ];
        [self addSubview:vue_bandeau];
        
        
        //attachement de l'appui long au bouton home, il faut l'attacher àla vue du bouton
        [[boutton_home valueForKey:@"view"] addGestureRecognizer:appui_long] ;
        
        [appui_long release];
        [boutton_home release];[boutton_back release];[boutton_url release];[boutton_forward release];[boutton_flex release]; [boutton_signet release];[boutton_ajouter_signet release];
    
        [vue_bandeau release];
        
        //creation de la vue web
        vue_Web=[[UIWebView alloc] init];
        [self addSubview:vue_Web];
        [vue_Web setDelegate:self];
        [vue_Web setScalesPageToFit:YES];
        [vue_Web loadRequest:[[NSURLRequest alloc] initWithURL: url_home]];
        [vue_Web release];
        
        //Creation de la roue de réflexion
        activite_en_cours=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activite_en_cours setHidesWhenStopped:YES];
        
        [self addSubview:activite_en_cours];
        [activite_en_cours release];
        
        
        alert_url=[[UIAlertView alloc] initWithTitle:@"Url" message:@"Entrez l'url" delegate:self cancelButtonTitle:@"Annuler" otherButtonTitles:@"Go", nil];
        [alert_url setAlertViewStyle:UIAlertViewStylePlainTextInput];
        
        alert_url_home=[[UIAlertView alloc] initWithTitle:@"url d'accueil" message:@"Changer l'url d'accueil" delegate:self cancelButtonTitle:@"Annuler" otherButtonTitles:@"Changer", nil];
        [alert_url_home setAlertViewStyle:UIAlertViewStylePlainTextInput];
        
        
        action_url_home=[[UIActionSheet alloc] initWithTitle:@"Signets" delegate:self cancelButtonTitle:@"Annuler" destructiveButtonTitle:nil otherButtonTitles:nil];
        [action_url_home setActionSheetStyle:UIActionSheetStyleAutomatic];
       
       
        //initialisation des signets
        [messignets addObject:url_home];
        int l=[messignets count];
        for (int i=0;i<l;i++) {
            NSString *titre=[NSString stringWithFormat:@"%@",[messignets objectAtIndex:i]] ;
            [action_url_home addButtonWithTitle:titre];
        }
        [self GereLaRotation:[[UIApplication sharedApplication] statusBarOrientation]];
    }
    return self;
}

-(void) gerer_appui_long {
    [alert_url_home show];
}

-(void) ajouter_signet{
    [messignets addObject:url_en_cours];
    NSString *titre=[NSString stringWithFormat:@"%@",url_en_cours] ;
    [action_url_home addButtonWithTitle:titre];
}

-(void) choisir_signet{
    if (isIpad) {
        [action_url_home showFromBarButtonItem:boutton_signet animated:YES];
    }
    else
    {
        [action_url_home showFromToolbar:vue_bandeau];
    }
}


-(void) goHome {
    NSURLRequest *url_request=[[NSURLRequest alloc] initWithURL:url_home];
    [vue_Web loadRequest:url_request];
    [url_request release];
}

-(void) naviguer : (id) sender {
    if (sender == boutton_back) {
        [vue_Web goBack];
    } else {
        [vue_Web goForward] ;
    }
    [self setNeedsDisplay];
}

-(void) nouvelle_url{
    [alert_url show];
}



-(void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (alertView==alert_url) {
        if (buttonIndex==1) {
            NSURL *tmp_url=[[NSURL alloc] initWithString :[[alertView textFieldAtIndex:0] text]];
            NSURLRequest *url_request=[[NSURLRequest alloc] initWithURL:tmp_url];
            [vue_Web loadRequest:url_request];
            [url_request release];
            [tmp_url release];
        }
    }
    if (alertView==alert_url_home) {
        if (buttonIndex==1) {
            [url_home release];
            url_home = [[NSURL alloc] initWithString: [[alertView textFieldAtIndex:0] text]];
        }
    }
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet == action_url_home) {

        NSURLRequest *req=[NSURLRequest requestWithURL:[messignets objectAtIndex:buttonIndex]];
        [vue_Web loadRequest:req];
    }
}


-(void) GereLaRotation: (UIInterfaceOrientation) orientation{

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    espaceX=10;
    
    if (isIOS6) {
        espaceY=4;
    } else {
        espaceY=14;
    }
    
    
    if ((orientation == UIInterfaceOrientationLandscapeLeft) || (orientation == UIInterfaceOrientationLandscapeRight)) {
        //NSLog(@"device paysage");
        
        [self setBounds:CGRectMake(screenRect.origin.x, screenRect.origin.y, screenRect.size.height, screenRect.size.width)];

    } else {
        // NSLog(@"device portrait");
        
        [self setBounds :CGRectMake(screenRect.origin.x, screenRect.origin.y, screenRect.size.width, screenRect.size.height)];
    }
    
    [self GerelAffichage];
    
}

-(void) GerelAffichage {
    [vue_bandeau setFrame:CGRectMake(0, 0, [self bounds].size.width, 46+espaceY)];
    [vue_Web setFrame:CGRectMake(0, [vue_bandeau bounds].size.height-espaceY+5, ([self bounds].size.width), ([self bounds].size.height-50))];
    [vue_Web setScalesPageToFit:YES];
    [activite_en_cours setFrame:CGRectMake(([self bounds].size.width/2)-20, ([self bounds].size.height/2)-20, 40, 40)];

}


// Gestion des erreurs
-(void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
        if ([error code]!=NSURLErrorCancelled) { // évite l'erreur 999
            [[[UIAlertView alloc] initWithTitle:@"Erreur" message:[NSString stringWithFormat:@"%@",[error localizedDescription]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }





-(void) webViewDidStartLoad:(UIWebView *)webView{
    [activite_en_cours startAnimating];
}

-(void) webViewDidFinishLoad:(UIWebView *)webView{
    
    [activite_en_cours stopAnimating];
    [url_en_cours release];
    url_en_cours = [[[vue_Web request] URL] retain] ;
    
    if (![vue_Web canGoForward]) {
        [boutton_forward setEnabled:NO];
    } else {
        [boutton_forward setEnabled:YES];
    }
    if (![vue_Web canGoBack]) {
        [boutton_back setEnabled:NO];
    } else {
        [boutton_back setEnabled:YES];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
