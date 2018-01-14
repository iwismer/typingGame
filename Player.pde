/*
Isaac Wismer
 Feb 2016
 This is the Player class
 it contains all the data fo the player
 */
class Player {
  private float xPos, yPos, xSpeed;
  private PImage photo;

  //constructor
  public Player() {
    //set the default position and speed
    xPos = 750;
    yPos = 1000;
    xSpeed = 3;
    //load the image
    photo = loadImage("include/ship.png");
  }

//getters and setters

  public float getX() {
    return xPos;
  }

  public float getY() {
    return yPos;
  }

  public void hit() {
    yPos += 2;
  }

  public void setXSpeed(float xSpeed) {
    this.xSpeed = xSpeed;
  }

  public void update() {
    //move the player
    xPos += xSpeed;
    //bounce the player
    if (xPos > 1400 || xPos < 100) {
      xSpeed = -xSpeed;
    }
    //fill(255, 255, 255);
    //ellipse(xPos, yPos, 50, 50);
    
    //draw the player
    image(photo, xPos, yPos, 75, 75);
    
    //old code for testing hit detection
    //fill(255, 255, 255);
    //ellipse(xPos+ 37, yPos+40, 70, 70);
    //fill(255, 0, 0);
    //float xInc = 5, yInc = -7.5;
    ////ellipse(xPos + 37, yPos + 37, 50, 75);
    ////ellipse(xPos + 37, yPos + 52, 75, 45);
    //for (float x = -25, y = 0; x <= 25 && y <= 37.5; x += xInc, y+= yInc) {
    //  ellipse(xPos + 37 + x, yPos + 37 + y, 9, 9);
    //  if (y == -37.5) {
    //    yInc = -yInc;
    //  }
    //}
    //xInc = 7.5;
    //yInc = 4.5;
    //for (float x = 0, y = -22.5; y <= 22.5; x += xInc, y+= yInc) {
    //  ellipse(xPos + 37 + x, yPos + 52 + y, 9, 9);
    //  if (x == 37.5) {
    //    xInc = -xInc;
    //  }
    //}

    //xInc = -7.5;
    //yInc = 4.5;
    //for (float x = 0, y = -22.5; y <= 22.5; x += xInc, y+= yInc) {
    //  ellipse(xPos + 37 + x, yPos + 52 + y, 9, 9);
    //  if (x == -37.5) {
    //    xInc = -xInc;
    //  }
    //}
  }
}