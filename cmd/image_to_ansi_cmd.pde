
PImage in;

int s = 10;

String out = "";
color prevColBg;
color prevColFg;
int w,h;

void setup() {
  
  // main setup
  
  in = loadImage("in.png");
  w = in.width;
  h = in.height;
  windowResize(s*w,s*h);
  
  // generate string
  
  out += "chcp 65001\ncls&echo.";
  
  for (int i=0; i<h/2; i++) {
    out += "&echo ";
    prevColBg = #00000000;
    prevColFg = #00000000;
    for (int j=0; j<w; j++) {
      color pixTop = in.pixels[w*2*i+j];
      color pixBot = in.pixels[w*(2*i+1)+j];
      if (pixTop != prevColBg || pixBot != prevColFg) {
        if (alpha(pixTop) < 128) {
          if (alpha(pixBot) < 128) {
            out += "\u001b[0m ";
          }
          else {
            out += "\u001b[0;38;2;"+(int)red(pixBot)+";"+(int)green(pixBot)+";"+(int)blue(pixBot)+"m\u2584";
          }
        }
        else {
          if (alpha(pixBot) < 128) {
            out += "\u001b[0;38;2;"+(int)red(pixTop)+";"+(int)green(pixTop)+";"+(int)blue(pixTop)+"m\u2580";
          }
          else {
            out += "\u001b[0;"+
              "48;2;"+(int)red(pixTop)+";"+(int)green(pixTop)+";"+(int)blue(pixTop)+";"+
              "38;2;"+(int)red(pixBot)+";"+(int)green(pixBot)+";"+(int)blue(pixBot)+"m\u2584";
          }
        }
        prevColBg = pixTop;
        prevColFg = pixBot;
      }
      else {
        if (alpha(pixBot) < 128) {
          if (alpha(pixTop) < 128) {
            out += " ";
          }
          else {
            out += "\u2580";
          }
        }
        else {
          out += "\u2584";
        }
      }
    }
    out += "\u001b[0m";
  }
  // bottom row if odd height
  if (h%2==1) {
    out += "&echo ";
    prevColFg = #00000000;
    for (int j=0; j<w; j++) {
      color pix = in.pixels[w*(h-1)+j];
      if (pix != prevColFg) {
        out += "\u001b[0;"+
          "38;2;"+(int)red(pix)+";"+(int)green(pix)+";"+(int)blue(pix)+"m";
        prevColFg = pix;
      }
      out += alpha(pix) < 128 ? " " : "\u2580";
    }
    out += "\u001b[0m";
  }
  
  out += "&echo \u001b[0m&pause";
  
  saveStrings("out.bat",new String[]{out});
}

void draw() {
  background(#ffffff);
  for (int i=0; i<h; i++) {
    for (int j=0; j<w; j++) {
      noStroke();
      fill(in.pixels[i*w+j]);
      rect(j*s,i*s,s,s);
    }
  }
}
