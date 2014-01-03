//
//  Constants.h
//  Toastmasters Timer
//
//  Created by Sundeep Gupta on 2013-09-20.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#ifndef Toastmasters_Timer_Constants_h
#define Toastmasters_Timer_Constants_h


typedef enum {
    GREEN_COLOR_INDEX,
    AMBER_COLOR_INDEX,
    RED_COLOR_INDEX,
    BELL_COLOR_INDEX,
    COLOR_INDEX_COUNT
} ColorIndex;



//Timer Notification
#define TIMER_NOTIFICATION @"timerNotification"
#define SECONDS_INFO_KEY @"seconds"



//Misc
#define REALLY_LARGE_INTEGER 999999999
#define AUDIO_ALERT_SOUND_ID 1002 //http://iphonedevwiki.net/index.php/AudioServices

//Defaults Keys
#define SHOULD_AUDIO_ALERT_KEY @"shouldAudioAlert"
#define COLOR_TIMES_KEY @"colorTimes"




//Color Names
#define GREEN_COLOR_NAME @"green"
#define AMBER_COLOR_NAME @"amber"
#define RED_COLOR_NAME @"red"
#define BELL_COLOR_NAME @"bell"


//Toast Stuff
#define TOAST_DURATION 2
#define TOAST_TAG 999
#define TOAST_POSITION @"center"


//Color RGB values
#define DISABLED_ALPHA 0.2

#define GREY_RGB 237  //#ededed

#define GREEN_R 0.
#define GREEN_G 200.
#define GREEN_B 0.

#define AMBER_R 255.0
#define AMBER_G 199.0
#define AMBER_B 0.0

#define RED_R 255.
#define RED_G 0.
#define RED_B 0.

#define BELL_R 255.
#define BELL_G 246.
#define BELL_B 0.

#endif
