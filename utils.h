#define TYPE_OPR 50
#define TYPE_CONST 51
#define TYPE_VAR 52

struct node{
    char* var;
    int type;
    int value;
    int degree;
    node** child;
  };
  typedef struct node node;

  typedef node *arbre;
  
