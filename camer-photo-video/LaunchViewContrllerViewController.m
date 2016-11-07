//
//  LaunchViewContrllerViewController.m
//  camer-photo-video
//
//  Created by D.Tong on 16/7/11.
//  Copyright © 2016年 practices. All rights reserved.
//

#import "LaunchViewContrllerViewController.h"
#import "ViewController.h"

@interface LaunchViewContrllerViewController ()<UIScrollViewDelegate>

@property (nonatomic,retain)UIPageControl *pageCtrl;
@property (nonatomic,retain)NSTimer *scrollTime;

@end

@implementation LaunchViewContrllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _launchScrollView];
    
    [self _loginBtn];

}

- (void)_loginBtn{

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(CGRectGetWidth(self.view.frame)-200, CGRectGetHeight(self.view.frame)-80, 80, 50);
    [btn setTitle:@"进入主页" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor grayColor]];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];

}

- (void)btnAction{

    ViewController *viewCtrl = [[ViewController alloc] init];
    self.view.window.rootViewController = viewCtrl;
    
    //[self presentViewController:viewCtrl animated:YES completion:nil];
    
}

- (void)_launchScrollView{
    
    UIScrollView *scrView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    //滚动范围
    scrView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame)*4, CGRectGetHeight(self.view.frame));
    //分页效果
    scrView.pagingEnabled = YES;
    //水平滚动条是否隐藏
    scrView.showsHorizontalScrollIndicator = NO;
    
    //图片
    NSArray *imgArray = @[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg"];
    
    //添加子视图
    for (int i = 0; i < 4; i ++) {
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)*i, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
       
        imgView.userInteractionEnabled = YES;
        imgView.tag = 30 + i;
        
        NSString *imgName = imgArray[i];
        imgView.image = [UIImage imageNamed:imgName];
        
        [scrView addSubview:imgView];
        
    }
    
    /*
    UIImageView *imageView01 = [scrView viewWithTag:30];
    UIImageView *imageView =[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)*4, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) ];
    imageView.image = imageView01.image;
    [scrView addSubview:imageView];
 */
    
    [self.view addSubview:scrView];
    
    scrView.tag = 30;
    scrView.delegate = self;

    //分页效果
    self.pageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), 0)];
    self.pageCtrl.numberOfPages = 4;
    self.pageCtrl.currentPage = 0;
    [self.view addSubview:self.pageCtrl];
    
    /*self.scrollTime = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.scrollTime forMode:NSRunLoopCommonModes];
 */
}


//////////////////////////////////


//开始划动，即手动，停止计时器
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0){

   // [self.scrollTime setFireDate:[NSDate distantFuture]];

}

//静止时，开启定时器，自动划动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

   // [self.scrollTime setFireDate:[NSDate dateWithTimeInterval:2 sinceDate:[NSDate date]]];
    
    NSInteger index = scrollView.contentOffset.x/scrollView.bounds.size.width;
    [_pageCtrl setCurrentPage:index];

}

- (void)timerAction{

    //获取到scrView
    UIScrollView *scrollView = [self.view viewWithTag:30];
    //改变contentOffset切换视图的子界面
    float offset_X = scrollView.contentOffset.x;
    offset_X += CGRectGetWidth(self.view.frame);
    //说明要从最右边的多余视图开始滚动了，最右边的多余视图实际上就是第一个视图。所以偏移量需要更改为第一个视图的偏移量。
    if (offset_X > CGRectGetWidth(self.view.frame)*4) {
        scrollView.contentOffset = CGPointMake(0, 0);
        
    }
    //说明正在显示的就是最右边的多余视图，最右边的多余视图实际上就是第一个视图。所以pageControl的小白点需要在第一个视图的位置。
    if (offset_X == CGRectGetWidth(self.view.frame)*4) {
        self.pageCtrl.currentPage = 0;
    }else{
        self.pageCtrl.currentPage = offset_X/CGRectGetWidth(self.view.frame);
    }
    
    //得到最终的偏移量
    CGPoint resultPoint = CGPointMake(offset_X, 0);
    //切换视图时带动画效果
    //最右边的多余视图实际上就是第一个视图，现在是要从第一个视图向第二个视图偏移，所以偏移量为一个屏幕宽度
    if (offset_X >CGRectGetWidth(self.view.frame)*4) {
        self.pageCtrl.currentPage = 1;
        [scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.view.frame), 0) animated:YES];
    }else{
        [scrollView setContentOffset:resultPoint animated:YES];
    }
    

    
    
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
