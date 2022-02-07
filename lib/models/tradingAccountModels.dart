class TradingAccountModels {
  final String name;
  final String contant;
  final String icon;

  TradingAccountModels({this.name, this.contant, this.icon});
}

List<TradingAccountModels> accountList = [
  TradingAccountModels(
    name: 'تحليل أسبوعي',
    contant:
        'عند فتح حساب عن طريق أحمد الموسوي ستحصل على ميزة التحليل الأسبوعي حيث يتم تزويدك بمناطق البيع والشراء للعملات والذهب والأسواق الأمريكية عن طريق التلغرام (كل اسبوع يوم الأحد).',
    icon: 'https://ahmadalmosawi.com/wp-content/uploads/2020/09/taxes-1.png',
  ),
  TradingAccountModels(
    name: 'خصومات خاصة',
    contant:
        'اذا تم فتح حساب اقل من\$5000 ستحصل على 15% واذا فتحت فوق\$5000 ستكون لك خصومات خاصه واقوى وسيتم تواصل معك',
    icon: 'https://ahmadalmosawi.com/wp-content/uploads/2020/09/Group.png',
  ),
  TradingAccountModels(
    name: 'جروب تيليجرام',
    contant:
        'عند اشتراكك في تيك ميل سنقوم بإضافتك إلى جروب في التيليجرام دوانية بوجود أحمد الموسوي حيث يتم مناقشة أوضاع الأسواق ومشاركة النصائح وطرح الأفكار.',
    icon: 'https://ahmadalmosawi.com/wp-content/uploads/2020/09/telegram-1.png',
  ),
];
