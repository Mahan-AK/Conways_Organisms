// Initial setup varibales
int w_box = 100;
int h_box = 72;
int cell_dim = 10;
double init_live_density = 0.4;

// Pseudo-Random initialization seed ## set to -1 for random initialization
int Random_Seed = -1;

// Global board variable
boolean[][] board = new boolean[w_box][h_box];

// We store index of Cells inside a pattern in patterns variable
ArrayList<int[]> patterns = new ArrayList<int[]>();


// Function to check if cell is going to live based on it's neighbours
boolean isAlive(int i, int j) {
  int liveNeighbours = 0;
  
  int startPosX = (i - 1 < 0) ? i : i-1;
  int startPosY = (j - 1 < 0) ? j : j-1;
  int endPosX =   (i + 1 > w_box - 1) ? i : i+1;
  int endPosY =   (j + 1 > h_box - 1) ? j : j+1;
  
  for (int rowNum=startPosX; rowNum<=endPosX; rowNum++) {
    for (int colNum=startPosY; colNum<=endPosY; colNum++) {
      if (board[rowNum][colNum]) liveNeighbours++;
    }
  }
  
  if (board[i][j]) liveNeighbours--;
  
  if (board[i][j] && liveNeighbours == 2 || liveNeighbours == 3) return true;
  
  return false;
}

// This function checks if the pattern is valid in the window
boolean checkPattern(int i, int j, boolean[][] board, boolean[][] pattern) {
  int pH = pattern.length;
  int pW = pattern[0].length;
  
  // Pattern should be surrounded by empty cells or borders (isolated)
  if (i != 0) {
    for (int a = 0; a < pW; a++) if (board[i-1][j+a]) return false; // checks cells in the west
  }
  if (j != 0) {
    for (int b = 0; b < pH; b++) if (board[i+b][j-1]) return false; // checks cells in the south
  }
  if (i + pH != board.length) {
    for (int c = 0; c < pW; c++) if (board[i+pH][j+c]) return false; // checks cells in the east
  }
  if (j + pW != board[0].length) {
    for (int d = 0; d < pH; d++) if (board[i+d][j+pW]) return false; // checks cells in the north
  }
  
  // These if statements check the cells in pattern's neighbouring corners
  if (i != 0 && j != 0 && board[i-1][j-1]) return false;
  if (i != 0 && j + pW != board[0].length && board[i-1][j+pW]) return false;
  if (i + pH != board.length && j != 0 && board[i + pH][j-1]) return false;
  if (i + pH != board.length && j + pW != board[0].length && board[i + pH][j+pW]) return false;
  
  // We check if patterns are the same in the window
  for (int x = 0; x < pH; x++) {
    for (int y = 0; y < pW; y++) {
      if (board[i+x][j+y] != pattern[x][y]) return false;
    }
  }
  
  return true;
}

// Sliding window to find all patterns
void findPatterns(boolean[][] board, boolean[][] pattern) {
  int pH = pattern.length;
  int pW = pattern[0].length;
  
  for (int i = 0; i < board.length - pH + 1; i++) {
    for (int j = 0; j < board[0].length - pW + 1; j++) {
      if(checkPattern(i, j, board, pattern)) {
        // if pattern is found in current window, save it's cells' coordinates in patterns
        for (int x = 0; x < pH; x++) {
          for (int y = 0; y < pW; y++) {
            if (board[i+x][j+y]) {
              int[] coor = {i+x, j+y};
              patterns.add(coor);
            }
          }
        }
      }
    }
  }
}

// Updating all cells and patterns
void update() {
  boolean[][] new_board = new boolean[w_box][h_box];
  
  for (int i = 0; i < new_board.length; i++) {
    for (int j = 0; j < new_board[0].length; j++) {
      new_board[i][j] = isAlive(i, j);
    }
  }
  patterns.clear();
  for (boolean[][] target: targets) findPatterns(new_board, target);
  board = new_board;
}

// Draws the cells
void show() {
  for(int i=0;i<w_box;i++){
    for(int j=0;j<h_box;j++){
      if (board[i][j]) fill(0);
      else fill(255);
      rect(i*cell_dim, j*cell_dim, cell_dim, cell_dim);
    }
  }
  
  fill(255, 0, 0);
  for (int[] coor: patterns) {
    rect(coor[0]*cell_dim, coor[1]*cell_dim, cell_dim, cell_dim);
  }
  fill(255);
}

// In setup we initialize the board randomly with predefined live cell density
void setup() {
  if (Random_Seed != -1) randomSeed(Random_Seed);
  
  for (int i = 0; i < board.length; i++) {
    for (int j = 0; j < board[0].length; j++) {
      if (random(1) < init_live_density) board[i][j] = true;
    }
  }
  
  size(1000, 720); // x10
  frameRate(10);
}

void draw() {
  update();
  show();
}
