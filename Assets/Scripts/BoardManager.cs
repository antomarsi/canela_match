using System.Collections.Generic;
using System.Collections;
using UnityEngine;
using Pixelplacement;

public class BoardManager : Singleton<Boardmanager> {

    public List<Sprite> pieces = new List<Sprite>();
    public GameObject tile;
    public int xSize;
    public int ySize;

    private GameObject[,] tiles;

    public bool isShifting { get; set; }

    void Start () {
        Vector2 offset = tile.GetComponent<SpriteRenderer>().bounds.size;
        CreateBoard(offset.x, offset.y);
    }

    private void CreateBoard (float xOffset, float yOffset) {
        tiles = new GameObject[xSize, ySize];
        float startX = transform.position.x;
        float startY = transform.position.y;

        for (int x = 0; x < xSize; x++) {
            for (int y = 0; y < ySize; y++) {
                GameObject newTile = Instantiate(tile, new Vector3(
                        startX + (xOffset * x),
                        startY + (yOffset * y),
                        0
                    ),
                    tile.transform.rotation
                );
                tiles[x, y] = newTile;
                newTile.transform.parent = transform;
                Sprite newSprite = pieces[Random.Range(0, pieces.Count)];
                newTile.GetComponent<SpriteRenderer>().sprite = newSprite;
            }
        }
    }
}
