/**
 * 首页
 * 自带闪屏动画
 */
import 'package:flutter/material.dart';

class FlashScreen extends StatefulWidget {
  @override
  _FlashScreenState createState() => _FlashScreenState();
}

///闪屏动画
class _FlashScreenState extends State<FlashScreen> with SingleTickerProviderStateMixin {
      AnimationController _controller;
      Animation _animation;

      void initState() { 
        super.initState();
        _controller = AnimationController(vsync:this,duration:Duration(milliseconds:3000));
        _animation = Tween(begin: 0.0,end:1.0).animate(_controller);


        /*动画事件监听器，
        它可以监听到动画的执行状态，
        我们这里只监听动画是否结束，
        如果结束则执行页面跳转动作。 */
        _animation.addStatusListener((status){
          if(status == AnimationStatus.completed){
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context)=>IndexPage()),  //动画过后，跳转到首页
              (route)=> route==null);
          }
        });
        //播放动画
        _controller.forward();
      }

      @override
      void dispose() {
        _controller.dispose();
        super.dispose();
      }


      @override
      Widget build(BuildContext context) {
        return FadeTransition(   //透明度动画组件
          opacity: _animation,   //执行动画
          child: Image.asset(  //网络图片
            "images/index.jpg",
            scale: 2.0,         //进行缩放
            fit:BoxFit.cover    // 充满父容器
          ),
        );
      }

}


///首页
class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage>{

  List _list = List();
  ScrollController _scrollController = ScrollController(); //监听列表下拉滚动

  @override
  void initState() {   
      super.initState();
      this._getData(); 
      setState(() {
        this._scrollController.addListener((){
            //print(this._scrollController.position.pixels);
            //如果当前滚动位置 等于 最大滚动位置
            if(this._scrollController.position.pixels == this._scrollController.position.maxScrollExtent){
              this._getData();
            }
        });
      });

  }

  //使用ScrollController()，最好在生命周期结束时，移除掉，减少性能的消耗
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(   //选项卡控件
      length: 6,  
      child: Scaffold(
            backgroundColor: Color.fromRGBO(245, 245, 245, 1),  
            appBar: _appBar(),   
             body: this._list.length > 0 ?
                RefreshIndicator(
                  onRefresh: _handleRefresh,
                  child: ListView.builder(
                      controller: _scrollController,
                      itemCount: this._list.length,
                      itemBuilder: (context,index){

                        if(index == this._list.length -1){     //代表当前列表的新数据，还没有加载完成，加一个加载提示组件
                          // print("未加载完，底部加圈圈组件");
                          return Column(
                            children: <Widget>[
                              _companyItem(),
                              _showMoreLoadingWidget()
                            ],
                          );

                        }else{
                          // print("加载完圈圈组件消失");
                          return Column(
                            children: <Widget>[
                              _companyItem(),
                            ],
                          );                          
                        }

                      }
                    ), 
                  ): _showMoreLoadingWidget(),

            bottomNavigationBar: _bottomNav()   
          ),
    );
          
  }
 

  ///下拉加载更多
  Future<void> _getData() async{
    await Future.delayed(Duration(seconds: 2),(){
          //虚拟数据
          List mapdata = [
            {
              "occupation" : "Java开发工程师",
              "skill" : ["Spring","SpringBoot","Mybatis","SpringMVC","Redis"],
              "company" : "xxx信息有限公司",  
              "hr":"韩先生" 
            },
            {
              "occupation" : "Java开发工程师",
              "skill" : ["Spring","SpringBoot","Mybatis","SpringMVC","Redis"],
              "company" : "xxx信息有限公司",  
              "hr":"韩先生" 
            },
            {
              "occupation" : "Java开发工程师",
              "skill" : ["Spring","SpringBoot","Mybatis","SpringMVC","Redis"],
              "company" : "xxx信息有限公司",  
              "hr":"韩先生" 
            },                
          ];
          // print(mapdata.length);

          setState(() {
            this._list.addAll(mapdata);    //集合拼接
          });
    });     
  }


  ///公司名片项
  Widget _companyItem(){
      return Container(
            width: MediaQuery.of(context).size.width,
            height: 150.0,
            margin: EdgeInsets.only(bottom:8.0),
            decoration: BoxDecoration(
              color:Colors.white
            ),
            child: Column(
              children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top:10.0),
                    height: 50.0,
                    decoration: BoxDecoration(
                      color:Colors.white
                    ),
                    child: Row(
                      children:<Widget>[
                        SizedBox(width: 10.0),
                        Expanded(
                          flex: 5,
                          child: Container(
                            child: Text(
                              "JAVA初级开发工程师",
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w800
                              ),
                            ),
                          )
                        ),
                        SizedBox(width: 10.0),
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Text(
                              "9-14K",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromRGBO(91, 203, 196, 1),
                              ),
                            ),
                          )
                        ),
                      ]
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 95.0,
                    decoration: BoxDecoration(
                      color:Colors.white
                    ),
                    child: Wrap(
                      children: <Widget>[           
                        SizedBox(width: 10.0),  

                        Container(
                          width: 40.0,
                          height: 22.0,
                          margin: EdgeInsets.only(right:5.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color:Color.fromRGBO(240, 240, 240, 1),
                            borderRadius: BorderRadius.all(Radius.circular(3.0))
                          ),
                          child:Text(
                            "1-3年",
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Color.fromRGBO(99, 106, 124, 1)
                            ),
                          )
                        ),
                        
                        Container(
                          width: 42.0,
                          height: 22.0,
                          margin: EdgeInsets.only(right:5.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color:Color.fromRGBO(240, 240, 240, 1),
                            borderRadius: BorderRadius.all(Radius.circular(3.0))
                          ),
                          child:Text(
                            "本科",
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Color.fromRGBO(99, 106, 124, 1)                                  
                            ),
                          )
                        ),
                        
                        Container(
                          width: 42.0,
                          height: 22.0,
                          margin: EdgeInsets.only(right:5.0),                                
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color:Color.fromRGBO(240, 240, 240, 1),
                            borderRadius: BorderRadius.all(Radius.circular(3.0))
                          ),
                          child:Text(
                            "Redis",
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Color.fromRGBO(99, 106, 124, 1)                                   
                            ),
                          )
                        ),
                        
                        Container(
                          width: 42.0,
                          height: 22.0,
                          margin: EdgeInsets.only(right:5.0),                                
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color:Color.fromRGBO(240, 240, 240, 1),
                            borderRadius: BorderRadius.all(Radius.circular(3.0))
                          ),
                          child:Text(
                            "Spring",
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Color.fromRGBO(99, 106, 124, 1)                                  
                            ),
                          )
                        ),

                        Container(
                          width: 50.0,
                          height: 22.0,
                          margin: EdgeInsets.only(right:5.0),                                
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color:Color.fromRGBO(240, 240, 240, 1),
                            borderRadius: BorderRadius.all(Radius.circular(3.0))
                          ),
                          child:Text(
                            "Mybatis",
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Color.fromRGBO(99, 106, 124, 1)
                            ),
                          )
                        ),

                        SizedBox(width: 60.0),

                        Container(
                            margin: EdgeInsets.fromLTRB(11.0, 10.0, 0.0, 5.0),
                            padding: EdgeInsets.only(bottom:8.0),
                            child: Text(
                              "xxx信息有限公司",
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ), 

                        Container(
                          
                          margin: EdgeInsets.only(bottom:20.0),
                          child: Row(
                            children: <Widget>[
                              SizedBox(width:10.0),
                              // Icon(Icons.home),
                              ClipOval(
                                child: Image.asset(
                                  "images/icon.jpeg",
                                  width: 22.0,
                                  height: 22.0,
                                  fit: BoxFit.cover,
                                ),                                        
                              ),
                              SizedBox(width:8.0),
                              Text("韩先生.技术总监"),
                              SizedBox(width:133.5),
                              Text(
                                "江干区 九堡",
                                style: TextStyle(
                                  color: Colors.grey
                                ),
                              ),
                            ],
                          ),
                        ), 

                      ],
                    ),
                  ),                  
              ],
            ),
          );
    }


  ///加载更多提示圈圈组件
  Widget _showMoreLoadingWidget() {
    return Center(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '加载中...',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  CircularProgressIndicator(
                    strokeWidth: 1.0,
                  )
                ],
              ),
            ),
          );    
    }


  //下拉刷新的回调函数
  Future<void> _handleRefresh() async {
     await Future.delayed(Duration(seconds:2)); //延迟2秒后执行
     return null;
  }


  ///头部AppBar导航
  Widget _appBar(){
    return AppBar(
            elevation:0.5,                                    //去除阴影
            backgroundColor:Color.fromRGBO(91, 203, 196, 1),  //导航背景色
            title:Row(
              children:<Widget>[
                  Expanded(
                    flex: 5,
                    child: Text(
                      "Java",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    )
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      icon: Icon(Icons.add), 
                      onPressed: (){
                        // Navigator.of(context)
                      }
                    ),
                  ),
                  Container(height: 20, child: VerticalDivider(color: Colors.white)),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      icon: Icon(Icons.search), 
                      onPressed: (){}
                    ),
                  ),                       
              ]
            ), 
            bottom: _appBarBottomItem(),                                        
        );
  }


  ///头部AppBar下面的选项卡
  Widget _appBarBottomItem(){
    return PreferredSize(
            preferredSize: Size.fromHeight(48),
            child: Material(
              
              color: Colors.white,                      //这里设置tab的背景色
              child: TabBar(
                isScrollable: true,                     //是否可以滚动，当数量多的时候，会被挤下去，不显示
                indicatorColor: Colors.white,           //选中时下划线颜色,如果使用了indicator这里设置无效
                labelColor: Colors.black87,             //选中时的文字颜色 
                unselectedLabelColor:Color.fromRGBO(99, 106, 124, 1),      //未选中时的文字颜色 
                labelStyle: TextStyle(                  //选中时的文字样式  
                  fontSize: 14.0,
                  fontWeight: FontWeight.w900
                ),

                unselectedLabelStyle: TextStyle(      //未选中时的文字样式 
                  fontSize: 13.0,                
                ),

                tabs:  <Widget>[                        //直接子控件数量，必须和length一致
                      Tab(
                        text: '推荐'              
                      ),     
                      Tab(         
                        text: '附近'              
                      ),   
                      Tab(  
                        text: '最新'
                      ),   
                      Tab(
                        text: '杭州'              
                      ),     
                      Tab(         
                        text: '筛选'              
                      ),   
                      Tab(  
                        text: '关键字'
                      ),                         
                    ]
              ),
            ),
          );
  }


  ///底部导航栏
  Widget _bottomNav(){
    return BottomNavigationBar(
          type: BottomNavigationBarType.fixed, //允许有很多按钮，否则按钮多了，会被挤下去，不显示
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.work,size: 23.0),
              title: Text(
                "职位",
                style: TextStyle(
                  fontSize: 10.0
                ),
              )
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.visibility,size: 23.0),
              title: Text(
                "发现",
                style: TextStyle(
                  fontSize: 10.0
                )
              )
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.sms,size: 23.0),
              title: Text(
                "消息",
                style: TextStyle(
                  fontSize: 10.0
                )
              )
            ),  
            BottomNavigationBarItem(
              icon: Icon(Icons.person,size: 23.0),
              title: Text(
                "我的",
                style: TextStyle(
                  fontSize: 10.0
                )
              )
            ),                    
          ],
      );
  }
  
}





