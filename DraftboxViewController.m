//
//  DraftboxViewController.m
//  shootVideoDemo
//
//  Created by 赵一帆 on 15/12/9.
//  Copyright © 2015年 ZYF. All rights reserved.
//

#import "DraftboxViewController.h"
#import "draftBoxViewCollectionViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import "CaptureViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MBProgressHUD.h"
#import "SBVideoData.h"
@interface DraftboxViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic ,strong)UICollectionView * boxCollection;
@property (nonatomic ,strong)draftBoxViewCollectionViewCell *cell;
@property (nonatomic ,strong)NSArray *videoUrlArray;
@property(nonatomic ,strong)CaptureViewController * videoController;

@property (nonatomic ,strong) NSURL *boxUrl;
@property (nonatomic,assign,readwrite)CGFloat videoTime;
@property (nonatomic ,strong)NSMutableArray *arr;
@property(nonatomic ,strong)NSDateFormatter *format;
@end

@implementation DraftboxViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self boxFileVideoUrl];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title =@"草稿箱";
    NSUserDefaults * userdefaus =[NSUserDefaults standardUserDefaults];
    _arr  = [[userdefaus objectForKey:@"times"] mutableCopy];
    if (!_arr) {
        _arr = @[].mutableCopy;
    }
    
    UICollectionViewFlowLayout* layout =[[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset=UIEdgeInsetsMake(10, 10, 10, 10);
    layout.minimumInteritemSpacing= 10;
    
    
    layout.itemSize=CGSizeMake(([UIScreen mainScreen].bounds.size.width - 50)/4,([UIScreen mainScreen].bounds.size.width - 50)/4);
    _boxCollection =[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:layout ];
    [self.view addSubview:_boxCollection];
    _boxCollection.delegate=self;
    _boxCollection.dataSource=self;
    [self.boxCollection registerNib:[UINib nibWithNibName:@"draftBoxViewCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"boxCell"];
     _boxCollection.backgroundColor=[UIColor whiteColor];
    
    UIButton *btn =[[UIButton alloc] init];
    btn.bounds =CGRectMake(0, 0, 33, 33);
    [btn  setImage:[UIImage imageNamed:@"back-icon2"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
     self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];

//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-icon2"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
//    if (!_arr)
//    {
//        _arr =[[NSMutableArray alloc] init];
//    }
//    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(editor)];
    UIButton *rightBtn =[[UIButton alloc] init];
    rightBtn.bounds=CGRectMake(0, 0, 44, 44);
    [rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(editor:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    
}
-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)editor:(UIButton *)sender
{
    sender.selected =!sender.selected;
   
    if (sender.selected)
    {
//        _cell.renove.hidden =NO;
         [sender setTitle:@"完成" forState:UIControlStateNormal];
       
    }else
    {
//        _cell.renove.hidden=YES;
         [sender setTitle:@"编辑" forState:UIControlStateNormal];
        
    }

}
//-(void)compelte
//{
//    _cell.renove.hidden=YES;
//    
//    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(editor)];
//}
//
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _videoUrlArray.count+1;
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    draftBoxViewCollectionViewCell *cell =[_boxCollection dequeueReusableCellWithReuseIdentifier:@"boxCell" forIndexPath:indexPath];
    if (indexPath.row==0)
    {
         cell.image.image=[UIImage imageNamed:@"camera"];
        cell.image.contentMode =UIViewContentModeScaleAspectFit;
        cell.label.hidden=YES;
    }
//    NSURL* url =[NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/aaa.mov"]];
    else
    {
        cell.image.image=[self thumbnailImageForVideo:_videoUrlArray[indexPath.row-1] atTime:0];
        NSInteger time= [_arr[indexPath.row-1] integerValue];
//        NSDate *date = [[NSDate alloc] initWithTimeInterval:time sinceDate:[NSDate dateWithTimeIntervalSince1970:-8*60*60]];
//       _format = [[NSDateFormatter alloc] init];
//        _format.dateFormat = @"SS";
//        NSString *str = [_format stringFromDate:date];
        //假时间
        cell.label.text= [NSString stringWithFormat:@"00:0%lu",time];
        UIButton *rightBtn = self.navigationItem.rightBarButtonItem.customView;
        if (rightBtn.selected) {
            cell.renove.hidden = NO;
        }else{
            cell.renove.hidden = YES;

        }
    }
    return cell;
    
}
//获取第一帧
-(UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil] ;
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset] ;
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60) actualTime:NULL error:&thumbnailImageGenerationError];
    
    if (!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
    
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef]  : nil;
    return thumbnailImage;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        self. videoController =[[CaptureViewController alloc] init];
        __weak typeof (self) weakSelf =self;
        self.videoController.time = ^(CGFloat time){
            _videoTime =time;
            [weakSelf.arr addObject:@(time)];
            NSUserDefaults *userDefaus= [NSUserDefaults standardUserDefaults];
            [userDefaus setObject:weakSelf.arr forKey:@"times"];
            [userDefaus synchronize];
        };
        _videoController.sendController=self.navigationController;
        [self presentViewController:_videoController animated:YES completion:^{
        }];
    }
    else
    {
        CGFloat time =[_arr[indexPath.row-1] floatValue];
        if (time >=6.0)
        {
            [self showMB];
        }
        else
        {
            CaptureViewController * video =[[CaptureViewController alloc] init];
            NSURL * url =_videoUrlArray[indexPath.row -1];
            SBVideoData * data =[[SBVideoData alloc] init];
            data.duration =time;
            data.fileURL=url;
            video.data=data;
            [self presentViewController:video animated:YES completion:^{
                if (data) {
//                    NSFileManager * fm =[NSFileManager defaultManager];
//                    NSString * boxString =@"Documents/videos";
//                    NSURL *fileUrl =[NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",boxString,url]]];
//                    [fm removeItemAtURL:fileUrl error:nil];
                }
            }];
            
        }
    }
}

-(void)boxFileVideoUrl
{
    NSFileManager *fm =[NSFileManager defaultManager];
    NSString * boxString =@"Documents/videos";
   _boxUrl =[NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent:boxString]];
    NSArray *dirArr =[fm contentsOfDirectoryAtURL:_boxUrl includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
    _videoUrlArray=dirArr;
    [self.boxCollection reloadData];
}
//这边只能获取系统相册里面的视频时间
//-(void)getVideoTime
//{
//    NSURL *videoTime = _boxUrl;
//    NSDictionary  *opts =[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
//    AVURLAsset  *urlAsset =[AVURLAsset URLAssetWithURL:videoTime options:opts];
//    _second =(NSInteger)urlAsset.duration.value/urlAsset.duration.timescale;
////     MPMoviePlayerController *player=[[MPMoviePlayerController alloc] initWithContentURL:_boxUrl];
////    _second =player.playableDuration;
//}
-(void)showMB
{
    UIColor *color =[UIColor whiteColor];
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode =MBProgressHUDModeText;
    hud.labelText =@"视频长度为6秒，不能继续录制了";
    hud .labelColor =color;
    [hud removeFromSuperViewOnHide];
    
    [hud hide:YES afterDelay:1.0];
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
