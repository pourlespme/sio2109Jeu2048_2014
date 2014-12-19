library gamegrid;

class Grille<T> {
  final int taille;
  List<List<T>> cellules;

  Grille(int taille)
    : taille = taille,
      cellules = new List.generate(taille, (i) => new List()..length = taille); 

  List<List<T>> get cells => cellules;

  resizeGrille(int newTaille){
    List<List<T>> newCellules = new List.generate(newTaille, (i) => new List()..length = newTaille);
    for (int i = 0; i < taille; i++) {
      for (int j = 0; j < taille; j++) {
        newCellules[i][j] = cellules[i][j];
      }
    }
    cellules = newCellules;
    //cellules.length.
  }

  T getCell(int dir, int i, int j) =>
      cellules[getLge(dir, i, j)][getCol(dir, i, j)];
      

  T setCell(int dir, int i, int j, T v) =>
      cellules[getLge(dir, i, j)][getCol(dir, i, j)] = v;

  int getLge(d, i, j) => (d == 0) ? i : (d == 1) ? j :
    (d == 2) ? taille - i - 1 : taille - j - 1;

  int getCol(d, i, j) => (d == 0) ? j : (d == 1) ? i :
    (d == 2) ? taille - j - 1 : taille - i - 1;

}
