import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrCodeScanner extends StatelessWidget {
  QrCodeScanner({super.key});

  final MobileScannerController controller = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      controller: controller,
      onDetect: (BarcodeCapture capture) {
        final List<Barcode> barcodes = capture.barcodes;
        Navigator.pop(context);
        //will leave this in for debugging purposes
        for (final barcode in barcodes) {
          print(barcode.rawValue);
        }
      },
    );
  }
}

class QrCodeBloc extends Bloc<QrCodeEvent,int?>{
  QrCodeBloc(): super(null){
    on<QrCodeScanned>((event,emit){
      if(event.barcodes.length==1){
        String pinString=event.barcodes[0].rawValue!;
        if(RegExp(r'^[0-9]+$').hasMatch(pinString)){ //if is valid pin
          emit(int.parse(pinString));
        }
      }  
    });
    on<QrCodeClean>((event,emit){emit(null);});
  }
}

class QrCodeEvent{}
class QrCodeClean extends QrCodeEvent{}
class QrCodeScanned extends QrCodeEvent{
  final List<Barcode> barcodes;
  QrCodeScanned(this.barcodes);
}
