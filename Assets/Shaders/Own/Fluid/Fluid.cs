using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Fluid : MonoBehaviour
{
    Mesh _waterMesh;
    MeshFilter _meshFilter;
    MeshRenderer _meshRend;

    [SerializeField] int    _size = 3;
    [SerializeField] float  _gridReso = 0.1f;
    [SerializeField] Material _material;

    private void Start()
    {
        CreateMesh();
    }

    public void CreateMesh()
    {
        List<Vector3> verts = new List<Vector3>(); // Index used in tri list
        List<int> tris = new List<int>(); // Every 3 ints represents a triangle
        List<Vector2> uvs = new List<Vector2>(); // Vertex in 0-1 UV space
        for (int i = 0; i < _size; i++)
        {
            for (int j = 0; j < _size; j++)
            {
                verts.Add(new Vector3(i, j, 0)); // Add noise function into y
                uvs.Add(new Vector2((float)i / _size, (float)j / _size));
                if (i == 0 || j == 0) continue; // First bottom and left skipped
                tris.Add(_size * i + j); //Top right
                tris.Add(_size * i + (j - 1)); //Bottom right
                tris.Add(_size * (i - 1) + (j - 1)); //Bottom left - First triangle
                tris.Add(_size * (i - 1) + (j - 1)); //Bottom left 
                tris.Add(_size * (i - 1) + j); //Top left
                tris.Add(_size * i + j); //Top right - Second triangle
            }
        }
        Mesh mesh = new Mesh();
        mesh.vertices = verts.ToArray();
        mesh.uv = uvs.ToArray();
        mesh.triangles = tris.ToArray();
        mesh.RecalculateNormals();

        GameObject terrain = new GameObject("Terrain");
        terrain.AddComponent<MeshFilter>();
        terrain.AddComponent<MeshRenderer>();
        terrain.GetComponent<MeshFilter>().mesh = mesh;
        terrain.GetComponent<Renderer>().material = _material;
    }

}