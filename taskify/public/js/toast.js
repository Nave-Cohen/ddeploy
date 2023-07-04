let $toastContainer = $(".toast-container");

function createToast(id, title) {
  return `<div
  class="toast"
  role="alert"
  aria-live="assertive"
  aria-atomic="true"
  data-bs-animation="true"
>
  <div class="toast-header">
  <i class="toast-icon fa-regular fa-bell"></i>
    <strong class="me-auto">Reminder</strong>
    <small>now</small>
    <button
      type="button"
      class="btn-close"
      data-bs-dismiss="toast"
      aria-label="Close"
    ></button>
  </div>
  <div class="toast-body" 
  onclick="toastClicked(${id},this.parentElement)"
  >${title}</div>
</div>`;
}
function getNow() {
  const now = new Date();
  const tzOffset = now.getTimezoneOffset() * 60000;
  const minDateTimeObj = new Date(now - tzOffset);
  return { time: minDateTimeObj.toISOString().slice(0, 16) };
}
function getClosetTask() {
  $.post(
    "/tasks/now",
    getNow(),
    function (response) {
      if (response.length > 0) {
        toastTask(response);
      }
    },
    "json"
  );
}

function toastTask(response) {
  $toastContainer.empty();
  response.forEach((item, i) => {
    let toast = createToast(item.id, item.title);
    $toastContainer.append(toast);
    // eslint-disable-next-line no-undef
    let toastBootstrap = new bootstrap.Toast($(".toast")[i]);
    toastBootstrap.show();
  });
}

function scrollTo(element) {
  setTimeout(function () {
    element[0].scrollIntoView({
      behavior: "smooth",
    });
  }, 500);
}

// eslint-disable-next-line no-unused-vars
function toastClicked(id, _toastElem) {
  let href = window.location.href.toLowerCase();
  if (!href.includes("today") && !href.includes("upcoming")) {
    $.cookie("scroll", id);
    window.location.href = "/tasks/today";
  } else {
    let collapseItem = $("#collapse-" + id);
    collapseItem.collapse("show");
    scrollTo(collapseItem);
  }
}

getClosetTask();
setInterval(getClosetTask, 1000 * 60);
