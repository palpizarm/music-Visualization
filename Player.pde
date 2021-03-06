Minim minim;
AudioPlayer song;
AudioMetaData data;
BeatDetect beat;
FFT fft;

Button buttonPause, buttonMusic;
float bgColor = 10;
MenuBar menu;
Menu songItem;
MenuItem loadSong;
Visualization[] animation;
int VisualizationCount = 2;


void setup() {
  size(1080,720,P3D);
  surface.setTitle("Music Arts");
  surface.setResizable(false);
  background(bgColor);
  minim = new Minim(this);
  
  animation = new Visualization[VisualizationCount];
  
  // create a buttons
  buttonPause = new Button(loadImage("pause.png"), loadImage("pause.png"), new PVector(50,height-100),40);
  buttonMusic = new Button(loadImage("music.png"),loadImage("music.png"),new PVector(50,50),40);
}

void draw() {
  buttonMusic.updateMouseIn();
  if (song != null && song.isPlaying()) {
    background(10);
    buttonPause.updateMouseIn();
    buttonMusic.updateMouseIn();

  
     fft.forward(song.mix);
     beat.detect(song.mix);
     noStroke();
     // render the visualization
     for (int i = 0; i < VisualizationCount; i++) {
       animation[i].update();
     }

    // time line
    stroke( 100, 100 ,100);
    line( 200, height - 100, width-200, height - 100);
    // map: Re-maps a number from one range to another.
    float position = map(song.position(),0,song.length(),0,width-400);
    stroke( 255, 255 ,255);
    line(200, height - 100, 200 + position, height - 100);
    // time
    textSize(18);
    fill(255);
    text(
     TimeToString(song.length()),
     width-150, height - 100    
    );
     
    textSize(18);
    fill(255);
    text(
     TimeToString(song.position()),
     100, height - 100    
    );
  }
}


void mousePressed() {
  if (song != null  && buttonPause.MouseInside()) {
    if (buttonPause.MouseInside() && song.isPlaying()) {
      buttonPause.setImage(loadImage("play.png"),loadImage("play.png"));
      song.pause();
    } else {
      buttonPause.setImage(loadImage("pause.png"), loadImage("pause.png"));
      song.play();
    }
    buttonPause.updateMouseIn();
  }
  if (buttonMusic.MouseInside()) {
    if (song != null) {
      if (song.isPlaying()) {
        song.pause();
      }
    }
    noLoop();
    print("Probablemente al inicio la ventana para seleccionar la cancion va a iniciar minimizada");
    selectInput("Select a song", "selectSong"); //<>//
    buttonMusic.updateMouseIn();
  }
}


void keyPressed() {
  if (keyCode == 32) {
    if (song != null) {
      if (song.isPlaying()) {
        buttonPause.setImage(loadImage("play.png"),loadImage("play.png"));
        song.pause();
      } else {
        buttonPause.setImage(loadImage("pause.png"), loadImage("pause.png"));
        song.play();
      }
      buttonPause.updateMouseIn();
    }
  }
  else if (keyCode == 77) {
    if (song != null) {
      if (song.isPlaying()) {
        song.pause();
      } 
    }
    noLoop();
    selectInput("Select a song", "selectSong");
    buttonMusic.updateMouseIn();
  }
}


void selectSong(File selection) {
  if (selection != null) {
    try {
      song = minim.loadFile(selection.getAbsolutePath());
      data = song.getMetaData();
      fft = new FFT(song.bufferSize(),song.sampleRate());
      beat = new BeatDetect(song.bufferSize(),song.sampleRate());
      beat.setSensitivity(100);
      animation[0] = new Visualization(50,50,0);
      animation[1] = new Visualization(50,50,-1000);
      song.play();
    } catch(Exception e) {
      JOptionPane.showMessageDialog(null, "Error al cargar la canción", "Error", JOptionPane.ERROR_MESSAGE);
      noLoop();
      selectInput("Select a song", "selectSong");
    }
   } else if (song != null){
     song.play();
   }
  loop();
}


void stop() {
  song.close();
  minim.stop();
  super.stop();
}
