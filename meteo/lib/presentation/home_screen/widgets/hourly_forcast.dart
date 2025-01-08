// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HourlyForcast extends StatelessWidget {
  final List<String> times;
  final List<double> temperatures;
  const HourlyForcast(
      {super.key, required this.temperatures, required this.times});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              // Change to transparent on scroll
              color: Colors.black.withOpacity(0.4))),
      padding: const EdgeInsets.all(12),
      child: SizedBox(
        height: ScreenUtil().scaleHeight * 110,
        width: ScreenUtil().screenWidth * 90,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: 24,
          itemBuilder: (context, index) => Row(
            children: [
              Column(
                children: [
                  Text(times[index].substring(11)),
                  const SizedBox(height: 10),
                  Icon(
                    index > 5 && index < 20
                        ? Icons.wb_sunny
                        : Icons.nightlight_round_sharp,
                  ),
                  const SizedBox(height: 10),
                  Text("${temperatures[index].ceil()}˚C"),
                  const SizedBox(height: 10),
                ],
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }
}
