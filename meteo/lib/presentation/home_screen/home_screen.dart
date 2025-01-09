import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiwi/kiwi.dart';
import 'package:meteo/logic/blocs/meteo/meteo_bloc.dart';
import 'package:meteo/presentation/home_screen/widgets/current_weather_widget.dart';
import 'package:meteo/presentation/home_screen/widgets/my_drawer.dart';
import 'package:meteo/presentation/home_screen/widgets/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isDrawerOpen = false;

  final MeteoBloc meteoBloc = KiwiContainer().resolve("meteoBloc");

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeteoBloc, MeteoState>(
      bloc: meteoBloc,
      builder: (context, state) {
        return Scaffold(
          onDrawerChanged: (isOpened) {
            setState(() {
              isDrawerOpen = isOpened;
            });
          },
          resizeToAvoidBottomInset: false,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: !meteoBloc.state.isSearching,
            actions: meteoBloc.state.isSearching
                ? []
                : [
                    IconButton(
                        onPressed: () {
                          if (meteoBloc.state.isCitySaved) {
                            meteoBloc.add(
                                DeleteCityEvent(id: meteoBloc.state.data!.id));
                          } else {
                            meteoBloc.add(const AddCityEvent());
                          }
                        },
                        icon: Icon(
                          Icons.favorite,
                          color:
                              meteoBloc.state.isCitySaved ? Colors.red : null,
                        )),
                    IconButton(
                        onPressed: () {
                          meteoBloc.add(const ToggleSearching());
                        },
                        icon: const Icon(Icons.search))
                  ],
            title: meteoBloc.state.isSearching
                ? Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      const SearchCityBar(),
                      IconButton(
                          onPressed: () {
                            meteoBloc.add(const ToggleSearching());
                          },
                          icon: const Icon(Icons.close))
                    ],
                  )
                : BlocBuilder<MeteoBloc, MeteoState>(
                    builder: (context, state) {
                      return state.data == null
                          ? const Text("Météo")
                          : Text(state.data!.name.isEmpty
                              ? "Météo"
                              : state.data!.name);
                    },
                  ),
          ),
          drawer: Drawer(
            backgroundColor: Colors.black.withOpacity(0.4),
            child: const MyDrawer(),
          ),
          body: BlocBuilder<MeteoBloc, MeteoState>(
            builder: (context, state) {
              return Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/background.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: state.data == null
                      ? SizedBox(
                          height: ScreenUtil().screenHeight,
                          child: Center(
                            child: Container(
                              margin: const EdgeInsets.all(4),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.45),
                                  borderRadius: BorderRadius.circular(12)),
                              child: const Text(
                                "Rechercher une ville pour voir la météo",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top,
                          ),
                          child: ImageFiltered(
                            imageFilter: ImageFilter.blur(
                                sigmaX:
                                    meteoBloc.state.isSearching || isDrawerOpen
                                        ? 3
                                        : 0,
                                sigmaY:
                                    meteoBloc.state.isSearching || isDrawerOpen
                                        ? 3
                                        : 0),
                            child: CurrentWeatherWidget(
                              meteo: state.data!,
                            ),
                          ),
                        ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
