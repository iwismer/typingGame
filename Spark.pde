/*
Isaac Wismer
 Feb 2016
 This is the Spark class
 It contains the data for one spark
 */

class Spark {
  private float xPos, yPos, xSpeed, ySpeed;

  //constructor
  public Spark(float x, float y) {
    //set the location and speeds
    xPos = x;
    yPos = y;
    xSpeed = random(-4, 4);
    ySpeed = -5;
  }

  //getters and setters

  public float getX() {
    return xPos;
  }

  public float getY() {
    return yPos;
  }

  public void update() {
    //increase the acceleration, move the spark
    ySpeed += 0.5;
    xPos += xSpeed;
    yPos += ySpeed;
    //draw the spark
    image(typingGame.spark, xPos, yPos, 30, 30);
  }
}