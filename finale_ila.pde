import processing.sound.*;
import processing.video.*;
import processing.serial.*;
import oscP5.*;
import netP5.*;

AudioIn input;
Amplitude analyzer;

Movie abajo; 
Movie sube;
Movie arriba;
Movie baja;
OscP5 oscP5;
NetAddress myRemoteLocation;

Serial myPort;

int value;
int hayPersona = 0;
int estado = 0;

void setup() {
  size(1280, 720);

  myPort = new Serial (this, "COM3", 115200);
  myPort.bufferUntil ('\n');

  abajo = new Movie(this, "abajo.MOV");
  arriba = new Movie (this, "arriba.MOV");
  sube = new Movie (this, "sube.MOV");
  baja = new Movie (this, "baja.MOV");
  input = new AudioIn(this, 0);
  input.start();
  analyzer = new Amplitude(this);
  analyzer.input(input);

  oscP5 = new OscP5(this, 12001);
  myRemoteLocation = new NetAddress("127.0.0.1", 12001);
}

void draw() {
  background (0);  
  noFill();
  stroke(200);

  float vol = analyzer.analyze();

  if (myPort.available() >= 0) {
    value = myPort.read();
    //  println (value);
    if (value < 2 ) {
      hayPersona = value;
      println (hayPersona);
     
    }
    
    //if (hayPersona == 1) {
    // OscMessage valorOSC = new OscMessage ("haypersona");
    //  valorOSC.add(hayPersona); 
    //  oscP5.send(valorOSC, myRemoteLocation);
    //}
    
    if (hayPersona == 0) {
      estado = 0;
      sube.stop();
      
    }  

    if ((estado == 0) && (hayPersona == 1)) {
      estado = 1;
    }

    if (vol >= 0.03) {
      if (estado == 1) {
        estado= 2;
      }
    }

    if (estado == 2) {
      if (sube.time() == sube.duration()) {
        estado = 3;
      }
    }

    if (vol <= 0.01) {
      if (estado == 3) {
        estado= 4;
      }
    }

    if (estado == 1) {
      baja.stop();
      image (abajo, 0, 0);
      abajo.loop();
    }


    if (estado == 2) {
      //arriba.stop();
      image (sube, 0, 0);
      sube.play();
    }

    if (estado == 3) {
      sube.stop();
      image (arriba, 0, 0);
      arriba.loop();
    }

    if (estado == 4) {
      arriba.stop();
      image (baja, 0, 0);
      baja.play();
      if (baja.time() == baja.duration()) {
        estado = 1;
      }
    }
    
    //if (hayPersona == 0) {
    // OscMessage valorOSC = new OscMessage ("nohaypersona");
    //  valorOSC.add(hayPersona); 
    //  oscP5.send(valorOSC, myRemoteLocation);
    //}

    println(vol);
    println(estado);
  }
 
}

void movieEvent(Movie m) {
  m.read();
}
