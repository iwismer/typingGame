/*
Isaac Wismer
Feb 2016
This is the background class
it contains an arraylist of the decor for the background
*/
class Background {

  ArrayList<AbstractDecoration> decor;

  public Background() {
    //create the backround with 2/3 stars and 1/3 planets
    //it has a total of 45 objects
    decor = new ArrayList();
    for (int i = 0; i < 15; i++) {
      decor.add(new Planet(random(0, 1500), random(0, 1500), (int)random(0, 4))); 
      decor.add(new Star(random(0, 1500), random(0, 1500), (int)random(0, 4))); 
      decor.add(new Star(random(0, 1500), random(0, 1500), (int)random(0, 4)));
    }
  }

  //update each of the objects in the arraylist
  public void update() {
    for (AbstractDecoration d : decor) {
      d.update();
    }
  }
}