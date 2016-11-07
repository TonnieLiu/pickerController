//
//  ViewController.m
//  camer-photo-video
//
//  Created by D.Tong on 16/7/10.
//  Copyright © 2016年 practices. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
- (IBAction)photoPick:(id)sender;
- (IBAction)takePhoto:(id)sender;
- (IBAction)takeVideo:(id)sender;
- (IBAction)playVideo:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
#pragma 就是这里了
   // _imageView = [[UIImageView alloc] init];
    
    _imageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *changeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changePhoto)];
    [_imageView addGestureRecognizer:changeTap];
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
    UIImage *saveImage = [UIImage imageWithContentsOfFile:fullPath];
    
    if (saveImage) {
        
        _imageView.image = saveImage;
        
    }
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)changePhoto{

    //提示框
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    //相册选取按钮
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
        [self photoPick:alertCtrl];
         
    }]];
    
    //拍照
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        [self takePhoto:alertCtrl];
        
        
    }]];
    
    //取消
    [alertCtrl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertCtrl animated:YES completion:nil];
    

}

//访问系统相册
- (IBAction)photoPick:(id)sender {
    
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    imgPicker.allowsEditing = YES;
    imgPicker.delegate = self;
    [self presentViewController:imgPicker animated:YES completion:nil];
    
}

//访问系统相机
- (IBAction)takePhoto:(id)sender {
    
    //判断是否支持相机
    if (![UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
        
        //不支持相机的提示信息
        UIAlertController *photoCtrl = [UIAlertController alertControllerWithTitle:@"Warning!!!" message:@"Sorry,your device dosen't suppot this feature" preferredStyle:UIAlertControllerStyleAlert];
        [photoCtrl addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil] ];
        
        [self presentViewController:photoCtrl animated:YES completion:nil];
        
        return ;
        
    }
    
    UIImagePickerController *takePhotoPicker = [[UIImagePickerController alloc] init];
    takePhotoPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
 
    takePhotoPicker.allowsEditing = YES;
    takePhotoPicker.delegate = self;
    [self presentViewController:takePhotoPicker animated:YES completion:nil];
}

- (IBAction)takeVideo:(id)sender {

    //判断是否支持相机
    if (![UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
        
        //不支持相机的提示信息
        UIAlertController *photoCtrl = [UIAlertController alertControllerWithTitle:@"Warning!!!" message:@"Sorry,your device dosen't suppot this feature" preferredStyle:UIAlertControllerStyleAlert];
        [photoCtrl addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil] ];
        
        [self presentViewController:photoCtrl animated:YES completion:nil];
        
        return ;
        
    }
    
    UIImagePickerController *takeVideoPicker = [[UIImagePickerController alloc] init];
    takeVideoPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    takeVideoPicker.mediaTypes = @[@"public.movie"];
    takeVideoPicker.delegate = self;
    [self presentViewController:takeVideoPicker animated:YES completion:nil];

}

- (IBAction)playVideo:(id)sender {
    
    UIImagePickerController *playVideoCtrl = [[UIImagePickerController alloc] init];
    playVideoCtrl.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    playVideoCtrl.delegate = self;
    playVideoCtrl.mediaTypes = @[@"public.movie"];
    [self presentViewController:playVideoCtrl animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{

    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    _imageView.image = image;

    [self saveImage:_imageView.image
           withName:@"currentImage"];
    [self dismissViewControllerAnimated:YES completion:nil];


}

- (void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName{

    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.8);
    
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
