/*
Isaac Wismer
Feb 2016
This is the Planet class
it extends the abstract decoration class
*/
class Planet extends AbstractDecoration {
  //constructor
  public Planet(float x, float y, int img) {
    super(x, y);
    //sets the image to be one of a planet
    photo = typingGame.planets[img];
  }
  //uses the default update method
}