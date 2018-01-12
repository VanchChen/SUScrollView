//
//  ViewController.m
//  AdventureScrollView
//
//  Created by 陈文琦 on 2018/1/12.
//  Copyright © 2018年 vanch. All rights reserved.
//

#import "ViewController.h"

#import "SUScrollView.h"

@interface ViewController ()

@property (nonatomic, strong) SUScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    _scrollView = [[SUScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //_scrollView.bounces = NO;
    _scrollView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_scrollView];
    
    UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    testView.backgroundColor = [UIColor redColor];
    [_scrollView addSubview:testView];
    
    testView = [[UIView alloc] initWithFrame:CGRectMake(100, 300, 100, 100)];
    testView.backgroundColor = [UIColor greenColor];
    [_scrollView addSubview:testView];
    
    testView = [[UIView alloc] initWithFrame:CGRectMake(100, 500, 100, 100)];
    testView.backgroundColor = [UIColor blueColor];
    [_scrollView addSubview:testView];
    
    testView = [[UIView alloc] initWithFrame:CGRectMake(100, 700, 100, 100)];
    testView.backgroundColor = [UIColor redColor];
    [_scrollView addSubview:testView];
    
    testView = [[UIView alloc] initWithFrame:CGRectMake(100, 900, 100, 100)];
    testView.backgroundColor = [UIColor greenColor];
    [_scrollView addSubview:testView];
    
    testView = [[UIView alloc] initWithFrame:CGRectMake(100, 1100, 100, 100)];
    testView.backgroundColor = [UIColor blueColor];
    [_scrollView addSubview:testView];
    
    testView = [[UIView alloc] initWithFrame:CGRectMake(100, 1300, 100, 100)];
    testView.backgroundColor = [UIColor redColor];
    [_scrollView addSubview:testView];
    
    testView = [[UIView alloc] initWithFrame:CGRectMake(100, 1500, 100, 100)];
    testView.backgroundColor = [UIColor greenColor];
    [_scrollView addSubview:testView];
    
    testView = [[UIView alloc] initWithFrame:CGRectMake(100, 1700, 100, 100)];
    testView.backgroundColor = [UIColor blueColor];
    [_scrollView addSubview:testView];
    
    testView = [[UIView alloc] initWithFrame:CGRectMake(100, 1900, 100, 100)];
    testView.backgroundColor = [UIColor redColor];
    [_scrollView addSubview:testView];
    
    testView = [[UIView alloc] initWithFrame:CGRectMake(100, 2100, 100, 100)];
    testView.backgroundColor = [UIColor greenColor];
    [_scrollView addSubview:testView];
    
    testView = [[UIView alloc] initWithFrame:CGRectMake(100, 2300, 100, 100)];
    testView.backgroundColor = [UIColor blueColor];
    [_scrollView addSubview:testView];
    
    _scrollView.contentSize = CGSizeMake(0, 2500);
}

@end
