//
//  ViewController.m
//  SaveGifToAlblum
//
//  Created by ZJW on 16/10/12.
//  Copyright © 2016年 NetEase. All rights reserved.
//

#import "ViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/ImageIO.h>
#import <Photos/Photos.h>
#import "JWGifDecoder.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"niconiconi" ofType:@"gif"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        
        CFShow(CGImageGetUTType(image.CGImage));
        
        CGDataProviderRef dataProvider = CGImageGetDataProvider(image.CGImage);
        CGImageSourceRef imageSource = CGImageSourceCreateWithDataProvider(dataProvider,NULL);
        CFShow(CGImageSourceGetType(imageSource));
        printf("%zu",CGImageSourceGetCount(imageSource));
        
        NSLog(@"aa");
    }
    
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"niconiconi" ofType:@"gif"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        UIImage *image = [UIImage imageWithData:data];
        CFShow(CGImageGetUTType(image.CGImage));
        NSLog(@"aa");
    }
    
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"4frame" ofType:@"gif"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        
        UIImage *image = [UIImage imageWithData:data];
        
        JWGifDecoder *decoder = [JWGifDecoder decoderWithData:data];
        NSMutableArray *frames = [NSMutableArray arrayWithCapacity:decoder.frameCount];
        for (int i = 0; i < decoder.frameCount; i++) {
            JWGifFrame *frame = [decoder frameAtIndex:i];
            [frames addObject:frame];
        }
        
        NSLog(@"aa");
    }
    
    {
        //项目要运行两次，第一次来获得相册权限，第二次则可正常保存
        NSString *path = [[NSBundle mainBundle] pathForResource:@"niconiconi" ofType:@"gif"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f) {
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                PHAssetResourceCreationOptions *options = [[PHAssetResourceCreationOptions alloc] init];
                [[PHAssetCreationRequest creationRequestForAsset] addResourceWithType:PHAssetResourceTypePhoto data:data options:options];
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                NSLog(@"是否保存成功：%d",success);
            }];
        }
        else {
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            [library writeImageDataToSavedPhotosAlbum:data metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
            }];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
