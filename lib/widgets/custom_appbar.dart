import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return ClipPath(
      clipper: WaveClipperOne(),
      child: Container(
        height: 280,
        color: Colors.redAccent,
        child: Center(
          child: Text("Minha Loja",style: TextStyle(fontSize: 20),),
        ),
      ),
    );
  }
}
