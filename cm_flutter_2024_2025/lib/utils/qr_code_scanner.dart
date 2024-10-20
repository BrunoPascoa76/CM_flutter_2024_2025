import 'package:cm_flutter_2024_2025/models/delivery_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrCodeScanner extends StatelessWidget {
  QrCodeScanner({super.key});

  final MobileScannerController controller = MobileScannerController(detectionSpeed: DetectionSpeed.noDuplicates);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MobileScanner(
          controller: controller,
          onDetect: (BarcodeCapture capture) async {
            await controller.stop();
            final List<Barcode> barcodes = capture.barcodes;
            //will leave this in for debugging purposes
            int? pin=_onQrCodeScanned(barcodes);
            DeliveryRouteBloc bloc=BlocProvider.of<DeliveryRouteBloc>(context);
            if(pin!=null){
              bloc.add(DeliveryRouteProgressEvent(pin));
            }
            bloc.state!.current_delivery; 
            Navigator.pop(context);
          },
        ),
        SafeArea(
          child: Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              iconSize: 30,
              onPressed: ()=>Navigator.pop(context),
              icon: const Icon(Icons.arrow_back)
            )
          ),
        )
      ]
    );
  }

  int? _onQrCodeScanned(List<Barcode> barcodes){
    if(barcodes.isNotEmpty){
      String pinString=barcodes[0].rawValue!;
        if(RegExp(r'^[0-9]+$').hasMatch(pinString)){ //if is valid pin
          return int.parse(pinString);
        }
    }
    return null;
  }
}

class QrCodeBloc extends Bloc<QrCodeEvent,int?>{
  QrCodeBloc(): super(null){
    on<QrCodeScanned>((event,emit){
      if(event.barcodes.isNotEmpty){
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
