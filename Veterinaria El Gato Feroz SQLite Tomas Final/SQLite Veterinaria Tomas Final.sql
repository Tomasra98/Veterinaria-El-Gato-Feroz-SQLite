-- Creamos la tabla de Mascotas --
CREATE TABLE Mascotas (ID_M INTEGER PRIMARY KEY, Especie text NOT NULL, Nombre text NOT NULL)
-- Creamos la tabla de Veterinarios --
CREATE TABLE Veterinarios (ID_V INTEGER PRIMARY KEY, Nombre text not NULL, Apellido text not NULL)
-- Creamos la tabla de Amos --
CREATE TABLE Amos (ID_A INTEGER PRIMARY key, Nombre TEXT NOT NULL, Apellido TEXT not NULL, Ciudad TEXT NOT NULL, Dirección TEXT not NULL)
-- Creamos la tabla de Citas --
CREATE TABLE Citas (Código INTEGER PRIMARY KEY, Fecha text not NULL, ID_Mascotas INTEGER REFERENCES Mascotas(ID_M), ID_Amos INTEGER REFERENCES Amos(ID_A), ID_Veterinarios INTEGER REFERENCES Veterinarios(ID_V))
-- Metemos o insertamos cada uno de los datos de la tabla Mascotas --
INSERT INTO Mascotas VALUES ("23", "Gato", "Figaro")
-- Mostramos la tabla Mascotas --
SELECT * FROM Mascotas
-- Metemos o insertamos cada uno de los datos de la tabla Amos --
INSERT INTO Amos VALUES ("20", "Isabela", "Velasquez","Medellin","Cr 65 # 19-27")
-- Mostramos la tabla Amos --
SELECT * FROM Amos
-- Metemos o insertamos cada uno de los datos de la tabla Veterinarios --
INSERT INTO Veterinarios VALUES ("20", "Karol", "Lizarazu")
-- Mostramos la tabla Veterinarios --
SELECT * FROM Veterinarios
-- Metemos o insertamos cada uno de los datos de la tabla Citas --
INSERT INTO Citas VALUES ("125", "16/09/2023", "23", "20", "20")
-- Mostramos la tabla Citas --
SELECT * FROM Citas
-- 1. Médico que más citas atiende --
SELECT V.Nombre, COUNT(C.Código) AS NumCitas
FROM Veterinarios V
JOIN Citas C ON V.ID_V = C.ID_Veterinarios
GROUP BY V.ID_V
ORDER BY NumCitas DESC
LIMIT 1;
-- 2. Mascota que más veces ha sido atendida --
SELECT M.Nombre, COUNT(C.Código) AS NumCitas
FROM Mascotas M
JOIN Citas C ON M.ID_M = C.ID_Mascotas
GROUP BY M.ID_M
ORDER BY NumCitas DESC
LIMIT 1;
-- 3. Amos con varias Mascotas --
SELECT ID_Amos, COUNT(*) AS TotalMascotas
FROM Citas
GROUP BY ID_Amos
HAVING TotalMascotas > 1;
-- 4. Promedio de Citas por día --
SELECT COUNT(*) / COUNT(DISTINCT Fecha) AS PromedioCitasPorDia
FROM Citas;
-- 5. Cantidad de Amos registrados en la Ciudad de Medellin --
SELECT COUNT(*) AS CantidadAmosMedellin
FROM Amos
WHERE Ciudad = 'Medellin';
-- 6. Gatos que asistieron a Citas en enero --
SELECT M.Nombre
FROM Mascotas M
JOIN Citas C ON M.ID_M = C.ID_Mascotas
WHERE M.Especie = 'Gato' AND strftime('%m', C.Fecha) = '01';
-- 7. Cantidad de Perros atendidos por un Veterinario específico --
SELECT V.Nombre, COUNT(M.ID_M) AS CantidadPerros
FROM Veterinarios V
JOIN Citas C ON V.ID_V = C.ID_Veterinarios
JOIN Mascotas M ON C.ID_Mascotas = M.ID_M
WHERE M.Especie = 'Perro' AND V.Nombre = 'Alfred'
GROUP BY V.ID_V;
-- 8. Amos que tienen perros y gatos --
SELECT ID_A, A.Nombre, A.Apellido
FROM Amos A
JOIN Mascotas M ON ID_A = ID_M
WHERE M.Especie IN ('Perro', 'Gato')
GROUP BY ID_A, A.Nombre;
-- 9. Listado de Mascotas que no son ni gatos ni perros y sus Amos --
SELECT M.Nombre AS NombreMascota, M.Especie, A.Nombre AS NombreAmo, A.Apellido AS ApellidoAmo
FROM Mascotas M
JOIN Amos A ON M.ID_Amos = A.ID_A
WHERE M.Especie NOT IN ('Gato', 'Perro');
-- 10. Dirección del Amo que más Mascotas llevó a consulta --
SELECT A.Dirección
FROM Amos A
JOIN (
  SELECT ID_Amos, COUNT(ID_Mascotas) AS NumMascotas
  FROM Citas
  GROUP BY ID_Amos
  ORDER BY NumMascotas DESC)
  LIMIT 1
