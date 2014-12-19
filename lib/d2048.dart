library dart2048;

import 'dart:async';
import 'dart:html';
import 'dart:math' show Random, max, min;
import 'package:polymer/polymer.dart';
import 'grid.dart';


@CustomTag('d2048-game')
class Jeu extends PolymerElement {
  final aleatoire = new Random();
  int taille=4;
  //final int taille2 = 5;
  //final int taille3 = 6;
  final tpstrans = new Duration(milliseconds: 180);

  Grille grille;

  @observable int score = 0;
  @observable bool gameOver = false;
  @observable bool gameWon = false;
  bool mouvement = false;


  @observable var ticks=[0,1,2,3];
  //final ticks2 = [0, 1, 2, 3 , 4 ];
  //final ticks3 = [0, 1, 2, 3 , 4 , 5];
  CheckboxInputElement radio1, radio2, radio3;
  ButtonElement changeButton;

  
  Jeu.created() : super.created() {
    radio1 = shadowRoot.querySelector("#tool-selector-1");
    radio2 = shadowRoot.querySelector("#tool-selector-2");
    radio3 = shadowRoot.querySelector("#tool-selector-3");

    window.onKeyDown
        .map((e) => e.keyCode - 37)
        .where((k) => k >= 0 && k <= 3 &&
            gameOver == false && mouvement == false)
        .listen(move);
  }

  start() {    
    
    grille = new Grille(taille);
    $['tiles'].children.clear();
    score = 0;
    gameOver = false;
    gameWon = false;
    newTile();
    newTile();
  }
  

   loadTicks(){
     
    if (radio1.checked){
      taille = 4;
      ticks = [0, 1, 2, 3];
    
    } else if (radio2.checked){
      taille = 5;
      ticks = [0, 1, 2, 3, 4];
    } else {
      taille = 6;
      ticks = [0, 1, 2, 3, 4, 5];
    }
    grille.resizeGrille(taille);
  }  
  
  newTile() {
        var carreaux = $['tiles'];
        assert(carreaux.children.length < taille * taille);
        while (true) {
          int ligne = aleatoire.nextInt(taille);
          int col = aleatoire.nextInt(taille);
          if (grille.getCell(0, ligne, col) == null) {
            var value = aleatoire.nextDouble() < 0.9 ? 2 : 4;
            var carreau = grille.setCell(0, ligne, col, new Carreau(value));
            carreaux.children.add(carreau);
            carreau.setPosition(ligne, col);
            break;
          }
        }
        if (carreaux.children.length == taille * taille) {
          gameOver = isGameOver();
        }
      }
  
  move(int dir) {
     bool moved = false;
     for (int i = 0; i < taille; i++) {
       int espaces = 0;
       Carreau prevcar = null;
       for (int j = 0; j < taille; j++) {
         var carreau = grille.getCell(dir, i, j);
         if (carreau == null) {
           espaces++;
         } else {
           bool fusion = prevcar != null && prevcar.value == carreau.value;
           if (fusion) {
             espaces++;
             prevcar.style.setProperty('z-index', '100');
           }
           if (espaces > 0) {
             assert(grille.getCell(dir, i, j) == carreau);
             int newJ = j - espaces;
             grille.setCell(dir, i, j, null);
             grille.setCell(dir, i, newJ, carreau);
             carreau.setPosition(
                 grille.getLge(dir, i, newJ),
                 grille.getCol(dir, i, newJ));
             moved = true;
             mouvement = true;
           }
           if (fusion) {
             var carfus = prevcar;
             carreau.onTransitionEnd.first.then((_) {
               carreau.value *= 2;
               score += carreau.value;
               carfus.remove();
               if (carreau.value == 2048) {
                 gameWon = true;
               }
             });
             prevcar = null;
           } else {
             prevcar = carreau;
           }
         }
       }
     }
     if (moved) {
       $['tiles'].onTransitionEnd.first.then((_) {
         new Future(() { 
           newTile();
           mouvement = false;
         });
       });
     }
   }
  
   isGameOver() {
     for (int i = 0; i < taille - 1; i++) {
       for (int j = 0; j < taille - 1; j++) {
         var carreau = grille.getCell(0, i, j);
         if (carreau == null) return false;
         var value = carreau.value;
         var voisine = grille.getCell(0, i+1, j);
         if (voisine == null || voisine.value == value) return false;
         voisine = grille.getCell(0, i, j+1);
         if (voisine == null || voisine.value == value) return false;
       }
     }
     return true;
   }

}

@CustomTag('d2048-tile')
class Carreau extends PolymerElement with Observable {
  @published @PublishedProperty(reflect: true) int value;

  Carreau.created() : super.created();

  factory Carreau(value) => (new Element.tag('d2048-tile') as Carreau)
      ..value = value;

  setPosition(ligne, col) {
    style.setProperty('-webkit-transform',
        'translate(${19 + col * 127}px, ${19 + ligne * 130}px)');
  }

}
