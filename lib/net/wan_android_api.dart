
//feed 文章列表
const String RECOMMEND_FEEDS = "http://www.wanandroid.com/article/list/{param}/json";

//知识体系
const String TREE_LIST = "http://www.wanandroid.com/tree/json";

//知识体系下的文章
const String TREE_FEEDS = "http://www.wanandroid.com/article/list/{param}/json?cid={param}";

//搜索热词
const String HOT_KEYS = "http://www.wanandroid.com/hotkey/json";

//热门网站
const String FRIEND_WEBSITE = "http://www.wanandroid.com/friend/json";

//搜索
const String SEARCH = "http://www.wanandroid.com/article/query/{param}/json";

//登陆
const String LOGIN = "http://www.wanandroid.com/user/login";

//注册
const String REGISTER = "http://www.wanandroid.com/user/login";

//取消收藏
const String REMOVE_FAVORITE = "http://www.wanandroid.com/lg/uncollect_originId/{param}/json";
//收藏
const String ADD_FAVORITE = "http://www.wanandroid.com/lg/collect/{param}/json";
//收藏列表
const String FAVORITE_LIST = "http://www.wanandroid.com/lg/collect/list/{param}/json";

//添加站外文章
const String ADD_POST = "http://www.wanandroid.com/lg/collect/add/json";

//添加网站
const String ADD_WEBSITE = "http://www.wanandroid.com/lg/collect/addtool/json";
//网站列表
const String WEBSITE_LIST = "http://www.wanandroid.com/lg/collect/usertools/json";
//删除网站
const String REMOVE_WEBSITE = "http://www.wanandroid.com/lg/collect/deletetool/json";


// 填充url
String fillUrl(String url, {List params}){
  if(null == params || params.length == 0){
    return url;
  }
  String s = url;
  params.forEach((dynamic p){
    if(s.contains("{param}")) {
      s = s.replaceFirst("{param}", p.toString());
    }
  });
  return s;
}