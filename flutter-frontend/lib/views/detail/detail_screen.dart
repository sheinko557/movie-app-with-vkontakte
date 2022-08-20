import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie/models/response_model.dart';
import 'package:movie/presenter/service.dart';
import 'package:movie/views/video_player/video_player.dart';
import 'package:movie/views/widgets/app_bar.dart';
import 'package:movie/views/widgets/cache_image.dart';
import 'package:movie/views/widgets/loading.dart';

class DetailScreen extends StatefulWidget {
  final Map movieDetails;
  final String fromPage;
  DetailScreen(this.movieDetails, this.fromPage);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {

  Service service = Service();
  ResponseModel resData;
  String videoUrl;
  String posterUrl;
  String view;

  @override
  void initState() {
    super.initState();
    // getPost();
  }

  getPost() async{
    resData = await service.getPost(widget.movieDetails['id']);
    if(resData.status == 200){
      view = resData.data['total_view'];
      videoUrl = resData.data['source'];
      posterUrl = resData.data['image'];
    }
    else{
      loading(context, 1, 'Details', "Something went wrong. Please try again.");
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return WillPopScope(
      onWillPop: (){
        if(resData != null){
          Navigator.pop(context, resData.data);
        }
        else{
          Navigator.pop(context);
        }
        return ;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        // appBar: appBar(context, widget.movieDetails['title']),
        appBar : AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).backgroundColor,
          leading: Builder(builder: (BuildContext context) {
            return IconTheme(
              data: Theme.of(context).iconTheme,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: (){
                  if(resData != null){
                    Navigator.pop(context, resData.data);
                  }
                  else{
                    Navigator.pop(context);
                  }
                },
              )
            );
          }),
          title: Text(
            widget.movieDetails['title'],
            style: Theme.of(context).textTheme.headline6.copyWith(
              fontFamily: 'FiraSans',
              fontWeight: FontWeight.bold
            ),
          ),
          // title: Image.asset(
          //   'assets/images/dm_app_bar.png',
          //   height: 20.0,
          // ),
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  BackdropImage(widget.movieDetails['image']),
                  _buildWidgetFloatingActionButton(mediaQuery),
                  // _buildWidgetIconBuyAndShare(mediaQuery),
                ],
              ),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    _buildWidgetTitleMovie(context),
                    SizedBox(height: 16.0),
                    _buildWidgetShortDescriptionMovie(context),
                    SizedBox(height: 16.0),
                    _buildWidgetSynopsisMovie(context),
                    SizedBox(height: 16.0),
                    // _buildWidgetScreenshots(mediaQuery, context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWidgetFloatingActionButton(MediaQueryData mediaQuery) {
    return Column(
      children: <Widget>[
        SizedBox(height: mediaQuery.size.height / 3.0 - 60),
        Center(
          child: FloatingActionButton(
            onPressed: () async {
              loading(context, 0, null, null);
              await getPost();
              Navigator.pop(context);
              if(videoUrl != null || posterUrl != null){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                  return VideoPlayer(videoUrl, posterUrl);
                }));
                setState(() {});
              }
            },
            child: Icon(
              Icons.play_arrow,
              color: Theme.of(context).brightness == Brightness.light  ? Colors.white : Colors.black,
              size: 32.0,
            ),
            // : CircularProgressIndicator(
            //   strokeWidth: 3,
            //   valueColor: AlwaysStoppedAnimation<Color>(
            //     Theme.of(context).brightness == Brightness.light  ? Colors.white : Colors.black
            //   ),
            // ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildWidgetTitleMovie(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Center(
        child: Text(
          widget.movieDetails['title'],
          style: Theme.of(context).textTheme.title.copyWith(
            fontFamily: 'FiraSans'
          ),
          textAlign: TextAlign.justify,
        ),
      ),
    );
  }

  Widget _buildWidgetShortDescriptionMovie(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Category\n',
                  style: Theme.of(context).textTheme.subtitle.copyWith(
                    fontFamily: 'FiraSans'
                  ),
                ),
                TextSpan(
                  text: widget.fromPage == 'home' ? widget.movieDetails['category'][0]['name'] : widget.movieDetails['category'],
                  style: Theme.of(context).textTheme.subtitle.merge(
                    TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      fontFamily: 'FiraSans'
                    ),
                  ),
                ),
              ],
            ),
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Views\n',
                  style: Theme.of(context).textTheme.subtitle.copyWith(
                    fontFamily: 'FiraSans'
                  ),
                ),
                TextSpan(
                  text: view ?? widget.movieDetails['total_view'].toString(),
                  style: Theme.of(context).textTheme.subtitle.merge(
                    TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'FiraSans',
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Duration\n',
                  style: Theme.of(context).textTheme.subtitle.copyWith(
                    fontFamily: 'FiraSans'
                  ),
                ),
                TextSpan(
                  text: widget.movieDetails['duration'] + ' mins',
                  style: Theme.of(context).textTheme.subtitle.merge(
                    TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      fontFamily: 'FiraSans'
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetSynopsisMovie(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Center(
        child: Text(
          widget.movieDetails['description'],
          style: Theme.of(context).textTheme.bodyText1.copyWith(
            fontFamily: 'FiraSans'
          ),
          textAlign: TextAlign.justify,
        ),
      ),
    );
  }

  Widget _buildWidgetScreenshots(MediaQueryData mediaQuery, BuildContext context) {
    var listScreenshotsMovie = widget.movieDetails['screenshots'];
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Text(
                  'Screenshots',
                  style: Theme.of(context).textTheme.subhead.merge(
                        TextStyle(fontWeight: FontWeight.bold),
                      ),
                ),
              ),
              Icon(Icons.chevron_right),
            ],
          ),
        ),
        SizedBox(height: 8.0),
        Container(
          width: mediaQuery.size.width,
          height: 100.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.only(
                  left: 16.0,
                  right: index == listScreenshotsMovie.length - 1 ? 16.0 : 0.0,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: cacheImage(
                    context, 
                    listScreenshotsMovie[index],
                    width: 200
                  ),
                  // child: Image.asset(
                  //   listScreenshotsMovie[index],
                  //   fit: BoxFit.cover,
                  // ),
                ),
              );
            },
            itemCount: listScreenshotsMovie.length,
          ),
        ),
      ],
    );
  }

  Widget _buildWidgetIconBuyAndShare(MediaQueryData mediaQuery) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: mediaQuery.size.height / 2 - 40,
          ),
          Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Icon(Icons.add),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Icon(Icons.share),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetRating() {
    return Center(
      child: RatingBar.builder(
        initialRating: 4.0,
        itemCount: 5,
        allowHalfRating: true,
        direction: Axis.horizontal,
        itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
        itemBuilder: (BuildContext context, int index) {
          return Icon(
            Icons.star,
            color: Theme.of(context).primaryColor,
          );
        },
        tapOnlyMode: true,
        itemSize: 24.0,
        unratedColor: Colors.black,
        onRatingUpdate: (rating) {
          /* Nothing to do in here */
        },
      ),
    );
  }
}

class BackdropImage extends StatelessWidget {
  final String backdropPath;

  BackdropImage(this.backdropPath);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return ClipPath(
      child: cacheImage(
        context, 
        backdropPath,
        height: mediaQuery.size.height / 3,
        width: mediaQuery.size.width,
      ),
      clipper: BottomWaveClipper(),
    );
  }
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 70.0);

    var firstControlPoint = Offset(size.width / 2, size.height);
    var firstEndPoint = Offset(size.width, size.height - 70.0);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    path.lineTo(size.width, size.height - 70.0);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
