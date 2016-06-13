//
//  TRFrontViewController.m
//  TuringTest
//
//  Created by 刘小姐 on 15/11/18.
//  Copyright © 2015年 Zeng Haitao. All rights reserved.
//

#import "TRFrontViewController.h"
#import "TRMainViewController.h"
#import "TRMessageCell.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"


@interface TRFrontViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *frameImageView;
@property(nonatomic,strong)UIImagePickerController*imagePicker;
@property(nonatomic,strong)UIImage*headImage;
@end

@implementation TRFrontViewController
- (UIImagePickerController *)imagePicker {
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc]init];
        _imagePicker.delegate = self;
        _imagePicker.allowsEditing = YES;
    }
    return _imagePicker;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Pattern"]];
    self.startChat.enabled = NO;
    [self.startChat setTintColor:[UIColor clearColor]];
    //self.imageView.layer.cornerRadius = 20;
    //self.imageView.layer.masksToBounds = YES;
    UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(appearAlertController)];
    tap.numberOfTapsRequired = 1;
    [self.frameImageView addGestureRecognizer:tap];
}

- (void)appearAlertController {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:0];
    UIAlertAction *action_album = [UIAlertAction actionWithTitle:@"从相册选择" style:0 handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
             self.imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [self presentViewController:self.imagePicker animated:YES completion:NULL];
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"应用无法打开您的照相机，请到“设置”修改" preferredStyle:1];
            [self presentViewController:alert animated:YES completion:NULL];
        }
    }];
    [alertController addAction:action_album];
    UIAlertAction *action_takePhoto = [UIAlertAction actionWithTitle:@"拍照" style:0 handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera] && [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]&& [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:self.imagePicker animated:YES completion:NULL];
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"应用无法打开您的照相机，请到“设置”修改" preferredStyle:1];
            [self presentViewController:alert animated:YES completion:NULL];
        }
    }];
    [alertController addAction:action_takePhoto];
    UIAlertAction *action_cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];

    [alertController addAction:action_cancel];
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
    
}
- (IBAction)startChat:(UIButton *)sender {
 
}

#pragma imagePickerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
  
    self.headImage = info[UIImagePickerControllerEditedImage];
    NSData *imageData = [NSKeyedArchiver archivedDataWithRootObject:self.headImage];
    [[NSUserDefaults standardUserDefaults]setObject:imageData forKey:@"headImage"];
    self.imageView.image = self.headImage;
    self.imageView.layer.cornerRadius = 50;
    self.imageView.layer.masksToBounds = YES;
    if (self.headImage) {
        self.startChat.enabled = YES;
        [self.startChat setTintColor:[UIColor blueColor]];
    }
    [self.imagePicker dismissViewControllerAnimated:YES completion:NULL];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.imagePicker dismissViewControllerAnimated:YES completion:NULL];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     
         TRMainViewController*mainVC = [segue destinationViewController];
         mainVC.myImage = self.headImage;

 }


@end
