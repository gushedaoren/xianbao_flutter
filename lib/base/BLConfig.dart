import 'package:dio/dio.dart';

class BLConfig {

  static String Channel = "网站";

  static String PackageName = "com.shumei.xianbao";
  static String AppName = "线报好羊毛";


  static String API_USER = "/userv14";

  static int QQGroup = 790242370;

  static String API_HEALTH = "/xianbao"; //生产环境

  // static String API_HEALTH = "/beirtest"; //测试环境

  static String API_SMJOBS = "/smjobs";

  static String API_FILES = "/files";
  static String API_IMAGE_BASE = "/files/health";
  static String API_USER_ICON = "/files/smuser";
  static String API_SIGN = "/apisix/plugin/jwt/sign";

  static String aws_domains =
      "https://ug6ij67jaccbsvqocv3mzlsk5y0xruhk.lambda-url.ap-east-1.on.aws/"; //aws函数服务器列表

  static String privacy_url = "https://1kcal.net/privacy.html"; //隐私协议地址

  static String user_agreemnet_url =
      "https://1kcal.net/user_agreemnet.html"; //用户协议

  static String baseDomain = "https://sh.1kcal.net/xianbao"; //aws 美国服务器

  static String userDomain = baseDomain + API_USER;
  static String domain = baseDomain + API_HEALTH;
  static String fileDomain = baseDomain + API_FILES;

  static String img_base_url = baseDomain + API_IMAGE_BASE;

  static String smjobs_base_url = baseDomain + API_SMJOBS;

  static String user_img_base_url = baseDomain + API_USER_ICON;

  static String SignURL = baseDomain + API_SIGN;
  static bool isDebug = true; //是否是调试模式

  static String token = "shumei";

  static String CategoryUrl = domain + "/categorylist";
  static String PostListUrl = domain + "/BingliList";
  static String TagListUrl = domain + "/TagList";
  static String PostListWithTagUrl = domain + "/BingliList";

  static String audioPlayerId = "com.brstory";

  static var DEBUG = true;

  static var APIUSER_KEY = "988b75c1f98644f862d2aa125e9223ea";

  static var AES_KEY = "988b75c1f98644f862d2aa125e9223ea";

  static var AES_IV = "RandomInitVector";

  //腾讯广告

  static var TencentAD_Android_ID_SHUMEI_HEALTH = "1200743851"; //树莓健康安卓id
  static var TencentAD_IOS_ID_SHUMEI_HEALTH = "1200743565"; //树莓健康ios id

  static var TencentAD_Android_ID_KALULI = "1200746385"; //卡路里减肥安卓id
  static var TencentAD_IOS_ID_KALULI = "1200746383"; //卡路里减肥ios id

  static var TencentAD_Android_SPLASH_ID_SHUMEI_HEALTH =
      "8083083219339580"; //树莓健康安卓开屏广告id
  static var TencentAD_IOS_SPLASH_ID_SHUMEI_HEALTH =
      "4093283244764225"; //树莓健康ios开屏广告id

  static var TencentAD_Android_SPLASH_ID_KALULI =
      "1063888229132424"; //卡路里减肥安卓开屏广告id
  static var TencentAD_IOS_SPLASH_ID_KALULI =
      "4003086226305906"; //卡路里减肥ios开屏广告id

  static var IOS_PUSH_KEY = "541f22be878a7f6f9668a122";
  static var ANDROID_PUSH_KEY = "541f22be878a7f6f9668a122";

  static var HUAWEI_APPID = "105461517";
  static var HUAWEI_PROJECTID = "737518067794446600";

  static var default_bingli_img_count = 1;
  static var vip_bingli_img_count = 10;

  static var customZiti = "nufang";
}
