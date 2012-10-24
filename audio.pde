import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;

Minim minim;
AudioPlayer player;
String name, author, title;
Boolean name_entered, loaded, playing;
PFont font;
float[] graph_left, graph_right;
float r, l;
int played_time, total_time;

void setup() {
  size(1034, 400);
  //size(1034, 400,OPENGL);//uncomment if not smooth, may not help
  frameRate(30);

  minim = new Minim(this);

  font = loadFont("Futura-Medium-30.vlw");
  textFont(font, 30);

  name = "./data/gangnam_style.mp3";
  name_entered = false;
  loaded       = false;
  playing      = false;
  graph_left = new float[256];
  graph_right = new float[256];
}

void draw() {
  background(40);
  fill(200);
  stroke(100);
  //allows users to select an mp3 file (or type a URL) to play
  if (!loaded) {
    text("Please enter a URL of a MP3 to load. Press enter to end input.", 10, 40);
    text(name, 10, 75);
  }
  //read/write audio files (can you convert from mp3 to aiff for example?)
  if (name_entered && !loaded) {
    player = minim.loadFile(name, 256);
    loaded = true;
    author = player.getMetaData().author();
    title  = player.getMetaData().title();
    total_time = player.length();
    graph_left = new float[256];//blank for loading new songs 
    graph_right = new float[256];// ditto
    println(player.getControls());
    
  }
  if (loaded) {
    if (playing) {//don't update visualizer if paused.
      graph_left = player.left.toArray();
      graph_right = player.right.toArray();
    }

    fill(200);
    text(author + ": " + title, 10, 290);//display artist and title from metadata

    text(toMin(player.position()/1000), 10, 345);//print time elapsed
    text(toMin(total_time/1000), width - 80, 345);//print total time

    //go to a certain point in the song (i.e. 1500 milliseconds)
    noFill();
    stroke(150, 25, 25);
    rect(4, 350, 1026, 27, 5);//outer position box
    stroke(100);
    fill(100);
    //println(player.position()/float(player.length()));
    rect(5, 351, (player.position()/float(total_time))*1024, 25, 5);

    //control volume, and pan or balance
    noFill();
    stroke(150, 25, 25);
    rect(width - 150, 265, 17, 82);//volume
    fill(100);
    stroke(100);
    rect(width - 149, 346, 15, -(map(player.getGain(), -80.0, 6.0206, 0, 80)));
    //rect();//balance


    //develop a SIMPLE visualizer
    for (int x = 0; x < graph_left.length - 1; x = x + 4) {
      //line(x*2+5, 200 + graph[x] * 100, x*2+6, 200 + [x + 1] * 100);
      l = abs(graph_left[x]*255);
      r = abs(graph_right[x]*255);
      fill(0, 0, l%256);
      rect(x * 2 + 5, 256, 5, -l);//left channel
      fill(0, r%256, 0);
      rect(x * 2 + 520, 256, 5, -r);//right channel
    }
  }
}

void stop() {
  player.close();
  minim.stop();

  super.stop();
}

void keyPressed() {
  if (key == '\n' && !loaded) {//HERE
    name_entered = true;
  } 
  else if (key == BACKSPACE && !loaded) {
    if (name.length() > 0)
      name = name.substring(0, name.length() - 1);
  } 
  else if (!name_entered) {
    name += key;//HERE for loading files
  } 
  else if (keyCode == RIGHT && loaded && !playing) {//play file 
    player.play();
    playing = true;
  } 
  else if (keyCode == LEFT && loaded) {//rewind play
    player.rewind();
  } 
  else if (keyCode == DOWN && loaded && playing) {//pause play
    player.pause();
    playing = false;
  } 
  else if (key == 'z' && loaded) {//rewind 5 seconds if possible, or to beginning of song
    int pos = player.position();
    if (pos < 5000) {
      player.rewind();
    } 
    else {
      player.cue(pos - 5000);
    }
  } 
  else if (key == 'x' && loaded) {//fast forward 5 seconds if possible, or does nothing
    int pos = player.position() + 5000;
    if ((pos) < total_time) {
      player.cue(pos);
    }
  }
  else if(key == 'l' && loaded){
    player.close();
    name_entered = false;
    loaded = false;
    playing = false; 
  }
}

void mouseClicked() {
  if (loaded) {
    if (mouseY >= 350 && mouseY <= 380 && mouseX > 5 && mouseX < width-5)//in position bar
      player.cue(int(map(mouseX, 6, width-6, 0, 1)*total_time));//set position close to click position
    //if(){

    //}
  }
}

String toMin(int seconds) {
  String head = str(int(seconds/60));
  String tail = str(seconds%60);
  if (tail.length() == 1 )
    tail = "0" + tail;
  return head + ":" + tail;
}

