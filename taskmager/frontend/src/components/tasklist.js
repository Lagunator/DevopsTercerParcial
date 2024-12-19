import React from "react";
import TaskItem from "./taskitem";

function TaskList({ tasks, onToggleTask, onDeleteTask }) {
  return (
    <ul>
      {tasks.map((task) => (
        <TaskItem
          key={task.id}
          task={task}
          onToggleTask={onToggleTask}
          onDeleteTask={onDeleteTask}
        />
      ))}
    </ul>
  );
}

export default TaskList;
