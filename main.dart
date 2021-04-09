import 'package:camera/camera.dart';
import 'package:flutter/material.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final camera = await availableCameras();
  final firstCamera = camera.first;

  runApp(HomeApp(camera: firstCamera,));
}


class HomeApp extends StatelessWidget {
  final CameraDescription camera;
  const HomeApp({Key key, @required this.camera}) : super(key: key);
  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(camera: camera,),
    );
  }
}


class HomeScreen extends StatefulWidget {
  final CameraDescription camera;
  const HomeScreen({Key key, @required this.camera}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.build),
        title: Text('Testing camera'),
      ),
      body: Center(
        child: IconButton(
          icon: Icon(
              Icons.camera
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => CamPage(camera: widget.camera,)));
          },
        ),
      ),
    );
  }
}

class CamPage extends StatefulWidget {

  final CameraDescription camera;

  const CamPage({Key key, @required this.camera}) : super(key: key);
  @override
  _CamPageState createState() => _CamPageState();
}

class _CamPageState extends State<CamPage> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = CameraController(widget.camera,
      ResolutionPreset.high
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12 ,
      body: Center(
        child: FutureBuilder<void> (
          future: _initializeControllerFuture,
          builder: (context, snapshot){
            if (snapshot.connectionState == ConnectionState.done) {
              // If the Future is complete, display the preview.
              return CameraPreview(_controller);
            } else {
              // Otherwise, display a loading indicator.
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
