import 'package:flutter/material.dart';
import 'package:sparioapp/Core/Theme/app_colors.dart';

class ProductDetailsPage extends StatefulWidget {
  final String name;
  final String image;

  const ProductDetailsPage({
    super.key,
    required this.name,
    required this.image,
  });

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      // AppBar شفاف فوق الصورة
      appBar: AppBar(
          leading: SizedBox(),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text("Page Details Parts"),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/home");
                },
                icon: Icon(Icons.arrow_forward)),
          ]),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            cardPhotoProduct(context),
            counterButtonsWithNameProduct(context),
            SizedBox(
              height: 20,
            ),
            buttonCompare(context),
            SizedBox(
              height: 20,
            ),
            buttonOrder(context),
          ],
        ),
      ),
    );
  }
}

Widget cardPhotoProduct(BuildContext context) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        Text(
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.start,
                          "صادق الرياني",
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Divider(
                          color: Colors.black,
                        ),
                        Container(
                            padding: EdgeInsets.all(12),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                height: 200,
                                width: 200,
                                "assets/1.JPG",
                                fit: BoxFit.fill,
                              ),
                            )),
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget counterButtonsWithNameProduct(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(33),
                  child: Container(
                    color: Colors.white,
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.remove),
                    ),
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Text(
                  "3",
                  style: TextStyle(
                    fontSize: 19,
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(33),
                  child: Container(
                    color: Colors.orange,
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.add),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Text(
                textAlign: TextAlign.right,
                "صادق الرياني",
                style: TextStyle(
                  fontSize: 19,
                ),
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0),
        child: Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              textAlign: TextAlign.right,
              "القطعة /",
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Text(
              textAlign: TextAlign.right,
              "ريال",
              style: TextStyle(
                fontSize: 17,
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              textAlign: TextAlign.right,
              "10.000 ",
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange),
            ),
          ],
        )),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0),
        child: Divider(
          color: Colors.grey,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              " نوع السيارة : تويوتا-كامري 2023-2024 ",
              style: TextStyle(fontSize: 17, color: Colors.black),
            ),
            Text(
              "hdfkh092834khdf : رقم القطعة",
              style: TextStyle(fontSize: 17, color: Colors.black),
            ),
            Text(
              "نوع القطعة : جديد",
              style: TextStyle(fontSize: 17, color: Colors.black),
            ),
          ],
        ),
      )
    ],
  );
}

Widget buttonCompare(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 44.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.background,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0), side: BorderSide()),
          ),
          child: const Text(
            "مقارنة الاسعار",
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.background,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0), side: BorderSide()),
          ),
          child: const Text(
            "قطع متوافقة",
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
      ],
    ),
  );
}

Widget buttonOrder(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 18.0),
    child: SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, "/orderPage");
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          "طلب القطعة",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    ),
  );
}
