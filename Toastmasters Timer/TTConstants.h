#pragma mark - Enums
typedef NS_ENUM(NSUInteger, ColorIndex) {
    GREEN_COLOR_INDEX,
    AMBER_COLOR_INDEX,
    RED_COLOR_INDEX,
    BELL_COLOR_INDEX,
    COLOR_INDEX_COUNT
};

#pragma mark - Keys
static NSString *const IS_NOT_FIRST_LAUNCH = @"IsNotFirstLaunch";


#pragma mark - API Keys
static NSString *const API_KEY_CRASHLYTICS = @"8326e081af65babd59690e3dc0bbfea5dcd9abd3";


#pragma mark - URLs
static NSString *const BASE_URL_RATE_APP = @"itms-apps://itunes.apple.com/app/id";
static NSString *const APP_ID = @"708807408";
static NSString *const APP_STORE_URL = @"https://itunes.apple.com/us/app/id708807408";


//Timer Notification
#define TIMER_NOTIFICATION @"timerNotification"
#define SECONDS_INFO_KEY @"seconds"



//Misc
#define REALLY_LARGE_INTEGER 999999999
#define AUDIO_ALERT_SOUND_ID 1002 //http://iphonedevwiki.net/index.php/AudioServices

//Defaults Keys
#define SHOULD_AUDIO_ALERT_KEY @"shouldAudioAlert"
#define COLOR_TIMES_KEY @"colorTimes"



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


//Google Analytics
static NSString *const GOOGLE_ANALYTICS_TRACKING_ID_PROD = @"UA-49711300-2";
static NSString *const GOOGLE_ANALYTICS_TRACKING_ID_DEV = @"UA-49711300-3";

static NSString *const GOOGLE_ANALYTICS_CATEGORY_TIMER = @"Timer";
static NSString *const GOOGLE_ANALYTICS_ACTION_AUDIO_ENABLE = @"Enable Audio Alerts";
static NSString *const GOOGLE_ANALYTICS_ACTION_AUDIO_DISABLE = @"Disable Audio Alerts";

static NSString *const GOOGLE_ANALYTICS_CATEGORY_INFO = @"Info";
static NSString *const GOOGLE_ANALYTICS_ACTION_RATE_APP = @"Rate App";
static NSString *const GOOGLE_ANALYTICS_ACTION_CONTACT_DEVELOPER = @"Contact Developer";
static NSString *const GOOGLE_ANALYTICS_ACTION_CONTACT_DESIGNER = @"Contact Designer";

static NSString *const GOOGLE_ANALYTICS_CATEGORY_TIME_ENTRY = @"Time Entry";
static NSString *const GOOGLE_ANALYTICS_ACTION_RESET_COLOURS = @"Reset Colours";
static NSString *const GOOGLE_ANALYTICS_ACTION_SAVE_COLOURS = @"Save Colours";


//Info View
static NSString *const URL_DESIGNER = @"http://www.redconservatory.com";
