const express = require("express");
const cors = require("cors");
const app = express();

app.use(cors());
app.use(express.json());

let tasks = []; // Base de datos en memoria

// Ruta para obtener todas las tareas
app.get("/tasks", (req, res) => {
  res.json(tasks);
});

// Ruta para crear una nueva tarea
app.post("/tasks", (req, res) => {
  const { title, description } = req.body;
  const newTask = { id: tasks.length + 1, title, description, completed: false };
  tasks.push(newTask);
  res.status(201).json(newTask);
});

// Ruta para actualizar el estado de una tarea
app.patch("/tasks/:id", (req, res) => {
  const { id } = req.params;
  const task = tasks.find((task) => task.id === parseInt(id));
  if (task) {
    task.completed = !task.completed;
    res.json(task);
  } else {
    res.status(404).send("Task not found");
  }
});

// Ruta para eliminar una tarea
app.delete("/tasks/:id", (req, res) => {
  const { id } = req.params;
  tasks = tasks.filter((task) => task.id !== parseInt(id));
  res.status(204).send();
});

// Iniciar servidor
app.listen(3001, () => {
  console.log("Servidor corriendo en http://localhost:3001");
});
