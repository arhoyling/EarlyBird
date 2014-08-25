//
//  AHViewController.h
//  EarlyBird
//
//  Created by Alex on 24/08/2014.
//  Copyright (c) 2014 Alex R. Hoyling. All rights reserved.
//
#import "AHTwitterManager.h"

// General controller orchestrating user inputs, tweet display via the stream widget controller,
// and Twitter specific operations via the Twitter manager.
@interface AHViewController : UIViewController <AHTwitterManagerDelegate, UITextFieldDelegate>
@end
