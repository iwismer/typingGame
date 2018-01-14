/*
Isaac Wismer
Feb 2016
This is the Star class
it extends the abstract decoration class
*/

class Star extends AbstractDecoration {
  
    //constructor
  public Star(float x, float y, int img) {
    super(x, y);
    //sets the photo to be one of a star
    photo = typingGame.stars[img];
  }

  //overrides the update method of the superclass to draw the image smaler
  @Override
    public void update() {
    image(photo, xPos, yPos, 20, 20);
  }
}