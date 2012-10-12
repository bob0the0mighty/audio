import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;

Minim minim;
AudioPlayer player;
String name;
Boolean name_entered, loaded;

void setup() {
  size(1024, 400);
  minim = new Minim(this);
  background(0);
  name = "";
  name_entered = false;
  loaded = false;
  //noLoop();
  
  
  
}

void draw() {
  //A
  //allows users to select an mp3 file (or type a URL) to play
  if(!loaded){
    println("Please enter a URL of a MP3 to load. Press enter to end input.");
    println(name);
  }
  //read/write audio files (can you convert from mp3 to aiff for example?)
  if(name_entered && !loaded){
    player = minim.loadFile(name,1024);
    loaded = true;
  }
  //play, rewind, pause, fast forward, go to a certain point in the song (i.e. 1500 milliseconds)


  //control volume, and pan or balance


  //develop a SIMPLE visualizer
}

void stop(){
   player.close();
   minim.stop();
  
  super.stop(); 
}

void keyPressed(){
  if(key == '\n' && !loaded) {
    name_entered = true;
  } else if(key == BACKSPACE && !loaded) {
    name = name.substring(0, name.length() - 1);
  } else {
     name += key;
  } 
}

