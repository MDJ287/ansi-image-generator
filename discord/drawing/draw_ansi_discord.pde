
int w = 30, h = 30;

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
  
  windowResize(s*(w+2),s*(h+12));
  
  altImg = new int[h][w];
  
  for (int i=0; i<h; i++) {
    for (int j=0; j<w; j++) {
      altImg[i][j] = -1;
    }
  }
}

void genStr() {
  
  out = "";
  
  int prevColBg, prevColFg;
  
  out += "```ansi";
  
  for (int i=0; i<h/2; i++) {
    out += "\n";
    prevColBg = -1;
    prevColFg = -1;
    for (int j=0; j<w; j++) {
      int pixTop = altImg[2*i][j];
      int pixBot = altImg[2*i+1][j];
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
  if (h%2==1) {
    out += "\n";
    prevColFg = -1;
    for (int j=0; j<w; j++) {
      int pix = altImg[h-1][j];
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

int curC = 0;

void keyPressed() {
  if (48 <= keyCode && keyCode <= 55) {
    curC = keyCode - 48;
  }
  if (keyCode == 192) {
    curC = -1;
  }
}

void draw() {
  if (mousePressed) {
    int x = mouseX/10 - 1;
    int y = mouseY/10 - 1;
    if (x >= 0 && x < w && y >= 0 && y < h) {
      altImg[y][x] = curC;
    }
  }
  
  genStr();
  background(discordbgtransparent);
  
  stroke(#000000);
  noFill();
  rect(s,s,s*w,s*h);
  
  for (int i=0; i<h; i++) {
    for (int j=0; j<w; j++) {
      if (altImg[i][j] < 0) continue;
      noStroke();
      fill(discordcols[altImg[i][j]]);
      rect((j+1)*s,(i+1)*s,s,s);
    }
  }
  
  for (int i=0; i<discordcols.length; i++) {
    noStroke();
    fill(discordcols[i]);
    rect(s+i*s*w/8,3*s+s*h,s*w/8,s*w/8);
  }
  
  if (curC >= 0) {
    stroke(#ffff00);
    noFill();
    rect(s+curC*s*w/8,3*s+s*h,s*w/8,s*w/8);
  }
}

void mouseClicked() {
  if (mouseX > s && mouseX < s+s*w && mouseY > 3*s+s*h && mouseY < 3*s+s*h+s*w/8) {
    curC = (mouseX - s) / (s*w/8);
  }
}
