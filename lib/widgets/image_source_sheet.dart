import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatelessWidget {
  final Function(File) onImageSelected;

  ImageSourceSheet({this.onImageSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _verDialog(context),);
  }

    void imageSelected(File image) async {
      if (image != null) {
        File croppedImage = await ImageCropper.cropImage(
          sourcePath: image.path,
        );
        onImageSelected(croppedImage);
      }
    }

    Future _abrirGaleria() async {
      FlatButton(
        child: Text("Galeria"),
        onPressed: () async {
          File image = await ImagePicker.pickImage(source: ImageSource.gallery);
          imageSelected(image);
        },
      );
    }

    _abrirCamera(BuildContext context) {
      FlatButton(
        child: Text("Câmera"),
        onPressed: () async {
          File image = await ImagePicker.pickImage(source: ImageSource.camera);
          imageSelected(image);
        },
      );
    }

     _verDialog(BuildContext context) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Adicionar Imagem"),
              content: SingleChildScrollView(
                  child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text("Abir Galeria"),
                    onTap: () {
                      _abrirGaleria();
                    },
                  ),
                  Padding(padding: EdgeInsets.all(20.0)),
                  GestureDetector(
                    child: Text("Abrir Camera"),
                    onTap: () {
                      _abrirCamera(context);
                    },
                  ),
                ],
              )),
            );
          });
    }
  }

