//
//  ViewController.m
//  MiniNav
//
//  Created by Vincent Chatel on 27/05/2014.
//  Copyright (c) 2014 ProSysIng. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    MiniNav = [[MiniNavVue alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self setView:MiniNav];
    

    
    
    [MiniNav release];
}

-(BOOL) shouldAutorotate {
    return YES;
}

-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation) InterfaceOrientation duration:(NSTimeInterval)duration{
    [MiniNav GereLaRotation:InterfaceOrientation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
