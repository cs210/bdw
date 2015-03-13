//
//  ViewController.m
//  droneControl
//
//  Created by Michael Weingert on 2015-03-08.
//  Copyright (c) 2015 bdw. All rights reserved.
//

#import "ViewController.h"
#import "SpeechController.h"

typedef enum
{
  kListening,
  kNotListening
} listeningStates;

@interface ViewController() <SpeechDelegate>
{
  SpeechController * speechController;
  listeningStates _currentState;
}



@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastHeardWord;

@end

@implementation ViewController

- (IBAction)microphoneClick:(UIButton *)sender
{
  if (_currentState == kNotListening)
  {
    _statusLabel.text = @"Listening";
    [speechController startListening];
    _currentState = kListening;
  }
}

- (void)viewDidLoad {
  [super viewDidLoad];

  // Do any additional setup after loading the view, typically from a nib.
  speechController = [[SpeechController alloc] initWithDelegate:self];
  [speechController setupSpeechHandler];
  
  _currentState = kNotListening;
    
  //Set up the UI
  //Get the location of the microphone and add a 
}

-(NSArray * ) listOfWordsToDetect
{
  return @[@"ACTIVATE DRONE", @" FIND PARKING", @"TEST", @"MIKE", @"OK BMW", @"GO", @"RIGHT", @"LEFT", @"SHAURYA"];
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