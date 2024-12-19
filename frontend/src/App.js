import React, { useState, useEffect } from "react";
import axios from "axios";
import TaskList from "./components/tasklist";
import TaskForm from "./components/taskform";

const API_URL = "http://localhost:3001/tasks";

function App() {
  const [tasks, setTasks] = useState([]);

  // Obtener tareas al cargar
  useEffect(() => {
    axios.get(API_URL).then((response) => setTasks(response.data));
  }, []);

  // Agregar una nueva tarea
  const addTask = (newTask) => {
    axios.post(API_URL, newTask).then((response) => {
      setTasks([...tasks, response.data]);
    });
  };

  // Cambiar estado de una tarea
  const toggleTask = (id) => {
    axios.patch(`${API_URL}/${id}`).then((response) => {
      setTasks(tasks.map((task) => (task.id === id ? response.data : task)));
    });
  };

  // Eliminar tarea
  const deleteTask = (id) => {
    axios.delete(`${API_URL}/${id}`).then(() => {
      setTasks(tasks.filter((task) => task.id !== id));
    });
  };

  return (
    <div>
      <h1>Task Manager</h1>
      <TaskForm onAddTask={addTask} />
      <TaskList tasks={tasks} onToggleTask={toggleTask} onDeleteTask={deleteTask} />
    </div>
  );
}

export default App;
