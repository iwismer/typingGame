/*
Isaac Wismer
Feb 2016
this is a button class.
It detects when the mouse is over it and allows for a stanard button throughout the project
*/
class Button {
  //variables for the location and colours
  int x, y, w, h, rInit, gInit, bInit, rHover, gHover, bHover;
  //what the button says
  String text;

  //constructor
  public Button(int x, int y, int w, int h, String text) {
    //sets the location and size and text
    this.x = x;
    this.y = y;
    this.h = h;
    this.w = w;
    this.text = text;
    //sets the default colours
    this. rInit = 255;
    this.gInit = 0;
    this.bInit = 0;
    this.rHover = 52;
    this.gHover = 160;
    this.bHover = 68;
    fill(rInit, gInit, bInit);
  }

  //change the colour that displays when the mouse is not over the button
  public void setInitColour(int rInit, int gInit, int bInit) {
    this. rInit = rInit;
    this.gInit = gInit;
    this.bInit = bInit;
  }

  //change the colour of the button when the mouse is over the button
  public void setHoverColour(int rHover, int gHover, int bHover) {
    this.rHover = rHover;
    this.gHover = gHover;
    this.bHover = bHover;
  }

  //checks if the mouse is over the button
  public boolean mouseOver() {
    //if it is over the button
    if (mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h) {
      //fill it with the hover colour and add a border
      fill(255, 0, 0);
      rect(x-20, y-20, w + 40, h+40, 10);
      fill(rHover, gHover, bHover);
      rect(x, y, w, h, 10);
      textSize(h/2);
      fill(0, 0, 0);
      text(text, x + (w/2), y + (h/2));
      return true;
    } else {
      //when the mouse is not over the button fill with the default colour
      fill(rInit, gInit, bInit);
      rect(x, y, w, h, 10);
      textSize(h/2);
      fill(255, 255, 255);
      text(text, x + (w/2), y + (h/2));
      return false;
    }
  }
}