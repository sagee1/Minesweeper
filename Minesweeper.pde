import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined
private int numClicked = 0;

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
   
    // make the manager
    Interactive.make( this );
   
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int i = 0; i < NUM_ROWS; i++){
      for(int j = 0; j < NUM_COLS; j++){
        buttons[i][j] = new MSButton(i, j);
      }
    }
   
   
    setMines();
}
public void setMines()
{
    //your code
    for(int i = 0; i < 40; i++){
      int rRandom = (int)(Math.random()*NUM_ROWS);
      int cRandom = (int)(Math.random()*NUM_COLS);
      if(!mines.contains(buttons[rRandom][cRandom])){
        mines.add(buttons[rRandom][cRandom]);
      }
    }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
    //your code here
    int flaggedMines= 0;
    int spaces = 0;
    for (int r= 0; r<NUM_ROWS; r++) {
      for (int c = 0; c<NUM_COLS; c++) {
        if(buttons[r][c].flagged == true && mines.contains(buttons[r][c])) {
          flaggedMines++;
        }  
        if(buttons[r][c].clicked==true && !mines.contains(buttons[r][c]) && buttons[r][c].flagged == false) {
          spaces++;
        }
      }
    }
    
    if (flaggedMines == mines.size() && spaces == (NUM_ROWS*NUM_COLS-mines.size())) {
      return true;
    }
    else{
      return false;
    }
}
public void displayLosingMessage()
{
    //your code here
    buttons[9][6].setLabel("Y");
    buttons[9][7].setLabel("O");
    buttons[9][8].setLabel("U");
    buttons[9][9].setLabel("L");
    buttons[9][10].setLabel("O");
    buttons[9][11].setLabel("S");
    buttons[9][12].setLabel("E");
    buttons[9][13].setLabel(":P");
    
}
public void displayWinningMessage()
{
    //your code here
    buttons[9][6].setLabel("Y");
    buttons[9][7].setLabel("O");
    buttons[9][8].setLabel("U");
    buttons[9][9].setLabel("W");
    buttons[9][10].setLabel("I");
    buttons[9][11].setLabel("N");
    buttons[9][12].setLabel(":D");
}
public boolean isValid(int r, int c)
{
    //your code here
    if(r < NUM_ROWS && c < NUM_COLS && r >= 0 && c >= 0){
      return true;
    }
    else{
      return false;
    }
}
public int countMines(int row, int col)
{
    int numMines = 0;
    //your code here
    for(int r = -1; r <= 1; r++){
     for(int c = -1; c <= 1; c++){
      if(isValid(row + r, col + c) == true && mines.contains(buttons[row+r][col+c])){
         numMines++;
       }
     }
    }
    if(mines.contains(buttons[row][col])){
      numMines--;
    }
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    //counter for spaces clicked
   
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col;
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
       
    }

    // called by manager
    public void mousePressed ()
    {
        clicked = true;
        //your code here
        if(mouseButton == RIGHT){
          if(flagged == true){
            flagged = false;
            clicked = false;
          }
          else{
            flagged = true;
          }
        }

          else if(mines.contains(this)){
          displayLosingMessage();
          }
          else if(isWon() == true){
            displayWinningMessage();
          }
          else if(countMines(myRow, myCol) > 0){
            setLabel(countMines(myRow, myCol));
          }
          else {
            if(isValid(myRow, myCol) && !mines.contains(buttons[myRow][myCol])){
              for(int r = myRow-1; r <= myRow+1; r++){
               for(int c = myCol-1; c <= myCol+1; c++){
                 if(isValid(r,c) == true && !buttons[r][c].clicked){
                   buttons[r][c].mousePressed();
                 }
               }
              }
            }
          }
       
    }
    public void draw ()
    {    
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) )
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
