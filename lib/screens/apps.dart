import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobscan/controllers/apps_controller/cubit/apps_cubit.dart';
import 'package:mobscan/core/appcolors.dart';
import 'package:mobscan/models/app_model.dart';
import 'package:mobscan/screens/threat_detailes.dart';

class Apps extends StatefulWidget {
  const Apps({super.key});

  @override
  State<Apps> createState() => _AppsState();
}

class _AppsState extends State<Apps> {
  @override
  void initState() {
    context.read<AppsCubit>().getApps();
    super.initState();
  }

  CarouselSliderController carouselController = CarouselSliderController();
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<AppsCubit>();
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: Image.asset("assets/Container.png"),
        title: Text(
          "MobScan",
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        forceMaterialTransparency: true,
      ),

      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                controller: searchController,
                onChanged: (value) {
                  context.read<AppsCubit>().search(value);
                },
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 18,
                ),
                decoration: InputDecoration(
                  fillColor: Theme.of(context).colorScheme.surface,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: "Search installed applications...",
                  hintStyle: TextStyle(color: Appcolors.text),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),

            SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: BlocBuilder<AppsCubit, AppsState>(
                builder: (context, state) {
                  return Row(
                    children: [
                      Text(
                        "Total apps :${state.allApps.length}",
                        style: TextStyle(color: Appcolors.text),
                      ),
                      SizedBox(width: 20),
                      Text(
                        "flagged :${cubit.riskyApps.length}",
                        style: TextStyle(color: Appcolors.text),
                      ),
                      Spacer(),
                      Icon(Icons.circle, color: Colors.blue, size: 12),
                      SizedBox(width: 5),
                      Text(
                        "scanning...",
                        style: TextStyle(color: Appcolors.text),
                      ),
                    ],
                  );
                },
              ),
            ),

            SizedBox(height: 20),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _categoryCard("all", 0, carouselController),
                  _categoryCard("safe", 1, carouselController),
                  _categoryCard("Risky", 2, carouselController),
                ],
              ),
            ),

            SizedBox(height: 10),
            Divider(color: Appcolors.searchBarColor),
            SizedBox(height: 10),

            Expanded(
              child: BlocBuilder<AppsCubit, AppsState>(
                builder: (BuildContext context, state) {
                  final cubit = context.read<AppsCubit>();

                  if (state.status == AppStatus.loading) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (state.status == AppStatus.error) {
                    return Center(child: Text("Error"));
                  }

                  if (state.status == AppStatus.success) {
                    return CarouselSlider(
                      carouselController: carouselController,
                      items: [
                        _appsList(
                          state.allApps,
                          cubit.safeApps,
                          cubit.riskyApps,
                        ),
                        _appsList(
                          state.allApps,
                          cubit.safeApps,
                          cubit.riskyApps,
                        ),
                        _appsList(
                          state.allApps,
                          cubit.safeApps,
                          cubit.riskyApps,
                        ),
                      ],
                      options: CarouselOptions(
                        height: double.infinity,
                        enlargeCenterPage: true,
                        viewportFraction: 0.9,
                        scrollDirection: Axis.horizontal,
                        onPageChanged: (index, reason) {
                          context.read<AppsCubit>().navigateToNextPage(index);
                        },
                      ),
                    );
                  }

                  return SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryCard(
    String text,
    int index,
    CarouselSliderController carouselController,
  ) {
    return Expanded(
      child: BlocBuilder<AppsCubit, AppsState>(
        builder: (context, state) {
          bool isSelected = context.read<AppsCubit>().categoryIndex == index;

          return GestureDetector(
            onTap: () {
              context.read<AppsCubit>().navigateToNextPage(index);
              carouselController.animateToPage(
                index,
                duration: Duration(milliseconds: 500),
                curve: Curves.decelerate,
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              margin: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text(text, style: TextStyle(color: Colors.white))],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _appCard(AppModel app) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ThreatDetailScreen()),
          );
        },
        child: ListTile(
          leading: app.icon != null
              ? Image.memory(
                  app.icon!,
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
                )
              : Icon(Icons.apps, color: Colors.white, size: 40),
          title: Text(
            app.name ?? "",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          subtitle: Text(
            app.package ?? "",
            style: TextStyle(color: Appcolors.text),
          ),
          trailing: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${app.riskLevel}%",
                style: TextStyle(
                  color: _riskColors(app.riskLevel ?? 0),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _riskColors(app.riskLevel ?? 0).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  app.riskLevel! > 50 ? "High Risk" : "Safe", // Keep it short!
                  style: TextStyle(
                    color: _riskColors(app.riskLevel ?? 0),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appsList(
    List<AppModel> apps,
    List<AppModel> safeApps,
    List<AppModel> riskyApps,
  ) {
    if (apps.isEmpty) {
      return Center(
        child: Text("No Apps Found", style: TextStyle(color: Appcolors.text)),
      );
    }
    if (riskyApps.isEmpty) {
      return Center(
        child: Text(
          "No Risky Apps Found",
          style: TextStyle(color: Appcolors.text),
        ),
      );
    }
    if (safeApps.isEmpty) {
      return Center(
        child: Text(
          "No Safe Apps Found",
          style: TextStyle(color: Appcolors.text),
        ),
      );
    }

    return ListView.builder(
      itemCount: apps.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: _appCard(apps[index]),
      ),
    );
  }

  Color _riskColors(int riskLevel) {
    if (riskLevel <= 25) return Colors.blue;
    if (riskLevel <= 50) return Colors.orange;
    if (riskLevel <= 75) return Colors.yellow;
    return Colors.red;
  }
}
