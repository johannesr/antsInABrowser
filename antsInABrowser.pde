/*
 *
 * File: antsInABrowser.pde
 * ----------------------
 *
 * This a ant farm based on Langton's ant rules which with a very simple set of rules create complicated emergent behavior.
 * The user can add ants to the farm by pointing and clicking on a place where they want more ants.
 *
 * The rules of the game:
 * 1. If the ant is on a black square, it turns right  and moves forward one unit.
 * 2. If the ant is on a white square, it turns left  and moves forward one unit.
 * 3. When the ant leaves a square, it inverts the color.
 *
 * Source: http://mathworld.wolfram.com/LangtonsAnt.html & http://en.wikipedia.org/wiki/Langton%27s_ant
 * 
 * 
 *
 * 
 * 
 * Created 19 Mar 2012
 * By Johannes Rummelhoff
 * Modified 24 Mar 2012
 * By Johannes Rummelhoff
 *
 */


int sqrSize = 20;
int numColumns;
int numRows;
int turn;

color backgroundColor = color(41, 0, 0);
color antColor = color(209, 0, 0);
color white = color(41, 0, 0);
color black = color(226, 141, 141);
color[][] sqrColor;

ArrayList ants;

void setup() {
  size(500, 500);
  background(backgroundColor);
  noStroke();
  smooth();

  numColumns = width/sqrSize;
  numRows = height/sqrSize;

  ants = new ArrayList();

  sqrColor = new color[numColumns][numRows];
  for (int rows = 0; rows < numRows; rows++) {
    for (int columns = 0; columns < numColumns; columns++) {
      sqrColor[columns][rows] = white;
    }
  }
}

void draw() {
  drawSquares();
  moveAnts();
  
  // Count and print the turn number
  turn++;
  println("turn #" + turn);
  saveFrame("ants-####.gif");


}

void drawSquares() {
  
  for (int rows = 0; rows < numRows; rows++) {
    for (int columns = 0; columns < numColumns; columns++) {
      fill(sqrColor[columns][rows]);
      rect(sqrSize * columns, sqrSize * rows, sqrSize, sqrSize);
    }
  }
}

void moveAnts() {
  for (int i = 0; i < ants.size(); i++) {
    Ant ant = (Ant) ants.get(i);
    ant.update();
    ant.display();

    // Check if the ant has moved outside the canvas. Remove the ant if it has done that.
    if (ant.location.x >= width - sqrSize || ant.location.x < sqrSize || ant.location.y >= height - sqrSize || ant.location.y < sqrSize) {
      ants.remove(i);
    }

    // Get ants position  
    int antX = int(ant.location.x) / sqrSize;
    int antY = int(ant.location.y) / sqrSize;

    // Rule 1. If the ant is on a black square, it turns right  and moves forward one unit.
    if (sqrColor[antX][antY] == black) {
      sqrColor[antX][antY] = white;
      ant.moveForward(true);
    } 

    // Rule 2. If the ant is on a white square, it turns left  and moves forward one unit.
    else if (sqrColor[antX][antY] == white) {
      sqrColor[antX][antY] = black;
      ant.moveForward(false);
    }
  }
}

void mousePressed() {
  
  // Find the appropriate square
  int x = (int)(mouseX / (width / (width / sqrSize))) * sqrSize;
  int y = (int)(mouseY / (height / (height / sqrSize))) * sqrSize;

  if (x < width && y < height && x > 0 && y > 0) {
    ants.add(new Ant(x, y));
  }
  
  // For debugging:
  // int mX = mouseX;
  // int mY = mouseY;
  // println("mouseX = " + mX + " mouseY = " + mY);
  // println("X = " + x + " Y = " + y);
}

// The mighty ant
class Ant {
  int direction;
  int north = 1;
  int south = 2;
  int east = 3;
  int west = 4;

  PVector location;
  PVector step;

  Ant(int x, int y) {
    location = new PVector(x, y);
    step = new PVector(0, 0);
 
    direction = north;
    
  }

  void moveForward(boolean black) {

    if (black) {

      switch(direction) {

        // north
      case 1: 
        step = new PVector(sqrSize, 0);
        direction = east;
        break;

        // south
      case 2:
        step = new PVector(-sqrSize, 0);
        direction = west;
        break;

        // east
      case 3:
        step = new PVector(0, sqrSize);
        direction = south;
        break;

        // west
      case 4:
        step = new PVector(0, -sqrSize);
        direction = north;
        break;
      }
    }

    if (!black) {

      switch(direction) {

        // north
      case 1:
        step = new PVector(-sqrSize, 0);
        direction = west;
        break;

        // south
      case 2:
        step = new PVector(sqrSize, 0);
        direction = east;
        break;

        // east
      case 3:
        step = new PVector(0, -sqrSize);
        direction = north;
        break;

        // west
      case 4:
        step = new PVector(0, sqrSize);
        direction = south;
        break;
      }
    }
  }

  void update() {
    location.add(step);
  }

  void display() {
    fill(antColor);
    rect(location.x, location.y, sqrSize, sqrSize);
  }
}

