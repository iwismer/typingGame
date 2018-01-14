/*
Isaac Wismer
Feb 2016
This is an abstract class for my backround decorations.
it is extended by the Planet and Star classes
*/
abstract class AbstractDecoration {
  //variables for the x,y positions and what the photo is
  protected float xPos, yPos;
  protected PImage photo;

  //constructor
  public AbstractDecoration(float x, float y) {
    xPos = x;
    yPos = y;
  }

  //draw the decoration with width and height 50px
  public void update() {
    image(photo, xPos, yPos, 50, 50);
  }
}