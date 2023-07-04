/* eslint-disable no-unused-vars */
function doneClicked(taskid) {
  fetch("/tasks/done", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ id: taskid }),
  })
    .then((response) => {
      if (response.ok) {
        $(`.accordion-item-${taskid}`).remove();
        $.cookie("badges", "false");
      } else {
        alert("There was an error when trying to finish a task");
      }
    })
    .catch((error) => {
      alert("Error when trying to POST request");
    });
}

function deleteClicked(taskid) {
  fetch("/tasks/delete", {
    method: "DELETE",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ id: taskid }),
  })
    .then((response) => {
      if (response.ok) {
        $(`.accordion-item-${taskid}`).remove();
        $.cookie("badges", "false");
      } else {
        alert("There was an error when trying to delete");
      }
    })
    .catch((error) => {
      alert("Error when trying to DELETE request");
    });
}
