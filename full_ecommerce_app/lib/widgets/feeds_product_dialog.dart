import 'package:flutter/material.dart';
import 'package:full_ecommerce_app/models%20&%20providers/cart.dart';
import 'package:full_ecommerce_app/models%20&%20providers/product.dart';
import 'package:full_ecommerce_app/models%20&%20providers/wishlist.dart';
import 'package:full_ecommerce_app/screens/inner_screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

class FeedsProductDialog extends StatelessWidget {
  final Product product;
  const FeedsProductDialog({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Consumer<WishListProvider>(
              builder: (context, wp, _) {
                return CircleAvatar(
                  backgroundColor: Colors.deepPurpleAccent,
                  child: IconButton(
                    onPressed: () {
                      wp.addOrRemoveWishList(
                        product.id,
                        product.title,
                        product.imageUrl,
                        product.price,
                      );
                    },
                    icon: wp.wishList.containsKey(product.id)
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : const Icon(
                            Icons.favorite,
                            color: Colors.white,
                          ),
                  ),
                );
              },
            ),
            Consumer<CartProvider>(
              builder: (context, cp, _) {
                return CircleAvatar(
                  backgroundColor: Colors.deepPurpleAccent,
                  child: IconButton(
                    onPressed: () {
                      cp.addToCart(
                        product.id,
                        product.title,
                        product.imageUrl,
                        product.price,
                      );
                    },
                    icon: cp.cartList.containsKey(product.id)
                        ? const Icon(
                            Icons.shopping_cart,
                            color: Colors.red,
                          )
                        : const Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                          ),
                  ),
                );
              },
            ),
            CircleAvatar(
              backgroundColor: Colors.deepPurpleAccent,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);

                  Navigator.of(context).pushNamed(
                    ProductDetailScreen.routeName,
                    arguments: product.id,
                  );
                },
                icon: const Icon(
                  Icons.remove_red_eye,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
