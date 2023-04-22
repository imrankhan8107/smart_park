import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:parking_app/screens/selectTimes.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class BookSlotScreen extends StatefulWidget {
  const BookSlotScreen({super.key});

  @override
  State<BookSlotScreen> createState() => _BookSlotScreenState();
}

class _BookSlotScreenState extends State<BookSlotScreen> {
  int hrsPrice = 200;
  double minutesPrice = 200 / 60;
  double totalCost = 0.0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _razorpay = Razorpay();
  Map<int, String>? slots;
  String payment = "Failed";
  int slotNo = 1;
  Duration? duration;

  // void addSlots() async{
  //   for(int i=1;i<=40;i++){
  //     _firestore.collection("Slots").doc("${i}").set({
  //       "slotNumber":i,
  //       "bookingStatus":"Available"
  //     });
  //   }
  //
  // }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    // Do something when payment succeeds
    setState(() {
      payment = "Success";
    });
    Fluttertoast.showToast(msg: 'Payment Success');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text("Booked Slot Successfully"),
        );
      },
    );

    await _firestore
        .collection("Slots")
        .doc("$slotNo")
        .update({"bookingStatus": "Booked"}); // Add SetOptions parameter

    await _firestore
        .collection("BookedSlots")
        .doc("$slotNo")
        .set({
      "slotNumber": slotNo,
      "uid": _auth.currentUser!.uid,
      "bookingTime": DateTime.now(),
      "slotTime": DateTime.now().add(duration!),
    });

    setState(() {
      getSlots();
    });
  }


  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    setState(() {
      payment = "Failed";
    });
    Fluttertoast.showToast(msg: 'Payment Failed');
  }


  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected

  }

  void getSlots() async {
    QuerySnapshot snapshot =
        await _firestore.collection('Slots').orderBy("slotNumber").get();
    Map<int, String> Slots = {};
    for (int i = 0; i < snapshot.docs.length; i++) {
      var ele = snapshot.docs[i];
      Slots[ele.get("slotNumber")] = ele.get("bookingStatus");
    }
    setState(() {
      slots = Slots;
    });
  }



  Widget parkingSlot(int slotnumber, String bookingstatus) {
    Widget view;
    if (bookingstatus == "Booked") {
      view = Image.asset("images/car_img.png");
    } else {
      view = Text("$slotnumber");
    }
    return Expanded(
      flex: 2,
      child: GestureDetector(
        onTap: () async {
          if (bookingstatus == "Booked") {
            _firestore.collection("Slots").doc("$slotnumber").update({"bookingStatus":"Available"});
            setState(() {
              getSlots();
            });
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const AlertDialog(
                    title: Text("Slot Already Booked, Pick Another Slot"),
                  );
                });
          } else {
            final result = await showDialog<TimeOfDay>(
              context: context,
              builder: (_) => TimeInputDialog(),
            );
            if (result != null) {
              final hours = result.hour;
              final minutes = result.minute;
              // Do something with the hours and minutes
              duration = Duration(hours: hours, minutes: minutes);
              totalCost = totalCost + hours * hrsPrice + minutes * minutesPrice;
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Confirm Booking?"),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          var options = {
                            'key': 'rzp_test_W8ouhkUI8IPXiQ',
                            'amount': '${totalCost * 100}00',
                            'name': _auth.currentUser!.uid,
                            "currency": "INR",
                            'prefill': {
                              'email': '${_auth.currentUser!.email}',
                            }
                          };
                          try {
                            _razorpay.open(options);
                            setState(() {
                              slotNo = slotnumber;
                            });
                            _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
                          } catch (e) {
                            _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
                            // Fluttertoast.showToast(msg: e.toString());
                            payment = "Failed";
                          }
                          // if (payment == "Success") {
                          //
                          //   await _firestore
                          //       .collection("Slots")
                          //       .doc("$slotnumber")
                          //       .update({"bookingStatus": "Booked"});
                          //   await _firestore
                          //       .collection("BookedSlots")
                          //       .doc("$slotnumber")
                          //       .set({
                          //     "slotNumber": slotnumber,
                          //     "uid": _auth.currentUser!.uid,
                          //     "bookingTime": DateTime.now(),
                          //     "slotTime": DateTime.now().add(duration),
                          //   });
                          //   setState(() {
                          //     getSlots();
                          //   });
                          //
                          // }
                        },
                        child: const Text("Yes"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("No"),
                      ),
                    ],
                  );
                },
              );
            }
          }
        },
        child: Container(
          height: 100.0,
          decoration: bookingstatus == "Booked"
              ? BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                )
              : BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8.0),
                ),
          child: Center(
            child: view,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSlots();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    if(slots==null){
      return Scaffold(
          appBar: AppBar(
            title: const Text('Book Slot'),
            actions: [
              // TextButton(onPressed: (){}, child: Text("My Slots",style: TextStyle(color: Colors.cyanAccent),)),
              TextButton(
                  onPressed: () {
                    _auth.signOut();
                  },
                  child: const Text(
                    "Log Out",
                    style: TextStyle(color: Colors.cyanAccent),
                  ))
            ],
          ),
          body: const Center(child: CircularProgressIndicator()),);
    }else{
      return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Book Slot'),
              actions: [
                // TextButton(onPressed: (){}, child: Text("My Slots",style: TextStyle(color: Colors.cyanAccent),)),
                TextButton(
                    onPressed: () {
                      _auth.signOut();
                    },
                    child: const Text(
                      "Log Out",
                      style: TextStyle(color: Colors.cyanAccent),
                    ))
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Car Park',
                    style: TextStyle(
                      fontSize: 50.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Text(
                    'Please select suitable place for \nparking in the zone',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 20,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              parkingSlot(slots!.keys.elementAt(index),
                                  slots!.values.elementAt(index)),
                              Expanded(flex: 1, child: Container()),
                              parkingSlot(slots!.keys.elementAt(index + 20),
                                  slots!.values.elementAt(index + 20))
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )),
      );
    }
  }
}
