
PImage in;

int s = 10;
color[] discordcols = new color[]{#000000,#ec6361,#45a366,#ce8100,#4591ec,#f549c9,#049faa,#b6b7bc};
color discordbgtransparent = color(53,55,72);

String reset = "\u001b[0m";
int[] numcodes = new int[]{30,31,32,33,34,35,36,37};

String out = "";

int[][] altImg;

float colDist(color a, color b) {
  return sq(red(a)-red(b))+sq(green(a)-green(b))+sq(blue(a)-blue(b));
}

int closestAvailableColor(color c) {
  if (alpha(c) < 128) {
    return -1;
  }
  float mindist = 999999999;
  int index = 0;
  for (int i=0; i<discordcols.length; i++) {
    if (colDist(discordcols[i],c) < mindist) {
      mindist = colDist(discordcols[i],c);
      index = i;
    }
  }
  return index;
}

void setup() {
  
  // main setup
  
  in = loadImage("in.png");
  windowResize(s*(in.width+2),s*(in.height+2));
  
  altImg = new int[in.height][in.width];
  
  // generate new image with available colors
  
  for (int i=0; i<altImg.length; i++) {
    for (int j=0; j<altImg[i].length; j++) {
      altImg[i][j] = closestAvailableColor(in.get(j,i));
    }
  }
  
  // generate string
  
  int prevColBg, prevColFg;
  
  out += "```ansi";
  
  for (int i=0; i<in.height/2; i++) {
    out += "\n";
    prevColBg = -1;
    prevColFg = -1;
    for (int j=0; j<in.width; j++) {
      int pixTop = closestAvailableColor(in.pixels[in.width*2*i+j]);
      int pixBot = closestAvailableColor(in.pixels[in.width*(2*i+1)+j]);
      if (pixTop != prevColBg || pixBot != prevColFg) {
        if (pixTop < 0) {
          if (pixBot < 0) {
            out += "\u001b[0m ";
          }
          else {
            out += "\u001b[0;"+(30+pixBot)+"m\u2584";
          }
        }
        else {
          if (pixBot < 0) {
            out += "\u001b[0;"+(30+pixTop)+"m\u2580";
          }
          else {
            out += "\u001b[0;"+(40+pixTop)+";"+(30+pixBot)+"m\u2584";
          }
        }
        prevColBg = pixTop;
        prevColFg = pixBot;
      }
      else {
        if (pixBot < 0) {
          if (pixTop < 0) {
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
  if (in.height%2==1) {
    out += "\n";
    prevColFg = -1;
    for (int j=0; j<in.width; j++) {
      int pix = closestAvailableColor(in.pixels[in.width*(in.height-1)+j]);
      if (pix != prevColFg) {
        out += "\u001b[0;"+
          (30+pix)+"m";
        prevColFg = pix;
      }
      out += pix < 0 ? " " : "\u2580";
    }
    out += "\u001b[0m";
  }
  
  out += "\n```";
  
  println(out.length() + " chars: " + (out.length() <= 2000 ? (2000 - out.length()) + " under" : (out.length() - 2000) + " over! cannot send on discord"));
  
  saveStrings("out.txt",new String[]{out});
}

void draw() {
  background(discordbgtransparent);
  for (int i=0; i<in.height; i++) {
    for (int j=0; j<in.width; j++) {
      noStroke();
      if (altImg[i][j] < 0) continue;
      fill(discordcols[altImg[i][j]]);
      rect((j+1)*s,(i+1)*s,s,s);
    }
  }
}
