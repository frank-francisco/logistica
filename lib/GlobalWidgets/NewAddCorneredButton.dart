import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

newAddCorneredButton(
  String txt,
  IconData iconInfo,
) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(
        color: Color(0xff1287c3),
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(8),
      ),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.all(
        Radius.circular(8),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Color(0xff1287c3),
                    child: CircleAvatar(
                      radius: 23,
                      //backgroundColor: Color(0xffFDCF09),
                      backgroundColor: Colors.blueGrey,
                      child: Center(
                        child: Icon(
                          iconInfo,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(),
              ),
              Text(
                txt,
                textAlign: TextAlign.start,
                style: GoogleFonts.quicksand(
                  fontSize: 16,
                  //fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  letterSpacing: .5,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
