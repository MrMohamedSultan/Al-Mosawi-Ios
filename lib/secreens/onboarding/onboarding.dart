import 'package:ahmad_pro/constants/constans.dart';
import 'package:ahmad_pro/constants/themes.dart';
import 'package:ahmad_pro/models/userData.dart';
import 'package:ahmad_pro/secreens/authenticate/authenticate.dart';
import 'package:ahmad_pro/secreens/onboarding/slider.dart';
import 'package:ahmad_pro/services/network_sensitive.dart';
import 'package:flutter/material.dart';

class OnBoard extends StatefulWidget {
  @override
  _OnBoardState createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (User.isOnBording == true) {
      return Authenticate();
    } else {
      return OnBoarding();
    }
  }
}

class OnBoarding extends StatefulWidget {
  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  int _currentPage = 0;
  PageController _controller = PageController();
  List<Widget> _pages = [
    CustomSlider(
      title: ' أ/أحمد الموسوي',
      contant:
          ' محلل فني محترف في الاسواق العالميه خبير في التحليل الفني وغيرها من مدارس هذا التطبيق سيسهل عليك دخولك عالم التداول من البدايه',
      // image: 'lib/icons/back1.svg',
      backImage: 'lib/images/ahmed.jpg',
    ),
    CustomSlider(
      title: 'توصيات وتحليلات احترافيه',
      contant:
          'نسبة نجاح عالية يمكنك الاستفاده من طريقتنا الاحترافيه والتداول براحه من غير خوف وتوتر من خلال Pro Chart',
      image: 'lib/icons/back3.svg',
    ),
    CustomSlider(
      title: ' الدورات التدريبية',
      contant:
          ' اهميه الدورات في عالم الفوركس القليل من يتعلم في هذا السوق. ستتمكن الحصول على اهم الدورات التدريبيه من الصفر الى الاحترافيه',
      image: 'lib/icons/back2.svg',
    ),
    CustomSlider(
      title: 'استشارات خاصه',
      contant:
          'الكثير تكون لديه صفقات مفتوحه او اسئله يريد ان يعرف اجابتها من محترف في الاسواق العالميه يمكنك حجز استشارتك الخاصه',
      image: 'lib/icons/back1.svg',
      // backImage: 'lib/images/ahmed.jpg',
    ),
  ];
  _onChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: NetworkSensitive(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                scrollDirection: Axis.horizontal,
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: _onChanged,
                itemBuilder: (context, int index) {
                  return _pages[index];
                },
              ),
            ),
            SliderContoler(
              pages: _pages,
              currentPage: _currentPage,
              controller: _controller,
            ),
          ],
        ),
      ),
    );
  }
}

class SliderContoler extends StatelessWidget {
  const SliderContoler({
    Key key,
    @required List<Widget> pages,
    @required int currentPage,
    @required PageController controller,
  })  : _pages = pages,
        _currentPage = currentPage,
        _controller = controller,
        super(key: key);

  final List<Widget> _pages;
  final int _currentPage;
  final PageController _controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List<Widget>.generate(
            _pages.length,
            (int index) {
              return AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: 10,
                width: (index == _currentPage) ? 30 : 10,
                margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: (index == _currentPage)
                      ? Colors.green
                      : Colors.green.withOpacity(0.5),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  if (_currentPage == (_pages.length - 1)) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => Authenticate(),
                      ),
                    );
                  } else {
                    _controller.nextPage(
                      duration: Duration(milliseconds: 600),
                      curve: Curves.easeInOutQuint,
                    );
                  }
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: 40,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: customColor,
                  ),
                  child: (_currentPage == (_pages.length - 1))
                      ? Center(
                          child: Text(
                            'ابدا',
                            style:
                                AppTheme.heading.copyWith(color: Colors.white),
                          ),
                        )
                      : Center(
                          child: Text(
                            'التالي',
                            style:
                                AppTheme.heading.copyWith(color: Colors.white),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
