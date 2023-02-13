import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inverntry/constants.dart';
import 'package:inverntry/models/product_model.dart';
import 'package:inverntry/screens/user/confirm_screen.dart';

class ProductUserDetails extends StatefulWidget {
  const ProductUserDetails({required this.productModel, Key? key}) : super(key: key);

  final ProductModel productModel;

  @override
  State<ProductUserDetails> createState() => _ProductUserDetailsState();
}

class _ProductUserDetailsState extends State<ProductUserDetails> {
  int quantity = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leadingWidth: 0.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey.shade300,
              radius: 20.0,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: kDarkGreenColor,
                  size: 24.0,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.42,
              color: kSpiritedGreen,
              padding: const EdgeInsets.only(top: 40.0),
              child: Hero(
                tag: widget.productModel.name,
                child: Image.network(widget.productModel.urlImage),
              ),
            ),
            Container(
              color: kSpiritedGreen,
              //height: MediaQuery.of(context).size.height * 0.58,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.productModel.name,
                              textAlign: TextAlign.start,
                              style: GoogleFonts.poppins(
                                fontSize: 28.0,
                                fontWeight: FontWeight.w600,
                                color: kDarkGreenColor,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Row(
                              children: [
                                Text(widget.productModel.expTime,
                                  style: TextStyle(
                                    color: Colors.green.shade600,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                StarRating(
                                  stars: 5,
                                  size: 16.0,
                                  onChanged: (value) {},
                                )
                              ],
                            ),
                            Text(
                              widget.productModel.quantity,
                              textAlign: TextAlign.start,
                              style: GoogleFonts.poppins(
                                fontSize: 28.0,
                                fontWeight: FontWeight.w600,
                                color: kDarkGreenColor,
                              ),
                            ),
                          ],
                        ),
                        QuantitySelector(
                          min: (int.parse(widget.productModel.quantity)==0)?0:1,
                          max: int.parse(widget.productModel.quantity),
                          initial: (int.parse(widget.productModel.quantity)==0)?0:1,
                          onChanged: (value) {
                            setState(() {
                              quantity = value;
                            });
                          },
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 22.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'About',
                            style: GoogleFonts.poppins(
                              color: kDarkGreenColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 10.0, bottom: 20.0),
                            child: SingleChildScrollView(
                              child: Text(widget.productModel.desc,
                                style: GoogleFonts.poppins(
                                  color: kDarkGreenColor,
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: kDarkGreenColor,
                        elevation: 20.0,
                        textStyle: GoogleFonts.poppins(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.shopping_bag_outlined,
                            size: 24.0,
                          ),
                          SizedBox(width: 10.0),
                          Text(
                            'Order Now',
                          ),
                        ],
                      ),
                      onPressed: () {
                        if(widget.productModel.quantity!='0'){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ConfirmScreen(
                            productModel: widget.productModel,
                            quantity: quantity,
                          )));
                        }else{
                          Fluttertoast.showToast(msg: 'dont quantity equal 0');
                        }

                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class QuantitySelector extends StatefulWidget {
  const QuantitySelector({
    required this.min,
    required this.max,
    required this.initial,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  final int min;
  final int max;
  final int initial;
  final Function(int) onChanged;

  @override
  State<QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  late int quantity;

  @override
  void initState() {
    quantity = widget.initial;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32.0,
      width: 95.0,
      decoration: BoxDecoration(
        color: kDarkGreenColor,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  widget.onChanged(
                      quantity != widget.min ? --quantity : widget.min);
                });
              },
              child: const Icon(
                Icons.remove,
                color: Colors.white,
                size: 18.0,
              ),
            ),
          ),
          Align(
            child: Text(
              '$quantity',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  widget.onChanged(
                      quantity != widget.max ? ++quantity : widget.max);
                });
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 18.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StarRating extends StatelessWidget {
  final int scale;
  final double stars;
  final Color? color;
  final double? size;
  final Function(double)? onChanged;

  const StarRating({
    this.scale = 5,
    this.stars = 0.0,
    this.size,
    this.color = Colors.orange,
    this.onChanged,
    Key? key,
  }) : super(key: key);

  Widget buildStar(BuildContext context, int index) {
    IconData icon;
    if (index >= stars) {
      icon = Icons.star_border;
    } else if (index > stars - 1 && index < stars) {
      icon = Icons.star_half;
    } else {
      icon = Icons.star;
    }
    return GestureDetector(
      onTap: () => onChanged!(index + 1.0),
      child: Icon(
        icon,
        color: color,
        size: size,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        scale,
        (index) => buildStar(context, index),
      ),
    );
  }
}
