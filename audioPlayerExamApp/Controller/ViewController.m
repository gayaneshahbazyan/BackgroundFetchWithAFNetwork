//
//  ViewController.m
//  audioPlayerExamApp
//
//  Created by Gayane Shahbazyan on 1/20/18.
//  Copyright © 2018 Gayane Shahbazyan. All rights reserved.
//

#import "ViewController.h"
#import "UrlWithStatus.h"
#import "AudioTableViewCell.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController () {
    NSURLSession* mySession;
    UIButton* lastTappedButton;
}
@property (strong, nonatomic) NSArray<NSString*> *mp3Urls;
@property (strong, nonatomic) NSMutableArray<UrlWithStatus*> *mp3WithStatusArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mp3Urls = [[NSArray alloc] initWithObjects:
                    @"https://s3-us-west-1.amazonaws.com/qairawan/Ch10_32_Encouragement.mp3",
                    @"https://s3-us-west-1.amazonaws.com/qairawan/Ch11_33_HowToEncourage.mp3",
                    @"https://s3-us-west-1.amazonaws.com/qairawan/Ch12_41_CommunicationCycle.mp3",
                    @"https://s3-us-west-1.amazonaws.com/qairawan/Ch13_42_DialogueSkills.mp3",
                    @"https://s3-us-west-1.amazonaws.com/qairawan/Ch14_43_ListeningSkills.mp3",
                    @"https://s3-us-west-1.amazonaws.com/qairawan/Ch15_44_PersuadingSkills.mp3",
                    @"https://s3-us-west-1.amazonaws.com/qairawan/Ch16_51_SupportingEnvironment.mp3",
                    @"https://s3-us-west-1.amazonaws.com/qairawan/Ch17_52_HowHelpTeenager.mp3",
                    @"https://s3-us-west-1.amazonaws.com/qairawan/Ch1_11_Adolescence.mp3",
                    @"https://s3-us-west-1.amazonaws.com/qairawan/Ch2_12_ChildChanged.mp3",
                    @"https://s3-us-west-1.amazonaws.com/qairawan/Ch3_13_Growing.mp3",
                    @"https://s3-us-west-1.amazonaws.com/qairawan/Ch4_14_ProblemsAdolescence.mp3",
                    @"https://s3-us-west-1.amazonaws.com/qairawan/Ch5_21_WhatTeenagerWants.mp3",
                    @"https://s3-us-west-1.amazonaws.com/qairawan/Ch6_22_AdolescentEmotions.mp3",
                    @"https://s3-us-west-1.amazonaws.com/qairawan/Ch7_23_WhenClashOccur.mp3",
                    @"https://s3-us-west-1.amazonaws.com/qairawan/Ch8_24_AvoidClash.mp3",
                    nil];
    
    self.mp3WithStatusArr = [NSMutableArray new];
    self.audioTblView.delegate = self;
    self.audioTblView.dataSource = self;
}

- (IBAction)downloadAll:(id)sender {
    // Downloading and saving in document.
    for (NSString *urlStr in self.mp3Urls) {
        UrlWithStatus *myUrl = [[UrlWithStatus alloc] initWithUrlPath:urlStr];
        [self.mp3WithStatusArr addObject:myUrl];
    }
    [self.audioTblView reloadData];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    mySession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:NSOperationQueue.mainQueue];
    
    for (UrlWithStatus *urlObj in self.mp3WithStatusArr) {
        NSURLSessionDownloadTask *task = [mySession downloadTaskWithURL:[NSURL URLWithString:urlObj.urlPath] completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            for (int i = 0; i < [self.mp3WithStatusArr count]; i++) {
                if (self.mp3WithStatusArr[i].urlPath == urlObj.urlPath) {
                    if (error == nil) {
                        NSArray *pathSong = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                        NSString *tempPath = [[pathSong objectAtIndex:0] stringByAppendingPathComponent:[[urlObj.urlPath componentsSeparatedByString:@"/"] lastObject]];
                        NSURL *url = [NSURL fileURLWithPath:tempPath];
                        [[NSFileManager defaultManager]copyItemAtURL:location toURL:url error:nil];
                        self.mp3WithStatusArr[i].savedPath = url;
                        self.mp3WithStatusArr[i].status = 1;
                    } else {
                        self.mp3WithStatusArr[i].status = -1;
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.audioTblView reloadData];
                    });
                    break;
                }
            }
        }];
        [task resume];
    }
}

- (void) playBtnTapped:(UIButton *) sender {
    if (self.audioPlayer.isPlaying) {
        [self.audioPlayer stop];
        [lastTappedButton setTitle:@"Play" forState: UIControlStateNormal];
        if (lastTappedButton == sender) {
            return;
        }
    }
    if (self.mp3WithStatusArr[sender.tag].savedPath != nil) {
        [sender setTitle:@"Stop" forState: UIControlStateNormal];
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.mp3WithStatusArr[sender.tag].savedPath error:nil];
        [self.audioPlayer prepareToPlay];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive: YES error: nil];
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        [self.audioPlayer play];
    }
    lastTappedButton = sender;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mp3WithStatusArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    AudioTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier   forIndexPath:indexPath] ;
    
    if (cell == nil) {
        cell = [[AudioTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell constractCell];
    cell.audioUrlLbl.text = [[self.mp3WithStatusArr[indexPath.row].urlPath componentsSeparatedByString:@"/"] lastObject];
    
    [cell.playAudioBtn setHidden: (self.mp3WithStatusArr[indexPath.row].status == 0)];
    [cell.loadingActivityIndicator setHidden: !(self.mp3WithStatusArr[indexPath.row].status == 0)];
    cell.playAudioBtn.userInteractionEnabled = (self.mp3WithStatusArr[indexPath.row].status == 1 );
    if (self.mp3WithStatusArr[indexPath.row].status == -1 ) {
        [cell.playAudioBtn setTitle:@"Fail" forState: UIControlStateNormal];
    } else if (self.mp3WithStatusArr[indexPath.row].status == 1) {
        [cell.playAudioBtn setTitle:(self.audioPlayer.isPlaying && lastTappedButton == cell.playAudioBtn) ? @"Stop" : @"Play" forState: UIControlStateNormal];
    }
    [cell.playAudioBtn addTarget:self action:@selector(playBtnTapped:) forControlEvents: UIControlEventTouchUpInside];
    cell.playAudioBtn.tag = indexPath.row;
    return cell;
}

@end
