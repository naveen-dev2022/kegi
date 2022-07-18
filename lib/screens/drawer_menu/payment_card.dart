import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PaymentCards extends StatelessWidget {
  const PaymentCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(50)),
              child: const Padding(
                padding: EdgeInsets.only(left: 5),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 15,
                  color: Colors.black,
                ),
              )),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Payment Cards',
          style: TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontFamily: 'montserrat_medium',
              fontWeight: FontWeight.w700),
        ),
      ),
      body: Container(
        height: 100.h,
        width: 100.w,
        padding: EdgeInsets.only(left: 15,right: 15),
        child: Column(
          children: [
            SizedBox(
              height: 2.h,
            ),
            Row(
              children: [
                Image.asset('assets/images/visa.png'),
                SizedBox(width: 4,),
                Text('**** **** **** 1234'),
                Expanded(
                  child: SizedBox(),
                ),
                IconButton(
                    onPressed: () {}, icon: Image.asset('assets/images/delete.png'))
              ],
            ),
            Divider(),
            Row(
              children: [
                Image.asset('assets/images/mastercard_icon.png'), Image.asset('assets/images/mastercard_icon1.png'),
                SizedBox(width: 4,),
                Text('**** **** **** 1234'),
                Expanded(
                  child: SizedBox(),
                ),
                IconButton(
                    onPressed: () {}, icon: Image.asset('assets/images/delete.png'))
              ],
            ),
            Divider(),
            ListTile(
              onTap: () {
                showModalBottomSheet(
                    backgroundColor: Colors.grey.shade300,
                    isDismissible: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    context: context,
                    builder: (builder) {
                      return StatefulBuilder(
                        builder: (BuildContext contex, setter) {
                          return FractionallySizedBox(
                            heightFactor: 1.0,
                            child: Container(
                                color: Colors.transparent,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              Icons.cancel,
                                              color: Colors.grey.shade800,
                                            ),
                                            onPressed: () {},
                                          ),
                                          Text(
                                            'Add New Card',
                                            style: TextStyle(
                                                fontFamily: 'montserrat_bold',
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: 20,
                                            height: 1,
                                          ),
                                        ],
                                      ),
                                      Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              color: Colors.white,
                                            ),
                                            height: 25.h,
                                            width: 100.w,
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    color:
                                                        const Color(0xffe7e7e7),
                                                    height: 45,
                                                    width: double.infinity,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10,
                                                            right: 10),
                                                    child: TextFormField(
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontFamily:
                                                              'montserrat_Medium'),
                                                      keyboardType:
                                                          TextInputType.text,
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .only(top: 5),
                                                        border:
                                                            const OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide
                                                                        .none),
                                                        hintText: 'Card number',
                                                        hintStyle: const TextStyle(
                                                            fontFamily:
                                                                'montserrat_Medium',
                                                            fontSize: 12,
                                                            color: Colors.grey),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Container(
                                                        color: const Color(
                                                            0xffe7e7e7),
                                                        height: 45,
                                                        width: 200,
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 10,
                                                                right: 10),
                                                        child: TextFormField(
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'montserrat_Medium'),
                                                          keyboardType:
                                                              TextInputType
                                                                  .text,
                                                          decoration:
                                                              InputDecoration(
                                                                  contentPadding:
                                                                      const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              5),
                                                                  border: const OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide
                                                                              .none),
                                                                  hintText:
                                                                      'Expiry date (mm/yy)',
                                                                  hintStyle: const TextStyle(
                                                                      fontFamily:
                                                                          'montserrat_Medium',
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .grey),
                                                                  suffixIcon:
                                                                      IconButton(
                                                                    onPressed:
                                                                        () {},
                                                                    icon:
                                                                        const Icon(
                                                                      Icons
                                                                          .info_outline,
                                                                      color: Colors
                                                                          .grey,
                                                                      size: 19,
                                                                    ),
                                                                  )),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 8,
                                                              top: 8,
                                                              bottom: 8),
                                                      child: Container(
                                                        color: const Color(
                                                            0xffe7e7e7),
                                                        height: 45,
                                                        width: 130,
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 10,
                                                                right: 10),
                                                        child: TextFormField(
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'montserrat_Medium'),
                                                          keyboardType:
                                                              TextInputType
                                                                  .text,
                                                          decoration:
                                                              InputDecoration(
                                                                  contentPadding:
                                                                      const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              5),
                                                                  border: const OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide
                                                                              .none),
                                                                  hintText:
                                                                      'cvv',
                                                                  hintStyle: const TextStyle(
                                                                      fontFamily:
                                                                          'montserrat_Medium',
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .grey),
                                                                  suffixIcon:
                                                                      IconButton(
                                                                    onPressed:
                                                                        () {},
                                                                    icon:
                                                                        const Icon(
                                                                      Icons
                                                                          .info_outline,
                                                                      color: Colors
                                                                          .grey,
                                                                      size: 19,
                                                                    ),
                                                                  )),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    color:
                                                        const Color(0xffe7e7e7),
                                                    height: 45,
                                                    width: double.infinity,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10,
                                                            right: 10),
                                                    child: TextFormField(
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontFamily:
                                                              'montserrat_Medium'),
                                                      keyboardType:
                                                          TextInputType.text,
                                                      decoration:
                                                          const InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.only(
                                                                top: 5),
                                                        border:
                                                            OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide
                                                                        .none),
                                                        hintText:
                                                            'Name on card',
                                                        hintStyle: TextStyle(
                                                            fontFamily:
                                                                'montserrat_Medium',
                                                            fontSize: 12,
                                                            color: Colors.grey),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                              'assets/images/american_express.png'),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Image.asset(
                                              'assets/images/paypal.png'),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Image.asset(
                                              'assets/images/visa_card.png'),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Image.asset(
                                            'assets/images/visa_card.png',
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 3.h,
                                      ),
                                      Center(
                                        child: Text(
                                            'Lorem ipsum dolor sit amet, consectetur\nadipiscing elit. Malesuada molestie morbi',
                                            style: TextStyle(
                                                fontFamily: 'montserrat_Medium',
                                                fontSize: 11)),
                                      ),
                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: const Color(0xff6ed1ec),
                                              borderRadius:
                                                  BorderRadius.circular(16)),
                                          height: 40,
                                          width: 100.w,
                                          child: const Center(
                                            child: Text(
                                              'ADD CARD',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily:
                                                      'montserrat_medium',
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          );
                        },
                      );
                    });
              },
              leading: Icon(
                Icons.add,
                size: 18,
                color: Color(0xff6ed1ec),
              ),
              title: Text(
                'Add New Card',
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'montserrat_medium',
                      color: Color(0xff6ed1ec)),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Color(0xff6ed1ec),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
