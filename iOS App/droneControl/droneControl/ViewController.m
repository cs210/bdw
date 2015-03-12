//
//  ViewController.m
//  droneControl
//
//  Created by Michael Weingert on 2015-03-08.
//  Copyright (c) 2015 bdw. All rights reserved.
//

#import "ViewController.h"

#import "SpeechController.h"

@interface ViewController() <SpeechDelegate>
{
  SpeechController * speechController;
}

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *microphoneImage;
@property (weak, nonatomic) IBOutlet UILabel *lastHeardWord;


@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  speechController = [[SpeechController alloc] initWithDelegate:self];
  [speechController setupSpeechHandler];
  
  
  //Set up the UI
  //Get the location of the microphone and add a 
}

-(NSArray * ) listOfWordsToDetect
{
  return @[@"DRONE", @"PARKING", @"TEST", @"MIKE"];
}

-(void) didReceiveWord: (NSString *) word
{
  _lastHeardWord.text = word;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}




@end
