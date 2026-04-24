class AppModel {
  final String image;
  final String name;
  final String package;
  final String risk;
  final int riskLevel;

  AppModel({
    required this.image,
    required this.name,
    required this.package,
    required this.risk,
    required this.riskLevel,
  });
  static List<AppModel> apps = [
    AppModel(
      image: "assets/swiftpay.png",
      name: "SwiftPay Global",
      package: "com.swiftpay.main",
      risk: "High risk",
      riskLevel: 94,
    ),
    AppModel(
      image: "assets/lensapp.png",
      name: "Lens Filter pro",
      package: "io.lensfilter.android",
      risk: "Medium",
      riskLevel: 42,
    ),
    AppModel(
      image: "assets/Calendar App Icon.png",
      name: "Enterprise Calender",
      package: "com.corp.calendar",
      risk: "Safe",
      riskLevel: 2,
    ),
    AppModel(
      image: "assets/Messaging App Icon.png",
      name: "TeamSync chat",
      package: "chat.corp.mobile",
      risk: "Safe",
      riskLevel: 5,
    ),
    AppModel(
      image: "assets/Cryepto.png",
      name: "Cyrpto Master X",
      package: "net.cryptomaster.free",
      risk: "High risk",
      riskLevel: 88,
    ),
    AppModel(
      image: "assets/Tool App Icon.png",
      name: "System Optimizer",
      package: "com.sys.optimizer.tools",
      risk: "Medium ",
      riskLevel: 56,
    ),
  ];
}
