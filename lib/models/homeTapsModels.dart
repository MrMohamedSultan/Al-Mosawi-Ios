class HomeTapsModels {
  final String titleAr;
  final String titleEn;
  final String image;

  HomeTapsModels({this.titleAr, this.titleEn, this.image});
}

List<HomeTapsModels> lsitOfTapsData = [
  HomeTapsModels(
    image: 'lib/images/consulantent.png',
    titleAr: 'المدونة',
    titleEn: 'The Blog',
  ),
  HomeTapsModels(
    image: 'lib/images/courses.png',
    titleAr: 'الدورات التدربية',
    titleEn: 'Courses',
  ),
  HomeTapsModels(
    image: 'lib/images/eventicons.png',
    titleAr: 'برو شارت',
    titleEn: 'Pro Chart',
  ),
];
