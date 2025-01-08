import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:meteo/logic/blocs/meteo/meteo_bloc.dart';
import 'package:meteo/utils/capitalize.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({
    super.key,
  });

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    MeteoBloc meteoBloc = KiwiContainer().resolve("meteoBloc");

    return BlocBuilder<MeteoBloc, MeteoState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Spacer(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
            (state.favoriteCities ?? []).isEmpty
                ? const Center(
                    child: Text(
                      "No saved cities",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: (state.favoriteCities ?? []).length,
                      itemBuilder: (context, index) {
                        final city = state.favoriteCities![index];
                        return ListTile(
                          trailing: IconButton(
                            icon: Icon(Icons.delete,
                                color: Colors.red.withOpacity(0.55)),
                            onPressed: () {
                              meteoBloc.add(DeleteCityEvent(id: city.id));
                            },
                          ),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          tileColor: Colors.white.withOpacity(0.3),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                city.name,
                                maxLines: 2,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 22),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                      "${city.weather.first.description.capitalize()} | ${city.main.temp.ceil()}°C",
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                          onTap: () {
                            meteoBloc.add(FetchMeteoEvent(
                                long: city.coord.lon,
                                lat: city.coord.lat,
                                id: city.id));
                          },
                        );
                      },
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.white.withOpacity(0.25),
                      ),
                    ),
                  ),
          ],
        );
      },
    );
  }
}
