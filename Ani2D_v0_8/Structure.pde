/*
  Classe permettant l'affichage d'un ensemble de formes et de noeuds, de les modifier,
  etc ...
*/


class Structure {
  
  //PARAMETRES
    private PGraphics page;
    
    private ArrayList<Noeud> noeuds = new ArrayList<Noeud>();
    private Noeud noeudStructure;
         
    private ArrayList<Forme> formes = new ArrayList<Forme>();
    
    private boolean afficherNoeuds = true;
    
    String nom = "";
    String id = null;
    
  
  //CONSTRUCTEURS
    Structure(PGraphics page) {
      this.page = page;
      this.noeudStructure = new Noeud(page , new PVector());
    }
    
    
    Structure(PGraphics page , PVector v) {
      this.page = page;
      this.noeudStructure = new Noeud(page,v);
    }
    
    
    Structure(PGraphics page , int x , int y , int z) {
      this.page = page;
      this.noeudStructure = new Noeud(page,x,y,z);
    }
  
  
  
  //METHODES
    //PUBLICS
      //Affichage : diférent mode d'affichage en fonction du mode choisi
        public void affichageEdition() {
          //on n'affiche pas le noeud de la structure car on doit la placer au centre lors de son édition
          //affichage des formes
            for (Forme f : formes) {
              f.affichage(); 
            }
          //affichage des noeuds (à la fin pour les voir)
            if (afficherNoeuds) {
              for (Noeud n : noeuds) {
                n.affichage();
              }
            }
        }//fin affichageEdition
        
        
      /////////////////////////////////////////////////////////////////////////////////////////////////
      //Action sur la liste noeuds
        public void ajouterNoeud(int x , int y , int z) {
          noeuds.add(new Noeud(page , x,y,z,getLastNoeudId()+1));
        }//fin ajouterNoeud
        public void ajouterNoeud(PVector v) {
          noeuds.add(new Noeud(page , v,getLastNoeudId()+1));
        }//fin ajouterNoeud
        
        public int getLastNoeudId() {
          int idMax = -1;
          for (Noeud n : noeuds) {
            idMax = max(n.idInStructure,idMax);
          }
          return idMax;
        }//fin getLastNoeudId
        
        public void ajoutNodeLoad(Noeud n) {
          if (!noeuds.contains(n)) {
            noeuds.add(n);
          }
        }//fin ajoutNodeLoad
        
        public void supprimerNoeud(Noeud noeud) {
          noeuds.remove(noeud);
          //on supprime le cercle si il y'en a un d'attacher au noeud
            Cercle c = getCercleFromNoeud(noeud);
            if (c != null) {
              supprimerCercle(c);
            }
        }//fin supprimerNoeud
        
        public void selectionnerAllNoeuds() {
          for (Noeud n : noeuds) {
            n.select = true;
          }
        }//fin selectionnerAllNoeuds
        
        public void deselecionnerAllNoeuds() {
          for (Noeud n : noeuds) {
            n.select = false;
          }
        }//fin deselectionnerAllNoeuds
        
        public void selectionNoeud(int x , int y) {
          for (Noeud n : noeuds) {
            if (n.onNoeud(x,y)) {
              n.changeSelect();
            }
          }
          
          for (Forme f : formes) {
            for (Dessin d : f.dessins) {
                if (d.noeud.onNoeud(x,y)) {
                  d.noeud.changeSelect();
                  //retrait du noeud de la sélection dans le mode si déselectionné
                  if (d.noeud == ((ModeEditionStructure) mode).noeudTextureSelect && !d.noeud.getSelect()) {
                    ((ModeEditionStructure) mode).noeudTextureSelect = null;
                  }
                }
                
                //vérif pour le noeud unique sélectionnable
                if (d.noeud.getSelect()) {
                    if ( ((ModeEditionStructure) mode).noeudTextureSelect == null ) {
                      ((ModeEditionStructure) mode).noeudTextureSelect = d.noeud;
                    } else {
                      if ( ((ModeEditionStructure) mode).noeudTextureSelect != d.noeud ) {
                        ((ModeEditionStructure) mode).noeudTextureSelect.select = false;
                        ((ModeEditionStructure) mode).noeudTextureSelect = null;
                        ((ModeEditionStructure) mode).noeudTextureSelect = d.noeud;
                      } else {
                        ((ModeEditionStructure) mode).noeudTextureSelect = null;
                      }
                    }
                }
            }
          }
        }//fin selectionNoeud
        
        public ArrayList<Noeud> getAllNoeudsSelect() {
          ArrayList<Noeud> resultat = new ArrayList<Noeud>();
          for (Noeud n : noeuds) {
            if (n.getSelect()) {
              resultat.add(n);
            }
          }
          return resultat;
        }//fin getAllNoeudsSelect
        
        public void deplacerNoeudSouris(int x , int y , int z) {
          for (Noeud n : noeuds) {
            if (n.onNoeud(mouseX,mouseY)) {
              n.deplacement(x,y,z);
            }
          }
        }//fin deplacerNoeud
        public void deplacerNoeudSouris(PVector v) {
          for (Noeud n : noeuds) {
            if (n.onNoeud(mouseX,mouseY)) {
              n.deplacement(v);
            }
          }
        }//fin deplacerNoeud
        
        
        public Noeud getNoeudByIdInStructure(int id) {
          for (Noeud n : noeuds) {
            if (n.idInStructure == id) {
              return n;
            }
          }
          return null;
        }//fin de la méthode getNoeudByIdInStructure()
        
        
      /////////////////////////////////////////////////////////////////////////////////////////////////
      //Action sur la liste formes
      
        //Pour toutes les formes
          //public void supprimerForme(int x , int y) {
          //  //on commence par les cercles, puis les convexes, et finalement les plan
          //  //le but et d'éviter les problèmes dû au modif éventuel de la liste formes durant l'opération
          //    //parcourt de la liste de cercles
          //      for (Cercle c : getAllCercles()) {
          //        if (c.pointInForme(x,y)) {
          //          supprimerCercle(c);
          //        }
          //      }
          //    //parcourt de la liste de convexes
          //      for (Convexe cv : getAllConvexes()) {
          //        if (cv.pointInForme(x,y)) {
          //          supprimerConvexe(cv);
          //        }
          //      }
          //}//fin supprimerForme
          
          public void supprimerForme() {
            //on supprime toutes les formes sélectionnées
              //on commence par les cercles, puis les converxes, et finallement les plans pour éviter les modifs de tailles de la liste formes
            //parcourt de la liste de cercles
              for (Cercle c : getAllCercles()) {
                if (c.select) {
                  supprimerCercle(c);
                }
              }
            //parcourt de la liste de convexes
              for (Convexe cv : getAllConvexes()) {
                if (cv.select) {
                  supprimerConvexe(cv);
                }
              }
          }//fin supprimerForme
          
          public void selectionnerFormes(int x , int y) {
            for (Forme f : formes) {
              f.selection(x,y);
            }
          }//fin selectionnerFormes
          
          public ArrayList<Forme> getAllFormesSelect() {
            ArrayList<Forme> resultat = new ArrayList<Forme>();
              for (Forme f : formes) {
                if (f.select) {
                  resultat.add(f);
                }
              }
            return resultat;
          }//fin getAllFormesSelect
          
          public void ajoutForme(Forme f) {
            formes.add(f);
          }
          
          public int getLastFormeId() {
            int idMax = 0;
            for (Forme f : formes) {
              idMax = max(idMax,f.idInStructure);
            }
            return idMax;
          }//fin getLastFormeId
      
      
      
        
        //Pour les cercles
          public void ajouterCercle(Noeud n) {
            if (getCercleFromNoeud(n) == null) {
              formes.add(new Cercle(page , n,getLastFormeId()+1));
            }
          }//fin ajouterCercle
          
          public Cercle getCercleFromNoeud(Noeud n) {
            for (Cercle c : getAllCercles()) {
              if (c.noeud == n) {
                return c;
              }
            }
            return null;
          }//fin getCercleFromNoeud
          
          public void supprimerCercle(Cercle c) {
            formes.remove(c);
            //on supprime les plans liés
              for (Plan p : getPlansFromCercle(c)) {
                supprimerPlan(p);
              }
            //on supprime les convexes liés
              for (Convexe cv : getConvexesFromCercle(c)) {
                supprimerConvexe(cv);
              }
          }//fin supprimerCercle
          
          public void supprimerCercleFromNoeud(Noeud n) {
            Cercle c = getCercleFromNoeud(n);
            if (c != null) {
              formes.remove(c);
            }
          }//fin supprimerCercleFromNoeud
          
          public ArrayList<Cercle> getAllCercles() {
            ArrayList<Cercle> resultat = new ArrayList<Cercle>();
              for (Forme f : formes) {
                if (f.getClass().getSimpleName().equals("Cercle")) {
                  resultat.add( (Cercle) f );
                }
              }
            return resultat;
          }//fin getAllCercles
         
         public void changerDiametreCercle(float diametre , Cercle c) {
           c.D = diametre;
         }//fin changerDiametreCercle
         
         Cercle getCercleById(int id) {
          for (Cercle c : getAllCercles()) {
            if (c.idInStructure == id) {
              return c;
            }
          }
          return null;
        }//fin de la méthode getCercleById()
         
         
         
         
         
       //Pour les convexes
         public void ajouterConvexe(Noeud n1 , Noeud n2) {
           //on ajoute un cercle au noeud si il n'y en a pas
             Cercle c1 = getCercleFromNoeud(n1);
             Cercle c2 = getCercleFromNoeud(n2);
             if (c1 == null) {
               ajouterCercle(n1);
               c1 = getCercleFromNoeud(n1);
             }
             if (c2 == null) {
               ajouterCercle(n2);
               c2 = getCercleFromNoeud(n2);
             }
           //on vérifie qu'un convexe n'a pas déjà été placé pour ces deux cercles (peu importe l'ordre des cercles)
             if ( getConvexeFromCercles(c1,c2) == null) {
               //on peut créer le convexe et l'ajouter à la liste de formes
                 formes.add(new Convexe(page , c1 , c2,getLastFormeId()+1));
             } else {
               println("ERREUR : un convexe a déjà été placé pour ces deux cercles.");
             }
         }//fin ajouterConvexe
         
         public void supprimerConvexe(Convexe c) {
           //on réaffiche les cercles
             c.c1.setAfficherForme(true);
             c.c2.setAfficherForme(true);
           //on supprime les plans liés
              for (Plan p : getPlansFromConvexe(c)) {
                supprimerPlan(p);
              }
           //suppression du convexe dans la liste de formes
             formes.remove(c);
         }//fin supprimerConvexe

         public Convexe getConvexeFromCercles(Cercle c1 , Cercle c2) {
           for (Convexe c : getAllConvexes()) {
             if ( (c.c1 == c1 && c.c2 == c2) || (c.c1 == c2 && c.c2 == c1) ) {
               return c;
             }
           }
           return null;
         }//fin de getConvexeFromCercles
 
         public ArrayList<Convexe> getAllConvexes() {
           ArrayList<Convexe> resultat = new ArrayList<Convexe>();
           for (Forme f : formes) {
             if (f.getClass().getSimpleName().equals("Convexe")) {
               resultat.add( (Convexe) f );
             }
           }
           return resultat;
         }//fin de getAllConvexes
         
         public ArrayList<Convexe> getConvexesFromCercle(Cercle c) {
           ArrayList<Convexe> resultat = new ArrayList<Convexe>();
           for (Convexe cv : getAllConvexes()) {
             if (cv.c1 == c || cv.c2 == c) {
               resultat.add( (Convexe) cv );
             }
           }
           return resultat;
         }
         
         Convexe getConvexeById(int id) {
          for (Convexe c : getAllConvexes()) {
            if (c.idInStructure == id) {
              return c;
            }
          }
          return null;
        }//fin de la méthode getCercleById()
         
         
         
         
       //Pour les plans
         public void ajouterPlan(ArrayList<Noeud> noeuds) {
           //on commence par ajouter les convexes (et donc les cercles) aux couples
           //de cercles qui n'en possèdent pas
             for (int i=0 ; i<noeuds.size()-1 ; i++) {
               ajouterConvexe(noeuds.get(i),noeuds.get(i+1));
             }
             //ajout du convexe de la dernière itération
               ajouterConvexe(noeuds.get(noeuds.size()-1),noeuds.get(0));
           //récup de la liste de cercles
             ArrayList<Cercle> cercles = new ArrayList<Cercle>();
             for (Noeud n : noeuds) {
               cercles.add(getCercleFromNoeud(n));
             }
           //on vérifie qu'un plan n'a pas été placé pour ces cercles (peu importe l'ordre)
             if (getPlanFromCercles(cercles) == null) {
               //on peut ajouter le plan
                 //=> donc récupérer la liste de convexes
                   ArrayList<Convexe> convexes = new ArrayList<Convexe>();
                   for (Cercle c : cercles) {
                     for (Convexe cv : getConvexesFromCercle(c)) {
                       if (!convexes.contains(cv)) {
                         convexes.add(cv);
                       }
                     }
                   }
                 Plan p = new Plan(page,convexes,getLastFormeId()+1);
                 p.cercles = cercles; //pas terrible de faire ça mais permet de garder l'ordre d'affichage pour créer le plan
                  //=> et en plus, ça ne marche pas tout le temps ...
                 formes.add(p);
             } else {
               println("Erreur : un plan a déjà été ajouté pour ces noeuds.");
             }
         }//fin ajouteRPlan
         
         
         
         public void supprimerPlan(Plan p) {
           //on commence par remettre l'affichage des convexes
             for (Convexe cv : p.convexes) {
               cv.setAfficherForme(true);
             }
           //et suppression du plan
             formes.remove(p);
         }//fin supprimerPlan
         
         
         
         public ArrayList<Plan> getAllPlans() {
           ArrayList<Plan> resultat = new ArrayList<Plan>();
             for (Forme f : formes) {
               if (f.getClass().getSimpleName().equals("Plan")) {
                 resultat.add((Plan) f);
               }
             }
           return resultat;
         }//fin getAllPlans
         
         
         
         public Plan getPlanFromCercles(ArrayList<Cercle> cercles) {
           Plan resultat = null;
             for (Plan p : getAllPlans()) {
               boolean condition = true;
               for (Cercle c : cercles) {
                 if (!p.cercles.contains(c)) {
                   condition = false;
                   break;
                 }
                 if (condition) {
                   return p;
                 }
               }
             }
           return resultat;
         }//fin getPlanFromCercles
         
         
         public ArrayList<Plan> getPlansFromCercle(Cercle c) {
           ArrayList<Plan> resultat = new ArrayList<Plan>();
             for (Plan p : getAllPlans()) {
               if (p.cercles.contains(c)) {
                 resultat.add(p);
               }
             }
           return resultat;
         }//fin getPlansFromCercle
         
         
         public ArrayList<Plan> getPlansFromConvexe(Convexe cv) {
           ArrayList<Plan> resultat = new ArrayList<Plan>();
             for (Plan p : getAllPlans()) {
               if (p.convexes.contains(cv)) {
                 resultat.add(p);
               }
             }
           return resultat;
         }//fin getPlansFromConvexe
         
         
         
         
  //ENCAPSULATION
    public void setAfficherNoeuds(boolean afficher) { this.afficherNoeuds = afficher; }
      
  
}