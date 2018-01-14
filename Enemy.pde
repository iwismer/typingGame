/*
Isaac Wismer
Feb 2016
This is the enemy class
it contains all the data for one enemy
*/

class Enemy {
  protected int completed;
  protected float xPos, yPos, xSpeed, ySpeed;
  protected String word;

  //constructor
  public Enemy(int x, int y, String word) {
    //set the location
    this.xPos = x;
    this.yPos = y;
    this.word = word.toLowerCase();
    completed = 0;
    //set the speed - down is dependant on the length of the word, horizontal is random
    float down = (5.0/ (float)word.length()), right = random(-3, 3);
    //dont allow the horizontal speed to be between -1 and 1
    if (right >= 0 && right < 1) {
      right++;
    } else if (right > -1 && right < 0) {
      right--;
    }
    ySpeed = down;
    xSpeed = right;
    //draw the enemy
    update();
  }
  
  //getters and setters

  public void setX(float x) {
    this.xPos = x;
  }

  public void setY(float y) {
    this.yPos = y;
  }

  public void setCompleted(int completed) {
    this.completed = completed;
  }

  public void setWord(String word) {
    this.word = word.toLowerCase();
  }

  public float getX() {
    return xPos;
  }

  public float getY() {
    return yPos;
  }

  public String getWord() {
    return word;
  }

  public int getCompleted() {
    return completed;
  }

  public char currentLetter() {
    return word.charAt(completed);
  }

  public boolean letterTyped() {
    completed++;
    return completed == word.length();
  }

  //updates the enemy
  public void update() {
    //move the enemy down
    fall();
    //draw the word
    rect(xPos - 5, yPos - 30, word.length() * 20 + 10, 40);
    fill(0, 255, 0);
    textSize(30);
    textAlign(RIGHT);
    text(word.substring(0, completed), xPos + (completed * 20), yPos);
    fill(0, 0, 255);
    textAlign(LEFT);
    text(word.substring(completed), xPos + (completed * 20), yPos);
    //draw the image
    image(typingGame.imgEnemy, xPos + ((word.length() * 20)/2) - 37, yPos - 75, 75, 37);
  }

  //makes the enemy fall down the screen and bounce side to side
  private void fall() {
    //bounce off the sides of the screen
    if (xPos > width - (word.length() * 20) - 5 || xPos < 0) {
      xSpeed = -xSpeed;
    }
    //move the enemy
    xPos += xSpeed;
    yPos += ySpeed;
  }

//these methods return where sparks can be created for the enemy

  public float sparkMinX() {
    return xPos + ((word.length() * 20)/2) - 37;
  }

  public float sparkMaxX() {
    return xPos + ((word.length() * 20)/2) + 37;
  }

  public float sparkMinY() {
    return yPos - 75;
  }

  public float sparkMaxY() {
    return yPos - 37;
  }
}