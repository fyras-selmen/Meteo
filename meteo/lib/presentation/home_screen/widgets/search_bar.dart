import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiwi/kiwi.dart';
import 'package:meteo/data/models/city.dart';
import 'package:meteo/data/repositories/meteo_repository.dart';
import 'package:meteo/logic/blocs/meteo/meteo_bloc.dart';

class SearchCityBar extends StatefulWidget {
  const SearchCityBar({super.key});

  @override
  State<SearchCityBar> createState() => _SearchCityBarState();
}

class _SearchCityBarState extends State<SearchCityBar> {
  MeteoBloc meteoBloc = KiwiContainer().resolve("meteoBloc");
  TextEditingController controller = TextEditingController();
  Future<Iterable<City>> searchCities(String keyword) async {
    MeteoRepository meteoRepository = MeteoRepository();
    final cities = await meteoRepository.searchCities(keyword);
    return cities ?? const Iterable<City>.empty();
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<City>(
      optionsBuilder: (TextEditingValue textEditingValue) async {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<City>.empty();
        }
        return await searchCities(textEditingValue.text);
      },
      optionsViewBuilder: (context, Function(City) onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            shadowColor: Colors.transparent,
            color: Colors.transparent,
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(maxWidth: ScreenUtil().screenWidth * 0.91),
              child: ListView.separated(
                padding: const EdgeInsets.only(top: 10),
                itemBuilder: (context, index) {
                  final option = options.elementAt(index);

                  return InkWell(
                    onTap: () {
                      meteoBloc.add(FetchMeteoEvent(
                          long: option.lon, lat: option.lat, id: 0));
                      meteoBloc.add(const ToggleSearching());
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 20, 14, 14)
                              .withOpacity(0.45),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(6.0))),

                      child: Row(
                        children: [
                          Text(
                            option.name,
                            style:
                                TextStyle(color: Colors.white.withOpacity(0.8)),
                          ),
                          Text(
                            ", ${option.country}",
                            style:
                                TextStyle(color: Colors.white.withOpacity(0.8)),
                          )
                        ],
                      ),
                      // title: Text(option.toString()),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: options.length,
              ),
            ),
          ),
        );
      },
      fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
        this.controller = controller;

        return SizedBox(
          width: ScreenUtil().screenWidth * 0.95,
          child: TextField(
            autofocus: true,
            controller: controller,
            focusNode: focusNode,
            onEditingComplete: onEditingComplete,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.black.withOpacity(0.5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF1E3A78)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF1E3A78)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF1E3A78)),
              ),
              hintText: "Saissisez une ville",
              hintStyle: const TextStyle(color: Color(0xFF1E3A78)),
            ),
          ),
        );
      },
    );
  }
}
