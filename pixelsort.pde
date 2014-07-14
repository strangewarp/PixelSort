


final int imgx = 704;
final int imgy = 576;

final String filename = "walk";
final String filetype = "png";

final int startnum = 30;
final int endnum = 210;

final int threshold = 60;



PImage img;

boolean compareColors(color c1, color c2) {
  
  float r = red(c1) - red(c2);
  float g = green(c1) - green(c2);
  float b = blue(c2) - blue(c2);
  
  if ((r + g + b) > 0) {
    return true;
  }
  
  return false;
  
}

void setup() {
  size(imgx, imgy);
  background(0);
  noStroke();
  noLoop();
}

void draw() {
  
  for (int fnum = startnum; fnum <= endnum; fnum++) {
    
    PImage newimg = createImage(imgx, imgy, RGB);
    
    img = loadImage(filename + nf(fnum, str(endnum).length()) + "." + filetype);
    img.loadPixels();
    
    for (int x = 0; x < imgx; x++) {
      
      int[] pix = new int[imgy];
      int[] highest = {0, 0, 0};
      int[] lowest = {255, 255, 255};
      int bound = 0;
      
      for (int y = 0; y < imgy; y++) {
        
        color col = img.pixels[x + (imgx * y)];
        
        pix[y] = col;
        
        highest[0] = max(highest[0], (int)red(col));
        highest[1] = max(highest[1], (int)green(col));
        highest[2] = max(highest[2], (int)blue(col));
        lowest[0] = min(lowest[0], (int)red(col));
        lowest[1] = min(lowest[1], (int)green(col));
        lowest[2] = min(lowest[2], (int)blue(col));
        
        float hightotal = (highest[0] + highest[1] + highest[2]) / 3;
        float lowtotal = (lowest[0] + lowest[1] + lowest[2]) / 3;
        
        if ((abs(hightotal - lowtotal) > threshold) || (y == (imgy - 1))) {
          
          int sortpoint = bound;
          while (sortpoint < y) {
            boolean clear = true;
            for (int p = sortpoint; p < y; p++) {
              color item = pix[p];
              color item2 = pix[p + 1];
              if (compareColors(item, item2)) {
                pix[p] = item2;
                pix[p + 1] = item;
                clear = false;
              }
            }
            if (clear) {
              sortpoint += 1;
            }
          }
          
          for (int b = bound; b <= y; b++) {
            newimg.pixels[x + (imgx * b)] = pix[b];
          }
          
          bound = y + 1;
          
          highest[0] = 0;
          highest[1] = 0;
          highest[2] = 0;
          lowest[0] = 255;
          lowest[1] = 255;
          lowest[2] = 255;
          
        }
        
      }
      
    }
    
    newimg.updatePixels();
    image(newimg, 0, 0);
    
    String outname = "data/" + filename + "_out" + fnum + "." + filetype;
    println(outname);
    saveFrame(outname);
    
  }
  
}
