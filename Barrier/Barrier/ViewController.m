//
//  ViewController.m
//  Barrier
//
//  Created by 刘宏立 on 16/9/24.
//  Copyright © 2016年 lhl. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(nonatomic,strong)NSMutableArray *photos;

@end

@implementation ViewController {
    dispatch_queue_t _photoQueue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    _photoQueue = dispatch_queue_create("com.liuhongli.photoQueue", DISPATCH_QUEUE_CONCURRENT);
    _photoQueue = dispatch_get_global_queue(0, 0);
    _photos = [NSMutableArray array];
    [self loadPhotos];
}

//模拟加载照片,并在加载完成后添加到数组
- (void)loadPhotos {
    NSInteger count = 10 *100;
    for (NSInteger i = 0; i < count; i++) {
        dispatch_async(_photoQueue, ^{
            NSString *imageName = [NSString stringWithFormat:@"%02zd.jpg", (i % 10 + 1)];
            NSURL *url = [[NSBundle mainBundle] URLForResource:imageName withExtension:nil];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *image = [UIImage imageWithData:data];
//            NSLog(@"下载图像 %@, %@", imageName, [NSThread currentThread]);
            dispatch_barrier_async(_photoQueue, ^{
                [self.photos addObject:image];
                NSLog(@"%@, %@", imageName, [NSThread currentThread]);
            });
        });
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"下载图像的数量 %zd", _photos.count);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
