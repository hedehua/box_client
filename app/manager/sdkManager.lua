-- var SDKManager = {}
-- var enableSdk = cc.sys.isMobile 

-- /*  any sdk
-- var appKey = "F27E6FA5-83AC-EA13-D01F-EDECB591A8AE";
-- var appSecret = "53e82e1660aa721f9edc204c3e652778";
-- var privateKey = "C6F88537682CFE33353256E1EEDC3604";
-- var oauthLoginServer = "http://oauth.anysdk.com/api/OauthLoginDemo/Login.php";
-- var agent = null

-- var user_plugin  = agent.getUserPlugin();              //用户系统
-- var iap_plugins   = agent.getIAPPlugin();              //支付系统
-- var share_plugin = agent.getSharePlugin();             //分享系统
-- var ads_plugin   = agent.getAdsPlugin();               //广告系统
-- var social_plugin = agent.getSocialPlugin();           //社交系统
-- var push_plugin  = agent.getPushPlugin();              //推送系统
-- var analytics_plugin  = agent.getAnalyticsPlugin();    //统计系统
-- var crash_plugin = agent.getCrashPlugin();             //崩溃分析系统
-- var rec_plugin = agent.getRECPlugin();                 //录屏分享系统
-- var custom_plugin = agent.getCustomPlugin();           //自定义系统

-- SDKManager.init = function() {
--     if(!enableSdk){
--         return
--     }
--     agent = anysdk.agentManager;
--     agent.init(appKey,appSecret,privateKey,oauthLoginServer);
--     agent.loadAllPlugins();
-- }

-- SDKManager.uninit = function() {
--     if(!enableSdk){
--         return
--     }
-- }

-- SDKManager.login = function() {
--     if(!enableSdk){
--         return
--     }
-- }

-- SDKManager.logout = function() {
--      if(!enableSdk){
--         return
--     }
-- }
-- */

-- /* js-sdk */
-- var oauthLoginServer = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=APPID&redirect_uri=REDIRECT_URI&response_type=code&scope=SCOPE&state=STATE#wechat_redirect"
-- var appID = "wx93037bd30c703860"
-- var appsecret = "dd0c0b7e8ef2137472c9e66578cbc619"

-- SDKManager.login = function() {
--     if(!enableSdk){
--         return
--     }
-- }

-- SDKManager.logout = function() {
--      if(!enableSdk){
--         return
--     }
-- }

-- module.exports = SDKManager
