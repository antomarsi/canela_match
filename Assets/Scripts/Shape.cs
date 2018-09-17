using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Shape : MonoBehaviour
{
    public BonusType bonus;
    public int column;
    public int row;
    public string type;

    void Start() {
        this.bonus = BonusType.None;
    }

    public bool IsSameType(Shape otherShape) {

        return string.Compare(this.type, otherShape.type);
    }

    public static void SwapColumnRow(Shape a, Shape b) {
        int temp = a.row;
        a.row = b.row;
        b.row = temp;

        temp = a.column;
        a.column = b.column;
        b.column = temp;
    }
}
