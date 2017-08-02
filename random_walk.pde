import geomerative.*;

boolean drawMain = !true;
boolean showVertex = false;

Line[] lines = {
  new Line(10, 125, !true, color(  140, 0, 20, 2), 3000), 
  new Line(10, 125, true, color(  0, 140, 20, 2), 100), 
};


/*

Line[] lines770 = {
  new Line(500, 80, true, color(  40, 0, 20, 2), 200), 
  new Line(150, 70, true, color( 250, 0, 20, 4), 200), 
  new Line( 20, 1600, true, color( 250, 250, 250, 40), 1) 
};

 
 Line[] lines770_k = {
  new Line(480, 75, true, color(  40, 0, 20, 2), 200), 
  new Line(200, 100, true, color( 250, 0, 20, 4), 200), 
  new Line( 20, 200, true, color( 250, 250, 250, 40), 1) 
};


Line[] lines_k_neg = {
  new Line(480, 100, false, color(  40, 0, 20, 2), 450), 
  new Line(200, 400, false, color( 250, 0, 20, 4), 110), 
  new Line( 20, 300, false, color( 120, 0, 120, 20), 1) 
};


Line[] lines_aquiescencia = {
  new Line(20, 2000, !true, color(  140, 0, 20, 10), 30), 
};

*/


RShape mainShape;

int index, currentReps;
int lastX, lastY;
int offsetX, offsetY;

void setup() {

  RG.init(this);
  
  size(1000, 1000); 
  mainShape = RG.getText("A", "FreeSans.ttf", 1100, CENTER);
  offsetX = 500;
  offsetY = 910;
  
  
  /*

  //770
  size(900, 450); 
  mainShape = RG.getText("770", "FreeSans.ttf", 512, CENTER);
  offsetX = 430;
  offsetY = 400;

  //770_k
  size(1100, 650); 
  mainShape = RG.getText("ok", "FreeSans.ttf", 750, CENTER);
  offsetX = 520;
  offsetY = 590;

  //770_k_neg
  size(1100, 650); 
  mainShape = RG.getText("ok", "FreeSans.ttf", 750, CENTER);
  offsetX = 520;
  offsetY = 590;
  
  //aquiescencia
  size(1600, 350); 
  mainShape = RG.getText("aquiescencia", "FreeSans.ttf", 225, CENTER);
  offsetX = 800;
  offsetY = 240;

  */


  pixelDensity(2);
  background(255);
  noFill();
  translate(offsetX, offsetY);
  if (drawMain) {
    mainShape.draw();
  }

  currentReps = 0;
  index = -1;
}


void draw() {

  translate(offsetX, offsetY);

  if (currentReps > 0) {

    if (currentReps%25==0) {
      println(currentReps + " repeticiones");
    }

    do {
      lastX = (int)random(width);
      lastY = (int)random(height);
    } while ((lines[index].linesInside ^ myContains(mainShape, new RPoint(lastX-offsetX, lastY-offsetY))));
    if (showVertex) {
      ellipse(lastX-offsetX, lastY-offsetY, 4, 4);
    }

    for (int f=0; f<lines[index].numSegments; ) {

      PVector v = PVector.random2D();
      v.mult(random(lines[index].distance/5, lines[index].distance));

      RPoint testPoint = new RPoint(lastX+v.x-offsetX, lastY+v.y-offsetY);

      if (!(lines[index].linesInside ^ myContains(mainShape, testPoint)) &&
          testPoint.x >= -offsetX &&
          testPoint.y >= -offsetY &&
          testPoint.x <= width - offsetX &&
          testPoint.y <= height - offsetY
          ) {
        line(lastX-offsetX, lastY-offsetY, testPoint.x, testPoint.y);
        if (showVertex) {
          ellipse(testPoint.x, testPoint.y, 2, 2);
        }
        lastX = (int)testPoint.x+offsetX;
        lastY = (int)testPoint.y+offsetY;
        f++;
      }
    }

    currentReps--;
  }

  if (currentReps<=0) {
    index++;
    if (index<lines.length) {
      currentReps = lines[index].repetitions;
      stroke(lines[index].strokeColor);
      println("Vuelta " + (index+1));
    } else {
      noLoop();
      println("end");
    }
  }
}


boolean myContains(RShape rs, RPoint rp) {

  for (int i=0; i<rs.countChildren(); i++) {
    if (rs.contains(rp)) {
      return true;
    }
  }
  return false;
}