extends Node2D

enum COLOR { PURPLE, BLUE, YELLOW, RED }
enum CELL_TYPE { UNFILED, FILLED, END, ACTOR }

export (CELL_TYPE) var type = CELL_TYPE.END
export (COLOR) var color = COLOR.PURPLE