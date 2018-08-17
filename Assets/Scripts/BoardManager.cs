using System.Collections.Generic;
using System.Collections;
using UnityEngine;
using Pixelplacement;

public class BoardManager : MonoBehaviour {

    public List<Sprite> characters = new List<Sprite>();
    public GameObject tile;
    public int xSize;
    public int ySize;

    #region Singleton
    public static BoardManager instance;
    void Awake() {
        instance = this;
    }
    #endregion

    private GameObject[,] tiles;

    public bool IsShifting { get; set; }

    void Start () {
        Vector2 offset = tile.GetComponent<SpriteRenderer>().bounds.size;
        CreateBoard(offset.x, offset.y);
    }

    private void CreateBoard (float xOffset, float yOffset) {
        tiles = new GameObject[xSize, ySize];
        float startX = transform.position.x;
        float startY = transform.position.y;
        
        Sprite[] previousLeft = new Sprite[ySize];
        Sprite previousBelow = null;
        for (int x = 0; x < xSize; x++) {
            for (int y = 0; y < ySize; y++) {
                GameObject newTile = Instantiate(tile, new Vector3(
                        startX + (xOffset * x),
                        startY + (yOffset * y),
                        0
                    ),
                    tile.transform.rotation
                );
                newTile.name ="Tile " + x + "x" + y;
                tiles[x, y] = newTile;
                newTile.transform.parent = transform;

                List<Sprite> possibleCharacters = new List<Sprite>(); // 1
                possibleCharacters.AddRange(characters); // 2

                possibleCharacters.Remove(previousLeft[y]); // 3
                possibleCharacters.Remove(previousBelow);

                Sprite newSprite = possibleCharacters[Random.Range(0, possibleCharacters.Count)];
                newTile.GetComponent<SpriteRenderer>().sprite = newSprite;
                previousLeft[y] = newSprite;
                previousBelow = newSprite;
            }
        }
    }

    public IEnumerator FindNullTiles() {
        for (int x = 0; x < xSize; x++) {
            for (int y = 0; y < ySize; y++) {
                if (tiles[x, y].GetComponent<SpriteRenderer>().sprite == null) {
                    yield return StartCoroutine(ShiftTilesDown(x, y));
                    break;
                }
            }
        }
    }
    private IEnumerator ShiftTilesDown(int x, int yStart, float shiftDelay = .03f) {
        IsShifting = true;
        List<SpriteRenderer>  renders = new List<SpriteRenderer>();
        int nullCount = 0;

        for (int y = yStart; y < ySize; y++) {  // 1
            SpriteRenderer render = tiles[x, y].GetComponent<SpriteRenderer>();
            if (render.sprite == null) { // 2
                nullCount++;
            }
            renders.Add(render);
        }

        for (int i = 0; i < nullCount; i++) { // 3
            yield return new WaitForSeconds(shiftDelay);// 4
            for (int k = 0; k < renders.Count - 1; k++) { // 5
                renders[k].sprite = renders[k + 1].sprite;
                renders[k + 1].sprite = null; // 6
            }
        }
        IsShifting = false;
    }
}
