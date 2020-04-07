import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' as intl;
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;


 List<String> imgList = new List<String>();
var res_final;
bool is_imgs_load=false;



void main() => runApp(CarouselDemo());

final Widget placeholder = Container(color: Colors.grey);

final List child = map<Widget>(
  imgList,
      (index, i) {
    return Container(
      margin: EdgeInsets.all(5.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        child: Stack(children: <Widget>[
          Image.network(i, fit: BoxFit.cover, width: 1000.0),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color.fromARGB(200, 0, 0, 0), Color.fromARGB(0, 0, 0, 0)],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                'No. $index image',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  },
).toList();

List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }

  return result;
}

class CarouselWithIndicator extends StatefulWidget {
  @override
  _CarouselWithIndicatorState createState() => _CarouselWithIndicatorState();
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicator> {
  String display_day;
  String display_month;
  String display_time;
  Future<http.Response>  get_Data () async{
    var r = await get("http://skillzycp.com/api/UserApi/getOneOccasion/389/0",
        headers: {
          "From":"123123",
          "User-Agent":"android",
          "Accept":"application/json",
          "Content-Type":"application/json",
          "Accept-Language":"en",
        }
    );
    print(r.statusCode);
    print(r.body);
    var result=json.decode(r.body);
    res_final=json.decode(result);
    print(res_final);
    for(var x=0;x<res_final['img'].length;x++){
      res_final['img'][x]= res_final['img'][x].toString().replaceAll("https", "http");
      imgList.add(res_final['img'][x]);
    }
    res_final['trainerImg']= res_final['trainerImg'].toString().replaceAll("https", "http");
setState(() {
  is_imgs_load=true;
});

    initializeDateFormatting("ar_SA", null).then((_) {
      print("lll${res_final['date']}");
      var parsedDate = DateTime.parse('${res_final['date']}');
      var day = intl.DateFormat.E('ar_SA');
      var month_year = intl.DateFormat.MMMMd('ar_SA');

      var time= intl.DateFormat.jm('ar_SA');
      print(month_year);
       display_day = day.format(parsedDate);
       display_month = month_year.format(parsedDate);
       display_time = time.format(parsedDate);
      //print(formatted);
    });

    print("imagList.length${imgList.length}");
  }

  @override
  void initState() {
    // TODO: implement initState
    print('get data');
    get_Data();
    super.initState();
  }

  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Expanded(child:  ListView(
      children: <Widget>[
        Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              is_imgs_load==true?Stack(
                children: <Widget>[
                  CarouselSlider(
                    autoPlay: true,
                    viewportFraction: 1.0,
                    height: MediaQuery.of(context).size.height*0.33,
                    aspectRatio: MediaQuery.of(context).size.aspectRatio,
                    onPageChanged: (index) {
                      setState(() {
                        _current = index;
                      });
                    },
                    items: imgList.map(
                          (url) {
                        return Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(0.0)),
                            child: Image.network(
                              url,
                              fit: BoxFit.cover,
                              width: 1000.0,
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                  Positioned(
                    top: 28,
                    child: Padding(
                      padding: const EdgeInsets.only(left:12.0,bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right:16.0),
                            child: Icon(
                              Icons.star_border,
                              color: Colors.white,
                              size: 24.0,
                              semanticLabel: 'Text to announce in accessibility modes',
                            ),
                          ),

                          Icon(
                            Icons.share,
                            color: Colors.white,
                            size: 24.0,
                            semanticLabel: 'Text to announce in accessibility modes',
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 28,
                    right: 12,
                    child: Padding(
                      padding: const EdgeInsets.only(left:12.0,bottom: 8.0),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 18.0,
                        semanticLabel: 'Text to announce in accessibility modes',
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Padding(
                      padding: const EdgeInsets.only(left:12.0,bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: map<Widget>(
                          imgList,
                              (index, url) {
                            return Container(
                              width: 8.0,
                              height: 8.0,
                              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _current == index
                                      ? Colors.white
                                      : Colors.white38),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                ],
              ):Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey),),),
              is_imgs_load==true?  Padding(
                padding: const EdgeInsets.only(right:16.0,top:6),
                child: Text("#${res_final['interest']}",style: TextStyle(fontSize: 16,color: Colors.grey[400]),textDirection: TextDirection.rtl,),
              ):Container(),
              Padding(
                padding: const EdgeInsets.only(right:16.0,top:4),
                child: Text("الاسم الكامل للدورة افتراضى من اجل اظهار \nشكل التصميم",style: TextStyle(fontSize: 17,fontWeight:FontWeight.bold,color: Colors.grey[400]),textDirection: TextDirection.rtl,),
              ),
              is_imgs_load==true? Padding(
                padding: const EdgeInsets.only(right:16.0,top:6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[

                    Padding(
                      padding: const EdgeInsets.only(right:8.0,bottom: 0),
                      child: Text("${display_day} , ${display_month} , ${display_time}",style: TextStyle(color: Colors.grey[400],),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom:4.0),
                      child: Icon(
                        Icons.calendar_today,
                        color: Colors.grey[400],
                        size: 18.0,
                        semanticLabel: 'Text to announce in accessibility modes',
                      ),
                    ),
                  ],
                ),
              ):Container(),
              is_imgs_load==true?Padding(
                padding: const EdgeInsets.only(right:16.0,top:6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[

                    Padding(
                      padding: const EdgeInsets.only(right:8.0,bottom: 0),
                      //address
                      child: Text("${res_final['address']}",style: TextStyle(color: Colors.grey[400],),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom:4.0),
                      child: Icon(
                        Icons.pin_drop,
                        color: Colors.grey[400],
                        size: 18.0,
                        semanticLabel: 'Text to announce in accessibility modes',
                      ),
                    ),
                  ],
                ),
              ):Container(),
              Divider(color: Colors.grey[400],thickness: 0.2,),
              is_imgs_load==true?Padding(
                padding: const EdgeInsets.only(right:16.0,top:6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[

                    Padding(
                      padding: const EdgeInsets.only(right:8.0,bottom: 12),
                      //address
                      child: Text("${res_final['trainerName']}",style: TextStyle(color: Colors.grey[400],),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom:4.0),
                      child:CircleAvatar(
                        radius:  20,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(  Radius.circular(58)),
                              border: Border.all(width: 3,color: Colors.white,style: BorderStyle.solid)
                          ),
                          child: ClipOval(
                            child:  FadeInImage.assetNetwork(
                              placeholderScale: 25,
                              width: MediaQuery.of(context).size.width,
                              placeholder: 'assets/doctor.png',
                              image:  res_final['trainerImg'].toString(),//result['item']['image_path'].toString()
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ):Container(),
              Padding(
                padding: const EdgeInsets.only(right:22.0,bottom: 12),
                child: is_imgs_load==true?Text("${res_final['trainerInfo']}",style: TextStyle(color: Colors.grey[400],)):Container(),
              ),
              Divider(color: Colors.grey[400],thickness: 0.2,),
              Padding(
                padding: const EdgeInsets.only(right:22.0,bottom: 12),
                child: Text("عن الدوره",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w400)),
              ),
              Padding(
                padding: const EdgeInsets.only(right:22.0,bottom: 12),
                child: is_imgs_load==true?Text("${res_final['occasionDetail']}",style: TextStyle(color: Colors.grey[400],),textDirection: TextDirection.rtl,):Container(),
              ),
              Divider(color: Colors.grey[400],thickness: 0.2,),
              Padding(
                padding: const EdgeInsets.only(right:22.0,bottom: 4),
                child: Text("تكلفه الدوره",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w400)),
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left:16.0),
                    child: Text("40 SAR",style: TextStyle(color: Colors.grey[400],fontSize: 16),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right:16.0),
                    child: Text("الحجز العادى",style: TextStyle(color: Colors.grey[400],fontSize: 16),),
                  ),

                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left:16.0),
                    child: Text("80 SAR",style: TextStyle(color: Colors.grey[400],fontSize: 16),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right:16.0),
                    child: Text("الحجز المميز",style: TextStyle(color: Colors.grey[400],fontSize: 16),),
                  ),

                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  is_imgs_load==true? Padding(
                    padding: const EdgeInsets.only(left:16.0),
                    child: Text("${res_final['price'].toString()} SAR",style: TextStyle(color: Colors.grey[400],fontSize: 16),),
                  ):Container(),
                  Padding(
                    padding: const EdgeInsets.only(right:16.0),
                    child: Text("الحجز السريع",style: TextStyle(color: Colors.grey[400],fontSize: 16),),
                  ),

                ],
              ), Padding(
                padding: const EdgeInsets.only(top:12.0),
                child: RaisedButton(
                  color: Colors.purple,
                    onPressed: () {},
                    textColor: Colors.white,
                    child: Container(
                      height: 50,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.purple,
                      child: Center(child: Text("قم بالحجز الان"),),
                    )
                ),
              )






            ])
      ],
    ));
  }
}

class CarouselDemo extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    //Manually operated Carousel
    final CarouselSlider manualCarouselDemo = CarouselSlider(
      items: child,
      autoPlay: false,
      enlargeCenterPage: true,
      viewportFraction: 0.9,
      aspectRatio: 2.0,
    );

    //Auto playing carousel
    final CarouselSlider autoPlayDemo = CarouselSlider(
      viewportFraction: 0.9,
      aspectRatio: 2.0,
      autoPlay: true,
      enlargeCenterPage: true,
      items: imgList.map(
            (url) {
          return Container(
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              child: Image.network(
                url,
                fit: BoxFit.cover,
                width: 1000.0,
              ),
            ),
          );
        },
      ).toList(),
    );

    //Button controlled carousel


    //Pages covers entire carousel
    final CarouselSlider coverScreenExample = CarouselSlider(
      viewportFraction: 1.0,
      aspectRatio: 2.0,
      autoPlay: false,
      enlargeCenterPage: false,
      items: map<Widget>(
        imgList,
            (index, i) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: NetworkImage(i), fit: BoxFit.cover),
            ),
          );
        },
      ),
    );

    //User input pauses carousels automatic playback
    final CarouselSlider touchDetectionDemo = CarouselSlider(
      viewportFraction: 0.9,
      aspectRatio: 2.0,
      autoPlay: true,
      enlargeCenterPage: true,
      pauseAutoPlayOnTouch: Duration(seconds: 3),
      items: imgList.map(
            (url) {
          return Container(
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              child: Image.network(
                url,
                fit: BoxFit.cover,
                width: 1000.0,
              ),
            ),
          );
        },
      ).toList(),
    );

    //Non-looping manual Carousel
    final CarouselSlider nonLoopingCarousel = CarouselSlider(
      items: child,
      scrollPhysics: BouncingScrollPhysics(),
      enableInfiniteScroll: false,
      autoPlay: false,
      enlargeCenterPage: true,
      viewportFraction: 0.9,
      aspectRatio: 2.0,
    );

    //Vertical carousel
    final CarouselSlider verticalScrollCarousel = CarouselSlider(
      scrollDirection: Axis.vertical,
      aspectRatio: 2.0,
      autoPlay: true,
      enlargeCenterPage: true,
      viewportFraction: 0.9,
      pauseAutoPlayOnTouch: Duration(seconds: 3),
      items: imgList.map(
            (url) {
          return Container(
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              child: Image.network(
                url,
                fit: BoxFit.cover,
                width: 1000.0,
              ),
            ),
          );
        },
      ).toList(),
    );

    //create full screen Carousel with context




    return MaterialApp(
      title: 'Task',
        theme: ThemeData(
          fontFamily: 'AvenirNext',
        ),
      home: Scaffold(

        body: Column(
          children: <Widget>[

              CarouselWithIndicator()

          ],
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}