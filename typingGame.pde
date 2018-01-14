/*
Isaac Wismer
 Feb 2016
 This is a typing game made for TEJ4M
 */

import java.util.Scanner;

//all my variables
//arraylists
ArrayList<Enemy> enemies;
ArrayList<Integer> currentWords;
ArrayList<Spark> sparks;
ArrayList<String[]> highscores;
int score = 0, frameCounter = 0, scene = 0, level = 1, keysTyped = 0, correctLetters = 0;
//final its of which scene you are on
final int MAIN_MENU = 0, GAME = 1, PAUSED = 2, GAME_OVER = 3, COUNTDOWN = 4, HIGHSCORES = 5;
Player p;
String[] wordList = new String[1000];
Button b;
Button[] menuButtons;
boolean mouseActive = true;
Background back;
static PImage spark, imgEnemy;
static PImage planets[], stars[];
String name;

void setup() {
  //set up the window
  frameRate(60);
  size(1500, 1500);
  //create ht font I use
  PFont f = createFont("include/Anonymous.ttf", 30);
  textFont(f);
  //read the words
  BufferedReader r = createReader("include/wordlist.txt");
  try {
    //my list is supposed to be the 1000 most used english words
    for (int i = 0; i < 1000; i++) {
      wordList[i] = r.readLine();
    }
  } 
  catch (IOException e) {
    e.printStackTrace();
  }
  //import the images I use
  spark = loadImage("include/spark.png");
  imgEnemy = loadImage("include/enemy.png");
  planets = new PImage[4];
  stars = new PImage[4];
  for (int i = 0; i < 4; i++) {
    planets[i] = loadImage("include/planet" + i + ".png");
    stars[i] = loadImage("include/star" + i + ".png");
  }
  //import the highscores
  name = "";
  highscores = new ArrayList();
  Scanner s = new Scanner(createReader("include/highscores.txt"));
  while (s.hasNextLine()) {
    String[] line = new String[4];
    for (int i = 0; i < 4; i++) {
      line[i] = s.nextLine();
    }
    highscores.add(line);
  }
}

void draw() {
  //Depending on what the current scene is, call the correct method
  switch (scene) {
  case MAIN_MENU:
    mainMenu();
    break;
  case GAME:
    game();
    break;
  case COUNTDOWN:
    countdown();
    break;
  case GAME_OVER:
    gameOver();
    break;
  case PAUSED:
    paused();
    break;
  case HIGHSCORES:
    highscores();
    break;
  }
}

//called whan a key on the keyboard is pressed
void keyTyped() {
  if (scene == GAME) {
    //pause with the spacebar
    if (key == ' ') {
      scene = PAUSED;
    } else {
      //add 1 to the total number of keys typed
      keysTyped ++;
      //if there are no words selected
      if (currentWords.size() == 0) {
        //search through the list and try and find one that matches the key typed
        for (int i = 0; i < enemies.size(); i++) {
          if (key == enemies.get(i).currentLetter() && enemies.get(i).getY() > 0) {
            //add it to the list and create a spark
            currentWords.add(i);
            sparks.add(new Spark(random(enemies.get(currentWords.get(currentWords.size() - 1)).sparkMinX(), enemies.get(currentWords.get(currentWords.size() - 1)).sparkMaxX()), random(enemies.get(currentWords.get(currentWords.size() - 1)).sparkMinY(), enemies.get(currentWords.get(currentWords.size() - 1)).sparkMaxY())));
            if (currentWords.size() == 1) {
              correctLetters++;
            }
            //if it completes a word, clear the list and delete the word
            if (enemies.get(i).letterTyped()) {
              for (int j = 0; j < 10; j++) {
                sparks.add(new Spark(random(enemies.get(i).sparkMinX(), enemies.get(i).sparkMaxX()), random(enemies.get(i).sparkMinY(), enemies.get(i).sparkMaxY())));
              }
              enemies.remove(i);
              currentWords.clear();
            }
          }
        }
        if (currentWords.size() == 0) {
          score--;
        }
        //if there is a word selected
      } else {
        //check if the letter typed matches any of the current words
        boolean match = false;
        for (int i = 0; i < currentWords.size(); i++) {
          if (key == enemies.get(currentWords.get(i)).currentLetter()) {
            //make a spark appear within the enemy
            sparks.add(new Spark(random(enemies.get(currentWords.get(i)).sparkMinX(), enemies.get(currentWords.get(i)).sparkMaxX()), random(enemies.get(currentWords.get(i)).sparkMinY(), enemies.get(currentWords.get(i)).sparkMaxY())));
            match = true;
          }
        }
        if (match) {
          //if it does add one to correct letters
          correctLetters++;
          //println(enemies.get(current).getCompleted());
          for (int i = 0; i < currentWords.size(); i++) {
            //if it matches add spark
            if (key == enemies.get(currentWords.get(i)).currentLetter()) {
              if (enemies.get(currentWords.get(i)).letterTyped()) {
                score += enemies.get(currentWords.get(i)).getWord().length();
                for (int j = 0; j < 10; j++) {
                  //make a spark appear within the enemy
                  sparks.add(new Spark(random(enemies.get(currentWords.get(i)).sparkMinX(), enemies.get(currentWords.get(i)).sparkMaxX()), random(enemies.get(currentWords.get(i)).sparkMinY(), enemies.get(currentWords.get(i)).sparkMaxY())));
                }
                enemies.remove((int)currentWords.get(i));
                //current = -1;
                currentWords.clear();
                for (int j = 0; j < enemies.size(); j++) {
                  enemies.get(j).setCompleted(0);
                }
              }
            } else {
              //if it doesnt match remove it from the list
              enemies.get(currentWords.get(i)).setCompleted(0);
              currentWords.remove(i);
              i--;
            }
          }
        } else {
          //reduce the score for a mistyped letter
          score--;
        }
      }
    }
  } else if (scene == PAUSED) {
    //when paused space unpauses, enter quits
    if (key == ' ') {
      scene = GAME;
    } else if (keyCode == ENTER) {
      scene = MAIN_MENU;
    }
  } else if ( scene == GAME_OVER) {
    //allows you to type your name for a highscore
    if (keyCode == BACKSPACE) {
      if (name.length() > 1) {
        name = name.substring(0, name.length() - 2);
      } else { 
        name = "";
      }
    } else if (keyCode != TAB && keyCode != ENTER) {
      name += key;
    }
  }
}

//detects collisions between the player and enemies
public void hitDetection(int i) {
  //check every 5px along the top and bottom of the word box
  for (int j = 0; j <= enemies.get(i).getWord().length() * 2 + 1; j++) {
    fill(255, 0, 0);
    //ellipse(enemies.get(i).getX() + (j * 10) - 5, enemies.get(i).getY() - 30, 10, 10);
    //ellipse(enemies.get(i).getX() + (j * 10) - 5, enemies.get(i).getY() + 10, 10, 10);
    if (dist((p.getX() + 37), (p.getY() + 40), enemies.get(i).getX() + (j * 10) - 5, enemies.get(i).getY() - 30) < 35|| dist((p.getX() + 37), (p.getY() + 40), enemies.get(i).getX() + (j * 10) - 5, enemies.get(i).getY() + 10) < 35) {
      //fill(255, 255, 255);
      //ellipse(enemies.get(i).getX() + (j * 10) - 5, enemies.get(i).getY() - 30, 10, 10);
      //ellipse(enemies.get(i).getX() + (j * 10) - 5, enemies.get(i).getY() - 10, 10, 10);
      //ellipse(enemies.get(i).getX() + (j * 10) - 5, enemies.get(i).getY() + 10, 10, 10);
      p.hit();
      sparks.add(new Spark(random(p.getX(), p.getX() + 75), random(p.getY(), p.getY() + 80)));
      println("HIT");
      return;
    }
  }
  //check along each side of the word box
  for (int j = 1; j < 4; j++) {
    fill(255, 0, 0);
    //ellipse(enemies.get(i).getX() - 5, enemies.get(i).getY() - 30 + (j * 10), 10, 10);
    //ellipse(enemies.get(i).getX() + (enemies.get(i).getWord().length() * 20) + 5, enemies.get(i).getY()  - 30 + (j * 10), 10, 10);
    if (dist((p.getX() + 37), (p.getY() + 40), enemies.get(i).getX() - 5, enemies.get(i).getY() - 30 + (j * 10)) < 35|| dist((p.getX() + 37), (p.getY() + 40), enemies.get(i).getX() + (enemies.get(i).getWord().length() * 20) + 5, enemies.get(i).getY()  - 30 + (j * 10)) < 35) {
      //fill(255, 255, 255);
      //ellipse(enemies.get(i).getX() - 5, enemies.get(i).getY() - 30 + (j * 10), 10, 10);
      //ellipse(enemies.get(i).getX() + (enemies.get(i).getWord().length() * 20) + 5, enemies.get(i).getY()  - 30 + (j * 10), 10, 10);
      p.hit();
      sparks.add(new Spark(random(p.getX(), p.getX() + 75), random(p.getY(), p.getY() + 80)));
      println("HIT");
      return;
    }
  }
  //check the picture of the UFO
  fill(255, 0, 0);
  //ellipse((enemies.get(i).sparkMinX() + enemies.get(i).sparkMaxX())/2, (enemies.get(i).sparkMinY() + enemies.get(i).sparkMaxY())/2, 50, 50);
  if (dist((p.getX() + 37), (p.getY() + 40), (enemies.get(i).sparkMinX() + enemies.get(i).sparkMaxX())/2, (enemies.get(i).sparkMinY() + enemies.get(i).sparkMaxY())/2) < 60) {
    //fill(255, 255, 255);
    //ellipse((enemies.get(i).sparkMinX() + enemies.get(i).sparkMaxX())/2, (enemies.get(i).sparkMinY() + enemies.get(i).sparkMaxY())/2, 50, 50);
    p.hit();
    sparks.add(new Spark(random(p.getX(), p.getX() + 75), random(p.getY(), p.getY() + 80)));
    println("HIT");
    return;
  }
}

//allows the user to click again after they release the mosue button
void mouseReleased() {
  mouseActive = true;
}

//draws the main menu
public void mainMenu() {
  //on the first time the menu is drawm, create buttons
  if (frameCounter == 0) {
    menuButtons = new Button[]{new Button(350, 500, 800, 200, "PLAY"), new Button(350, 750, 800, 200, "HIGHSCORES"), new Button(350, 1000, 800, 200, "QUIT")};
    back = new Background();
    frameCounter++;
  }
  //draw the menu
  background(0, 0, 0);
  back.update();
  fill(255, 255, 255);
  textSize(150);
  textAlign(CENTER, CENTER);
  text("SPACE TYPE", 750, 250);
  //if the first button is clicked (the play button)
  if (menuButtons[0].mouseOver() && mousePressed && mouseActive) {
    //dont let them clikc until they release the mouse button
    mouseActive = false;
    //reset all the game stats
    level = 1;
    score = 0;
    keysTyped = 0;
    correctLetters = 0;
    currentWords = new ArrayList();
    p = new Player();
    frameCounter = 0;
    //go to the countdown screen
    scene = COUNTDOWN;
  }
  //button 2 (highscores)
  if (menuButtons[1].mouseOver() && mousePressed && mouseActive) {
    mouseActive = false;
    frameCounter = 0;
    //go to the highscores screen
    scene = HIGHSCORES;
  }
  //quit button
  if (menuButtons[2].mouseOver() && mousePressed && mouseActive) {
    mouseActive = false;
    //exit the application
    exit();
  }
}

//called when the scene is GAME
public void game() {
  //blackbackground, draw the planets and stars
  background(0, 0, 0);
  back.update();
  //draw the player
  p.update();
  //draw the score text
  fill (255, 255, 255);
  textAlign(LEFT, CENTER);
  textSize(30);
  text("SCORE: " + score, 50, 50);
  //update each of the enemies
  for (int i = 0; i < enemies.size(); i ++) {
    if (currentWords.contains((Integer)i)) {
      fill(#FF4D4D);
      enemies.get(i).update();
    } else {
      fill(#BCB8B8);
      enemies.get(i).update();
    }
    //do hit detection for each of the enemies
    hitDetection(i);
    //delete the enemies if they below the bottom of the screen
    if (enemies.get(i).getY() > 1575) {
      score -= enemies.get(i).getWord().length();
      enemies.remove(i);
      currentWords.remove((Integer) i);
      for (int j = 0; j < currentWords.size(); j++) {
        if (currentWords.get(j) > i) {
          currentWords.set(j, currentWords.get(j) - 1);
        }
      }
    }
  }
  //update each spark
  for (int i = 0; i < sparks.size(); i++) {
    sparks.get(i).update();
    //if its below the bottom delete it
    if (sparks.get(i).getY() > 1500) {
      sparks.remove(i);
      i--;
    }
  }
  //go to next level if there are no enemies left
  if (enemies.size() == 0) {
    level++;
    frameCounter = 0;
    scene = COUNTDOWN;
  }
  //end the game if the player goes off the screen
  if (p.getY() > 1500) {
    frameCounter = 0;
    name = "";
    scene = GAME_OVER;
  }
}

//this is the scene that loads the game and counts down for the user
public void countdown() {
  //increase frame count
  frameCounter++;
  //draw the text
  background(0, 0, 0);
  textAlign(LEFT, CENTER);
  textSize(30);
  fill(255, 255, 255);
  text("SCORE: " + score, 50, 50);
  textAlign(CENTER, CENTER);
  textSize(200);
  fill(255, 255, 255);
  text("LEVEL: " + level, 750, 500);
  println(frameCounter);
  if (frameCounter == 1) {
    //for the first frame load the level objects
    //create new enemies
    enemies = new ArrayList();
    for (int i = 0; i < level * 5; i++) {
      boolean wordMatch = true;
      int w = 0;
      while (wordMatch) {
        w = (int)random(1000);
        wordMatch = false;
        for (int j = 0; j < enemies.size(); j++) {
          if (wordList[w].equals(enemies.get(j).getWord())) {
            wordMatch = true;
            j = enemies.size();
          }
        }
      }
      enemies.add(new Enemy(750, (int)random(-(level *100), 0), wordList[w]));
      enemies.get(i).setX((int)random(0, 1500 - (enemies.get(i).getWord().length() * 20)));
    }
    //empty the sparks arraylist
    sparks = new ArrayList();
    //if the level is greater than 5 give the player a side to side motion
    if (level < 5) {
      p.setXSpeed(0);
    } else {
      p.setXSpeed(level/5.0);
    }
    //generate a new background
    back = new Background();
    //display each of the messages for approx a second each
  } else if (frameCounter < 60) {    
    text("READY", 750, 750);
  } else if (frameCounter >= 60 && frameCounter < 120) {
    text("SET", 750, 750);
  } else if (frameCounter >= 120 && frameCounter < 180) {
    text("GO!", 750, 750);
  } else {
    //after the countdown show the game
    scene = GAME;
  }
}

//this is the scene that shows when the player has lost
public void gameOver() {
  //only on the first frame create a new button
  if (frameCounter == 0) {
    b = new Button(350, 800, 800, 200, "MAIN MENU");
    frameCounter++;
  }
  //draw the background and stats
  background(0, 0, 0);
  fill(255, 255, 255);
  textSize(150);
  textAlign(CENTER, CENTER);
  text("GAME OVER", 750, 250);
  textSize(50);
  text("LEVEL: " + level, 750, 350);
  text("SCORE: " + score, 750, 400);
  //correctLetters = 57;
  //keysTyped = 567;
  text("ACCURACY: " + ((float) correctLetters / (float) keysTyped) * 100.0 + "%", 750, 450);
  //get them to type their name
  text("TYPE YOUR NAME:", 750, 500);
  text(name, 750, 550);
  if (b.mouseOver() && mousePressed) {
    //delay(100);
    //add the new highscore
    if (name.equals("")) {
      name = "anonymous";
    }
    highscores.add(new String[]{name, String.valueOf(level), String.valueOf(score), String.valueOf(((float) correctLetters / (float) keysTyped) * 100.0) + "%"});
    //resort the highscores
    quickSort(highscores, 0, highscores.size() - 1);
    //save the highscores
    PrintWriter p = createWriter("highscores.txt");
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 4; j++) {
        p.println(highscores.get(i)[j]);
      }
    }
    p.flush();
    p.close();
    //go back to the menu
    mouseActive = false;
    scene = MAIN_MENU;
  }
}

//displayed when the game is paused
public void paused() {
  //draw the background and game stats
  background(0, 0, 0);
  textAlign(CENTER, CENTER);
  fill(255, 255, 255);
  textSize(150);
  text("SPACE TYPE", 750, 300);
  textSize(200);
  text("PAUSED", 750, 500);
  textSize(50);
  text("LEVEL: " + level, 750, 650);
  text("SCORE: " + score, 750, 700);
  //correctLetters = 57;
  //keysTyped = 567;
  text("ACCURACY: " + ((float) correctLetters / (float) keysTyped) * 100.0 + "%", 750, 750);
  //instructions on what to do
  textSize(100);
  text("Press SPACE to RESUME", 750, 850);
  text("Press ENTER to QUIT", 750, 950);
}

public void highscores() {
  //create the button
  if (frameCounter == 0) {
    frameCounter++;
    b = new Button(350, 1200, 800, 200, "MAIN MENU");
  }
  //drwa background and check the button
  background(0, 0, 0);
  textSize(150);
  fill(255, 255, 255);
  text("HIGHSCORES", 750, 100);
  if (b.mouseOver() && mousePressed) {
    //if the button is pressed go back to the menu
    mouseActive = false;
    scene = MAIN_MENU;
  }
  //display the top 3 highscores
  for (int i = 0; i < 3 && i < highscores.size(); i++) {
    fill(255, 0, 0);
    rect(350, 200 + i * 300, 800, 250, 10);
    textSize(50);
    textAlign(CENTER, CENTER);
    fill(0, 0, 0);
    text("NAME: " + highscores.get(i)[0], 750, 250 + i * 300);
    text("LEVEL: " + highscores.get(i)[1], 750, 300 + i * 300);
    text("SCORE: " + highscores.get(i)[2], 750, 350 + i * 300);
    text("ACCURACY: " + highscores.get(i)[3], 750, 400 + i * 300);
  }
}

//sorting algorithm for the highscores
public static void quickSort(ArrayList<String[]> list, int lo, int hi) {
  //continue while it's still sorting something
  if (lo < hi) {
    //set the left and right indexs and the pivot to the center
    int l = lo, r = hi, pivot = Integer.parseInt(list.get((lo + hi)/2)[2]);
    //loop while the left and right havn't passed each other
    while (l <= r) {
      //while the left value is less than the pivot, increase the left value
      while (Integer.parseInt(list.get(l)[2]) > pivot) {
        l++;
      }
      //while the right value is less than the pivot, increase the left value
      while (Integer.parseInt(list.get(r)[2]) < pivot) {
        r--;
      }
      //swap the 2 values as long as they have not overlapped
      if (l <= r) {
        String[] temp = list.get(l);
        list.set(l, list.get(r));
        list.set(r, temp);
        l++;
        r--;
      }
    }
    //sort the left and right halves of the list
    quickSort(list, l, hi);
    quickSort(list, lo, r);
  }
}