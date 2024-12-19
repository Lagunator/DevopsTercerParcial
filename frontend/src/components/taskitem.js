import React from "react";

function TaskItem({ task, onToggleTask, onDeleteTask }) {
  return (
    <li>
      <span
        style={{
          textDecoration: task.completed ? "line-through" : "none",
        }}
      >
        {task.title}: {task.description}
      </span>
      <button onClick={() => onToggleTask(task.id)}>
        {task.completed ? "Undo" : "Complete"}
      </button>
      <button onClick={() => onDeleteTask(task.id)}>Delete</button>
    </li>
  );
}

export default TaskItem;
